require 'luno'
luno.useAliases()
luno.functional.exposeAll()
luno.string.exposeSome()

class 'KeyValuePair'

function KeyValuePair:init(line, sep)
    self.sep = sep or '='
    self:parse(line)
end

function KeyValuePair:parse(kvString)
    local p = map(trim, split(kvString, self.sep))
    self.key = p[1]
    self.value = p[2]
    return self
end

--[[
function KeyValuePair:getPair(kvString)
    return map(trim, split(kvString, self.sep))
end


function KeyValuePair:getKey(kvString)
    local kvPair = self:getPair(kvString)
    return kvPair[1]
end


function KeyValuePair:getValue(kvString)
    local kvPair = self:getPair(kvString)
    return kvPair[2]
end
]]
