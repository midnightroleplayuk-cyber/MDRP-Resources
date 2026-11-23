-- NDM_PublicDefib server. Everything is decided here: availability, distance, timing, the AED
-- analysis and whether a shock works. Clients only play animations and progress bars.

local Defs = {}       -- [id] = { label, coords = vector4 (interaction point), prop = vector4|nil, placed = bool }
local Cabinets = {}   -- [id] = { state = 'ready' | 'out' | 'restock', carrier, restockAt }
local Carriers = {}   -- [src] = { cabinet, takenAt, warned, used }
local Sessions = {}   -- [patient] = { user, analyses, lastAnalyse, shockAdvised, ospShockable, shocks }
local UserSession = {}-- [user] = patient
local Pending = {}    -- [src] = { action, arg, token, startedAt, duration }
local Cooldown = {}   -- [license] = os.time() the player may take a defib again

local SHOCKABLE = { vFib = true, vTach = true, torsades = true, VF = true, VT = true }
local KVP_KEY = 'placed_cabinets'

---------------------------------------------------------------------------
-- Helpers
---------------------------------------------------------------------------
local function notify(src, msg, kind)
    TriggerClientEvent('ox_lib:notify', src, { title = 'Defibrillator', description = msg, type = kind or 'inform' })
end

local function pedCoords(src)
    local ped = GetPlayerPed(src)
    if not ped or ped == 0 then return nil end
    return GetEntityCoords(ped)
end

local function dist(a, b)
    local ca, cb = pedCoords(a), type(b) == 'number' and pedCoords(b) or b
    if not ca or not cb then return math.huge end
    return #(ca - vector3(cb.x, cb.y, cb.z))
end

local function license(src)
    return GetPlayerIdentifierByType(src, 'license') or ('src:' .. src)
end

local function playerName(src)
    local ok, player = pcall(function() return exports.qbx_core:GetPlayer(src) end)
    local info = ok and player and player.PlayerData.charinfo
    local name = info and info.firstname and (info.firstname .. ' ' .. (info.lastname or '')) or 'Unknown'
    return ('%s (%s, ID %d)'):format(name, GetPlayerName(src) or '?', src)
end

local function bodyDamage(src)
    local bd = Player(src).state.BodyDamage
    return type(bd) == 'table' and bd or nil
end

-- osp: inLastStand = downed but breathing, isDead = cardiac arrest
local function patientState(src)
    local bd = bodyDamage(src)
    if bd and bd.isDead == true then return 'arrest', bd end
    if bd and bd.inLastStand == true then return 'laststand', bd end
    if Player(src).state.isDead == true then return 'arrest', bd end
    return nil, bd
end

local function ospShockable(bd)
    return bd ~= nil and (bd.shockableRythm == true or SHOCKABLE[tostring(bd.cardiacState or '')] == true)
end

local function ospLog(patient, text)
    if not Config.Use.OspLog then return end
    local bd = bodyDamage(patient)
    if not bd then return end
    if type(bd.MessageLog) ~= 'table' then bd.MessageLog = {} end
    table.insert(bd.MessageLog, os.date('%H:%M') .. ' | ' .. text)
    Player(patient).state:set('BodyDamage', bd, true)
    TriggerClientEvent('osp_ambulance:SaveDataCl', patient, bd, true)
end

local function v4(t) return vector4(t.x + 0.0, t.y + 0.0, t.z + 0.0, (t.w or 0) + 0.0) end
local function plain(v) return v and { x = v.x, y = v.y, z = v.z, w = v.w } or nil end

local function fmtCoords(v)
    return ('%.2f, %.2f, %.2f'):format(v.x, v.y, v.z)
end

