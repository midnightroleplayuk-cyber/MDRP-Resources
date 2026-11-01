if Sky.Config.notification ~= "wasabi_uikit" then return end

local RESOURCE = "wasabi_uikit"

function Sky.Functions.ShowNotification(title, message, type, time)
    if type == "warn" then type = "warning" end
    exports[RESOURCE]:Notification(title or "", message or "", type or "info", time or 5000)
end
