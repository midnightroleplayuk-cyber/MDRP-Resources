Config = {}

-- Add as many zones as you need.
--
-- type = "sphere":
--   coords = vec3(x, y, z)
--   radius = number
--
-- type = "box":
--   coords = vec3(x, y, z)
--   size = vec3(width, length, height)
--   heading = degrees
--
-- For a multi-level MLO, sphere is usually easiest. The Z check for spheres is
-- deliberately ignored so the zone also catches peds just above/below you.
Config.Zones = {
    {
        name = "Estate_Pub",
        type = "sphere",
        coords = vector3(1528.29, 3533.25, 35.75), -- Estate Pub
        radius = 25.0,

        -- Optional: prevent ambient vehicle spawning in the same zone.
        blockVehicles = false,
    },

        {
        name = "Rental Estate",
        type = "box",
        coords = vector3(1597.38, 3527.35, 35.98), -- Estate Rental
        size = vector3(10.0, 10.0, 10.0),
        heading = 0.0,
        radius = 10.0,

        -- Optional: prevent ambient vehicle spawning in the same zone.
        blockVehicles = true,
    },
    -- Example box:
    -- {
    --     name = "second_area",
    --     type = "box",
    --     coords = vec3(100.0, 200.0, 30.0),
    --     size = vec3(40.0, 30.0, 15.0),
    --     heading = 0.0,
    --     blockVehicles = false,
    -- },
}

Config.Settings = {
    -- Stops GTA ambient population from generating normal peds while
    -- the local player is inside a zone.
    blockAmbientPeds = true,

    -- Stops scenario/ambient activity peds (bar/bench/etc.) while inside.
    blockScenarioPeds = true,

    -- Removes already-existing ambient peds found inside the zone.
    -- Mission peds and player peds are never removed.
    removeExistingPeds = true,

    -- How often the existing-ped cleanup runs while inside a zone.
    cleanupInterval = 1500,

    -- Also set vehicle density to zero in zones with blockVehicles=true.
    blockAmbientVehicles = true,

    -- Debug zone drawing.
    debug = false,

    -- Commands are client-side and available to everyone.
    debugCommand = "pedblockdebug",

    -- If a scripted NPC is accidentally removed, put its model name here.
    -- Example: "s_m_m_bouncer_01"
    protectedModels = {
        -- "s_m_m_bouncer_01",
    },
}
