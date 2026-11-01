if Sky.Config.notification ~= "codem-supreme-notification" then return end

local RESOURCE = "codem-supreme-notification"

local types = { warn = "info", warning = "info", inform = "info" }

function Sky.Functions.ShowNotification(title, message, type, time)
    title, message = title or "", message or ""
    type = types[type] or type or "info"
    local text = message
    if title ~= "" then
        text = title .. (message ~= "" and ": " .. message or "")
    end
    exports[RESOURCE]:Notify(type, text, time or 5000)
end
