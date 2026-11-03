if Sky.Config.notification ~= "rtx_notify" then return end

local RESOURCE = "rtx_notify"

function Sky.Functions.ShowNotification(title, message, type, time)
    title, message = title or "", message or ""
    if type == "warn" then type = "warning" end
    if type == "inform" then type = "info" end
    type = type or "info"
    exports[RESOURCE]:Notify(title, message, time or 5000, type)
end
