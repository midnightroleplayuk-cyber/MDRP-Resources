Config = Config or {}

-- ──────────────────────────────────────────────────────────────────────────────
-- Car wax (slows dirt buildup)
-- ──────────────────────────────────────────────────────────────────────────────
Config.Wax = {
    enabled = true,

    item = 'car_wax',
    durationMinutes = 45,
    dirtRate = 0.25,
    cleanOnApply = true,
    refreshExtends = true,

    maxDistance = 4.0,
    applyDurationMs = 5500,

    tickMs = 750,
}