if Sky.Config.notification ~= "core_notify" then return end

local RESOURCE = "core_notify"

function Sky.Functions.ShowNotification(title, message, type, time)
    title, message = title or "", message or ""
    if type == "warn" then type = "warning" end
    if type == "inform" then type = "info" end
    type = type or "info"
    local text = message
    if title ~= "" then
        text = title .. (message ~= "" and ": " .. message or "")
    end
    exports[RESOURCE]:ShowNotification({ text = text, type = type, duration = time or 5000, flash = true })
end
