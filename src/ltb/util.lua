require "luno"
luno.useAliases()
luno.functional.exposeAll()

--##############################################################################
DIR_SEP = lstring.splitLines(package.config)[1]

function fixPath(path)
    path = string.gsub(path, "[/\\]", DIR_SEP)
    return path
end


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


function getPair(kvString, sep)
    sep = sep or "="
    return map(trim, split(kvString, sep))
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


function timestamp(time)
    if time == nil then
        time = os.time()
    end
    local ret = os.date("%Y%m%d_%H%M%S", time)
    return ret
end


function copyFile(orig, dest)
    inputFile = io.open(orig, "rb")
    outputFile = io.open(dest, "wb")
    outputFile:write(inputFile:read("*a"))
    inputFile:close()
    outputFile:close()
end
