
local plugin =
{
    name = "db-restore"
}


function plugin.exec(target, db, databaseName, backupFile)
    
    databaseName = databaseName or target.getDatabaseName()
    if databaseName == nil then
        print("O banco de dados alvo deve ser especificado na linha de comando ou no arquivo de configuração")
        os.exit(0)
    end

    print("Atualizando base de dados '" .. databaseName .. "'")
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
    print("Tabelas apagadas")

    -- Importar Dados:
    backupFile = backupFile or databaseName .. "_dump.sql"
    sqlCommand = sqlShellCommand .. [[ --database=%s < ]] .. backupFile
    sqlCommand = sqlCommand:format(databaseName)
    print("Importando dados do arquivo '" .. backupFile .. "'")
    if(os.execute(sqlCommand) == 0) then
        print("Dados importados com sucesso")
    else
        print("Ocorreu um problema durante a importação de dados")
    end
end


return plugin
