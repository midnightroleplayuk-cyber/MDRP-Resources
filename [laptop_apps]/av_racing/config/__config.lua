--[[
    READ THE DOCS BEFORE USING THE SCRIPT FOR THE FIRST TIME
    https://docs.av-scripts.com/
    https://docs.av-scripts.com/
    https://docs.av-scripts.com/
]]

Config = {}
Config.Debug = false -- Enable debug prints
Config.AdminLevel = {"group.admin", "group.god"} -- Admin level, used for permissions in APP and for admin command, check the docs to customize server/framework/permissions.lua
Config.AdminCommand = "admin:racing" -- Command used to open the admin menu
Config.EventsAfterRestart = true -- If enabled, scheduled events will be saved and restored automatically after a script or server restart
Config.TheUnderground = true -- Enable/Disable The Underground button
Config.NotificationsCommand = "racing:off" -- Command used to disable new events notifications, in case the player doesn't have access to a laptop anymore
Config.TodaysMoneyAccount = "cosmo" -- Money account used for the statistics displayed in the Home tab; the script will detect the daily earnings
Config.App = {
    name = "racing",
    label = "Racing", -- You can rename the app by editing this field
    isEnabled = function(serial)
        return true
    end
}

Config.DefaultProfile = { -- Default profile for new users
    photo = "",
    nationality = "Unknown",
    blip = "violet",  -- don't modify this
    animation = "smoke", -- neds to match an animation from config/animations.lua
}

-- Money accounts available when creating a new event
-- function canUse is triggered client side only
Config.MoneyAccounts = {
    {
        value = "cash", -- account name ("cash" is used in qbcore/qbox, for esx use "money")
        label = "Cash", -- how the player will see it on APP and Discord
        canUse = function()
            return true
        end
    },
    {
        value = "cosmo",
        label = "Cosmo",
        canUse = function()
            return not exports['av_laptop']:isCop() -- cops can't use this account for events
        end
    }
}

-- Only change label field
-- If you don't want X option remove it from the table
Config.PhasingOptions = {
    { value = "10", label = "First 10 seconds" },
    { value = "30", label = "First 30 seconds" },
    { value = "racers", label = "Full Race - Racers Only" },
    { value = "npc", label = "Full Race - Locals Only" },
    { value = "both", label = "Full Race - Racers and Locals"},
    { value = "full", label = "Full Race - All vehicles" },
}

function dbug(...)
    if Config.Debug then print ('^3[DEBUG]^7', ...) end
end

function warn(...)
    print('^1[WARNING]^7', ...)
end