if Sky.Config.helpnotify ~= "custom" then return end

-- Implement both callbacks below, then set Config.helpnotify = "custom".
local last_message, last_key

function Sky.Functions.ShowHelpNotification(msg, key)
    Sky.Show.RegisterToggle("helpNotify", {
        key = key or "E",
        msg = msg or "",
        show = function(self)
            if last_message == self.msg and last_key == self.key then return end
            -- Replace with your persistent UI's show/update export.
            -- self.msg is the description; self.key is the displayed key.
            error("Custom help notification integration: show is not implemented")
            last_message, last_key = self.msg, self.key
        end,
        hide = function()
            -- Replace with your UI's hide export.
            error("Custom help notification integration: hide is not implemented")
            last_message, last_key = nil, nil
        end
    })
end
