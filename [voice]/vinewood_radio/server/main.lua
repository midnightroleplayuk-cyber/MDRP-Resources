local pma = exports['pma-voice']

local Radios = {}     -- [src] = unit
local ByIssi = {}     -- [issi] = src
local Calls = {}      -- [id] = { a, b, state, channel }
local CallOf = {}     -- [src] = callId
local Civ = {}        -- [src] = current civ frequency (0 = on, not tuned)
local CivSpeaker = {} -- [src] = true when the walkie is on loudspeaker
local nextCallId = 1

local TG = {}         -- [id] = group (with .folder, .services)
local ChannelTG = {}  -- [channel] = id

for _, folder in ipairs(Config.Talkgroups) do
    for _, g in ipairs(folder.groups) do
        g.folder = folder.label
        g.services = g.services or folder.services
        TG[g.id] = g
        ChannelTG[g.channel] = g.id
    end
end

---------------------------------------------------------------------------
-- Access control
---------------------------------------------------------------------------
local function getService(src)
    local job, grade, duty, jobType = Bridge.GetJob(src)
    if not job then return nil, 'no_character' end

    for key, svc in pairs(Config.Services) do
        local min = svc.jobs and svc.jobs[job]
        local typeMatch = jobType and svc.jobTypes and lib.table.contains(svc.jobTypes, jobType)
        if min ~= nil or typeMatch then
            if min and grade < min then return nil, 'grade' end
            if Config.RequireOnDuty and not duty then return nil, 'off_duty' end
            return key, grade
        end
    end

    return nil, 'unauthorised'
end

local function canUseGroup(serviceKey, grade, g)
    if not g or not lib.table.contains(g.services, serviceKey) then return false end
    if g.minGrade then
        local min = type(g.minGrade) == 'table' and g.minGrade[serviceKey] or g.minGrade
        if type(min) == 'number' and grade < min then return false end
    end
    return true
end

