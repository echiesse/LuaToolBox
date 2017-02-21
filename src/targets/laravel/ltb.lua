require "lfs"
require "luno"
luno.useAliases()
luno.functional.exposeAll()
luno.string.exposeSome()

function fixPath(path)
    local dirSep = splitLines(package.config)[1]
    path = string.gsub(path, "[/\\]", dirSep)
    return path
end

package.path = package.path .. fixPath(";./?/init.lua")
require "ltb_lib"

SRC_DIR = fixPath "../src"
info =
{
    ENV_FILE = joinPath{SRC_DIR, ".env"}
}

dotEnv = DotEnvHelper(info.ENV_FILE)


function getCommand(commandName)
    local pluginPath = ("ltb_lib.plugins.%s"):format(commandName)
    local status, cmd = pcall(require, pluginPath)
    if status == false then
        cmd = nil
    end
    return cmd
end


function main(...)
    local args = {...}
    local commandName = args[1]

    if commandName == nil then
        print("Nenhuma informação solicitada.")
        os.exit(0)
    end

    -- Processar a requisição do usuário:
    local command = getCommand(commandName)
    if command ~= nil then
        local args = drop(1, args)
        command.exec(unpack(args))
    else
        print("Comando nao encontrado: " .. commandName)
        os.exit(1)
    end
end


main(...)
