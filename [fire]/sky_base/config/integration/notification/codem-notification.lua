if Sky.Config.notification ~= "codem-notification" then return end

-- Explicit event exception for CodeM mNotification; its public API documents no export.
local types = { warn = "info", warning = "info", inform = "info", primary = "info" }

function Sky.Functions.ShowNotification(title, message, type, time)
    type = types[type] or type or "info"
    TriggerEvent("codem-notification:Create", message or "", type, title or "", time or 5000)
end
