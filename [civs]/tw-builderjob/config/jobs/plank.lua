-- ====================================================================
-- REGION 1 -- Frame & Concrete (El Burro Heights)
-- ====================================================================
-- 7 stages: formwork -> mesh -> concrete -> stripping -> columns -> rebar -> walls/upper floor.
-- Slot layouts come from the blueprints, pile layout from config/systems/plank_stages.lua.
-- ====================================================================

Config.PlankJob                   = {}

Config.PlankJob.designId          = nil

Config.PlankJob.zoneId            = 'buildermainzone'

Config.PlankJob.memberCraneRemote = true

-- Vehicle set and starting step per crew size.
-- ⚠ If you change startStep it must stay in step with the server's
-- applyHeadStart table. The reward already drops by the work not done.
Config.PlankJob.crewProfiles = {
    -- Solo = crane work only; the concrete phases are skipped (pump + mixer need two people).
    [1] = { vehicles = { winch = 1 }, startStep = 5 },  -- 1 player: crane work
    [2] = { vehicles = { winch = 2, pump = 1, mixer = 1 }, startStep = 1 },
    [3] = { vehicles = { winch = 3, pump = 1, mixer = 1 }, startStep = 1 },
    [4] = { vehicles = { winch = 4, pump = 1, mixer = 1 }, startStep = 1 }
}

local PLANK_TEST_START_STEP = 0
local PLANK_TEST_FULL_FLEET = true

if not __TWSIM and PLANK_TEST_START_STEP and PLANK_TEST_START_STEP > 0 then
    for crew = 1, 2 do
        local p = Config.PlankJob.crewProfiles[crew]
        if p then
            p.startStep = PLANK_TEST_START_STEP
            if PLANK_TEST_FULL_FLEET then
                p.vehicles.pump  = p.vehicles.pump  or 1
                p.vehicles.mixer = p.vehicles.mixer or 1
            end
        end
    end
    print(('^1[plank][RELEASE BLOCKER] SOLO/2-PLAYER TEST OVERRIDE: startStep=%d%s'
        .. ' — set PLANK_TEST_START_STEP = 0 before release/video.^7')
        :format(PLANK_TEST_START_STEP, PLANK_TEST_FULL_FLEET and ' + full fleet' or ''))
end

-- false: crews always get the first free site (the shipped behaviour).
-- true:  a free site is picked at random, so crews spread across your sites.
Config.PlankJob.randomSite = false

Config.PlankJob.minPlayers = 1
Config.PlankJob.maxPlayers = 4

Config.PlankJob.rentAllowed = { 'winch', 'pump', 'mixer' }

-- Add `enabled = false` to a site to take it out of rotation. Useful when you
-- built your own sites with /tw_bp and no longer want the shipped one.
-- If every site is disabled, site1 is forced back on so the region still works.
Config.PlankSites = {
    {
        id       = 'site1',
        labelKey = 'planksite_site1', label    = TL('planksite_site1', 'El Burro Heights Site'),
        anchor   = nil,
        zoneId   = 'buildermainzone',
        designId = nil,
        enabled  = true,
    },

}

if Tworst and Tworst.LoadPlankSitesJson then Tworst.LoadPlankSitesJson() end
if Tworst and Tworst.LoadSiteSettingsJson then Tworst.LoadSiteSettingsJson() end

Config.PlankJob.completeCleanupMs = 15000

Config.PlankJob.plankModel        = 'tworst_buildplank'

Config.PlankJob.pileSpawns        = {
    { id = 'pile_1', coords = vec3(1012.962, 2374.378, 50.789), rot = vec3(0.000, 0.000, 90.000) },
    { id = 'pile_2', coords = vec3(992.495, 2362.292, 50.674), rot = vec3(2.296, -3.124, -0.063) },
}

