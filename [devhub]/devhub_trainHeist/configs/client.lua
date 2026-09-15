Config = {}

Config.Debug = true

-- Called client-side (on the player who tipped off the cops) when a police alert fires.
-- Plug your own client dispatch / alarm logic in here, or handle it server side in configs/server.lua.
-- `coords` is where the player was when they alerted the police.
function TriggerAlarm(coords)
    -- TODO implement your police call logic here (client side) or go to configs/server.lua to implement it server side
end

Config.MonitorProp = 'm24_1_prop_m41_orbital_screen_01a'
Config.MonitorRenderTarget = 'prop_m41_orbital_screen_01a'

Config.SecondMonitorProp = 'prop_monitor_01b'
Config.SecondMonitorRemove = 'prop_monitor_03b'
Config.SecondMonitorRenderTarget = 'tvscreen'
Config.CodeVerifyDuration = 5 -- seconds for progress bar after code entry on second monitor
Config.CameraPullback = 0.3 -- extra meters to pull the monitor camera back from the screen (larger = farther away)

-- Depots where the heist vehicle is collected. When a heist starts one is picked at random:
-- the player gets a waypoint, the vehicle spawns once they are close, and getting in begins the heist.
-- Adjust these to real open spots on your map.
Config.VehiclePickupLocations = {
    vec4(-345.4493, -1567.4952, 25.2286, 38.1397),
    vec4(-369.9995, -1545.5543, 26.1688, 359.9827),
    vec4(938.2646, 147.6344, 80.8302, 262.3766),
    vec4(1534.4044, 785.4790, 77.4460, 61.2150),
    vec4(1517.0812, 1705.7626, 110.1069, 82.4156),
    vec4(1209.3685, 1818.8981, 78.7607, 36.3495),
    vec4(1367.7692, 2363.1655, 73.7535, 186.4191),
    vec4(832.6333, 2470.7175, 63.3802, 168.7633),
    vec4(906.0820, 3589.7568, 33.2237, 270.3399),
    vec4(882.3669, 3648.5935, 32.8750, 182.0712),
    vec4(322.4700, 3536.8171, 33.5565, 319.9845),
    vec4(214.7637, 2789.6733, 45.6507, 97.4648),
    vec4(-1152.1815, 2660.7710, 17.9442, 227.8998),
    vec4(-2323.1907, 4088.4556, 33.7867, 342.9767),
    vec4(142.8994, 6351.2163, 31.3582, 34.1176),
    vec4(439.2615, 6541.3052, 27.9518, 91.5123),
    vec4(1573.0480, 6460.5513, 24.8159, 167.2239),
    vec4(2597.7051, 5318.3843, 44.6140, 197.6131),
    vec4(2555.2603, 5076.7485, 44.8405, 13.9520),
    vec4(2497.3870, 4615.1904, 35.2191, 33.8019),
    vec4(2786.2483, 3894.9595, 45.7656, 153.5988),
}


-- coords (monitor base), camera (exact cam position), lookAt (where cam points)
Config.AntennaLocations = {

    {
        coords = vector4(2042.2028, 2948.0161, 47.9760, 311.4505), -- Monitor base position
        camera = vector4(2041.7725, 2947.6289, 47.9959, 311.4505), -- Exact camera position
        lookAt = vector3(2042.2028, 2948.0161, 47.9760) -- Where camera looks
    },

    {
        coords = vector4(1400.9871, 2123.6021, 105.2925, 358.7374),
        camera = vector4(1400.9832, 2123.1812, 105.2925, 358.7374),
        lookAt = vector3(1400.9871, 2123.6021, 105.2925)
    },

    {
        coords = vector4(751.4589, 1273.5125, 360.5952, 269.8218),
        camera = vector4(750.9281, 1273.5134, 360.5952, 269.8218),
        lookAt = vector3(751.4589, 1273.5125, 360.5952)
    },




}

Config.SecondHackLocation = {
    coords = vector4(2634.3513, 2931.1013, 44.6104, 165.6576), -- Monitor base position
    camera = vector4(2634.4739, 2931.6267, 45.0104, 166.0450), -- Camera position
    lookAt = vector3(2634.3513, 2931.1013, 44.8104) -- Where camera looks
}

-- locs to part 4
Config.InterceptionLocations = {
    vector4(2948.3250, 3659.9480, 54.8831, 340.5862),
    vector4(2631.2708, 5449.2334, 62.0930, 21.4040),
    vector4(787.6786, 6437.4424, 32.1632, 90.7585),
    vector4(-484.9183, 5237.0986, 87.8143, 153.0507),
    vector4(1031.3569, 3221.5940, 40.4883, 281.1755)
}

