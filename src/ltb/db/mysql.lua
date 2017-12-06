

local db = {}

db.dropTableCmdTemplate =
[[USE %s;
SET FOREIGN_KEY_CHECKS = 0;
DROP TABLE IF EXISTS %s;
SET FOREIGN_KEY_CHECKS = 1;]]

function db.getSaveCommand(paramStr, fileName)
    local mysqlDumpCmd = [["C:\Program Files\MySQL\MySQL Server 5.7\bin\mysqldump"]]
    return lstring.joinWords{mysqlDumpCmd, paramStr, "> " .. fileName}
end


return db
