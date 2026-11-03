if Sky.Config.notification ~= "brutal_notify" then return end

local RESOURCE = "brutal_notify"

function Sky.Functions.ShowNotification(title, message, type, time)
    title, message = title or "", message or ""
    if type == "warn" then type = "warning" end
    if type == "inform" then type = "info" end
    type = type or "info"
    exports[RESOURCE]:SendAlert(title, message, time or 5000, type, true)
end
