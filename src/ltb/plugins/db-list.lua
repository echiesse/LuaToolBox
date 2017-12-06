require "ltb_lib"

--##############################################################################
local plugin = {}


function plugin.exec(...)
    local dotEnvLines = dotEnv:getLines()

    local dbLines = filter(partial(lineKeyMatches, "DB_DATABASE"), dotEnvLines)
    dbLines = map(compose(getAnotatedDB, getPair), dbLines)

    map(print, dbLines)
end

return plugin
