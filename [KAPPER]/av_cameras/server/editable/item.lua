CreateThread(function()
    for item, _ in pairs(Config.CameraItems) do
        exports['av_laptop']:registerItem(item)
    end
end)

AddEventHandler('ox_inventory:usedItem', function(playerId, name, slotId, metadata)
    dbug("ox_inventory:usedItem", name)
    if not name or not playerId then return end
    if Config.CameraItems and Config.CameraItems[name] then
        local canUse = Config.CameraItems[name].canUse(playerId)
        local settings = Config.CameraItems[name].settings
        local isTechnician = Config.CameraItems[name].technician
        if canUse then
            startPlacement(playerId, name, settings, canUse, isTechnician)
        else
            TriggerClientEvent("av_laptop:notification",playerId,Lang['app_title'],Lang['technician_only'],"error")
        end
        return
    end
end)