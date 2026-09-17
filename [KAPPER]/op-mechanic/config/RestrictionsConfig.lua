Config = Config or {}

-- ──────────────────────────────────────────────────────────────────────────────
-- Tuning restrictions
-- ──────────────────────────────────────────────────────────────────────────────
Config.Restrictions = {
    -- GTA vehicle class ids blocked from opening tuning
    blockedClasses = {
        -- 0,  -- Compacts
        -- 1,  -- Sedans
        -- 2,  -- SUVs
        -- 3,  -- Coupes
        -- 4,  -- Muscle
        -- 5,  -- Sports Classics
        -- 6,  -- Sports
        -- 7,  -- Super
        -- 8,  -- Motorcycles
        -- 9,  -- Off-road
        -- 10, -- Industrial
        -- 11, -- Utility
        -- 12, -- Vans
        -- 13, -- Cycles
        -- 14, -- Boats
        -- 15, -- Helicopters
        -- 16, -- Planes
        -- 17, -- Service
        -- 18, -- Emergency
        -- 19, -- Military
        -- 20, -- Commercial
        -- 21, -- Trains
    },

    -- Spawn / display names (lowercase) fully blocked from tuning
    blacklistModels = {
        -- 'rhino',
        -- 'khanjali',
        -- 'apc',
        -- 'oppressor',
        -- 'oppressor2',
        -- 'deluxo',
        -- 'scrap',
        -- 'bus',
        -- 'police',
        -- 'police2',
        -- 'ambulance',
        -- 'firetruk',
    },

    -- Empty = all allowed (minus blacklist). Non-empty = only these models.
    whitelistModels = {
        -- 'sultan',
        -- 'sultanrs',
        -- 'elegy',
        -- 'elegy2',
        -- 'comet2',
        -- 'adder',
    },

    -- Global option ids hidden from the tuning menu
    -- Stance: stance.height | stance.camber | stance.offset | stance.width | stance.size
    disabledOptions = {
        -- 'stance.size',
        -- 'stance.width',
        -- 'stance.offset',
        -- 'stance.camber',
        -- 'stance.height',
        -- 'wheels.bulletproof',
        -- 'wheels.customTires',
        -- 'wheels.tireSmoke',
        -- 'performance.armor',
        -- 'performance.turbo',
        -- 'nitro.kit',
        -- 'rgb.controller',
        -- 'tuning.antilag',
        -- 'extras.hydraulics',
        -- 'repair.full',
    },

    -- Per-model option blacklist (spawn / display name lowercase)
    modelOptionBlacklist = {
        -- adder = { 'body.spoiler', 'performance.armor' },
        -- panto = { 'tuning.engine', 'tuning.drivetrain', 'nitro.kit' },
        -- police = { 'paint.primary.color', 'paint.secondary.color', 'lights.xenon' },
        -- bus = { 'stance.height', 'wheels.model' },
    },
}