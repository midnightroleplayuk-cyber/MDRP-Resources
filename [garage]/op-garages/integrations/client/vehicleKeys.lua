function giveKeys(vehicle, model, plate)
    if plate == nil then
        if vehicle and vehicle ~= 0 and DoesEntityExist(vehicle) then
            plate = GetVehicleNumberPlateText(vehicle)
        else
            debugPrint('giveKeys aborted - missing plate and vehicle')
            return
        end
    end

    plate = tostring(plate):match("^%s*(.-)%s*$")
    if not plate or plate == "" then
        debugPrint('giveKeys aborted - empty plate')
        return
    end

    -- Sync plate onto entity before key scripts that read from the vehicle
    if vehicle and vehicle ~= 0 and DoesEntityExist(vehicle) then
        local current = GetVehicleNumberPlateText(vehicle)
        current = current and current:match("^%s*(.-)%s*$") or ""
        if current ~= plate then
            SetVehicleNumberPlateText(vehicle, plate)
        end
    end

    debugPrint('Adding keys to vehicle with plate', plate, model, vehicle)

    if Config.KeysDependency == "qb-keys" or Config.KeysDependency ==
        "sna-vehiclekeys" or Config.KeysDependency == "qbx_vehiclekeys" then
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
        if vehicle and DoesEntityExist(vehicle) then
            exports["tgiann-hotwire"]:CheckKeyInIgnitionWhenSpawn(vehicle, plate)
        end
        exports["tgiann-hotwire"]:GiveKeyPlate(plate, true)
    elseif Config.KeysDependency == "ak47_vehiclekeys" then
        exports['ak47_vehiclekeys']:GiveKey(plate, false)
    elseif Config.KeysDependency == "ak47_qb_vehiclekeys" then
        exports['ak47_qb_vehiclekeys']:GiveKey(plate, false)
    elseif Config.KeysDependency == "p_carkeys" then
        TriggerServerEvent('p_carkeys:CreateKeys', plate)
    elseif Config.KeysDependency == "MrNewbVehicleKeys" then
        exports.MrNewbVehicleKeys:GiveKeysByPlate(plate)
    elseif Config.KeysDependency == "brutal_keys" then
        exports.brutal_keys:addVehicleKey(plate, plate)
    elseif Config.KeysDependency == "sy_carkeys" then
        TriggerServerEvent('sy_carkeys:KeyOnBuy', plate, model)
    elseif Config.KeysDependency == "mVehicle" then
        exports.mVehicle:ItemCarKeysClient('add', plate)
    elseif Config.KeysDependency == "old-qb-keys" then
        TriggerServerEvent('vehiclekeys:server:GiveVehicleKeys', plate, GetPlayerServerId(PlayerId()))
    elseif Config.KeysDependency == "custom-qb-keys" then
        TriggerServerEvent('vehiclekeys:server:SetVehicleOwner', plate)
    elseif Config.KeysDependency == "wx_carlock" then
        TriggerServerEvent('op-garages:wxCarlock', vehicle, model, plate)
    elseif Config.KeysDependency == "jaksam_keys" then
        TriggerServerEvent("vehicles_keys:selfGiveVehicleKeys", plate)
    elseif Config.KeysDependency == "0r-vehiclekeys" then
        exports['0r-vehiclekeys']:GiveKeys(plate)
    elseif Config.KeysDependency == "msk_vehiclekeys" then
        if vehicle and DoesEntityExist(vehicle) then
            exports.msk_vehiclekeys:AddKey(vehicle)
        end
    elseif Config.KeysDependency == "p_vehiclekeys" then
        exports['p_vehiclekeys']:createKey(plate, vehicle)
    elseif Config.KeysDependency == "ic3d_vehiclekeys" then
        exports.ic3d_vehiclekeys:ClientInventoryKeys('add', plate)
    elseif Config.KeysDependency == "filo_vehiclekeys" then
        -- Only one API — calling both ByPlate + entity gave duplicate keys
        local ok = pcall(function()
            exports.filo_vehiclekeys:GiveKeysByPlate(plate)
        end)
        if not ok and vehicle and vehicle ~= 0 and DoesEntityExist(vehicle) then
            pcall(function()
                exports.filo_vehiclekeys:GiveKeys(vehicle)
            end)
        end
    end
end

function removeKeys(vehicle, model, plate)
    debugPrint('removing keys to vehicle with plate', plate, model, vehicle)
    if plate then
        plate = tostring(plate):match("^%s*(.-)%s*$")
    end
    if Config.KeysDependency == "jaksam_keys" then
        TriggerServerEvent("vehicles_keys:selfRemoveKeys", plate)
    elseif Config.KeysDependency == "qb-keys" or Config.KeysDependency ==
        "sna-vehiclekeys" or Config.KeysDependency == "qbx_vehiclekeys" then
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
        if vehicle and DoesEntityExist(vehicle) then
            exports["tgiann-hotwire"]:CheckKeyInIgnitionWhenSpawn(vehicle, plate)
        end
    elseif Config.KeysDependency == "ak47_vehiclekeys" then
        exports['ak47_vehiclekeys']:RemoveKey(plate, false)
    elseif Config.KeysDependency == "ak47_qb_vehiclekeys" then
        exports['ak47_qb_vehiclekeys']:RemoveKey(plate, false)
    elseif Config.KeysDependency == "p_carkeys" then
        TriggerServerEvent('p_carkeys:RemoveKeys', plate)
    elseif Config.KeysDependency == "MrNewbVehicleKeys" then
        exports.MrNewbVehicleKeys:RemoveKeysByPlate(plate)
    elseif Config.KeysDependency == "sy_carkeys" then
    elseif Config.KeysDependency == "mVehicle" then
        exports.mVehicle:ItemCarKeysClient('delete', plate)
    elseif Config.KeysDependency == "brutal_keys" then
        exports.brutal_keys:removeKey(plate, true)
    elseif Config.KeysDependency == "old-qb-keys" then
    elseif Config.KeysDependency == "custom-qb-keys" then
        local playerData = Fr.GetPlayerData()
        local identifier = trim(playerData[Fr.identificatorTable])
        TriggerServerEvent('vehiclekeys:server:RemoveKeys', plate, identifier)
    elseif Config.KeysDependency == "wx_carlock" then
    elseif Config.KeysDependency == "0r-vehiclekeys" then
        exports['0r-vehiclekeys']:RemoveKeys(plate)
    elseif Config.KeysDependency == "msk_vehiclekeys" then
        if vehicle and DoesEntityExist(vehicle) then
            exports.msk_vehiclekeys:RemoveKey(vehicle)
        end
    elseif Config.KeysDependency == "p_vehiclekeys" then
        exports['p_vehiclekeys']:removeKey(plate, vehicle, true)
    elseif Config.KeysDependency == "ic3d_vehiclekeys" then
        exports.ic3d_vehiclekeys:ClientInventoryKeys('remove', plate)
    elseif Config.KeysDependency == "filo_vehiclekeys" then
        local ok = pcall(function()
            exports.filo_vehiclekeys:RemoveKeysByPlate(plate)
        end)
        if not ok and vehicle and vehicle ~= 0 and DoesEntityExist(vehicle) then
            pcall(function()
                exports.filo_vehiclekeys:RemoveKeys(vehicle)
            end)
        end
    end
end