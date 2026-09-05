function Notify(src, text, notifyType)
    if Config.NotificationType == 'mythic' then
        TriggerClientEvent('mythic_notify:client:SendAlert', src, { type = notifyType, text = text})
    elseif Config.NotificationType == 'ox' then
        lib.notify(src, {
            title = _U('notify'),
            description = text,
            type = notifyType
        })
    else
        ShowNotification(src, text, notifyType)
    end
end

function Webhook(message)
    local webhookLink = '' -- place your webhook link here on this line inside the quotes
    if not webhookLink or webhookLink == '' then return end

    local msg = {{title = "**".. _U('webhook_title') .."**", description = message, footer = { text = os.date("%d.%m.%y Time: %X")}}}
    PerformHttpRequest(webhookLink, function(err, text, headers) end, 'POST', json.encode({embeds = msg}), { ['Content-Type'] = 'application/json' })
end

function RegisterSocieties()
    if Config.Framework ~= 'esx' then return end

    local registeredSocieties = {}

    for _,station in pairs(Config.Hospitals) do
        for job in pairs(station.jobs) do
            if not registeredSocieties[job] then
                registeredSocieties[job] = true
                TriggerEvent('esx_society:registerSociety', job, job, 'society_' .. job, 'society_' .. job, 'society_' .. job, {type = 'private'})
            end
        end
    end
end

function RegisterShops()
    for stationId, station in pairs(Config.Hospitals) do
        if type(station.shops) == 'table' then
            for shopId, shop in pairs(station.shops) do
                if Config.Inventory == 'ox' then
                    exports.ox_inventory:RegisterShop('tk_ambulancejob_shop_' .. stationId .. '_' .. shopId, {
                        name = _U('shop'),
                        inventory = shop.items,
                        locations = {
                            shop.coords.xyz
                        },
                        groups = station.jobs
                    })
                elseif Config.Inventory == 'qb_new' then
                    exports['qb-inventory']:CreateShop({
                        name = 'tk_ambulancejob_shop_' .. stationId .. '_' .. shopId,
                        label = _U('shop'),
                        coords = shop.coords,
                        slots = #shop.items,
                        items = shop.items
                    })
                end
            end
        end
    end
end

function RegisterStorage(name, label, storageData, owner, groups)
    if Config.Inventory == 'ox' then
        local slots = storageData.slots or 100
        local weight = storageData.weight or 1000000
        exports.ox_inventory:RegisterStash(name, label, slots, weight, owner, groups)
    end
end

function RegisterStorages()
    for stationId, station in pairs(Config.Hospitals) do
        if type(station.storages) == 'table' then
            for storageId, storage in pairs(station.storages) do
                if Config.Inventory == 'ox' then
                    local storageName = 'tk_ambulancejob_storage_' .. stationId .. '_' .. storageId
                    local owner = storage.type == 'personal' and true or false
                    RegisterStorage(storageName, _U('stash'), storage, owner)
                end
            end
        end
    end
end

---Called when a vehicle is spawned by EMS garage
---@param playerId number the player id
---@param vehicle number the vehicle entity
---@param plate string the vehicle plate
function SpawnedGarageVehicle(playerId, vehicle, plate)
    if GetResourceState('qb-vehiclekeys') == 'started' then
        exports['qb-vehiclekeys']:GiveKeys(playerId, Utils.Trim(plate))
    end
end

---Called when a vehicle is returned to the garage
---@param playerId number the player id
---@param vehicle number the vehicle entity
function VehicleReturned(playerId, vehicle)

end

---Called when a player respawns himself from the death screen
---@param playerId number the player id
---@param location table|nil the nearest Config.Respawn.locations entry
function OnPlayerSelfRespawn(playerId, location)

end

---@class DeathData
---@field coords vector3 the coords where the player died
---@field weapon number the weapon hash, 0 if none
---@field killerServerId number|nil the killer player id, nil if not killed by a player

