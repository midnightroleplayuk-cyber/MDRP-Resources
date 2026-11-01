if Sky.Config.garage ~= "ak47" then return end
if not IsDuplicityVersion() then return end

local table_name = Sky.Config.framework == "esx" and "owned_vehicles" or "player_vehicles"

function Sky.Functions.IsPlateUsed(plate)
    local result = Sky.Query(("SELECT plate FROM %s WHERE plate = ?"):format(table_name), { plate })
    return result[1] ~= nil
end

function Sky.Functions.GeneratePlate()
    math.randomseed(GetGameTimer())
    local plate = string.upper(Sky.Math.GetRandomLetters(3)..' '..Sky.Math.GetRandomNumbers(3)..''..Sky.Math.GetRandomLetters(1))

    if Sky.Functions.IsPlateUsed(plate) then
        return Sky.Functions.GeneratePlate()
    end

    return plate
end

function Sky.Functions.GiveVehicle(source, model)
    local plate = Sky.Functions.GeneratePlate()
    local model_hash = joaat(model)
    local vehicle_data = json.encode({ plate = plate, model = model_hash })

    if Sky.Config.framework == "esx" then
        Sky.Query("INSERT INTO owned_vehicles (owner, plate, vehicle, type, stored) VALUES (?, ?, ?, ?, ?)", {
            Sky.FW.GetIdentifier(source),
            plate,
            vehicle_data,
            "car",
            1
        })
    else
        local player_data
        if Sky.Config.framework == "qbox" then
            player_data = exports.qbx_core:GetPlayer(source)
        else
            player_data = QBCore.Functions.GetPlayer(source)
        end
        Sky.Query("INSERT INTO player_vehicles (license, citizenid, vehicle, hash, mods, plate, state, garage) VALUES (?, ?, ?, ?, ?, ?, ?, ?)", {
            player_data.PlayerData.license,
            player_data.PlayerData.citizenid,
            model,
            model_hash,
            vehicle_data,
            plate,
            1,
            "pillboxgarage"
        })
    end

    TriggerClientEvent("sky_base:client:giveVehicleKeys", source, plate, model)
end

function Sky.Functions.ChangePlate(old_plate, new_plate)
    Sky.Query(("UPDATE %s SET plate = ? WHERE plate = ?"):format(table_name), { new_plate, old_plate })
end
