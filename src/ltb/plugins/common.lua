
local OPTION_MAP =
{
    db = 'databaseName',
    output = 'outputFileName',
}


function getCmdLineArgs(rawArgs)
    --local args = {...}
    local ret = {}
    for i, arg in ipairs(rawArgs) do
        local key, value = unpack(split(arg, '='))
        ret[key] = value
    end

    return ret
end


function processCmdLineOptions(rawArgs)
    local ret = {}
    for i, arg in ipairs(rawArgs) do
        local key, value = unpack(split(arg, '='))
        local option = OPTION_MAP[key]
        if option ~= nil then
            ret[option] = value
        end
    end

    return ret
end
