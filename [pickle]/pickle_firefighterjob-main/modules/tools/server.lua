CarriedPlayers = {}

RegisterNetEvent("pickle_firefighterjob:removeDoor", function(net_id, door_id)
    local source = source
    if not Firefighters[source] then return end
    TriggerClientEvent("pickle_firefighterjob:removeDoor", -1, net_id, door_id)
end)

RegisterNetEvent("pickle_firefighterjob:carryPlayer", function(target)
    local source = source
    if not target or target < 1 then return end
    if not Firefighters[source] then return end
    if CarriedPlayers[target] then 
        TriggerClientEvent("pickle_firefighterjob:stopCarryEvent", CarriedPlayers[target], target, false)
        TriggerClientEvent("pickle_firefighterjob:stopCarryEvent", target, CarriedPlayers[target], true)
        CarriedPlayers[target] = nil
    else
        CarriedPlayers[target] = source
        TriggerClientEvent("pickle_firefighterjob:startCarryEvent", source, target, false)
        TriggerClientEvent("pickle_firefighterjob:startCarryEvent", target, source, true)
    end
end)

RegisterNetEvent("pickle_firefighterjob:dragoutPlayer", function(target)
    local source = source
    if not target or target < 1 then return end
    if not Firefighters[source] then return end
    TriggerClientEvent("pickle_firefighterjob:dragoutPlayer", target)
end)