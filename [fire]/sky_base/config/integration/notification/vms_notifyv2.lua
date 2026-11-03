if Sky.Config.notification ~= "vms_notifyv2" then return end

local RESOURCE = "vms_notifyv2"

-- VMS accepts explicit colors/icons instead of a severity argument.
local styles = {
    info = { color = "#3b82f6", icon = "fa-solid fa-circle-info" },
    success = { color = "#22c55e", icon = "fa-solid fa-circle-check" },
    error = { color = "#ef4444", icon = "fa-solid fa-circle-xmark" },
    warning = { color = "#f59e0b", icon = "fa-solid fa-triangle-exclamation" },
}

function Sky.Functions.ShowNotification(title, message, type, time)
    title, message = title or "", message or ""
    if type == "warn" then type = "warning" end
    if type == "inform" then type = "info" end
    type = type or "info"
    local style = styles[type] or styles.info
    exports[RESOURCE]:Notification({
        title = title,
        description = message,
        time = time or 5000,
        color = style.color,
        icon = style.icon,
    })
end
