

local db = {}

db.dropTableCmdTemplate =
[[USE %s;
SET FOREIGN_KEY_CHECKS = 0;
DROP TABLE IF EXISTS %s;
SET FOREIGN_KEY_CHECKS = 1;]]


function db.getSaveCommand(databaseName, fileName)
    local params = lstring.joinWords{config.mysql.DB_PARAMS, "--skip-triggers", databaseName}
    return lstring.joinWords{config.mysql.DUMP_CMD, params, "> " .. fileName}
end

function db.listTablesCommand(databaseName)
    local shellCommand = string.format([[echo show tables from %s | %s]], databaseName, db.getShellCommand())
    return shellCommand
end


function db.getShellCommand()
    local shellCommand = lstring.joinWords{config.mysql.DB_CMD, config.mysql.DB_PARAMS,  "--comments"}
    return shellCommand
end


return db