Config.TrainRoutes = {
    "Sandy Shores Express",
    "Paleto Bay Freight",
    "Los Santos Central",
    "Grapeseed Line",
    "Mount Chiliad Route",
    "Davis Quartz Line",
    "Vinewood Transit",
    "Del Perro Coastal",
    "La Mesa Industrial",
    "Cypress Flats Cargo"
}

Config.CarriageFloorZ = 0.0 -- base Z offset to place props on the carriage floor (above entity origin)

Config.Scenarios = {
    {
        name = "c4",
        prop = "w_ex_pe",
        hologramProp = "w_ex_pe",
        timer = 15,
        resultProp = "prop_pile_dirt_04",
        animDict = "amb@world_human_gardener_plant@male@base",
        animName = "base"
    },
    {
        name = "jammer",
        prop = "h4_prop_h4_jammer_01a",
        hologramProp = "h4_prop_h4_jammer_01a",
        timer = 15,
        animDict = "amb@world_human_gardener_plant@male@base",
        animName = "base"
    },
    {
        name = "emp",
        prop = "hei_prop_heist_emp",
        hologramProp = "hei_prop_heist_emp",
        timer = 15,
        triggerDistance = 30.0,
        animDict = "mini@repair",
        animName = "fixing_a_player"
    }
}

Config.TrainSpawnDistance = 1200.0 -- how far away to spawn the train
Config.TrainStopDistance = 20.0 -- how many meters before interception point the train stops

-- type: "loot" = pickup prop, "search" = searchable crate (random model from SearchProps)
-- slots with a model are fixed; slots without a model randomly pick from the remaining LootProps pool
Config.TrainPropSlots = {
    { slot = 1,  type = "loot",   model = "ch_prop_ch_crate_empty_01a", x = 0.0,  y = -5.5 },
    { slot = 2,  type = "loot",   model = "sm_prop_smug_crate_s_bones", x = 0.0,  y = -4.0 },
    { slot = 3,  type = "search",                                        x = 0.0,  y = -2.1 },
    { slot = 4,  type = "loot",   model = "hei_prop_heist_emp",          x = -0.7, y = 0.0 },
    { slot = 5,  type = "loot",   model = "tr_prop_tr_adv_case_01a",     x = 0.5,  y = 0.0 },
    { slot = 6,  type = "loot",   model = "sf_prop_sf_flightcase_01b",   x = 0.5,  y = 1.4 },
    { slot = 7,  type = "loot",   model = "prop_ld_case_01_s",           x = 0.0,  y = 4.9 },
    -- Slots 8-17: positions fixed, models randomly shuffled from remaining LootProps
    { slot = 8,  type = "loot",   x = -0.7, y = 1.4 },
    { slot = 9,  type = "loot",   x = 0.5,  y = 2.5 },
    { slot = 10, type = "loot",   x = -0.3, y = 2.0 },
    { slot = 11, type = "loot",   x = -0.5, y = 3.1 },
    { slot = 12, type = "loot",   x = 0.8,  y = 3.3 },
    { slot = 13, type = "loot",   x = 0.2,  y = 4.0 },
    { slot = 14, type = "loot",   x = -0.8, y = 4.3 },
    { slot = 15, type = "loot",   x = 0.8,  y = 5.2 },
    { slot = 16, type = "loot",   x = -0.8, y = 5.5 },
    { slot = 17, type = "loot",   x = 0.1,  y = 5.7 },
}

Config.MinItemsToDeliver = 5 -- minimum items that must be loaded into the vehicle before the drop-off can be completed
Config.MaxLootProps = 60 -- max pickup-able props spawned on train
Config.MaxSearchProps = 4 -- max search-only crate props near train
Config.PickupDuration = 1500 -- ms to pick up a loot prop
Config.SearchDuration = 5000 -- ms to search a crate
Config.TrainAutoDeleteTime = 900 -- seconds after train stops to auto-delete train and props
Config.VehicleDeleteDelay = 120 -- seconds the frozen vehicle stays at the drop-off before it is deleted (5 min)

Config.SearchProps = {
    "ba_prop_battle_crate_art_02_bc",
    "sm_prop_smug_crate_l_narc",
    "ex_prop_crate_wlife_bc",
    "sm_prop_smug_crate_l_hazard",
    "ba_prop_battle_crate_gems_bc",
    "ex_prop_crate_pharma_sc",
    "sm_prop_smug_crate_l_fake",
    "ex_prop_crate_med_bc",
    "ex_prop_crate_jewels_racks_bc",
    "ex_prop_crate_med_sc",
    "sm_prop_smug_crate_m_jewellery",
    "ex_prop_crate_pharma_bc",
    "ba_prop_battle_crate_m_hazard",
    "ba_prop_battle_crate_m_bones"
}