Config.PlankJob.plankSlots        = {
    { coords = vec3(997.330, 2381.636, 50.424),  rot = vec3(0.0, 0.0, 180.0) },
    { coords = vec3(999.637, 2381.636, 50.424),  rot = vec3(0.0, 0.0, 180.0) },
    { coords = vec3(1001.944, 2381.636, 50.424),  rot = vec3(0.0, 0.0, 180.0) },
    { coords = vec3(1004.251, 2381.636, 50.424),  rot = vec3(0.0, 0.0, 180.0) },
    { coords = vec3(1006.558, 2381.636, 50.424),  rot = vec3(0.0, 0.0, 180.0) },
    { coords = vec3(1008.865, 2381.636, 50.424),  rot = vec3(0.0, 0.0, 180.0) },
    { coords = vec3(997.182, 2354.050, 50.424),  rot = vec3(0.0, 0.0, 0.0) },
    { coords = vec3(999.485, 2354.050, 50.424),  rot = vec3(0.0, 0.0, 0.0) },
    { coords = vec3(1001.789, 2354.050, 50.424),  rot = vec3(0.0, 0.0, 0.0) },
    { coords = vec3(1004.092, 2354.050, 50.424),  rot = vec3(0.0, 0.0, 0.0) },
    { coords = vec3(1006.396, 2354.050, 50.424),  rot = vec3(0.0, 0.0, 0.0) },
    { coords = vec3(1008.699, 2354.050, 50.424),  rot = vec3(0.0, 0.0, 0.0) },
    { coords = vec3(995.651, 2355.713, 50.424),  rot = vec3(0.0, 0.0, -90.0) },
    { coords = vec3(995.651, 2358.423, 50.424),  rot = vec3(0.0, 0.0, -90.0) },
    { coords = vec3(995.651, 2361.134, 50.424),  rot = vec3(0.0, 0.0, -90.0) },
    { coords = vec3(995.651, 2363.844, 50.424),  rot = vec3(0.0, 0.0, -90.0) },
    { coords = vec3(995.651, 2366.555, 50.424),  rot = vec3(0.0, 0.0, -90.0) },
    { coords = vec3(995.651, 2369.265, 50.424),  rot = vec3(0.0, 0.0, -90.0) },
    { coords = vec3(995.651, 2371.976, 50.424),  rot = vec3(0.0, 0.0, -90.0) },
    { coords = vec3(995.651, 2374.686, 50.424),  rot = vec3(0.0, 0.0, -90.0) },
    { coords = vec3(995.651, 2377.397, 50.424),  rot = vec3(0.0, 0.0, -90.0) },
    { coords = vec3(995.651, 2380.107, 50.424),  rot = vec3(0.0, 0.0, -90.0) },
    { coords = vec3(1010.384, 2355.713, 50.424),  rot = vec3(0.0, 0.0, 90.0) },
    { coords = vec3(1010.384, 2358.408, 50.424),  rot = vec3(0.0, 0.0, 90.0) },
    { coords = vec3(1010.384, 2361.103, 50.424),  rot = vec3(0.0, 0.0, 90.0) },
    { coords = vec3(1010.384, 2363.798, 50.424),  rot = vec3(0.0, 0.0, 90.0) },
    { coords = vec3(1010.384, 2366.493, 50.424),  rot = vec3(0.0, 0.0, 90.0) },
    { coords = vec3(1010.384, 2369.187, 50.424),  rot = vec3(0.0, 0.0, 90.0) },
    { coords = vec3(1010.384, 2371.882, 50.424),  rot = vec3(0.0, 0.0, 90.0) },
    { coords = vec3(1010.384, 2374.577, 50.424),  rot = vec3(0.0, 0.0, 90.0) },
    { coords = vec3(1010.384, 2377.272, 50.424),  rot = vec3(0.0, 0.0, 90.0) },
    { coords = vec3(1010.384, 2379.967, 50.424),  rot = vec3(0.0, 0.0, 90.0) },
}

Config.PlankJob.baseModel         = 'tworst_buildbase1'

Config.PlankJob.baseGroundZOffset = -0.573

Config.PlankJob.wireGroundLift    = 0.537

Config.PlankJob.baseSlots         = {
    { coords = vec3(1006.907, 2379.424, 50.429), rot = vec3(0.0, 0.0, 0.0) },
    { coords = vec3(1006.907, 2374.906, 50.429), rot = vec3(0.0, 0.0, 0.0) },
    { coords = vec3(1006.907, 2370.387, 50.429), rot = vec3(0.0, 0.0, 0.0) },
    { coords = vec3(1006.907, 2365.869, 50.429), rot = vec3(0.0, 0.0, 0.0) },
    { coords = vec3(1006.907, 2361.350, 50.429), rot = vec3(0.0, 0.0, 0.0) },
    { coords = vec3(1006.907, 2356.832, 50.429), rot = vec3(0.0, 0.0, 0.0) },
    { coords = vec3(999.786, 2379.424, 50.429),  rot = vec3(0.0, 0.0, 0.0) },
    { coords = vec3(999.786, 2374.906, 50.429),  rot = vec3(0.0, 0.0, 0.0) },
    { coords = vec3(999.786, 2370.387, 50.429),  rot = vec3(0.0, 0.0, 0.0) },
    { coords = vec3(999.786, 2365.869, 50.429),  rot = vec3(0.0, 0.0, 0.0) },
    { coords = vec3(999.786, 2361.350, 50.429),  rot = vec3(0.0, 0.0, 0.0) },
    { coords = vec3(999.786, 2356.832, 50.429),  rot = vec3(0.0, 0.0, 0.0) },
}

