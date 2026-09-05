-- ──────────────────────────────────────────────────────────────────────────────
-- Integrations / Client / Notifications
-- ──────────────────────────────────────────────────────────────────────────────

--- @param message string  text to display
--- @param ntype   string  'inform' | 'success' | 'error' | 'warning'
--- @param time    number  duration in seconds
function sendNotify(message, ntype, time)
    message  = tostring(message or '')
    ntype    = ntype or 'inform'
    time     = time or ((Config and Config.Notify and Config.Notify.Duration) or 5)
    local ms = time * 1000

    local provider = (Config and Config.Notify and Config.Notify.Provider) or 'ox_lib'

    if provider == 'ox_lib' then
        if ntype == 'info' then ntype = 'inform' end
        lib.notify({
            description = message,
            duration    = ms,
            type        = ntype,
            position    = 'top-right',
        })
    elseif provider == 'op_hud' then
        TriggerEvent('op-hud:showNotification', ntype, time, message)
    elseif provider == 'okokNotify' then
        exports['okokNotify']:Alert('', message, ms, ntype)
    elseif provider == 'vms_notify' then
        exports['vms_notify']:Notification('Notify', message, time, '#5feb34', '')
    elseif provider == 'brutal_notify' then
        exports['brutal_notify']:SendAlert('Notify', message, ms, ntype, false)
    else
        TriggerEvent('chat:addMessage', { args = { 'OP Clothing', message } })
        if Config and Config.Debug then print(('[notify] %s'):format(message)) end
    end
end

RegisterNetEvent('op-clothing:client:sendNotify', function(message, ntype, time)
    sendNotify(message, ntype, time)
end)