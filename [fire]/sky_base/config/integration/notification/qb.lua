if Sky.Config.notification ~= "qb" then return end

local RESOURCE = "qb-core"

local notification_types = { info = "primary", inform = "primary", warn = "warning" }

function Sky.Functions.ShowNotification(title, message, type, time)
    local framework = QBCore or exports[RESOURCE]:GetCoreObject()
    framework.Functions.Notify({
        text = title or "",
        caption = message or "",
    }, notification_types[type] or type or "primary", time or 5000)
end