Config.PlankJob.baseSlotsFinal    = Config.PlankJob.baseSlots

Config.PlankJob.pump              = {
    spawn      = vector4(1001.92, 2355.41, 50.85, 81.23),
    pourRadius = 4.0,
    pourDrain  = 0.07,
}

Config.PlankJob.concreteQuadrants = {
    { id = 1, label = 'NE', center = vec3(1006.907, 2374.906, 51.0), slots = { 1, 2, 3 } },
    { id = 2, label = 'SE', center = vec3(1006.907, 2361.350, 51.0), slots = { 4, 5, 6 } },
    { id = 3, label = 'NW', center = vec3(999.786,  2374.906, 51.0), slots = { 7, 8, 9 } },
    { id = 4, label = 'SW', center = vec3(999.786,  2361.350, 51.0), slots = { 10, 11, 12 } },
}

Config.PlankJob.concretePour      = {
    pourPtfxMs       = 3500,
    riseMs           = 2500,
    riseMsFinal      = 2500,
    startZOffset      = -0.4,
    startZOffsetFinal = -0.873,
    finalTopLift      = 0.08,
    marker2Lift       = -0.273,
    pourHover         = 0.6,
    pourCostPerQuad   = 0.25,
    pourFlowRate      = 0.05,
}

Config.PlankJob.concreteTimings   = {
    firstCuringMs = 10000,

    finalCuringMs = 10000,
}

Config.PlankJob.wireModel         = 'tworst_buildwire'
Config.PlankJob.wireGrid          = {
    startX = 996.998,
    endX = 1009.005,
    cols = 6,
    startY = 2355.267,
    endY = 2380.424,
    rows = 14,
    z = 50.429 + Config.PlankJob.baseGroundZOffset + Config.PlankJob.wireGroundLift,
}

Config.PlankJob.wirePileSpawns    = {
    { id = 'wirepile_1', coords = vec3(992.183, 2358.566, 50.679), rot = vec3(0.0, 0.0, 0.0) },
    { id = 'wirepile_2', coords = vec3(1013.014, 2377.423, 50.837), rot = vec3(0.0, 0.0, 0.0) },
}

-- /tw_bp derives a site's zone from its footprint; this is the margin left
-- around it. factor = share of the spread, min/max are the bounds.
Config.PlankJob.zoneMargin        = { factor = 0.35, min = 12.0, max = 30.0 }

-- Metres the slab is lifted above the terrain after G (sit on ground).
-- A site's base is not bare terrain: concrete is poured on top of it.
Config.PlankJob.snapLift          = 0.08

Config.PlankJob.pileGround        = {
    enabled = true,
    lift    = 0.03,
    maxAdjust = 4.0,

    modelSink = {
        tworst_buildground = 0.28,
    },
}

Config.PlankJob.pileStacks        = {
    plank = {
        enabled    = true,
        model      = nil,
        stackCount = 5,
        baseOffset = vec3(0.0, 0.0, 0.0),
        rot        = vec3(-90.0, 0.0, 0.0),
        stackStep  = vec3(0.0, 0.0, 0.10),
    },
    wire = {
        enabled    = true,
        model      = nil,
        stackCount = 5,
        baseOffset = vec3(0.0, 0.0, 0.0),
        rot        = vec3(0.0, 0.0, 0.0),
        stackStep  = vec3(0.0, 0.0, 0.06),
    },
}

Config.PlankJob.craneVehicleSpawn = {
    coords  = vec3(994.41, 2385.21, 49.97),
    heading = -60.0,
}
Config.PlankJob.hookRigPoint      = vector3(0.0, 0.0, 0.25)
Config.PlankJob.poleCarryRot      = vector3(8.0, 0.0, 0.0)
Config.PlankJob.wallCarryRot      = vector3(18.0, 0.0, 0.0)
Config.PlankJob.poleRaiseRange    = 2.5
Config.PlankJob.wallRaiseRange    = 2.0

Config.PlankJob.poleModel         = 'tworst_build1u'

