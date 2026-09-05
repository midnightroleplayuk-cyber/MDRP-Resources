local function normalizeKeyPlate(plate, vehicle)
    if (not plate or plate == '') and vehicle and DoesEntityExist(vehicle) then
        plate = GetVehicleNumberPlateText(vehicle)
    end
    if type(plate) ~= 'string' then return nil end
    return plate:match('^%s*(.-)%s*$')
end

function giveKeys(vehicle, model, plate)
    plate = normalizeKeyPlate(plate, vehicle)
    if not plate or plate == '' then return end

    if Config.KeysDependency == "qb-keys" or Config.KeysDependency ==
        "sna-vehiclekeys" then
        TriggerServerEvent('qb-vehiclekeys:server:AcquireVehicleKeys', plate)
    elseif Config.KeysDependency == "wasabi_carlock" then
        exports.wasabi_carlock:GiveKey(plate)
    elseif Config.KeysDependency == "dusa_vehiclekeys" then
        exports['dusa_vehiclekeys']:AddKey(plate)
    elseif Config.KeysDependency == "velia_carkeys" then
        exports["velia_carkeys"]:AddKey(plate)
    elseif Config.KeysDependency == "Renewed-Vehiclekeys" then
        exports['Renewed-Vehiclekeys']:addKey(plate)
    elseif Config.KeysDependency == "tgiann-keys" then
        exports["tgiann-hotwire"]:CheckKeyInIgnitionWhenSpawn(vehicle, plate)
    elseif Config.KeysDependency == "ak47_vehiclekeys" then
        exports['ak47_vehiclekeys']:GiveKey(plate, false)
    elseif Config.KeysDependency == "ak47_qb_vehiclekeys" then
        exports['ak47_qb_vehiclekeys']:GiveKey(plate, false)
    elseif Config.KeysDependency == "p_carkeys" then
        TriggerServerEvent('p_carkeys:CreateKeys', plate)
    elseif Config.KeysDependency == "brutal_keys" then 
        exports.brutal_keys:addVehicleKey(plate, plate)
    elseif Config.KeysDependency == "sy_carkeys" then 
        TriggerServerEvent('sy_carkeys:KeyOnBuy', plate, model) 
    elseif Config.KeysDependency == "mVehicle" then 
        exports.mVehicle:ItemCarKeysClient('add', plate)
    elseif Config.KeysDependency == "MrNewbVehicleKeys" then
        exports.MrNewbVehicleKeys:GiveKeysByPlate(plate)
    elseif Config.KeysDependency == "vehicles_keys" then 
        TriggerServerEvent("vehicles_keys:selfGiveVehicleKeys", plate)
    end
end

function removeKeys(vehicle, model, plate)
    plate = normalizeKeyPlate(plate, vehicle)
    if not plate or plate == '' then return end

    if Config.KeysDependency == "qb-keys" or Config.KeysDependency ==
        "sna-vehiclekeys" then
        TriggerServerEvent('qb-vehiclekeys:server:RemoveKey', plate)
    elseif Config.KeysDependency == "wasabi_carlock" then
        exports.wasabi_carlock:RemoveKey(plate)
    elseif Config.KeysDependency == "dusa_vehiclekeys" then
        exports['dusa_vehiclekeys']:RemoveKey(plate)
    elseif Config.KeysDependency == "velia_carkeys" then
        exports["velia_carkeys"]:RemoveKey(plate)
    elseif Config.KeysDependency == "Renewed-Vehiclekeys" then
        exports['Renewed-Vehiclekeys']:removeKey(plate)
    elseif Config.KeysDependency == "tgiann-keys" then
        exports["tgiann-hotwire"]:CheckKeyInIgnitionWhenSpawn(vehicle, plate)
    elseif Config.KeysDependency == "ak47_vehiclekeys" then
        exports['ak47_vehiclekeys']:RemoveKey(plate, false)
    elseif Config.KeysDependency == "ak47_qb_vehiclekeys" then
        exports['ak47_qb_vehiclekeys']:RemoveKey(plate, false)
    elseif Config.KeysDependency == "p_carkeys" then
        TriggerServerEvent('p_carkeys:RemoveKeys', plate)
    elseif Config.KeysDependency == "brutal_keys" then 
        exports.brutal_keys:removeKey(plate, true)
    elseif Config.KeysDependency == "sy_carkeys" then 
    elseif Config.KeysDependency == "mVehicle" then 
        exports.mVehicle:ItemCarKeysClient('delete', plate)
    elseif Config.KeysDependency == "MrNewbVehicleKeys" then
        exports.MrNewbVehicleKeys:RemoveKeysByPlate(plate)
    elseif Config.KeysDependency == "vehicles_keys" then 
        TriggerServerEvent("vehicles_keys:selfRemoveKeys", plate)
    end
end