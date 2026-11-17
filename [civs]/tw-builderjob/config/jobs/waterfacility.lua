-- ====================================================================
-- REGION 6 -- Water Facility
-- ====================================================================
-- Two phases: (1) pour the base with pump + mixer, (2) stone wall with the
-- tower crane.
-- ====================================================================

Config.WaterFacilityJob          = {}

Config.WaterFacilityJob.zoneId   = 'buildermainzone'

Config.WaterFacilityJob.crewProfiles = {
    [1] = { vehicles = { mixer = 1, pump = 1, winch = 1 } },
    [2] = { vehicles = { mixer = 1, pump = 1, winch = 2 } },
    [3] = { vehicles = { mixer = 1, pump = 1, winch = 3 } },
    [4] = { vehicles = { mixer = 1, pump = 1, winch = 4 } },
}
Config.WaterFacilityJob.rentAllowed = { 'mixer', 'pump', 'winch' }

-- Vehicles a phase needs at the same time; also the floor for the rental cap.
-- The concrete phase needs pump and mixer together (the parked mixer feeds the hopper within 8 m).
-- Without this floor a solo crew gets a cap of 1 and phase 1 stalls.
Config.WaterFacilityJob.phaseVehicles = {
    base      = { 'pump', 'mixer' },
    stonewall = { 'winch' },
}

if Config.SoloTest and not Config.WaterFacilityJob.crewProfiles[1] then
    Config.WaterFacilityJob.crewProfiles[1] = { vehicles = { mixer = 1, pump = 1, winch = 1 } }
end

Config.WaterFacilityJob.minPlayers = 2
Config.WaterFacilityJob.maxPlayers = 4

Config.WaterFacilityJob.baseModel = 'tworst_buildjbase1'

Config.WaterFacilityJob.baseSlots = {
    { coords = vec3(1048.950, 2298.945, 43.472), rot = vec3(0.0, 0.0, 0.0) },
    { coords = vec3(1063.880, 2298.945, 43.472), rot = vec3(0.0, 0.0, 0.0) },
    { coords = vec3(1073.799, 2298.945, 43.472), rot = vec3(0.0, 0.0, 0.0) },
    { coords = vec3(1073.799, 2316.771, 43.472), rot = vec3(0.0, 0.0, 0.0) },
    { coords = vec3(1058.870, 2316.770, 43.472), rot = vec3(0.0, 0.0, 0.0) },
    { coords = vec3(1043.940, 2316.770, 43.472), rot = vec3(0.0, 0.0, 0.0) },
    { coords = vec3(1029.010, 2316.770, 43.472), rot = vec3(0.0, 0.0, 0.0) },
    { coords = vec3(1087.938, 2298.945, 43.472), rot = vec3(0.0, 0.0, 0.0) },
    { coords = vec3(1087.938, 2314.520, 43.472), rot = vec3(0.0, 0.0, 0.0) },
    { coords = vec3(1102.868, 2314.520, 43.472), rot = vec3(0.0, 0.0, 0.0) },
    { coords = vec3(1102.868, 2298.945, 43.472), rot = vec3(0.0, 0.0, 0.0) },
    { coords = vec3(1087.938, 2330.096, 43.472), rot = vec3(0.0, 0.0, 0.0) },
    { coords = vec3(1034.020, 2298.945, 43.472), rot = vec3(0.0, 0.0, 0.0) },
}

Config.WaterFacilityJob.baseAutoCascade = {
    triggers = { 8, 9 },
    auto     = { 10, 11, 12 },
}

Config.WaterFacilityJob.testStartAtStonewall = false

Config.WaterFacilityJob.TOWER_TEST_BASE_LIMIT = 0

Config.WaterFacilityJob.TOWER_TEST_WALL_LIMIT = 0

Config.WaterFacilityJob.testSoloStonewall = false

Config.WaterFacilityJob.pump = {
    spawn      = vector3(1014.08, 2300.36, 46.33),
    spawnRot   = vector3(0.0, 0.0, 92.14),
    pourRadius = 4.0,
    pourDrain  = 0.07,
    markerLift = 0.85,
}

Config.WaterFacilityJob.concretePour = {
    riseMs       = 2500,
    startZOffset = -0.4,
}

