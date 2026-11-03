if Sky.Config.helpnotify ~= "zenit_hud" then return end

local RESOURCE = "zenit_hud"

function Sky.Functions.ShowHelpNotification(msg, key)
    exports[RESOURCE]:showInteractionThisFrame(key, msg)
end