Config.PlankJob.poleSlots         = {
    { coords = vec3(996.000, 2372.315, 54.439),  rot = vec3(0.0, 0.0, 0.0) },
    { coords = vec3(996.000, 2381.237, 54.439),  rot = vec3(0.0, 0.0, 0.0) },
    { coords = vec3(1002.991, 2381.237, 54.439), rot = vec3(0.0, 0.0, 0.0) },
    { coords = vec3(1010.100, 2381.237, 54.439), rot = vec3(0.0, 0.0, 0.0) },
    { coords = vec3(1002.991, 2372.315, 54.439), rot = vec3(0.0, 0.0, 0.0) },
    { coords = vec3(1010.100, 2372.315, 54.439), rot = vec3(0.0, 0.0, 0.0) },
    { coords = vec3(1010.100, 2354.425, 54.439), rot = vec3(0.0, 0.0, 0.0) },
    { coords = vec3(1002.991, 2354.425, 54.439), rot = vec3(0.0, 0.0, 0.0) },
    { coords = vec3(1002.991, 2363.316, 54.439), rot = vec3(0.0, 0.0, 0.0) },
    { coords = vec3(1010.100, 2363.316, 54.439), rot = vec3(0.0, 0.0, 0.0) },
}

Config.PlankJob.polePickups       = {
    { coords = vec3(988.042, 2373.598, 50.342), rot = vec3(90.0, 0.0, 90.0) },
    { coords = vec3(988.042, 2374.297, 50.342), rot = vec3(90.0, 0.0, 90.0) },
    { coords = vec3(988.042, 2374.935, 50.342), rot = vec3(90.0, 0.0, 90.0) },
    { coords = vec3(988.042, 2375.572, 50.342), rot = vec3(90.0, 0.0, 90.0) },
    { coords = vec3(988.042, 2376.271, 50.342), rot = vec3(90.0, 0.0, 90.0) },
    { coords = vec3(988.042, 2373.598, 50.642), rot = vec3(90.0, 0.0, 90.0) },
    { coords = vec3(988.042, 2374.297, 50.642), rot = vec3(90.0, 0.0, 90.0) },
    { coords = vec3(988.042, 2374.935, 50.642), rot = vec3(90.0, 0.0, 90.0) },
    { coords = vec3(988.042, 2375.572, 50.642), rot = vec3(90.0, 0.0, 90.0) },
    { coords = vec3(988.042, 2376.271, 50.642), rot = vec3(90.0, 0.0, 90.0) },
}

Config.PlankJob.rebarModel        = 'tworst_build1b'

Config.PlankJob.rebarSlots        = {
    { model = 'tworst_build1b', coords = vec3(1002.991, 2376.768, 54.498), rot = vec3(0.0, 0.0, 0.0) },
    { model = 'tworst_build1b', coords = vec3(996.000, 2376.768, 54.498),  rot = vec3(0.0, 0.0, 0.0) },
    { model = 'tworst_build1b', coords = vec3(1010.100, 2376.768, 54.498), rot = vec3(0.0, 0.0, 0.0) },
    { model = 'tworst_build1b', coords = vec3(1010.100, 2358.766, 54.498), rot = vec3(0.0, 0.0, 0.0) },
    { model = 'tworst_build1b', coords = vec3(1010.100, 2367.844, 54.498), rot = vec3(0.0, 0.0, 0.0) },
    { model = 'tworst_build1b', coords = vec3(1002.991, 2358.766, 54.498), rot = vec3(0.0, 0.0, 0.0) },
    { model = 'tworst_build1b', coords = vec3(1002.991, 2367.844, 54.498), rot = vec3(0.0, 0.0, 0.0) },
}

Config.PlankJob.rebarSlotsUpper   = {
    { model = 'tworst_build1b', coords = vec3(1002.991, 2376.768, 58.695), rot = vec3(0.0, 0.0, 0.0) },
    { model = 'tworst_build1b', coords = vec3(1010.100, 2376.768, 58.695), rot = vec3(0.0, 0.0, 0.0) },
    { model = 'tworst_build1b', coords = vec3(1010.100, 2367.844, 58.695), rot = vec3(0.0, 0.0, 0.0) },
    { model = 'tworst_build1b', coords = vec3(1010.100, 2358.766, 58.695), rot = vec3(0.0, 0.0, 0.0) },
    { model = 'tworst_build1b', coords = vec3(1002.991, 2358.766, 58.695), rot = vec3(0.0, 0.0, 0.0) },
    { model = 'tworst_build1b', coords = vec3(1002.991, 2367.844, 58.695), rot = vec3(0.0, 0.0, 0.0) },
    { model = 'tworst_build1b', coords = vec3(996.000, 2376.768, 58.695),  rot = vec3(0.0, 0.0, 0.0) },
}

Config.PlankJob.groundModel       = 'tworst_buildground'
Config.PlankJob.groundWallModel   = 'tworst_buildwall1'

