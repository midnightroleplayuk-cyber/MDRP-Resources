-- ====================================================================
-- REGION 7 -- Water Facility 2 (underground pipes)
-- ====================================================================
-- 18 pipes across three trenches, no stage order: all of them are open from the start.
-- Each trench uses one straight slope: per-point terrain following would break the joints.
-- ====================================================================

Config.WaterFacility2Job = {}

Config.WaterFacility2Job.zoneId = 'buildermainzone'

Config.WaterFacility2Job.crewProfiles = {
    [1] = { vehicles = { winch = 1 } },
    [2] = { vehicles = { winch = 2 } },
    [3] = { vehicles = { winch = 3 } },
    [4] = { vehicles = { winch = 4 } },
}
Config.WaterFacility2Job.rentAllowed = { 'winch' }

Config.WaterFacility2Job.minPlayers = 1
Config.WaterFacility2Job.maxPlayers = 4

Config.WaterFacility2Job.pipeModel = 'tworst_buildstonepipe'

Config.WaterFacility2Job.slots = {
    { coords = vec3(1028.573, 2238.333, 43.092), rot = vec3(0.0, 0.0, 0.0) },
    { coords = vec3(1028.573, 2244.187, 43.135), rot = vec3(0.0, 0.0, 0.0) },
    { coords = vec3(1028.573, 2250.026, 43.179), rot = vec3(0.0, 0.0, 0.0) },
    { coords = vec3(1028.573, 2255.882, 43.223), rot = vec3(0.0, 0.0, 0.0) },
    { coords = vec3(1028.573, 2261.717, 43.267), rot = vec3(0.0, 0.0, 0.0) },
    { coords = vec3(1028.573, 2267.564, 43.311), rot = vec3(0.0, 0.0, 0.0) },
    { coords = vec3(1058.915, 2238.333, 42.947), rot = vec3(0.0, 0.0, 0.0) },
    { coords = vec3(1058.915, 2244.187, 42.992), rot = vec3(0.0, 0.0, 0.0) },
    { coords = vec3(1058.915, 2250.026, 43.036), rot = vec3(0.0, 0.0, 0.0) },
    { coords = vec3(1058.915, 2255.882, 43.081), rot = vec3(0.0, 0.0, 0.0) },
    { coords = vec3(1058.915, 2261.717, 43.125), rot = vec3(0.0, 0.0, 0.0) },
    { coords = vec3(1058.915, 2267.564, 43.169), rot = vec3(0.0, 0.0, 0.0) },
    { coords = vec3(1078.774, 2238.333, 43.769), rot = vec3(0.0, 0.0, 0.0) },
    { coords = vec3(1078.774, 2244.187, 43.640), rot = vec3(0.0, 0.0, 0.0) },
    { coords = vec3(1078.774, 2250.026, 43.512), rot = vec3(0.0, 0.0, 0.0) },
    { coords = vec3(1078.774, 2255.882, 43.383), rot = vec3(0.0, 0.0, 0.0) },
    { coords = vec3(1078.774, 2261.717, 43.255), rot = vec3(0.0, 0.0, 0.0) },
    { coords = vec3(1078.774, 2267.564, 43.127), rot = vec3(0.0, 0.0, 0.0) },
}

Config.WaterFacility2Job.vehicleSpawn = {
    coords  = vec3(992.66, 2254.77, 48.49),
    heading = 61.51,
}

Config.WaterFacility2Job.pipePileLayout = {
    { coords = vec3(1024.573, 2249.000, 45.123), rot = vec3(0.0, 0.0, 0.0) },
    { coords = vec3(1024.573, 2256.000, 45.094), rot = vec3(0.0, 0.0, 0.0) },
    { coords = vec3(1024.573, 2263.000, 45.011), rot = vec3(0.0, 0.0, 0.0) },
    { coords = vec3(1032.573, 2249.000, 44.872), rot = vec3(0.0, 0.0, 0.0) },
    { coords = vec3(1032.573, 2256.000, 44.771), rot = vec3(0.0, 0.0, 0.0) },
    { coords = vec3(1032.573, 2263.000, 44.428), rot = vec3(0.0, 0.0, 0.0) },
    { coords = vec3(1054.915, 2249.000, 45.522), rot = vec3(0.0, 0.0, 0.0) },
    { coords = vec3(1054.915, 2256.000, 46.125), rot = vec3(0.0, 0.0, 0.0) },
    { coords = vec3(1054.915, 2263.000, 45.931), rot = vec3(0.0, 0.0, 0.0) },
    { coords = vec3(1062.915, 2249.000, 45.444), rot = vec3(0.0, 0.0, 0.0) },
    { coords = vec3(1062.915, 2256.000, 46.056), rot = vec3(0.0, 0.0, 0.0) },
    { coords = vec3(1062.915, 2263.000, 45.447), rot = vec3(0.0, 0.0, 0.0) },
    { coords = vec3(1074.774, 2249.000, 45.376), rot = vec3(0.0, 0.0, 0.0) },
    { coords = vec3(1074.774, 2256.000, 45.160), rot = vec3(0.0, 0.0, 0.0) },
    { coords = vec3(1074.774, 2263.000, 44.629), rot = vec3(0.0, 0.0, 0.0) },
    { coords = vec3(1082.774, 2249.000, 45.674), rot = vec3(0.0, 0.0, 0.0) },
    { coords = vec3(1082.774, 2256.000, 45.512), rot = vec3(0.0, 0.0, 0.0) },
    { coords = vec3(1082.774, 2263.000, 45.199), rot = vec3(0.0, 0.0, 0.0) },
}

Config.WaterFacility2Job.riggingMode = 'midline'

Config.WaterFacility2Job.grabRange            = 3.5
Config.WaterFacility2Job.placementRange       = 4.0
Config.WaterFacility2Job.placementRotSymmetry = nil

Config.WaterFacility2Job.parkedRestoreSeconds = 180

local function buildWF2FlatSlots()
    local out = {}
    for _, slot in ipairs(Config.WaterFacility2Job.slots) do
        out[#out + 1] = { coords = slot.coords, rot = slot.rot, model = Config.WaterFacility2Job.pipeModel }
    end
    return out
end

Config.WF2TowerJob1 = {
    suppressPlacedNotify = true,
    requestSyncEvent = 'wf2:requestSync',
    instanceId = 'wf2_t1',
    zoneId     = 'buildermainzone',
    model      = Config.WaterFacility2Job.pipeModel,

    sharedSitePile = true,

    slots = buildWF2FlatSlots(),

    grabRange  = Config.WaterFacility2Job.grabRange,
    placeRange = Config.WaterFacility2Job.placementRange,

    hookAttach = {
        offset = vector3(0.0, 0.0, -0.4),
        rot    = vector3(0.0, 0.0, 0.0),
    },

    placementStyle = 'simple',

    slotPlacedEvent  = 'wf2:slotPlaced',
    slotReserveEvent = 'wf2:slotReserve',
}

Config.TowerCraneJobs = Config.TowerCraneJobs or {}
