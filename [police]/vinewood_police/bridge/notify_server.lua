--- Sends a notification to a player. kind: 'inform' | 'success' | 'error' | 'warning'
function VPO.Notify(src, message, kind, duration)
    if not src or src == 0 then
        print(('[%s] %s'):format(VPO.Resource, message))
        return
    end
    TriggerClientEvent(VPO.Events.notify, src, message, kind or 'inform', duration)
end
