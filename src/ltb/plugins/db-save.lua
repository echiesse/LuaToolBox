require "ltb.plugins.common"

local plugin =
{
    name = "db-save"
}

function plugin.exec(target, db, ...)
    local args = {...}
    local options = processCmdLineOptions(args)

    local databaseName = options.databaseName or target.getDatabaseName()
    local fileName = options.outputFileName or table.concat({config.DB_BACKUP_DIR,  databaseName .. "_dump.sql"}, DIR_SEP)
    local isFastBackup = options.outputFileName == nil

    local saveDbCommand = db.getSaveCommand(databaseName, fileName)
    os.execute('"' .. saveDbCommand .. '"')
    if isFastBackup then
        local tsFileName = table.concat({config.DB_BACKUP_DIR,  databaseName .. "_dump_".. timestamp() .. ".sql" }, DIR_SEP)
        copyFile(fileName, tsFileName)
    end
    print(("Banco '%s' salvo com sucesso no arquivo '%s'"):format(databaseName, fileName))
end

return plugin
