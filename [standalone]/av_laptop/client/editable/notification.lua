-- Notification
RegisterNetEvent('av_laptop:notification', function(title, description, type, time, position)
    if LocalPlayer.state.inLaptop then
        local id = lib.string.random(".....")
        SendNUIMessage({
            action = "notification",
            data = {
                title = title,
                msg = description,
                type = type,
                id = id,
                time = time or 5000
            }
        })
        return
    end
    if Config.UIlib == "lation_ui" and GetResourceState("lation_ui") == "started" then
        return exports.lation_ui:notify({
            title = title,
            message = description,
            type = type,
            position = position,
            duration = time,
        })
    end
    lib.notify({
        title = title,
        description = description,
        type = type,
        position = position,
        duration = time
    })
end)