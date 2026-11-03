Dispatch = Dispatch or {}

Dispatch['default'] = {
    alert = function(coords, message)
        TriggerServerEvent('hospital:server:ambulanceAlert', message)
    end
}
