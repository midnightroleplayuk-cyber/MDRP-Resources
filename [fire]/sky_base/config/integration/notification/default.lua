if Sky.Config.notification ~= "default" then return end

local notification_positions = {
    ["top-left"] = true,
    ["top-center"] = true,
    ["top-right"] = true,
    ["middle-left"] = true,
    ["middle-right"] = true,
    ["bottom-left"] = true,
    ["bottom-center"] = true,
    ["bottom-right"] = true,
}

assert(
    notification_positions[Sky.Config.notificationPosition],
    ("Config.notificationPosition has invalid value '%s'"):format(tostring(Sky.Config.notificationPosition))
)

function Sky.Functions.ShowNotification(title, message, type, time)
    if type == nil then
        type = "info"
    end

    if type == "warning" then
        type = "warn"
    end

    SendNUIMessage({
        sort = "notify",
        title = title or "",
        msg = message or "",
        color = type,
        time = time or 5000,
        position = Sky.Config.notificationPosition,
    })
end
