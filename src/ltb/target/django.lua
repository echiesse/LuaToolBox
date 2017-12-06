
local target =
{
    name = "django"
}

function target.getDatabases()
    return {"* seya"}
end

function target.getDatabaseName()
    return config.django.DB_NAME
end


return target
