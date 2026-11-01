if Sky.Config.garage ~= "codem" then return end
if not IsDuplicityVersion() then return end

if Sky.Config.framework ~= "esx" and Sky.Config.framework ~= "qb" then
    error("CodeM mGarage integration only supports ESX and QBCore.")
end

local table_name = Sky.Config.framework == "esx" and "owned_vehicles" or "player_vehicles"
local default_parking = "Garage A"

function Sky.Functions.IsPlateUsed(plate)
    local result = Sky.Query("SELECT plate FROM " .. table_name .. " WHERE plate = ?", { plate })
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
    local model_hash = joaat(model)
    local vehicle_data = Sky.Cb.Trigger("sky_base:getVehicleMods", source, model)
    vehicle_data.plate = plate

    if Sky.Config.framework == "esx" then
        local vehicle_type = "car"
        if vehicle_data.class == 14 then
            vehicle_type = "boat"
        elseif vehicle_data.class == 15 or vehicle_data.class == 16 then
            vehicle_type = "air"
        end

        Sky.Query(
            "INSERT INTO owned_vehicles (owner, plate, vehicle, type, stored, parking) VALUES (?, ?, ?, ?, ?, ?)",
            {
                Sky.FW.GetIdentifier(source),
                plate,
                json.encode(vehicle_data),
                vehicle_type,
                1,
                default_parking
            }
        )
    else
        Sky.Query(
            "INSERT INTO player_vehicles (license, citizenid, vehicle, hash, mods, plate, state, parking) VALUES (?, ?, ?, ?, ?, ?, ?, ?)",
            {
                GetPlayerIdentifierByType(source, "license"),
                Sky.FW.GetIdentifier(source),
                model,
                model_hash,
                json.encode(vehicle_data),
                plate,
                1,
                default_parking
            }
        )
    end

    TriggerClientEvent("sky_base:client:giveVehicleKeys", source, plate, model)
    return plate
end

function Sky.Functions.ChangePlate(old_plate, new_plate)
    local json_column = Sky.Config.framework == "esx" and "vehicle" or "mods"
    local rows = Sky.Query(
        "SELECT " .. json_column .. " FROM " .. table_name .. " WHERE plate = ?",
        { old_plate }
    )

    if not rows[1] then
        Sky.Debug("warn", "[CodeM mGarage] Cannot change an unknown vehicle plate: " .. tostring(old_plate))
        return false
    end

    local vehicle_data = json.decode(rows[1][json_column])
    vehicle_data.plate = new_plate

    Sky.Query(
        "UPDATE " .. table_name .. " SET plate = ?, " .. json_column .. " = ? WHERE plate = ?",
        { new_plate, json.encode(vehicle_data), old_plate }
    )

    return true
end
