
local plugin = {}

function plugin.exec(target, db, ...)
    local databases = target.getDatabases()
    if databases == nil or ltable.isEmpty(databases) then
        print("Nenhum banco de dados encontrado")
    else
        map(print, databases)
    end
end

return plugin
