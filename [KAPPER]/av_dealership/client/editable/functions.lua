function HasJob(job)
    return exports['av_laptop']:hasJob(job)
end

function Notify(title, message, ntype, duration, position)
    TriggerEvent('av_laptop:notificationUI', title, message, ntype or "info", duration, position)
end

function GiveKeys(vehicle, plates)
    if GetResourceState('qb-vehiclekeys') == "started" then
        TriggerServerEvent('qb-vehiclekeys:server:AcquireVehicleKeys', plates)
        return
    end
end

function SetFuel(vehicle)
    if GetResourceState('LegacyFuel') == "started" then
        exports['LegacyFuel']:SetFuel(vehicle, 100.0)
        return
    end
    SetVehicleFuelLevel(vehicle, 100.0)
end
