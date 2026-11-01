if Sky.Config.garage ~= "jg" then return end
if not IsDuplicityVersion() then return end

local table_name = Sky.Config.framework == "esx" and "owned_vehicles" or "player_vehicles"
local mods_column = Sky.Config.framework == "esx" and "vehicle" or "mods"

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
    local garage = "Legion Square"

    if mods.class == 14 then
        garage = "Boats"
        vehicle_type = "boat"
    elseif mods.class == 15 or mods.class == 16 then
        garage = "Hangar"
        vehicle_type = "plane"
    end
    if Sky.Config.framework == "esx" then
        local player = ESX.GetPlayerFromId(source)
        Sky.Query('INSERT INTO owned_vehicles (owner, plate, vehicle, in_garage, garage_id, type) VALUES (@owner, @plate, @vehicle, @stored, @garage, @type)',
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
        Sky.Query('INSERT INTO player_vehicles (license, citizenid, vehicle, hash, mods, plate, in_garage, garage_id) VALUES (?, ?, ?, ?, ?, ?, ?, ?)', {
            player.PlayerData.license,
            player.PlayerData.citizenid,
            model,
            GetHashKey(model),
            json.encode(mods),
            plate,
            1,
            garage
        })
    end
    TriggerClientEvent("sky_base:client:giveVehicleKeys", source, plate, model)
end

function Sky.Functions.ChangePlate(old_plate, new_plate)
    Sky.Query("UPDATE " .. table_name .. " SET plate = ? WHERE plate = ?", { new_plate, old_plate })
    local rows = Sky.Query("SELECT * FROM " .. table_name .. " WHERE plate = ?", { new_plate })
    if not rows or not rows[1] then
        return
    end

    local row = rows[1]
    local mods_json = row[mods_column]

    local mods_ok, mods = pcall(json.decode, mods_json or "")
    if mods_ok and type(mods) == "table" then
        mods.plate = new_plate
        mods_json = json.encode(mods)
    end

    Sky.Query("UPDATE ".. table_name .. " SET ".. mods_column .." = ? WHERE plate = ?", {
        mods_json or row.mods,
        new_plate
    })
end
