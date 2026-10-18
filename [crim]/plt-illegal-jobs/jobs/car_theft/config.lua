

---[[
--- All accepted values are specified in `shared/types/__job.lua`.
---]]

---@type Job
return {
    -- Minimum required level to start the job
    level = 3,

    -- Job title displayed in the UI
    label = locale('car_theft.label'),

    -- Short mission description
    description = locale('car_theft.description'),

    -- UI image for the mission
    image = 'car_theft.png',

    -- Rewards for completing the mission
    reward = {
        exp = 100,    -- Experience points given
        money = 20000 -- Money
    },

    -- Restart cooldown applied per player when the job finishes or is manually stopped.
    cooldown = { enabled = true, minutes = 12 },

    -- Minimum police-job players online required to start (0 = no minimum).
    requiredMinCopCount = 0,

    -- Additional info or lore for the mission
    information = locale('car_theft.information'),

    -- Step-by-step instructions for the mission
    steps = {
        { label = locale('car_theft.steps.1'), timeLimit = 900, },
        { label = locale('car_theft.steps.2'), timeLimit = 900, progress = { target = 5 }, },
        { label = locale('car_theft.steps.3'), timeLimit = 900, progress = { current = 0 }, },
        { label = locale('car_theft.steps.4'), timeLimit = 900, progress = { current = 0 }, },
    },

    -- Required item(s) to do the mission
    requiredItems = {
        ['lockpick'] = { itemName = 'lockpick', label = 'Lockpick' }, -- Player must have a lockpick
    },

    -- Blips
    blips = {
        area = { sprite = 270, color = 5, text = locale('car_theft.blips.area') }
    },

    --[[ Game mechanics and settings ]]
    game = {
        -- Chance that a police alert is triggered when smashing a window (5%)
        police_alert_chance = .05,

        areas = {
            [1] = {
                center = vector3(2133.2437, 4785.0933, 40.9703),
                distance = 50.0,
                vehicle_blip = { sprite = 225, color = 1, text = 'Vehicle' },
                vehicle_positions = {
                    vector4(2141.99, 4782.83, 40.33, 48.50),
                    vector4(2137.54, 4780.03, 40.33, 37.47),
                    vector4(2135.17, 4775.70, 40.33, 7.20),
                    vector4(2131.20, 4775.78, 40.33, 5.75),
                },
                enemy_positions = {
                    vector4(2131.41, 4785.00, 40.97, 13.43),
                    vector4(2130.62, 4779.67, 40.97, 8.0),
                    vector4(2138.62, 4784.83, 40.97, 50.0),
                    vector4(2135.59, 4787.72, 40.97, 45.35),
                    vector4(2129.40, 4787.81, 40.97, 6.22),
                },

                delivery_point = vector4(1565.26, -2140.47, 76.6312, 60.80),
            },
            [2] = {
                center = vector3(1521.9860, 1718.2043, 110.0154),
                distance = 75.0,
                vehicle_blip = { sprite = 225, color = 1, text = 'Vehicle' },
                vehicle_positions = {
                    vector4(1534.51, 1705.22, 109.32, 81.10),
                    vector4(1527.86, 1701.50, 109.42, 263.20),
                    vector4(1531.41, 1711.70, 109.50, 40.62),
                    vector4(1523.24, 1718.10, 109.55, 3.55),
                },
                enemy_positions = {
                    vector4(1522.7635, 1713.8802, 109.0052, 90.5807),
                    vector4(1529.3754, 1705.5795, 108.7941, 89.2235),
                    vector4(1532.3289, 1701.2355, 108.7566, 82.1561),
                    vector4(1527.6899, 1720.3250, 108.9391, 58.3821),
                    vector4(1536.2617, 1709.1343, 108.8185, 46.4121),
                },

                delivery_point = vector4(598.6751, -430.8378, 23.7449, 285.0192),
            },
        },

        -- Vehicle models that can be stolen (also used by mission queue)
        vehicle_models = {
            'blista', 'futo', 'prairie', 'sultan', 'kuruma', 'buffalo',
            'elegy2', 'jester', 'comet2', 'feltzer2', 'schafter3',
            'cheetah', 't20', 'emerus',
        },
        -- One-at-a-time contract queue (tablet)
        queue = {
            vehicle_pool = {
                'blista', 'futo', 'prairie', 'sultan', 'kuruma', 'buffalo',
                'elegy2', 'jester', 'comet2', 'schafter3', 'feltzer2',
            },
            classes = { 'D', 'C', 'B', 'A' },
            area_labels = { 'Davis', 'La Mesa', 'Vinewood', 'Del Perro', 'Sandy Shores', 'Mirror Park' },
            payout_min = 8000,
            payout_max = 22000,
            mission_cooldown_seconds = 180,
            decline_cooldown_seconds = 45,
            offer_ttl_seconds = 900,
            tracker_chance = 0.4,
        },
    },
    -- Briefing disabled: fixed contact coords fought random area selection and
    -- made the job look like it "did nothing" after start. Objectives begin immediately.
}

