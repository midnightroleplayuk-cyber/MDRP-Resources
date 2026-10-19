-- Skip ESX bridge entirely when a QB-family framework is running.
-- Otherwise both bridges would overwrite globals like `GetPlayer`
-- and the script would behave erratically on dual-framework boxes.
if GetResourceState('qb-core')   == 'started' then return end
if GetResourceState('qbx_core')  == 'started' then return end
if GetResourceState('es_extended') ~= 'started' then return end

Framework = 'esx'
ESX = nil

-- The native `GetPlayers` exists on the global scope before this
-- file overrides it. Capture it so our wrappers can safely fall
-- back to the native version when ESX hasn't finished initialising
-- (otherwise every caller crashes with "attempt to index a nil
-- value (global 'ESX')" during the first few hundred ms of boot).
local nativeGetPlayers = GetPlayers

-- Wait for ESX to be initialized
CreateThread(function()
    while ESX == nil do
        local ok, sh = pcall(function() return exports['es_extended']:getSharedObject() end)
        if ok then ESX = sh end
        Wait(0)
    end
end)

GetPlayer = function(source)
    if not ESX then return nil end
    return ESX.GetPlayerFromId(source)
end

GetPlayerFromIdentifier = function(identifier)
    if not ESX then return nil end
    return ESX.GetPlayerFromIdentifier(identifier)
end

-- Safe override: while ESX is still loading we hand back the
-- native FiveM player list so callers never see a nil. Once ESX is
-- ready we proxy to ESX.GetPlayers (which is identical anyway —
-- ESX uses the same native under the hood).
GetPlayers = function()
    if ESX and ESX.GetPlayers then
        local ok, list = pcall(ESX.GetPlayers)
        if ok and list then return list end
    end
    return nativeGetPlayers and nativeGetPlayers() or {}
end

RegisterCallback = function(name, cb)
    if not ESX then
        -- Defer registration until ESX is up.
        CreateThread(function()
            while not ESX do Wait(100) end
            ESX.RegisterServerCallback(name, cb)
        end)
        return
    end
    ESX.RegisterServerCallback(name, cb)
end

KickPlayer = function(source, reason)
    DropPlayer(source, reason)
end

HasPermission = function(source, group)
    local player = GetPlayer(source)
    if not player then return false end
    
    local playerGroup = player.getGroup()
    if playerGroup == group then
        return true
    else
        return false
    end
end

HasGroup = function(source, filter)
    local player = GetPlayer(source)
    if not player then return false end
    
    local type = type(filter)

    if type == 'string' then
        if player.job.name == filter then
            return player.job.name, player.job.grade
        end
    else
        local tabletype = table.type(filter)

        if tabletype == 'hash' then
            local grade = filter[player.job.name]

            if grade and grade <= player.job.grade then
                return player.job.name, player.job.grade
            end
        elseif tabletype == 'array' then
            for i = 1, #filter do
                local group = filter[i]

                if player.job.name == group then
                    return player.job.name, player.job.grade
                end
            end
        end
    end
end

-- ESX checks job + grade against its OWN in-memory table and, when the pair
-- is unknown, quietly does nothing after printing
--   [ESX] [WARNING] Ignoring invalid .setJob() usage for ID: 1, Job: vagos
-- to the console. From the admin's side the job simply never changed and
-- nothing said why. Asking first lets the caller report the real reason.
--
-- ApexEsxJobAccepts lives in server/adminpanel.lua, which loads after this
-- bridge — but this function only ever RUNS long after both are loaded.
SetJob = function(source, job, grade)
    local player = GetPlayer(source)
    if not player then return false, 'Player not loaded' end

    grade = tonumber(grade) or 0
    if ApexEsxJobAccepts then
        local ok, reason = ApexEsxJobAccepts(job, grade)
        if not ok then return false, reason end
    end

    player.setJob(job, grade)
    return true
end

GetIdentifier = function(source)
    local player = GetPlayer(source)
    if not player then return end
    return player.identifier
end

GetName = function(source)
    local player = GetPlayer(source)
    if not player then return end
    return player.getName()
end

HasItem = function(source, item)
    -- Both branches used to be identical (`item?.count or 0`), so the ox
    -- check did nothing: on an ESX server running ox_inventory the count
    -- came from ESX's own inventory table, which ox does not keep in sync.
    if GetResourceState('ox_inventory') == 'started' then
        local ok, count = pcall(function()
            return exports.ox_inventory:GetItemCount(source, item)
        end)
        return (ok and tonumber(count)) or 0
    end

    local player = GetPlayer(source)
    if not player or not player.getInventoryItem then return 0 end
    local found = player.getInventoryItem(item)
    return (found and (found.count or found.amount)) or 0
end

AddItem = function(source, item, count, slot, metadata)
    local player = GetPlayer(source)
    if not player then return false end
    return player.addInventoryItem(item, count, metadata)
end

AddWeapon = function(source, weapon, ammo)
    local player = GetPlayer(source)
    if not player then return false end
    return player.addWeapon(weapon, ammo)
end

RemoveItem = function(source, item, count, slot, metadata)
    local player = GetPlayer(source)
    if not player then return end
    player.removeInventoryItem(item, count, metadata)
end

AddMoney = function(source, type, amount)
    local player = GetPlayer(source)
    if not player then return end
    player.addAccountMoney(type, amount)
end

RemoveMoney = function(source, type, amount)
    local player = GetPlayer(source)
    if not player then return end
    player.removeAccountMoney(type, amount)
end

GetPlayerAccountFunds = function(source, type)
    local player = GetPlayer(source)
    if not player then return 0 end
    return player.getAccount(type).money
end
