if Sky.Config.notification ~= "wasabi_notify" then return end

local RESOURCE = "wasabi_notify"

function Sky.Functions.ShowNotification(title, message, type, time)
    if type == "warn" then type = "warning" end
    exports[RESOURCE]:notify(title or "", message or "", time or 5000, type or "info")
end
