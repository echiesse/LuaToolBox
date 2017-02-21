require "ltb_lib"

--##############################################################################
local MY_SQL_CMD = [["C:\Program Files\MySQL\MySQL Server 5.7\bin\mysql.exe"]]

local plugin =
{
    name = "db-restore"
}


function plugin.exec(databaseName, backupFile)
    local params = [[--protocol=tcp --host=127.0.0.1 --user=root --port=3307 --default-character-set=utf8 --comments]]
    local baseSqlCommand = lstring.joinWords{MY_SQL_CMD, params}

    databaseName = databaseName or dotEnv:get("DB_DATABASE")
    backupFile = backupFile or databaseName .. "_dump.sql"

    if databaseName == nil then
        print("O banco de dados alvo deve ser especificado na linha de comando ou no arquivo .env")
        os.exit(0)
    end
    print("Atualizando base de dados '" .. databaseName .. "'")

    -- Obter todas as tabelas do DB:
    local sqlCommand = string.format([[echo show tables from %s | %s]], databaseName, baseSqlCommand)
    os.execute(sqlCommand .. "> output.out")
    local tables = filter(function(x) return trim(x) ~= "" end, drop(1, lstring.splitLines(lio.getTextFromFile("output.out"))))


    -- Apagar as tabelas obtidas:
    print("Apagando tabelas atuais")
    for i, table in ipairs(tables) do
        local dropCommand = require("ltb_lib.dropTableCmdTemplate")
        dropCommand = dropCommand:format(databaseName, table)
        local dropCommandFile = "drop.sql"
        lio.saveTextToFile(dropCommand, dropCommandFile)
        os.execute(baseSqlCommand .. " < " .. dropCommandFile .. " > output.out")
        os.remove(dropCommandFile)
    end
    print("Tabelas apagadas")


    -- Importar Dados:
    sqlCommand = baseSqlCommand .. [[ --database=%s < ]] .. backupFile
    sqlCommand = sqlCommand:format(databaseName)
    print("Importando dados do arquivo '" .. backupFile .. "'")
    if(os.execute(sqlCommand) == 0) then
        print("Dados importados com sucesso")
    else
        print("Ocorreu um problema durante a importação de dados")
    end
end


return plugin
