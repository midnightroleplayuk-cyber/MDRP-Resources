if Sky.Config.helpnotify ~= "default" then return end

local last_message, last_key
local help_notification = {
    show = function(self)
        if last_message == self.msg and last_key == self.key then return end
        last_message, last_key = self.msg, self.key
        SendNUIMessage({
            sort = "showE",
            title = self.msg,
            letter = self.key,
        })
    end,
    hide = function()
        last_message, last_key = nil, nil
        SendNUIMessage({
            sort = "hideE",
        })
    end
}

function Sky.Functions.ShowHelpNotification(msg, key)
    help_notification.key, help_notification.msg = key or "E", msg or ""
    Sky.Show.RegisterToggle("helpNotify", help_notification)
end
