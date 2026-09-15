--[[
    HRS Base Building Integration (Client)

    Receives interaction events from hrs_base_building and forwards
    entity coordinates to the server for headless bench creation.

    No gate on HRSBaseBuilding.enabled here — config.lua only loads in
    server_scripts, so the global is always nil on the client. The server
    handler is the source of truth for enable/disable; this client side just
    forwards coords and is harmless when the integration is off.
]]

RegisterNetEvent('nextgenfivem_crafting:hrs:interact', function(benchTypeName, entity)
    if not benchTypeName then return end

    local coords, heading

    if entity and DoesEntityExist(entity) then
        coords = GetEntityCoords(entity)
        heading = GetEntityHeading(entity)
    else
        -- Fallback: use player coords if entity is invalid
        local ped = PlayerPedId()
        coords = GetEntityCoords(ped)
        heading = GetEntityHeading(ped)
    end

    TriggerServerEvent('nextgenfivem_crafting:hrs:registerAndOpen', benchTypeName, {
        x = coords.x,
        y = coords.y,
        z = coords.z,
        h = heading,
    })
end)
