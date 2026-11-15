local Occupant = {}   -- [scannerId] = patient server id lying on the table
local Busy = {}       -- [scannerId] = { medic, patient, startedAt }

local PART_ORDER = { 'Head', 'Torso', 'Larm', 'Rarm', 'Lleg', 'Rleg' }
local PART_LABELS = {
    Head = 'Head', Torso = 'Torso / Chest', Larm = 'Left Arm', Rarm = 'Right Arm', Lleg = 'Left Leg', Rleg = 'Right Leg',
}
local WOUND_LABELS = {
    abrasion = 'Abrasion', avulsion = 'Avulsion', contusion = 'Contusion', crush = 'Crush injury',
    cut = 'Cut', laceration = 'Laceration', lowvelocitywound = 'Low velocity wound',
    mediumvelocitywound = 'Medium velocity wound', highvelocitywound = 'High velocity wound',
    velocitywound = 'Velocity wound', puncturewound = 'Puncture wound', burn = 'Burn',
}
local CARDIAC_LABELS = {
    NSR = 'Normal sinus rhythm', asystole = 'Asystole', vfib = 'Ventricular fibrillation',
    vtach = 'Ventricular tachycardia', torsades = 'Torsades de pointes', pea = 'PEA',
}

local function isMedic(src)
    local player = exports.qbx_core:GetPlayer(src)
    if not player then return false end
    local job = player.PlayerData.job
    local minGrade = job and Config.Jobs[job.name]
    if not minGrade then return false end
    if Config.RequireOnDuty and not job.onduty then return false end
    local grade = type(job.grade) == 'table' and job.grade.level or job.grade or 0
    return grade >= minGrade
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

local function scanner(id)
    return type(id) == 'number' and Config.Scanners[id] or nil
end

local function medicInRange(src, s)
    local spot = s.console or s.table
    return distTo(src, spot) <= Config.MedicRange + 1.5 or distTo(src, s.table) <= Config.MedicRange + 1.5
end

local function findPatient(id, exclude)
    local s = scanner(id)
    local occ = Occupant[id]
    if occ and GetPlayerPed(occ) ~= 0 and distTo(occ, s.table) <= Config.PatientRadius + 1.0 then
        return occ
    end
    local best, bestDist
    for _, pid in ipairs(GetPlayers()) do
        pid = tonumber(pid)
        if pid ~= exclude then
            local d = distTo(pid, s.table)
            if d <= Config.PatientRadius and (not bestDist or d < bestDist) then
                best, bestDist = pid, d
            end
        end
    end
    return best
end

local function setSound(id, playing)
    TriggerClientEvent('NDM_MRI:client:sound', -1, id, playing)
end

---------------------------------------------------------------------------
-- Report
---------------------------------------------------------------------------
local function num(v, default)
    v = tonumber(v)
    if v == nil then return default end
    return v
end

