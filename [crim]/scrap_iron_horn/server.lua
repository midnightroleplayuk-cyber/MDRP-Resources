-- Vinewood Studios :: Scrap Iron Horn (server relay)

local COOLDOWN_MS = 6500  -- matches client HORN_DURATION_MS
local lastTrigger = {}

RegisterNetEvent('scrapiron:trigger', function(netId)
    local src = source
    local now = GetGameTimer()

    if lastTrigger[src] and (now - lastTrigger[src]) < COOLDOWN_MS then
        return
    end
    lastTrigger[src] = now

    if type(netId) ~= 'number' or netId <= 0 then return end

    TriggerClientEvent('scrapiron:play', -1, netId)
end)

AddEventHandler('playerDropped', function()
    lastTrigger[source] = nil
end)
