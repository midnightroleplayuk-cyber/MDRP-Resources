if Sky.Config.notification ~= "sky_hud" then return end

local RESOURCE = "sky_hud"

function Sky.Functions.ShowNotification(title, message, type, time)
    exports[RESOURCE]:notify(title, message, type, time)
end
