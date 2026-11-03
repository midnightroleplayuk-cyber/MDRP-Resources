if Sky.Config.helpnotify ~= "codem-textui" then return end

local RESOURCE = "codem-textui"

local theme = "thema-1" -- Change this to the desired installed mTextUI theme.
local last_message, last_key

function Sky.Functions.ShowHelpNotification(msg, key)
    Sky.Show.RegisterToggle("helpNotify", {
        key = key or "E",
        msg = msg or "",
        show = function(self)
            if last_message == self.msg and last_key == self.key then return end
            exports[RESOURCE]:OpenTextUI(self.msg, self.key, theme)
            last_message, last_key = self.msg, self.key
        end,
        hide = function()
            exports[RESOURCE]:CloseTextUI()
            last_message, last_key = nil, nil
        end
    })
end
