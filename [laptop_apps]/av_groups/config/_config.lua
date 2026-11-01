Config = {}
Config.Debug = false

function dbug(...)
    if Config.Debug then print ('^3[DEBUG]^7', ...) end
end