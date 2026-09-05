-- ──────────────────────────────────────────────────────────────────────────────
-- revivePlayer                                                                
-- (Information) ► Revives a player using the ambulance job configured in
--        Config.AmbulanceJob (see config/MainConfig.lua).
-- ──────────────────────────────────────────────────────────────────────────────

local reviveHandlers = {
    ['wasabi_ambulance'] = function(source, playerId)
        exports.wasabi_ambulance:RevivePlayer(source)
    end,
    ['wasabi_ambulance_v2'] = function(source, playerId)
        exports['wasabi_ambulance_v2']:RevivePlayer(source)
    end,
    ['esx_ambulancejob'] = function(source, playerId)
        local xPlayer = Fr.getPlayerFromId(source)
        if xPlayer then xPlayer.triggerEvent('esx_ambulancejob:revive') end
    end,
    ['qb-ambulancejob'] = function(source, playerId)
        TriggerClientEvent('hospital:client:Revive', playerId)
        TriggerClientEvent('hospital:client:HealInjuries', playerId, 'full')
    end,
    ['qbx_medical'] = function(source, playerId)
        TriggerClientEvent('qbx_medical:client:playerRevived', playerId)
    end,
    ['p_ambulancejob'] = function(source, playerId)
        TriggerClientEvent('p_ambulancejob/client/death/revive', source)
    end,
    ['tk_ambulancejob'] = function(source, playerId)
        exports.tk_ambulancejob:revive(source, true)
    end,
    ['osp_ambulance'] = function(source, playerId)
        TriggerEvent('osp_ambulance:revive', source)
    end,
    ['sky_ambulancejob'] = function(source, playerId)
        exports['sky_ambulancejob']:revive(source)
    end,
    ['0r_ambulancejob'] = function(source, playerId)
        TriggerEvent('0r_ambulancejob:server:revivePlayer', source, {
            source = source,
            reason = 'Revive',
            silentGetUp = true,
        })
    end,
    ['brutal_ambulancejob'] = function(source, playerId)
        TriggerClientEvent('brutal_ambulancejob:revive', playerId)
    end,
}

local function reviveWithFramework(source, playerId)
    if ESX then
        local xPlayer = Fr.getPlayerFromId(source)
        if xPlayer then xPlayer.triggerEvent('esx_ambulancejob:revive') end
    elseif QBCore then
        TriggerClientEvent('hospital:client:Revive', playerId)
        TriggerClientEvent('hospital:client:HealInjuries', playerId, 'full')
    elseif QBox then
        TriggerClientEvent('qbx_medical:client:playerRevived', playerId)
    else
        print('revivePlayer: no supported medical script/framework detected.')
    end
end

function revivePlayer(source)
    while Framework == nil do Wait(5) end

    local Player = Fr.getPlayerFromId(source)
    if not Player then return end

    local playerId = Fr.GetSourceFromPlayerObject(Player) or source

    local ambulanceJob = Config.AmbulanceJob or 'framework'

    if ambulanceJob == 'framework' then
        reviveWithFramework(source, playerId)
        return
    end

    local handler = reviveHandlers[ambulanceJob]
    if handler then
        handler(source, playerId)
    else
        reviveWithFramework(source, playerId)
    end
end