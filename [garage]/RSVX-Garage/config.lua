Config = {}

Config.Command = 'ems_garageadmin'
Config.AdminGroup = 'group.admin'

Config.RequireDuty = true
Config.HideLockedVehicles = true -- false shows vehicles above the player's grade as locked
Config.ReturnDistance = 40.0
Config.FuelLevel = 100

local function attempt(label, fn)
    local ok, result = pcall(fn)
    if not ok then print(('[RSVX_Garage] %s failed: %s'):format(label, result)) end
    return ok and result
end

-- Both run on the server. GiveKeys fires once the vehicle has its final plate, RemoveKeys when it is returned.
function Config.GiveKeys(source, vehicle, plate)
    if GetResourceState('qbx_vehiclekeys') == 'started' then
        attempt('qbx_vehiclekeys GiveKeys', function()
            exports.qbx_vehiclekeys:GiveKeys(source, vehicle)
        end)
    end

    if GetResourceState('Renewed-Vehiclekeys') == 'started' then
        local has = attempt('Renewed hasKey', function()
            return exports['Renewed-Vehiclekeys']:hasKey(source, plate)
        end)
        if not has then
            attempt('Renewed addKey', function()
                exports['Renewed-Vehiclekeys']:addKey(source, plate)
            end)
        end
    end
end

function Config.RemoveKeys(source, vehicle, plate)
    if GetResourceState('Renewed-Vehiclekeys') == 'started' then
        attempt('Renewed removeKey', function()
            exports['Renewed-Vehiclekeys']:removeKey(source, plate)
        end)
    elseif GetResourceState('qbx_vehiclekeys') == 'started' then
        attempt('qbx_vehiclekeys RemoveKeys', function()
            exports.qbx_vehiclekeys:RemoveKeys(source, vehicle, true)
        end)
    end
end
