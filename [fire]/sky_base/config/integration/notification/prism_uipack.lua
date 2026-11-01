if Sky.Config.notification ~= "prism_uipack" then return end

local RESOURCE = "prism_uipack"

function Sky.Functions.ShowNotification(title, message, type, time)
    title, message = title or "", message or ""
    if type == "warn" then type = "warning" end
    if type == "inform" then type = "info" end
    type = type or "info"
    exports[RESOURCE]:Notify({ title = title, description = message, type = type, duration = time or 5000 })
end
