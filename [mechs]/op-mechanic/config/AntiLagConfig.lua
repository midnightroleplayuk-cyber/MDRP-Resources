Config = Config or {}

-- ──────────────────────────────────────────────────────────────────────────────
-- Exhaust anti-lag / two-step
-- ──────────────────────────────────────────────────────────────────────────────
Config.AntiLag = {
    enabled = true,

    requireInstallItem = false, -- item unlocks tuning install
    kitItem = 'antilag_install_kit',
    kitUnlockDurationMs = 4500,

    muteCommand = 'antilag', -- client mute while driving

    defaults = {
        style = 'combo',
        chance = 65,
        size = 'stock',
        color = 'stock',
        sound = 'stock',
    },

    --- Flame styles (tuning menu)
    styles = {
        {
            id = 'backfire',
            native = false,
            ptfx = { dict = 'core', name = 'veh_backfire' },
            scale = 1.25,
            holdMs = { 0, 0 },
        },
        {
            id = 'nitro',
            native = true,
            ptfx = nil,
            scale = 1.0,
            holdMs = { 25, 350 },
        },
        {
            id = 'combo',
            native = false,
            ptfx = { dict = 'core', name = 'veh_backfire' },
            scale = 1.35,
            colorScaleMult = 1.0,
            backfireScaleMult = 0.52,
            holdMs = { 55, 140 },
        },
        {
            id = 'torch',
            native = false,
            loop = true,
            ptfx = { dict = 'veh_xs_vehicle_mods', name = 'veh_nitrous' },
            scale = 1.1,
            holdMs = { 220, 650 },
        },
    },

    sizes = {
        { id = 'small', scale = 0.70, hold = 0.70 },
        { id = 'stock', scale = 1.00, hold = 1.00 },
        { id = 'big', scale = 1.55, hold = 1.35 },
        { id = 'huge', scale = 2.20, hold = 1.80 },
    },

    --- Custom colors use stream/ ptfx assets (stock = orange vanilla)
    colors = {
        { id = 'stock', rgb = nil, swatch = '#ff7a1f' },
        { id = 'red', rgb = { 255, 18, 8 }, ptfx = { dict = 'opmechanic_flame_red', name = 'veh_nitrous' } },
        { id = 'orange', rgb = { 255, 105, 20 }, ptfx = { dict = 'opmechanic_flame_yellowred', name = 'veh_nitrous' } },
        { id = 'yellow', rgb = { 255, 205, 8 }, ptfx = { dict = 'opmechanic_flame_yellow', name = 'veh_nitrous' } },
        { id = 'green', rgb = { 9, 255, 15 }, ptfx = { dict = 'opmechanic_flame_green', name = 'veh_nitrous' } },
        { id = 'blue', rgb = { 10, 122, 255 }, ptfx = { dict = 'opmechanic_flame_blue', name = 'veh_nitrous' } },
        { id = 'navy', rgb = { 4, 34, 190 }, ptfx = { dict = 'opmechanic_flame_navy', name = 'veh_nitrous' } },
        { id = 'purple', rgb = { 174, 28, 255 }, ptfx = { dict = 'opmechanic_flame_purple', name = 'veh_nitrous' } },
        { id = 'white', rgb = { 255, 255, 255 }, ptfx = { dict = 'opmechanic_flame_white', name = 'veh_nitrous' } },
    },

    colorFlame = {
        minHoldMs = 90,
        replaceNativeFlame = false,
    },

    hideColorsWithoutPtfx = false,

    colorLayer = {
        enabled = true,
        light = {
            enabled = true,
            range = 3.2,
            intensity = 3.0,
            fadeMs = 180,
        },
        ptfx = false,
        scale = 0.22,
    },

    chance = {
        min = 0,
        max = 100,
        step = 5,
        default = 65,
    },

    behaviour = {
        minRpm = 0.45,
        minSpeedKmh = 25.0,
        throttleRelease = 0.15,
        minThrottleHoldMs = 320,
        minThrottleDepth = 0.42,
        minEngineHealth = 300.0,
        downshiftRequiresGearDrop = true,

        burstCount = { 1, 5 },
        pulseMs = { 150, 80 },
        cooldownMs = { 1200, 420 },

        downshift = {
            enabled = true,
            rpmOffset = -0.06,
            burstCount = { 1, 3 },
            pulseMs = { 130, 70 },
            cooldownMs = { 900, 240 },
            rpmSpike = 0.10,
        },

        coast = {
            enabled = true,
            minRpm = 0.55,
            minIntervalMs = { 800, 260 },
            maxIntervalMs = { 1400, 520 },
            chanceScale = 0.6,
        },

        twoStep = {
            enabled = true,
            requireHandbrake = true,
            maxSpeedKmh = 8.0,
            minThrottle = 0.40,
            minRpm = 0.42,
            burstCount = { 1, 3 },
            pulseMs = { 120, 55 },
            cooldownMs = { 220, 90 },
        },
    },

    sounds = {
        enabled = true,
        default = 'stock',
        presets = {
            {
                id = 'stock',
                native = {
                    'tuner_muscle01_exhaust_pops',
                    'zr350_exhaust_pops',
                    'calico_exhaust_pops',
                    'comet6_exhaust_pops',
                    'cypher_exhaust_pops',
                    'dominator7_exhaust_pops',
                    'futo2_exhaust_pops',
                    'jester4_exhaust_pops',
                    'remus_exhaust_pops',
                    'rt3000_exhaust_pops',
                    'tailgater2_exhaust_pops',
                    'vectre_exhaust_pops',
                    'warrener2_exhaust_pops',
                },
            },
            -- Type 61 sounds great outdoors but Rockstar mutes it in tunnels /
            -- underpasses. tunnelExplosionType is used when enclosed (default 2).
            { id = 'bang', explosionType = 61, tunnelExplosionType = 2 },
        },
        calmNpcs = true,
        calmRadius = 28.0,
        calmHoldMs = 2200,
    },

    sync = {
        enabled = true,
        radius = 140.0,
        minIntervalMs = 70,
    },

    blacklist = {
        -- 'police',
    },
}