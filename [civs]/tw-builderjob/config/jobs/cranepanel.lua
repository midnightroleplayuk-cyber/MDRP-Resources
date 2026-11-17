-- ====================================================================
-- REGION 13 -- Tower Crane / Panel  (DISABLED BY DEFAULT)
-- ====================================================================
-- The switch for this region is `enabled` below. While false the record is removed
-- from regionData entirely, so writing `enabled = false` in config.lua has no effect.
-- ====================================================================
Config = Config or {}

Config.CranePanel = {
    enabled = false,

    sitesFile = 'config/data/crane_sites.json',

    admins = {
    },

    crew = { kolay = 2, zor = 4 },

    pileStack = 6,
    pileModel = { kolay = 'tworst_cranebuild1wall3', zor = 'tworst_cranebuild2wall2' },
    pileLayout = {
        step  = 0.394,
        baseZ = 0.197,
        rot   = { x = 0.0, y = 90.0 },
        zor   = { step = 0.486, baseZ = 0.243, rot = { x = 0.0, y = -90.0 } },
    },

    skeletonModel = { kolay = 'tworst_cranebuild1', zor = 'tworst_cranebuild2' },

    rentAllowed = false,
}

function CranePanel_PileLayout(difficulty)
    local CP    = Config.CranePanel
    local PL    = CP.pileLayout or {}
    local OV    = PL[difficulty]
    local function num(k, d)
        if OV and tonumber(OV[k]) then return tonumber(OV[k]) end
        return tonumber(PL[k]) or d
    end
    local function rot(axis, d)
        if OV and OV.rot and tonumber(OV.rot[axis]) then return tonumber(OV.rot[axis]) end
        if PL.rot and tonumber(PL.rot[axis]) then return tonumber(PL.rot[axis]) end
        return d
    end
    local step, baseZ = num('step', 0.394), num('baseZ', 0.197)
    local rx, ry      = rot('x', 0.0), rot('y', 90.0)
    local model = (CP.pileModel and CP.pileModel[difficulty]) or 'tworst_cranebuild1wall3'

    local out = {}
    for i = 0, (CP.pileStack or 6) - 1 do
        out[#out + 1] = {
            model = model,
            off   = vector3(0.0, 0.0, baseZ + i * step),
            rot   = vector3(rx, ry, 0.0),
        }
    end
    return out
end

local function removeRegion13()
    local rd = Config.Job and Config.Job.regionData
    if not rd then return false end
    local gone = false
    for i = #rd, 1, -1 do
        local info = rd[i].regionInfo
        if info and info.jobType == 'cranepanel' then
            table.remove(rd, i)
            gone = true
        end
    end
    return gone
end

if Config.CranePanel.enabled == false then
    removeRegion13()
    if IsDuplicityVersion() and Config.Debug then
        print('^3[tw-builderjob] region 13 (Tower Crane / Panel) is OFF '
            .. '-- Config.CranePanel.enabled = false in config/jobs/cranepanel.lua^7')
    end
    return
end

CreateThread(function()
    Wait(3000)
    if GetResourceState('tw-cranejob') ~= 'started' then return end
    if not removeRegion13() then return end
    Config.CranePanel.disabledByFreeResource = true
    if IsDuplicityVersion() then
        print('^3[tw-builderjob] tw-cranejob is running -> region 13 (Tower Crane / Panel) disabled^7')
        print('^3            the same job would otherwise be offered twice^7')
    end
end)
