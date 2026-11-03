local provider = Sky.Config.helpnotify
if provider ~= "ZSX_UIV2" and provider ~= "ZSX_UIV2_help" then return end

local RESOURCE = "ZSX_UIV2"

local last_message, last_key, serial

local function hide_hint()
    if provider == "ZSX_UIV2" then
        exports[RESOURCE]:TextUI_Remove(serial, false)
        serial = nil
    else
        exports[RESOURCE]:HelpNotification_Remove()
    end
    last_message, last_key = nil, nil
end

function Sky.Functions.ShowHelpNotification(msg, key)
    Sky.Show.RegisterToggle("helpNotify", {
        key = key or "E",
        msg = msg or "",
        show = function(self)
            if last_message == self.msg and last_key == self.key then return end
            if provider == "ZSX_UIV2" then
                if serial then exports[RESOURCE]:TextUI_Remove(serial, false) end
                serial = exports[RESOURCE]:TextUI(self.key, self.msg)
            else
                exports[RESOURCE]:HelpNotification({
                    icon = "fas fa-info-circle", header = "[" .. self.key .. "]", text = self.msg,
                })
            end
            last_message, last_key = self.msg, self.key
        end,
        hide = hide_hint,
    })
end

AddEventHandler("onResourceStop", function(resource)
    if resource == GetCurrentResourceName() and last_message ~= nil then hide_hint() end
end)
