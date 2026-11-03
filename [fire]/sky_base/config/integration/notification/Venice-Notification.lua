if Sky.Config.notification ~= "Venice-Notification" then return end

local RESOURCE = "Venice-Notification"

local types = { success = "check", warn = "info", warning = "info", inform = "info" }

function Sky.Functions.ShowNotification(title, message, type, time)
    title, message = title or "", message or ""
    type = types[type] or type or "info"
    local text = message
    if title ~= "" then
        text = title .. (message ~= "" and ": " .. message or "")
    end
    exports[RESOURCE]:Notify(text, time or 5000, type)
end
