if Sky.Config.helpnotify ~= "msk_core" then return end

local RESOURCE = "msk_core"

local last_message, last_key

function Sky.Functions.ShowHelpNotification(msg, key)
    Sky.Show.RegisterToggle("helpNotify", {
        key = key or "E",
        msg = msg or "",
        show = function(self)
            if last_message == self.msg and last_key == self.key then return end
            exports[RESOURCE]:ShowTextUI({ key = self.key, text = self.msg })
            last_message, last_key = self.msg, self.key
        end,
        hide = function()
            exports[RESOURCE]:HideTextUI()
            last_message, last_key = nil, nil
        end
    })
end
