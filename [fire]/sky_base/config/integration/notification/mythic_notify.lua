if Sky.Config.notification ~= "mythic_notify" then return end

local RESOURCE = "mythic_notify"

-- Mythic's documented styles are inform, success and error.
local notification_types = { info = "inform", warning = "inform", warn = "inform" }

function Sky.Functions.ShowNotification(title, message, type, time)
    local text = message or ""
    if title and title ~= "" then
        text = title .. (text ~= "" and (": " .. text) or "")
    end
    exports[RESOURCE]:DoCustomHudText(notification_types[type] or type or "inform", text, time or 5000)
end
