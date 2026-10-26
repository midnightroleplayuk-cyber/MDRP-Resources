-- Live 999 calls from dispatch scripts, filtered to ambulance jobs (Config.Dispatch.Jobs).
-- Ported from vinewood-mdt. Scripts with a "get calls" export are read directly; scripts
-- that only send alerts are listened to. Anything else can push calls in with
-- exports['vinewood-emsmdt']:AddCall(data).
Dispatch = {}

local cache = {}      -- captured calls, newest last
local nextId = 0
local active          -- name of the source(s) in use, for the status panel

local function cfg() return Config.Dispatch or {} end
local function now() return os.time() end

local function toCoords(c)
    if type(c) == 'vector3' or type(c) == 'vector4' then return { x = c.x, y = c.y, z = c.z } end
    if type(c) == 'table' then
        local x, y, z = tonumber(c.x or c[1]), tonumber(c.y or c[2]), tonumber(c.z or c[3])
        if x and y then return { x = x, y = y, z = z or 0.0 } end
    end
    return nil
end

local function toSeconds(t)
    t = tonumber(t)
    if not t then return now() end
    if t > 1e11 then return math.floor(t / 1000) end   -- milliseconds
    return t
end

-- Every script names priority differently; map it to the MDT's grades.
local function toGrade(p)
    if type(p) == 'number' then return ('Grade %d'):format(math.max(1, math.min(4, p))) end
    if type(p) == 'boolean' then return p and 'Grade 1' or 'Grade 2' end
    if type(p) == 'string' then
        local s = p:lower()
        local n = tonumber(s:match('%d'))
        if n then return ('Grade %d'):format(math.max(1, math.min(4, n))) end
        if s:find('high') or s:find('urgent') or s:find('emerg') then return 'Grade 1' end
        if s:find('low') then return 'Grade 3' end
    end
    return 'Grade 2'
end

local function forUs(jobs)
    local wanted = cfg().Jobs
    if not wanted or not jobs then return true end
    if type(jobs) == 'string' then jobs = { jobs } end
    if type(jobs) ~= 'table' then return true end
    local any = false
    for _, j in pairs(jobs) do
        any = true
        for _, w in ipairs(wanted) do if j == w then return true end end
    end
    return not any
end

local function prune()
    local keep = (cfg().KeepMinutes or 30) * 60
    local cutoff = now() - keep
    for i = #cache, 1, -1 do
        if cache[i].time < cutoff then table.remove(cache, i) end
    end
    while #cache > (cfg().MaxCalls or 60) do table.remove(cache, 1) end
end

--- Add a call to the cache. data: { title, code, message, location, coords, priority, jobs, time, source }
function Dispatch.Add(data, source)
    if type(data) ~= 'table' or not forUs(data.jobs or data.job) then return end
    nextId = nextId + 1
    cache[#cache + 1] = {
        id = ('%s-%d'):format(source or 'mdt', nextId),
        source = source or 'MDT',
        title = tostring(data.title or data.message or 'Call'):sub(1, 120),
        code = data.code and tostring(data.code):sub(1, 16) or nil,
        message = data.message and data.title and tostring(data.message):sub(1, 300) or nil,
        location = data.location and tostring(data.location):sub(1, 120) or nil,
        coords = toCoords(data.coords),
        grade = toGrade(data.priority),
        units = tonumber(data.units) or 0,
        time = toSeconds(data.time),
    }
    prune()
end

---------------------------------------------------------------------------
-- Readers: scripts that hand over their call list
---------------------------------------------------------------------------
-- cd_dispatch3d and cd_dispatch both provide their calls in ps-dispatch format.
local READERS = {
    { resource = 'cd_dispatch3d', export = 'GetDispatchCalls_PS', label = 'CD Dispatch 3D' },
    { resource = 'cd_dispatch',   export = 'GetDispatchCalls_PS', label = 'CD Dispatch' },
    { resource = 'ps-dispatch',   export = 'GetDispatchCalls',    label = 'PS Dispatch' },
}

