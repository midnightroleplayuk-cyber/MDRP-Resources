notifyMe = false

RegisterNUICallback('notifications', function(data,cb)
    notifyMe = data
    if notifyMe then
        TriggerEvent("av_laptop:notification", Lang['app_title'],Lang['notifications_on'], "success")
    else
        TriggerEvent("av_laptop:notification", Lang['app_title'],Lang['notifications_off'], "error")
    end
    cb('ok')
end)

RegisterNetEvent('av_racing:newRace', function(event)
    if notifyMe and not exports['av_laptop']:isCop() then
        TriggerEvent('av_laptop:notification',Lang['app_title'],Lang['new_event'])
    end
    if LocalPlayer.state.inLaptop then
        exports['av_laptop']:postMessage('newEvent', event)
    else
        if inAdminPanel then
            SendNUIMessage({
                action = "newEvent",
                data = event
            })
        end
    end
end)

RegisterNetEvent('av_racing:notifications', function(state)
    notifyMe = state
end)

if Config.NotificationsCommand then
    RegisterCommand(Config.NotificationsCommand, function() -- Forgot to remove notifications and player doesn't own a laptop item anymore?
        notifyMe = false
    end,false)
end