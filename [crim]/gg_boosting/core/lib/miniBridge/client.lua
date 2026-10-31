gg = gg or {} gg.fuel = gg.fuel or {} gg.keys = gg.keys or {}


-- MARK: Get Fuel
---@param veh number Vehicle Entity Id
gg.fuel.getFuel = function(veh)
    if type(veh) ~= "number" or veh == 0 or not DoesEntityExist(veh) then return end

    if GetResourceState('bigDaddy-Fuel') == 'started' then
        return exports['BigDaddy-Fuel']:GetFuel(veh)
    elseif GetResourceState('cdn-fuel') == 'started' then
        return exports['cdn-fuel']:GetFuel(veh)
    elseif GetResourceState('esx-sna-fuel') == 'started' then
        return exports['esx-sna-fuel']:GetFuel(veh)
    elseif GetResourceState('frkn-fuelstationv4') == 'started' then
        return exports['frkn-fuelstationv4']:GetFuel(veh)
    elseif GetResourceState('lc_fuel') == 'started' then
        return exports['lc_fuel']:GetFuel(veh)
    elseif GetResourceState('LegacyFuel') == 'started' then
        return exports['LegacyFuel']:GetFuel(veh)
    elseif GetResourceState('okokGasStation') == 'started' then
        return exports['okokGasStation']:GetFuel(veh)
    elseif GetResourceState('ox_fuel') == 'started' then
        return Entity(veh).state.fuel
    elseif GetResourceState('ps-fuel') == 'started' then
        return exports['ps-fuel']:GetFuel(veh)
    elseif GetResourceState('qb-fuel') == 'started' then
        return exports['qb-fuel']:GetFuel(veh)
    elseif GetResourceState('qb-sna-fuel') == 'started' then
        return exports['qb-sna-fuel']:GetFuel(veh)
    elseif GetResourceState('qs-fuelstations') == 'started' then
        return exports['qs-fuelstations']:GetFuel(veh)
    elseif GetResourceState('rcore_fuel') == 'started' then
        return exports['rcore_fuel']:GetVehicleFuelLiters(veh)
    elseif GetResourceState('Renewed-Fuel') == 'started' then
        return exports['Renewed-Fuel']:GetFuel(veh)
    elseif GetResourceState('ti_fuel') == 'started' then
        return exports['ti_fuel']:getFuel(veh)
    elseif GetResourceState('x-fuel') == 'started' then
        return exports['x-fuel']:GetFuel(veh)
    else
        return GetVehicleFuelLevel(veh)
    end
end

-- MARK: Set Fuel
---@param veh number Vehicle Entity Id
---@param val number Fuel level
gg.fuel.setFuel = function(veh, val)
    if type(veh) ~= "number" or veh == 0 or not DoesEntityExist(veh) then return end
    if type(val) ~= "number" then val = 100.0 end

    if GetResourceState('bigDaddy-Fuel') == 'started' then
        return exports['BigDaddy-Fuel']:SetFuel(veh, val)
    elseif GetResourceState('cdn-fuel') == 'started' then
        return exports['cdn-fuel']:SetFuel(veh, val)
    elseif GetResourceState('esx-sna-fuel') == 'started' then
        return exports['esx-sna-fuel']:SetFuel(veh, val)
    elseif GetResourceState('frkn-fuelstationv4') == 'started' then
        return exports['frkn-fuelstationv4']:SetFuel(veh, val)
    elseif GetResourceState('lc_fuel') == 'started' then
        return exports['lc_fuel']:SetFuel(veh, val)
    elseif GetResourceState('LegacyFuel') == 'started' then
        return exports['LegacyFuel']:SetFuel(veh, val)
    elseif GetResourceState('okokGasStation') == 'started' then
        return exports['okokGasStation']:SetFuel(veh, val)
    elseif GetResourceState('ox_fuel') == 'started' then
        Entity(veh).state.fuel = val
        return true
    elseif GetResourceState('ps-fuel') == 'started' then
        return exports['ps-fuel']:SetFuel(veh, val)
    elseif GetResourceState('qb-fuel') == 'started' then
        return exports['qb-fuel']:SetFuel(veh, val)
    elseif GetResourceState('qb-sna-fuel') == 'started' then
        return exports['qb-sna-fuel']:SetFuel(veh, val)
    elseif GetResourceState('qs-fuelstations') == 'started' then
        return exports['qs-fuelstations']:SetFuel(veh, val)
    elseif GetResourceState('rcore_fuel') == 'started' then
        return exports['rcore_fuel']:SetVehicleFuel(veh, val)
    elseif GetResourceState('Renewed-Fuel') == 'started' then
        return exports['Renewed-Fuel']:SetFuel(veh, val)
    elseif GetResourceState('ti_fuel') == 'started' then
        return exports['ti_fuel']:setFuel(veh, val, "RON91")
    elseif GetResourceState('x-fuel') == 'started' then
        return exports['x-fuel']:SetFuel(veh, val)
    else
        return SetVehicleFuelLevel(veh, val)
    end
end