local function fromPsFormat(c, label)
    if type(c) ~= 'table' then return nil end
    local units = 0
    if type(c.units) == 'table' then for _ in pairs(c.units) do units = units + 1 end end
    local title = c.message or c.title or c.codeName or 'Call'
    return {
        id = ('%s-%s'):format(label, tostring(c.id or c.callId or title)),
        source = label,
        title = tostring(title),
        jobs = c.jobs or c.job,
        code = c.code or c.dispatchCode,
        message = c.information or c.description,
        location = c.street or c.location,
        coords = toCoords(c.coords or c.origin),
        grade = toGrade(c.priority),
        units = units,
        time = toSeconds(c.time),
    }
end

---------------------------------------------------------------------------
-- Vinewood Dispatch: read live, with units, call updates and attach state
---------------------------------------------------------------------------
local VD = 'vinewood-dispatch'

local function vdLocation(l)
    if type(l) ~= 'table' then return nil end
    local road = l.street and (l.cross and ('%s / %s'):format(l.street, l.cross) or l.street)
    local parts = {}
    if road then parts[#parts + 1] = road end
    if l.zone then parts[#parts + 1] = l.zone end
    if l.postal then parts[#parts + 1] = ('postal %s'):format(l.postal) end
    return #parts > 0 and table.concat(parts, ', ') or nil
end

local function vdVehicle(a)
    local v = a.vehicle
    if type(v) ~= 'table' then return nil end
    local name = table.concat((function()
        local t = {}
        for _, k in ipairs({ 'colour', 'make', 'model' }) do if v[k] then t[#t + 1] = v[k] end end
        return t
    end)(), ' ')
    local out = name ~= '' and name or 'Unknown vehicle'
    if v.plate then out = ('%s, plate %s'):format(out, v.plate) end
    if a.heading then out = ('%s, heading %s'):format(out, a.heading) end
    return out
end

local function fromVinewood(a, src)
    local units, attached = {}, false
    for _, r in ipairs(a.responders or {}) do
        units[#units + 1] = r.callsign or r.name
        if src and r.src == src then attached = true end
    end
    local now = os.time()
    local notes = {}
    for i, n in ipairs(a.notes or {}) do
        notes[i] = { author = n.author, text = n.text, age = now - (n.time or now) }
    end
    local c = a.blipCoords or a.coords
    return {
        id = ('VD-%d'):format(a.id),
        dispatchId = a.id,
        source = 'Vinewood Dispatch',
        title = a.title,
        code = a.code,
        message = a.description,
        location = vdLocation(a.location),
        coords = c and { x = c.x, y = c.y, z = c.z } or nil,
        grade = toGrade(a.priority),
        units = #units,
        unitNames = units,
        attached = attached,
        notes = notes,
        vehicle = vdVehicle(a),
        weapon = a.weapon,
        unit = a.unit and (a.unit.callsign and ('%s (%s)'):format(a.unit.callsign, a.unit.name) or a.unit.name) or nil,
        unitSrc = a.unitSrc,
        caller = a.caller and table.concat((function()
            local t = {}
            if a.caller.name then t[#t + 1] = a.caller.name end
            if a.caller.phone then t[#t + 1] = a.caller.phone end
            return t
        end)(), ', ') or nil,
        time = a.time,
    }
end

local function readVinewood(src)
    if (cfg().Sources or {})[VD] == false or GetResourceState(VD) ~= 'started' then return nil end
    local ok, alerts = pcall(function() return exports[VD]:GetActiveAlerts(cfg().Service) end)
    if not ok or type(alerts) ~= 'table' then return nil end
    local out = {}
    for _, a in ipairs(alerts) do out[#out + 1] = fromVinewood(a, src) end
    return out
end

--- Raw vinewood-dispatch alert by id, or nil
function Dispatch.Alert(id)
    id = tonumber(id)
    if not id or not Dispatch.UsingVinewood() then return nil end
    local ok, alerts = pcall(function() return exports[VD]:GetActiveAlerts(cfg().Service) end)
    if not ok or type(alerts) ~= 'table' then return nil end
    for _, a in ipairs(alerts) do if tonumber(a.id) == id then return a end end
end

--- Is this player attached to the vinewood-dispatch call?
function Dispatch.IsAttached(id, src)
    local a = Dispatch.Alert(id)
    if not a then return nil end
    for _, r in ipairs(a.responders or {}) do if r.src == src then return true end end
    return false
end

function Dispatch.UsingVinewood()
    return (cfg().Sources or {})[VD] ~= false and GetResourceState(VD) == 'started'
end

local function readExports(src)
    local vd = readVinewood(src)
    if vd then return vd, { 'Vinewood Dispatch' } end
    local out, used = {}, {}
    for _, r in ipairs(READERS) do
        local rc = (cfg().Sources or {})[r.resource]
        if rc ~= false and GetResourceState(r.resource) == 'started' then
            local ok, calls = pcall(function() return exports[r.resource][r.export]() end)
            if ok and type(calls) == 'table' then
                used[#used + 1] = r.label
                for _, c in pairs(calls) do
                    local n = fromPsFormat(c, r.label)
                    if n and forUs(n.jobs) then n.jobs = nil; out[#out + 1] = n end
                end
                break -- cd_dispatch3d/cd_dispatch/ps-dispatch run alone; the first that answers wins
            end
        end
    end
    return out, used
end

---------------------------------------------------------------------------
-- Listeners: scripts that only send alerts
---------------------------------------------------------------------------
local function listen(eventName, resource, label, map)
    RegisterNetEvent(eventName)
    AddEventHandler(eventName, function(data)
        if (cfg().Sources or {})[resource] == false then return end
        if GetResourceState(resource) ~= 'started' then return end
        local ok, call = pcall(map, data or {}, source)
        if ok and call then Dispatch.Add(call, label) end
    end)
end

-- Quasar: qs-dispatch
listen('qs-dispatch:server:CreateDispatchCall', 'qs-dispatch', 'QS Dispatch', function(d)
    local cc = type(d.callCode) == 'table' and d.callCode or {}
    return {
        title = (type(d.blip) == 'table' and d.blip.text) or cc.snippet or d.message,
        code = cc.code, message = d.message, coords = d.callLocation or d.coords,
        jobs = d.job, priority = d.priority,
    }
end)

-- rcore: rcore_dispatch
listen('rcore_dispatch:server:sendAlert', 'rcore_dispatch', 'rcore Dispatch', function(d)
    return {
        title = d.text, code = d.code, coords = d.coords, jobs = d.job,
        priority = d.default_priority, location = d.street,
    }
end)

---------------------------------------------------------------------------
-- Manual feed for anything else (tk_dispatch, core_dispatch, custom alerts)
---------------------------------------------------------------------------
exports('AddCall', function(data) Dispatch.Add(data, data and data.source or 'Custom') end)
AddEventHandler('vinewood-emsmdt:server:addCall', function(data) Dispatch.Add(data, data and data.source or 'Custom') end)

-- Client-side alerts: rate limited, and the coords are checked against the sender.
local lastClientCall = {}
RegisterNetEvent('vinewood-emsmdt:server:clientCall', function(data)
    local src = source
    if type(data) ~= 'table' then return end
    local t = GetGameTimer()
    if lastClientCall[src] and t - lastClientCall[src] < 5000 then return end
    lastClientCall[src] = t
    local ped = GetPlayerPed(src)
    if ped and ped ~= 0 then data.coords = data.coords or GetEntityCoords(ped) end
    Dispatch.Add(data, data.source or 'Custom')
end)
AddEventHandler('playerDropped', function() lastClientCall[source] = nil end)

---------------------------------------------------------------------------
-- Read
---------------------------------------------------------------------------
---@param src? number viewer, so calls can show whether they're attached
function Dispatch.Get(src)
    if cfg().enabled == false then return {}, nil end
    prune()
    local calls, used = readExports(src)
    if #cache > 0 then
        local seen = {}
        for _, c in ipairs(cache) do
            calls[#calls + 1] = c
            if not seen[c.source] then seen[c.source] = true; used[#used + 1] = c.source end
        end
    end
    -- Listener-based scripts count as connected once running, even before their first alert.
    for res, label in pairs({ ['qs-dispatch'] = 'QS Dispatch', ['rcore_dispatch'] = 'rcore Dispatch' }) do
        if GetResourceState(res) == 'started' then
            local found = false
            for _, u in ipairs(used) do if u == label then found = true end end
            if not found then used[#used + 1] = label end
        end
    end
    table.sort(calls, function(a, b)
        if a.grade ~= b.grade then return a.grade < b.grade end
        return (a.time or 0) > (b.time or 0)
    end)
    active = #used > 0 and table.concat(used, ', ') or nil
    return calls, active
end

function Dispatch.Connected()
    local _, name = Dispatch.Get()
    return name
end
