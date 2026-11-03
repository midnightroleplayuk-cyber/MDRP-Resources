if Sky.Config.notification ~= "prims_hud" then return end

local RESOURCE = "prims_hud"

function Sky.Functions.ShowNotification(title, message, type, time)
    title, message = title or "", message or ""
    if type == "warn" then type = "warning" end
    if type == "inform" then type = "info" end
    type = type or "info"
    local text = message
    if title ~= "" then
        text = title .. (message ~= "" and ": " .. message or "")
    end
    exports[RESOURCE]:prims_Notification_show({ msg = text, type = type, time = time or 5000 })
end
