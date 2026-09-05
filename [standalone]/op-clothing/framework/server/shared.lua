-- ------------------------------------------------------------------------------
-- Framework / Server / Shared
-- ------------------------------------------------------------------------------

Framework = Framework or nil
Fr = Fr or {}

Fr.GetIdentifier          = Fr.GetIdentifier          or function(_) return nil end
Fr.GetPlayerName          = Fr.GetPlayerName          or function(src) return GetPlayerName(src) or 'Unknown' end
Fr.GetPlayerObject        = Fr.GetPlayerObject        or function(_) return nil end
Fr.GetGender              = Fr.GetGender              or function(_) return 'male' end
Fr.AddMoney               = Fr.AddMoney               or function(_, _, _) return false end
Fr.RemoveMoney            = Fr.RemoveMoney            or function(_, _, _) return false end
Fr.HasMoney               = Fr.HasMoney               or function(_, _, _) return false end
Fr.GetJob                 = Fr.GetJob                 or function(_) return nil, 0 end
Fr.GetGang                = Fr.GetGang                or function(_) return nil, 0 end
Fr.GetGroup               = Fr.GetGroup               or function(_) return nil end

-- Callbacks may register before the deferred framework adapter boots — queue them.
local pendingCallbacks = {}
local registerImpl = nil

Fr.RegisterServerCallback = function(name, fn)
    if registerImpl then
        return registerImpl(name, fn)
    end
    pendingCallbacks[#pendingCallbacks + 1] = { name = name, fn = fn }
end

--- Called by framework adapters once their real RegisterServerCallback is ready.
function Fr.BindRegisterServerCallback(impl)
    registerImpl = impl
    Fr.RegisterServerCallback = impl
    for i = 1, #pendingCallbacks do
        local item = pendingCallbacks[i]
        impl(item.name, item.fn)
    end
    pendingCallbacks = {}
end

Fr.Ready = false

function Fr.MarkReady(name)
    Fr.Ready = true
    print(('^2 Framework ready: %s^0'):format(tostring(name)))
end

--- Wait helper used by deferred adapters (qbox > esx > qb).
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

    -- Same priority as detectFramework: qbox > esx > qb
    if qbx == 'started' or qbx == 'starting' then return name == 'qbox' end
    if esx == 'started' or esx == 'starting' then return name == 'esx' end
    if qb == 'started' or qb == 'starting' then return name == 'qb' end
    return true
end