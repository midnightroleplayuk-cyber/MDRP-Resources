if Sky.Config.notification ~= "RxNotify" then return end

local RESOURCE = "RxNotify"

local types = { warning = "warn", inform = "info" }

function Sky.Functions.ShowNotification(title, message, type, time)
    title, message = title or "", message or ""
    type = types[type] or type or "info"
    exports[RESOURCE]:Notify(title, message, type, time or 5000)
end