Config.WaterFacilityJob.stonewallSlots = {
    { model = 'tworst_buildjstonewall', coords = vec3(1014.566, 2324.402, 49.144), rot = vec3(0.0, 0.0, 18.24) },
    { model = 'tworst_buildjstonewall', coords = vec3(1010.211, 2321.139, 49.144), rot = vec3(0.0, 0.0, 36.62) },
    { model = 'tworst_buildjstonewall', coords = vec3(1007.043, 2316.733, 49.144), rot = vec3(0.0, 0.0, 54.14) },
    { model = 'tworst_buildjstonewall', coords = vec3(1005.395, 2311.547, 49.144), rot = vec3(0.0, 0.0, 72.14) },
    { model = 'tworst_buildjstonewall', coords = vec3(1019.730, 2326.148, 49.144), rot = vec3(0.0, 0.0, 0.0) },
    { model = 'tworst_buildjstonewall', coords = vec3(1085.949, 2326.167, 49.144), rot = vec3(0.0, 0.0, -18.25) },
    { model = 'tworst_buildjstonewall', coords = vec3(1091.076, 2324.427, 49.144), rot = vec3(0.0, 0.0, -37.89) },
    { model = 'tworst_buildjstonewall', coords = vec3(1095.428, 2321.150, 49.144), rot = vec3(0.0, 0.0, -54.75) },
    { model = 'tworst_buildjstonewall', coords = vec3(1098.632, 2316.746, 49.144), rot = vec3(0.0, 0.0, -72.12) },
    { model = 'tworst_buildjstonewall', coords = vec3(1100.301, 2311.583, 49.144), rot = vec3(0.0, 0.0, -90.82) },
    { model = 'tworst_buildjstonewall', coords = vec3(1085.790, 2291.644, 49.144), rot = vec3(0.0, 0.0, -180.82) },
    { model = 'tworst_buildjstonewall', coords = vec3(1090.953, 2293.313, 49.144), rot = vec3(0.0, 0.0, -162.12) },
    { model = 'tworst_buildjstonewall', coords = vec3(1095.357, 2296.517, 49.144), rot = vec3(0.0, 0.0, -144.75) },
    { model = 'tworst_buildjstonewall', coords = vec3(1098.634, 2300.869, 49.144), rot = vec3(0.0, 0.0, -127.89) },
    { model = 'tworst_buildjstonewall', coords = vec3(1100.374, 2305.996, 49.144), rot = vec3(0.0, 0.0, -108.25) },

    { model = 'tworst_buildjstonewalls', coords = vec3(1025.897, 2326.641, 47.992), rot = vec3(0.0, 0.0, -0.234)},
    { model = 'tworst_buildjstonewalls', coords = vec3(1031.296, 2326.624, 47.992), rot = vec3(0.0, 0.0, -0.234)},
    { model = 'tworst_buildjstonewalls', coords = vec3(1036.672, 2326.616, 47.992), rot = vec3(0.0, 0.0, -0.234)},
    { model = 'tworst_buildjstonewalls', coords = vec3(1042.053, 2326.616, 47.992), rot = vec3(0.0, 0.0, -0.234)},
    { model = 'tworst_buildjstonewalls', coords = vec3(1047.453, 2326.641, 47.992), rot = vec3(0.0, 0.0, -0.234)},
    { model = 'tworst_buildjstonewalls', coords = vec3(1052.852, 2326.624, 47.992), rot = vec3(0.0, 0.0, -0.234)},
    { model = 'tworst_buildjstonewalls', coords = vec3(1058.228, 2326.616, 47.992), rot = vec3(0.0, 0.0, -0.234)},
    { model = 'tworst_buildjstonewalls', coords = vec3(1063.609, 2326.616, 47.992), rot = vec3(0.0, 0.0, -0.234)},
    { model = 'tworst_buildjstonewalls', coords = vec3(1068.999, 2326.641, 47.992), rot = vec3(0.0, 0.0, -0.234)},
    { model = 'tworst_buildjstonewalls', coords = vec3(1074.399, 2326.624, 47.992), rot = vec3(0.0, 0.0, -0.234)},
    { model = 'tworst_buildjstonewalls', coords = vec3(1079.775, 2326.616, 47.992), rot = vec3(0.0, 0.0, -0.234)},
    { model = 'tworst_buildjstonewalls', coords = vec3(1025.897, 2291.302, 47.992), rot = vec3(0.0, 0.0, -0.234)},
    { model = 'tworst_buildjstonewalls', coords = vec3(1031.296, 2291.284, 47.992), rot = vec3(0.0, 0.0, -0.234)},
    { model = 'tworst_buildjstonewalls', coords = vec3(1036.672, 2291.277, 47.992), rot = vec3(0.0, 0.0, -0.234)},
    { model = 'tworst_buildjstonewalls', coords = vec3(1042.053, 2291.277, 47.992), rot = vec3(0.0, 0.0, -0.234)},
    { model = 'tworst_buildjstonewalls', coords = vec3(1047.453, 2291.302, 47.992), rot = vec3(0.0, 0.0, -0.234)},
    { model = 'tworst_buildjstonewalls', coords = vec3(1052.852, 2291.284, 47.992), rot = vec3(0.0, 0.0, -0.234)},
    { model = 'tworst_buildjstonewalls', coords = vec3(1058.228, 2291.277, 47.992), rot = vec3(0.0, 0.0, -0.234)},
    { model = 'tworst_buildjstonewalls', coords = vec3(1063.609, 2291.277, 47.992), rot = vec3(0.0, 0.0, -0.234)},
    { model = 'tworst_buildjstonewalls', coords = vec3(1068.999, 2291.302, 47.992), rot = vec3(0.0, 0.0, -0.234)},
    { model = 'tworst_buildjstonewalls', coords = vec3(1074.399, 2291.284, 47.992), rot = vec3(0.0, 0.0, -0.234)},
    { model = 'tworst_buildjstonewalls', coords = vec3(1079.775, 2291.277, 47.992), rot = vec3(0.0, 0.0, -0.234)},
}

