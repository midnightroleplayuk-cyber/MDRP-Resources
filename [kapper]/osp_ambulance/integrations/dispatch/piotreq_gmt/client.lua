Dispatch = Dispatch or {}

Dispatch['piotreq_gmt'] = {
    alert = function(coords, message)
        TriggerServerEvent('hospital:server:ambulanceAlert', message)
    end
}
