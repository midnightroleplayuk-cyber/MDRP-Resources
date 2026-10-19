-- ============================================================
-- Object Remover — server-side fallback delete
-- When a client lacks ownership of a networked entity, it asks
-- the server to relay a delete to the owning client.
-- ============================================================

RegisterNetEvent('apex_adminmenu:laserDeleteEntity', function(netId)
    local src = source
    if not AdminPerms(src) then return end
    if not netId or netId == 0 then return end

    local entity = NetworkGetEntityFromNetworkId(netId)
    if not entity or entity == 0 then return end

    -- Try server-side delete first (works for server-spawned entities).
    if DoesEntityExist(entity) then
        DeleteEntity(entity)
    end

    -- Fallback: tell the owner to delete it.
    local owner = NetworkGetEntityOwner(entity)
    if owner and owner > 0 then
        TriggerClientEvent('apex_adminmenu:laserDeleteEntityClient', owner, netId)
    end

    SendDiscordLog(
        'Admin Action: Object Remover',
        'Admin deleted a world entity via laser',
        { { name = 'NetId', value = tostring(netId), inline = true } },
        'utilityActions'
    )
end)
