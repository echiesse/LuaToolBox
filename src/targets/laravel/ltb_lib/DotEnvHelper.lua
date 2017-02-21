require "luno"

class "DotEnvHelper"

function DotEnvHelper.init(self, dotEnvFilePath)
    assert(dotEnvFilePath ~= nil and dotEnvFilePath ~= "", "O arquivo .env deve ser especificado")
    self.dotEnvFilePath = dotEnvFilePath
    self:readFile()
end


function DotEnvHelper.readFile(self)
    local dotEnvContents = lio.getTextFromFile(self.dotEnvFilePath)

    self.dotEnvLines = lstring.splitLines(dotEnvContents)
    self:buildDotEnvTable()

end


function DotEnvHelper.buildDotEnvTable(self)
    self.dotEnvTable = {}
    for i, line in ipairs(self.dotEnvLines) do
        line = trim(line)
        if line ~= "" and charAt(line, 1) ~= "#" then
            local kvPair = map(trim, split(line, "="))
            local key = kvPair[1]
            local value = kvPair[2]
            self.dotEnvTable[key] = value
        end
    end
end


function DotEnvHelper.getLines(self)
    return self.dotEnvLines
end


function DotEnvHelper.setLines(self, lines)
    self.dotEnvLines = lines
    self:buildDotEnvTable()
    local dotEnvContents = lstring.joinLines(self.dotEnvLines)
    lio.saveTextToFile(dotEnvContents, self.dotEnvFilePath)
    return self
end


function DotEnvHelper.get(self, key)
    return self.dotEnvTable[key]
end
