require "lib.DotEnvHelper"

local dotEnv = DotEnvHelper(config.laravel.SETTINGS_FILE)

local function commmentDBLine(line)
    local key = getKey(line)
    if key == "DB_DATABASE" then
        line = commentLine(line)
    end
    return line
end


local function uncommentTargetDBLine(targetDB) --<<<<< TODO: Uniformizar
    return function(line)
        local value = getValue(line)
        if value == targetDB then
            line = uncommentLine(line)
        end
        return line
    end
end


local target = {}

function target.getDatabases()
    local dotEnvLines = dotEnv:getLines()

    local dbLines = filter(partial(lineKeyMatches, "DB_DATABASE"), dotEnvLines)
    local pairLines = map(getPair, dbLines)
    local databases = map(compose(DatabaseInfo.fromRawKeyValue, unpack), pairLines)
    return databases
end


function target.getDatabaseName()
    return dotEnv:get("DB_DATABASE")
end


function target.changeDatabase(newDatabaseName)
    local lines = dotEnv:getLines()
    lines = map(compose(uncommentTargetDBLine(newDatabaseName), commmentDBLine), lines)
    dotEnv:setLines(lines)
    return true
end


return target
