if Sky.Config.helpnotify ~= "prims_hud" then return end

local RESOURCE = "prims_hud"

local last_message, last_key

function Sky.Functions.ShowHelpNotification(msg, key)
    Sky.Show.RegisterToggle("helpNotify", {
        key = key or "E",
        msg = msg or "",
        show = function(self)
            if last_message == self.msg and last_key == self.key then return end
            exports[RESOURCE]:prims_keybind_show({ key = self.key, title = self.msg, description = "" })
            last_message, last_key = self.msg, self.key
        end,
        hide = function()
            exports[RESOURCE]:prims_keybind_hide()
            last_message, last_key = nil, nil
        end
    })
end
