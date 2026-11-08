local currentZone
-- "You're on ... turf" notices come from the server (server/systems/hexes.lua), which knows every hex.

CreateThread(function()
    Wait(5000) -- don't announce the area you spawn in before the gang data has arrived
    currentZone = Zones.FromCoords(GetEntityCoords(cache.ped))
    while true do
        local zone = Zones.FromCoords(GetEntityCoords(cache.ped))
        if zone ~= currentZone then
            currentZone = zone
            local state = ZoneOwnerInfo(zone)
            TriggerEvent('vinewood_gangs:client:zoneChanged', zone, state)
        end
        Wait(1000)
    end
end)


exports('GetCurrentZone', function() return currentZone end)
