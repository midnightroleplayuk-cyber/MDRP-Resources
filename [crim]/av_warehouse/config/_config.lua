--[[
    IF USING QBOX MAKE SURE TO UNCOMMENT THE QBOX IMPORTS IN FXMANIFEST.LUA BEFORE USING THE SCRIPT
    IF USING QBOX MAKE SURE TO UNCOMMENT THE QBOX IMPORTS IN FXMANIFEST.LUA BEFORE USING THE SCRIPT
    IF USING QBOX MAKE SURE TO UNCOMMENT THE QBOX IMPORTS IN FXMANIFEST.LUA BEFORE USING THE SCRIPT
]]--
Config = {}
Config.Debug = false -- Used for debug prints
Config.UseNPC = true -- or false, use NPC to get a warehouse mission
Config.Target = "ox_target" -- "qb-target", "ox_target" or false to use TextUI instead
Config.MinCops = 0 -- Min cops needed to get a warehouse
Config.PoliceJobs = {"police", "bcso", "leo"}-- Job name/type used for cops count and dispatch
Config.MissionPrice = 5000 -- Price to start mission
Config.AccountMoney = "bank" -- Account used to pay for the mission
Config.RemoveItem = false -- Remove the item used to break into a warehouse
Config.Expiration = 60 -- (in minutes) Time before warehouse expires and gets removed
Config.Cooldown = 90 -- (in minutes) player/gang/global cooldown
Config.MaxWarehouses = 10 -- number or false, set the max warehouse robberies active at the same time or false
Config.GlobalCooldown = false -- true/false enable global cooldown
Config.Blip = { -- used for the warehouse blip, NOT the dispatch
    sprite = 473,
    color = 1,
    label = "Warehouse",
}
Config.Dispatch = { -- Blip for dispatch
    sprite = 161,
    label = "Warehouse Alarm",
    timer = 5, -- remove blip after X minutes
}

function dbug(...)
    if Config.Debug then print ('^3[DEBUG]^7', ...) end
end

function warn(...)
    print ('^1[WARNING]^7', ...)
end