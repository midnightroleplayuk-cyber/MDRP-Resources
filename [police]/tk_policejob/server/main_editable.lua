function Notify(src, text, notifyType)
    if Config.NotificationType == 'mythic' then
        TriggerClientEvent('mythic_notify:client:SendAlert', src, { type = notifyType, text = text})
    elseif Config.NotificationType == 'ox' then
        lib.notify(src, {
            title = 'Notify',
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

    local msg = {{["color"] = Config.WebhookColor, ["title"] = "**".. _U('webhook_title') .."**", ["description"] = message, ["footer"] = { ["text"] = os.date("%d.%m.%y Time: %X")}}}
    PerformHttpRequest(webhookLink, function(err, text, headers) end, 'POST', json.encode({embeds = msg}), { ['Content-Type'] = 'application/json' })
end

function RegisterSocieties()
    if Config.Framework ~= 'esx' then return end

    local registeredSocieties = {}

    for _,station in pairs(Config.PoliceStations) do
        for job in pairs(station.jobs) do
            if not registeredSocieties[job] then
                registeredSocieties[job] = true
                TriggerEvent('esx_society:registerSociety', job, job, 'society_' .. job, 'society_' .. job, 'society_' .. job, {type = 'private'})
            end
        end
    end
end

function RegisterShops()
    for stationId, station in pairs(Config.PoliceStations) do
        if type(station.shops) == 'table' then
            for shopId, shop in pairs(station.shops) do
                if Config.Inventory == 'ox' then
                    exports.ox_inventory:RegisterShop('tk_policejob_shop_' .. stationId .. '_' .. shopId, {
                        name = _U('shop'),
                        inventory = shop.items,
                        locations = {
                            shop.coords.xyz
                        },
                        groups = station.jobs
                    })
                elseif Config.Inventory == 'qb_new' then
                    exports['qb-inventory']:CreateShop({
                        name = 'tk_policejob_shop_' .. stationId .. '_' .. shopId,
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

function RegisterStorages()
    for stationId, station in pairs(Config.PoliceStations) do
        if type(station.storages) == 'table' then
            for storageId, storage in pairs(station.storages) do
                if Config.Inventory == 'ox' then
                    local storageName = 'tk_policejob_storage_' .. stationId .. '_' .. storageId
                    local slots = storage.slots or 100
                    local weight = storage.weight or 1000000
                    local owner = storage.type == 'personal' and true or false
                    exports.ox_inventory:RegisterStash(storageName, _U('stash'), slots, weight, owner)
                end
            end
        end
    end
end

---@class FineData
---@field id string
---@field speed number
---@field limit number
---@field coords vector3

---Handles paying a fine for speeding on a speed camera
---@param src number
---@param fineData FineData
function PaySpeedCameraFine(src, fineData)
    local amount = math.floor((fineData.speed - fineData.limit) * 10)
    local xPlayer = GetPlayerFromId(src)
    RemoveAccountMoney(xPlayer, 'bank', amount)
    Notify(src, _U('paid_speed_camera_fine', amount), 'success')

    Webhook(_U('webhook_action', Utils.GetIdentifiers(src), 'Pay Speed Camera Fine', json.encode(fineData, {indent = true})))
end

function SetVehicleStored(garage, stored, plate)
    if Config.Framework == 'esx' then
        local result = MySQL.Sync.fetchAll('SHOW COLUMNS FROM owned_vehicles LIKE "garage"')
        if #result > 0 then
            MySQL.Sync.execute('UPDATE owned_vehicles SET garage = ?, stored = ? WHERE plate = ?', {garage, stored, plate})
        else
            MySQL.Sync.execute('UPDATE owned_vehicles SET parking = ?, stored = ? WHERE plate = ?', {garage, stored, plate})
        end
    elseif Config.Framework == 'qb' then
        local result = MySQL.Sync.fetchAll('SHOW COLUMNS FROM player_vehicles LIKE "garage"')
        if #result > 0 then
            MySQL.Sync.execute('UPDATE player_vehicles SET garage = ?, state = ? WHERE plate = ?', {garage, stored, plate})
        else
            MySQL.Sync.execute('UPDATE player_vehicles SET parking = ?, state = ? WHERE plate = ?', {garage, stored, plate})
        end
    end
end

local function Trim(str)
    return str:gsub('^%s*(.-)%s*$', '%1')
end

function GetVehicleOwner(plate)
    plate = Trim(plate)

    if Config.Framework == 'esx' then
        local owner = MySQL.Sync.fetchScalar('SELECT owner FROM owned_vehicles WHERE plate = ?', {plate})
        return owner
    elseif Config.Framework == 'qb' then
        local owner = MySQL.Sync.fetchScalar('SELECT citizenid FROM player_vehicles WHERE plate = ?', {plate})
        return owner
    end
end

function GetVehicleOwnerName(plate)
    if Config.Framework == 'esx' then
        local result = MySQL.Sync.fetchAll('SELECT owner, firstname, lastname FROM owned_vehicles INNER JOIN users ON owned_vehicles.owner = users.identifier WHERE plate = ?', {plate})
        if not result?[1] then return end

        return ('%s %s'):format(result?[1]?.firstname, result?[1]?.lastname)
    elseif Config.Framework == 'qb' then
        local result = MySQL.Sync.fetchAll('SELECT charinfo FROM player_vehicles INNER JOIN players ON player_vehicles.citizenid = players.citizenid WHERE plate = ?', {plate})
        if not result?[1] then return end

        local charinfo = json.decode(result?[1]?.charinfo)
        return ('%s %s'):format(charinfo?.firstname, charinfo?.lastname)
    end
end

function GetVehicle(plate)
    if Config.Framework == 'esx' then
        local result = MySQL.Sync.fetchScalar('SELECT vehicle FROM owned_vehicles WHERE plate = ?', {plate})
        if not result then return {} end
        return json.decode(result)
    elseif Config.Framework == 'qb' then
        local result = MySQL.Sync.fetchAll('SELECT mods, vehicle FROM player_vehicles WHERE plate = ?', {plate})
        if not result?[1] then return {} end
        local mods = json.decode(result?[1]?.mods)
        mods.model = result?[1]?.vehicle
        return mods
    end
end

---@param vehicle number the vehicle entity
---@return boolean isPoliceVehicle whether the vehicle is a police vehicle
function IsPoliceVehicle(vehicle)
    return Entity(vehicle).state.isPoliceVehicle
end

---Called when a vehicle is spawned by police garage
---@param playerId number the player id
---@param vehicle number the vehicle entity
---@param plate string the vehicle plate
function SpawnedGarageVehicle(playerId, vehicle, plate)
    if GetResourceState('qb-vehiclekeys') == 'started' then
        exports['qb-vehiclekeys']:GiveKeys(playerId, plate)
    end
    if GetResourceState('qbx_vehiclekeys') == 'started' and vehicle and DoesEntityExist(vehicle) then
        exports.qbx_vehiclekeys:GiveKeys(playerId, vehicle)
    end
end

---Called when a vehicle is spawned by police impound
---@param playerId number the player id
---@param vehicle number the vehicle entity
---@param plate string the vehicle plate
function SpawnedImpoundVehicle(playerId, vehicle, plate)
    if GetResourceState('qb-vehiclekeys') == 'started' then
        exports['qb-vehiclekeys']:GiveKeys(playerId, Trim(plate))
    end
    if GetResourceState('qbx_vehiclekeys') == 'started' and vehicle and DoesEntityExist(vehicle) then
        exports.qbx_vehiclekeys:GiveKeys(playerId, vehicle)
    end
end

---Called when a vehicle is returned to the garage
---@param playerId number the player id
---@param vehicle number the vehicle entity
function VehicleReturned(playerId, vehicle)

end

function ShowFingerprintResult(playerId, officerId)
    local xPlayer = GetPlayerFromId(playerId)
    if not xPlayer then return end

    local identifier = GetIdentifier(xPlayer)
    local name = GetCharName(identifier)

    Notify(officerId, _U('fingerprint_result', name), 'success')
end

RegisterNetEvent('tk_policejob:openShop', function(shopName, shopData)
    local src = source
    if not Utils.IsPolice(src) then return end

    exports['qb-inventory']:OpenShop(src, shopName)
end)

RegisterNetEvent('tk_policejob:openStorage', function(storageName, storageData)
    local src = source
    if not Utils.IsPolice(src) then return end

    exports['qb-inventory']:OpenInventory(src, storageName, {
        label = _U('stash'),
        maxweight = storageData.weight or 1000000,
        slots = storageData.slots or 100,
    })
end)

RegisterNetEvent('tk_policejob:searchPlayer', function(targetId)
    local src = source
    if not Utils.IsPolice(src) then return end

    local xTarget = GetPlayerFromId(targetId)
    if not xTarget then
        return
    end

    local playerPed = GetPlayerPed(src)
    local targetPed = GetPlayerPed(targetId)

    local distance = #(GetEntityCoords(playerPed) - GetEntityCoords(targetPed))
    if distance > 3.0 then
        return
    end

    exports['qb-inventory']:OpenInventoryById(src, targetId)
end)

RegisterNetEvent('tk_policejob:sendBill', function(targetId, amount, reason)
    local src = source
    local xTarget = GetPlayerFromId(targetId)

    local targetPed = GetPlayerPed(targetId)
    local sourcePed = GetPlayerPed(src)

    if #(GetEntityCoords(sourcePed) - GetEntityCoords(targetPed)) > 3.0 then return end

    RemoveAccountMoney(xTarget, 'bank', amount)
    exports['qb-banking']:AddMoney('police', amount, 'Fine')

    Notify(targetId, _U('paid_fine', amount), 'success')
    Webhook(_U('webhook_action', Utils.GetIdentifiers(src), 'Pay Fine', json.encode({amount = amount, reason = reason}, {indent = true})))
end)

RegisterCallback('tk_policejob:registerStorage', function(src, cb, storageName, storageData)
    if not Utils.IsPolice(src) then return end

    if exports.ox_inventory:GetInventory(storageName) then
        cb(true)
        return
    end

    local slots = storageData.slots or 100
    local weight = storageData.weight or 1000000
    exports.ox_inventory:RegisterStash(storageName, _U('stash'), slots, weight)
    cb(true)
end)

RegisterCommand('cuff', function(source, args, rawCommand)
	CuffCommand(source, args, rawCommand)
end, true)

RegisterCommand('uncuff', function(source, args, rawCommand)
	UncuffCommand(source, args, rawCommand)
end, true)