Config.PlankJob.groundTopSlots    = {
    { coords = vec3(1007.251, 2369.617, 54.195), rot = vec3(0.0, 0.0, 0.0) },
    { coords = vec3(1007.251, 2365.216, 54.195), rot = vec3(0.0, 0.0, 0.0) },
    { coords = vec3(1007.251, 2360.745, 54.195), rot = vec3(0.0, 0.0, 0.0) },
    { coords = vec3(1007.251, 2356.333, 54.195), rot = vec3(0.0, 0.0, 0.0) },
    { coords = vec3(1000.258, 2378.613, 54.195), rot = vec3(0.0, 0.0, 0.0) },
    { coords = vec3(1007.251, 2374.214, 54.195), rot = vec3(0.0, 0.0, 0.0) },
    { coords = vec3(1007.251, 2378.608, 54.195), rot = vec3(0.0, 0.0, 0.0) },
    { coords = vec3(1000.258, 2374.167, 54.195), rot = vec3(0.0, 0.0, 0.0) },
}

Config.PlankJob.frameCornerModel  = 'tworst_build1y'
Config.PlankJob.frameSwapYawDelta = 90.0
Config.PlankJob.frameCornerSlots  = {
    { coords = vec3(1006.565, 2381.145, 58.651), rot = vec3(0.0, 0.0, 0.0) },
    { coords = vec3(999.480, 2381.145, 58.651),  rot = vec3(0.0, 0.0, 0.0) },
    { coords = vec3(1006.565, 2372.191, 58.651), rot = vec3(0.0, 0.0, 0.0) },
    { coords = vec3(1006.565, 2363.212, 58.651), rot = vec3(0.0, 0.0, 0.0) },
    { coords = vec3(999.480, 2376.768, 58.651),  rot = vec3(0.0, 0.0, 0.0) },
    { coords = vec3(1006.565, 2367.722, 58.651), rot = vec3(0.0, 0.0, 0.0) },
    { coords = vec3(1006.565, 2376.768, 58.651), rot = vec3(0.0, 0.0, 0.0) },
    { coords = vec3(999.480, 2372.191, 58.651),  rot = vec3(0.0, 0.0, 0.0) },
    { coords = vec3(1006.565, 2354.221, 58.651), rot = vec3(0.0, 0.0, 0.0) },
    { coords = vec3(999.480, 2372.191, 54.440),  rot = vec3(0.0, 0.0, 0.0) },
    { coords = vec3(999.480, 2381.145, 54.440),  rot = vec3(0.0, 0.0, 0.0) },
    { coords = vec3(1006.565, 2372.191, 54.440), rot = vec3(0.0, 0.0, 0.0) },
    { coords = vec3(1006.565, 2363.212, 54.440), rot = vec3(0.0, 0.0, 0.0) },
    { coords = vec3(1006.565, 2354.221, 54.440), rot = vec3(0.0, 0.0, 0.0) },
    { coords = vec3(1006.565, 2381.145, 54.440), rot = vec3(0.0, 0.0, 0.0) },
}

Config.PlankJob.frameEdgeModel    = nil
Config.PlankJob.frameEdgeSlots    = {}

Config.PlankJob.rebarCranePickups = {}
do
    local total = #Config.PlankJob.rebarSlots + #Config.PlankJob.rebarSlotsUpper
        + #Config.PlankJob.frameCornerSlots
    local yStart, yEnd = 2372.875, 2377.557
    local x = 987.740
    local perLayer = math.ceil(total / 2)
    local step = (perLayer > 1) and ((yEnd - yStart) / (perLayer - 1)) or 0.0
    for layer = 0, 1 do
        local z = 50.375 + layer * 0.300
        for i = 1, perLayer do
            if #Config.PlankJob.rebarCranePickups >= total then break end
            Config.PlankJob.rebarCranePickups[#Config.PlankJob.rebarCranePickups + 1] = {
                coords = vec3(x, yStart + (i - 1) * step, z), rot = vec3(0.0, 0.0, 90.0),
            }
        end
    end
end

