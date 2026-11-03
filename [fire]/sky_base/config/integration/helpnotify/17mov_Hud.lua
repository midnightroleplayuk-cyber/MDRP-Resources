if Sky.Config.helpnotify ~= "17mov_Hud" then return end

local RESOURCE = "17mov_Hud"

local last_message, last_key

function Sky.Functions.ShowHelpNotification(msg, key)
    Sky.Show.RegisterToggle("helpNotify", {
        key = key or "E",
        msg = msg or "",
        show = function(self)
            if last_message == self.msg and last_key == self.key then return end
            exports[RESOURCE]:ShowHelpNotification("[" .. self.key .. "] " .. self.msg)
            last_message, last_key = self.msg, self.key
        end,
        hide = function()
            exports[RESOURCE]:HideHelpNotification()
            last_message, last_key = nil, nil
        end
    })
end
