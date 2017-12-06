require "DotEnvHelper"

local dotEnv = DotEnvHelper(config.laravel.ENV_FILE)

local target = {}

function target.getDatabases()
    local dotEnvLines = dotEnv:getLines()

    local dbLines = filter(partial(lineKeyMatches, "DB_DATABASE"), dotEnvLines)
    dbLines = map(compose(getAnotatedDB, getPair), dbLines)

    return dbLines
end


function target.getDatabaseName()
    return dotEnv:get("DB_DATABASE")
end

return target