Config.PlankJob.groundWallSlots = {
    { model = 'tworst_buildwall1', coords = vec3(1003.091, 2370.275, 52.410), rot = vec3(0.0, 0.0, 0.0) },
    { model = 'tworst_buildwall1', coords = vec3(1003.091, 2365.776, 52.410), rot = vec3(0.0, 0.0, 0.0) },
    { model = 'tworst_buildwall1', coords = vec3(1010.054, 2365.776, 52.410), rot = vec3(0.0, 0.0, 0.0) },
    { model = 'tworst_buildwall1', coords = vec3(1010.054, 2370.275, 52.410), rot = vec3(0.0, 0.0, 0.0) },
    { model = 'tworst_buildwindow', coords = vec3(1010.054, 2361.278, 52.410), rot = vec3(0.0, 0.0, 0.0) },
    { model = 'tworst_buildwall1', coords = vec3(1010.054, 2356.780, 52.410), rot = vec3(0.0, 0.0, 0.0) },
    { model = 'tworst_buildwall1', coords = vec3(1010.054, 2379.224, 52.410), rot = vec3(0.0, 0.0, 0.0) },
    { model = 'tworst_buildwindow', coords = vec3(1010.054, 2374.726, 52.410), rot = vec3(0.0, 0.0, 0.0) },
    { model = 'tworst_buildwindow', coords = vec3(996.131, 2374.726, 52.410),  rot = vec3(0.0, 0.0, 0.0) },
    { model = 'tworst_buildwall1', coords = vec3(996.131, 2379.224, 52.410),  rot = vec3(0.0, 0.0, 0.0) },
    { model = 'tworst_builwall1a', coords = vec3(1007.874, 2381.185, 52.438), rot = vec3(0.0, 0.0, 0.0) },
    { model = 'tworst_builwall1a', coords = vec3(1004.375, 2381.185, 52.438), rot = vec3(0.0, 0.0, 0.0) },
    { model = 'tworst_builwall1a', coords = vec3(997.369, 2381.185, 52.438),  rot = vec3(0.0, 0.0, 0.0) },
    { model = 'tworst_builwall1a', coords = vec3(1000.867, 2381.185, 52.438), rot = vec3(0.0, 0.0, 0.0) },
    { model = 'tworst_builwall1a', coords = vec3(1000.867, 2372.372, 52.438), rot = vec3(0.0, 0.0, 0.0) },
    { model = 'tworst_builwall1a', coords = vec3(997.369, 2372.372, 52.438),  rot = vec3(0.0, 0.0, 0.0) },
    { model = 'tworst_builwall1a', coords = vec3(1004.442, 2354.425, 52.438), rot = vec3(0.0, 0.0, 0.0) },
    { model = 'tworst_builwall1a', coords = vec3(1007.941, 2354.425, 52.438), rot = vec3(0.0, 0.0, 0.0) },
}

Config.PlankJob.groundWallSlotsUpper = {
    { model = 'tworst_buildwall1', coords = vec3(1010.054, 2379.224, 56.585), rot = vec3(0.0, 0.0, 0.0) },
    { model = 'tworst_buildwindow', coords = vec3(1010.054, 2374.726, 56.585), rot = vec3(0.0, 0.0, 0.0) },
    { model = 'tworst_buildwall1', coords = vec3(1010.054, 2370.275, 56.585), rot = vec3(0.0, 0.0, 0.0) },
    { model = 'tworst_buildwall1', coords = vec3(1010.054, 2365.776, 56.585), rot = vec3(0.0, 0.0, 0.0) },
    { model = 'tworst_buildwindow', coords = vec3(1010.054, 2361.278, 56.585), rot = vec3(0.0, 0.0, 0.0) },
    { model = 'tworst_buildwall1', coords = vec3(1010.054, 2356.780, 56.585), rot = vec3(0.0, 0.0, 0.0) },
    { model = 'tworst_buildwall1', coords = vec3(996.131, 2379.224, 56.585),  rot = vec3(0.0, 0.0, 0.0) },
    { model = 'tworst_buildwindow', coords = vec3(996.131, 2374.726, 56.585),  rot = vec3(0.0, 0.0, 0.0) },
    { model = 'tworst_buildwall1', coords = vec3(1003.091, 2370.275, 56.585), rot = vec3(0.0, 0.0, 0.0) },
    { model = 'tworst_buildwall1', coords = vec3(1003.091, 2356.780, 56.585), rot = vec3(0.0, 0.0, 0.0) },
    { model = 'tworst_buildwall1', coords = vec3(1003.091, 2365.776, 56.585), rot = vec3(0.0, 0.0, 0.0) },
    { model = 'tworst_buildwall1', coords = vec3(1003.091, 2361.278, 56.585), rot = vec3(0.0, 0.0, 0.0) },
    { model = 'tworst_builwall1a', coords = vec3(1007.874, 2381.185, 56.585), rot = vec3(0.0, 0.0, 0.0) },
    { model = 'tworst_builwall1a', coords = vec3(1004.375, 2381.185, 56.585), rot = vec3(0.0, 0.0, 0.0) },
    { model = 'tworst_builwall1a', coords = vec3(1000.954, 2381.185, 56.585), rot = vec3(0.0, 0.0, 0.0) },
    { model = 'tworst_builwall1a', coords = vec3(997.455, 2381.185, 56.585),  rot = vec3(0.0, 0.0, 0.0) },
    { model = 'tworst_builwall1a', coords = vec3(997.455, 2372.372, 56.585),  rot = vec3(0.0, 0.0, 0.0) },
    { model = 'tworst_builwall1a', coords = vec3(1000.954, 2372.372, 56.585), rot = vec3(0.0, 0.0, 0.0) },
    { model = 'tworst_builwall1a', coords = vec3(1007.941, 2354.425, 56.585), rot = vec3(0.0, 0.0, 0.0) },
    { model = 'tworst_builwall1a', coords = vec3(1004.442, 2354.425, 56.585), rot = vec3(0.0, 0.0, 0.0) },
}

