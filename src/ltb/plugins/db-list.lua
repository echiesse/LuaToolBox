
local plugin = {}

local function showDatabase(dbInfo)
    local value = dbInfo.value
    local prefix = "  "
    if dbInfo.isActive then
        prefix = "* "
    end

    return prefix .. value
end

function plugin.exec(target, db, ...)
    local databases = target.getDatabases()
    if databases == nil or ltable.isEmpty(databases) then
        print("Nenhum banco de dados encontrado")
    else
        map(print, map(showDatabase, databases))
    end
end

return plugin
