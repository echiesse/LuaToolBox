local dbReset = require "ltb.plugins.db-reset"

local plugin =
{
    name = "db-restore"
}


function plugin.exec(target, db, databaseName, backupFile)

    dbReset.exec(target, db, databaseName)

    -- Importar Dados:
    backupFile = backupFile or table.concat({config.DB_BACKUP_DIR,  databaseName .. "_dump.sql"}, DIR_SEP)
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
