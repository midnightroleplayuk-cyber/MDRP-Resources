-- Sends prison alerts to Vinewood Dispatch:
--   exports.vinewood_dispatch:CreateAlert({ code, title, description, coords = vec3, jobs = { 'police' }, priority = 1-3, source = 'vinewood_prison' })
Prison.adapters.dispatch = Prison.adapters.dispatch or {}
Prison.adapters.dispatch.vinewood_dispatch = {
    resource = 'vinewood_dispatch',
    alert = function(alert)
        local ok, err = pcall(function() exports.vinewood_dispatch:CreateAlert(alert) end)
        if not ok then Prison.warn('vinewood_dispatch CreateAlert failed: %s', err) end
    end,
}