local function buildFolders(serviceKey, grade)
    local out = {}
    for _, folder in ipairs(Config.Talkgroups) do
        local groups = {}
        for _, g in ipairs(folder.groups) do
            if canUseGroup(serviceKey, grade, g) then
                groups[#groups + 1] = { id = g.id, name = g.name, channel = g.channel }
            end
        end
        if #groups > 0 then out[#out + 1] = { label = folder.label, groups = groups } end
    end
    return out
end

-- pma-voice channel locks: applies to every radio script on the server
local function canJoinChannel(src, channel)
    local unit = Radios[src]
    if not unit then return false end
    local service, grade = getService(src)
    if not service then return false end
    local id = ChannelTG[channel]
    if id then return canUseGroup(service, grade, TG[id]) end
    return true
end

CreateThread(function()
    local r = Config.ReservedChannels
    local done = {}
    for ch = r.min, r.max do
        done[ch] = true
        pma:addChannelCheck(ch, function(source) return canJoinChannel(source, ch) end)
    end
    for ch in pairs(ChannelTG) do
        if not done[ch] then
            pma:addChannelCheck(ch, function(source) return canJoinChannel(source, ch) end)
        end
    end
end)

---------------------------------------------------------------------------
-- Directory (who's online, for contacts + RX caller display)
---------------------------------------------------------------------------
local function unitInfo(src)
    local u = Radios[src]
    if not u then return nil end
    return {
        src = src,
        issi = u.issi,
        callsign = u.callsign,
        service = Config.Services[u.service].label,
        serviceKey = u.service,
        talkgroup = u.tg and TG[u.tg] and TG[u.tg].name or nil,
        tg = u.tg,
        tg2 = u.tg2,
        talkgroup2 = u.tg2 and TG[u.tg2] and TG[u.tg2].name or nil,
        inCall = u.inCall == true,
    }
end

local directoryQueued = false
local function broadcastDirectory()
    if directoryQueued then return end
    directoryQueued = true
    SetTimeout(250, function()
        directoryQueued = false
        local list = {}
        for src in pairs(Radios) do list[#list + 1] = unitInfo(src) end
        for src in pairs(Radios) do TriggerClientEvent('vinewood_radio:directory', src, list) end
    end)
end

---------------------------------------------------------------------------
-- Talkgroups
---------------------------------------------------------------------------
local function joinGroup(src, id)
    local u = Radios[src]
    local g = TG[id]
    if not u or not g or not canUseGroup(u.service, u.grade, g) then return false end
    u.tg = id
    if u.tg2 == id then u.tg2 = nil; DB.SetSecondaryTalkgroup(u.ident, nil) end
    if not u.inCall then pma:setPlayerRadio(src, g.channel) end -- in a PTP call: rejoins when it ends
    DB.SetLastTalkgroup(u.ident, id)
    broadcastDirectory()
    return true
end

---------------------------------------------------------------------------
-- PTP calls
---------------------------------------------------------------------------
-- pma-voice may already have dropped a leaving player; don't let that break the call teardown
local function safeCall(p, channel)
    if GetPlayerName(p) then pcall(pma.setPlayerCall, pma, p, channel) end
end
local function safeRadio(p, channel)
    if GetPlayerName(p) then pcall(pma.setPlayerRadio, pma, p, channel) end
end

local function endCall(id, reason)
    local c = Calls[id]
    if not c then return end
    Calls[id] = nil
    for _, p in ipairs({ c.a, c.b }) do
        if CallOf[p] == id then CallOf[p] = nil end
        if c.state == 'active' then safeCall(p, 0) end
        local u = Radios[p]
        if u and u.inCall then
            u.inCall = nil
            if u.tg and TG[u.tg] then safeRadio(p, TG[u.tg].channel) end -- back onto the talkgroup
        end
        -- a control caller has no terminal to tell
        if u and not (c.control and p == c.a) then TriggerClientEvent('vinewood_radio:ptpEnded', p, reason or 'ended') end
    end
    if c.control then
        TriggerEvent('vinewood_radio:server:controlCallState', id, c.a, c.b, 'ended', reason or 'ended')
    end
    broadcastDirectory()
end

---------------------------------------------------------------------------
-- Power
---------------------------------------------------------------------------
local function cleanup(src, reason)
    local u = Radios[src]
    if not u then return end
    if CallOf[src] then endCall(CallOf[src], 'unavailable') end
    pma:setPlayerRadio(src, 0)
    if ByIssi[u.issi] == src then ByIssi[u.issi] = nil end
    Radios[src] = nil
    broadcastDirectory()
    Hooks.OnPowerOff(src, reason)
end

local function forceOff(src, reason)
    if not Radios[src] then return end
    cleanup(src, reason)
    TriggerClientEvent('vinewood_radio:forceOff', src, reason)
end

lib.callback.register('vinewood_radio:powerOn', function(src)
    if Radios[src] then cleanup(src, 'restart') end
    Civ[src] = nil -- only one radio can hold the pma-voice channel

    if Config.Item.required and not Bridge.HasItem(src, Config.Item.name) then
        return { ok = false, reason = 'no_item' }
    end

    local service, gradeOrReason = getService(src)
    if not service then return { ok = false, reason = gradeOrReason } end
    local grade = gradeOrReason

    local ident = Bridge.GetIdentifier(src)
    if not ident then return { ok = false, reason = 'no_character' } end

    local rec = DB.Get(ident, service)
    if not rec then return { ok = false, reason = 'error' } end
    if not Radios[src] and getService(src) ~= service then return { ok = false, reason = 'reprogrammed' } end

    -- Another session still holding this ISSI (e.g. relog) gets kicked off the network
    local holder = ByIssi[rec.issi]
    if holder and holder ~= src then forceOff(holder, 'duplicate') end

    Radios[src] = {
        ident = ident,
        issi = rec.issi,
        callsign = rec.callsign,
        service = service,
        grade = grade,
        name = Bridge.GetName(src),
        speaker = Config.Speaker.tetraDefault == true,
    }
    ByIssi[rec.issi] = src

    local folders = buildFolders(service, grade)
    local startTg = rec.lastTg
    if not (startTg and canUseGroup(service, grade, TG[startTg])) then
        startTg = folders[1] and folders[1].groups[1].id or nil
    end
    if startTg then joinGroup(src, startTg) end

    local startTg2 = Config.Secondary.enabled and rec.lastTg2 or nil
    if startTg2 and (startTg2 == startTg or not canUseGroup(service, grade, TG[startTg2])) then startTg2 = nil end
    Radios[src].tg2 = startTg2

    local list = {}
    for s in pairs(Radios) do list[#list + 1] = unitInfo(s) end
    broadcastDirectory()
    Hooks.OnPowerOn(src, unitInfo(src))

    return {
        ok = true,
        issi = rec.issi,
        callsign = rec.callsign,
        service = Config.Services[service].label,
        name = Radios[src].name,
        folders = folders,
        tg = startTg,
        tg2 = startTg2,
        volume = rec.volume,
        directory = list,
        speaker = Radios[src].speaker,
        me = src,
    }
end)

RegisterNetEvent('vinewood_radio:powerOff', function()
    cleanup(source, 'user')
end)

AddEventHandler('playerDropped', function()
    Civ[source] = nil
    CivSpeaker[source] = nil
    if CallOf[source] then endCall(CallOf[source], 'unavailable') end
    cleanup(source, 'dropped')
end)

lib.callback.register('vinewood_radio:setTalkgroup', function(src, id)
    return joinGroup(src, id)
end)

lib.callback.register('vinewood_radio:setCallsign', function(src, text)
    local u = Radios[src]
    if not u or type(text) ~= 'string' then return false end
    text = text:gsub('[^%w %-/]', ''):gsub('^%s+', ''):gsub('%s+$', ''):upper():sub(1, math.min(Config.CallsignMaxLength or 24, 32))
    if text == '' then return false end
    u.callsign = text
    DB.SetCallsign(u.ident, text)
    broadcastDirectory()
    return text
end)

lib.callback.register('vinewood_radio:setSecondary', function(src, id)
    local u = Radios[src]
    if not u or not Config.Secondary.enabled then return { ok = false } end
    if id == nil or id == false or id == '' then
        u.tg2 = nil
    else
        local g = TG[id]
        if not g or id == u.tg or not canUseGroup(u.service, u.grade, g) then return { ok = false } end
        u.tg2 = id
    end
    DB.SetSecondaryTalkgroup(u.ident, u.tg2)
    broadcastDirectory()
    return { ok = true, tg2 = u.tg2 }
end)

lib.callback.register('vinewood_radio:setSpeaker', function(src, on)
    local u = Radios[src]
    if not u or not Config.Speaker.enabled then return { ok = false } end
    u.speaker = on == true
    return { ok = true, speaker = u.speaker }
end)

RegisterNetEvent('vinewood_radio:setVolume', function(vol)
    local u = Radios[source]
    vol = tonumber(vol)
    if not u or not vol then return end
    DB.SetVolume(u.ident, math.floor(math.max(0, math.min(100, vol))))
end)

---------------------------------------------------------------------------
-- Revalidation (job change, off duty, item removed, rank change)
---------------------------------------------------------------------------
local lastCheck = {}
local function revalidate(src)
    local u = Radios[src]
    if not u then return end
    if Config.Item.required and not Bridge.HasItem(src, Config.Item.name) then return forceOff(src, 'no_item') end
    local service, gradeOrReason = getService(src)
    if not service then return forceOff(src, gradeOrReason) end
    if service ~= u.service or gradeOrReason ~= u.grade then return forceOff(src, 'reprogrammed') end
end

RegisterNetEvent('vinewood_radio:revalidate', function()
    local src = source
    if lastCheck[src] and os.time() - lastCheck[src] < 2 then return end
    lastCheck[src] = os.time()
    SetTimeout(500, function() revalidate(src) end) -- give the framework a moment to commit the job change
end)

CreateThread(function()
    while true do
        Wait(Config.RevalidateInterval * 1000)
        local list = {}
        for src in pairs(Radios) do list[#list + 1] = src end
        for _, src in ipairs(list) do revalidate(src) end
    end
end)

---------------------------------------------------------------------------
-- PTP events
---------------------------------------------------------------------------
RegisterNetEvent('vinewood_radio:ptpDial', function(issi)
    local src = source
    local me = Radios[src]
    if not me or not Config.PTP.enabled or CallOf[src] then return end

    issi = tostring(issi or ''):gsub('%D', '')
    local target = ByIssi[issi]

    if issi == '' or issi == me.issi then return TriggerClientEvent('vinewood_radio:ptpEnded', src, 'invalid') end
    if not target or not Radios[target] then return TriggerClientEvent('vinewood_radio:ptpEnded', src, 'unavailable') end
    if CallOf[target] then return TriggerClientEvent('vinewood_radio:ptpEnded', src, 'busy') end
    if not Config.PTP.crossService and Radios[target].service ~= me.service then
        return TriggerClientEvent('vinewood_radio:ptpEnded', src, 'restricted')
    end

    local id = nextCallId
    nextCallId = nextCallId + 1
    Calls[id] = { a = src, b = target, state = 'ringing', channel = Config.PTP.callChannelBase + id }
    CallOf[src], CallOf[target] = id, id

    TriggerClientEvent('vinewood_radio:ptpRinging', src, unitInfo(target))
    TriggerClientEvent('vinewood_radio:ptpIncoming', target, unitInfo(src))

    SetTimeout(Config.PTP.ringTime * 1000, function()
        local c = Calls[id]
        if c and c.state == 'ringing' then endCall(id, 'no_answer') end
    end)
end)

RegisterNetEvent('vinewood_radio:ptpAnswer', function()
    local src = source
    local id = CallOf[src]
    local c = id and Calls[id]
    if not c or c.state ~= 'ringing' or c.b ~= src then return end
    c.state = 'active'
    for _, p in ipairs({ c.a, c.b }) do
        if Config.PTP.leaveTalkgroup and Radios[p] then
            Radios[p].inCall = true
            pma:setPlayerRadio(p, 0) -- off the talkgroup for the duration of the call
        end
        pma:setPlayerCall(p, c.channel)
    end
    broadcastDirectory()
    if c.control then
        TriggerEvent('vinewood_radio:server:controlCallState', id, c.a, c.b, 'active')
    else
        TriggerClientEvent('vinewood_radio:ptpConnected', c.a)
    end
    TriggerClientEvent('vinewood_radio:ptpConnected', c.b)
end)

RegisterNetEvent('vinewood_radio:ptpEnd', function()
    local src = source
    local id = CallOf[src]
    local c = id and Calls[id]
    if not c then return end
    local reason = (c.state == 'ringing' and c.b == src) and 'rejected' or 'ended'
    endCall(id, reason)
end)

---------------------------------------------------------------------------
-- Emergency button
---------------------------------------------------------------------------
local function inScope(me, other)
    if Config.Emergency.scope == 'all' then return true end
    if Config.Emergency.scope == 'service' then return other.service == me.service end
    return other.tg ~= nil and (other.tg == me.tg or other.tg2 == me.tg)
end

lib.callback.register('vinewood_radio:emergency', function(src, street)
    local me = Radios[src]
    if not me or not Config.Emergency.enabled then return false end
    local now = os.time()
    if me.lastEmergency and now - me.lastEmergency < Config.Emergency.cooldown then return false end
    me.lastEmergency = now
    me.emergency = true

    local c = GetEntityCoords(GetPlayerPed(src))
    local payload = {
        src = src,
        issi = me.issi,
        callsign = me.callsign,
        service = Config.Services[me.service].label,
        serviceKey = me.service,
        talkgroup = me.tg and TG[me.tg].name or '',
        street = type(street) == 'string' and street:sub(1, 80) or '',
        coords = { x = c.x, y = c.y, z = c.z },
    }

    for s, u in pairs(Radios) do
        if s ~= src and inScope(me, u) then
            TriggerClientEvent('vinewood_radio:emergencyAlert', s, payload)
        end
    end

    payload.coords = c
    Hooks.OnEmergency(src, payload)
    return true
end)

RegisterNetEvent('vinewood_radio:emergencyCancel', function()
    local src = source
    local me = Radios[src]
    if not me or not me.emergency then return end
    me.emergency = false
    for s, u in pairs(Radios) do
        if s ~= src and inScope(me, u) then
            TriggerClientEvent('vinewood_radio:emergencyCleared', s, me.issi)
        end
    end
end)

---------------------------------------------------------------------------
-- Civilian / gang handheld
---------------------------------------------------------------------------
local CivCfg = Config.CivRadio

local function canJoinPrivate(src, rule)
    local gang = Bridge.GetGang(src)
    if gang and rule.gangs and lib.table.contains(rule.gangs, gang) then return true end
    local job = Bridge.GetJob(src)
    if job and rule.jobs and lib.table.contains(rule.jobs, job) then return true end
    return false
end

local function normaliseFreq(ch)
    ch = tonumber(ch)
    if not ch or ch ~= ch then return nil end
    if CivCfg.decimals then
        ch = math.floor(ch * 10 + 0.5) / 10
        if ch == math.floor(ch) then ch = math.tointeger(ch) or ch end
    else
        ch = math.floor(ch)
    end
    return ch
end

local function civOff(src, notifyClient)
    if Civ[src] == nil then return end
    Civ[src] = nil
    CivSpeaker[src] = nil
    if not Radios[src] then pma:setPlayerRadio(src, 0) end
    if notifyClient then TriggerClientEvent('vinewood_radio:civForceOff', src) end
end

if CivCfg.enabled then
    for ch, rule in pairs(CivCfg.private or {}) do
        pma:addChannelCheck(ch, function(source)
            return Civ[source] ~= nil and canJoinPrivate(source, rule)
        end)
    end
end

lib.callback.register('vinewood_radio:civPowerOn', function(src)
    if not CivCfg.enabled then return { ok = false } end
    if not Bridge.HasItem(src, CivCfg.item) then return { ok = false, reason = 'no_item' } end
    if Radios[src] then cleanup(src, 'switch') end
    Civ[src] = 0
    local hasEar = Bridge.HasItem(src, Config.Speaker.civEarpieceItem)
    CivSpeaker[src] = not hasEar
    return { ok = true, speaker = CivSpeaker[src], earpiece = hasEar }
end)

lib.callback.register('vinewood_radio:civSetSpeaker', function(src, on)
    if Civ[src] == nil then return { ok = false } end
    if not on and not Bridge.HasItem(src, Config.Speaker.civEarpieceItem) then
        CivSpeaker[src] = true
        return { ok = false, reason = 'no_earpiece', speaker = true }
    end
    CivSpeaker[src] = on == true
    return { ok = true, speaker = CivSpeaker[src] }
end)

RegisterNetEvent('vinewood_radio:civPowerOff', function()
    civOff(source, false)
end)

lib.callback.register('vinewood_radio:civSetChannel', function(src, ch)
    if Civ[src] == nil then return { ok = false, reason = 'off' } end
    ch = normaliseFreq(ch)
    if not ch or ch < CivCfg.min or ch > CivCfg.max then return { ok = false, reason = 'range' } end
    local rule = CivCfg.private and CivCfg.private[ch]
    if rule and not canJoinPrivate(src, rule) then return { ok = false, reason = 'encrypted' } end
    Civ[src] = ch
    pma:setPlayerRadio(src, ch)
    return { ok = true, channel = ch, private = rule ~= nil }
end)

CreateThread(function()
    while true do
        Wait(Config.RevalidateInterval * 1000)
        local list = {}
        for src in pairs(Civ) do list[#list + 1] = src end
        for _, src in ipairs(list) do
            if not Bridge.HasItem(src, CivCfg.item) then
                civOff(src, true)
            else
                if not CivSpeaker[src] and not Bridge.HasItem(src, Config.Speaker.civEarpieceItem) then
                    CivSpeaker[src] = true
                    TriggerClientEvent('vinewood_radio:civSpeaker', src, true)
                end
                local rule = Civ[src] and CivCfg.private and CivCfg.private[Civ[src]]
                if rule and not canJoinPrivate(src, rule) then
                    Civ[src] = 0
                    pma:setPlayerRadio(src, 0)
                    TriggerClientEvent('vinewood_radio:civKicked', src)
                end
            end
        end
    end
end)

---------------------------------------------------------------------------
-- Usable items (QB / Qbox without ox_inventory / ESX)
---------------------------------------------------------------------------
Bridge.RegisterUsableItem(Config.Item.name, function(source)
    TriggerClientEvent('vinewood_radio:open', source)
end)

if CivCfg.enabled then
    Bridge.RegisterUsableItem(CivCfg.item, function(source)
        TriggerClientEvent('vinewood_radio:openWalkie', source)
    end)
end

---------------------------------------------------------------------------
-- Exports (MDT, dispatch, etc.)
---------------------------------------------------------------------------
exports('IsRadioOn', function(src) return Radios[src] ~= nil end)
exports('GetUnit', function(src) return unitInfo(src) end)
exports('GetUnitByIssi', function(issi) local s = ByIssi[tostring(issi)]; return s and unitInfo(s) end)
exports('GetUnits', function()
    local list = {}
    for s in pairs(Radios) do list[#list + 1] = unitInfo(s) end
    return list
end)
exports('GetUnitsOnTalkgroup', function(id)
    local list = {}
    for s, u in pairs(Radios) do if u.tg == id then list[#list + 1] = unitInfo(s) end end
    return list
end)
exports('ForcePowerOff', function(src, reason) forceOff(src, reason or 'remote') end)

---Talkgroups this unit's terminal may join: { { label, groups = { { id, name, channel } } } }
exports('GetUnitTalkgroups', function(src)
    local u = Radios[tonumber(src)]
    if not u then return nil end
    return buildFolders(u.service, u.grade)
end)

---Moves a unit to a talkgroup from outside the radio (control room). The terminal switches and shows who moved it.
---@return boolean ok, string|nil err  'off' | 'not_permitted'
exports('SetUnitTalkgroup', function(src, id, by)
    src = tonumber(src)
    local u = Radios[src]
    if not u then return false, 'off' end
    if not joinGroup(src, id) then return false, 'not_permitted' end
    TriggerClientEvent('vinewood_radio:tgForced', src, id, type(by) == 'string' and by:sub(1, 40) or Config.Control.label)
    return true
end)

---Control room individual call: rings the unit's terminal from Control. The caller needs no radio;
---once answered both are on a pma-voice call channel (open mic, like a phone call).
---Progress is reported with TriggerEvent('vinewood_radio:server:controlCallState', callId, caller, target, state, reason)
---@return number|false callId, string|nil err  'disabled' | 'busy' | 'unavailable' | 'caller_busy' | 'invalid_caller' | 'invalid_target'
exports('ControlCall', function(caller, target, label)
    caller, target = tonumber(caller), tonumber(target)
    if not Config.PTP.enabled or not (Config.Control and Config.Control.enabled) then return false, 'disabled' end
    if not caller or not GetPlayerName(caller) then return false, 'invalid_caller' end
    if caller == target then return false, 'invalid_target' end
    if CallOf[caller] then return false, 'caller_busy' end
    if not target or not Radios[target] then return false, 'unavailable' end
    if CallOf[target] then return false, 'busy' end

    local id = nextCallId
    nextCallId = nextCallId + 1
    Calls[id] = { a = caller, b = target, state = 'ringing', channel = Config.PTP.callChannelBase + id, control = true }
    CallOf[caller], CallOf[target] = id, id

    TriggerClientEvent('vinewood_radio:ptpIncoming', target, {
        src = caller,
        issi = Config.Control.issi,
        callsign = type(label) == 'string' and label:sub(1, 32) or Config.Control.label,
        service = Config.Control.label,
    })
    TriggerEvent('vinewood_radio:server:controlCallState', id, caller, target, 'ringing')

    SetTimeout(Config.PTP.ringTime * 1000, function()
        local c = Calls[id]
        if c and c.state == 'ringing' then endCall(id, 'no_answer') end
    end)
    return id
end)

---Hangs up whatever call this player is in (control room hang-up button).
exports('EndCall', function(src)
    local id = CallOf[tonumber(src)]
    if id then endCall(id, 'ended') return true end
    return false
end)

---------------------------------------------------------------------------
-- Transmission routing beyond pma-voice's single radio channel:
--   * secondary talkgroups (people monitoring a talkgroup that isn't their pma-voice channel)
--   * loudspeaker radios (bystanders near a radio on speaker)
-- The talker adds everyone found here as extra voice targets; each listener's client
-- applies the radio filter and volume.
---------------------------------------------------------------------------
local Spk = Config.Speaker
local Tx = {} -- [talker] = { kind, channel, secondary, targets = { [bystander] = listener }, side = { [listener] = slot } }

local function primaryChannel(u) return u and u.tg and TG[u.tg] and TG[u.tg].channel end
local function secondaryChannel(u) return u and u.tg2 and TG[u.tg2] and TG[u.tg2].channel end

local function radioChannelOf(src)
    local u = Radios[src]
    if u and u.inCall then return nil end
    if u and u.tg and TG[u.tg] then return TG[u.tg].channel, 'tetra' end
    local c = Civ[src]
    if c and c ~= 0 then return c, 'civ' end
end

-- Does this player hear `channel` at all (pma-voice primary or our secondary)?
local function hearsChannel(src, channel)
    if radioChannelOf(src) == channel then return true end
    local u = Radios[src]
    return u and not u.inCall and secondaryChannel(u) == channel
end

-- The channel this transmission is on
local function txChannel(src, secondary)
    if secondary then
        local u = Radios[src]
        if not u or u.inCall or not Config.Secondary.enabled then return nil end
        return secondaryChannel(u), 'tetra'
    end
    return radioChannelOf(src)
end

local function speakerListeners(channel, talker)
    local out = {}
    for s, u in pairs(Radios) do
        if s ~= talker and u.speaker and not u.inCall and (primaryChannel(u) == channel or secondaryChannel(u) == channel) then
            out[#out + 1] = s
        end
    end
    for s, c in pairs(Civ) do
        if s ~= talker and c == channel and CivSpeaker[s] then out[#out + 1] = s end
    end
    return out
end

-- Listeners pma-voice won't reach for this transmission, and which of their slots it arrives on
local function sideListeners(channel, talker, secondary)
    local out = {}
    if not Config.Secondary.enabled then return out end
    for s, u in pairs(Radios) do
        if s ~= talker and not u.inCall then
            local p, q = primaryChannel(u), secondaryChannel(u)
            if secondary then
                -- talking on a secondary: pma-voice isn't involved, so everyone on it needs routing
                if p == channel then out[s] = 'primary' elseif q == channel then out[s] = 'secondary' end
            elseif q == channel and p ~= channel then
                out[s] = 'secondary'
            end
        end
    end
    return out
end

local function pedPos(src)
    local ped = GetPlayerPed(src)
    if not ped or ped == 0 or not DoesEntityExist(ped) then return nil end
    return GetEntityCoords(ped)
end

local function stopTx(talker)
    local t = Tx[talker]
    if not t then return end
    Tx[talker] = nil
    for pid in pairs(t.targets) do TriggerClientEvent('vinewood_radio:speakerStop', pid, talker) end
    for pid in pairs(t.side) do TriggerClientEvent('vinewood_radio:sideRx', pid, talker, false) end
    TriggerClientEvent('vinewood_radio:speakerTargets', talker, {})
end

local function updateTx(talker)
    local t = Tx[talker]
    if not t then return end
    local channel, kind = txChannel(talker, t.secondary)
    if channel ~= t.channel then return stopTx(talker) end

    local talkerPos = pedPos(talker)
    if not talkerPos then return stopTx(talker) end
    local bucket = GetPlayerRoutingBucket(talker)

    -- radio users who need routing
    local side = sideListeners(channel, talker, t.secondary)

    -- bystanders near loudspeaker radios
    local new = {}
    if Spk.enabled then
        local listeners = speakerListeners(channel, talker)
        if #listeners > 0 then
            local players = GetPlayers()
            for _, l in ipairs(listeners) do
                local lp = pedPos(l)
                if lp and GetPlayerRoutingBucket(l) == bucket then
                    for _, id in ipairs(players) do
                        local pid = tonumber(id)
                        if pid ~= talker and pid ~= l and not new[pid] and not side[pid] and not hearsChannel(pid, channel)
                            and GetPlayerRoutingBucket(pid) == bucket then
                            local pp = pedPos(pid)
                            if pp and #(pp - lp) <= Spk.range and #(pp - talkerPos) > Spk.skipNearTalker then
                                new[pid] = l
                            end
                        end
                    end
                end
            end
        end
    end

    local changed = false
    for pid, l in pairs(new) do
        if t.targets[pid] ~= l then
            changed = true
            TriggerClientEvent('vinewood_radio:speakerHear', pid, talker, l, kind)
        end
    end
    for pid in pairs(t.targets) do
        if not new[pid] then
            changed = true
            TriggerClientEvent('vinewood_radio:speakerStop', pid, talker)
        end
    end
    for pid, slot in pairs(side) do
        if t.side[pid] ~= slot then
            changed = true
            TriggerClientEvent('vinewood_radio:sideRx', pid, talker, true, slot)
        end
    end
    for pid in pairs(t.side) do
        if not side[pid] then
            changed = true
            TriggerClientEvent('vinewood_radio:sideRx', pid, talker, false)
        end
    end
    t.targets, t.side = new, side

    if changed then
        local list = {}
        for pid in pairs(new) do list[#list + 1] = pid end
        for pid in pairs(side) do list[#list + 1] = pid end
        TriggerClientEvent('vinewood_radio:speakerTargets', talker, list)
    end
end

local function startTx(src, secondary)
    stopTx(src)
    local channel, kind = txChannel(src, secondary)
    if not channel then return end
    Tx[src] = { kind = kind, channel = channel, secondary = secondary, targets = {}, side = {} }
    updateTx(src)
end

-- primary: pma-voice is transmitting; we only add secondary monitors and loudspeaker bystanders
RegisterNetEvent('vinewood_radio:tx', function(active)
    local src = source
    if not active then return stopTx(src) end
    startTx(src, false)
end)

-- secondary: the client is transmitting itself; we provide every listener on that talkgroup
RegisterNetEvent('vinewood_radio:tx2', function(active)
    local src = source
    if not active then return stopTx(src) end
    startTx(src, true)
end)

AddEventHandler('playerDropped', function()
    local src = source
    stopTx(src)
end)

CreateThread(function()
    while true do
        Wait(Spk.updateInterval or 500)
        for talker in pairs(Tx) do updateTx(talker) end
    end
end)
