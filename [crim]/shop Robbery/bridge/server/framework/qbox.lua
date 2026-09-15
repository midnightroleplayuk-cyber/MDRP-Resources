if not Bridge.ShouldLoadFramework('qbox') then return end

Bridge.SetFramework('qbox', {
    getPlayer = function(src)
        return exports.qbx_core:GetPlayer(src)
    end,

    getIdentifier = function(src)
        local player = exports.qbx_core:GetPlayer(src)

        return player and player.PlayerData and player.PlayerData.citizenid
            or GetPlayerIdentifierByType(src, 'license')
            or ('source:%s'):format(src)
    end,

    getJob = function(src)
        local player = exports.qbx_core:GetPlayer(src)
        local job = player and player.PlayerData and player.PlayerData.job

        if not job then return nil, false end
        return job.name, job.onduty ~= false
    end
})
