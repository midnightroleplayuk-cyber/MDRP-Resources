Dispatch = Dispatch or {}

Dispatch['lb-tablet'] = {
    alert = function(coords, message)
        -- Don't use the clientside export! lb-scripts provide use serverside exports
        TriggerServerEvent('hospital:server:ambulanceAlert', message)
    end
}
