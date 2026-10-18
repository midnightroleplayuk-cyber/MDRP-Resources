
---@type Job
return {
    level = 2,
    label = locale('atm_drilling.label'),
    description = locale('atm_drilling.description'),
    image = 'atm_drilling.png',
    -- toolLoot: low-chance trickle of the drill/atm_hack_device the hacking
    -- tree hands out as a guaranteed kit at the hack_decrypt skill node.
    reward = { exp = 140, money = 9000, toolLoot = {
        { itemName = 'drill', chance = 0.06, min = 1, max = 1 },
    } },
    -- Restart cooldown applied per player when the job finishes or is manually stopped.
    cooldown = { enabled = true, minutes = 10 },
    information = locale('atm_drilling.information'),
    teamSize = { min = 1, max = 2 },
    -- Minimum police-job players online required to start (0 = no minimum).
    requiredMinCopCount = 0,
    steps = {
        { label = locale('atm_drilling.steps.1'), timeLimit = 1200, progress = { target = 1 } },
        { label = locale('atm_drilling.steps.2'), timeLimit = 120 },
    },
    blips = {
        atm = { sprite = 500, color = 2, text = locale('atm_drilling.blips.atm') },
    },
    game = {
        --[[ EDITABLE LOCATIONS — add as many ATMs as you want; route picks N in order/shuffle ]]
        atms = {
            vector4(147.42, -1035.88, 29.34, 160.0),  -- TODO: Legion Square
            vector4(-254.22, -692.44, 33.60, 160.0),  -- TODO
            vector4(-301.88, -830.12, 32.42, 350.0),  -- TODO
            vector4(112.64, -776.22, 31.44, 340.0),   -- TODO
            vector4(289.12, -1256.88, 29.44, 90.0),    -- TODO
            vector4(-1205.12, -324.88, 37.86, 30.0),  -- TODO
            vector4(-2072.44, -317.22, 13.32, 260.0), -- TODO
        },
        -- Hand drill prop attached while drilling (nil = default hei_prop_heist_drill)
        hand_drill_prop = 'hei_prop_heist_drill',
        -- Fleeca drill anim is authored for PH_R_Hand (28422). Offsets tuned so bit seats on ATM face.
        drill_attach = {
            bone = 28422,
            x = 0.0, y = 0.0, z = 0.0,
            rx = 0.0, ry = 0.0, rz = 0.0,
        },
        -- Stand this far in front of the ATM (meters) before drilling
        drill_stand_distance = 0.72,
        -- Rope pull: hitch the real wall ATM; freestanding prop only spawns after a successful haul
        rope_atm_prop = 'prop_fleeca_atm',
        rope_vehicle_distance = 25.0,
        rope = {
            drag_force = 0.10,          -- light drag so the car keeps rolling
            required_distance = 4.0,    -- short haul to rip it free
            max_rope_length = 36.0,     -- generous stretch before snap
            taut_rope_length = 3.0,     -- rope counts as taut past this
            min_speed = 2.0,            -- ~7 km/h is enough
            max_wait_ms = 180000,
        },
        --[[ TUNING ]]
        route_count = 1,
        shuffle_route = true,
        payout_min = 800,
        payout_max = 1800,
        -- Police alert chance grows each successful hit: base + (index-1)*step
        police_alert_base = 0.10,
        police_alert_step = 0.18,
        partial_pay = true, -- bank cash per ATM even if you bail early
        -- Default when UI does not pass method
        default_method = 'drill',
    },
    -- Opening contact VO beat (optional; omit to skip)
    briefing = {
        pedModel = `s_m_y_dealer_01`,
        coords   = vec4(146.2, -1058.69, 30.19, 158.63),
        blip     = { sprite = 280, color = 5, text = 'Contact' },
        label    = 'Talk to your contact',
        audio    = 'atm_drilling.mp3',
        line     = 'Fast hands, faster feet — the vault won\'t wait for sirens.',
    },
}
