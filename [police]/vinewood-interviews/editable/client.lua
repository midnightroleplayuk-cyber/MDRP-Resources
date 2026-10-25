--[[
    Open client file: not encrypted by escrow. Swap the notification system here.
]]
Editable = Editable or {}

--- On-screen notification. kind: 'inform' | 'success' | 'warning' | 'error'
function Editable.Notify(message, kind, duration)
    lib.notify({
        title = Config.Text.title,
        description = message,
        type = kind or 'inform',
        duration = duration,
    })
end
