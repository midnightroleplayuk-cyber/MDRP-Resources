-- Sends remanded prisoners to the server's prison script, and lets them out again on bail.
-- Open file: add your own prison script at the bottom (Prison.Adapters.myprison = {...}).
--
-- Each adapter:
--   resource  = resource name, used to detect it
--   imprison  = function(target, data) -> ok, message
--   release   = function(target, data) -> ok, message   (optional)
--   offline   = true if it can take someone who isn't in the city
-- target = { src = server id or nil, cid = citizen id }
-- data   = { minutes, seconds, reason, caseRef, offences = { 'text', ... }, officer = server id }
Prison = { Adapters = {} }

local A = Prison.Adapters

-- vinewood_prison: proper remand prisoner, works offline, keeps time served if sentenced later.
A.vinewood_prison = {
    resource = 'vinewood_prison', offline = true, label = 'Vinewood Prison',
    imprison = function(t, d)
        local offences = {}
        for _, o in ipairs(d.offences or {}) do offences[#offences + 1] = { code = '', title = o } end
        local ok, info = exports.vinewood_prison:Imprison(t.src or t.cid, {
            termSeconds = d.seconds, remand = true, caseRef = d.caseRef, offences = offences, prison = 'auto',
        })
        if ok == false then return false, tostring(info or 'refused') end
        return true, info and ('Received at prison on remand, prison number %s.'):format(tostring(info)) or 'Received at prison on remand.'
    end,
    release = function(t, d)
        local ok, err = exports.vinewood_prison:Release(t.src or t.cid, d.reason or 'bail')
        return ok ~= false, err
    end,
}

-- rcore_prison (v2): exports Jail / Unjail / UnjailOffline. Time in minutes.
A.rcore_prison = {
    resource = 'rcore_prison', label = 'rcore Prison',
    imprison = function(t, d)
        if not t.src then return false, 'must be in the city' end
        exports['rcore_prison']:Jail(t.src, d.minutes, d.reason, d.officer)
        return true
    end,
    release = function(t)
        if t.src then exports['rcore_prison']:Unjail(t.src, false) else exports['rcore_prison']:UnjailOffline(t.cid) end
        return true
    end,
}

-- tk_jail / qb_tk_jail: exports jail(targetId, time) / unjail(targetId)
A.tk_jail = {
    resource = 'tk_jail', label = 'tk_jail',
    imprison = function(t, d)
        if not t.src then return false, 'must be in the city' end
        exports['tk_jail']:jail(t.src, d.minutes)
        return true
    end,
    release = function(t)
        if not t.src then return false, 'must be in the city' end
        exports['tk_jail']:unjail(t.src)
        return true
    end,
}
A.qb_tk_jail = {
    resource = 'qb_tk_jail', label = 'qb_tk_jail',
    imprison = function(t, d)
        if not t.src then return false, 'must be in the city' end
        exports['qb_tk_jail']:jail(t.src, d.minutes)
        return true
    end,
}

-- qb-prison (with qb-policejob): the same thing qb-policejob's jail does.
A['qb-prison'] = {
    resource = 'qb-prison', label = 'qb-prison',
    imprison = function(t, d)
        if not t.src then return false, 'must be in the city' end
        local fw = Bridge.Framework()
        local Player = fw == 'qbx' and exports.qbx_core:GetPlayer(t.src)
            or (fw == 'qb' and exports['qb-core']:GetCoreObject().Functions.GetPlayer(t.src))
        if not Player then return false, 'player not loaded' end
        Player.Functions.SetMetaData('injail', d.minutes)
        TriggerClientEvent('police:client:SendToJail', t.src, d.minutes)
        return true
    end,
}

-- Your own prison script: fill this in and set Config.Prison.resource = 'custom'.
A.custom = {
    resource = nil, label = 'Custom',
    imprison = function(t, d)
        if type(Config.Prison.Custom) == 'function' then return Config.Prison.Custom(t, d) end
        return false, 'Config.Prison.Custom is not set'
    end,
    release = function(t, d)
        if type(Config.Prison.CustomRelease) == 'function' then return Config.Prison.CustomRelease(t, d) end
        return false, 'Config.Prison.CustomRelease is not set'
    end,
}

-- Which adapter to use: the one named in config, or the first running one in this order.
local ORDER = { 'vinewood_prison', 'rcore_prison', 'tk_jail', 'qb_tk_jail', 'qb-prison' }

function Prison.Pick()
    local cfg = Config.Prison or {}
    if cfg.enabled == false then return nil end
    local want = cfg.resource or 'auto'
    if want ~= 'auto' then
        local a = A[want]
        if a and (want == 'custom' or GetResourceState(a.resource) == 'started') then return a, want end
        return nil
    end
    for _, name in ipairs(ORDER) do
        local a = A[name]
        if a and GetResourceState(a.resource) == 'started' then return a, name end
    end
    for name, a in pairs(A) do
        if name ~= 'custom' and a.resource and GetResourceState(a.resource) == 'started' then return a, name end
    end
    return nil
end

local function call(fn, t, d)
    local ok, res, msg = pcall(fn, t, d)
    if not ok then
        print(('[vinewood-mdt] prison script error: %s'):format(tostring(res)))
        return false, 'the prison script returned an error (see server console)'
    end
    return res ~= false, msg
end

--- Remand someone. Returns ok, message, adapterLabel
function Prison.Remand(cid, data)
    local a, name = Prison.Pick()
    if not a then return false, 'No prison script is running.', nil end
    local src = Bridge.GetSource(cid)
    if not src and not a.offline then
        return false, ('%s can only take someone who is in the city. Remand them when they are back.'):format(a.label or name), a.label
    end
    local minutes = math.max(1, math.floor(tonumber(data.minutes) or (Config.Prison.RemandMinutes or 60)))
    local ok, msg = call(a.imprison, { src = src, cid = cid }, {
        minutes = minutes, seconds = minutes * 60, reason = data.reason, caseRef = data.caseRef,
        offences = data.offences or {}, officer = data.officer,
    })
    return ok, msg, a.label or name
end

--- Release from remand (bail, NFA). Returns ok, message
function Prison.Release(cid, reason)
    local a, name = Prison.Pick()
    if not a or not a.release then return false, 'This prison script has no release function.' end
    return call(a.release, { src = Bridge.GetSource(cid), cid = cid }, { reason = reason })
end

function Prison.Name()
    local a, name = Prison.Pick()
    return a and (a.label or name) or nil
end

-- Add your own adapters below, e.g.:
-- Prison.Adapters.my_prison = {
--     resource = 'my_prison', label = 'My Prison',
--     imprison = function(t, d) exports.my_prison:Jail(t.src, d.minutes) return true end,
--     release  = function(t, d) exports.my_prison:Release(t.src) return true end,
-- }
