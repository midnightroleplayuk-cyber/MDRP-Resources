Config = Config or {}

-- ──────────────────────────────────────────────────────────────────────────────
-- NOS / nitro boost
-- ──────────────────────────────────────────────────────────────────────────────
Config.Nitro = {
    enabled = true,
    screenEffects = true,
    boostStartFx = true,
    boostStartShake = 0.35,
    boostStartFlashMs = 1100,
    boostBlurWhileActive = true,
    boostBlurStrength = 0.40,

    rearLightTrails = true,
    lightTrails = true,
    lightTrailScale = 1.5,

    exhaustFlames = true,
    flameScale = 1.30,

    powerMult = 1.95,
    powerAddScale = 26.0,
    boostThrottle = true,
    boostThrottleAmount = 0.75,
    maxBoostSpeedKmh = 215, -- 0 = off
    explodeBoostSec = 15, -- 0 = off

    boostKey = 'RMENU',
    purgeKey = 'LSHIFT',
    boostControls = { 19 },
    purgeControls = { 21 },

    blockCommand = 'blocknitro',
    blockKey = '',
    blockPurgeToo = true,

    maxBottles = 3,
    bottleDurationSec = 10,
    bottleCooldownSec = 5,
    showHud = true,
    purgeDrainRate = 0.1,
    purgeParticle = 'ent_amb_steam',
    purgeScale = 0.7,

    syncRadius = 80.0,

    sounds = {
        enabled = true,
        boost = {
            name = 'Flight_Loop',
            set = 'DLC_Exec_Air_Drops_Sounds',
        },
        purge = {
            name = 'Spray',
            set = 'FBI_05_SOUNDS',
        },
    },

    refillDistance = 3.2,
    refillDurationMs = 4500,

    requireInstallItem = false,
    kitItem = 'nitrous_install_kit',
    kitUnlockDurationMs = 4500,
    bottleItem = 'nitrous_bottle',
    emptyBottleItem = 'empty_nitrous_bottle',

    bottleMinigame = true,
}