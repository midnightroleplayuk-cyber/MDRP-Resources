if Sky.Config.helpnotify ~= "lation_ui" then return end

local RESOURCE = "lation_ui"

local last_message, last_key

function Sky.Functions.ShowHelpNotification(msg, key)
    Sky.Show.RegisterToggle("helpNotify", {
        key = key or "E",
        msg = msg or "",
        show = function(self)
            if last_message == self.msg and last_key == self.key then return end
            exports[RESOURCE]:showText({
                description = self.msg,
                keybind = self.key,
            })
            last_message, last_key = self.msg, self.key
        end,
        hide = function()
            exports[RESOURCE]:hideText()
            last_message, last_key = nil, nil
        end
    })
end
