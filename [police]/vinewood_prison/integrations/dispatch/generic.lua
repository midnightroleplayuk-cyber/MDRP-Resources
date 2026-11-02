-- Fallback: a server event any dispatch script can listen for.
--   AddEventHandler('vinewood_prison:dispatch', function(alert) ... end)
Prison.adapters.dispatch = Prison.adapters.dispatch or {}
Prison.adapters.dispatch.generic = {
    fallback = true,
    alert = function(alert)
        TriggerEvent('vinewood_prison:dispatch', alert)
    end,
}
