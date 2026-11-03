if Sky.Config.notification ~= "17mov_Hud" then return end

local RESOURCE = "17mov_Hud"

local types = { warn = "info", warning = "info", inform = "info" }

function Sky.Functions.ShowNotification(title, message, type, time)
    title, message = title or "", message or ""
    type = types[type] or type or "info"
    exports[RESOURCE]:ShowNotification(message, type, title, time or 5000)
end
