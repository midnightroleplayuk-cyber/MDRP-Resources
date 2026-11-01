if Sky.Config.garage ~= "op" then return end
if not IsDuplicityVersion() then return end

local resource_version = GetResourceMetadata("op-garages", "version", 0)
local major_version = type(resource_version) == "string"
    and tonumber(resource_version:match("^v?(%d+)"))
    or nil

if not major_version or major_version < 3 then
    return
end

local table_name = Sky.Config.framework == "esx" and "owned_vehicles" or "player_vehicles"

local function has_restriction(access)
    return type(access) == "table"
        and type(access.name) == "string"
        and access.name ~= ""
end

local function resolve_default_garage()
    local garages = exports["op-garages"]:getAllGarages()
    local selected_index

    for key, garage in pairs(garages or {}) do
        if type(garage) == "table" then
            local garage_type = string.lower(tostring(garage.Type or ""))
            local is_private = garage.IsPrivate == true or tonumber(garage.IsPrivate) == 1
            local is_restricted = has_restriction(garage.Job) or has_restriction(garage.Gang)

            if garage_type == "car" and not is_private and not is_restricted then
                local garage_index = garage.Index or key
                if selected_index == nil
                    or tostring(garage_index) < tostring(selected_index) then
                    selected_index = garage_index
                end
            end
        end
    end

    if selected_index == nil then
        Sky.Debug(
            "error",
            "[OP Garages V3] No public, unrestricted car garage is configured"
        )
    end

    return selected_index
end

function Sky.Functions.IsPlateUsed(plate)
    local result = Sky.Query(
        "SELECT plate FROM " .. table_name .. " WHERE plate = ? LIMIT 1",
        { plate }
    )
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
    local garage_index = resolve_default_garage()
    if garage_index == nil then
        return false
    end

    local plate = Sky.Functions.GeneratePlate()
    local hash = joaat(model)
    local vehicle_data = {
        plate = plate,
        model = hash,
        hash = hash
    }

    if Sky.Config.framework == "esx" then
        Sky.Query([[
            INSERT INTO owned_vehicles
                (owner, plate, vehicle, type, stored, vehicleGarage, isTowedOut)
            VALUES
                (?, ?, ?, ?, ?, ?, ?)
        ]], {
            Sky.FW.GetIdentifier(source),
            plate,
            json.encode(vehicle_data),
            "car",
            0,
            garage_index,
            0
        })
    elseif Sky.Config.framework == "qb" or Sky.Config.framework == "qbox" then
        local citizen_id = Sky.FW.GetIdentifier(source)
        local player = Sky.Query(
            "SELECT license FROM players WHERE citizenid = ? LIMIT 1",
            { citizen_id }
        )[1]

        if not player or not player.license then
            Sky.Debug(
                "error",
                "[OP Garages V3] Cannot give vehicle because the player license was not found"
            )
            return false
        end

        Sky.Query([[
            INSERT INTO player_vehicles
                (license, citizenid, vehicle, hash, mods, plate, state, garage, vehicleGarage, isTowedOut)
            VALUES
                (?, ?, ?, ?, ?, ?, ?, ?, ?, ?)
        ]], {
            player.license,
            citizen_id,
            model,
            hash,
            json.encode(vehicle_data),
            plate,
            0,
            tostring(garage_index),
            garage_index,
            0
        })
    else
        Sky.Debug(
            "error",
            "[OP Garages V3] Only ESX, QBCore, and Qbox are supported"
        )
        return false
    end

    TriggerClientEvent("sky_base:client:giveVehicleKeys", source, plate, model)
    return true
end

function Sky.Functions.ChangePlate(old_plate, new_plate)
    Sky.Query(
        "UPDATE " .. table_name .. " SET plate = ? WHERE plate = ?",
        { new_plate, old_plate }
    )
end
