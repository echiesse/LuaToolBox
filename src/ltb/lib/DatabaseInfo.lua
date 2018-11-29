require 'luno'
luno.useAliases()
luno.functional.exposeAll()
luno.string.exposeSome()


class 'DatabaseInfo'

function DatabaseInfo:init(key, value, isActive)
    self.key = key
    self.value = value
    self.isActive = isActive
end


function DatabaseInfo.fromRawKeyValue(key, value)
    return DatabaseInfo(
        string.match(key, "^#?%s*(.+)"),
        value,
        not lstring.startsWith(key, '#')
    )
end
