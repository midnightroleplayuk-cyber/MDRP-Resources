if Sky.Config.helpnotify ~= "wasabi_uikit" then return end

local RESOURCE = "wasabi_uikit"

local last_message, last_key

function Sky.Functions.ShowHelpNotification(msg, key)
    Sky.Show.RegisterToggle("helpNotify", {
        key = key or "E",
        msg = msg or "",
        show = function(self)
            if last_message == self.msg and last_key == self.key then return end
            if last_message == nil then
                exports[RESOURCE]:OpenTextUI(self.msg, self.key)
            else
                exports[RESOURCE]:ChangeTextUI(self.msg, self.key)
            end
            last_message, last_key = self.msg, self.key
        end,
        hide = function()
            exports[RESOURCE]:CloseTextUI()
            last_message, last_key = nil, nil
        end
    })
end
