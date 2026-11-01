if Sky.Config.garage ~= "rx" then return end
if not IsDuplicityVersion() then return end

local table_name = Sky.Config.framework == "esx" and "owned_vehicles" or "player_vehicles"

function Sky.Functions.IsPlateUsed(plate)
    local result = Sky.Query('SELECT plate FROM ' .. table_name .. ' WHERE plate = ?', { plate })
    return result[1] ~= nil
end

function Sky.Functions.GeneratePlate()
    math.randomseed(GetGameTimer())
    local plate = string.upper(Sky.Math.GetRandomLetters(3) .. ' ' .. Sky.Math.GetRandomNumbers(3))

    if Sky.Functions.IsPlateUsed(plate) then
        return Sky.Functions.GeneratePlate()
    end

    return plate
end

function Sky.Functions.GiveVehicle(source, model)
    local plate = Sky.Functions.GeneratePlate()
    local vehicle_properties = { model = GetHashKey(model), plate = plate }

    if Sky.Config.framework == "esx" then
        local identifier = Sky.FW.GetIdentifier(source)
        Sky.Query('INSERT INTO owned_vehicles (owner, plate, vehicle, stored, type, parked_at) VALUES (@owner, @plate, @vehicle, @stored, @type, @parked_at)',
        {
            ['@owner'] = identifier,
            ['@plate'] = plate,
            ['@vehicle'] = json.encode(vehicle_properties),
            ['@stored'] = 1,
            ['@type'] = 'car',
            ['@parked_at'] = 'garage'
        })
    else
        local player = nil
        if Sky.Config.framework == "qb" then
            player = QBCore.Functions.GetPlayer(source)
        elseif Sky.Config.framework == "qbox" then
            player = exports.qbx_core:GetPlayer(source)
        end
        Sky.Query('INSERT INTO player_vehicles (license, citizenid, plate, vehicle, parked_at) VALUES (@license, @citizenid, @plate, @vehicle, @parked_at)',
        {
            ['@license'] = string.gsub(player.PlayerData.license, "license:", ""),
            ['@citizenid'] = player.PlayerData.citizenid,
            ['@plate'] = plate,
            ['@vehicle'] = json.encode(vehicle_properties),
            ['@parked_at'] = 'garage'
        })
    end
end

function Sky.Functions.ChangePlate(old_plate, new_plate)
    Sky.Query("UPDATE " .. table_name .. " SET plate = ?, vehicle = JSON_SET(vehicle, '$.plate', ?) WHERE plate = ?", {
        new_plate,
        new_plate,
        old_plate
    })
end
