if Sky.Config.notification ~= "esx_notify" then return end

local RESOURCE = "esx_notify"

function Sky.Functions.ShowNotification(title, message, type, time)
    if type == "warn" then type = "warning" end
    -- esx_notify takes duration before message (see the provider's Notify.lua).
    exports[RESOURCE]:Notify(type or "info", time or 5000, message or "", title or "")
end