---------------------------------------------------------------------------
-- Logs
---------------------------------------------------------------------------
local function log(title, colour, fields)
    if not Config.Logs.Enabled or type(PublicDefibWebhook) ~= 'string' or PublicDefibWebhook == '' then return end
    local list = {}
    for _, f in ipairs(fields or {}) do
        list[#list + 1] = { name = f[1], value = tostring(f[2]), inline = f[3] == true }
    end
    PerformHttpRequest(PublicDefibWebhook, function() end, 'POST', json.encode({
        username = Config.Logs.Username,
        embeds = { { title = title, color = colour, fields = list, timestamp = os.date('!%Y-%m-%dT%H:%M:%SZ') } },
    }), { ['Content-Type'] = 'application/json' })
end

local GREEN, RED, ORANGE, BLUE = 3066993, 15158332, 15105570, 3447003

---------------------------------------------------------------------------
-- Availability (GoodCiv medic count)
---------------------------------------------------------------------------
local medicCache, medicCacheAt = 0, -1

local function medicsOnDuty()
    if os.time() - medicCacheAt < 5 then return medicCache end
    local a = Config.Availability
    local count
    for _, res in ipairs({ a.GoodCivResource, a.GoodCivResource:lower() }) do
        if not count and GetResourceState(res) == 'started' then
            local ok, n = pcall(function() return exports[res]:GetOnDutyMedicCount() end)
            if ok and tonumber(n) then count = tonumber(n) end
        end
    end
    if not count then
        count = 0
        for _, job in ipairs(a.Jobs) do
            local ok, n = pcall(function() return exports.qbx_core:GetDutyCountJob(job) end)
            if ok and tonumber(n) then count = count + tonumber(n) end
        end
    end
    medicCache, medicCacheAt = count, os.time()
    return count
end

local function cabinetsUnlocked()
    if not Config.Availability.OnlyWhenNoMedics then return true end
    return medicsOnDuty() < Config.Availability.MinOnDuty
end

local function isRestockMedic(src)
    local ok, player = pcall(function() return exports.qbx_core:GetPlayer(src) end)
    local job = ok and player and player.PlayerData.job
    if not job then return false end
    local min = Config.Restock.Jobs[job.name]
    if not min then return false end
    if Config.Restock.RequireOnDuty and not job.onduty then return false end
    local grade = type(job.grade) == 'table' and job.grade.level or job.grade or 0
    return grade >= min
end

---------------------------------------------------------------------------
-- Cabinet list + state sync (clients only use this for targets / props / labels)
---------------------------------------------------------------------------
local function syncDefs()
    local out = {}
    for id, d in pairs(Defs) do
        out[id] = { label = d.label, coords = plain(d.coords), prop = plain(d.prop), model = d.model,
            placed = d.placed, noProp = d.noProp }
    end
    GlobalState.NDM_PublicDefib_defs = out
end

local function sync()
    local states = {}
    for id, c in pairs(Cabinets) do states[id] = c.state end
    GlobalState.NDM_PublicDefib = { cabinets = states, unlocked = cabinetsUnlocked() }
end

local function setCabinet(id, state)
    local c = Cabinets[id]
    if not c then return end
    c.state = state
    c.carrier = nil
    c.restockAt = state == 'restock' and Config.Restock.AutoMinutes > 0
        and (os.time() + Config.Restock.AutoMinutes * 60) or nil
    sync()
end

local function savePlaced()
    local list = {}
    for id, d in pairs(Defs) do
        if d.placed then
            list[#list + 1] = { id = id, label = d.label, coords = plain(d.coords), prop = plain(d.prop), noProp = d.noProp }
        end
    end
    SetResourceKvp(KVP_KEY, json.encode(list))
end

local function addDef(id, def)
    Defs[id] = def
    Cabinets[id] = Cabinets[id] or { state = 'ready' }
end

-- config cabinets: coords = where you stand facing the wall
for i, cab in ipairs(Config.Cabinets) do
    addDef('cfg_' .. i, { label = cab.label, coords = cab.coords, prop = cab.propCoords, model = cab.prop, placed = false })
end

-- cabinets placed in game
do
    local raw = GetResourceKvpString(KVP_KEY)
    local ok, list = pcall(json.decode, raw or '[]')
    for _, p in ipairs(ok and type(list) == 'table' and list or {}) do
        if type(p.id) == 'string' and p.coords then
            addDef(p.id, { label = p.label or 'Public defibrillator', coords = v4(p.coords),
                prop = p.prop and v4(p.prop) or nil, noProp = p.noProp == true, placed = true })
        end
    end
end

syncDefs()
sync()

---------------------------------------------------------------------------
-- Pads / carrying
---------------------------------------------------------------------------
local function endSession(patient, reason, notifyUser)
    local s = Sessions[patient]
    if not s then return end
    Sessions[patient] = nil
    UserSession[s.user] = nil
    TriggerClientEvent('NDM_PublicDefib:client:session', s.user, nil)
    if notifyUser and reason then notify(s.user, reason, 'inform') end
end

-- returned = brought back to its cabinet. Not returned = lost (cabinet needs restocking)
local function endCarry(src, returned, reason)
    local c = Carriers[src]
    if not c then return end
    Carriers[src] = nil
    local patient = UserSession[src]
    if patient then endSession(patient) end
    local needsRestock = not returned or (Config.Restock.AfterUse and c.used)
    setCabinet(c.cabinet, needsRestock and 'restock' or 'ready')
    Cooldown[license(src)] = os.time() + Config.Carry.PlayerCooldown
    if GetPlayerPed(src) ~= 0 then
        TriggerClientEvent('NDM_PublicDefib:client:carry', src, nil)
        if reason then notify(src, reason, returned and 'success' or 'error') end
    end
    local def = Defs[c.cabinet]
    log(returned and 'Defib returned' or 'Defib lost', returned and GREEN or RED, {
        { 'Player', playerName(src) }, { 'Cabinet', def and def.label or c.cabinet, true },
        { 'Used', c.used and 'Yes' or 'No', true }, { 'Reason', reason or '-' },
    })
end

---------------------------------------------------------------------------
-- Timed actions: begin -> client progress bar -> finish
---------------------------------------------------------------------------
local DURATION = {
    take = function() return 2 end,
    ['return'] = function() return 2 end,
    restock = function() return Config.Restock.Time end,
    attach = function() return Config.Use.AttachTime end,
    analyse = function() return Config.Use.AnalyseTime end,
    shock = function() return Config.Use.ShockTime end,
}

local function cabinetFor(src, id)
    local def = type(id) == 'string' and Defs[id]
    if not def then return nil, 'Unknown cabinet' end
    if dist(src, def.coords) > Config.TakeDistance + 1.0 then return nil, 'You are too far from the cabinet' end
    return def
end

-- Returns ok, error. Checked at begin AND again at finish.
local CHECK = {}

CHECK.take = function(src, id)
    local _, err = cabinetFor(src, id)
    if err then return false, err end
    if Carriers[src] then return false, 'You are already carrying a defibrillator' end
    if patientState(src) then return false, 'You can\'t do that right now' end
    if Cabinets[id].state == 'out' then return false, 'This cabinet is empty' end
    if Cabinets[id].state == 'restock' then return false, 'This cabinet is waiting to be restocked by the medical service' end
    if not cabinetsUnlocked() then
        return false, 'Locked: paramedics are on duty. Call 111 for an ambulance'
    end
    local cd = Cooldown[license(src)]
    if cd and cd > os.time() then
        return false, ('You can take another defibrillator in %d seconds'):format(cd - os.time())
    end
    return true
end

CHECK['return'] = function(src, id)
    local _, err = cabinetFor(src, id)
    if err then return false, err end
    local c = Carriers[src]
    if not c then return false, 'You are not carrying a defibrillator' end
    if c.cabinet ~= id then
        return false, ('This defibrillator belongs to: %s'):format(Defs[c.cabinet] and Defs[c.cabinet].label or '?')
    end
    return true
end

CHECK.restock = function(src, id)
    local _, err = cabinetFor(src, id)
    if err then return false, err end
    if not isRestockMedic(src) then return false, 'Only the medical service can restock this cabinet' end
    if Cabinets[id].state ~= 'restock' then return false, 'This cabinet doesn\'t need restocking' end
    return true
end

local function checkPatient(src, patient)
    if not Carriers[src] then return false, 'You need a defibrillator' end
    if type(patient) ~= 'number' or patient == src or GetPlayerPed(patient) == 0 then return false, 'No patient' end
    if patientState(src) then return false, 'You can\'t do that right now' end
    if dist(src, patient) > Config.Use.Distance + 0.5 then return false, 'You are too far from the patient' end
    return true
end

CHECK.attach = function(src, patient)
    local ok, err = checkPatient(src, patient)
    if not ok then return false, err end
    if UserSession[src] then return false, 'Your pads are already on someone' end
    if Sessions[patient] then return false, 'Someone is already using a defibrillator on them' end
    if not patientState(patient) then return false, 'They don\'t need a defibrillator' end
    return true
end

CHECK.analyse = function(src, patient)
    local ok, err = checkPatient(src, patient)
    if not ok then return false, err end
    local s = Sessions[patient]
    if not s or s.user ~= src then return false, 'Put the pads on first' end
    if s.shockAdvised then return false, 'Shock advised: deliver the shock' end
    local wait = s.lastAnalyse and (s.lastAnalyse + Config.Use.ReanalyseAfter - os.time()) or 0
    if wait > 0 then return false, ('Continue CPR. The defibrillator will analyse again in %d seconds'):format(wait) end
    return true
end

CHECK.shock = function(src, patient)
    local ok, err = checkPatient(src, patient)
    if not ok then return false, err end
    local s = Sessions[patient]
    if not s or s.user ~= src then return false, 'Put the pads on first' end
    if not s.shockAdvised then return false, 'No shock advised' end
    return true
end

-- Results (only after a finished, re-checked progress bar)
local DO = {}

DO.take = function(src, id)
    Cabinets[id].state = 'out'
    Cabinets[id].carrier = src
    sync()
    Carriers[src] = { cabinet = id, takenAt = os.time(), used = false }
    TriggerClientEvent('NDM_PublicDefib:client:carry', src, id)
    log('Defib taken', BLUE, { { 'Player', playerName(src) }, { 'Cabinet', Defs[id].label, true },
        { 'Medics on duty', medicsOnDuty(), true } })
    return true, 'Defibrillator taken. Bring it back to this cabinet when you\'re done', 'success'
end

DO['return'] = function(src)
    endCarry(src, true, nil)
    return true, 'Defibrillator returned. Thank you', 'success'
end

DO.restock = function(src, id)
    setCabinet(id, 'ready')
    if (Config.Restock.Reward or 0) > 0 then
        pcall(function() exports.qbx_core:GetPlayer(src).Functions.AddMoney('cash', Config.Restock.Reward, 'defib restock') end)
    end
    log('Cabinet restocked', GREEN, { { 'Medic', playerName(src) }, { 'Cabinet', Defs[id].label, true } })
    return true, 'Cabinet restocked', 'success'
end

DO.attach = function(src, patient)
    Sessions[patient] = { user = src, analyses = 0, shocks = 0, shockAdvised = false }
    UserSession[src] = patient
    TriggerClientEvent('NDM_PublicDefib:client:session', src, patient)
    ospLog(patient, 'Public defibrillator pads attached')
    return true, 'Pads attached. Analyse the heart rhythm', 'success'
end

DO.analyse = function(src, patient)
    local s = Sessions[patient]
    local state, bd = patientState(patient)
    s.analyses = s.analyses + 1
    s.lastAnalyse = os.time()

    if not state then
        endSession(patient)
        return true, 'Patient is breathing. Remove the pads and put them in the recovery position', 'success'
    end
    if s.shocks >= Config.Use.MaxShocks then
        return true, 'No shock advised. Continue CPR until help arrives', 'inform'
    end

    local shockable = ospShockable(bd)
    s.ospShockable = shockable
    local advised = shockable
    if not advised and state == 'arrest' then
        local chance = Config.Use.ShockableChance * (Config.Use.ShockableDecay ^ (s.analyses - 1))
        advised = math.random() < chance
    end

    s.shockAdvised = advised
    ospLog(patient, 'Public defibrillator: ' .. (advised and 'shock advised' or 'no shock advised'))
    if advised then return true, 'SHOCK ADVISED. Stand clear of the patient', 'error' end
    if state == 'laststand' then return true, 'No shock advised. The patient has signs of life', 'inform' end
    return true, 'No shock advised. Continue CPR', 'inform'
end

DO.shock = function(src, patient)
    local s = Sessions[patient]
    local carry = Carriers[src]
    s.shockAdvised = false
    s.shocks = s.shocks + 1
    s.lastAnalyse = os.time()
    carry.used = true

    local chance = Config.Use.SuccessChance + (s.ospShockable and Config.Use.OspShockableBonus or 0)
    local success = math.random() < math.min(chance, 0.95)
    ospLog(patient, ('Public defibrillator: shock %d delivered%s'):format(s.shocks, success and ', pulse returned' or ''))
    log(success and 'Defib shock - ROSC' or 'Defib shock - no change', success and GREEN or ORANGE, {
        { 'User', playerName(src) }, { 'Patient', playerName(patient) },
        { 'Shock', s.shocks, true }, { 'Cabinet', Defs[carry.cabinet] and Defs[carry.cabinet].label or '?', true },
    })

    if success then
        endSession(patient)
        Config.Revive(patient)
        notify(patient, 'You were brought round by a public defibrillator', 'success')
        return true, 'Shock delivered. The patient is coming round!', 'success'
    end
    return true, ('Shock delivered. Continue CPR, the defibrillator will analyse again in %d seconds')
        :format(Config.Use.ReanalyseAfter), 'inform'
end

lib.callback.register('NDM_PublicDefib:begin', function(src, action, arg)
    if not CHECK[action] then return false, 'Unknown action' end
    local ok, err = CHECK[action](src, arg)
    if not ok then return false, err end
    local token = math.random(1, 2147483647)
    local duration = DURATION[action]()
    Pending[src] = { action = action, arg = arg, token = token, startedAt = GetGameTimer(), duration = duration }
    return true, { token = token, duration = duration }
end)

lib.callback.register('NDM_PublicDefib:finish', function(src, token, completed)
    local p = Pending[src]
    Pending[src] = nil
    if not p or p.token ~= token then return false, 'Nothing in progress', 'error' end
    if not completed then return false, 'Cancelled', 'error' end
    if GetGameTimer() - p.startedAt < p.duration * 1000 - 750 then return false, 'Interrupted', 'error' end
    local ok, err = CHECK[p.action](src, p.arg)
    if not ok then return false, err, 'error' end
    return DO[p.action](src, p.arg)
end)

RegisterNetEvent('NDM_PublicDefib:server:removePads', function()
    local src = source
    local patient = UserSession[src]
    if patient then
        endSession(patient)
        ospLog(patient, 'Public defibrillator pads removed')
        notify(src, 'Pads removed', 'inform')
    end
end)

RegisterNetEvent('NDM_PublicDefib:server:requestState', function()
    local src = source
    if Carriers[src] then TriggerClientEvent('NDM_PublicDefib:client:carry', src, Carriers[src].cabinet) end
    if UserSession[src] then TriggerClientEvent('NDM_PublicDefib:client:session', src, UserSession[src]) end
end)

---------------------------------------------------------------------------
-- Watchdog
---------------------------------------------------------------------------
CreateThread(function()
    local lastUnlocked
    while true do
        Wait(2000)
        local now = os.time()

        for src, c in pairs(Carriers) do
            local def = Defs[c.cabinet]
            local d = def and dist(src, def.coords) or 0
            if GetPlayerPed(src) == 0 then
                endCarry(src, false, 'Carrier left')
            elseif patientState(src) then
                endCarry(src, false, 'You dropped the defibrillator')
            elseif d > Config.Carry.MaxDistance then
                endCarry(src, false, 'You took the defibrillator too far. It has been reported missing')
            elseif now - c.takenAt > Config.Carry.MaxTime then
                endCarry(src, false, 'You kept the defibrillator too long. It has been reported missing')
            elseif d > Config.Carry.WarnDistance and not c.warned then
                c.warned = true
                notify(src, ('The defibrillator alarm is sounding: go back towards %s'):format(def.label), 'error')
            elseif d <= Config.Carry.WarnDistance then
                c.warned = false
            end
        end

        for patient, s in pairs(Sessions) do
            if GetPlayerPed(patient) == 0 or GetPlayerPed(s.user) == 0 then
                endSession(patient, 'The pads came off', true)
            elseif dist(s.user, patient) > Config.Use.Distance + 3.0 then
                endSession(patient, 'You moved away and the pads came off', true)
            elseif not patientState(patient) then
                endSession(patient, 'The patient is breathing. Pads removed', true)
            end
        end

        for id, c in pairs(Cabinets) do
            if c.state == 'restock' and c.restockAt and now >= c.restockAt then setCabinet(id, 'ready') end
        end

        local unlocked = cabinetsUnlocked()
        if unlocked ~= lastUnlocked then
            lastUnlocked = unlocked
            sync()
        end
    end
end)

AddEventHandler('playerDropped', function()
    local src = source
    Pending[src] = nil
    if UserSession[src] then endSession(UserSession[src]) end
    if Sessions[src] then endSession(src) end
    if Carriers[src] then endCarry(src, false, 'Carrier left the city') end
end)

---------------------------------------------------------------------------
-- Admin: placing / managing cabinets
---------------------------------------------------------------------------
local function isAdmin(src)
    return src == 0 or IsPlayerAceAllowed(src, Config.AdminAce)
end

lib.callback.register('NDM_PublicDefib:isAdmin', function(src) return isAdmin(src) end)

local function validVec(t)
    return type(t) == 'table' and tonumber(t.x) and tonumber(t.y) and tonumber(t.z) and tonumber(t.w)
end

-- data = { label, coords = {x,y,z,w} (interaction point), prop = {x,y,z,w} (prop origin + heading),
--          noProp = true for an interaction spot only (no cabinet model spawned) }
lib.callback.register('NDM_PublicDefib:place', function(src, data)
    if not isAdmin(src) then return false, 'No permission' end
    if type(data) ~= 'table' or not validVec(data.coords) then return false, 'Bad placement' end
    local noProp = data.noProp == true
    if not noProp and not validVec(data.prop) then return false, 'Bad placement' end
    local label = type(data.label) == 'string' and data.label:gsub('[%c<>]', ''):sub(1, 48) or ''
    if label == '' then return false, 'Give the cabinet a name' end
    local coords = v4(data.coords)
    local prop = not noProp and v4(data.prop) or nil
    if dist(src, coords) > 15.0
        or (prop and #(vector3(coords.x, coords.y, coords.z) - vector3(prop.x, prop.y, prop.z)) > 2.0) then
        return false, 'Bad placement'
    end
    local id
    repeat id = ('p_%d_%d'):format(os.time(), math.random(1000, 9999)) until not Defs[id]
    addDef(id, { label = label, coords = coords, prop = prop, noProp = noProp, placed = true })
    savePlaced()
    syncDefs()
    sync()
    log('Cabinet placed', BLUE, { { 'Admin', playerName(src) }, { 'Cabinet', label, true }, { 'Coords', fmtCoords(coords), true } })
    return true, ('Cabinet "%s" placed'):format(label)
end)

lib.callback.register('NDM_PublicDefib:list', function(src)
    if not isAdmin(src) then return nil end
    local list = {}
    for id, d in pairs(Defs) do
        list[#list + 1] = { id = id, label = d.label, coords = plain(d.coords), placed = d.placed,
            noProp = d.noProp, state = Cabinets[id].state }
    end
    table.sort(list, function(a, b) return a.label < b.label end)
    return list
end)

lib.callback.register('NDM_PublicDefib:admin', function(src, action, id)
    if not isAdmin(src) then return false, 'No permission' end
    local def = type(id) == 'string' and Defs[id]
    if not def then return false, 'Unknown cabinet' end

    local carrier = Cabinets[id].carrier
    if action == 'reset' or action == 'remove' then
        if carrier and Carriers[carrier] then endCarry(carrier, true, 'An admin returned the defibrillator') end
    end

    if action == 'reset' then
        setCabinet(id, 'ready')
        return true, 'Cabinet reset'
    elseif action == 'remove' then
        if not def.placed then return false, 'This cabinet is in config.lua, remove it there' end
        Defs[id] = nil
        Cabinets[id] = nil
        savePlaced()
        syncDefs()
        sync()
        log('Cabinet removed', RED, { { 'Admin', playerName(src) }, { 'Cabinet', def.label, true } })
        return true, ('Cabinet "%s" removed'):format(def.label)
    end
    return false, 'Unknown action'
end)

-- /defibreset all  (console or admin)
RegisterCommand('defibreset', function(src, args)
    if not isAdmin(src) then return end
    for id in pairs(Cabinets) do
        if args[1] == 'all' or args[1] == id then
            local carrier = Cabinets[id].carrier
            if carrier and Carriers[carrier] then endCarry(carrier, true, 'An admin returned the defibrillator') end
            setCabinet(id, 'ready')
        end
    end
    if src ~= 0 then notify(src, 'Cabinet(s) reset', 'success') else print('[NDM_PublicDefib] cabinet(s) reset') end
end, false)
