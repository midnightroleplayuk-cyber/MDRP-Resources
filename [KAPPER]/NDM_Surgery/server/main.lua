local Occupant = {}   -- [tableId] = patient server id on the table
local Sessions = {}   -- [tableId] = { patient, sedated, open = { [part] = true } }
local Busy = {}       -- [tableId] = { medic, patient, proc, part, token, startedAt }

-- Procedures that cut the patient open (need anaesthesia, leave an incision to stitch)
local INVASIVE = { bullet = true, internal = true, shrapnel = true, fracture = true }

local PART_ORDER = { 'Head', 'Torso', 'Larm', 'Rarm', 'Lleg', 'Rleg' }
local PART_LABELS = {
    Head = 'Head', Torso = 'Torso / Chest', Larm = 'Left Arm', Rarm = 'Right Arm', Lleg = 'Left Leg', Rleg = 'Right Leg',
}

---------------------------------------------------------------------------
-- Helpers
---------------------------------------------------------------------------
local function num(v, default)
    v = tonumber(v)
    if v == nil then return default end
    return v
end

local function isMedic(src, minGrade)
    local player = exports.qbx_core:GetPlayer(src)
    if not player then return false end
    local job = player.PlayerData.job
    local jobMin = job and Config.Jobs[job.name]
    if not jobMin then return false end
    if Config.RequireOnDuty and not job.onduty then return false end
    local grade = type(job.grade) == 'table' and job.grade.level or job.grade or 0
    return grade >= math.max(jobMin, minGrade or 0)
end

local function getName(src)
    local player = exports.qbx_core:GetPlayer(src)
    local info = player and player.PlayerData.charinfo
    if info and info.firstname then
        return ('%s %s'):format(info.firstname, info.lastname or '')
    end
    return GetPlayerName(src) or ('ID ' .. src)
end

local function pedCoords(src)
    local ped = GetPlayerPed(src)
    if not ped or ped == 0 then return nil end
    return GetEntityCoords(ped)
end

local function distTo(src, point)
    local c = pedCoords(src)
    if not c then return math.huge end
    return #(c - vector3(point.x, point.y, point.z))
end

local function opTable(id)
    return type(id) == 'number' and Config.Tables[id] or nil
end

-- OSP stage 1 = last stand (downed), stage 2 = dead
local function isDowned(src)
    local state = Player(src).state
    local bd = state.BodyDamage
    if type(bd) == 'table' and (bd.isDead == true or bd.inLastStand == true) then return true end
    return state.isDead == true
end

local function notify(src, msg, kind)
    TriggerClientEvent('ox_lib:notify', src, { title = 'Surgery', type = kind or 'inform', description = msg })
end

-- Items (ox_inventory). All optional: nil item = nothing needed.
local function hasItem(src, item)
    if not item then return true end
    local ok, count = pcall(function() return exports.ox_inventory:GetItemCount(src, item) end)
    return ok and (count or 0) > 0
end

local function removeItem(src, item)
    if not item then return true end
    local ok, res = pcall(function() return exports.ox_inventory:RemoveItem(src, item, 1) end)
    return ok and res and true or false
end

local function giveItem(src, item, count)
    if not item then return end
    pcall(function()
        if exports.ox_inventory:CanCarryItem(src, item, count) then
            exports.ox_inventory:AddItem(src, item, count)
        end
    end)
end

local function itemLabel(item)
    local ok, data = pcall(function() return exports.ox_inventory:Items(item) end)
    return ok and type(data) == 'table' and data.label or item
end

---------------------------------------------------------------------------
-- OSP body damage
---------------------------------------------------------------------------
local function getBodyDamage(patient)
    local bd = Player(patient).state.BodyDamage
    if type(bd) ~= 'table' then return nil end
    bd.BodyPartDamage = type(bd.BodyPartDamage) == 'table' and bd.BodyPartDamage or {}
    local bpd = bd.BodyPartDamage
    for _, key in ipairs({ 'Wounds', 'Bleeding', 'DamageType', 'NeedSewed', 'Fractures', 'FractureTime' }) do
        if type(bpd[key]) ~= 'table' then bpd[key] = {} end
    end
    return bd
