local plugin = {}


function plugin.exec(target, db, newDatabaseName)
    local ok = target.changeDatabase(newDatabaseName)
    if not ok then
        print(string.format("Banco nao encontrado: %s", newDatabaseName))
    end
end

return plugin
