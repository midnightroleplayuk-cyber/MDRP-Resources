if Sky.Config.garage ~= "okok" then return end
if not IsDuplicityVersion() then return end

local table_name = Sky.Config.framework == "esx" and "owned_vehicles" or "player_vehicles"

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

    local mods = Sky.Cb.Trigger("sky_base:getVehicleMods", source, model)
    local vehicle_type = "car"
    local garage = "Legion Square"

    if mods.class == 14 then
        garage = "Boat"
        vehicle_type = "boat"
    elseif mods.class == 15 or mods.class == 16 then
        garage = "Air"
        vehicle_type = "air"
    end

    if Sky.Config.framework == "esx" then
        local player = ESX.GetPlayerFromId(source)
        Sky.Query('INSERT INTO owned_vehicles (owner, plate, vehicle, stored, parking, type) VALUES (?, ?, ?, ?, ?, ?)',{
            player.identifier,
            plate,
            json.encode(mods),
            1,
            garage,
            vehicle_type
        })
    elseif Sky.Config.framework == "qb" or Sky.Config.framework == "qbox" then
        local player
        if Sky.Config.framework == "qb" then
            player = QBCore.Functions.GetPlayer(source)
        elseif Sky.Config.framework == "qbox" then
            player = exports.qbx_core:GetPlayer(source)
        end
        Sky.Query("INSERT INTO player_vehicles (license, citizenid, vehicle, hash, mods, plate, state, garage) VALUES (?, ?, ?, ?, ?, ?, ?, ?)", {
            player.PlayerData.license,
            player.PlayerData.citizenid,
            model,
            GetHashKey(model),
            json.encode(mods),
            plate,
            1,
            garage,
        })
    end
end

function Sky.Functions.ChangePlate(old_plate, new_plate)
    Sky.Query("UPDATE " .. table_name .. " SET plate = ? WHERE plate = ?", { new_plate, old_plate })
end
