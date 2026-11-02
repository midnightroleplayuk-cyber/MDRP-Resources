-- DISCORD CONFIG IS INSIDE SERVER/FRAMEWORK/_DISCORD.LUA
-- DISCORD CONFIG IS INSIDE SERVER/FRAMEWORK/_DISCORD.LUA
-- DISCORD CONFIG IS INSIDE SERVER/FRAMEWORK/_DISCORD.LUA
-- READ THE DOCS BEFORE USING THIS SCRIPT: https://docs.av-scripts.com/
Config = {}
Config.Debug = true -- print debug info in console, recommended to keep this on while setting up the script, can be turned off later
Config.CameraDistance = 10.0 -- Distance between player and camera when placing, can be adjusted if you want to allow placing cameras farther away or require them to be closer
Config.AdminGroups = {"group.admin", "group.god"} -- Groups with access to Admin Panel
Config.AdminCommand = "admin:cameras" -- Command to open admin panel
Config.App = {
    name = "cameras",
    label = "CamPro", -- You can rename the app by editing this field
    isEnabled = function(serial)
        return true
    end
}

function dbug(...)
    if Config.Debug then print ('^3[DEBUG]^7', ...) end
end