if Sky.Config.garage ~= "zyke_garages" then return end
if not IsDuplicityVersion() then return end

function Sky.Functions.IsPlateUsed(plate)
    local vin = exports["zyke_garages"]:ResolveVehicleVin(plate)
    return vin ~= nil
end

function Sky.Functions.GeneratePlate()
    -- Zyke handles plate generation internally.
    -- This only exists for compatibility with scripts expecting it.
    math.randomseed(GetGameTimer())

    local plate = string.upper(
        Sky.Math.GetRandomLetters(3) ..
        Sky.Math.GetRandomNumbers(3)
    )

    if Sky.Functions.IsPlateUsed(plate) then
        return Sky.Functions.GeneratePlate()
    end

    return plate
end

function Sky.Functions.GiveVehicle(source, model)
    local success, vehicle_data = exports["zyke_garages"]:GiveVehicle(model, source)

    if not success then
        print(("Sky Base: Failed to give vehicle (%s)"):format(vehicle_data))
        return false
    end

    return vehicle_data
end

function Sky.Functions.ChangePlate(old_plate, new_plate)
    local vin = exports["zyke_garages"]:ResolveVehicleVin(old_plate)

    if not vin then
        return false
    end

    exports["zyke_garages"]:SetFakePlate(
        vin,
        new_plate,
        true,
        false
    )

    return true
end
