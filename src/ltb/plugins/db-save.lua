
local plugin =
{
    name = "db-save"
}

function plugin.exec(target, db, ...)
    local args = {...}
    local databaseName = target.getDatabaseName()
    local fileName = args[1]
    local isFastBackup = false
    if #args > 1 then
        databaseName, fileName = unpack(args)
    elseif #args == 0 then
        fileName = table.concat({config.DB_BACKUP_DIR,  databaseName .. "_dump.sql"}, DIR_SEP)
        isFastBackup = true
    end

    local saveDbCommand = db.getSaveCommand(databaseName, fileName)
    os.execute('"' .. saveDbCommand .. '"')
    if isFastBackup then
        local tsFileName = table.concat({config.DB_BACKUP_DIR,  databaseName .. "_dump_".. timestamp() .. ".sql" }, DIR_SEP)
        copyFile(fileName, tsFileName)
    end
    print(("Banco '%s' salvo com sucesso no arquivo '%s'"):format(databaseName, fileName))
end

return plugin