local function buildReport(patient, medic)
    local bd = Player(patient).state.BodyDamage
    if type(bd) ~= 'table' then return nil end
    local bpd = type(bd.BodyPartDamage) == 'table' and bd.BodyPartDamage or {}
    local wounds = bpd.Wounds or {}
    local fractures = bpd.Fractures or {}
    local bleeding = bpd.Bleeding or {}
    local damage = bpd.DamageType or {}
    local sewed = bpd.NeedSewed or {}
    local tourniquets = bpd.appliedTourniquets or {}

    local regions, impressions, toConfirm = {}, {}, {}
    local anyFinding = false

    for _, part in ipairs(PART_ORDER) do
        local findings = {}
        local severity = 0

        local f = fractures[part]
        if f == true or f == 'xrayed' then
            findings[#findings + 1] = { text = 'Fracture', level = 'critical' }
            severity = math.max(severity, 3)
            if f == true then toConfirm[#toConfirm + 1] = part end
        elseif f == 'splint' then
            findings[#findings + 1] = { text = 'Fracture (splinted)', level = 'warn' }
            severity = math.max(severity, 2)
        elseif f == 'cast' then
            findings[#findings + 1] = { text = 'Fracture (in cast)', level = 'info' }
            severity = math.max(severity, 1)
        end

        local seen = {}
        if type(wounds[part]) == 'table' then
            for _, w in pairs(wounds[part]) do
                if type(w) == 'string' and w ~= '' then
                    seen[w] = (seen[w] or 0) + 1
                end
            end
        end
        for w, count in pairs(seen) do
            local label = WOUND_LABELS[w] or w
            if count > 1 then label = ('%s x%d'):format(label, count) end
            local lvl = (w:find('velocity') or w == 'crush' or w == 'avulsion') and 'critical' or 'warn'
            findings[#findings + 1] = { text = label, level = lvl }
            severity = math.max(severity, lvl == 'critical' and 3 or 2)
        end

        local bleed = num(bleeding[part], 0)
        if bleed > 0 then
            local txt = (part == 'Head' or part == 'Torso') and 'Active internal / external bleeding' or 'Active bleeding'
            findings[#findings + 1] = { text = txt, level = 'critical' }
            severity = math.max(severity, 3)
        end
        if sewed[part] == true then
            findings[#findings + 1] = { text = 'Wound requires sutures', level = 'warn' }
            severity = math.max(severity, 2)
        end
        if tourniquets[part] == true then
            findings[#findings + 1] = { text = 'Tourniquet applied', level = 'info' }
        end

        local dmg = num(damage[part], 0)
        if dmg > 0 and #findings == 0 then
            findings[#findings + 1] = { text = 'Soft tissue damage / oedema', level = 'warn' }
            severity = math.max(severity, 1)
        end

        if #findings > 0 then anyFinding = true end

        regions[#regions + 1] = {
            part = part,
            label = PART_LABELS[part],
            severity = severity,
            findings = findings,
        }

        if part == 'Head' and severity >= 2 then
            impressions[#impressions + 1] = 'Head trauma: rule out intracranial haemorrhage, monitor GCS.'
        elseif part == 'Torso' and severity >= 2 then
            impressions[#impressions + 1] = 'Thoracic / abdominal trauma: assess for internal bleeding.'
        end
    end

    local bloodLevel = num(bpd.BloodLevel, 6.0)
    if bloodLevel < 5.0 then
        impressions[#impressions + 1] = ('Significant blood loss (%.1f L of 6.0 L).'):format(bloodLevel)
    end

    local conditions = {}
    if type(bd.activeConditions) == 'table' then
        for id, data in pairs(bd.activeConditions) do
            conditions[#conditions + 1] = type(data) == 'table' and (data.label or data.name) or tostring(id)
        end
    end
    if type(bd.overdose) == 'table' and bd.overdose.active then
        conditions[#conditions + 1] = 'Overdose'
    end

    if #toConfirm > 0 then
        impressions[#impressions + 1] = ('%d fracture(s) identified, treat with splint / cast.'):format(#toConfirm)
    end
    if not anyFinding and #impressions == 0 then
        impressions[#impressions + 1] = 'No acute abnormality detected.'
    end

    local bp = type(bd.BloodPressure) == 'table' and bd.BloodPressure or {}
    local state = 'Stable'
    if bd.isDead == true then state = 'Deceased / cardiac arrest'
    elseif bd.inLastStand == true then state = 'Critical (last stand)'
    elseif bd.Conscious == false then state = 'Unconscious' end

    return {
        patient = (type(bd.playerName) == 'string' and bd.playerName ~= 'UNKNOWN' and bd.playerName) or getName(patient),
        patientId = patient,
        medic = getName(medic),
        time = os.date('%d/%m/%Y %H:%M'),
        state = state,
        vitals = {
            pulse = num(bd.Pulse),
            bp = (tonumber(bp[1]) and tonumber(bp[2])) and ('%d/%d'):format(bp[1], bp[2]) or nil,
            spo2 = num(bd.oxygenSaturation),
            temp = num(bd.Temp),
            pain = num(bd.Pain),
            blood = bloodLevel,
            rhythm = type(bd.cardiacState) == 'string' and (CARDIAC_LABELS[bd.cardiacState] or bd.cardiacState) or nil,
        },
        regions = regions,
        conditions = conditions,
        impressions = impressions,
        confirmFractures = Config.ConfirmFractures and toConfirm or {},
    }
end

---------------------------------------------------------------------------
-- Callbacks / events
---------------------------------------------------------------------------
lib.callback.register('NDM_MRI:server:startScan', function(src, id)
    local s = scanner(id)
    if not s then return false, 'Unknown scanner' end
    if not isMedic(src) then return false, 'Only on-duty medical staff can run the MRI' end
    if not medicInRange(src, s) then return false, 'You are too far from the scanner' end
    if Busy[id] then return false, 'The scanner is already running' end

    local patient = findPatient(id, src)
    if not patient then return false, 'There is no patient on the MRI table' end

    local job = { medic = src, patient = patient, startedAt = GetGameTimer() }
    Busy[id] = job
    setSound(id, true)
    -- Failsafe in case the medic's client never reports back
    SetTimeout(Config.ScanDuration + 15000, function()
        if Busy[id] == job then
            Busy[id] = nil
            setSound(id, false)
        end
    end)
    TriggerClientEvent('NDM_MRI:client:holdStill', patient, id, Config.ScanDuration)
    return true, Config.ScanDuration
end)

lib.callback.register('NDM_MRI:server:finishScan', function(src, id, completed)
    local job = Busy[id]
    if not job or job.medic ~= src then return false, 'No scan running' end
    Busy[id] = nil
    setSound(id, false)
    TriggerClientEvent('NDM_MRI:client:holdStill', job.patient, id, 0)

    if not completed then return false, 'Scan cancelled' end
    if GetGameTimer() - job.startedAt < Config.ScanDuration - 1500 then
        return false, 'Scan was interrupted'
    end
    if distTo(job.patient, Config.Scanners[id].table) > Config.PatientRadius + 1.0 then
        return false, 'The patient moved off the table, scan failed'
    end

    local report = buildReport(job.patient, src)
    if not report then return false, 'Could not read patient data' end
    return true, report
end)

RegisterNetEvent('NDM_MRI:server:layPatient', function(id, target)
    local src = source
    local s = scanner(id)
    target = tonumber(target)
    if not s or not target or not isMedic(src) then return end
    if Occupant[id] and GetPlayerPed(Occupant[id]) ~= 0 then
        return TriggerClientEvent('ox_lib:notify', src, { type = 'error', description = 'The MRI table is already occupied' })
    end
    local mc, tc = pedCoords(src), pedCoords(target)
    if not mc or not tc or #(mc - tc) > Config.LayPatientRange + 1.0 or distTo(src, s.table) > 8.0 then return end
    Occupant[id] = target
    TriggerClientEvent('NDM_MRI:client:lieDown', target, id)
end)

RegisterNetEvent('NDM_MRI:server:selfLie', function(id)
    local src = source
    local s = scanner(id)
    if not s or distTo(src, s.table) > 4.0 then return end
    if Occupant[id] and Occupant[id] ~= src and GetPlayerPed(Occupant[id]) ~= 0 then
        return TriggerClientEvent('ox_lib:notify', src, { type = 'error', description = 'The MRI table is already occupied' })
    end
    Occupant[id] = src
    TriggerClientEvent('NDM_MRI:client:lieDown', src, id)
end)

RegisterNetEvent('NDM_MRI:server:removePatient', function(id)
    local src = source
    local occ = Occupant[id]
    if not occ then return end
    if occ ~= src and not isMedic(src) then return end
    Occupant[id] = nil
    TriggerClientEvent('NDM_MRI:client:getUp', occ, id)
end)

RegisterNetEvent('NDM_MRI:server:leftTable', function(id)
    if Occupant[id] == source then Occupant[id] = nil end
end)

---------------------------------------------------------------------------
-- Table carrier: hidden object the patient is attached to while the table moves.
-- Created server side so it exists for everyone (client-made entities can be blocked).
---------------------------------------------------------------------------
local Carriers = {} -- [scannerId] = { entity, patient }
local CARRIER_MODEL = `prop_cs_cardbox_01`

local function deleteCarrier(id)
    local c = Carriers[id]
    if not c then return end
    Carriers[id] = nil
    if DoesEntityExist(c.entity) then DeleteEntity(c.entity) end
end

lib.callback.register('NDM_MRI:server:createCarrier', function(src, id)
    local s = scanner(id)
    local job = Busy[id]
    if not s or not s.bore or not job or job.patient ~= src then return false end
    deleteCarrier(id)

    local c = pedCoords(src)
    if not c then return false end
    local ent = CreateObjectNoOffset(CARRIER_MODEL, c.x, c.y, c.z - 2.0, true, true, false)
    local timeout = GetGameTimer() + 3000
    while not DoesEntityExist(ent) do
        if GetGameTimer() > timeout then return false end
        Wait(0)
    end
    FreezeEntityPosition(ent, true)
    SetEntityHeading(ent, s.table.w)
    local entry = { entity = ent, patient = src }
    Carriers[id] = entry

    -- Failsafe: never leave one behind
    local m = Config.TableMotion
    SetTimeout(Config.ScanDuration + (m.slideTime or 0) * 2 + 20000, function()
        if Carriers[id] == entry then deleteCarrier(id) end
    end)
    return NetworkGetNetworkIdFromEntity(ent)
end)

RegisterNetEvent('NDM_MRI:server:removeCarrier', function(id)
    local c = Carriers[id]
    if c and c.patient == source then deleteCarrier(id) end
end)

AddEventHandler('onResourceStop', function(res)
    if res ~= GetCurrentResourceName() then return end
    for id in pairs(Carriers) do deleteCarrier(id) end
end)

AddEventHandler('playerDropped', function()
    local src = source
    for id, c in pairs(Carriers) do
        if c.patient == src then deleteCarrier(id) end
    end
    for id, occ in pairs(Occupant) do
        if occ == src then Occupant[id] = nil end
    end
    for id, job in pairs(Busy) do
        if job.medic == src or job.patient == src then
            Busy[id] = nil
            setSound(id, false)
        end
    end
end)