Config.PlankJob.groundCranePickups = {}
do
    local x, y = 985.0, 2375.0
    local zBase = 50.4
    local zStep = 0.15
    local total = #Config.PlankJob.groundWallSlots
    for i = 1, total do
        Config.PlankJob.groundCranePickups[i] = {
            coords = vec3(x, y, zBase + (i - 1) * zStep),
            rot    = vec3(0.0, 90.0, 0.0),
        }
    end
end

Config.PlankJob.upperWallCranePickups = {}
do
    local x, y = 985.0, 2375.0
    local zBase = 50.4
    local zStep = 0.15
    local total = #Config.PlankJob.groundWallSlotsUpper
    for i = 1, total do
        Config.PlankJob.upperWallCranePickups[i] = {
            coords = vec3(x, y, zBase + (i - 1) * zStep),
            rot    = vec3(0.0, 90.0, 0.0),
        }
    end
end

Config.PlankJob.groundTopSlotsUpper = {
    { coords = vec3(1007.251, 2378.608, 58.400), rot = vec3(0.0, 0.0, 0.0) },
    { coords = vec3(1007.251, 2374.214, 58.400), rot = vec3(0.0, 0.0, 0.0) },
    { coords = vec3(1000.258, 2378.613, 58.400), rot = vec3(0.0, 0.0, 0.0) },
    { coords = vec3(1007.251, 2356.333, 58.400), rot = vec3(0.0, 0.0, 0.0) },
    { coords = vec3(1007.251, 2360.745, 58.400), rot = vec3(0.0, 0.0, 0.0) },
    { coords = vec3(1007.251, 2365.216, 58.400), rot = vec3(0.0, 0.0, 0.0) },
    { coords = vec3(1007.251, 2369.617, 58.400), rot = vec3(0.0, 0.0, 0.0) },
    { coords = vec3(1000.258, 2374.167, 58.400), rot = vec3(0.0, 0.0, 0.0) },
}

Config.PlankJob.upperCeilingCranePickups = {}
do
    local x, y = 986.587, 2375.0
    local zBase = 49.978
    local zStep = 0.15
    local total = #Config.PlankJob.groundTopSlotsUpper
    for i = 1, total do
        Config.PlankJob.upperCeilingCranePickups[i] = {
            coords = vec3(x, y, zBase + (i - 1) * zStep),
            rot    = vec3(0.0, 0.0, 0.0),
        }
    end
end

Config.PlankJob.ceilingCranePickups = {}
do
    local x, y = 986.587, 2375.0
    local zBase = 49.978
    local zStep = 0.15
    local total = #Config.PlankJob.groundTopSlots
    for i = 1, total do
        Config.PlankJob.ceilingCranePickups[i] = {
            coords = vec3(x, y, zBase + (i - 1) * zStep),
            rot    = vec3(0.0, 0.0, 0.0),
        }
    end
end

Config.PlankJob.hologram              = {
    alpha         = 80,
    outlineDist   = 5.0,
    highlightDist = 2.0,
    colorIdle     = { r = 255, g = 255, b = 255 },
    colorActive   = { r = 0, g = 255, b = 100 },
    colorBlocked  = { r = 255, g = 60, b = 60 },
    colorNear     = { r = 255, g = 60, b = 60 },
}

Config.PlankJob.interaction           = {
    pileDistance  = 2.5,
    placeDistance = 2.0,
    eCooldownMs   = 400,
}

Config.PlankJob.autoComplete          = {
    threshold = 0,
    delayMs   = 80,
    appliesTo = { plank = true, wire = true, pole = false },
}

Config.PlankJob.carry                 = {
    attachBone   = 28422,
    attachOffset = vec3(0.18, 0.10, -0.10),
    attachRot    = vec3(-80.0, 0.0, 0.0),
    animDict     = 'anim@heists@box_carry@',
    animClip     = 'idle',
    animFlag     = 49,
-- Phases where the player may sprint while carrying.
    sprintPhases = { wire = true, plank = true },
}

Config.PlankJob.carryGrips            = {
    plank = {
        bone = 11816,
        offset = vec3(-0.380, -0.440, -0.028),
        rot = vec3(-1.6, -93.2, -35.8),
        animDict = 'tworsttrow@anim', animClip = 'tworsttrow_clip', animFlag = 49,
    },
    wire = {
        bone = 11816,
        offset = vec3(-0.532, -0.068, 0.062),
        rot = vec3(85.6, -21.8, -1.8),
        animDict = 'tworsttrow@anim', animClip = 'tworsttrow_clip', animFlag = 49,
    },
}

