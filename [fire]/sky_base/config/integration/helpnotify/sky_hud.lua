if Sky.Config.helpnotify ~= "sky_hud" then return end

local RESOURCE = "sky_hud"

function Sky.Functions.ShowHelpNotification(msg, key)
    exports[RESOURCE]:pressE(msg, key)
end
