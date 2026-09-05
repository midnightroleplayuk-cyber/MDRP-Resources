-- ------------------------------------------------------------------------------
-- Framework / Client / Shared
-- ------------------------------------------------------------------------------

Framework = Framework or nil
Fr = Fr or {}

Fr.GetPlayerData    = Fr.GetPlayerData    or function() return {} end
Fr.IsLoaded         = Fr.IsLoaded         or function() return true end
Fr.IsDead           = Fr.IsDead           or function() return IsEntityDead(PlayerPedId()) end
Fr.PlayerLoadedEvt  = Fr.PlayerLoadedEvt  or 'opc:client:playerLoaded'
Fr.PlayerUnloadEvt  = Fr.PlayerUnloadEvt  or 'opc:client:playerUnloaded'
Fr.Ready            = false

Fr.TriggerCallback  = Fr.TriggerCallback  or function(name, cb, ...)
    if cb then cb(nil) end
end

Fr.GetJob  = Fr.GetJob  or function() return nil, 0 end
Fr.GetGang = Fr.GetGang or function() return nil, 0 end

function Fr.MarkReady(name)
    Fr.Ready = true
    print(('^2 Client framework ready: %s^0'):format(tostring(name)))
end

function Fr.WaitForResource(resName, timeoutMs)
    timeoutMs = timeoutMs or 60000
    local deadline = GetGameTimer() + timeoutMs
    while GetResourceState(resName) ~= 'started' do
        if GetGameTimer() > deadline then return false end
        Wait(100)
    end
    return true
end

function Fr.ShouldBind(name)
    local pinned = Config and Config.Framework
    if type(pinned) == 'string' and pinned ~= '' and pinned ~= 'auto' then
        return pinned == name
    end
    if Fr.Ready then return Config.Framework == name end

    local qbx = GetResourceState('qbx_core')
    local esx = GetResourceState('es_extended')
    local qb  = GetResourceState('qb-core')

    if qbx == 'started' or qbx == 'starting' then return name == 'qbox' end
    if esx == 'started' or esx == 'starting' then return name == 'esx' end
    if qb == 'started' or qb == 'starting' then return name == 'qb' end
    return true
end