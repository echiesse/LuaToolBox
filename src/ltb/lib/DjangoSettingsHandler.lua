require 'luno'
luno.useAliases()
luno.functional.exposeAll()
luno.string.exposeSome()

require 'lib.KeyValuePair'

function commentLine(line)
    if lstring.charAt(trim(line), 1) ~= "#" then
        line = string.gsub(line, "(%s*)", "%1#", 1)
    end
    return line
end


function uncommentLine(line)
    if lstring.charAt(trim(line), 1) == "#" then
        line = string.gsub(line, "#", "", 1)
    end
    return line
end


class 'DjangoSettingsHandler'

function DjangoSettingsHandler:init(path)
    assert(path ~= nil and path ~= "", "path deve ser especificado")
    self:load(path)
end


function DjangoSettingsHandler:load(path)
    self.path = path
    local content = lio.getTextFromFile(self.path)
    self.lines = lstring.splitLines(content)
end


function DjangoSettingsHandler:save()
    lio.saveTextToFile(self:show(), self.path)
end


function DjangoSettingsHandler:traverse(dictName, f)
    local ret = {}
    local index = 0
    for i, line in ipairs(self.lines) do
        line = trim(line)
        if lstring.startsWith(line, dictName .. "%s=%s{") then
            index = i
            break
        end
        if i == #self.lines then return nil end
    end

    for i = index, #self.lines do
        local line = self.lines[i]
        if trim(line) == '}' then
            return nil
        end
        local go = f(self.lines, i)
        if not go then break end
    end

    return ret
end


function DjangoSettingsHandler:enableTargetDB(targetDB)
    local ret = false
    self:traverse('DATABASES', function(lines, index)
        local line = lines[index]
        local pair = KeyValuePair(line, ':')
        if pair.value == targetDB then
            lines[index] = uncommentLine(line)
            self:save()
            ret = true
            return false
        end
        return true
    end)

    return ret
end


function DjangoSettingsHandler:disableCurrentDatabase()
    local ret = false
    self:traverse('DATABASES', function (lines, index)
        local line = lines[index]
        local pair = KeyValuePair(line, ':')
        if pair.key == "'default'" then
            lines[index] = commentLine(line)
            ret = true
            return false
        end
        return true
    end)

    return ret
end


function DjangoSettingsHandler:getDictValue(dictName, key)
    local value
    local traverser = function(lines, index)
        local line = lines[index]
        local k, v = unpack(map(trim, lstring.split(line, ':')))
        if k == key then
            value = v
            return false
        end
        return true
    end
    self:traverse(dictName, traverser)

    return value
end


function DjangoSettingsHandler:show()
    return lstring.joinLines(self.lines)
end
