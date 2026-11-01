if Sky.Config.garage ~= "quasar" then return end
if not IsDuplicityVersion() then return end

local table_name = Sky.Config.framework == "esx" and "owned_vehicles" or "player_vehicles"

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
    local plate = string.upper(Sky.Math.GetRandomLetters(4) .. Sky.Math.GetRandomNumbers(4))

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
    local garage = "Legion Square"

    if mods.class == 14 then
        garage = "La Puerta Pier"
        vehicle_type = "boat"
    elseif mods.class == 15 or mods.class == 16 then
        garage = "Airport Hangar"
        vehicle_type = "plane"
    end

    if Sky.Config.framework == "esx" then
        local player = ESX.GetPlayerFromId(source)
        Sky.Query('INSERT INTO owned_vehicles (owner, plate, vehicle, stored, garage, type) VALUES (@owner, @plate, @vehicle, @stored, @garage, @type)',
        {
            ['@owner']   = player.identifier,
            ['@plate']   = plate,
            ['@vehicle'] = json.encode(mods),
            ['@stored'] = 1,
            ['@garage'] = garage,
            ['@type'] = vehicle_type
        })
    elseif Sky.Config.framework == "qb" or Sky.Config.framework == "qbox" then
        local player
        if Sky.Config.framework == "qb" then
            player = QBCore.Functions.GetPlayer(source)
        elseif Sky.Config.framework == "qbox" then
            player = exports.qbx_core:GetPlayer(source)
        end
        Sky.Query('INSERT INTO player_vehicles (license, citizenid, vehicle, hash, mods, plate, garage) VALUES (?, ?, ?, ?, ?, ?, ?)', {
            player.PlayerData.license,
            player.PlayerData.citizenid,
            model,
            GetHashKey(model),
            json.encode(mods),
            plate,
            garage
        })
    end
    TriggerClientEvent("sky_base:client:giveVehicleKeys", source, plate, model)
end

function Sky.Functions.ChangePlate(old_plate, new_plate)
    Sky.Query("UPDATE " .. table_name .. " SET plate = ? WHERE plate = ?", {new_plate, old_plate})
end
