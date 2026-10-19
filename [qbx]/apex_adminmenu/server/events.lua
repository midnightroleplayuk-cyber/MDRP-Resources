Weather = 'EXTRASUNNY'

RegisterNetEvent('apex_adminmenu:skinmenu', function(target)
    if not AdminPerms(source) then return end
    TriggerClientEvent('apex_adminmenu:skinmenu', target)
    
    -- Log the action
    SendDiscordLog(
        "Admin Action: Skin Menu",
        "Admin opened skin menu for a player",
        {
            {name = "Target Player", value = GetPlayerName(target) .. " (ID: " .. target .. ")", inline = true}
        },
        "playerActions"
    )
end)

RegisterNetEvent('apex_adminmenu:revive', function(target)
    if not AdminPerms(source) then return end
    if not ApexRevivePlayer(target) then return end
    
    -- Log the action
    SendDiscordLog(
        "Admin Action: Revive",
        "Admin revived a player",
        {
            {name = "Target Player", value = GetPlayerName(target) .. " (ID: " .. target .. ")", inline = true}
        },
        "playerActions"
    )
end)

RegisterNetEvent('apex_adminmenu:heal', function(target)
    if not AdminPerms(source) then return end
    if not ApexHealPlayer(target) then return end
    
    -- Log the action
    SendDiscordLog(
        "Admin Action: Heal",
        "Admin healed a player",
        {
            {name = "Target Player", value = GetPlayerName(target) .. " (ID: " .. target .. ")", inline = true}
        },
        "playerActions"
    )
end)

RegisterNetEvent('apex_adminmenu:freezePlayer', function(target, state)
    local source = source
    if not AdminPerms(source) then return end
    
    -- Send freeze state to all clients to ensure it works
    TriggerClientEvent('apex_adminmenu:setPlayerFrozen', -1, target, state)
    
    -- Log the action
    SendDiscordLog(
        "Admin Action: " .. (state and "Freeze" or "Unfreeze"),
        "Admin " .. (state and "froze" or "unfroze") .. " a player",
        {
            {name = "Target Player", value = GetPlayerName(target) .. " (ID: " .. target .. ")", inline = true}
        },
        "playerActions"
    )
end)

RegisterNetEvent('apex_adminmenu:playerteleport', function(target, action)
    if not AdminPerms(source) then return end
    
    local sourceCoords = GetEntityCoords(GetPlayerPed(source))
    local targetCoords = GetEntityCoords(GetPlayerPed(target))
    
    if action == 'tpto' then
        SetEntityCoords(GetPlayerPed(source), targetCoords.x, targetCoords.y, targetCoords.z)
        
        -- Log the action
        SendDiscordLog(
            "Admin Action: Teleport",
            "Admin teleported to a player",
            {
                {name = "Target Player", value = GetPlayerName(target) .. " (ID: " .. target .. ")", inline = true}
            },
            "playerActions"
        )
    elseif action == 'bring' then
        SetEntityCoords(GetPlayerPed(target), sourceCoords.x, sourceCoords.y, sourceCoords.z)
        
        -- Log the action
        SendDiscordLog(
            "Admin Action: Bring",
            "Admin brought a player to their location",
            {
                {name = "Target Player", value = GetPlayerName(target) .. " (ID: " .. target .. ")", inline = true}
            },
            "playerActions"
        )
    end
end)

-- ── Spectate ───────────────────────────────────────────────
-- With OneSync a player a few hundred metres away is not in the admin's
-- scope at all: the client has no ped for them, so spectate used to fail
-- with "player not found" for anyone who wasn't already nearby. The
-- server always knows where everyone is, so the client asks here first,
-- parks its hidden ped under the target and only then attaches.
--
-- Also called again mid-spectate when the target teleports out of range.
local spectating    = {} -- [adminSrc] = targetId
local spectateHome  = {} -- [adminSrc] = routing bucket to return to

local function canSpectate(src)
    if AdminPerms(src) then return true end
    return PanelHasPerm ~= nil
        and (PanelHasPerm(src, 'players.spectate') or PanelHasPerm(src, 'players.*'))
end

