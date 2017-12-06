require "ltb_lib"

--##############################################################################
local mysqlDumpCmd = [["C:\Program Files\MySQL\MySQL Server 5.7\bin\mysqldump"]]
local params = [[--user=root --host=127.0.0.1 --protocol=tcp --port=3307 --default-character-set=utf8 --skip-triggers "{databaseName}"]]


local plugin =
{
    name = "db-save"
}


function plugin.exec(...)
    local args = {...}
    local databaseName = dotEnv:get("DB_DATABASE")
    local fileName = args[1]
    if #args > 1 then
        databaseName, fileName = unpack(args)
    elseif #args == 0 then
        fileName = databaseName .. "_dump.sql"
    end

    local params = sformat(params, {databaseName = databaseName})
    local saveDbCommand = lstring.joinWords{mysqlDumpCmd, params, "> " .. fileName}
    os.execute('"' .. saveDbCommand .. '"')
    print(("Banco '%s' salvo com sucesso no arquivo '%s'"):format(databaseName, fileName))
end

return plugin
