-- Requires: https://av-scripts.tebex.io/package/6351957
-- Requires: https://av-scripts.tebex.io/package/6351957
-- Requires: https://av-scripts.tebex.io/package/6351957

Config = Config or {}
Config.UsingAVGangs = false -- Set warehouse robbery as mission in av_gangs
Config.GangCooldown = true -- Sets the gang on cooldown to prevent multiple active warehouse for the same gang
Config.GangXP = 10 -- number or false, add XP to player gang after hacking a warehouse

if Config.UsingAVGangs and GetResourceState('av_gangs') == "started" then
    local mission = {
        name = "av_warehouse", -- an identifier
        label = "Warehouse Robbery", -- shown in app as mission title
        price = Config.MissionPrice or 5000, -- number or false
        cops = Config.MinCops or 0, -- min cops online to start mission
        difficulty = 3, -- from 0 to 5
        level = 0, -- min gang level required, make sure it matches the min level from the lowest warehouse
        image = "https://files.fivemerr.com/images/92d92710-7035-41c2-8d3f-344a410a61f8.png",
        description = "Lorem, ipsum dolor sit amet consectetur adipisicing elit. Repudiandae fugiat aspernatur illo enim odio id nam qui ad minus quis.",
        canStart = function(playerId, gang) -- this will be triggered before anything else
            local inCooldown = exports['av_warehouse']:inCooldown(playerId, gang)
            dbug('inCooldown?', inCooldown)
            if inCooldown then
                TriggerClientEvent('av_warehouse:notification',playerId, Lang['title'], Lang['in_cooldown'], 'error')
            end
            return not inCooldown
        end,
        onTrigger = function(playerId, gang) -- This is triggered server side and only available if event = false
            exports['av_warehouse']:startHeist(playerId)
        end,
    }
    exports['av_gangs']:registerMission(mission)
end

function addGangXP(playerId)
    if GetResourceState('av_gangs') == "started" then
        local gang = exports['av_gangs']:getGang(playerId)
        if gang and gang['name'] then
            exports['av_gangs']:addXP(gang['name'],Config.GangXP)
        end
    end
end

exports('inCooldown', function(playerId, gang)
    dbug('inCooldown(playerId,gang?)', playerId, gang)
    local playerIdentifier = exports['av_laptop']:getIdentifier(playerId)
    local playerInCooldown = inCooldown(playerIdentifier)
    if playerInCooldown then return true end
    local gangCooldown = inCooldown(gang)
    if gangCooldown then return true end
    local globalCooldown = inCooldown("global")
    return globalCooldown
end)