if not Bridge.ShouldLoadFramework('esx') then return end

local ESX = exports.es_extended:getSharedObject()

Bridge.SetFramework('esx', {
    getPlayer = function(src)
        return ESX.GetPlayerFromId(src)
    end,

    getIdentifier = function(src)
        local player = ESX.GetPlayerFromId(src)

        return player and player.identifier
            or GetPlayerIdentifierByType(src, 'license')
            or ('source:%s'):format(src)
    end,

    getJob = function(src)
        local player = ESX.GetPlayerFromId(src)

        if not player or not player.job then return nil, false end
        return player.job.name, true
    end,

    isAdmin = function(src)
        local player = ESX.GetPlayerFromId(src)
        local group = player and player.getGroup and player.getGroup()

        if not group then return nil end
        return lib.table.contains(Config.AdminGroups, group)
    end
})
