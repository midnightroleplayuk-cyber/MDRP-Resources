Config = Config or {}

-- ──────────────────────────────────────────────────────────────────────────────
-- Mechanic quick menu (F6)
-- ──────────────────────────────────────────────────────────────────────────────
Config.MechanicMenu = {
    enabled = true,
    keybind = 'F6',
    requireJob = true,

    quickActions = {
        enabled = true,
        scanDistance = 6.0,

        registerUsables = true,
        usableRequiresJob = true,

        actions = {
            repair_engine = {
                enabled = true,
                label = 'Repair Engine',
                description = 'Needs engine_kit - approach bay, skill check, repair',
                icon = 'fa-solid fa-gears',
                repair = 'engine',
                point = 'engine',
                preset = 'repair_engine',
                minigame = 'engine',
                requireItem = true,
                item = 'engine_kit',
                removeOnUse = true,
            },
            repair_body = {
                enabled = true,
                label = 'Repair Body',
                description = 'Needs body_kit - approach side, skill check, repair',
                icon = 'fa-solid fa-car-burst',
                repair = 'body',
                point = 'left_side',
                preset = 'repair_body',
                minigame = 'bolts',
                requireItem = true,
                item = 'body_kit',
                removeOnUse = true,
            },
            clean_vehicle = {
                enabled = true,
                label = 'Clean Vehicle',
                description = 'Needs cleaning_kit - approach side and wipe down',
                icon = 'fa-solid fa-soap',
                repair = 'wash',
                point = 'left_side',
                preset = 'wash_car',
                minigame = '',
                requireItem = true,
                item = 'cleaning_kit',
                removeOnUse = true,
            },
        },
    },
}
