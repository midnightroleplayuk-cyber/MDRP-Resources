---@type Job
return {
    -- Minimum required level to start the job
    level = 1,

    -- Job title displayed in the UI
    label = locale('chop_shop.label'),

    -- Short mission description
    description = locale('chop_shop.description'),

    -- UI image for the mission
    image = 'chop_shop.png',

    -- Rewards for completing the mission
    -- toolLoot: low-chance trickle of the lockpick chop_shop's own tree hands
    -- out as a guaranteed kit at the chop_strip skill node (config/progression.lua)
    reward = { exp = 120, money = 6000, toolLoot = {
        { itemName = 'lockpick', chance = 0.08, min = 1, max = 1 },
    } },

    -- Restart cooldown applied per player when the job finishes or is manually stopped.
    cooldown = { enabled = true, minutes = 15 },

    -- Minimum police-job players online required to start (0 = no minimum).
    requiredMinCopCount = 0,

    -- Additional info or lore for the mission
    information = locale('chop_shop.information'),

    -- Step-by-step instructions for the mission
    steps = {
        { label = locale('chop_shop.steps.1'), timeLimit = 600, },
        { label = locale('chop_shop.steps.2'), timeLimit = 900, },
        { label = locale('chop_shop.steps.3'), timeLimit = 900, },
        { label = locale('chop_shop.steps.4'), timeLimit = 900, },
    },

    -- No tools required at start (Digi Scanner removed from validation)
    requiredItems = {},

    -- Blips
    blips = {
        vehicle_location = { sprite = 225, color = 5, text = locale('chop_shop.blips.vehicle_location') },
        drop_off_location = { sprite = 270, color = 5, text = locale('chop_shop.blips.drop_off_location') },
    },

    --[[ Game mechanics and settings ]]
    game = {
        police_alert_chance = 0.4, -- 40% chance to alert police when stealing a vehicle

        -- Location settings where vehicles can be stolen
        locations           = {
            [1] = {
                vehicle_location = vector4(-462.2772, 641.7559, 144.1884, 47.4927),
            },
            [2] = {
                vehicle_location = vector4(-710.04, 643.80, 154.83, 170.0),
            },
        },

        -- The point where the parts will be dismantled and dropped off
        -- Should be at least as many as the number of 'locations'
        drop_off_locations  = {
            { vehicle_lock = vec3(-507.5, -1723.54, 19.32), vector3(-560.1563, -1687.4324, 19.3006), drop_off = vector3(-555.8652, -1684.7043, 19.5) },
            { vehicle_lock = vector3(-423.9329, -1686.1304, 19.0290), drop_off = vector3(-417.9132, -1685.7708, 19.5) },
            { vehicle_lock = vector3(1731.6963, 3312.0889, 41.2234),  drop_off = vector3(1741.1049, 3318.3652, 41.2234) },
            { vehicle_lock = vector3(2352.0449, 3132.6443, 48.2087),  drop_off = vector3(2350.8103, 3127.9507, 48.2087) },
        },

        -- Vehicle models that can be stolen
        vehicle_models      = {
            'blista', 'futo', 'prairie', 'sultan', 'kuruma', 'buffalo',
            'elegy2', 'schafter3', 'comet2', 'cheetah', 't20',
        },
        queue = {
            vehicle_pool = {
                'blista', 'futo', 'prairie', 'sultan', 'kuruma', 'buffalo',
                'elegy2', 'schafter3', 'comet2',
            },
            classes = { 'D', 'C', 'B', 'A' },
            area_labels = { 'Vinewood Hills', 'Rockford', 'Richman', 'Mirror Park' },
            payout_min = 4000,
            payout_max = 12000,
            mission_cooldown_seconds = 150,
            decline_cooldown_seconds = 40,
            offer_ttl_seconds = 900,
            tracker_chance = 0.25,
        },
    },
}