Config.WaterFacilityJob.stonewallPileLayout = {
    { coords = vec3(1031.430, 2303.783, 44.288), rot = vec3(90.0, 0.0, 0.0), rotOrder = 0},
    { coords = vec3(1031.430, 2303.783, 45.029), rot = vec3(90.0, 0.0, 0.0), rotOrder = 0},
    { coords = vec3(1031.430, 2303.783, 45.770), rot = vec3(90.0, 0.0, 0.0), rotOrder = 0},
    { coords = vec3(1038.365, 2303.783, 44.288), rot = vec3(90.0, 0.0, 0.0), rotOrder = 0},
    { coords = vec3(1038.365, 2303.783, 45.029), rot = vec3(90.0, 0.0, 0.0), rotOrder = 0},
    { coords = vec3(1038.365, 2303.783, 45.770), rot = vec3(90.0, 0.0, 0.0), rotOrder = 0},
    { coords = vec3(1045.397, 2303.783, 44.288), rot = vec3(90.0, 0.0, 0.0), rotOrder = 0},
    { coords = vec3(1045.397, 2303.783, 45.029), rot = vec3(90.0, 0.0, 0.0), rotOrder = 0},
    { coords = vec3(1045.397, 2303.783, 45.770), rot = vec3(90.0, 0.0, 0.0), rotOrder = 0},
    { coords = vec3(1052.618, 2303.783, 44.288), rot = vec3(90.0, 0.0, 0.0), rotOrder = 0},
    { coords = vec3(1052.618, 2303.783, 45.029), rot = vec3(90.0, 0.0, 0.0), rotOrder = 0},
    { coords = vec3(1052.618, 2303.783, 45.770), rot = vec3(90.0, 0.0, 0.0), rotOrder = 0},
    { coords = vec3(1060.861, 2303.783, 44.288), rot = vec3(90.0, 0.0, 0.0), rotOrder = 0},
    { coords = vec3(1060.861, 2303.783, 45.029), rot = vec3(90.0, 0.0, 0.0), rotOrder = 0},
    { coords = vec3(1060.861, 2303.783, 45.770), rot = vec3(90.0, 0.0, 0.0), rotOrder = 0},
    { coords = vec3(1068.565, 2303.783, 44.288), rot = vec3(90.0, 0.0, 0.0), rotOrder = 0},
    { coords = vec3(1068.565, 2303.783, 45.029), rot = vec3(90.0, 0.0, 0.0), rotOrder = 0},
    { coords = vec3(1068.565, 2303.783, 45.770), rot = vec3(90.0, 0.0, 0.0), rotOrder = 0},
    { coords = vec3(1078.948, 2303.783, 44.288), rot = vec3(90.0, 0.0, 0.0), rotOrder = 0},
    { coords = vec3(1078.948, 2303.783, 45.029), rot = vec3(90.0, 0.0, 0.0), rotOrder = 0},
    { coords = vec3(1078.948, 2303.783, 45.770), rot = vec3(90.0, 0.0, 0.0), rotOrder = 0},
    { coords = vec3(1031.430, 2312.620, 44.288), rot = vec3(90.0, 0.0, 0.0), rotOrder = 0},
    { coords = vec3(1031.430, 2312.620, 45.029), rot = vec3(90.0, 0.0, 0.0), rotOrder = 0},
    { coords = vec3(1031.430, 2312.620, 45.770), rot = vec3(90.0, 0.0, 0.0), rotOrder = 0},
    { coords = vec3(1041.143, 2312.620, 44.288), rot = vec3(90.0, 0.0, 0.0), rotOrder = 0},
    { coords = vec3(1041.143, 2312.620, 45.029), rot = vec3(90.0, 0.0, 0.0), rotOrder = 0},
    { coords = vec3(1041.143, 2312.620, 45.770), rot = vec3(90.0, 0.0, 0.0), rotOrder = 0},
    { coords = vec3(1050.899, 2312.620, 44.288), rot = vec3(90.0, 0.0, 0.0), rotOrder = 0},
    { coords = vec3(1050.899, 2312.620, 45.029), rot = vec3(90.0, 0.0, 0.0), rotOrder = 0},
    { coords = vec3(1050.899, 2312.620, 45.770), rot = vec3(90.0, 0.0, 0.0), rotOrder = 0},
    { coords = vec3(1057.555, 2312.620, 44.288), rot = vec3(90.0, 0.0, 0.0), rotOrder = 0},
    { coords = vec3(1057.555, 2312.620, 45.029), rot = vec3(90.0, 0.0, 0.0), rotOrder = 0},
    { coords = vec3(1057.555, 2312.620, 45.770), rot = vec3(90.0, 0.0, 0.0), rotOrder = 0},
    { coords = vec3(1086.858, 2309.456, 44.288), rot = vec3(90.0, 0.0, 0.0), rotOrder = 0},
    { coords = vec3(1086.858, 2309.456, 45.029), rot = vec3(90.0, 0.0, 0.0), rotOrder = 0},
    { coords = vec3(1093.467, 2309.457, 44.288), rot = vec3(90.0, 0.0, 0.0), rotOrder = 0},
    { coords = vec3(1093.467, 2309.457, 45.029), rot = vec3(90.0, 0.0, 0.0), rotOrder = 0},
}

