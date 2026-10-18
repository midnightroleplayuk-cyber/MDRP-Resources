--[[
  Drug Lab Raid — edit locations / IPL / process stations below.
  Tip: point `entrance` at a default map interior door (meth/coke lockup, etc.).
]]
---@type Job
return {
    level = 4,
    label = locale('drug_lab_raid.label'),
    description = locale('drug_lab_raid.description'),
    image = 'drug_lab_raid.png',
    reward = { exp = 260, money = 24000 },
    cooldown = { enabled = true, minutes = 25 },
    information = locale('drug_lab_raid.information'),
    teamSize = { min = 1, max = 4 },
    -- Minimum police-job players online required to start (0 = no minimum).
    requiredMinCopCount = 0,
    steps = {
        { label = locale('drug_lab_raid.steps.1'), timeLimit = 600 },
        { label = locale('drug_lab_raid.steps.2'), timeLimit = 600, progress = { target = 4 } },
        { label = locale('drug_lab_raid.steps.3'), timeLimit = 600, progress = { target = 4 } },
        { label = locale('drug_lab_raid.steps.4'), timeLimit = 180 },
        { label = locale('drug_lab_raid.steps.5'), timeLimit = 180 },
        { label = locale('drug_lab_raid.steps.6'), timeLimit = 600 },
    },
    blips = {
        lab = { sprite = 499, color = 2, text = locale('drug_lab_raid.blips.lab') },
        process = { sprite = 499, color = 5, text = locale('drug_lab_raid.blips.process') },
        yield = { sprite = 478, color = 2, text = locale('drug_lab_raid.blips.yield') },
        turnin = { sprite = 501, color = 2, text = locale('drug_lab_raid.blips.turnin') },
    },
    game = {
        --[[ EDITABLE LOCATIONS ]]
        labs = {
            {
                -- Exterior / approach point (waypoint on job start)
                entrance = vector4(1391.85, 3606.35, 38.94, 200.0), -- TODO: set your lab door
                -- Optional default IPL name (nil = no RequestIpl)
                ipl = nil, -- e.g. 'bkr_biker_interior_placement_interior_2_biker_dlc_int_ware01_milo'
                -- Ordered processing stations (step 3). Complete in order.
                process_stations = {
                    {
                        id = 'mix',
                        coords = vec4(1389.13, 3605.34, 38.94, 284.6),
                        label = locale('drug_lab_raid.process.mix'),
                        duration = 9000,
                        marker = { type = 20, r = 80, g = 200, b = 80, a = 160, scale = 0.45 },
                        anim = {
                            dict = 'anim@amb@business@coc@coc_unpack_cut@',
                            clip = 'fullcut_cycle_v1_cokecutter',
                            flag = 1,
                        },
                    },
                    {
                        id = 'cook',
                        coords = vec4(1391.77, 3605.91, 38.94, 111.06),
                        label = locale('drug_lab_raid.process.cook'),
                        duration = 14000,
                        marker = { type = 20, r = 255, g = 160, b = 40, a = 170, scale = 0.45 },
                        anim = {
                            dict = 'anim@amb@business@meth@meth_monitoring_cooking@cooking@',
                            clip = 'chemical_pour_short_cooker',
                            flag = 1,
                        },
                    },
                    {
                        id = 'cool',
                        coords = vec4(1394.38, 3601.68, 38.94, 202.11),
                        label = locale('drug_lab_raid.process.cool'),
                        duration = 8000,
                        marker = { type = 20, r = 60, g = 170, b = 255, a = 160, scale = 0.45 },
                        anim = {
                            dict = 'mini@repair',
                            clip = 'fixing_a_ped',
                            flag = 1,
                        },
                    },
                    {
                        id = 'bag',
                        coords = vec4(1390.01, 3608.86, 38.94, 23.72),
                        label = locale('drug_lab_raid.process.bag'),
                        duration = 8000,
                        marker = { type = 20, r = 200, g = 80, b = 255, a = 160, scale = 0.45 },
                        anim = {
                            dict = 'anim@amb@business@coc@coc_unpack_cut@',
                            clip = 'fullcut_cycle_v1_cokepacker',
                            flag = 1,
                        },
                    },
                },
                -- Legacy aliases (first cook / last bag fallbacks)
                cook_station = vector4(1389.72, 3602.88, 38.94, 110.0),
                -- Where packaged yield is collected after processing (table + baggies spawn here)
                yield_pickup = vec4(1399.02, 3603.03, 38.94, 197.95),
                -- Table the baggies sit on (placed at yield_pickup)
                yield_table = {
                    prop = 'bkr_prop_weed_table_01b',
                    -- z offset from yield_pickup so the table sits on the floor
                    z_offset = -1.0,
                },
                -- Packaged baggies laid out on the table (picked up during collect)
                yield_bags = {
                    prop = 'bkr_prop_weed_bag_01a',
                    offsets = {
                        vector3( 0.18,  0.12, 0.92),
                        vector3(-0.12,  0.18, 0.92),
                        vector3( 0.05, -0.10, 0.92),
                        vector3(-0.20, -0.05, 0.92),
                        vector3( 0.22, -0.18, 0.92),
                    },
                },
                -- Player pickup anim + hand baggy while collecting
                yield_pickup_anim = {
                    dict = 'pickup_object',
                    clip = 'pickup_low',
                    flag = 1,
                    duration = 4500,
                    hand_prop = 'bkr_prop_weed_bag_01a',
                },
                -- Escape radius center (leave this area before timer ends)
                escape_center = vector3(1391.85, 3606.35, 38.94),
                escape_radius = 80.0,
                -- Guard spawn points around / inside lab
                guard_spawns = {
                    vector4(1388.12, 3609.88, 38.94, 200.0),
                    vector4(1395.44, 3608.22, 38.94, 90.0),
                    vector4(1390.22, 3601.12, 38.94, 0.0),
                    vector4(1396.88, 3604.55, 38.94, 270.0),
                },
                -- Response wave spawn (rivals / PD) after yield grab
                response_spawns = {
                    vector4(1375.12, 3618.44, 34.89, 200.0),
                    vector4(1405.88, 3595.22, 34.89, 40.0),
                },
            },
        },
        -- Turn-in / buyer locations (pick one at random)
        turnins = {
            vector4(2434.12, 4968.44, 42.35, 45.0),
            vector4(721.88, -2016.42, 29.29, 90.0),
        },
        --[[ GAMEPLAY TUNING ]]
        guard_model = 'g_m_y_mexgoon_01',
        guard_weapon = `WEAPON_MICROSMG`,
        response_model = 'g_m_y_ballaorig_01',
        response_weapon = `WEAPON_PISTOL`,
        -- Fallback if a station omits duration
        cook_duration_ms = 12000,
        escape_window_ms = 90000,
        yield_item = 'weed', -- TODO: swap to your lab product item
        yield_count = 8,
        police_alert_chance = 0.45,
    },
}
