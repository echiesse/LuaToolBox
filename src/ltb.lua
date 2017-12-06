require "lfs"
require "luno"
    luno.useAliases()
    luno.functional.exposeAll()
    luno.string.exposeSome()

require "ltb.util"

package.path = package.path .. fixPath(";./ltb/?.lua;./ltb/?/init.lua")

-- Aqui deve-se ler o arquivo de setup:
-- Ex: '.env' no Laravel ou 'settings.py' no django
--dotEnv = DotEnvHelper(info.ENV_FILE)


function tryLoadModule(moduleName, errMessage, errCode)
    errCode = errCode or 1
    local ok, module = pcall(require, moduleName)
    if not ok then
        print(errMessage)
        print(module)
        os.exit(errCode)
    end
    return module
end


function loadTarget(targetName)
    targetName = targetName or config.TARGET_FRAMEWORK
    return tryLoadModule(
        "target." .. targetName,
        "Não foi possivel carregar o target " .. targetName
    )
end


function loadDBAdapter(dbType)
    dbType = dbType or config.DB_TYPE
    return tryLoadModule(
        "db." .. dbType,
        "Não foi possivel carregar o adaptador para o banco " .. dbType
    )
end


function getCommand(commandName)
    local pluginPath = ("plugins.%s"):format(commandName)
    local status, cmd = pcall(require, pluginPath)
    if status == false then
        cmd = nil
    end
    return cmd
end


config = require "config"

function main(...)
    local args = {...}
    local commandName = args[1]

    if commandName == nil then
        print("Nenhuma informação solicitada.")
        os.exit(0)
    end

    local target = loadTarget()
    local db = loadDBAdapter()

    -- Processar a requisição do usuário:
    local command = getCommand(commandName)
    if command ~= nil then
        local args = drop(1, args)
        command.exec(target, db, unpack(args))
    else
        print("Comando nao encontrado: " .. commandName)
        os.exit(1)
    end
end


main(...)
--printDeep(loadTarget("django"))