Config.WaterFacilityJob.phaseWeights = {
    base      = { labelKey = 'wf_phase_base', label = TL('wf_phase_base', 'Base Concrete Pour'),
                  units = #(Config.WaterFacilityJob.baseSlots or {}), weight = 40 },
    stonewall = { labelKey = 'wf_phase_stonewall', label = TL('wf_phase_stonewall', 'Stone Wall Placement'),
                  units = #(Config.WaterFacilityJob.stonewallSlots or {}), weight = 60 },
    complete  = { labelKey = 'phase_complete', label = TL('phase_complete', 'Complete'), units = 0, weight = 0 },
}

Config.WaterFacilityJob.riggingMode         = 'midline'
Config.WaterFacilityJob.grabRange           = 3.5
Config.WaterFacilityJob.placementRange      = 6.5
Config.WaterFacilityJob.placementRotSymmetry = nil

Config.WaterFacilityJob.hookRigPoint        = vector3(0.0, 0.0, 0.25)
Config.WaterFacilityJob.stonewallCarryRot   = vector3(12.0, 0.0, 0.0)
Config.WaterFacilityJob.stonewallRaiseRange = 2.0
Config.WaterFacilityJob.craneVehicleSpawn   = {
    coords  = vec3(990.5, 2308.0, 49.6),
    heading = 90.0,
}

local function buildWFStonewallSlots()
    local out = {}
    for _, s in ipairs(Config.WaterFacilityJob.stonewallSlots or {}) do
        out[#out + 1] = { coords = s.coords, rot = s.rot, model = s.model }
    end
    return out
end

Config.WFTowerJob1 = {
    suppressPlacedNotify = true,
    instanceId = 'wf2_t1',
    zoneId     = 'buildermainzone',
    model      = 'tworst_buildjstonewall',

    sharedSitePile = true,
    placeRotOrder = 2,
    pickup = {
        base            = vector3(1057.0, 2310.0, 49.0),
        rot             = vector3(0.0, 0.0, 0.0),
        rotOrder        = 2,
        stackCount      = 5,
        stackStep       = vector3(0.000, 0.000, 0.500),
        respawnOnPlaced = false,
    },

    slots = buildWFStonewallSlots(),

    grabRange  = Config.WaterFacilityJob.grabRange,
    placeRange = Config.WaterFacilityJob.placementRange,

    hookAttach = {
        offset = vector3(0.0, 0.0, -0.4),
        rot    = vector3(0.0, 0.0, 0.0),
    },

    placementStyle = 'simple',

    slotPlacedEvent  = 'wf:stonewallPlaced',
    slotReserveEvent = 'wf:stoneReserve',
}

Config.TowerCraneJobs = Config.TowerCraneJobs or {}

if Config.ReleaseBuild then
    local W = Config.WaterFacilityJob
    local forced = {}
    if (tonumber(W.TOWER_TEST_BASE_LIMIT) or 0) > 0 then
        forced[#forced + 1] = ('TOWER_TEST_BASE_LIMIT %s→0'):format(tostring(W.TOWER_TEST_BASE_LIMIT))
        W.TOWER_TEST_BASE_LIMIT = 0
    end
    if (tonumber(W.TOWER_TEST_WALL_LIMIT) or 0) > 0 then
        forced[#forced + 1] = ('TOWER_TEST_WALL_LIMIT %s→0'):format(tostring(W.TOWER_TEST_WALL_LIMIT))
        W.TOWER_TEST_WALL_LIMIT = 0
    end
    if W.testStartAtStonewall == true then
        forced[#forced + 1] = 'testStartAtStonewall→false'
        W.testStartAtStonewall = false
    end
    if W.testSoloStonewall == true then
        forced[#forced + 1] = 'testSoloStonewall→false'
        W.testSoloStonewall = false
    end
    if #forced > 0 then
        print('^3[wf][RELEASE]^7 test settings force-disabled: ' .. table.concat(forced, ', '))
    end
end

do
    local W = Config.WaterFacilityJob
    local n = tonumber(W.TOWER_TEST_BASE_LIMIT) or 0
    if n > 0 then
        local full = #(W.baseSlots or {})
        if full > n then
            for i = full, n + 1, -1 do W.baseSlots[i] = nil end
        end
        local cas, dropped = W.baseAutoCascade, 0
        if cas then
            for _, key in ipairs({ 'triggers', 'auto' }) do
                local list = cas[key]
                if type(list) == 'table' then
                    local keep = {}
                    for _, idx in ipairs(list) do
                        if (tonumber(idx) or 0) <= n then keep[#keep + 1] = idx
                        else dropped = dropped + 1 end
                    end
                    cas[key] = keep
                end
            end
        end
        if W.phaseWeights and W.phaseWeights.base then
            W.phaseWeights.base.units = #W.baseSlots
        end
        print(('^1[wf][RELEASE BLOCKER]^7 Phase 1 concrete TEST OVERRIDE: pours %d→%d'
            .. ' (%d cascade indices dropped, units synced) — set TOWER_TEST_BASE_LIMIT = 0 before release.')
            :format(full, #W.baseSlots, dropped))
    end
end

do
    local W = Config.WaterFacilityJob
    local n = tonumber(W.TOWER_TEST_WALL_LIMIT) or 0
    if n > 0 then
        local fullS = #(W.stonewallSlots or {})
        local fullP = #(W.stonewallPileLayout or {})
        for i = fullS, n + 1, -1 do W.stonewallSlots[i] = nil end
        for i = fullP, n + 1, -1 do W.stonewallPileLayout[i] = nil end
        local T = Config.WFTowerJob1 and Config.WFTowerJob1.slots
        local fullT = T and #T or 0
        if T then
            for i = fullT, n + 1, -1 do T[i] = nil end
        end
        if W.phaseWeights and W.phaseWeights.stonewall then
            W.phaseWeights.stonewall.units = #W.stonewallSlots
        end
        print(('^1[wf][RELEASE BLOCKER]^7 wall TEST OVERRIDE: slots %d→%d, pile %d→%d, tower slots %d→%d'
            .. ' — set TOWER_TEST_WALL_LIMIT = 0 before release.')
            :format(fullS, #W.stonewallSlots, fullP, #W.stonewallPileLayout, fullT, T and #T or 0))
    end
    if W.testSoloStonewall == true and W.testStartAtStonewall == true then
        W.minPlayers = 1
        W.crewProfiles[1] = { vehicles = { winch = 1 } }
        print('^1[wf][RELEASE BLOCKER]^7 testSoloStonewall=true — minPlayers 2→1 + crewProfiles[1]'
            .. ' (winch=1) ADDED (SOLO wall test). Set it back to false before release.')
    elseif W.testSoloStonewall == true then
        print('^3[wf][CONFIG]^7 testSoloStonewall=true but testStartAtStonewall=false —'
            .. ' the solo gate did NOT OPEN (the concrete phase cannot be played by one person).')
    end
end
