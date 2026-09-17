Config = Config or {}

-- ──────────────────────────────────────────────────────────────────────────────
-- RGB neon controller
-- ──────────────────────────────────────────────────────────────────────────────
Config.Rgb = {
    enabled = true,

    item = 'rgb_controller',
    command = 'rgb',
    driverOnly = true,
    maxDistance = 4.0,

    defaultMode = 'solid',

    speed = { min = 1, max = 10, default = 5 },
    fadeCycleMs = { slow = 14000, fast = 1400 },
    flashPeriodMs = { slow = 1400, fast = 160 },
    dualPeriodMs = { slow = 1600, fast = 180 },
    blendCycleMs = { slow = 8000, fast = 700 },

    tickMs = 50,
    renderDistance = 70.0,
    runWhenEmpty = true,

    defaultColor = { r = 0, g = 130, b = 255 },
    defaultColor2 = { r = 255, g = 28, b = 72 },
}