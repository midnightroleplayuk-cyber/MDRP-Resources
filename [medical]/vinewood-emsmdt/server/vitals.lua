-- Live vitals from OSP Ambulance V2.
-- OSP's server export GetAmbulanceData(playerId) returns the patient's BodyDamage state bag.
-- If the export isn't available, the state bag is read directly.
Vitals = {}

local PARTS = { Head = 'head', Torso = 'torso', Larm = 'left arm', Rarm = 'right arm', Lleg = 'left leg', Rleg = 'right leg' }

-- OSP cardiacState -> ECG rhythm names in Config.ECGRhythms
local RHYTHMS = {
    nsr = 'Sinus rhythm', sinus = 'Sinus rhythm',
    tachycardia = 'Sinus tachycardia', stach = 'Sinus tachycardia', sinustachycardia = 'Sinus tachycardia',
    bradycardia = 'Sinus bradycardia', sbrady = 'Sinus bradycardia', sinusbradycardia = 'Sinus bradycardia',
    af = 'Atrial fibrillation', afib = 'Atrial fibrillation',
    vf = 'Ventricular fibrillation (VF)', vfib = 'Ventricular fibrillation (VF)',
    vt = 'Pulseless VT', pvt = 'Pulseless VT', vtach = 'Pulseless VT',
    pea = 'PEA',
    asystole = 'Asystole (flatline)', flatline = 'Asystole (flatline)',
}

local function num(v, dp)
    v = tonumber(v)
    if not v then return nil end
    local m = 10 ^ (dp or 0)
    return math.floor(v * m + 0.5) / m
end

local function bodyDamage(target)
    local res = Config.Vitals.resource
    if GetResourceState(res) == 'started' then
        local ok, data = pcall(function() return exports[res]:GetAmbulanceData(target) end)
        if ok and type(data) == 'table' then return data end
    end
    local st = Player(target).state
    return st and st.BodyDamage or nil
end

--- Returns vitals, extra (rhythm, bloodType, findings) or nil, reason
function Vitals.Get(target)
    if Config.GetVitals then
        local v = Config.GetVitals(target)
        if v then return v, {} end
    end
    local bd = bodyDamage(target)
    if type(bd) ~= 'table' then
        return nil, ('No medical data for this patient. Is %s running?'):format(Config.Vitals.resource)
    end

    local bp = type(bd.BloodPressure) == 'table' and bd.BloodPressure or {}
    local down = bd.isDead or bd.inLastStand or bd.Conscious == false
    local pain = num(bd.Pain)
    if pain then pain = math.max(0, math.min(10, pain > 10 and math.floor(pain / 10 + 0.5) or pain)) end

    local v = {
        hr = num(bd.Pulse),
        sbp = num(bp.systolic or bp[1]),
        dbp = num(bp.diastolic or bp[2]),
        spo2 = num(bd.oxygenSaturation),
        temp = num(bd.Temp, 1),
        avpu = down and 'U' or 'A',
        pain = pain,
    }

    local extra = { bloodType = bd.bloodType }
    local state = tostring(bd.cardiacState or ''):lower():gsub('[%s_%-]', '')
    extra.rhythm = RHYTHMS[state]
    extra.rawRhythm = bd.cardiacState

    -- Injuries for the Exposure field
    local f = {}
    local bpd = type(bd.BodyPartDamage) == 'table' and bd.BodyPartDamage or {}
    local frac, bleed = {}, {}
    for key, label in pairs(PARTS) do
        if type(bpd.Fractures) == 'table' and bpd.Fractures[key] then frac[#frac + 1] = label end
        local b = type(bpd.Bleeding) == 'table' and tonumber(bpd.Bleeding[key]) or 0
        if b and b > 0 then bleed[#bleed + 1] = ('%s (%s)'):format(label, num(b, 1)) end
    end
    table.sort(frac); table.sort(bleed)
    if #frac > 0 then f[#f + 1] = 'Suspected fractures: ' .. table.concat(frac, ', ') end
    if #bleed > 0 then f[#f + 1] = 'Bleeding: ' .. table.concat(bleed, ', ') end
    if bpd.BloodLevel then f[#f + 1] = ('Blood volume about %s L'):format(num(bpd.BloodLevel, 1)) end
    if type(bd.overdose) == 'table' and bd.overdose.active and not bd.overdose.treated then
        f[#f + 1] = ('Signs of overdose%s'):format(bd.overdose.drugId and (' (' .. tostring(bd.overdose.drugId) .. ')') or '')
    end
    extra.findings = #f > 0 and table.concat(f, '. ') .. '.' or nil
    extra.arrest = extra.rhythm and Clinical.IsArrestRhythm(extra.rhythm) or false
    return v, extra
end
