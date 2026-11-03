if Sky.Config.garage ~= "my" then return end
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

    mods = mods or {}
    mods.plate = plate

    local player = ESX.GetPlayerFromId(source)

    Sky.Query('INSERT INTO owned_vehicles (owner, plate, vehicle, stored) VALUES (@owner, @plate, @vehicle, @stored)', {
        ['@owner'] = player.identifier,
        ['@plate'] = plate,
        ['@vehicle'] = json.encode(mods),
        ['@stored'] = 1
    })
end

function Sky.Functions.ChangePlate(old_plate, new_plate)
    Sky.Query('UPDATE owned_vehicles SET plate = @newPlate WHERE plate = @oldPlate', {
        ['@newPlate'] = new_plate,
        ['@oldPlate'] = old_plate
    })
end
