if Sky.Config.garage ~= "hex" then return end
if not IsDuplicityVersion() then return end

function Sky.Functions.IsPlateUsed(plate)
    local result = Sky.Query('SELECT plate FROM owned_vehicles WHERE plate = ?', {plate})
    return result[1] ~= nil
end

function Sky.Functions.GeneratePlate()
    math.randomseed(GetGameTimer())
    local plate = string.upper(Sky.Math.GetRandomLetters(3)..' '..Sky.Math.GetRandomNumbers(3))

    if Sky.Functions.IsPlateUsed(plate) then
        return Sky.Functions.GeneratePlate()
    end

    return plate
end

function Sky.Functions.GiveVehicle(source, model)
    local plate = Sky.Functions.GeneratePlate()
    local vehicle_data = Sky.Cb.Trigger("sky_base:getVehicleMods", source, model)

    local vehicle_type = "car"
    if vehicle_data.class == 14 then
        vehicle_type = "boat"
    elseif vehicle_data.class == 15 or vehicle_data.class == 16 then
        vehicle_type = "air"
    end

    vehicle_data.model = joaat(model)
    vehicle_data.hash = vehicle_data.model
    vehicle_data.plate = plate
    vehicle_data.fuelLevel = 100

    local player = ESX.GetPlayerFromId(source)
    Sky.Query('INSERT INTO owned_vehicles (owner, plate, vehicle, type, stored, job) VALUES (@owner, @plate, @vehicle, @type, @stored, @job)',
    {
        ['@owner'] = player.identifier,
        ['@plate'] = plate,
        ['@vehicle'] = json.encode(vehicle_data),
        ['@type'] = vehicle_type,
        ['@stored'] = 1,
        ['@job'] = 'civ',
    })
end

function Sky.Functions.ChangePlate(old_plate, new_plate)
    local rows = Sky.Query("SELECT vehicle FROM owned_vehicles WHERE plate = ?", { old_plate })
    if not rows[1] then
        Sky.Debug("warn", "[HEX Garage] Cannot change plate because the old plate does not exist: " .. tostring(old_plate))
        return false
    end

    local decoded, vehicle_data = pcall(json.decode, rows[1].vehicle)
    if not decoded or type(vehicle_data) ~= "table" then
        Sky.Debug("error", "[HEX Garage] Cannot change plate because the vehicle properties are invalid: " .. tostring(old_plate))
        return false
    end

    vehicle_data.plate = new_plate
    Sky.Query(
        "UPDATE owned_vehicles SET plate = ?, vehicle = ? WHERE plate = ?",
        { new_plate, json.encode(vehicle_data), old_plate }
    )
end
