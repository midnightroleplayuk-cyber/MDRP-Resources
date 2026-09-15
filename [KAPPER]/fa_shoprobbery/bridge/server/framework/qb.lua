if not Bridge.ShouldLoadFramework('qb') then return end

local QBCore = exports['qb-core']:GetCoreObject()

Bridge.SetFramework('qb', {
    getPlayer = function(src)
        return QBCore.Functions.GetPlayer(src)
    end,

    getIdentifier = function(src)
        local player = QBCore.Functions.GetPlayer(src)

        return player and player.PlayerData and player.PlayerData.citizenid
            or GetPlayerIdentifierByType(src, 'license')
            or ('source:%s'):format(src)
    end,

    getJob = function(src)
        local player = QBCore.Functions.GetPlayer(src)
        local job = player and player.PlayerData and player.PlayerData.job

        if not job then return nil, false end
        return job.name, job.onduty ~= false
    end,

    isAdmin = function(src)
        for i = 1, #Config.AdminGroups do
            if QBCore.Functions.HasPermission(src, Config.AdminGroups[i]) then
                return true
            end
        end

        return false
    end
})
