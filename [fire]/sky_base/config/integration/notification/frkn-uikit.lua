if Sky.Config.notification ~= "frkn-uikit" then return end

local RESOURCE = "frkn-uikit"

function Sky.Functions.ShowNotification(title, message, type, time)
    title, message = title or "", message or ""
    if type == "warn" then type = "warning" end
    if type == "inform" then type = "info" end
    type = type or "info"
    local text = message
    if title ~= "" then
        text = title .. (message ~= "" and ": " .. message or "")
    end
    exports[RESOURCE]:Notify(type, time or 5000, text)
end
