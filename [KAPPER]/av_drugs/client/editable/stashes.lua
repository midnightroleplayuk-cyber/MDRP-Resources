RegisterNetEvent('av_drugs:openStash', function(data)
    Wait(250)
    if data and data['itemName'] then
        local info = lib.callback.await('av_drugs:getTableInfo', false, data['itemName'], data['identifier'])
        if info then
            return exports['av_laptop']:openStash(data['identifier'], Lang['tableStash'], info['weight'], info['slots'], true)
        end
    end
end)

RegisterNetEvent('av_drugs:labStash', function(data)
    dbug('av_drugs:labStash')
    local slots = Config.DefaultLabStash['slots'] or 10
    local weight = Config.DefaultLabStash['weight'] or 100000
    local identifier = data['identifier'] or false
    local level = false
    if not identifier then
        dbug("^1Missing info for stash^7", identifier, weight, slots)
        return
    end
    if Config.Upgrades and Config.Upgrades['stash'] then
        level = lib.callback.await('av_drugs:getLabLevel', false, identifier, 'stash')
        level = level and tonumber(level) or false
        if level and level > 0 then
            slots = Config.Upgrades['stash'][level] and Config.Upgrades['stash'][level]['slots'] or slots
            weight = Config.Upgrades['stash'][level] and Config.Upgrades['stash'][level]['weight'] or slots
        end
    end
    dbug("openStash (identifier, level, weight, slots)", identifier, level, weight, slots)
    exports['av_laptop']:openStash(identifier, Lang['lab_stash'], weight, slots, true)
end)