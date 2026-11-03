if Sky.Config.garage ~= "vms" then return end
if not IsDuplicityVersion() then return end

function Sky.Functions.IsPlateUsed(plate)
    local result
    if Sky.Config.framework == "esx" then
        result = Sky.Query('SELECT plate FROM owned_vehicles WHERE plate = ?', {plate})
    elseif Sky.Config.framework == "qb" or Sky.Config.framework == "qbox" then
        result = Sky.Query('SELECT plate FROM player_vehicles WHERE plate = ?', {plate})
    end
    return result[1] ~= nil
end

function Sky.Functions.GeneratePlate()
    math.randomseed(GetGameTimer())
    local plate = string.upper(Sky.Math.GetRandomLetters(3) .. Sky.Math.GetRandomNumbers(3))

    if Sky.Functions.IsPlateUsed(plate) then
        return Sky.Functions.GeneratePlate()
    end

    return plate
end

function Sky.Functions.GiveVehicle(source, model)
    local plate = Sky.Functions.GeneratePlate()

    local mods = Sky.Cb.Trigger("sky_base:getVehicleMods", source, model)
    mods.plate = plate
    local vehicle_type = "vehicle"
    local garage = "Impound1"

    if mods.class == 14 then
        garage = "ImpoundBoat"
        vehicle_type = "boat"
    elseif mods.class == 15 then
        garage = "ImpoundHeli"
        vehicle_type = "helicopter"
    elseif mods.class == 16 then
        garage = "ImpoundPlane"
        vehicle_type = "plane"
    end
    if Sky.Config.framework == "esx" then
        local player = ESX.GetPlayerFromId(source)
        Sky.Query('INSERT INTO owned_vehicles (owner, plate, vehicle, type, garage, impound_date) VALUES (?, ?, ?, ?, ?, ?)', {
            player.identifier,
            plate,
            json.encode({['model'] = GetHashKey(model), ['plate'] = plate}),
            vehicle_type,
            garage,
            os.time()
        })
    elseif Sky.Config.framework == "qb" or Sky.Config.framework == "qbox" then
        local player
        if Sky.Config.framework == "qbox" then
            player = exports.qbx_core:GetPlayer(source)
        else
            player = QBCore.Functions.GetPlayer(source)
        end
        Sky.Query('INSERT INTO player_vehicles (citizenid, vehicle, hash, mods, plate, type, garage, impound_date) VALUES (?, ?, ?, ?, ?, ?, ?, ?)', {
            player.PlayerData.citizenid,
            model,
            GetHashKey(model),
            json.encode({['model'] = GetHashKey(model), ['plate'] = plate}),
            plate,
            vehicle_type,
            garage,
            os.time()
        })
    end
    TriggerClientEvent("sky_base:client:giveVehicleKeys", source, plate, model)
end

function Sky.Functions.ChangePlate(old_plate, new_plate, src)
    if Sky.Config.framework == "esx" then
        local vehicle_data = Sky.Query('SELECT vehicle, netid FROM owned_vehicles WHERE plate = ?', {old_plate})
        if vehicle_data[1] then
            local vehicle = json.decode(vehicle_data[1].vehicle)
            vehicle.plate = new_plate
            Sky.Query('UPDATE owned_vehicles SET plate = ?, vehicle = ? WHERE plate = ?', {new_plate, json.encode(vehicle), old_plate})

            if GetResourceState("vms_garagesv2") == "started" then
                exports["vms_garagesv2"]:updateParkedVehiclePlate(old_plate, new_plate, true)
            end

            local netId = vehicle_data[1].netid
            if netId then
                local vehicle = NetworkGetEntityFromNetworkId(netId)
                while not DoesEntityExist(vehicle) do Wait(0) end

                SetVehicleNumberPlateText(vehicle, new_plate)
                local state = Entity(vehicle).state
                local VehicleProperties = state.VehicleProperties
                VehicleProperties.plate = new_plate
                state:set("VehicleProperties", VehicleProperties, true)
            end
        end
    elseif Sky.Config.framework == "qb" or Sky.Config.framework == "qbox" then
        Sky.Query('UPDATE player_vehicles SET plate = ? WHERE plate = ?', {new_plate, old_plate})
        TriggerClientEvent("sky_base:client:giveVehicleKeys", src, new_plate)
    end
end
