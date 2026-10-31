cfg = cfg or {} cfg.tasks = cfg.tasks or {} lang = lang or {}

-------------------------------
-- MARK: Skill Checks
-------------------------------
cfg.tasks.skill_checks = {
    -- Vehicle Class gets passed to create varying difficulties in hacks
    remove_tracker = function(class)
        -- Example of how to incorporate class to alter minigame
        local puzzles = 1
        if class == "S+" or class == "S" then puzzles = 3 end

        local success = exports.bl_ui:PathFind(puzzles, {
            numberOfNodes = 5,
            duration = 15000,
        })
        return success
    end,
    repaint_vehicle = function()
        local success = exports.bl_ui:KeySpam(2, math.random(25, 50))
        return success
    end,
    disable_alarm = function()
        local success = exports.bl_ui:KeySpam(2, math.random(25, 50))
        return success
    end,
    plate_swap = function()
        local success = exports.bl_ui:Progress(3, math.random(25, 50))
        return success
    end,
    jam_radio_towers = function()
        local success = exports.bl_ui:MineSweeper(1, {
            grid = 4,
            duration = 20000,
            target = 6,
            previewDuration = 3000
        })
        return success
    end,
}



-------------------------------
-- MARK: Mission Types
-------------------------------
cfg.tasks.types = {
    acquire = {
        {
            enabled = true,
            id = "mug_owner",
            label = lang:get("tasks_info.mug_owner.l"),
            description = lang:get("tasks_info.mug_owner.d"),
            classes = { "D", "D+", "C", "C+", "B", "B+" },
            enemy_ped = 'default'
        },
        {
            enabled = true,
            id = "test_drive",
            label = lang:get("tasks_info.test_drive.l"),
            description = lang:get("tasks_info.test_drive.d"),
            classes = { "D", "D+", "C", "C+", "B", "B+" },
            enemy_ped = 'default'
        },
        {
            enabled = true,
            id = "lockpick_vehicle",
            label = lang:get("tasks_info.lockpick_vehicle.l"),
            description = lang:get("tasks_info.lockpick_vehicle.d"),
            classes = 'all',
            item_required = { 
                { item = "lockpick", count = 1 }
            },
        },
        {
            enabled = true,
            id = "hack_keyless",
            label = lang:get("tasks_info.hack_keyless.l"),
            description = lang:get("tasks_info.hack_keyless.d"),
            classes = { "C", "C+", "B", "B+", "A", "A+", "S", "S+" },
            item_required = {
                { item = "weapon_digiscanner", count = 1 }
            },
        },
        {
            enabled = true,
            id = "stop_vehicle",
            label = lang:get("tasks_info.stop_vehicle.l"),
            description = lang:get("tasks_info.stop_vehicle.d"),
            classes = { "C", "C+", "B", "B+", "A", "A+", "S", "S+" },
            enemy_ped = 'default'
        },
        {
            enabled = true,
            id = "gang_theft",
            label = lang:get("tasks_info.gang_theft.l"),
            description = lang:get("tasks_info.gang_theft.d"),
            classes = { "C", "C+", "B", "B+", "A", "A+", "S", "S+" },
            enemy_ped = "gang"
        },
        {
            enabled = true,
            id = "military_theft",
            label = lang:get("tasks_info.military_theft.l"),
            description = lang:get("tasks_info.military_theft.d"),
            classes = { "A", "A+", "S", "S+" },
            enemy_ped = "military",
            item_required = {},
        },
        {
            enabled = false,
            id = "dev_test_01",
            label = "Dev Phase",
            description = "Dev",
            classes = 'all',
        },
    },

    operation = {
        {
            enabled = true,
            id = "remove_tracker",
            label = lang:get("tasks_info.remove_tracker.l"),
            description = lang:get("tasks_info.remove_tracker.d"),
            classes = { "C", "C+", "B", "B+", "A", "A+", "S", "S+" },
            item_required = {
                { item = "gg_tracker_scrambler", count = 1 }
            },
        },
        {
            enabled = true,
            id = "disable_alarm",
            label = lang:get("tasks_info.disable_alarm.l"),
            description = lang:get("tasks_info.disable_alarm.d"),
            classes = { "D", "D+", "C", "C+", "B", "B+" },
            item_required = {
                { item = "gg_wire_cutters", count = 1 }
            },
        },
        {
            enabled = true,
            id = "plate_swap",
            label = lang:get("tasks_info.plate_swap.l"),
            description = lang:get("tasks_info.plate_swap.d"),
            classes = { "D", "D+", "C", "C+", "B", "B+" },
            item_required = {
                { item = "gg_boost_plate", count = 1 }
            },
        },
        {
            enabled = true,
            id = "repaint_car",
            label = lang:get("tasks_info.repaint_car.l"),
            description = lang:get("tasks_info.repaint_car.d"),
            classes = { "D", "D+", "C", "C+", "B", "B+" },
            item_required = {
                { item = "gg_rattle_can", count = 1 }
            },
        },
        {
            enabled = true,
            id = "jam_radio_towers",
            label = lang:get("tasks_info.jam_radio_towers.l"),
            description = lang:get("tasks_info.jam_radio_towers.d"),
            classes = { "A", "A+", "S", "S+" },
            item_required = {
                { item = "gg_signal_jammer", count = 3 }
            },
        },
        {
            enabled = true,
            id = "ego_boast",
            label = lang:get("tasks_info.ego_boast.l"),
            description = lang:get("tasks_info.ego_boast.d"),
            classes = { "D", "D+", "C", "C+", "B", "B+" },
        },
        {
            enabled = false,
            id = "dev_test_02",
            label = "Dev Phase 2",
            description = "Dev",
            classes = 'all',
        },
    },

    delivery = {
        {
            enabled = true,
            id = "drop_location",
            label = lang:get("tasks_info.drop_location.l"),
            description = lang:get("tasks_info.drop_location.d"),
            classes = 'all',
        },
        {
            enabled = true,
            id = "hand_off",
            label = lang:get("tasks_info.hand_off.l"),
            description = lang:get("tasks_info.hand_off.d"),
            classes = 'all',
            npc = 'delivery'
        },
        {
            enabled = true,
            id = "chop_shop",
            label = lang:get("tasks_info.chop_shop.l"),
            description = lang:get("tasks_info.chop_shop.d"),
            classes = 'all',
            npc = 'delivery'
        },
        {
            id = "vin_scratch",
            label = lang:get("tasks_info.vin_scratch.l"),
            description = lang:get("tasks_info.vin_scratch.d"),
            classes = {},
            npc = 'delivery'
        },
        {
            enabled = false,
            id = "dev_test_03",
            label = "Dev Phase 3",
            description = "Dev",
            classes = 'all',
        },
    }
}




