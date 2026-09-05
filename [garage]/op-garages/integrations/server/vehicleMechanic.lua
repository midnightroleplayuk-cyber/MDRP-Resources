local function trimPlate(plate)
    return tostring(plate or ""):match("^%s*(.-)%s*$") or ""
end

local function useOpMechanicMileage()
    return Config.MechanicScript == 'op-mechanic'
        and GetResourceState('op-mechanic') == 'started'
end

function GetOpMechanicMileageByPlate(plate)
    plate = trimPlate(plate)
    if plate == "" or not useOpMechanicMileage() then return nil end

    local ok, data = pcall(function()
        return exports['op-mechanic']:GetVehicleMileage(plate)
    end)

    if ok and type(data) == 'table' then
        return data
    end
    return nil
end

function ResolveGarageVehicleMileage(row)
    if not Config.Mileage or not Config.Mileage.Enable or type(row) ~= 'table' then
        return 0, Config.Mileage and Config.Mileage.DistanceUnit or 'Mi'
    end

    local defaultUnit = Config.Mileage.DistanceUnit or 'Mi'
    local plate = trimPlate(row.plate)

    if useOpMechanicMileage() and plate ~= '' then
        local data = GetOpMechanicMileageByPlate(plate)
        if data then
            local value = tonumber(data.odometer) or tonumber(data.mileageKm) or 0
            local unit = data.odometerUnit or defaultUnit
            return value, unit
        end

        local opCol = Config.Mileage.OpMechanicColumn or 'mileage_km'
        if row[opCol] ~= nil then
            return tonumber(row[opCol]) or 0, defaultUnit
        end
    end

    local col = Config.Mileage.DatabaseColumnName or 'mileage'
    if row[col] ~= nil then
        return tonumber(row[col]) or 0, defaultUnit
    end

    if row.drivingdistance ~= nil then
        return tonumber(row.drivingdistance) or 0, defaultUnit
    end

    return 0, defaultUnit
end

function EnrichGarageVehicleMileage(vehicles)
    if not Config.Mileage or not Config.Mileage.Enable or type(vehicles) ~= 'table' then
        return vehicles
    end

    for _, row in pairs(vehicles) do
        local value, unit = ResolveGarageVehicleMileage(row)
        row.garageMileage = value
        row.garageMileageUnit = unit
    end

    return vehicles
end

RegisterNetEvent('op-garages:ensureVehicleMileage', function(netId, modelName)
    if not useOpMechanicMileage() then return end
    netId = tonumber(netId)
    if not netId or netId == 0 then return end

    pcall(function()
        exports['op-mechanic']:EnsureVehicleMileage(netId, modelName)
    end)
end)

function NotifyMechanicPlateUpdated(oldPlate, newPlate)
    oldPlate = trimPlate(oldPlate)
    newPlate = trimPlate(newPlate)
    if oldPlate == "" or newPlate == "" or oldPlate == newPlate then return end

    if Config.MechanicScript == 'jg-mechanic' then
        pcall(function()
            exports['jg-mechanic']:vehiclePlateUpdated(oldPlate, newPlate)
        end)
    end
end