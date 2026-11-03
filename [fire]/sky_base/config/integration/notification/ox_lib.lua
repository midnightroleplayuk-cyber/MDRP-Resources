if Sky.Config.notification ~= "ox_lib" then return end

local RESOURCE = "ox_lib"

local notification_types = { info = "inform", warn = "warning" }

function Sky.Functions.ShowNotification(title, message, type, time)
    exports[RESOURCE]:notify({
        title = title or "",
        description = message or "",
        type = notification_types[type] or type or "inform",
        duration = time or 5000,
    })
end
