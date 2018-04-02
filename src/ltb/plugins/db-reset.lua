
local plugin = 
{
    name = "db-reset"
}


function plugin.exec(target, db, databaseName)
    databaseName = databaseName or target.getDatabaseName()
    if databaseName == nil then
        print("O banco de dados alvo deve ser especificado na linha de comando ou no arquivo de configuração")
        os.exit(0)
    end

    print("Reiniciando base de dados '" .. databaseName .. "'")
    local sqlShellCommand = db.getShellCommand()

    -- Obter todas as tabelas do DB:
    local sqlCommand = db.listTablesCommand(databaseName)
    os.execute(sqlCommand .. "> output.out")
    local tables = filter(function(x) return trim(x) ~= "" end, drop(1, lstring.splitLines(lio.getTextFromFile("output.out"))))

    -- Apagar as tabelas obtidas:
    print("Apagando tabelas atuais")
    for i, table in ipairs(tables) do
        local dropCommand = db.dropTableCmdTemplate
        dropCommand = dropCommand:format(databaseName, table)
        local dropCommandFile = "drop.sql"
        lio.saveTextToFile(dropCommand, dropCommandFile)
        os.execute(sqlShellCommand .. " < " .. dropCommandFile .. " > output.out")
        os.remove(dropCommandFile)
    end
    print("Tabelas apagadas com sucesso")

end


return plugin
