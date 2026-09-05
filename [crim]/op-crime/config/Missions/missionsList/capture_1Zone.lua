local MS = MissionShared

local isCaptureMissionStarted = false

function startZoneCaptureMission()
    isCaptureMissionStarted = true
    lib.alertDialog({
        header = TranslateIt('captureMission_header'),
        content = TranslateIt('captureMission_desc'),
        centered = true,
        cancel = false,
        labels = { confirm = TranslateIt('vehicleMission_alert_Okay') }
    })
end

RegisterNetEvent('op-crime:zoneCaptured')
AddEventHandler('op-crime:zoneCaptured', function()
    if not isCaptureMissionStarted then return end
    sendNotify(TranslateIt('captureMissionEnd'), "success", 5)
    TriggerServerEvent('op-crime:endMission', "capture_1Zone")
    isCaptureMissionStarted = false
end)

