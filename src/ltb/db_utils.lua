require"luno"
luno.useAliases()
luno.string.exposeSome()


MY_SQL_CMD = [["C:\Program Files\MySQL\MySQL Server 5.7\bin\mysql.exe"]]

local BKP_PREFIX = "dump_"


function dbBackupName(dbName)
    return BKP_PREFIX .. dbName .. ".sql"
end