end

-- Same as OSP: set the state bag and push it to the patient's client (which persists it)
local function saveBodyDamage(patient, bd)
    Player(patient).state:set('BodyDamage', bd, true)
    TriggerClientEvent('osp_ambulance:SaveDataCl', patient, bd, true)
end

local function addLog(bd, text)
    if type(bd.MessageLog) ~= 'table' then bd.MessageLog = {} end
    table.insert(bd.MessageLog, os.date('%H:%M') .. ' | ' .. text)
end

-- Wound lists can come back from the state bag with holes; return a clean ordered list
local function woundList(bpd, part)
    local raw = bpd.Wounds[part]
    local list = {}
    if type(raw) ~= 'table' then return list end
    local keys = {}
    for k, w in pairs(raw) do
        if type(w) == 'string' and w ~= '' then keys[#keys + 1] = k end
    end
    table.sort(keys, function(a, b)
        local na, nb = tonumber(a), tonumber(b)
        if na and nb then return na < nb end
        return tostring(a) < tostring(b)
    end)
    for _, k in ipairs(keys) do list[#list + 1] = raw[k] end
    return list
end

local function countIn(list, set)
    local n = 0
    for _, w in ipairs(list) do
        if set[w] then n = n + 1 end
    end
    return n
end

local function countBullets(list)
    return countIn(list, Config.BulletWounds)
end

-- Removes the first wound in `list` that is in `set`. Returns true if one was removed.
local function removeFirst(list, set)
    for i, w in ipairs(list) do
        if set[w] then
            table.remove(list, i)
            return true
        end
    end
    return false
end

-- OSP fracture states: true (found), 'xrayed', 'splint', 'cast', false (healed)
-- Returns the state and whether surgery can fix it (+ reason if not)
local function fractureStatus(bpd, part)
    local f = bpd.Fractures[part]
    if f == true then
        if Config.Procedures.fracture.requireImaging then
            return f, false, 'The fracture must be confirmed by X-ray or MRI first'
        end
        return f, true
    elseif f == 'xrayed' or f == 'splint' then
        return f, true
    elseif f == 'cast' then
        return f, false, 'The fracture is already in a cast'
    end
    return nil, false
end

local function hasInternal(bpd, part, list, isOpen)
    for _, w in ipairs(list) do
        if Config.InternalWounds[w] then return true end
    end
    -- bleeding from the head / torso with no wound to explain it = internal bleeding
    if Config.InternalBleedParts[part] and not isOpen and #list == 0 and num(bpd.Bleeding[part], 0) > 0 then
        return true
    end
    return false
end

---------------------------------------------------------------------------
-- Table / session
---------------------------------------------------------------------------
local function patientOn(id)
    local t = opTable(id)
    local p = Occupant[id]
    if t and p and GetPlayerPed(p) ~= 0 and distTo(p, t.coords) <= Config.PatientRadius + 1.0 then
        return p
    end
    return nil
end

local function session(id, patient)
    local s = Sessions[id]
    if not s or s.patient ~= patient then
        -- shrapnel[part] = { done, needed } for the shrapnel wound being worked on
        s = { patient = patient, sedated = false, open = {}, shrapnel = {} }
        Sessions[id] = s
    end
    return s
end

local function wake(id)
    local s = Sessions[id]
    if s and s.sedated then
        s.sedated = false
        TriggerClientEvent('NDM_Surgery:client:sedate', s.patient, false)
    end
end

local function clearTable(id)
    wake(id)
    Occupant[id] = nil
    Sessions[id] = nil
end

local function needsAnaesthesia(patient, s)
    if not Config.Anaesthesia.required or s.sedated then return false end
    if Config.Anaesthesia.skipIfDowned and isDowned(patient) then return false end
    return true
end

-- Can this procedure be done right now? Returns ok, error message
local function canDo(proc, part, patient, s)
    if proc == 'anaesthesia' then
        if s.sedated then return false, 'The patient is already under anaesthesia' end
        return true
    end

    if not PART_LABELS[part] then return false, 'Unknown body part' end
    local bd = getBodyDamage(patient)
    if not bd then return false, 'Could not read the patient\'s medical data' end
    local bpd = bd.BodyPartDamage
    local list = woundList(bpd, part)
    local label = PART_LABELS[part]:lower()

    if INVASIVE[proc] and needsAnaesthesia(patient, s) then
        return false, 'The patient needs to be put under anaesthesia first'
    end

    if proc == 'bullet' then
        if countBullets(list) == 0 then return false, ('No bullets found in the %s'):format(label) end
    elseif proc == 'shrapnel' then
        if countIn(list, Config.ShrapnelWounds) == 0 then return false, ('No shrapnel found in the %s'):format(label) end
    elseif proc == 'debride' then
        if countIn(list, Config.DebrideWounds) == 0 then return false, ('No wounds to clean on the %s'):format(label) end
    elseif proc == 'fracture' then
        local state, fixable, reason = fractureStatus(bpd, part)
        if not state then return false, ('No fracture found in the %s'):format(label) end
        if not fixable then return false, reason end
    elseif proc == 'internal' then
        if not hasInternal(bpd, part, list, s.open[part]) then
            return false, ('No internal damage found in the %s'):format(label)
        end
    elseif proc == 'stitch' then
        if not s.open[part] and bpd.NeedSewed[part] ~= true then
            return false, ('There is nothing to stitch on the %s'):format(label)
        end
    else
        return false, 'Unknown procedure'
    end
    return true
end

---------------------------------------------------------------------------
-- Procedure results
---------------------------------------------------------------------------
local function applyProcedure(job, s, passed)
    local cfg = Config.Procedures[job.proc]
    local patient = job.patient

    if job.proc == 'anaesthesia' then
        s.sedated = true
        TriggerClientEvent('NDM_Surgery:client:sedate', patient, true)
        local bd = getBodyDamage(patient)
        if bd then
            addLog(bd, 'Surgery: general anaesthesia administered')
            saveBodyDamage(patient, bd)
        end
        return true, 'The patient is now under general anaesthesia', 'success'
    end

    local bd = getBodyDamage(patient)
    if not bd then return false, 'Could not read the patient\'s medical data', 'error' end
    local bpd = bd.BodyPartDamage
    local part = job.part
    local partLabel = PART_LABELS[part]
    local list = woundList(bpd, part)

    -- Failed skill check: complications
    if not passed then
        if INVASIVE[job.proc] then
            s.open[part] = true
            bpd.NeedSewed[part] = true
        end
        if (cfg.failBleed or 0) > 0 then
            bpd.Bleeding[part] = math.min(num(bpd.Bleeding[part], 0) + cfg.failBleed, 2.0)
        end
        bd.Pain = num(bd.Pain, 0) + (cfg.failPain or 0)
        bpd.Wounds[part] = list
        addLog(bd, ('Surgery: complication during %s (%s)'):format(cfg.label:lower(), partLabel))
        saveBodyDamage(patient, bd)
        return true, ('Complication during %s, the patient is bleeding'):format(cfg.label:lower()), 'error'
    end

    local msg
    if job.proc == 'bullet' then
        for i, w in ipairs(list) do
            if Config.BulletWounds[w] then
                table.remove(list, i)
                break
            end
        end
        s.open[part] = true
        bpd.NeedSewed[part] = true
        local left = countBullets(list)
        if left == 0 and countIn(list, Config.ShrapnelWounds) == 0 and not hasInternal(bpd, part, list, true) then
            bpd.Bleeding[part] = Config.OpenBleed
        end
        giveItem(job.medic, Config.BulletItem, 1)
        addLog(bd, ('Surgery: bullet removed (%s)'):format(partLabel))
        msg = left > 0 and ('Bullet removed from the %s, %d left'):format(partLabel:lower(), left)
            or ('All bullets removed from the %s, stitch the incision'):format(partLabel:lower())

    elseif job.proc == 'internal' then
        local remaining = {}
        for _, w in ipairs(list) do
            if not Config.InternalWounds[w] then remaining[#remaining + 1] = w end
        end
        list = remaining
        s.open[part] = true
        bpd.NeedSewed[part] = true
        if countBullets(list) == 0 and countIn(list, Config.ShrapnelWounds) == 0 then
            bpd.Bleeding[part] = Config.OpenBleed
        end
        bpd.DamageType[part] = math.min(num(bpd.DamageType[part], 0), 1)
        addLog(bd, ('Surgery: internal damage repaired (%s)'):format(partLabel))
        msg = ('Internal damage in the %s repaired, stitch the incision'):format(partLabel:lower())

    elseif job.proc == 'shrapnel' then
        s.open[part] = true
        bpd.NeedSewed[part] = true
        local frag = s.shrapnel[part]
        if not frag then
            local range = cfg.fragments or { 2, 4 }
            frag = { done = 0, needed = math.random(range[1], range[2] or range[1]) }
            s.shrapnel[part] = frag
        end
        frag.done = frag.done + 1
        if frag.done >= frag.needed then
            removeFirst(list, Config.ShrapnelWounds)
            s.shrapnel[part] = nil
            local left = countIn(list, Config.ShrapnelWounds)
            if left == 0 and countBullets(list) == 0 and not hasInternal(bpd, part, list, true) then
                bpd.Bleeding[part] = Config.OpenBleed
            end
            addLog(bd, ('Surgery: shrapnel wound cleared (%s)'):format(partLabel))
            msg = left > 0 and ('Shrapnel wound cleared from the %s, %d more to go'):format(partLabel:lower(), left)
                or ('All shrapnel removed from the %s, stitch the incision'):format(partLabel:lower())
        else
            addLog(bd, ('Surgery: shrapnel fragment removed (%s)'):format(partLabel))
            msg = ('Fragment removed (%d/%d)'):format(frag.done, frag.needed)
        end

    elseif job.proc == 'fracture' then
        local state = bpd.Fractures[part]
        if state == 'splint' and type(bpd.CosmeticFractures) == 'table' then
            -- let OSP take the splint off the patient's model (it reads the old state, so send it first)
            TriggerClientEvent('osp_ambulance:removeCastCl', patient, { BodyPart = part })
        end
        bpd.Fractures[part] = false
        bpd.FractureTime[part] = 0
        s.open[part] = true
        bpd.NeedSewed[part] = true
        addLog(bd, ('Surgery: fracture repaired (ORIF) (%s)'):format(partLabel))
        msg = ('Fracture in the %s repaired, stitch the incision'):format(partLabel:lower())

    elseif job.proc == 'debride' then
        local remaining = {}
        for _, w in ipairs(list) do
            if not Config.DebrideWounds[w] then remaining[#remaining + 1] = w end
        end
        list = remaining
        -- cleaned and closed in one go; only reset the area if nothing else is left on it
        if #list == 0 and not s.open[part] then
            bpd.NeedSewed[part] = false
            bpd.Bleeding[part] = 0.0
            bpd.DamageType[part] = 0
        end
        addLog(bd, ('Surgery: wounds debrided and closed (%s)'):format(partLabel))
        msg = ('Wounds on the %s cleaned and closed'):format(partLabel:lower())

    elseif job.proc == 'stitch' then
        s.open[part] = nil
        bpd.NeedSewed[part] = false
        if #list == 0 then
            bpd.Bleeding[part] = 0.0
            bpd.DamageType[part] = 0
        end
        addLog(bd, ('Surgery: incision closed (%s)'):format(partLabel))
        msg = ('The %s has been stitched up'):format(partLabel:lower())
    end

    bpd.Wounds[part] = list
    saveBodyDamage(patient, bd)
    if (cfg.heal or 0) > 0 then
        TriggerClientEvent('osp_ambulance:treatmentHealCl', patient, cfg.heal)
    end
    return true, msg, 'success'
end

---------------------------------------------------------------------------
-- Callbacks
---------------------------------------------------------------------------
lib.callback.register('NDM_Surgery:server:overview', function(src, id)
    local t = opTable(id)
    if not t then return false, 'Unknown table' end
    if not isMedic(src) then return false, 'Only on-duty medical staff can perform surgery' end
    if distTo(src, t.coords) > Config.SurgeonRange + 1.0 then return false, 'You are too far from the table' end
    local patient = patientOn(id)
    if not patient then return false, 'There is no patient on the operating table' end
    if patient == src then return false, 'You can\'t operate on yourself' end
    if not Config.AllowDowned and isDowned(patient) then
        return false, 'The patient must be stabilised (not downed or dead) before surgery'
    end

    local bd = getBodyDamage(patient)
    if not bd then return false, 'Could not read the patient\'s medical data' end
    local bpd = bd.BodyPartDamage
    local s = session(id, patient)

    local parts = {}
    for _, part in ipairs(PART_ORDER) do
        local list = woundList(bpd, part)
        local fState, fFixable, fReason = fractureStatus(bpd, part)
        local frag = s.shrapnel[part]
        parts[#parts + 1] = {
            part = part,
            label = PART_LABELS[part],
            bullets = countBullets(list),
            shrapnel = countIn(list, Config.ShrapnelWounds),
            fragDone = frag and frag.done or nil,
            fragNeeded = frag and frag.needed or nil,
            debride = countIn(list, Config.DebrideWounds),
            fracture = fState and true or false,
            fractureState = fState,
            fractureFixable = fFixable,
            fractureReason = fReason,
            internal = hasInternal(bpd, part, list, s.open[part]),
            open = s.open[part] == true,
            needsStitch = s.open[part] == true or bpd.NeedSewed[part] == true,
            bleeding = num(bpd.Bleeding[part], 0) > 0,
        }
    end

    local state = 'Stable'
    if bd.isDead == true then state = 'Cardiac arrest'
    elseif bd.inLastStand == true then state = 'Critical'
    elseif s.sedated then state = 'Under anaesthesia' end

    local bp = type(bd.BloodPressure) == 'table' and bd.BloodPressure or {}
    return true, {
        patient = (type(bd.playerName) == 'string' and bd.playerName ~= 'UNKNOWN' and bd.playerName) or getName(patient),
        state = state,
        sedated = s.sedated,
        needsAnaesthesia = needsAnaesthesia(patient, s),
        pulse = num(bd.Pulse),
        bp = (tonumber(bp[1]) and tonumber(bp[2]))
            and ('%d/%d'):format(math.floor(tonumber(bp[1]) + 0.5), math.floor(tonumber(bp[2]) + 0.5)) or nil,
        blood = num(bpd.BloodLevel, 6.0),
        parts = parts,
    }
end)

lib.callback.register('NDM_Surgery:server:begin', function(src, id, proc, part)
    local t = opTable(id)
    if not t then return false, 'Unknown table' end
    local cfg = Config.Procedures[proc]
    if not cfg then return false, 'Unknown procedure' end
    if not isMedic(src, cfg.minGrade) then return false, 'You are not trained for this procedure' end
    if distTo(src, t.coords) > Config.SurgeonRange + 1.0 then return false, 'You are too far from the table' end
    if Busy[id] then return false, 'A procedure is already in progress on this table' end

    local patient = patientOn(id)
    if not patient then return false, 'There is no patient on the operating table' end
    if patient == src then return false, 'You can\'t operate on yourself' end
    if not Config.AllowDowned and isDowned(patient) then
        return false, 'The patient must be stabilised (not downed or dead) before surgery'
    end

    local s = session(id, patient)
    local ok, err = canDo(proc, part, patient, s)
    if not ok then return false, err end
    if cfg.item and not hasItem(src, cfg.item) then
        return false, ('You need a %s'):format(itemLabel(cfg.item))
    end

    local token = math.random(1, 2147483647)
    local job = { medic = src, patient = patient, proc = proc, part = part, token = token, startedAt = GetGameTimer() }
    Busy[id] = job
    -- failsafe in case the surgeon's client never reports back
    SetTimeout(cfg.duration + 60000, function()
        if Busy[id] == job then Busy[id] = nil end
    end)
    return true, { token = token, duration = cfg.duration, skill = cfg.skill, label = cfg.label }
end)

lib.callback.register('NDM_Surgery:server:finish', function(src, id, token, completed, passed)
    local job = Busy[id]
    if not job or job.token ~= token or job.medic ~= src then return false, 'No procedure in progress', 'error' end
    Busy[id] = nil

    local cfg = Config.Procedures[job.proc]
    if not completed then return false, ('%s cancelled'):format(cfg.label), 'error' end
    if GetGameTimer() - job.startedAt < cfg.duration - 1500 then
        return false, 'The procedure was interrupted', 'error'
    end
    if patientOn(id) ~= job.patient then return false, 'The patient is no longer on the table', 'error' end
    if distTo(src, Config.Tables[id].coords) > Config.SurgeonRange + 1.5 then
        return false, 'You moved away from the table', 'error'
    end

    local s = session(id, job.patient)
    local ok, err = canDo(job.proc, job.part, job.patient, s)
    if not ok then return false, err, 'error' end
    if cfg.item and cfg.removeItem and not removeItem(src, cfg.item) then
        return false, ('You need a %s'):format(itemLabel(cfg.item)), 'error'
    end

    return applyProcedure(job, s, passed == true)
end)

---------------------------------------------------------------------------
-- Table events
---------------------------------------------------------------------------
RegisterNetEvent('NDM_Surgery:server:layPatient', function(id, target)
    local src = source
    local t = opTable(id)
    target = tonumber(target)
    if not t or not target or target == src or not isMedic(src) then return end
    if not Config.AllowDowned and isDowned(target) then
        return notify(src, 'The patient must be stabilised (not downed or dead) before surgery', 'error')
    end
    if Occupant[id] and GetPlayerPed(Occupant[id]) ~= 0 then
        return notify(src, 'The operating table is already occupied', 'error')
    end
    local mc, tc = pedCoords(src), pedCoords(target)
    if not mc or not tc or #(mc - tc) > Config.LayPatientRange + 1.0 or distTo(src, t.coords) > 8.0 then return end
    clearTable(id)
    Occupant[id] = target
    TriggerClientEvent('NDM_Surgery:client:lieDown', target, id)
end)

RegisterNetEvent('NDM_Surgery:server:selfLie', function(id)
    local src = source
    local t = opTable(id)
    if not t or distTo(src, t.coords) > 4.0 then return end
    if Occupant[id] and Occupant[id] ~= src and GetPlayerPed(Occupant[id]) ~= 0 then
        return notify(src, 'The operating table is already occupied', 'error')
    end
    if Occupant[id] ~= src then clearTable(id) end
    Occupant[id] = src
    TriggerClientEvent('NDM_Surgery:client:lieDown', src, id)
end)

RegisterNetEvent('NDM_Surgery:server:removePatient', function(id)
    local src = source
    local occ = Occupant[id]
    if not occ then return end
    if occ ~= src and not isMedic(src) then return end
    if Busy[id] then return notify(src, 'Finish the current procedure first', 'error') end
    clearTable(id)
    TriggerClientEvent('NDM_Surgery:client:getUp', occ, id)
end)

RegisterNetEvent('NDM_Surgery:server:wake', function(id)
    local src = source
    local t = opTable(id)
    if not t or not isMedic(src) or distTo(src, t.coords) > Config.SurgeonRange + 1.5 then return end
    if Busy[id] then return notify(src, 'Finish the current procedure first', 'error') end
    wake(id)
    notify(src, 'The patient is waking up', 'success')
end)

RegisterNetEvent('NDM_Surgery:server:leftTable', function(id)
    if Occupant[id] == source then clearTable(id) end
end)

AddEventHandler('playerDropped', function()
    local src = source
    for id, occ in pairs(Occupant) do
        if occ == src then Occupant[id] = nil Sessions[id] = nil end
    end
    for id, job in pairs(Busy) do
        if job.medic == src or job.patient == src then Busy[id] = nil end
    end
end)
