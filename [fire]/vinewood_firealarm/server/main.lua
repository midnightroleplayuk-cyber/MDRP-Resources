local Systems  = {}  -- [id] = persisted system
local States   = {}  -- [id] = runtime state
local Sessions = {}  -- [src][sysId] = { level, expires }
local Attempts = {}  -- [src] = { count, lockedUntil }
local Cooldowns = {} -- [src] = os.time() of last break glass

local DEVICE_TYPES = { panel = true, mcp = true, sounder = true, detector = true }
local TYPE_NAMES = { panel = 'Control panel', mcp = 'Call point', sounder = 'Sounder', detector = 'Detector' }

---------------------------------------------------------------------
-- Helpers
---------------------------------------------------------------------
local function contains(t, v) for i = 1, #t do if t[i] == v then return i end end end
local function addUnique(t, v) if not contains(t, v) then t[#t + 1] = v end end
local function removeVal(t, v) local i = contains(t, v) if i then table.remove(t, i) end end

local function zoneName(sys, z) return sys.zones[z] or ('Zone %d'):format(z) end

local function getDevice(sys, devId)
    for _, d in ipairs(sys.devices) do if d.id == devId then return d end end
end

local function devCoords(d) return vector3(d.x, d.y, d.z) end

local function pedCoords(src)
    local ped = GetPlayerPed(src)
    if ped == 0 then return nil end
    return GetEntityCoords(ped)
end

local function newState(sys)
    return {
        fire = false, zones = {}, active = {}, silenced = false, evacuate = false,
        test = false, testUntil = nil, disabled = sys.disabled, events = {},
        alarmAt = nil, alarmToken = 0, dispatched = false,
    }
end

local function defaults(sys)
    sys.job = sys.job or ''
    sys.jobGrade = tonumber(sys.jobGrade) or 0
    sys.userCode = sys.userCode or ''
    sys.engineerCode = sys.engineerCode or ''
    sys.zones = sys.zones or {}
    for z = 1, Config.MaxZones do sys.zones[z] = sys.zones[z] or ('Zone %d'):format(z) end
    sys.tone = sys.tone or Config.DefaultTone
    sys.radius = tonumber(sys.radius) or Config.DefaultSoundRadius
    if sys.dispatch == nil then sys.dispatch = true end
    sys.dispatchDelay = tonumber(sys.dispatchDelay) or Config.Dispatch.defaultDelay
    sys.disabled = sys.disabled or {}
    sys.devices = sys.devices or {}
    sys.nextId = sys.nextId or (#sys.devices + 1)
    return sys
end

local function publicSystem(sys)
    return {
        id = sys.id, label = sys.label, job = sys.job, zones = sys.zones,
        tone = sys.tone, radius = sys.radius, devices = sys.devices,
        dispatch = sys.dispatch and Config.Dispatch.enabled, dispatchDelay = sys.dispatchDelay,
    }
end

local function publicState(id, withActors)
    local st = States[id]
    if not st then return nil end
    local events = {}
    for i, e in ipairs(st.events) do
        events[i] = { t = e.t, text = e.text, actor = withActors and e.actor or nil }
    end
    return {
        fire = st.fire, zones = st.zones, active = st.active, silenced = st.silenced,
        evacuate = st.evacuate, test = st.test, testSounding = st.testUntil ~= nil,
        disabled = st.disabled, events = events, alarmAt = st.alarmAt, dispatched = st.dispatched,
        serverTime = os.time(),
    }
end

local function syncSystem(id)
    TriggerClientEvent('vinewood_firealarm:syncSystem', -1, id, Systems[id] and publicSystem(Systems[id]) or false)
end

local function syncState(id)
    TriggerClientEvent('vinewood_firealarm:syncState', -1, id, publicState(id) or false)
end

local function persist(id)
    local sys = Systems[id]
    if not sys then return end
    local data = {}
    for k, v in pairs(sys) do if k ~= 'id' and k ~= 'label' then data[k] = v end end
    MySQL.update('UPDATE vinewood_firealarm SET label = ?, data = ? WHERE id = ?', { sys.label, json.encode(data), id })
end

local function webhook(title, desc)
    if not Config.Webhook or Config.Webhook == '' then return end
    PerformHttpRequest(Config.Webhook, function() end, 'POST', json.encode({
        username = 'Vinewood Fire Alarm',
        embeds = { { title = title, description = desc, color = 13632027, timestamp = os.date('!%Y-%m-%dT%H:%M:%SZ') } },
    }), { ['Content-Type'] = 'application/json' })
end

local function addEvent(id, text, actor)
    local st = States[id]
    table.insert(st.events, 1, { t = os.time(), text = text, actor = actor })
    while #st.events > Config.EventLogSize do table.remove(st.events) end
    if Config.Debug then print(('[vinewood_firealarm] #%d %s %s'):format(id, text, actor or '')) end
end

---------------------------------------------------------------------
-- Access
---------------------------------------------------------------------
local function touchSession(src, id)
    local s = Sessions[src] and Sessions[src][id]
    if s then s.expires = os.time() + Config.AccessTimeout end
end

local function GetAccess(src, sys)
    if Bridge.IsAdmin(src) then return 3 end
    local level = 1
    local s = Sessions[src] and Sessions[src][sys.id]
    if s then
        if s.expires > os.time() then level = s.level else Sessions[src][sys.id] = nil end
    end
    local job, grade = Bridge.GetJob(src)
    if job then
        local fs = Config.FireServiceJobs[job]
        if fs and grade >= fs.minGrade then level = math.max(level, fs.level) end
        if Config.OwnerJobGetsLevel2 and sys.job ~= '' and job == sys.job and grade >= sys.jobGrade then
            level = math.max(level, 2)
        end
    end
    return level
end

local function nearPanel(src, sys, dist)
    local pc = pedCoords(src)
    if not pc then return false end
    for _, d in ipairs(sys.devices) do
        if d.type == 'panel' and #(pc - devCoords(d)) <= (dist or 4.0) then return true end
    end
    return false
end

local function nearDevice(src, d, dist)
    local pc = pedCoords(src)
    return pc and #(pc - devCoords(d)) <= (dist or 3.0)
end

---------------------------------------------------------------------
-- Alarm logic
---------------------------------------------------------------------
local function scheduleDispatch(id)
    local sys, st = Systems[id], States[id]
    if not Config.Dispatch.enabled or not sys.dispatch then return end
    local token = st.alarmToken
    SetTimeout(sys.dispatchDelay * 1000, function()
        local s = States[id]
        if not s or not s.fire or s.alarmToken ~= token or s.dispatched then return end
        s.dispatched = true
        local zone = s.zones[1]
        local dev
        for _, devId in ipairs(s.active) do
            local d = getDevice(sys, devId)
            if d and d.zone == zone then dev = d break end
        end
        if not dev then
            for _, d in ipairs(sys.devices) do if d.type == 'panel' then dev = d break end end
        end
        local ok, err = pcall(Config.Dispatch.Send, {
            system = sys.label, systemId = id, zone = zone, zoneName = zoneName(sys, zone),
            device = dev and dev.label or nil, reason = dev and TYPE_NAMES[dev.type] or 'Fire alarm',
            coords = dev and devCoords(dev) or nil,
        })
        if not ok then print(('[vinewood_firealarm] Dispatch.Send error: %s'):format(err)) end
        addEvent(id, 'Fire service called by ARC')
        syncState(id)
    end)
end

local function TriggerAlarm(id, zone, devId, reason, actor)
    local sys, st = Systems[id], States[id]
    if not sys then return false, 'Unknown system' end
    zone = tonumber(zone)
    if not zone or zone < 1 or zone > Config.MaxZones then return false, 'Invalid zone' end

    local dev = devId and getDevice(sys, devId)
    local what = dev and dev.label ~= '' and dev.label or reason or 'Activation'

    if contains(st.disabled, zone) then
        addEvent(id, ('Disabled zone activation Z%02d %s'):format(zone, what), actor)
        syncState(id)
        return false, 'Zone disabled'
    end

    if st.test then
        addEvent(id, ('Test Z%02d %s'):format(zone, what), actor)
        local untilT = os.time() + Config.TestSoundDuration
        st.testUntil = untilT
        syncState(id)
        SetTimeout(Config.TestSoundDuration * 1000, function()
            if st.testUntil == untilT then st.testUntil = nil syncState(id) end
        end)
        return true
    end

    if devId then addUnique(st.active, devId) end
    local newZone = not contains(st.zones, zone)
    if newZone then st.zones[#st.zones + 1] = zone end

    if not st.fire then
        st.fire = true
        st.alarmAt = os.time()
        st.alarmToken = st.alarmToken + 1
        st.silenced = false
        st.dispatched = false
        scheduleDispatch(id)
    elseif newZone and st.silenced and Config.NewZoneResounds then
        st.silenced = false
    end

    addEvent(id, ('Fire Z%02d %s — %s'):format(zone, zoneName(sys, zone), what), actor)
    syncState(id)
    webhook('Fire alarm activation', ('**%s**\nZone %d — %s\nDevice: %s\nBy: %s'):format(sys.label, zone, zoneName(sys, zone), what, actor or 'n/a'))
    return true
end

local function ResetSystem(id, actor, force)
    local sys, st = Systems[id], States[id]
    if not sys then return false, 'Unknown system' end
    if Config.RequireCallPointReset and not force then
        for _, devId in ipairs(st.active) do
            local d = getDevice(sys, devId)
            if d and d.type == 'mcp' then
                return false, ('Call point still active: Z%02d %s'):format(d.zone, d.label)
            end
        end
    end
    st.fire, st.zones, st.active = false, {}, {}
    st.silenced, st.evacuate, st.testUntil = false, false, nil
    st.alarmAt, st.dispatched = nil, false
    st.alarmToken = st.alarmToken + 1
    addEvent(id, force and 'System reset (forced)' or 'System reset', actor)
    syncState(id)
    return true
end

local function SilenceSystem(id, actor)
    local st = States[id]
    if not st then return false, 'Unknown system' end
    if not (st.fire or st.evacuate or st.testUntil) then return false, 'Nothing to silence' end
    st.silenced = true
    addEvent(id, 'Sounders silenced', actor)
    syncState(id)
    return true
end

---------------------------------------------------------------------
-- Load
---------------------------------------------------------------------
MySQL.ready(function()
    MySQL.query.await([[
        CREATE TABLE IF NOT EXISTS `vinewood_firealarm` (
          `id` INT NOT NULL AUTO_INCREMENT,
          `label` VARCHAR(100) NOT NULL,
          `data` LONGTEXT NOT NULL,
          `created_at` TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
          PRIMARY KEY (`id`)
        ) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4
    ]])
    local rows = MySQL.query.await('SELECT * FROM vinewood_firealarm') or {}
    for _, row in ipairs(rows) do
        local sys = json.decode(row.data) or {}
        sys.id, sys.label = row.id, row.label
        Systems[row.id] = defaults(sys)
        States[row.id] = newState(Systems[row.id])
    end
    print(('[vinewood_firealarm] loaded %d system(s)'):format(#rows))
    TriggerClientEvent('vinewood_firealarm:refresh', -1)
end)

AddEventHandler('playerDropped', function()
    local src = source
    Sessions[src], Attempts[src], Cooldowns[src] = nil, nil, nil
end)

---------------------------------------------------------------------
-- Player callbacks
---------------------------------------------------------------------
lib.callback.register('vinewood_firealarm:getAll', function()
    local systems, states = {}, {}
    for id, sys in pairs(Systems) do
        systems[#systems + 1] = publicSystem(sys)
        states[tostring(id)] = publicState(id)
    end
    return systems, states
end)

lib.callback.register('vinewood_firealarm:openPanel', function(src, id)
    local sys = Systems[id]
    if not sys or not nearPanel(src, sys) then return false end
    local level = GetAccess(src, sys)
    touchSession(src, id)
    return { level = level, state = publicState(id, level >= 3), system = publicSystem(sys) }
end)

lib.callback.register('vinewood_firealarm:enterCode', function(src, id, code)
    local sys = Systems[id]
    if not sys or not nearPanel(src, sys) then return false, 'Too far from panel' end
    local a = Attempts[src] or { count = 0, lockedUntil = 0 }
    Attempts[src] = a
    if a.lockedUntil > os.time() then return false, 'Keypad locked' end

    code = tostring(code or '')
    local level
    if sys.engineerCode ~= '' and code == sys.engineerCode then level = 3
    elseif sys.userCode ~= '' and code == sys.userCode then level = 2 end

    if not level then
        a.count = a.count + 1
        if a.count >= Config.MaxCodeAttempts then
            a.count, a.lockedUntil = 0, os.time() + Config.CodeLockout
            addEvent(id, 'Keypad lockout — too many wrong codes', Bridge.GetName(src))
            syncState(id)
            return false, 'Keypad locked'
        end
        return false, 'Invalid code'
    end

    a.count = 0
    Sessions[src] = Sessions[src] or {}
    Sessions[src][id] = { level = level, expires = os.time() + Config.AccessTimeout }
    addEvent(id, ('Access level %d entered'):format(level), Bridge.GetName(src))
    syncState(id)
    return GetAccess(src, sys)
end)

local Actions = {
    silence = { level = 2, fn = function(src, id) return SilenceSystem(id, Bridge.GetName(src)) end },
    resound = { level = 2, fn = function(src, id)
        local st = States[id]
        if not st.silenced then return false, 'Sounders are not silenced' end
        st.silenced = false
        addEvent(id, 'Sounders resounded', Bridge.GetName(src))
        syncState(id)
        return true
    end },
    reset = { level = 2, fn = function(src, id) return ResetSystem(id, Bridge.GetName(src)) end },
    evacuate = { level = 2, fn = function(src, id)
        local st = States[id]
        st.evacuate, st.silenced = true, false
        addEvent(id, 'Evacuate activated', Bridge.GetName(src))
        syncState(id)
        return true
    end },
    toggleZone = { level = 2, fn = function(src, id, zone)
        zone = tonumber(zone)
        if not zone or zone < 1 or zone > Config.MaxZones then return false, 'Invalid zone' end
        local sys, st = Systems[id], States[id]
        if contains(st.disabled, zone) then
            removeVal(st.disabled, zone)
            addEvent(id, ('Zone %d enabled'):format(zone), Bridge.GetName(src))
        else
            addUnique(st.disabled, zone)
            table.sort(st.disabled)
            addEvent(id, ('Zone %d disabled'):format(zone), Bridge.GetName(src))
        end
        sys.disabled = st.disabled
        persist(id)
        syncState(id)
        return true
    end },
    testMode = { level = 3, fn = function(src, id)
        local st = States[id]
        if st.fire then return false, 'Reset the fire condition first' end
        st.test = not st.test
        st.testUntil = nil
        addEvent(id, st.test and 'Test mode on' or 'Test mode off', Bridge.GetName(src))
        syncState(id)
        return true
    end },
    logout = { level = 1, fn = function(src, id)
        if Sessions[src] then Sessions[src][id] = nil end
        return true
    end },
}

lib.callback.register('vinewood_firealarm:panelAction', function(src, id, action, arg)
    local sys = Systems[id]
    local a = Actions[action]
    if not sys or not a then return { ok = false, msg = 'Unknown action' } end
    if not nearPanel(src, sys) then return { ok = false, msg = 'Too far from panel' } end
    local level = GetAccess(src, sys)
    if level < a.level then return { ok = false, msg = ('Access level %d required'):format(a.level), level = level } end
    touchSession(src, id)
    local ok, msg = a.fn(src, id, arg)
    level = GetAccess(src, sys)
    return { ok = ok, msg = msg, level = level, state = publicState(id, level >= 3) }
end)

lib.callback.register('vinewood_firealarm:breakGlass', function(src, id, devId)
    local sys = Systems[id]
    local d = sys and getDevice(sys, devId)
    if not d or d.type ~= 'mcp' or not nearDevice(src, d) then return false, 'Too far away' end
    if contains(States[id].active, devId) then return false, 'Already activated' end
    local last = Cooldowns[src]
    if last and os.time() - last < Config.BreakGlassCooldown then return false, 'You need to wait before doing that again' end
    Cooldowns[src] = os.time()
    return TriggerAlarm(id, d.zone, devId, 'Manual call point', Bridge.GetName(src))
end)

lib.callback.register('vinewood_firealarm:resetDevice', function(src, id, devId)
    local sys = Systems[id]
    local d = sys and getDevice(sys, devId)
    if not d or not nearDevice(src, d) then return false, 'Too far away' end
    if GetAccess(src, sys) < 2 then return false, 'You need the reset key (level 2 access)' end
    local st = States[id]
    if not contains(st.active, devId) then return false, 'Device is not active' end
    removeVal(st.active, devId)
    addEvent(id, ('Device reset Z%02d %s'):format(d.zone, d.label), Bridge.GetName(src))
    syncState(id)
    return true
end)

lib.callback.register('vinewood_firealarm:testDevice', function(src, id, devId)
    local sys = Systems[id]
    local d = sys and getDevice(sys, devId)
    if not d or not nearDevice(src, d, 5.0) then return false, 'Too far away' end
    if GetAccess(src, sys) < 3 then return false, 'Engineer access required' end
    return TriggerAlarm(id, d.zone, devId, TYPE_NAMES[d.type] .. ' test', Bridge.GetName(src))
end)

---------------------------------------------------------------------
-- Admin
---------------------------------------------------------------------
local function adminList()
    local list = {}
    for id, sys in pairs(Systems) do
        local s = lib.table.deepclone(sys)
        s.state = publicState(id, true)
        list[#list + 1] = s
    end
    table.sort(list, function(a, b) return a.id < b.id end)
    return list
end

local function isAdmin(src) return Bridge.IsAdmin(src) end

lib.callback.register('vinewood_firealarm:admin:open', function(src)
    if not isAdmin(src) then return false end
    return { systems = adminList(), maxZones = Config.MaxZones, tones = { 'bs_alternating', 'alternating', 'continuous', 'pulsed', 'sweep' } }
end)

local function cleanCode(c)
    c = tostring(c or ''):gsub('%D', '')
    return c:sub(1, 6)
end

lib.callback.register('vinewood_firealarm:admin:save', function(src, data)
    if not isAdmin(src) or type(data) ~= 'table' then return false end
    local label = tostring(data.label or ''):sub(1, 100)
    if label == '' then return false, 'Give the system a name' end

    local fields = {
        job = tostring(data.job or ''):sub(1, 50),
        jobGrade = tonumber(data.jobGrade) or 0,
        userCode = cleanCode(data.userCode),
        engineerCode = cleanCode(data.engineerCode),
        tone = data.tone or Config.DefaultTone,
        radius = math.min(math.max(tonumber(data.radius) or Config.DefaultSoundRadius, 5.0), 200.0),
        dispatch = data.dispatch and true or false,
        dispatchDelay = math.min(math.max(tonumber(data.dispatchDelay) or Config.Dispatch.defaultDelay, 0), 600),
        zones = {},
    }
    for z = 1, Config.MaxZones do
        local n = data.zones and data.zones[z]
        fields.zones[z] = (n and tostring(n) ~= '') and tostring(n):sub(1, 40) or ('Zone %d'):format(z)
    end

    local id = tonumber(data.id)
    if id and Systems[id] then
        local sys = Systems[id]
        sys.label = label
        for k, v in pairs(fields) do sys[k] = v end
        persist(id)
    else
        local sys = defaults(fields)
        sys.label = label
        local store = {}
        for k, v in pairs(sys) do if k ~= 'label' then store[k] = v end end
        id = MySQL.insert.await('INSERT INTO vinewood_firealarm (label, data) VALUES (?, ?)', { label, json.encode(store) })
        sys.id = id
        Systems[id] = sys
        States[id] = newState(sys)
    end
    syncSystem(id)
    syncState(id)
    return adminList(), id
end)

lib.callback.register('vinewood_firealarm:admin:delete', function(src, id)
    if not isAdmin(src) or not Systems[id] then return false end
    MySQL.query.await('DELETE FROM vinewood_firealarm WHERE id = ?', { id })
    Systems[id], States[id] = nil, nil
    syncSystem(id)
    syncState(id)
    return adminList()
end)

lib.callback.register('vinewood_firealarm:admin:addDevice', function(src, id, dev)
    local sys = Systems[id]
    if not isAdmin(src) or not sys or type(dev) ~= 'table' then return false end
    if not DEVICE_TYPES[dev.type] then return false, 'Unknown device type' end
    local zone = tonumber(dev.zone) or 1
    if zone < 1 or zone > Config.MaxZones then zone = 1 end
    local d = {
        id = sys.nextId,
        type = dev.type,
        zone = zone,
        label = tostring(dev.label or ''):sub(1, 40),
        mode = dev.mode == 'prop' and 'prop' or 'target',
        surface = dev.surface or 'wall',
        x = tonumber(dev.x) + 0.0, y = tonumber(dev.y) + 0.0, z = tonumber(dev.z) + 0.0,
        h = (tonumber(dev.h) or 0.0) + 0.0,
        pitch = (tonumber(dev.pitch) or 0.0) + 0.0,
    }
    if d.label == '' then d.label = ('%s %d'):format(TYPE_NAMES[d.type], d.id) end
    sys.nextId = sys.nextId + 1
    sys.devices[#sys.devices + 1] = d
    persist(id)
    syncSystem(id)
    return adminList()
end)

lib.callback.register('vinewood_firealarm:admin:updateDevice', function(src, id, devId, fields)
    local sys = Systems[id]
    local d = sys and getDevice(sys, devId)
    if not isAdmin(src) or not d then return false end
    if fields.label then d.label = tostring(fields.label):sub(1, 40) end
    if fields.zone then
        local z = tonumber(fields.zone)
        if z and z >= 1 and z <= Config.MaxZones then d.zone = z end
    end
    if fields.x and fields.y and fields.z then
        d.x, d.y, d.z = tonumber(fields.x) + 0.0, tonumber(fields.y) + 0.0, tonumber(fields.z) + 0.0
        d.h = (tonumber(fields.h) or d.h) + 0.0
        d.surface = fields.surface or d.surface
        if fields.mode then d.mode = fields.mode == 'prop' and 'prop' or 'target' end
    end
    persist(id)
    syncSystem(id)
    return adminList()
end)

lib.callback.register('vinewood_firealarm:admin:deleteDevice', function(src, id, devId)
    local sys = Systems[id]
    if not isAdmin(src) or not sys then return false end
    for i, d in ipairs(sys.devices) do
        if d.id == devId then table.remove(sys.devices, i) break end
    end
    removeVal(States[id].active, devId)
    persist(id)
    syncSystem(id)
    syncState(id)
    return adminList()
end)

lib.callback.register('vinewood_firealarm:admin:trigger', function(src, id, zone)
    if not isAdmin(src) or not Systems[id] then return false end
    TriggerAlarm(id, zone, nil, 'Admin test', Bridge.GetName(src))
    return adminList()
end)

lib.callback.register('vinewood_firealarm:admin:reset', function(src, id)
    if not isAdmin(src) or not Systems[id] then return false end
    ResetSystem(id, Bridge.GetName(src), true)
    return adminList()
end)

lib.callback.register('vinewood_firealarm:isAdmin', function(src) return isAdmin(src) end)

---------------------------------------------------------------------
-- Exports (server)
---------------------------------------------------------------------
exports('TriggerZone', function(id, zone, reason)
    return TriggerAlarm(tonumber(id), zone, nil, reason or 'External input', 'export')
end)

-- For fire scripts: finds the nearest detector to coords and activates it
exports('TriggerAtCoords', function(coords, reason, range)
    coords = vector3(coords.x, coords.y, coords.z)
    range = range or Config.DetectorRange
    local best, bestSys, bestDist
    for id, sys in pairs(Systems) do
        for _, d in ipairs(sys.devices) do
            if d.type == 'detector' then
                local dist = #(coords - devCoords(d))
                if dist <= range and (not bestDist or dist < bestDist) then
                    best, bestSys, bestDist = d, id, dist
                end
            end
        end
    end
    if not best then return false end
    if contains(States[bestSys].active, best.id) then return true, bestSys end
    return TriggerAlarm(bestSys, best.zone, best.id, reason or 'Smoke detector', 'detector'), bestSys
end)

exports('ResetSystem', function(id, force) return ResetSystem(tonumber(id), 'export', force) end)
exports('SilenceSystem', function(id) return SilenceSystem(tonumber(id), 'export') end)
exports('GetSystemState', function(id) return publicState(tonumber(id), true) end)
exports('GetSystems', function()
    local list = {}
    for _, sys in pairs(Systems) do list[#list + 1] = publicSystem(sys) end
    return list
end)
