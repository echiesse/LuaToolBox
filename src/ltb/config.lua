
local config = {
    --TARGET_FRAMEWORK = "laravel",
    TARGET_FRAMEWORK = "django",
    DB_TYPE = "mysql",
    DB_BACKUP_DIR = [[C:\Techiesse\Dev\Clientes\InstitutoPegasus\Codigo\db_backups]],

    laravel =
    {
        ENV_FILE = ".env",
    },

    django =
    {
        DB_NAME = "seya",

    },

    --Database setup
    mysql =
    {
        DUMP_CMD = [["C:\Program Files\MySQL\MySQL Server 5.7\bin\mysqldump"]],
        DB_CMD = [["C:\Program Files\MySQL\MySQL Server 5.7\bin\mysql.exe"]],
        DB_PARAMS = [[--host=127.0.0.1 --protocol=tcp --user=root --password=xxxx --port=3306 --default-character-set=utf8]],
    }
}

return config
