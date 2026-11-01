if Sky.Config.notification ~= "qbox" then return end

local RESOURCE = "qbx_core"

local notification_types = { info = "inform", warn = "warning" }

function Sky.Functions.ShowNotification(title, message, type, time)
    exports[RESOURCE]:Notify({
        text = title or "",
        caption = message or "",
    }, notification_types[type] or type or "inform", time or 5000)
end
