RegisterNetEvent("av_business:tray", function(data)
    dbug("tray()")
    local name = data['name']
    local label = data['label']
    local job = data['zoneJob']
    dbug("tray(name,label,job)", name, label, job)
    if name and label then
        local stash = getStashName(name, job, data['zoneType'])
        exports['av_laptop']:openStash(stash, label, Config.TrayWeight, Config.TraySlots)
    end
end)

RegisterNetEvent("av_business:stash", function(data)
    local permissions = getPermissions()
    dbug("stash()")
    if permissions['isBoss'] or permissions['stashes'] then
        local name = data['name']
        local label = data['label']
        local weight = Config.StashWeight
        local slots = Config.StashSlots
        local job = data['zoneJob']
        if data['zoneType'] == "tray" then
            weight = Config.TrayWeight
            slots = Config.TraySlots
        end
        dbug("stash(name,label,job)", name, label, job)
        if name and label then
            local stash = getStashName(name, job, data['zoneType'])
            exports['av_laptop']:openStash(stash, label, weight, slots)
        end
    else
        TriggerEvent("av_laptop:notification", Lang['app_title'], Lang['missing_permissions'], "error")
        dbug("User does not have permissions to access stash")
    end
end)