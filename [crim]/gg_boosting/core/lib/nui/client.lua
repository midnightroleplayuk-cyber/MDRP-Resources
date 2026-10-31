gg.nui = gg.nui or {}

gg.nui.emit = function(event, data)
    SendNUIMessage({
        action  = event,
        data = data,
    })
end

gg.nui.toggle = function(bool, focus)
    focus = focus or {}
    SetNuiFocus(focus[1] or bool, focus[2] or bool)
end

RegisterNUICallback('hideUI', function(_, cb)
    gg.player.ToggleTablet(false)
    TriggerEvent(GetCurrentResourceName().."client:forcecloseui")
    gg.nui.toggle(false, false)
    cb({})
end)