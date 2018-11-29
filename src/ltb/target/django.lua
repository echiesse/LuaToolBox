require 'lib.DjangoSettingsHandler'

settings = DjangoSettingsHandler(config.django.SETTINGS_FILE)


local target =
{
    name = "django"
}


function target.getDatabases()
    local databases = settings:parseDict('DATABASES')
    return databases
end


function target.getDatabaseName()
    local dbVarName = settings:getDictValue('DATABASES', 'default')
    local database = middle(settings:getDictValue(dbVarName, 'NAME'))
    return database
end


function target.changeDatabase(newDatabaseName)
    settings:disableCurrentDatabase()
    return settings:enableTargetDB(newDatabaseName)
end


return target