---Called when a player dies
---@param playerId number the player id
---@param deathData DeathData the death data
function OnPlayerDied(playerId, deathData)

end

RegisterNetEvent('tk_ambulancejob:openShop', function(shopName, shopData)
    local src = source
    if not Utils.IsEMS(src) then return end

    exports['qb-inventory']:OpenShop(src, shopName)
end)

RegisterNetEvent('tk_ambulancejob:openStorage', function(storageName, storageData)
    local src = source
    if not Utils.IsEMS(src) then return end

    exports['qb-inventory']:OpenInventory(src, storageName, {
        label = _U('stash'),
        maxweight = storageData.weight or 1000000,
        slots = storageData.slots or 100,
    })
end)

RegisterNetEvent('tk_ambulancejob:sendBill', function(targetId, amount, reason)
    local src = source
    local xTarget = GetPlayerFromId(targetId)

    local targetPed = GetPlayerPed(targetId)
    local sourcePed = GetPlayerPed(src)

    if #(GetEntityCoords(sourcePed) - GetEntityCoords(targetPed)) > 3.0 then return end

    RemoveAccountMoney(xTarget, 'bank', amount)

    if GetResourceState('Renewed-Banking') == 'started' then
        exports['Renewed-Banking']:addAccountMoney('ambulance', amount, 'Bill')
    else
        exports['qb-banking']:AddMoney('ambulance', amount, 'Bill')
    end

    Notify(targetId, _U('paid_bill', amount), 'success')
    Webhook(_U('webhook_action', Utils.GetIdentifiers(src), 'Pay Bill', json.encode({amount = amount, reason = reason}, {indent = true})))
end)

RegisterNetEvent('tk_ambulancejob:sendDistressSignal', function(coords, street, gender)
    local emsPlayers = JobPlayers.GetJobPlayers()

    for _,playerId in pairs(emsPlayers) do
        TriggerClientEvent('tk_ambulancejob:sendDistressSignal', playerId, coords, street, gender)
    end
end)

RegisterCallback('tk_ambulancejob:registerStorage', function(src, cb, storageName, storageData)
    if not Utils.IsEMS(src) then return end

    if exports.ox_inventory:GetInventory(storageName) then
        cb(true)
        return
    end

    RegisterStorage(storageName, _U('stash'), storageData)
    cb(true)
end)

RegisterNetEvent('tk_ambulancejob:onPlayerLastStand', function()
    local src = source

    if GetResourceState('qb-core') ~= 'started' then return end

    local xPlayer = GetPlayerFromId(src)
    if not xPlayer then return end

    xPlayer.Functions.SetMetaData('isdead', false)
    xPlayer.Functions.SetMetaData('inlaststand', true)
end)

RegisterNetEvent('tk_ambulancejob:onPlayerDeath', function()
    local src = source

    if GetResourceState('qb-core') ~= 'started' then return end

    local xPlayer = GetPlayerFromId(src)
    if not xPlayer then return end

    xPlayer.Functions.SetMetaData('isdead', true)
    xPlayer.Functions.SetMetaData('inlaststand', false)
end)

RegisterNetEvent('tk_ambulancejob:onPlayerRevive', function()
    local src = source

    if GetResourceState('qb-core') ~= 'started' then return end

    local xPlayer = GetPlayerFromId(src)
    if not xPlayer then return end

    xPlayer.Functions.SetMetaData('hunger', 100)
    xPlayer.Functions.SetMetaData('thirst', 100)
    xPlayer.Functions.SetMetaData('stress', 0)
    xPlayer.Functions.SetMetaData('isdead', false)
    xPlayer.Functions.SetMetaData('inlaststand', false)
end)

RegisterCommand('kill', function(source, args, rawCommand)
    local targetId = args[1] and tonumber(args[1]) or source
    exports.tk_ambulancejob:setDeathState(targetId, 2)
end, true)

RegisterCommand('revive', function(src, args)
    ExecuteReviveCommand(src, args)
end, true)