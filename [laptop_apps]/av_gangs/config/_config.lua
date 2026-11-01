Config = {}
Config.Debug = true
Config.AdminLevel = {"group.admin", "group.god"} -- Admin rank needed to open admin menu
Config.AdminCommand = "admin:gangs" -- Admin menu command
Config.GraffitiXP = false -- Read the docs for this, only for ppl who was using av_gangs before Sept 09
Config.PurityField = "purity" -- Metadata field name for drugs produced in labs
Config.Target = exports['av_laptop']:getTarget()
Config.DailyLimitXP = 50 -- Max XP a gang can receive per server restart
Config.LevelXP = 100 -- Needed XP points per level
Config.UseGangNPC = true -- If set to true, local NPCs inside a gang territory will spawn as gang members; if false, default NPC models will remain.
Config.InteractionPrefix = "[E]" -- Prefix used for interactions in properties (door, stashes, ingredients, etc)
Config.InteractionKey = 38 -- Key used for interaction with zones like doors, stashes, etc
Config.PropertyInZone = false -- Properties should be inside gang territory, otherwise door will be blocked untill gang recovers territory control
Config.DisableGraffitis = false -- true/false disable the graffitis system, in case you don't want to use it
Config.App = {
    name = "gang",
    label = "Gangs", -- You can rename the app by editing this field
    isEnabled = function(serial)
        return exports['av_gangs']:getGang() -- app is only enabled if player is a gang member
    end
}

function dbug(...)
    if Config.Debug then print ('^3[DEBUG]^7', ...) end
end

function warn(...)
    print ('^1[WARNING]^7', ...)
end