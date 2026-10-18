--[[
  Yacht / Marina Smuggling — raid a guarded supply ship for rare cargo.
]]
---@type Job
return {
    level = 4,
    label = locale('marina_smuggling.label'),
    description = locale('marina_smuggling.description'),
    image = 'marina_smuggling.png',
    reward = { exp = 280, money = 26000 },
    cooldown = { enabled = true, minutes = 25 },
    information = locale('marina_smuggling.information'),
    teamSize = { min = 1, max = 2 },
    -- Minimum police-job players online required to start (0 = no minimum).
    requiredMinCopCount = 0,
    requiredItems = {
        lockpick = { itemName = 'lockpick', label = 'Lockpick' },
    },
    steps = {
        { label = locale('marina_smuggling.steps.1'), timeLimit = 600 },
        { label = locale('marina_smuggling.steps.2'), timeLimit = 300 },
        { label = locale('marina_smuggling.steps.3'), timeLimit = 900 },
        { label = locale('marina_smuggling.steps.4'), timeLimit = 480 },
        { label = locale('marina_smuggling.steps.5'), timeLimit = 900 },
        { label = locale('marina_smuggling.steps.6'), timeLimit = 600 },
    },
    blips = {
        marina = { sprite = 410, color = 3, text = locale('marina_smuggling.blips.marina') },
        ship = { sprite = 455, color = 1, text = locale('marina_smuggling.blips.ship') },
        dropoff = { sprite = 410, color = 2, text = locale('marina_smuggling.blips.dropoff') },
        crate = { sprite = 478, color = 1, text = locale('marina_smuggling.blips.crate') },
    },
    game = {
        marinas = {
            {
                boat_spawn = vec4(-805.34, -1492.75, 0.12, 113.39),
                boat_model = 'dinghy',
            },
            {
                boat_spawn = vec4(-1636.21, -1155.23, 0.4, 129.78),
                boat_model = 'speeder',
            },
        },
        -- Supply ship starts close enough to stream after lockpick
        ship_routes = {
            {
                start = vec4(-2335.7, -1835.22, 0.65, 308.87),
                ship_model = 'tug',
                waypoints = {
                    vector3(-920.0, -1540.0, 0.5),
                    vector3(-880.0, -1500.0, 0.5),
                    vector3(-840.0, -1460.0, 0.5),
                    vector3(-800.0, -1420.0, 0.5),
                },
                -- Absolute deck guard positions (vector4 x,y,z,heading) — edit these in-world
                guard_spawns = {
                    vec4(-2331.45, -1832.16, 6.09, 133.75),
                    vec4(-2329.31, -1830.97, 5.98, 328.19),
                    vec4(-2338.49, -1840.02, 6.49, 128.71),
                    vec4(-2340.11, -1835.9, 6.55, 26.12),
                    vec4(-2340.55, -1838.28, 2.87, 7.54)
                },
                -- Keep ship parked at start when using absolute guards (no coastal AI drive)
                stationary = true,
            },
            {
                start = vector4(-1680.0, -1280.0, 0.5, 130.0),
                ship_model = 'tug',
                waypoints = {
                    vector3(-1640.0, -1240.0, 0.5),
                    vector3(-1600.0, -1200.0, 0.5),
                    vector3(-1560.0, -1160.0, 0.5),
                    vector3(-1520.0, -1120.0, 0.5),
                },
                guard_spawns = {
                    -- TODO: add absolute guard vec4s for this route
                },
                stationary = false,
            },
        },
        patrol_spawns = {
            vec4(-800.14, -1500.86, -0.47, 116.03),
            vec4(-800.14, -1500.86, -0.47, 116.03),
        },
        dropoffs = {
            vec4(211.71, -2291.92, 69.17, 96.97),
        },

        -- Board / raid range (player boat or ped near the supply ship)
        board_distance = 28.0,
        ship_guard_model = 's_m_y_blackops_01',
        ship_guard_weapon = `WEAPON_ASSAULTRIFLE`,
        -- Global fallback absolute guard spawns (used when a route has no guard_spawns)
        ship_guard_spawns = {
            -- vec4(x, y, z, heading),
        },
        -- Fallback only when no absolute guard_spawns are set: offsets relative to the ship
        ship_guard_offsets = {
            vector3(0.0, 3.2, 1.35),
            vector3(1.4, 1.0, 1.35),
            vector3(-1.4, 1.0, 1.35),
            vector3(0.8, -2.0, 1.35),
            vector3(-0.8, -2.0, 1.35),
        },
        -- Weapons container attached to the supply ship deck (relative offset)
        -- Edit container_offset until it sits on your tug/ship model.
        container_prop = 'prop_ld_container', -- realistic small shipping container
        container_offset = vector3(0.0, -2.8, 0.55), -- x=right, y=forward, z=up
        container_rotation = vector3(0.0, 0.0, 90.0), -- pitch, roll, yaw relative to ship
        crate_loot_distance = 4.0,

        -- Rare haul the contact wants delivered
        -- ox_inventory: 'WEAPON_RPG' | qb-core often: 'weapon_rpg'
        loot_item = 'WEAPON_RPG',
        loot_count = 1,
        loot_label = 'RPG',

        transfer_duration_ms = 8000, -- used as loot progress fallback
        transfer_distance = 25.0,
        patrol_model = 'predator',
        patrol_ped = 's_m_y_uscg_01',
        patrol_weapon = `WEAPON_CARBINERIFLE`,
        police_alert_chance = 0.30,
    },
    -- Opening contact VO beat (optional; omit to skip)
    briefing = {
        pedModel = `a_m_y_beach_01`,
        coords   = vec4(-802.33, -1496.88, 1.6, 287.04),
        blip     = { sprite = 280, color = 5, text = 'Contact' },
        label    = 'Talk to your contact',
        audio    = 'marina_smuggling.mp3',
        line     = 'Tide\'s ours tonight — don\'t miss the window.',
    },
}
