if Sky.Config.helpnotify ~= "risk-notify" then return end

local RESOURCE = "risk-notify"

-- Risk's temporary prompt has no separate hide export.
function Sky.Functions.ShowHelpNotification(msg, key)
    exports[RESOURCE]:HelpNotify(key or "E", msg or "")
end