-- MARK: Add Keys
---@param veh number Vehicle Entity Id
gg.keys.AddKeys = function(veh)
    if type(veh) ~= "number" or veh == 0 or not DoesEntityExist(veh) then return end

    local plate = GetVehicleNumberPlateText(veh)
    local model = GetEntityModel(veh)
    local displayName = GetDisplayNameFromVehicleModel(model)

    if GetResourceState('bhd_garage') == 'started' then
        TriggerServerEvent('bhd_garage:keys:CreateKey', plate)
        return true
    elseif GetResourceState('brutal_keys') == 'started' then
        return exports.brutal_keys:addVehicleKey(plate, plate)
    elseif GetResourceState('cd_garage') == 'started' then
        TriggerEvent('cd_garage:AddKeys', plate)
        return true
    elseif GetResourceState('F_RealCarKeysSystem') == 'started' then
        TriggerServerEvent('F_RealCarKeysSystem:generateVehicleKeys', plate)
        return true
    elseif GetResourceState('mk_vehiclekeys') == 'started' then
        return exports['mk_vehiclekeys']:AddKey(veh)
    elseif GetResourceState('mono_carkeys') == 'started' then
        TriggerServerEvent('mono_carkeys:CreateKey', plate)
        return true
    elseif GetResourceState('MrNewbVehicleKeys') == 'started' then
        return exports.MrNewbVehicleKeys:GiveKeys(veh)
    elseif GetResourceState('0r-vehiclekeys') == 'started' then
        return exports['0r-vehiclekeys']:GiveKeys(plate)
    elseif GetResourceState('p_carkeys') == 'started' then
        TriggerServerEvent('p_carkeys:CreateKeys', plate)
        return true
    elseif GetResourceState('p_vehiclekeys') == 'started' then
        return exports['p_vehiclekeys']:createKey(plate, veh)
    elseif GetResourceState('Renewed-Vehiclekeys') == 'started' then
        exports['Renewed-Vehiclekeys']:addKey(plate)
        return true
    elseif GetResourceState('qb-vehiclekeys') == 'started' then
        TriggerServerEvent('qb-vehiclekeys:server:AcquireVehicleKeys', plate)
        return true
    elseif GetResourceState('qbx_vehiclekeys') == 'started' then
        TriggerServerEvent('qb-vehiclekeys:server:AcquireVehicleKeys', plate)
        return true
    elseif GetResourceState('qs-vehiclekeys') == 'started' then
        return exports['qs-vehiclekeys']:GiveKeys(plate, displayName, true)
    elseif GetResourceState('tgiann-hotwire') == 'started' then
        return exports['tgiann-hotwire']:GiveKeyVehicle(veh, true)
    elseif GetResourceState('vehicles_keys') == 'started' then
        TriggerServerEvent('vehicles_keys:selfGiveVehicleKeys', plate)
        return true
    elseif GetResourceState('wasabi_carlock') == 'started' then
        return exports.wasabi_carlock:GiveKey(plate)
    elseif GetResourceState('okokGarage') == 'started' then
        TriggerServerEvent('okokGarage:GiveKeys', plate)
        return true
    else
        -- Default add keys
    end
end

-- MARK: Remove Keys
---@param veh number Vehicle Entity Id
gg.keys.RemoveKeys = function(veh)
    if type(veh) ~= "number" or veh == 0 or not DoesEntityExist(veh) then return end

    local plate = GetVehicleNumberPlateText(veh)
    local model = GetEntityModel(veh)
    local displayName = GetDisplayNameFromVehicleModel(model)

    if GetResourceState('bhd_garage') == 'started' then
        TriggerServerEvent('bhd_garage:keys:DeleteKey', 1, plate)
        return true
    elseif GetResourceState('brutal_keys') == 'started' then
        return exports.brutal_keys:removeKey(plate, true)
    elseif GetResourceState('cd_garage') == 'started' then
        TriggerEvent('cd_garage:RemoveKeys', plate)
        return true
    elseif GetResourceState('F_RealCarKeysSystem') == 'started' then
        -- No Remove Key Event
        return false
    elseif GetResourceState('mk_vehiclekeys') == 'started' then
        return exports['mk_vehiclekeys']:RemoveKey(veh)
    elseif GetResourceState('mono_carkeys') == 'started' then
        TriggerServerEvent('mono_carkeys:DeleteKey', 1, plate)
        return true
    elseif GetResourceState('MrNewbVehicleKeys') == 'started' then
        return exports.MrNewbVehicleKeys:RemoveKeys(veh)
    elseif GetResourceState('0r-vehiclekeys') == 'started' then
        return exports['0r-vehiclekeys']:RemoveKeys(plate)
    elseif GetResourceState('p_carkeys') == 'started' then
        TriggerServerEvent('p_carkeys:RemoveKeys', plate)
        return true
    elseif GetResourceState('p_vehiclekeys') == 'started' then
        return exports['p_vehiclekeys']:removeKey(plate, veh)
    elseif GetResourceState('Renewed-Vehiclekeys') == 'started' then
        return exports['Renewed-Vehiclekeys']:removeKey(plate)
    elseif GetResourceState('qb-vehiclekeys') == 'started' then
        -- No Remove Key Event
        return false
    elseif GetResourceState('qbx_vehiclekeys') == 'started' then
        -- No Remove Key Event
        return false
    elseif GetResourceState('qs-vehiclekeys') == 'started' then
        return exports['qs-vehiclekeys']:RemoveKeys(plate, displayName)
    elseif GetResourceState('tgiann-hotwire') == 'started' then
        -- No Remove Key Event
        return false
    elseif GetResourceState('vehicles_keys') == 'started' then
        TriggerServerEvent('vehicles_keys:selfRemoveKeys', plate)
        return true
    elseif GetResourceState('wasabi_carlock') == 'started' then
        return exports.wasabi_carlock:RemoveKey(plate)
    elseif GetResourceState('okokGarage') == 'started' then
        TriggerServerEvent('okokGarage:RemoveKeys', plate, GetPlayerServerId(PlayerId()))
        return true
    else
        -- Default remove keys
    end
end
