if Sky.Config.garage ~= "cd" then return end
if not IsDuplicityVersion() then return end

local table_name = Sky.Config.framework == "esx" and "owned_vehicles" or "player_vehicles"

function Sky.Functions.IsPlateUsed(plate)
    local result = Sky.Query("SELECT plate FROM " .. table_name .. " WHERE plate = ?", { plate })
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
    local hash = GetHashKey(model)
    local vehicle_data = json.encode({
        plate = plate,
        engineHealth = 1000.0,
        bodyHealth = 1000.0,
        fuelLevel = 100.0,
        model = hash
    })

    if Sky.Config.framework == "esx" then
        local player = ESX.GetPlayerFromId(source)
        Sky.Query("INSERT INTO owned_vehicles (owner, plate, vehicle, in_garage, garage_id, garage_type, adv_stats, impound, impound_data) VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?)", {
            player.identifier,
            plate,
            vehicle_data,
            1,
            "A",
            "car",
            json.encode({
                plate = plate,
                mileage = 0.0,
                maxhealth = 1000.0
            }),
            0,
            json.encode({})
        })
    else
        local player
        if Sky.Config.framework == "qbox" then
            player = exports.qbx_core:GetPlayer(source)
        else
            player = QBCore.Functions.GetPlayer(source)
        end
        Sky.Query("INSERT INTO player_vehicles (license, citizenid, vehicle, hash, mods, plate, state, garage, in_garage, garage_id, garage_type, impound, impound_data) VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?)", {
            player.PlayerData.license,
            player.PlayerData.citizenid,
            model,
            hash,
            vehicle_data,
            plate,
            1,
            "pillboxgarage",
            1,
            "A",
            "car",
            0,
            json.encode({})
        })
    end
end

function Sky.Functions.ChangePlate(old_plate, new_plate)
    -- Update primary plate column
    Sky.Query("UPDATE " .. table_name .. " SET plate = ? WHERE plate = ?", { new_plate, old_plate })

    -- Also update the plate inside JSON columns
    local rows = Sky.Query("SELECT * FROM " .. table_name .. " WHERE plate = ?", { new_plate })
    if not rows or not rows[1] then
        return
    end

    TriggerEvent('cd_garage:PlateChangedPersistentVehicles', old_plate, new_plate)

    if Sky.Config.framework == "esx" then
        local row = rows[1]
        local vehicle_json = row.vehicle
        local advanced_stats_json = row.adv_stats

        local vehicle_ok, vehicle_data = pcall(json.decode, vehicle_json or "")
        if vehicle_ok and type(vehicle_data) == "table" then
            vehicle_data.plate = new_plate
            vehicle_json = json.encode(vehicle_data)
        end

        local advanced_stats_ok, advanced_stats = pcall(json.decode, advanced_stats_json or "")
        if advanced_stats_ok and type(advanced_stats) == "table" then
            advanced_stats.plate = new_plate
            advanced_stats_json = json.encode(advanced_stats)
        end

        Sky.Query("UPDATE owned_vehicles SET vehicle = ?, adv_stats = ? WHERE plate = ?", {
            vehicle_json or row.vehicle,
            advanced_stats_json or row.adv_stats,
            new_plate
        })
    else
        local row = rows[1]
        local mods_json = row.mods

        local mods_ok, mods = pcall(json.decode, mods_json or "")
        if mods_ok and type(mods) == "table" then
            mods.plate = new_plate
            mods_json = json.encode(mods)
        end

        Sky.Query("UPDATE player_vehicles SET mods = ? WHERE plate = ?", {
            mods_json or row.mods,
            new_plate
        })
    end
end
