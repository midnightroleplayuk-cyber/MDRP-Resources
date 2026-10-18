
---@type Job
return {
    level = 5,
    label = locale('train_heist.label'),
    description = locale('train_heist.description'),
    image = 'train_heist.png',
    reward = { exp = 350, money = 0 }, -- payout comes from gold delivery (price * count)
    cooldown = { enabled = true, minutes = 30 },
    information = locale('train_heist.information'),
    teamSize = { min = 1, max = 4 },
    -- Minimum police-job players online required to start (0 = no minimum).
    requiredMinCopCount = 0,
    requiredItems = {
        grinder = { itemName = 'grinder', label = 'Angle Grinder' },
    },
    steps = {
        { label = locale('train_heist.steps.1'), timeLimit = 900 },
        { label = locale('train_heist.steps.2'), timeLimit = 600 },
        { label = locale('train_heist.steps.3'), timeLimit = 600, progress = { target = 2 } },
        { label = locale('train_heist.steps.4'), timeLimit = 600, progress = { target = 2 } },
        { label = locale('train_heist.steps.5'), timeLimit = 900 },
    },
    blips = {
        train = { sprite = 570, color = 1, text = locale('train_heist.blips.train') },
        deliver = { sprite = 280, color = 2, text = locale('train_heist.blips.deliver') },
    },
    game = {
        approach_distance = 400.0,
        police_alert_on_approach = true,
        require_bag = false,

        -- Clear all guards in this window or the mission train rolls on the tracks
        escape_time_ms = 120000, -- 2 minutes
        escape_speed = 15.0,     -- SetTrainCruiseSpeed (rail units, not free velocity)
        escape_enabled = true,

        train = {
            -- Spawn must be ON / near freight rails so CreateMissionTrain can snap
            position = vector3(2533.0, 2833.0, 38.0),
            direction = true,
            variation = 2, -- GTA freight consist id (0–22)
        },

        guards = {
            models = { 's_m_y_blackops_01' },
            amount = 15,
            spawn_range = 30.0,
            weapons = { 'WEAPON_PISTOL' },
            armour = 50,
            accuracy = 50,
        },

        loot = {
            item = 'gold_ingot',
            stack = 10,
            stacks = 2,
            price = 300,
            moneyAccount = nil,

            -- One of the two containers drops a cash stack instead of gold; paid out
            -- instantly as dirty money on grab (no delivery step needed for cash).
            cashModel = `ch_prop_ch_cash_trolly_01a`,
            cashMin = 8000,
            cashMax = 15000,
        },

        delivery = {
            pedModel = `s_m_m_highsec_01`,
            coords = vec4(-675.15, -2398.87, 16.12, 79.17),
        },
    },
    briefing = {
        pedModel = `s_m_m_highsec_01`,
        coords   = vec4(-675.15, -2398.87, 16.12, 79.17),
        blip     = { sprite = 280, color = 5, text = 'Contact' },
        label    = 'Talk to your contact',
        audio    = 'train_heist.mp3',
        line     = 'Freight\'s sitting cold on the inland rail — grind the boxes, take the gold, bring it back.',
    },
}
