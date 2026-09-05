--- ox_fuel replicated fuel. One server set is enough — never spam statebags
--- (retry loops were hitching the network thread under player load).

local lastFuelSet = {} -- [netId] = gameTimer

RegisterNetEvent('op-garages:setVehicleFuel', function(netId, level)
    local src = source
    netId = tonumber(netId)
    level = tonumber(level)

    if not netId or not level then return end
    level = math.max(0.0, math.min(100.0, level))

    -- Debounce identical/rapid updates (clients used to fire this 5+ times per take-out)
    local now = GetGameTimer()
    local prev = lastFuelSet[netId]
    if prev and (now - prev) < 750 then
        return
    end
    lastFuelSet[netId] = now

    local vehicle = NetworkGetEntityFromNetworkId(netId)
    if not vehicle or vehicle == 0 or not DoesEntityExist(vehicle) then return end
    if GetEntityType(vehicle) ~= 2 then return end

    local ped = GetPlayerPed(src)
    if not ped or ped == 0 then return end

    local pcoords = GetEntityCoords(ped)
    local vcoords = GetEntityCoords(vehicle)
    if #(pcoords - vcoords) > 25.0 then return end

    Entity(vehicle).state:set('fuel', level + 0.0, true)
end)

--- Clear leftover ox_lib vehicle-props statebags (can be 20-40KB each and
--- get resent to every client that streams the vehicle → mass timeouts).
RegisterNetEvent('op-garages:clearVehiclePropState', function(netId)
    local src = source
    netId = tonumber(netId)
    if not netId then return end

    local vehicle = NetworkGetEntityFromNetworkId(netId)
    if not vehicle or vehicle == 0 or not DoesEntityExist(vehicle) then return end
    if GetEntityType(vehicle) ~= 2 then return end

    local ped = GetPlayerPed(src)
    if not ped or ped == 0 then return end
    if #(GetEntityCoords(ped) - GetEntityCoords(vehicle)) > 25.0 then return end

    local state = Entity(vehicle).state
    if state['ox_lib:setVehicleProperties'] ~= nil then
        state:set('ox_lib:setVehicleProperties', nil, true)
    end
end)

AddEventHandler('entityRemoved', function(entity)
    if GetEntityType(entity) == 2 then
        local netId = NetworkGetNetworkIdFromEntity(entity)
        if netId then lastFuelSet[netId] = nil end
    end
end)
