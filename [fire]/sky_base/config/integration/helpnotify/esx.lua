if Sky.Config.helpnotify ~= "esx" then return end

local RESOURCE = "es_extended"

-- Uses the framework TextUI hooks (normally backed by esx_textui).
local last_message, last_key

function Sky.Functions.ShowHelpNotification(msg, key)
    Sky.Show.RegisterToggle("helpNotify", {
        key = key or "E",
        msg = msg or "",
        show = function(self)
            if last_message == self.msg and last_key == self.key then return end
            local framework = ESX or exports[RESOURCE]:getSharedObject()
            framework.TextUI("[" .. self.key .. "] " .. self.msg, "info")
            last_message, last_key = self.msg, self.key
        end,
        hide = function()
            local framework = ESX or exports[RESOURCE]:getSharedObject()
            framework.HideUI()
            last_message, last_key = nil, nil
        end
    })
end
