Config = {}
Config.Debug = true
Config.Target = exports['av_laptop']:getTarget()
Config.MaxLevel = 10 -- Max level for any contact / Every 100 XP = 1 level

Config.App = { -- Read this to know how to restrict an APP: https://docs.av-scripts.com/laptop-pack-v3/laptop-v3/apps-config
    name = "contacts",
    label = "Contacts", -- You can rename the app by editing this field
    isEnabled = function(serial)
        return true
    end
}

-- THE CONTACTS LIST IS AVAILABLE IN SERVER/EDITABLE/_CONFIG.LUA
-- THE CONTACTS LIST IS AVAILABLE IN SERVER/EDITABLE/_CONFIG.LUA
-- THE CONTACTS LIST IS AVAILABLE IN SERVER/EDITABLE/_CONFIG.LUA

function dbug(...)
    if Config.Debug then print ('^3[DEBUG]^7', ...) end
end

function warn(...)
    print('^1[WARNING]^7', ...)
end