AddEventHandler('ox_inventory:usedItem', function(playerId, name, slotId, metadata)
    dbug("ox_inventory:usedItem", name)
    if not name or not playerId then return end
    dbug("Item used, Config.LaptopItem", name, Config.LaptopItem)
    if Config.LaptopItem and name == Config.LaptopItem then
        dbug("item name matches")
        local slot = slotId
        metadata = metadata or {}
        metadata['durability'] = metadata['durability'] or 100
        if metadata and not metadata['serial'] then
            local info = {}
            local serial = lib.string.random('..............')
            info['serial'] = serial
            info['owner'] = getIdentifier(playerId)
            info['durability'] = metadata['durability'] or 100
            info['password'] = false
            if info['durability'] > 100 then
                dbug("^3[DEBUG]:^7 ".."more than 100")
                info['durability'] = 100
            end
            info['storage'] = getStorage(info['serial'],info['owner'])
            allDevices[serial] = os.time()
            setItemMetadata(playerId, Config.LaptopItem, slot, info)
            TriggerClientEvent("av_laptop:openUI", playerId, info, slot, true)
        else
            allDevices[metadata['serial']] = os.time()
            if not metadata['owner'] then
                local identifier = getIdentifier(playerId)
                metadata['owner'] = identifier
                setItemMetadata(playerId, Config.LaptopItem, slot, metadata)
            end
            metadata['storage'] = getStorage(metadata['serial'],metadata['owner'])
            TriggerClientEvent("av_laptop:openUI", playerId, metadata, slot, true)
        end
    end
end)