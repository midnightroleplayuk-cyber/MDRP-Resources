if Sky.Config.helpnotify ~= "codem-supreme-hud" then return end

local RESOURCE = "codem-supreme-hud"

local last_message, last_key

function Sky.Functions.ShowHelpNotification(msg, key)
    Sky.Show.RegisterToggle("helpNotify", {
        key = key or "E",
        msg = msg or "",
        show = function(self)
            if last_message == self.msg and last_key == self.key then return end
            exports[RESOURCE]:ShowTextUI(self.msg, { key = self.key })
            last_message, last_key = self.msg, self.key
        end,
        hide = function()
            exports[RESOURCE]:HideTextUI()
            last_message, last_key = nil, nil
        end
    })
end
