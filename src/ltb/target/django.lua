require 'lib.DjangoSettingsHandler'

settings = DjangoSettingsHandler(config.django.SETTINGS_FILE)


local target =
{
    name = "django"
}

function target.getDatabases()
    --return {"* seya"}
    local database = settings:getDictValue('DATABASES', "'default'")
    return {database}
end


function target.getDatabaseName()
    local database = settings:getDictValue('DATABASES', "'default'")
    return database
end


function target.changeDatabase(newDatabaseName)
    settings:disableCurrentDatabase()
    return settings:enableTargetDB(newDatabaseName)
end


return target
