if Sky.Config.helpnotify ~= "ox_lib" then return end

local RESOURCE = "ox_lib"

local last_message, last_key

function Sky.Functions.ShowHelpNotification(msg, key)
    Sky.Show.RegisterToggle("helpNotify", {
        key = key or "E",
        msg = msg or "",
        show = function(self)
            if last_message == self.msg and last_key == self.key then return end
            exports[RESOURCE]:showTextUI("[" .. self.key .. "] " .. self.msg)
            last_message, last_key = self.msg, self.key
        end,
        hide = function()
            exports[RESOURCE]:hideTextUI()
            last_message, last_key = nil, nil
        end
    })
end
