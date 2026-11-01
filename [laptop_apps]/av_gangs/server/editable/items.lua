AddEventHandler('ox_inventory:usedItem', function(playerId, name, slotId, metadata)
    metadata = metadata or {}
    if Config.DisableGraffitis then
        return
    end
    dbug('usedITem(playerId, name, sprayItem, removerItem)', playerId, name, Config.ItemNames and Config.ItemNames['spray'], Config.ItemNames and Config.ItemNames['remover'])
    if Config.ItemNames['remover'] and Config.ItemNames['remover'] == name then
        dbug("av_gangs:useCleaner...")
        TriggerClientEvent('av_gangs:useCleaner', playerId)
        return
    end
    if Config.ItemNames['spray'] and Config.ItemNames['spray'] == name then
        dbug("Used spray item...")
        local myGang = getGang(playerId)
        if myGang and metadata.gang and metadata.gang == myGang.name then
            if isExpired(metadata.expiration) then
                TriggerClientEvent('av_laptop:notification',playerId,Lang['app_title'],Lang['expired'],"error")
                return
            end
            local gangData = gangs[myGang.name]
            if gangData then
                TriggerClientEvent('av_gangs:addGraffiti',playerId,myGang.name)
            else
                TriggerClientEvent('av_laptop:notification',playerId,Lang['app_title'], Lang['not_your_spray'], 'error')
            end
        else
            TriggerClientEvent('av_laptop:notification',playerId,Lang['app_title'], Lang['not_your_spray'], 'error')
        end
    end
end)

function isExpired(expiration)
    if not expiration then return false end
    expiration = tonumber(expiration)
    local timeNow = os.time()
    return (timeNow > expiration)
end