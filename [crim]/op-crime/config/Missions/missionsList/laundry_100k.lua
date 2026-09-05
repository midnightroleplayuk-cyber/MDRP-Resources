local MS = MissionShared

local totalLaundred = 0
local isLaundryMissionStarted = false

function startLaundryMission()
    SetNewWaypoint(Config.MoneyLaundry.laundryMisc.location.x, Config.MoneyLaundry.laundryMisc.location.y)
    isLaundryMissionStarted = true

    lib.alertDialog({
        header = TranslateIt('laundryMission_header'),
        content = TranslateIt('laundryMission_desc'),
        centered = true,
        cancel = false,
        labels = { confirm = TranslateIt('vehicleMission_alert_Okay') }
    })
end

RegisterNetEvent('op-crime:laundryMoney')
AddEventHandler('op-crime:laundryMoney', function(amount)
    if not isLaundryMissionStarted then return end

    totalLaundred = totalLaundred + amount
    if totalLaundred >= 100000 then
        sendNotify(TranslateIt('laundryMissionEnd'), "success", 5)
        TriggerServerEvent('op-crime:endMission', "laundry_100k")
        isLaundryMissionStarted = false
        totalLaundred = 0
    end
end)

