-- Optional mission used by external Vehicle Theft script.
local isVehicleTheftMissionStarted = false

function startVehicleTheftMission()
    isVehicleTheftMissionStarted = true
    lib.alertDialog({
        header = TranslateIt('theftMission_header'),
        content = TranslateIt('theftMission_desc'),
        centered = true,
        cancel = false,
        labels = {
            confirm = TranslateIt('vehicleMission_alert_Okay')
        }
    })
end

RegisterNetEvent('op-crime:vehicleTheftMission')
AddEventHandler('op-crime:vehicleTheftMission', function()
    if not isVehicleTheftMissionStarted then return end

    sendNotify(TranslateIt('theftMissionEnd'), "success", 5)
    TriggerServerEvent('op-crime:endMission', "vehicleTheft")
    isVehicleTheftMissionStarted = false
end)