Config.PlankJob.placement             = {
    lerpDurationMs = 800,
    lerpSteps      = 20,
    charAnimDict   = 'anim@mp_fireworks',
    charAnimClip   = 'place_firework_box2',
    charAnimFlag   = 2,
    charAnimMs     = 900,
    propDelayMs    = 450,
    plankStartRot  = vec3(69.625, 0.0, 0.0),
}

Config.PlankJob.phaseWeights          = {
    plank          = { labelKey = 'plank_phase_formwork', label = TL('plank_phase_formwork', 'Formwork Panels'), units = 32, weight = 15 },
    wire           = { labelKey = 'plank_phase_rebar', label = TL('plank_phase_rebar', 'Rebar Grid'), units = 84, weight = 15 },
    concrete2      = { labelKey = 'plank_phase_pour', label = TL('plank_phase_pour', 'Concrete Pour'), units = 1, weight = 20 },
    pole           = { labelKey = 'plank_phase_columns', label = TL('plank_phase_columns', 'Vertical Columns'), units = 10, weight = 15 },
    stage5_cleanup = { labelKey = 'plank_phase_finishing', label = TL('plank_phase_finishing', 'Finishing'), units = 6, weight = 35 },
    complete       = { labelKey = 'phase_complete', label = TL('phase_complete', 'Complete'), units = 0, weight = 0 },
}

Config.PlankJob.phaseVehicles         = {
    plank          = {},
    wire           = {},
    concrete2      = { 'pump', 'mixer' },
    pole           = { 'winch' },
    stage5_cleanup = { 'winch' },
    complete       = {},
}

-- Vehicle names shown in the task row.
-- ⚠ Kept in PAIR with vehicleLabelKeys below: the text freezes to the server's
-- language, the KEY is resolved in the player's. Change one, change the other.
Config.PlankJob.vehicleLabels         = {
    winch = TL('plankveh_winch', 'Crane'),
    pump  = TL('plankveh_pump',  'Concrete pump'),
    mixer = TL('plankveh_mixer', 'Mixer'),
}

Config.PlankJob.vehicleLabelKeys      = {
    winch = 'plankveh_winch',
    pump  = 'plankveh_pump',
    mixer = 'plankveh_mixer',
}

-- Task rows shown in the mission list, in order.
-- `label` is resolved WHILE THIS FILE LOADS, so it freezes to the server's
-- language. `labelKey` is what actually reaches the player: the client
-- resolves it in their own language. Keep both in step -- a row with only
-- `label` stays in the server language for everyone.
Config.PlankJob.taskRows              = {
    { id = 1,  cat = 'plank',        labelKey = 'plankcat_formwork',        label = TL('plankcat_formwork',        'Formwork panel') },
    { id = 2,  cat = 'wire',         labelKey = 'plankcat_rebar_mesh',      label = TL('plankcat_rebar_mesh',      'Rebar mesh') },
    { id = 3,  cat = 'concrete2',    labelKey = 'plankcat_concrete_pour',   label = TL('plankcat_concrete_pour',   'Concrete pour') },
    { id = 4,  cat = 'plankRemoved', labelKey = 'plankcat_formwork_strip',  label = TL('plankcat_formwork_strip',  'Formwork stripping') },
    { id = 5,  cat = 'pole',         labelKey = 'plankcat_column',          label = TL('plankcat_column',          'Vertical column') },
    { id = 6,  cat = 'rebar',        labelKey = 'plankcat_rebar_tying',     label = TL('plankcat_rebar_tying',     'Rebar tying') },
    { id = 7,  cat = 'ground',       labelKey = 'plankcat_wall_building',   label = TL('plankcat_wall_building',   'Wall building') },
    { id = 8,  cat = 'ceiling',      labelKey = 'plankcat_ceiling_decking', label = TL('plankcat_ceiling_decking', 'Ceiling decking') },
    { id = 9,  cat = 'upperWall',    labelKey = 'plankcat_upper_wall',      label = TL('plankcat_upper_wall',      '2nd floor wall') },
    { id = 10, cat = 'upperCeiling', labelKey = 'plankcat_roof',            label = TL('plankcat_roof',            'Roof') },
}

Config.PlankJob.customTasks           = {}

if Config.PlankJob.designId and Tworst and Tworst.ApplyBlueprintToPlankJob then
    Tworst.ApplyBlueprintToPlankJob(Config.PlankJob.designId)
end
