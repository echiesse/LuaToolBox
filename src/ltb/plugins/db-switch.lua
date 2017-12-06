require "ltb_lib"

function commmentDBLine(line)
    local key = getKey(line)
    if key == "DB_DATABASE" then
        line = commentLine(line)
    end
    return line
end


function uncommentTargetDBLine(targetDB)
    return function(line)
        local value = getValue(line)
        if value == targetDB then
            line = uncommentLine(line)
        end
        return line
    end
end

--##############################################################################
local plugin = {}


function plugin.exec(targetDB)
    local lines = dotEnv:getLines()

    lines = map(compose(uncommentTargetDBLine(targetDB), commmentDBLine), lines)

    dotEnv:setLines(lines)
end

return plugin
