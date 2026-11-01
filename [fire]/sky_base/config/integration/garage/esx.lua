if Sky.Config.garage ~= "esx" then return end
if not IsDuplicityVersion() then return end

function Sky.Functions.IsPlateUsed(plate)
    local result = Sky.Query('SELECT plate FROM owned_vehicles WHERE plate = ?', {plate})
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
    local vehicle_type = "car"
    if mods.class == 14 then
        vehicle_type = "boat"
    elseif mods.class == 15 or mods.class == 16 then
        vehicle_type = "air"
    end

    local player = ESX.GetPlayerFromId(source)
    Sky.Query('INSERT INTO owned_vehicles (owner, plate, vehicle, type, stored) VALUES (@owner, @plate, @vehicle, @type, @stored)',
    {
        ['@owner'] = player.identifier,
        ['@plate'] = plate,
        ['@vehicle'] = json.encode({ model = GetHashKey(model), hash = GetHashKey(model), plate = plate }),
        ['@type'] = vehicle_type,
        ['@stored'] = 1
    })
end

function Sky.Functions.ChangePlate(old_plate, new_plate)
    Sky.Query('UPDATE owned_vehicles SET plate = @newPlate WHERE plate = @oldPlate', {
        ['@newPlate'] = new_plate,
        ['@oldPlate'] = old_plate
    })
end
