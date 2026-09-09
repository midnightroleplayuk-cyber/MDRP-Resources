function giveKeys(vehicle, model, plate)
    if Config.KeysDependency == "qs-keys" then
        exports['qs-vehiclekeys']:GiveKeys(plate, model, true)
    elseif Config.KeysDependency == "qb-keys" or Config.KeysDependency ==
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
        exports["tgiann-hotwire"]:GiveKeyPlate(plate, true)
    elseif Config.KeysDependency == "ak47_vehiclekeys" then
        exports['ak47_vehiclekeys']:GiveKey(plate, false)
    elseif Config.KeysDependency == "ak47_qb_vehiclekeys" then
        exports['ak47_qb_vehiclekeys']:GiveKey(plate, false)
    elseif Config.KeysDependency == "p_carkeys" then
        TriggerServerEvent('p_carkeys:CreateKeys', plate)
    elseif Config.KeysDependency == "MrNewbVehicleKeys" then
        exports.MrNewbVehicleKeys:GiveKeysByPlate(plate)
    end
end

function removeKeys(vehicle, model, plate)
    if Config.KeysDependency == "qs-keys" then
        exports['qs-vehiclekeys']:RemoveKeys(plate, model)
    elseif Config.KeysDependency == "qb-keys" or Config.KeysDependency ==
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
    elseif Config.KeysDependency == "MrNewbVehicleKeys" then
        exports.MrNewbVehicleKeys:RemoveKeysByPlate(plate)
    end
end