
local plugin =
{
    name = "db-save"
}

function plugin.exec(target, db, ...)
    local args = {...}
    local databaseName = target.getDatabaseName()
    local fileName = args[1]
    if #args > 1 then
        databaseName, fileName = unpack(args)
    elseif #args == 0 then
        fileName = databaseName .. "_dump.sql"
    end

    local params = sformat(config.DB_PARAMS, {databaseName = databaseName})
    local saveDbCommand = db.getSaveCommand(params, fileName)
    os.execute('"' .. saveDbCommand .. '"')
    print(("Banco '%s' salvo com sucesso no arquivo '%s'"):format(databaseName, fileName))
end

return plugin
