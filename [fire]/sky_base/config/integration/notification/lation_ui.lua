if Sky.Config.notification ~= "lation_ui" then return end

local RESOURCE = "lation_ui"

function Sky.Functions.ShowNotification(title, message, type, time)
    if type == "warn" then type = "warning" end
    exports[RESOURCE]:notify({
        title = title or "",
        message = message or "",
        type = type or "info",
        duration = time or 5000,
    })
end
