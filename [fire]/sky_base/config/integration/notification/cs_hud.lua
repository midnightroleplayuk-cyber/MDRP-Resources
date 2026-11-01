if Sky.Config.notification ~= "cs_hud" then return end

local RESOURCE = "cs_hud"

local types = { info = "primary", inform = "primary", warning = "primary", warn = "primary" }

function Sky.Functions.ShowNotification(title, message, type, time)
    title, message = title or "", message or ""
    type = types[type] or type or "primary"
    exports[RESOURCE]:Alert(title, message, time or 5000, type)
end