-------------------------------
-- MARK: Mission Settings
-------------------------------
cfg.tasks.settings = {
    default = {
        vehicle_blip = {
            type   = "both",  -- "blip" | "radius" | "both" | (Default: "both")
            sprite = 620,
            color  = 1,
            scale  = 1.0,
            radius = 100.0,
        },

        dispatch = {   -- Dispatch Will only trigger if enabled in respective mission below these are fallback defaults
            message  = lang:get("tasks_settings.default.dispatch"),
            alert_class = true, -- Passes vehicle class in dispatch alert.
            code     = "10-80",
            icon     = "fas fa-car",
            priority = 2,
            time     = 10000,
            timeout  = 0,   -- Time until dispatch is sent
            blip     = {
                sprite = 161,
                color  = 1,
                scale  = 1.2,
                radius = 25.0,
                flash  = true,
            },
        },
        progress = {
            duration = 30,
        },
        hack = {
            count = 0,
        },
        warning = {
            duration = 0,
        },
    },

    mug_owner = {
        dispatch = {
            enabled  = true,
            code     = "10-31",
            message  = lang:get("tasks_settings.mug_owner.dispatch"),
            icon     = "fas fa-user-secret",
            priority = 2,
            time     = 5000,
            timeout  = 0,
            blip = {
                sprite = 620,
                color  = 1,
                scale  = 1.0,
                radius = 50.0,
                length = 30000,
                flash  = true,
            },
        },
    },

    test_drive = {
        vehicle_blip = {
            type   = "blip",
            sprite = 620,
            color  = 1,
            scale  = 1.0,
            radius = 60.0,
        },
        dispatch = {
            enabled  = true,
            code     = "10-51",
            message  = lang:get("tasks_settings.test_drive.dispatch"),
            icon     = "fas fa-car-side",
            priority = 2,
            time     = 5000,
            timeout  = 10000,
            blip = {
                sprite = 620,
                color  = 1,
                scale  = 1.0,
                radius = 50.0,
                length = 30000,
                flash  = false,
            },
        },
    },

    lockpick_vehicle = {
        dispatch = {
            enabled  = true,
            code     = "10-31",
            message  = lang:get("tasks_settings.lockpick_vehicle.dispatch"),
            icon     = "fas fa-tools",
            priority = 2,
            time     = 5000,
            timeout  = 0,
            blip = {
                sprite = 620,
                color  = 1,
                scale  = 1.0,
                radius = 50.0,
                length = 30000,
                flash  = true,
            },
        },
    },

    hack_keyless = {
        dispatch = {
            enabled  = true,
            code     = "10-37",
            message  = lang:get("tasks_settings.hack_keyless.dispatch"),
            icon     = "fas fa-broadcast-tower",
            priority = 1,
            time     = 5000,
            timeout  = 5000,
            blip = {
                sprite = 620,
                color  = 1,
                scale  = 1.0,
                radius = 50.0,
                length = 30000,
                flash = false,
            },
        },
    },

    stop_vehicle = {
        dispatch = {
            enabled  = true,
            code     = "10-33",
            message  = lang:get("tasks_settings.stop_vehicle.dispatch"),
            icon     = "fas fa-car-crash",
            priority = 1,
            time     = 5000,
            timeout  = 0,
            loop = 5000,   -- Loop will not create a new dispatch will just send blips down on last know location.
            blip = {
                sprite = 161,
                color  = 1,
                scale  = 1.2,
                radius = 60.0,
                length = 5000,
                flash  = true,
            },
        },
    },

    gang_theft = {
        dispatch = {
            enabled  = true,
            code     = "10-31",
            message  = lang:get("tasks_settings.gang_theft.dispatch"),
            icon     = "fas fa-user-secret",
            priority = 2,
            time     = 5000,
            timeout  = 0,
            blip = {
                sprite = 620,
                color  = 1,
                scale  = 1.0,
                radius = 50.0,
                length = 30000,
                flash  = true,
            },
        },
    },

    military_theft = {
        dispatch = {
            enabled  = true,
            code     = "10-66",
            message  = lang:get("tasks_settings.military_theft.dispatch"),
            icon     = "fas fa-user-secret",
            priority = 2,
            time     = 5000,
            timeout  = 0,
            blip = {
                sprite = 620,
                color  = 1,
                scale  = 1.0,
                radius = 50.0,
                length = 30000,
                flash  = true,
            },
        },
    },

    remove_tracker = {
        dispatch = {
            enabled  = true,
            code     = "10-60",
            message  = lang:get("tasks_settings.remove_tracker.dispatch"),
            icon     = "fas fa-location-arrow",
            priority = 1,
            time     = 5000,
            timeout  = 0,
            loop = 30000,   -- Loop will not create a new dispatch will just send blips down on last know location.
            blip = {
                sprite = 161,
                color  = 1,
                scale  = 1.2,
                radius = 60.0,
                length = 30000,
                flash  = true,
            },
        },
        hack_settings = {
            default = {
                hack_count = 1,               -- 1 Hack Required
                progress_bar = 30,            -- 30 Seconds on Progress Bar
                passenger_seat = false,       -- Must be in Passenger Seat when hacking
                require_driver = false,        -- Car must have a driver to hack
                progressive_progress = false, -- Must do x amount in a row if you fail you lose 1 progress from total
            },
            ['D']  = {hack_count = 1, progress_bar = 60, passenger_seat = false, progressive_progress = false},
            ['D+'] = {hack_count = 1, progress_bar = 60, passenger_seat = false, progressive_progress = false},
            ['C']  = {hack_count = 2, progress_bar = 30, passenger_seat = false, progressive_progress = false},
            ['C+'] = {hack_count = 2, progress_bar = 45, passenger_seat = false, progressive_progress = false},
            ['B']  = {hack_count = 3, progress_bar = 30, passenger_seat = false, progressive_progress = false},
            ['B+'] = {hack_count = 3, progress_bar = 45, passenger_seat = false, progressive_progress = true},
            ['A']  = {hack_count = 4, progress_bar = 30, passenger_seat = false, progressive_progress = true},
            ['A+'] = {hack_count = 4, progress_bar = 45, passenger_seat = false, progressive_progress = true},
            ['S']  = {hack_count = 5, progress_bar = 30, passenger_seat = false, progressive_progress = true},
            ['S+'] = {hack_count = 5, progress_bar = 45, passenger_seat = false, progressive_progress = true},
        },
    },

    disable_alarm = {
        dispatch = {
            enabled  = true,
            code     = "10-60",
            message  = lang:get("tasks_settings.disable_alarm.dispatch"),
            icon     = "fas fa-car",
            priority = 1,
            time     = 5000,
            timeout  = 0,
            blip = {
                sprite = 161,
                color  = 1,
                scale  = 1.2,
                radius = 60.0,
                length = 30000,
                flash  = true,
            },
        },
    },

    plate_swap = {
        dispatch = {
            enabled  = true,
            code     = "10-66",
            message  = lang:get("tasks_settings.plate_swap.dispatch"),
            icon     = "fas fa-user-secret",
            priority = 2,
            time     = 5000,
            timeout  = 0,
            blip = {
                sprite = 620,
                color  = 1,
                scale  = 1.0,
                radius = 50.0,
                length = 30000,
                flash  = true,
            },
        },
        progress = { duration = 60 },
    },

    repaint_car = {
        dispatch = {
            enabled  = true,
            code     = "10-66",
            message  = lang:get("tasks_settings.repaint_car.dispatch"),
            icon     = "fas fa-user-secret",
            priority = 2,
            time     = 5000,
            timeout  = 0,
            blip = {
                sprite = 620,
                color  = 1,
                scale  = 1.0,
                radius = 50.0,
                length = 30000,
                flash  = true,
            },
        },
        progress = {
            duration = 60,  -- Total Seconds
        },
    },

    jam_radio_towers = {
        dispatch = {
            enabled  = true,
            code     = "10-66",
            message  = lang:get("tasks_settings.jam_radio_towers.dispatch"),
            icon     = "fas fa-broadcast-tower",
            priority = 1,
            time     = 5000,
            timeout  = 0,
            loop = 15000,   -- Loop will not create a new dispatch will just send blips down on last know location.
            blip = {
                sprite = 161,
                color  = 1,
                scale  = 1.2,
                radius = 60.0,
                length = 15000,
                flash  = true,
            },
        },
        model    = "imp_prop_impexp_cargo_01",
        progress = { duration = 10 },
        warning  = { duration = 10 },
    },

    ego_boast = {
        dispatch = {
            enabled  = false,
            code     = "10-66",
            message  = lang:get("tasks_settings.ego_boast.dispatch"),
            icon     = "fas fa-user-secret",
            priority = 2,
            time     = 5000,
            timeout  = 0,
            blip = {
                sprite = 620,
                color  = 1,
                scale  = 1.0,
                radius = 50.0,
                length = 30000,
                flash  = true,
            },
        },
    },

    drop_location = {
        dispatch = {
            enabled  = false,
            code     = "10-66",
            message  = lang:get("tasks_settings.drop_location.dispatch"),
            icon     = "fas fa-user-secret",
            priority = 2,
            time     = 5000,
            timeout  = 0,
            blip = {
                sprite = 620,
                color  = 1,
                scale  = 1.0,
                radius = 50.0,
                length = 30000,
                flash  = true,
            },
        },
    },

    hand_off = {
        dispatch = {
            enabled  = false,
            code     = "10-66",
            message  = lang:get("tasks_settings.hand_off.dispatch"),
            icon     = "fas fa-user-secret",
            priority = 2,
            time     = 5000,
            timeout  = 0,
            blip = {
                sprite = 620,
                color  = 1,
                scale  = 1.0,
                radius = 50.0,
                length = 30000,
                flash  = true,
            },
        },
    },

    chop_shop = {
        dispatch = {
            enabled  = false,
            code     = "10-66",
            message  = lang:get("tasks_settings.chop_shop.dispatch"),
            icon     = "fas fa-user-secret",
            priority = 2,
            time     = 5000,
            timeout  = 0,
            blip = {
                sprite = 620,
                color  = 1,
                scale  = 1.0,
                radius = 50.0,
                length = 30000,
                flash  = true,
            },
        },
    },
}


