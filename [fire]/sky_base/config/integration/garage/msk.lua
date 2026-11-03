if Sky.Config.garage ~= "msk" then return end
if not IsDuplicityVersion() then return end

if Sky.Config.framework ~= "esx" then
    error("MSK Garage integration only supports ESX.")
end

-- Keep these ids aligned with the defaults configured in the MSK Garage dashboard.
local default_garages = {
    land = "A",
    sea = "boat_A",
    air = "heli_A"
}

local function get_vehicle_storage(class)
    if class == 8 or class == 13 then
        return "bike", default_garages.land
    elseif class == 14 then
        return "boat", default_garages.sea
    elseif class == 15 then
        return "helicopter", default_garages.air
    elseif class == 16 then
        return "plane", default_garages.air
    elseif class == 20 then
        return "truck", default_garages.land
    end

    return "car", default_garages.land
end

function Sky.Functions.IsPlateUsed(plate)
    local result = Sky.Query("SELECT plate FROM owned_vehicles WHERE plate = ?", { plate })
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
    local vehicle_data = Sky.Cb.Trigger("sky_base:getVehicleMods", source, model)
    local vehicle_type, garage = get_vehicle_storage(vehicle_data.class)

    vehicle_data.model = joaat(model)
    vehicle_data.hash = vehicle_data.model
    vehicle_data.plate = plate

    Sky.Query(
        "INSERT INTO owned_vehicles (owner, plate, vehicle, type, job, stored, garage, fuel) VALUES (?, ?, ?, ?, ?, ?, ?, ?)",
        {
            Sky.FW.GetIdentifier(source),
            plate,
            json.encode(vehicle_data),
            vehicle_type,
            "civ",
            1,
            garage,
            100
        }
    )

    TriggerClientEvent("sky_base:client:giveVehicleKeys", source, plate, model)
    return plate
end

function Sky.Functions.ChangePlate(old_plate, new_plate)
    local rows = Sky.Query("SELECT vehicle FROM owned_vehicles WHERE plate = ?", { old_plate })
    if not rows[1] then
        Sky.Debug("warn", "[MSK Garage] Cannot change an unknown vehicle plate: " .. tostring(old_plate))
        return false
    end

    local decoded, vehicle_data = pcall(json.decode, rows[1].vehicle)
    if not decoded or type(vehicle_data) ~= "table" then
        Sky.Debug("error", "[MSK Garage] Cannot change plate because the vehicle properties are invalid: " .. tostring(old_plate))
        return false
    end

    vehicle_data.plate = new_plate
    Sky.Query(
        "UPDATE owned_vehicles SET plate = ?, vehicle = ? WHERE plate = ?",
        { new_plate, json.encode(vehicle_data), old_plate }
    )

    if Sky.Config.vehiclekeys == "msk" and GetResourceState("msk_vehiclekeys") == "started" then
        exports["msk_vehiclekeys"]:ChangeNumberPlate(old_plate, new_plate, false)
    end

    return true
end
