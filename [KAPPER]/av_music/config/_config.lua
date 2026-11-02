-- READ THE DOCS BEFORE USING THIS SCRIPT: https://docs.av-scripts.com/
Config = {}
Config.Debug = false -- enable debug prints
Config.AdminGroups = {"group.admin", "group.god", "group.superadmin"} -- groups that can use admin command
Config.AdminCommand = "admin:music" -- command used to open admin menu
Config.MaxSongsInPlaylist = 30 -- max songs a playlist can have, higher number = playlist will take a little more time to load
Config.MouseKey = 'F6' -- Key used to enable mouse for mini player (every player can change it from keybinds menu)
Config.HeadphonesItem = "headphones" -- Item used to listen music connected to laptop / can't be false
Config.UseAnimation = true -- enable default headphones prop and animation (client/editable/headphones.lua)
Config.StreamerCommand = "streamer" -- used to mute all audio sources, or set to false to toggle streamer mode by export
Config.ZoneDefaultVolume = 0.50 -- default volume for ambient zones (0.0-1.0); can be overridden per-zone with a "volume" field
Config.VehicleRadius = 7.0 -- meters around a vehicle that its music can be heard
Config.LaptopRadius = 3.0 -- meters around a player that their laptop music can be heard
Config.UseVehicles = true -- enable music for vehicles

-- GTA V vehicle classes that cannot use the music app
-- Full list: https://docs.fivem.net/natives/?_0x29439776AAA00A62
Config.VehicleClassBlacklist = {
    [8] = true, -- Motorcycles
    [13] = true, -- Cycles
}

Config.App = {
    name = "music",
    label = "Music", -- You can rename the app by editing this field
    isEnabled = function(serial)
        return true
    end
}

-- Disables the default GTA audio emitters from specific interiors (the background music)
Config.GTAEmitters = {
    "LOS_SANTOS_VANILLA_UNICORN_03_BACK_ROOM", -- Vanilla Unicorn
    "LOS_SANTOS_VANILLA_UNICORN_01_STAGE",  -- Vanilla Unicorn
    "LOS_SANTOS_VANILLA_UNICORN_02_MAIN_ROOM",  -- Vanilla Unicorn
    "collision_9qv4ecm", -- Tequilala
}

-- Key from Config.MiniPlayerPositions to use as the default starting position
Config.MiniPlayerDefaultPosition = "right-mid"
-- x = left offset (% of screen width), y = top offset (% of screen height)
Config.MiniPlayerPositions = {
    ["left-top"] = {x = 1.0, y = 2.0},
    ["left-mid"] = {x = 1.0, y = 46.0},
    ["left-bottom"] = {x = 1.0, y = 91.0},
    ["mid-top"] = {x = 42.0, y = 2.0},
    ["mid"] = {x = 42.0, y = 46.0},
    ["mid-bottom"] = {x = 42.0, y = 91.0},
    ["right-top"] = {x = 85.0, y = 2.0},
    ["right-mid"] = {x = 85.0, y = 46.0},
    ["right-bottom"] = {x = 85.0, y = 91.0},
}

function dbug(...)
    if Config.Debug then print ('^3[DEBUG]^7', ...) end
end