lib.callback.register('apex_adminmenu:spectateTarget', function(source, target)
    local src = source
    if not canSpectate(src) then return nil end
    target = tonumber(target)
    if not target or target == src or not GetPlayerName(target) then return nil end

    local ped = GetPlayerPed(target)
    if not ped or ped == 0 then return nil end
    local c = GetEntityCoords(ped)

    -- A target in another dimension is invisible from ours. Follow them
    -- in, and remember where we came from so stopping brings us back.
    local targetBucket = GetPlayerRoutingBucket(target)
    local ownBucket    = GetPlayerRoutingBucket(src)
    if targetBucket ~= ownBucket then
        if spectateHome[src] == nil then spectateHome[src] = ownBucket end
        SetPlayerRoutingBucket(src, targetBucket)
    end

    if spectating[src] ~= target then
        spectating[src] = target
        SendDiscordLog(
            "Admin Action: Spectate",
            "Admin started spectating a player",
            {
                {name = "Target Player", value = GetPlayerName(target) .. " (ID: " .. target .. ")", inline = true}
            },
            "playerActions", nil, src
        )
    end

    return { x = c.x, y = c.y, z = c.z, name = GetPlayerName(target) }
end)

RegisterNetEvent('apex_adminmenu:stopSpectating', function(target)
    local src = source
    -- Only ever set by the callback above, after its permission check.
    if spectateHome[src] ~= nil then
        SetPlayerRoutingBucket(src, spectateHome[src])
        spectateHome[src] = nil
    end
    if spectating[src] == nil then return end
    spectating[src] = nil

    target = tonumber(target)
    SendDiscordLog(
        "Admin Action: Stop Spectate",
        "Admin stopped spectating a player",
        {
            -- The target may have left already; GetPlayerName is nil then.
            {name = "Target Player", value = (GetPlayerName(target) or 'Disconnected') .. " (ID: " .. tostring(target) .. ")", inline = true}
        },
        "playerActions", nil, src
    )
end)

AddEventHandler('playerDropped', function()
    spectating[source], spectateHome[source] = nil, nil
end)

