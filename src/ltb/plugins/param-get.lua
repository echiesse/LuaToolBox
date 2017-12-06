require "ltb_lib"

--##############################################################################
local plugin =
{
    exec = function(key)
        print(dotEnv:get(key))
    end,
}


return plugin
