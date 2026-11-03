if Sky.Config.notification ~= "msk_core" then return end

local RESOURCE = "msk_core"

function Sky.Functions.ShowNotification(title, message, type, time)
    title, message = title or "", message or ""
    if type == "warn" then type = "warning" end
    if type == "inform" then type = "info" end
    type = type or "info"
    exports[RESOURCE]:Notification({ title = title, message = message, type = type, duration = time or 5000 })
end
