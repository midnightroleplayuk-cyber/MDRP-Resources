-- Implement this client-side adapter, then set Config.notification = "custom".
if Sky.Config.notification ~= "custom" then return end

function Sky.Functions.ShowNotification(title, message, type, time)
    title, message = title or "", message or ""
    type, time = type or "info", time or 5000
    -- Replace the error with your notification export.
    -- Public types: info, success, error, warning. Duration is in milliseconds.
    error("Custom notification integration: ShowNotification is not implemented")
end