RegisterNetEvent('apex_adminmenu:announcement', function(message, job)
    if not AdminPerms(source) then return end
    
    if job and job ~= "" then
        local allPlayers = GetPlayers()
        local players = {}
        
        for i=1, #allPlayers do
            local src = tonumber(allPlayers[i])
            if HasGroup(src, job) then
                players[#players + 1] = src
            end
        end
        
        if #players > 0 then
            for i=1, #players do
                TriggerClientEvent('chat:addMessage', players[i], {
                    color = { 255, 0, 0 },
                    args = { 'Admin Announcement', message }
                })
            end
        end
        
        -- Log the action
        SendDiscordLog(
            "Admin Action: Job Announcement",
            "Admin sent an announcement to a specific job",
            {
                {name = "Job", value = job, inline = true},
                {name = "Message", value = message, inline = false}
            },
            "utilityActions"
        )
    else
        TriggerClientEvent('chat:addMessage', -1, {
            color = { 255, 0, 0 },
            args = { 'Admin Announcement', message }
        })
        
        -- Log the action
        SendDiscordLog(
            "Admin Action: Global Announcement",
            "Admin sent a global announcement",
            {
                {name = "Message", value = message, inline = false}
            },
            "utilityActions"
        )
    end
end)

RegisterNetEvent('apex_adminmenu:setFuel', function(netId)
    if not AdminPerms(source) then return end
    
    local vehicle = NetworkGetEntityFromNetworkId(netId)
    if DoesEntityExist(vehicle) then
        Entity(vehicle).state.fuel = 100
        
        -- Log the action
        SendDiscordLog(
            "Admin Action: Refuel Vehicle",
            "Admin refueled a vehicle",
            {
                {name = "Vehicle", value = "NetID: " .. netId, inline = true}
            },
            "vehicleActions"
        )
    end
end)

RegisterNetEvent('apex_adminmenu:deleteEntity', function(netId)
    if not AdminPerms(source) then return end
    
    local entity = NetworkGetEntityFromNetworkId(netId)
    if DoesEntityExist(entity) then
        DeleteEntity(entity)
        
        -- Log the action
        SendDiscordLog(
            "Admin Action: Delete Entity",
            "Admin deleted an entity",
            {
                {name = "Entity", value = "NetID: " .. netId, inline = true}
            },
            "utilityActions"
        )
    end
end)

RegisterNetEvent('apex_adminmenu:weathersync', function(type)
    if not AdminPerms(source) then return false end
    
    Weather = type
    TriggerClientEvent('apex_adminmenu:weathersync', -1, type)
    TriggerEvent('apex_adminmenu:reqsync')
    TriggerClientEvent('apex_adminmenu:notify', source, Strings.notify_weather, (Strings.notify_weather_desc:format(string.lower(type))), 'success','fa-check')
    
    -- Log the action
    SendDiscordLog(
        "Admin Action: Weather Change",
        "Admin changed the server weather",
        {
            {name = "Weather Type", value = type, inline = true}
        },
        "utilityActions"
    )
end)

RegisterNetEvent('apex_adminmenu:reqsync', function()
    TriggerClientEvent('apex_adminmenu:weathersync', -1, Weather)
end)

-- New events for logging
RegisterNetEvent('apex_adminmenu:logAdminActivity', function(action)
    if not AdminPerms(source) then return end
    
    SendDiscordLog(
        "Admin Menu Activity",
        "Admin " .. action .. " the admin menu",
        {},
        "adminActivity",
        3066993  -- Green color
    )
end)

RegisterNetEvent('apex_adminmenu:logPlayerAction', function(target, actionType, reason, duration)
    if not AdminPerms(source) then return end
    
    local fields = {
        {name = "Target Player", value = GetPlayerName(target) .. " (ID: " .. target .. ")", inline = true},
        {name = "Reason", value = reason or "No reason provided", inline = false}
    }
    
    if duration then
        local durationText = duration
        if duration ~= 'perm' then
            durationText = duration .. " hours"
        else
            durationText = "Permanent"
        end
        table.insert(fields, {name = "Duration", value = durationText, inline = true})
    end
    
    SendDiscordLog(
        "Admin Action: " .. (actionType:gsub("^%l", string.upper)),
        "Admin " .. actionType .. "ed a player",
        fields,
        "playerActions",
        15158332  -- Red color for punishments
    )
end)

RegisterNetEvent('apex_adminmenu:logVehicleAction', function(actionType, model, plate, maxed)
    if not AdminPerms(source) then return end
    
    local fields = {}
    
    if actionType == "spawnVehicle" then
        table.insert(fields, {name = "Vehicle Model", value = model, inline = true})
        if plate then
            table.insert(fields, {name = "License Plate", value = plate, inline = true})
        end
        if maxed then
            table.insert(fields, {name = "Modifications", value = "Maxed out", inline = true})
        end
    elseif actionType == "changePlate" then
        table.insert(fields, {name = "New License Plate", value = model, inline = true})
    end
    
    SendDiscordLog(
        "Admin Action: Vehicle Management",
        "Admin performed a " .. actionType .. " action",
        fields,
        "vehicleActions",
        3447003  -- Blue color
    )
end)

RegisterNetEvent('apex_adminmenu:logMoneyAction', function(target, account, amount)
    if not AdminPerms(source) then return end
    
    SendDiscordLog(
        "Admin Action: Give Money",
        "Admin gave money to a player",
        {
            {name = "Target Player", value = GetPlayerName(target) .. " (ID: " .. target .. ")", inline = true},
            {name = "Account", value = account, inline = true},
            {name = "Amount", value = "$" .. amount, inline = true}
        },
        "moneyActions",
        15844367  -- Gold color for money
    )
end)

RegisterNetEvent('apex_adminmenu:logItemAction', function(target, item, amount)
    if not AdminPerms(source) then return end
    
    SendDiscordLog(
        "Admin Action: Give Item",
        "Admin gave items to a player",
        {
            {name = "Target Player", value = GetPlayerName(target) .. " (ID: " .. target .. ")", inline = true},
            {name = "Item", value = item, inline = true},
            {name = "Amount", value = amount, inline = true}
        },
        "moneyActions",
        10181046  -- Purple color for items
    )
end)

RegisterNetEvent('apex_adminmenu:logUtilityAction', function(actionType, param1, param2)
    if not AdminPerms(source) then return end
    
    local title = "Admin Action: Utility"
    local description = "Admin performed a utility action"
    local fields = {}
    
    if actionType == "announcement" then
        title = "Admin Action: Announcement"
        description = "Admin sent an announcement"
        table.insert(fields, {name = "Message", value = param1, inline = false})
        if param2 and param2 ~= "" then
            table.insert(fields, {name = "Target Job", value = param2, inline = true})
        else
            table.insert(fields, {name = "Target", value = "Global", inline = true})
        end
    elseif actionType == "deleteEntities" then
        title = "Admin Action: Delete Entities"
        description = "Admin deleted entities"
        table.insert(fields, {name = "Entity Type", value = param1, inline = true})
    end
    
    SendDiscordLog(
        title,
        description,
        fields,
        "utilityActions",
        7419530  -- Teal color for utility
    )
end)

AddEventHandler('onResourceStart', function(resourceName)
    if (GetCurrentResourceName() ~= resourceName) then
        return
    end
    
    if GetResourceState('vSync') == 'started' then
        print('^1[Warning] You have vSync started.. this breaks our weather function^0')
    elseif GetResourceState('cd_easytime') == 'started' then
        print('^1[Warning] You have cd_easytime started.. this breaks our weather function^0')
    end
    
    -- Log resource start
    SendDiscordLog(
        "Admin Menu Started",
        "The admin menu resource has been started",
        {},
        "adminActivity",
        3066993  -- Green color
    )
end)
