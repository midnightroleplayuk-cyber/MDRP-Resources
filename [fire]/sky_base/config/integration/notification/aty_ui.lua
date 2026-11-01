if Sky.Config.notification ~= "aty_ui" then return end

local RESOURCE = "aty_ui"

local types = { warn = "info", warning = "info", inform = "info" }

function Sky.Functions.ShowNotification(title, message, type, time)
    title, message = title or "", message or ""
    type = types[type] or type or "info"
    exports[RESOURCE]:GetAtyUI().sendNotify(title, message, type, time or 5000)
end
