Bridge = Bridge or {}
Bridge.Keys = Bridge.Keys or {}

local function cleanPlate(plate)
    return string.gsub(plate or '', '^%s*(.-)%s*$', '%1')
end

local function resourceStarted(resource)
    return GetResourceState(resource) == 'started'
end

local function try(handler)
    local ok = pcall(handler)
    return ok
end

local function vehicleNetId(vehicle)
    if not vehicle or vehicle == 0 then return nil end
    if not DoesEntityExist(vehicle) then return nil end

    if not NetworkGetEntityIsNetworked(vehicle) then
        NetworkRegisterEntityAsNetworked(vehicle)
    end

    local netId = VehToNet(vehicle)
    local attempts = 0

    while DoesEntityExist(vehicle) and (not netId or netId == 0) and attempts < 20 do
        Wait(50)
        netId = VehToNet(vehicle)
        attempts = attempts + 1
    end

    if netId and netId ~= 0 and DoesEntityExist(vehicle) then
        SetNetworkIdCanMigrate(netId, true)
        SetNetworkIdExistsOnAllMachines(netId, true)
    end

    return netId
end

local keySystems = {
    {
        name = 'qb-vehiclekeys',
        give = function(vehicle, plate, model)
            if not resourceStarted('qb-vehiclekeys') then return false end
            return try(function()
                TriggerServerEvent('qb-vehiclekeys:server:AcquireVehicleKeys', plate)
                TriggerEvent('vehiclekeys:client:SetOwner', plate)
            end)
        end,
        remove = function(vehicle, plate)
            if not resourceStarted('qb-vehiclekeys') then return false end
            return try(function()
                TriggerServerEvent('qb-vehiclekeys:server:RemoveVehicleKeys', plate)
            end)
        end
    },
    {
        name = 'qbx_vehiclekeys',
        give = function(vehicle, plate)
            if not resourceStarted('qbx_vehiclekeys') then return false end
            return try(function()
                TriggerServerEvent('tn_carrental:keys:give', 'qbx_vehiclekeys', vehicleNetId(vehicle), plate)
            end)
        end,
        remove = function(vehicle, plate)
            if not resourceStarted('qbx_vehiclekeys') then return false end
            return try(function()
                TriggerServerEvent('tn_carrental:keys:remove', 'qbx_vehiclekeys', vehicleNetId(vehicle), plate)
            end)
        end
    },
    {
        name = 'qs-vehiclekeys',
        give = function(vehicle, plate, model)
            if not resourceStarted('qs-vehiclekeys') then return false end
            return try(function()
                local displayName = GetDisplayNameFromVehicleModel(GetEntityModel(vehicle))
                exports['qs-vehiclekeys']:GiveKeys(plate, displayName or model, true)
            end)
        end,
        remove = function(vehicle, plate, model)
            if not resourceStarted('qs-vehiclekeys') then return false end
            return try(function()
                local displayName = vehicle and vehicle ~= 0 and GetDisplayNameFromVehicleModel(GetEntityModel(vehicle)) or model
                exports['qs-vehiclekeys']:RemoveKeys(plate, displayName)
            end)
        end
    },
    {
        name = 'cd_garage',
        give = function(vehicle, plate)
            if not resourceStarted('cd_garage') then return false end
            return try(function()
                local cdPlate = exports['cd_garage']:GetPlate(vehicle) or plate
                TriggerEvent('cd_garage:AddKeys', cdPlate)
            end)
        end,
        remove = function(vehicle, plate)
            if not resourceStarted('cd_garage') then return false end
            return try(function()
                local cdPlate = vehicle and vehicle ~= 0 and exports['cd_garage']:GetPlate(vehicle) or plate
                TriggerEvent('cd_garage:RemoveKeys', cdPlate)
            end)
        end
    },
    {
        name = 'wasabi_carlock',
        give = function(vehicle, plate)
            if not resourceStarted('wasabi_carlock') then return false end
            return try(function()
                exports.wasabi_carlock:GiveKey(plate)
                TriggerServerEvent('tn_carrental:keys:give', 'wasabi_carlock', vehicleNetId(vehicle), plate)
            end)
        end,
        remove = function(vehicle, plate)
            if not resourceStarted('wasabi_carlock') then return false end
            return try(function()
                exports.wasabi_carlock:RemoveKey(plate)
                TriggerServerEvent('tn_carrental:keys:remove', 'wasabi_carlock', vehicleNetId(vehicle), plate)
            end)
        end
    },
    {
        name = 'Renewed-Vehiclekeys',
        give = function(vehicle, plate)
            if not resourceStarted('Renewed-Vehiclekeys') then return false end
            return try(function()
                exports['Renewed-Vehiclekeys']:addKey(plate)
            end)
        end,
        remove = function(vehicle, plate)
            if not resourceStarted('Renewed-Vehiclekeys') then return false end
            return try(function()
                exports['Renewed-Vehiclekeys']:removeKey(plate)
            end)
        end
    },
    {
        name = 't1ger_keys',
        give = function(vehicle, plate, model)
            if not resourceStarted('t1ger_keys') then return false end
            return try(function()
                local displayName = GetLabelText(GetDisplayNameFromVehicleModel(GetEntityModel(vehicle)))
                if displayName == 'NULL' then displayName = model end
                exports['t1ger_keys']:GiveTemporaryKeys(plate, displayName, 'rental')
                exports['t1ger_keys']:SetVehicleLocked(vehicle, 1)
            end)
        end,
        remove = function(vehicle, plate)
            if not resourceStarted('t1ger_keys') then return false end
            return try(function()
                exports['t1ger_keys']:SetVehicleLocked(vehicle, 1)
            end)
        end
    },
    {
        name = 'mk_vehiclekeys',
        give = function(vehicle)
            if not resourceStarted('mk_vehiclekeys') then return false end
            return try(function()
                exports.mk_vehiclekeys:AddKey(vehicle)
            end)
        end,
        remove = function(vehicle)
            if not resourceStarted('mk_vehiclekeys') then return false end
            return try(function()
                exports.mk_vehiclekeys:RemoveKey(vehicle)
            end)
        end
    },
    {
        name = 'xd_locksystem',
        give = function(vehicle, plate)
            if not resourceStarted('xd_locksystem') then return false end
            return try(function()
                exports.xd_locksystem:givePlayerKeys(plate)
            end)
        end,
        remove = function(vehicle, plate)
            if not resourceStarted('xd_locksystem') then return false end
            return try(function()
                exports.xd_locksystem:removePlayerKeys(plate)
            end)
        end
    },
    {
        name = 'VehicleKeyChain',
        give = function(vehicle, plate)
            if not resourceStarted('VehicleKeyChain') then return false end
            return try(function()
                TriggerServerEvent('tn_carrental:keys:give', 'VehicleKeyChain', vehicleNetId(vehicle), plate)
            end)
        end,
        remove = function(vehicle, plate)
            if not resourceStarted('VehicleKeyChain') then return false end
            return try(function()
                TriggerServerEvent('tn_carrental:keys:remove', 'VehicleKeyChain', vehicleNetId(vehicle), plate)
            end)
        end
    }
}

local function eachConfiguredSystem()
    if Config.VehicleKeys == 'none' then return function() end end

    local index = 0
    return function()
        while true do
            index = index + 1
            local system = keySystems[index]
            if not system then return nil end
            if Config.VehicleKeys == 'auto' or Config.VehicleKeys == system.name then
                return system
            end
        end
    end
end

function Bridge.Keys.Give(vehicle, model)
    if not vehicle or vehicle == 0 then return false end

    local plate = cleanPlate(GetVehicleNumberPlateText(vehicle))
    local handled = false

    for system in eachConfiguredSystem() do
        handled = system.give(vehicle, plate, model) or handled
        if handled and Config.VehicleKeys ~= 'auto' then break end
    end

    SetVehicleDoorsLocked(vehicle, 1)
    SetVehicleDoorsLockedForPlayer(vehicle, PlayerId(), false)
    return handled
end

function Bridge.Keys.Remove(vehicle, plate, model)
    plate = cleanPlate(plate or (vehicle and vehicle ~= 0 and GetVehicleNumberPlateText(vehicle)) or '')

    for system in eachConfiguredSystem() do
        system.remove(vehicle, plate, model)
        if Config.VehicleKeys ~= 'auto' then break end
    end
end
