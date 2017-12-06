
local config = {
    --TARGET_FRAMEWORK = "laravel",
    TARGET_FRAMEWORK = "django",
    DB_TYPE = "mysql",
    DB_PARAMS = [[--user=root --password=drhcs --host=127.0.0.1 --protocol=tcp --port=3306 --default-character-set=utf8 --skip-triggers "{databaseName}"]],

    laravel =
    {
        ENV_FILE = ".env",
    },

    django =
    {
        DB_NAME = "seya",
    }
}

return config
