if Sky.Config.helpnotify ~= "qs-textui" then return end

local RESOURCE = "qs-textui"

local last_message, last_key

function Sky.Functions.ShowHelpNotification(msg, key)
    Sky.Show.RegisterToggle("helpNotify", {
        key = key or "E",
        msg = msg or "",
        show = function(self)
            if last_message == self.msg and last_key == self.key then return end
            local text = "[" .. self.key .. "] " .. self.msg
            if last_message == nil then
                exports[RESOURCE]:displayTextUI(text, "left")
            else
                exports[RESOURCE]:changeText(text, "left")
            end
            last_message, last_key = self.msg, self.key
        end,
        hide = function()
            exports[RESOURCE]:hideTextUI()
            last_message, last_key = nil, nil
        end
    })
end
