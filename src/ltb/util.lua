require "luno"
luno.useAliases()
--##############################################################################
function sformat(pattern, vars)
    for var, value in pairs(vars) do
        pattern = string.gsub(pattern, "{" .. var .. "}", value)
    end
    return pattern
end


function joinPath(parts)
    local pconfigLines = lstring.splitLines(package.config)
    local dirSep = pconfigLines[1]
    local path = lstring.join(parts, dirSep)
    return path
end


function getPair(kvString)
    return map(trim, split(kvString, "="))
end


function getKey(kvString)
    local kvPair = getPair(kvString)
    return kvPair[1]
end


function getValue(kvString)
    local kvPair = getPair(kvString)
    return kvPair[2]
end


function lineKeyMatches(key, line)
    local k, v = unpack(getPair(line))
    return string.match(k, key) ~= nil
end


function lineValueMatches(value, line)
    local k, v = unpack(getPair(line))
    return string.match(v, value) ~= nil
end


function getAnotatedDB(kvPair)
    local prefix = "  "
    if lstring.charAt(kvPair[1], 1) ~= "#" then
        prefix = "* "
    end
    local ret = prefix .. kvPair[2]
    return ret
end


function commentLine(line)
    if lstring.charAt(trim(line), 1) ~= "#" then
        line = "#" .. line
    end
    return line
end


function uncommentLine(line)
    if lstring.charAt(trim(line), 1) == "#" then
        line = string.gsub(line, "#", "", 1)
    end
    return line
end