-------------------------------
-- MARK: Mission Locations
-------------------------------




cfg.tasks.locations = {
    -------------------------------
    -- MARK: mug_owner
    -------------------------------
    ["mug_owner"] = {
        { coord = vector4(1375.81, 632.85, 79.54, 323.38), npc = vector4(1372.7, 631.45, 80.0, 44.41) },
        { coord = vector4(1286.46, 840.54, 105.02, 357.94), npc = vector4(1284.84, 838.21, 105.34, 357.69) },
        { coord = vector4(553.01, 1388.05, 303.41, 160.06), npc = vector4(549.07, 1386.05, 303.72, 222.16) },
        { coord = vector4(245.71, 1160.83, 225.05, 14.14), npc = vector4(246.32, 1165.42, 225.46, 35.55) },
        { coord = vector4(73.27, 1421.71, 263.62, 56.71), npc = vector4(69.52, 1424.14, 264.36, 134.7) },
        { coord = vector4(-413.72, 1227.86, 325.23, 236.31), npc = vector4(-418.61, 1228.62, 325.76, 246.9) },
        { coord = vector4(-1579.84, 975.34, 156.7, 80.96), npc = vector4(-1579.06, 973.38, 157.18, 155.44) },
        { coord = vector4(-1545.14, 1374.17, 125.32, 313.39), npc = vector4(-1550.86, 1377.2, 126.41, 72.11) },
        { coord = vector4(-1660.75, 2229.35, 86.79, 83.05), npc = vector4(-1660.96, 2227.27, 87.52, 96.35) },
        { coord = vector4(-2570.3, 2340.16, 32.65, 154.79), npc = vector4(-2572.59, 2336.7, 33.06, 171.43) },
        { coord = vector4(-2441.44, 3764.08, 18.44, 353.66), npc = vector4(-2442.39, 3767.33, 19.02, 81.38) },
        { coord = vector4(-2349.92, 288.89, 169.06, 294.48), npc = vector4(-2348.25, 291.58, 169.47, 350.88) },
        { coord = vector4(-2071.32, -301.69, 12.75, 173.21), npc = vector4(-2070.77, -296.87, 13.32, 155.05) },
        { coord = vector4(-1734.75, -734.46, 10.0, 139.2), npc = vector4(-1734.96, -738.14, 10.41, 313.71) },
        { coord = vector4(-1676.26, -875.17, 8.29, 141.16), npc = vector4(-1673.14, -874.54, 8.74, 214.53) },
        { coord = vector4(-1538.71, -1001.11, 12.61, 254.58), npc = vector4(-1532.56, -1001.08, 13.02, 233.29) },
        { coord = vector4(-1143.94, -1064.6, 1.74, 206.52), npc = vector4(-1141.21, -1065.28, 2.15, 190.94) },
        { coord = vector4(-910.8, -1165.71, 4.46, 29.12), npc = vector4(-907.89, -1168.8, 4.91, 165.8) },
    },


    -------------------------------
    -- MARK: test_drive
    -------------------------------
    ["test_drive"] = {
        { coord = vector4(-910.8, -1165.71, 4.46, 29.12), npc = vector4(-907.89, -1168.8, 4.91, 165.8) },
        { coord = vector4(-955.19, -1085.19, 1.74, 156.66), npc = vector4(-952.06, -1081.81, 2.15, 212.04) },
        { coord = vector4(-1181.37, -1395.23, 4.23, 293.51), npc = vector4(-1183.88, -1398.18, 4.68, 302.43) },
        { coord = vector4(-1276.63, -1152.41, 5.83, 295.11), npc = vector4(-1275.05, -1149.67, 6.41, 114.18) },
        { coord = vector4(-1184.26, -543.94, 28.38, 40.47), npc = vector4(-1186.34, -539.6, 28.87, 136.61) },

        { coord = vector4(-1389.86, -11.53, 52.87, 324.23), npc = vector4(-1391.93, -8.39, 53.38, 289.73) },
        { coord = vector4(-1618.88, -515.03, 34.71, 128.84), npc = vector4(-1619.38, -517.93, 34.96, 134.85) },
        { coord = vector4(-1528.77, -553.88, 32.95, 34.14), npc = vector4(-1530.95, -554.19, 33.4, 108.34) },
        { coord = vector4(-576.06, -1036.46, 21.77, 269.9), npc = vector4(-574.4, -1034.62, 22.18, 266.87) },
        { coord = vector4(-607.05, -1215.79, 14.07, 311.02), npc = vector4(-608.63, -1214.16, 14.46, 309.15) },

        { coord = vector4(-354.75, -1400.67, 29.83, 255.93), npc = vector4(-353.44, -1397.11, 31.34, 199.61) },
        { coord = vector4(66.06, -1431.09, 28.9, 139.41), npc = vector4(65.25, -1435.31, 29.31, 321.92) },
        { coord = vector4(119.35, -1573.71, 29.19, 278.32), npc = vector4(119.41, -1571.24, 29.6, 283.34) },
        { coord = vector4(561.11, -1789.34, 28.79, 338.25), npc = vector4(558.68, -1790.38, 29.2, 133.5) },
        { coord = vector4(452.75, -1693.98, 28.89, 142.21), npc = vector4(452.64, -1691.12, 29.28, 315.78) },
    },

    -------------------------------
    -- MARK: lockpick_vehicle
    -------------------------------
    ["lockpick_vehicle"] = {
        { coord = vector4(645.27, 626.15, 128.5, 250.36) },
        { coord = vector4(968.92, 184.64, 80.42, 82.46) },
        { coord = vector4(1270.02, -373.66, 68.61, 231.0) },
        { coord = vector4(1387.22, -741.66, 66.65, 356.82) },
        { coord = vector4(900.46, -1067.14, 32.42, 180.22) },

        { coord = vector4(878.88, -1535.08, 29.83, 226.31) },
        { coord = vector4(964.91, -1822.51, 30.66, 174.63) },
        { coord = vector4(1112.23, -2232.71, 29.71, 87.05) },
        { coord = vector4(492.57, -2577.62, 6.47, 202.92) },
        { coord = vector4(-137.28, -2420.32, 5.59, 184.49) },
    },

    -------------------------------
    -- MARK: stop_vehicle
    -------------------------------
    ["stop_vehicle"] = {
        { coord = vector4(-640.46, -2245.46, 5.91, 229.06) },
        { coord = vector4(-516.68, -1827.82, 22.54, 356.92) },
        { coord = vector4(-1568.08, -865.45, 9.6, 320.0) },
        { coord = vector4(-1785.08, -594.2, 10.56, 68.26) },
        { coord = vector4(442.24, 865.53, 196.92, 310.13) },
    },
    -------------------------------
    -- MARK: hack_keyless
    -------------------------------
    ["hack_keyless"] = {
        { coord = vector4(-971.1, -1558.1, 4.64, 200.74), hack_point = vector3(-981.61, -1563.43, 5.18) },
        { coord = vector4(-1162.56, 475.58, 85.26, 10.55), hack_point = vector3(-1161.6, 500.04, 86.09) },
        { coord = vector4(-850.45, 513.66, 90.21, 283.44), hack_point = vector3(-831.9, 512.73, 94.62) },
        { coord = vector4(-182.93, 206.62, 87.28, 180.72), hack_point = vector3(-193.0, 203.42, 86.18) },
        { coord = vector4(845.81, -194.85, 72.09, 327.8), hack_point = vector3(839.79, -181.85, 74.19) },
    },
    -------------------------------
    -- MARK: gang_theft
    -------------------------------
    ["gang_theft"] = {
        {
            coord = vector4(626.23, -868.88, 10.44, 1.92),
            npc = {
                vector4(627.95, -862.64, 10.86, 100.63),
                vector4(625.03, -865.84, 10.86, 90.06),
                vector4(628.57, -872.64, 11.06, 93.31),
            },
        },
        {
            coord = vector4(571.35, -1770.31, 28.74, 358.02),
            npc = {
                vector4(566.5, -1777.66, 29.35, 329.47),
                vector4(562.21, -1769.88, 29.36, 10.16),
                vector4(558.67, -1760.29, 29.32, 246.26),
            },
        },
        {
            coord = vector4(585.91, -1883.66, 24.9, 141.07),
            npc = {
                vector4(581.66, -1885.08, 25.52, 173.67),
                vector4(588.57, -1877.57, 25.14, 167.85),
            },
        },
        {
            coord = vector4(-181.23, -2262.38, 7.4, 171.02),
            npc = {
                vector4(-177.29, -2266.05, 7.81, 359.45),
                vector4(-184.63, -2270.47, 7.81, 0.02),
            },
        },
        {
            coord = vector4(-231.18, -1692.31, 33.39, 359.23),
            npc = {
                vector4(-234.09, -1691.36, 33.82, 231.66),
                vector4(-231.26, -1687.33, 34.01, 194.41),
                vector4(-231.26, -1687.33, 34.01, 192.99),
                vector4(-227.49, -1688.76, 33.89, 176.3),
            },
        },
    },
    -------------------------------
    -- MARK: military_theft
    -------------------------------
    ["military_theft"] = {
        {
            coord = vector4(-1859.11, 2914.16, 32.4, 60.03),
            npc = {
                vector4(-1863.39, 2918.6, 32.81, 145.73),
                vector4(-1852.34, 2912.15, 32.81, 212.08),
                vector4(-1857.76, 2911.24, 32.81, 146.34),
                vector4(-1863.35, 2914.13, 32.81, 62.55),
            },
        },
        {
            coord = vector4(-2455.64, 2984.79, 32.4, 104.29),
            npc = {
                vector4(-2457.49, 2981.09, 32.81, 276.49),
                vector4(-2459.9, 2987.09, 32.81, 287.44),
            },
        },
        {
            coord = vector4(-1829.73, 3291.12, 32.4, 152.39) ,
            npc = {
                vector4(-1824.67, 3290.15, 32.81, 62.55),
                vector4(-1824.61, 3284.98, 32.81, 151.16),
                vector4(-1832.77, 3270.58, 32.69, 47.14),
                vector4(-1836.95, 3297.46, 32.81, 231.46),
            },
        },
    },
    -------------------------------
    -- MARK: repaint_car
    -------------------------------
    ["repaint_car"] = {
        { coord = vector3(-284.03, 2535.49, 74.26) },
        { coord = vector3(610.19, 2791.94, 41.75) },
        { coord = vector3(986.07, -138.63, 72.68) },
        { coord = vector3(969.92, -1624.54, 29.7) },
        { coord = vector3(947.77, -1697.75, 29.67) },

    },
    -------------------------------
    -- MARK: jam_radio_towers
    -------------------------------
    ["jam_radio_towers"] = {
        {
            vector4(1658.7, -2412.58, 99.0, 184.0),
            vector4(1495.29, -1270.74, 120.9, 2.3),
            vector4(2678.84, -319.65, 124.85, 319.28),
        },
        {
            vector4(-2224.68, 538.64, 165.25, 261.85),
            vector4(-2049.6, 896.19, 192.2, 243.09),
            vector4(-1768.09, 607.56, 178.32, 169.93),
        },
        {
            vector4(-282.62, 1422.31, 343.87, 328.09),
            vector4(489.46, 1439.9, 349.69, 250.41),
            vector4(976.3, 690.77, 187.26, 184.0),
        },
    },
    -------------------------------
    -- MARK: ego_boast
    -------------------------------
    ["ego_boast"] = {
        {
            vector3(1184.55, -511.86, 65.09),
            vector3(800.19, -57.36, 80.64),
            vector3(780.89, -1006.29, 26.15),
            vector3(780.89, -1006.29, 26.15),
            vector3(107.23, -998.2, 29.39),
            vector3(265.19, -577.86, 43.32),
        },
        {
            vector3(265.19, -577.86, 43.32),
            vector3(-524.35, -365.34, 35.28),
            vector3(-1073.75, -764.29, 19.35),
            vector3(-271.85, -1141.69, 23.08),
            vector3(315.86, -1513.65, 29.33),
            vector3(224.47, -1044.62, 29.37),
        },
        {
            vector3(287.13, -861.76, 29.31),
            vector3(385.43, -607.56, 28.89),
            vector3(-633.24, -656.66, 31.72),
            vector3(-187.49, -894.77, 29.34),
            vector3(-27.42, -1605.49, 29.3),
            vector3(-105.44, -230.42, 44.81),
        },
    },
    -------------------------------
    -- MARK: drop_location
    -------------------------------
    ["drop_location"] = {
        { coord = vector3(-39.93, -197.28, 52.35) },
        { coord = vector3(-707.87, -973.44, 20.39) },
        { coord = vector3(-612.97, -1597.69, 26.75) },
        { coord = vector3(-963.36, -1970.23, 13.19) },
        { coord = vector3(-529.98, -2780.84, 6.0) },

        { coord = vector3(168.02, -2389.58, 6.0) },
        { coord = vector3(524.65, -2110.89, 5.99) },
        { coord = vector3(888.07, -2211.58, 30.51) },
        { coord = vector3(498.47, -1406.38, 29.31) },
        { coord = vector3(816.75, -751.08, 26.73) },
    },
    -------------------------------
    -- MARK: hand_off
    -------------------------------
    ["hand_off"] = {
        { coord = vector4(760.82, -783.61, 26.43, 270.75) },
        { coord = vector4(844.22, -220.78, 71.91, 328.02) },
        { coord = vector4(893.47, -86.7, 78.85, 330.92) },
        { coord = vector4(688.48, 238.14, 93.48, 147.84) },
        { coord = vector4(354.83, 358.39, 104.8, 71.69) },
        { coord = vector4(119.22, 317.38, 112.15, 120.63) },
        { coord = vector4(-1822.85, 805.61, 138.74, 355.17) },
        { coord = vector4(-2232.29, 4227.38, 46.62, 290.22) },
        { coord = vector4(-214.68, 6356.49, 31.49, 115.69) },
        { coord = vector4(986.07, 3583.75, 33.64, 352.34) },
    },
    -------------------------------
    -- MARK: chop_shop
    -------------------------------
    ["chop_shop"] = {
        {
            coord = vector4(849.48, -2133.16, 30.31, 350.06),
            npc = {
                vector4(860.84, -2124.1, 30.65, 195.76), 
                vector4(843.38, -2133.57, 29.85, 316.89),
            },
        },
        {
            coord = vector4(2373.77, 3056.65, 48.15, 265.4),
            npc = {
                vector4(2372.43, 3048.34, 48.15, 262.77), 
                vector4(2388.98, 3052.41, 48.41, 66.73),
            },
        },
        {
            coord = vector4(704.92, -2275.14, 27.48, 32.25),
            npc = {
                vector4(713.99, -2266.89, 27.47, 124.78), 
                vector4(703.57, -2288.04, 27.47, 81.54),
            },
        },
        {
            coord = vector4(739.62, 2578.76, 75.45, 199.97),
            npc = {
                vector4(744.65, 2583.97, 75.31, 202.74), 
                vector4(728.41, 2579.13, 75.25, 199.56),
            },
        },
        {
            coord = vector4(-60.47, -2250.11, 7.81, 92.44),
            npc = {
                vector4(-56.78, -2242.8, 7.81, 93.18), 
                vector4(-56.64, -2255.89, 7.81, 82.55),
            },
        },
    },
    -------------------------------
    -- MARK: vin_scratch
    -------------------------------
    ["vin_scratch"] = {
        { coord = vector4(-475.49, 6257.97, 13.49, 67.04) },
        { coord = vector4(763.49, 4174.88, 40.59, 1.63) },
        { coord = vector4(3812.2, 4447.85, 3.51, 43.85) },
        { coord = vector4(2481.9, 3433.02, 50.02, 141.99) },
        { coord = vector4(1538.05, 1702.43, 109.67, 83.44) },
    },

    -- Referenced But no Data is Used.    
    ["remove_tracker"] = {}, ["disable_alarm"] = {}, ["plate_swap"] = {},

    -- Dev Testing All Disabled in Production
    ["dev_test_01"] = { { coord = vector4(-1571.73, -3175.5, 13.95, 313.01) } }, ["dev_test_02"] = {}, ["dev_test_03"] = {},
}



cfg.tasks.mounted = true  -- Shows the document does not have any syntax errors.