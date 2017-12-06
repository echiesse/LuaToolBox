require "ltb_lib"

--##############################################################################


local plugin = {}


function plugin.exec(databaseName, backupFile)
    local params = [[--protocol=tcp --host=127.0.0.1 --user=root --port=3307 --default-character-set=utf8 --comments]]
    local baseSqlCommand = lstring.joinWords{MY_SQL_CMD, params}

    databaseName = databaseName or dotEnv:get("DB_DATABASE")
    backupFile = backupFile or dbBackupName(databaseName)

    if databaseName == nil then
        print("O banco de dados alvo deve ser especificado na linha de comando ou no arquivo .env")
        os.exit(0)
    end
    print("Apagando tabelas da base de dados '" .. databaseName .. "'")

    -- Obter todas as tabelas do DB:
    local sqlCommand = string.format([[echo show tables from %s | %s]], databaseName, baseSqlCommand)
    os.execute(sqlCommand .. "> output.out")
    local tables = filter(function(x) return trim(x) ~= "" end, drop(1, lstring.splitLines(lio.getTextFromFile("output.out"))))


    -- Apagar as tabelas obtidas:
    print("Apagando tabelas atuais")
    for i, table in ipairs(tables) do
        local dropCommand = require("psetup_lib.dropTableCmdTemplate")
        dropCommand = dropCommand:format(databaseName, table)
        local dropCommandFile = "drop.sql"
        lio.saveTextToFile(dropCommand, dropCommandFile)
        os.execute(baseSqlCommand .. " < " .. dropCommandFile .. " > output.out")
        os.remove(dropCommandFile)
        print("Apagada tabela: " .. table)
    end
    print("")
    print("Tabelas apagadas com sucesso")

end


return plugin
