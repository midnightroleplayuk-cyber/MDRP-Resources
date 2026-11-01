if Sky.Config.notification ~= "zenit_hud" then return end

local RESOURCE = "zenit_hud"

function Sky.Functions.ShowNotification(title, message, type, time)
    exports[RESOURCE]:showNotify(title, message, type, time)
end