Config.DropOffLocations = {
    vec4(2594.1421, 494.2607, 108.4748, 88.7598),
    vec4(2152.9807, -844.8054, 78.3766, 106.4809),
    vec4(1492.6630, -2193.7683, 77.1276, 208.7679),
    vec4(1261.9852, -2563.7544, 42.7167, 107.7751),
    vec4(1067.6248, -2454.1060, 28.9101, 15.8549),
    vec4(561.1591, -2747.7888, 6.0560, 150.7130),
    vec4(1062.2495, -2445.8374, 29.0489, 268.8448),
    vec4(1096.3047, -2238.0620, 30.2904, 355.4695),
    vec4(-1788.5618, 810.9203, 138.4917, 220.4212),
    vec4(601.6763, 772.4366, 202.9346, 259.7710),
}

-- Carry attach tuned for the two-handed box-carry idle (anim@heists@box_carry@ idle).
-- Bone 28422 holds the prop against the chest/front of the ped (matches devhub_crimeScenes
-- crates). Per-prop offsets/rotations below are ported from that resource's crate config.
Config.CarryBone = 28422 -- box-carry chest bone
Config.CarryOffset = vector3(0.0, -0.2, 0.15)   -- default box-carry offset
Config.CarryRotation = vector3(6.0, 24.0, -89.0)  -- default box-carry rotation

Config.CarryOverrides = {
    ["hei_prop_heist_emp"]              = { offset = vector3(0.0, -0.2, 0.15),  rotation = vector3(6.0, 24.0, -89.0) },
    ["sm_prop_smug_crate_s_bones"]      = { offset = vector3(0.0, -0.4, 0.04),  rotation = vector3(30.0, 0.0, 0.0) },
    ["ex_prop_adv_case_sm"]             = { offset = vector3(0.0, -0.3, 0.04),  rotation = vector3(6.0, 32.0, -89.0) },
    ["sf_prop_sf_weed_bigbag_01a"]      = { offset = vector3(0.0, -0.2, -0.2),  rotation = vector3(4.0, 24.0, -89.0) },
    -- ["m23_2_prop_m32_bag_weapons_01a"]  = { offset = vector3(0.0, -0.1, -0.14), rotation = vector3(24.0, -3.0, 0.0) },
    ["ex_office_swag_drugbags"]         = { offset = vector3(0.0, -0.1, -0.15), rotation = vector3(24.0, -3.0, 0.0) },
    ["ex_office_swag_ivory2"]           = { offset = vector3(0.0, -0.1, 0.0),   rotation = vector3(6.0, 40.0, -89.0) },
    ["prop_mp_drug_pack_red"]           = { offset = vector3(0.0, -0.2, -0.05), rotation = vector3(32.0, -3.0, 0.0) },
    ["ch_prop_ch_crate_empty_01a"]      = { offset = vector3(0.0, -0.2, -0.2),  rotation = vector3(40.0, -3.0, 0.0) },
    ["bkr_prop_biker_case_shut"]        = { offset = vector3(0.0, -0.2, -0.15), rotation = vector3(30.0, 0.0, 0.0) },
    ["h4_prop_h4_case_supp_01a"]        = { offset = vector3(0.0, -0.1, -0.15), rotation = vector3(30.0, 0.0, 0.0) },
    ["prop_box_guncase_02a"]            = { offset = vector3(0.0, -0.1, -0.2),  rotation = vector3(0.0, 0.0, 0.0) },
    ["hei_p_attache_case_shut_s"]       = { offset = vector3(0.0, -0.2, -0.15), rotation = vector3(30.0, 0.0, 0.0) },
    ["prop_ld_case_01_s"]               = { offset = vector3(0.0, 0.1, 0.0),    rotation = vector3(-70.0, 0.0, 0.0) },
    ["sf_prop_sf_flightcase_01b"]       = { offset = vector3(0.0, -0.2, -0.15), rotation = vector3(6.0, 24.0, -89.0) },
    ["sf_prop_sf_flightcase_01c"]       = { offset = vector3(0.0, -0.2, -0.15), rotation = vector3(6.0, 24.0, -89.0) },
    ["prop_suitcase_03b"]               = { offset = vector3(0.0, -0.15, 0.05), rotation = vector3(-90.0, 24.0, -89.0) },
    ["tr_prop_tr_adv_case_01a"]         = { offset = vector3(0.0, -0.4, 0.05),  rotation = vector3(5.0, 32.0, -89.0) },
    -- w_am_case has no crimeScenes entry; uses a generic case fit.
    ["w_am_case"]                       = { offset = vector3(0.0, -0.2, -0.15), rotation = vector3(6.0, 24.0, -89.0) },
}
