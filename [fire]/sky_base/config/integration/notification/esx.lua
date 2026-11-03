if Sky.Config.notification ~= "esx" then return end

local RESOURCE = "es_extended"

function Sky.Functions.ShowNotification(title, message, type, time)
    if type == "warn" then type = "warning" end
    local framework = ESX or exports[RESOURCE]:getSharedObject()
    framework.ShowNotification(message or "", type or "info", time or 5000, title or "")
end
