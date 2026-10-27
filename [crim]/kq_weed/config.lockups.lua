-- Colors of Lockups containers
-- 0 = white/default
-- 1 = blue
-- 2 = green
-- 3 = orange
-- 4 = red
-- 5 = black
-- 6 = Cyan
-- 7 = lime
-- 8 = dark green
-- 9 = maroon
-- 10 = dark red
-- 11 = dark purple
-- 12 = gray
-- 13 = dark gray
-- 14 = light gray
-- 15 = yellow

Config.lockups = {
    ['container_1'] = {
        -- Model name of the container
        model = 'kq_weed_container_01',

        -- All the locations at which this lockup will spawn
        locations = {
            {
                coords = vec3(2484.687, 4125.216, 37.07),
                rotation = vec3(0, -0.5, -25.6),
                color = 9,

                -- Limit players of specific jobs to be able to access the lockups
                jobs = { 'unemployed' },

                -- Set a required item which player will need to have in their inventory to open the grow op
                requiredItem = 'access_card',
            },
            {
                coords = vec3(933.55, -2983.15, 4.90),
                rotation = vec3(0, 0, 90),
                color = 3,
            },
            {
                coords = vec3(1688.29, -1556.49, 111.65),
                rotation = vec3(0, 0, 65),
                color = 1,
            },
            {
                coords = vec3(-332.0, -1280.7, 30.31),
                rotation = vec3(0, 0, 269),
                color = 0,
            },
            {
                coords = vec3(699.33, -1161.37, 23.28),
                rotation = vec3(0, 0, 269),
                color = 0,
            },
            {
                coords = vec3(465.04, 3546.91, 32.25),
                rotation = vec3(0, -0.06, 267),
                color = 0,
            },
            {
                coords = vec3(300.34, 2893.95, 42.61),
                rotation = vec3(0, 0, 200),
                color = 4,
            },
            {
                coords = vec3(-2456.45, 2963.06, 31.81),
                rotation = vec3(0.95, 0, 223),
                color = 7,
            },
        },

        -- Information about the door of the lockup. No need to modify this
        door = {
            model = 'kq_weed_container_door',
            coords = vec3(-2.61, -3.4, -0.0),
            rotation = vec3(0, 0, 0)
        },
        -- The relative position of the interactions
        interactions = {
            lights = vec3(-2.15, 3.21, 1.56),
        },
        -- The relative placement of the tables
        tables = {
            {
                coords = vec3(-2.1, 0.4, 0.07),
                rotation = vec3(0, 0, 90),
            },
        },
        -- The relative placement of the presses
        presses = {
            {
                coords = vec3(-2.2, -1.3, 0.07),
                rotation = vec3(0, 0, 90),
            },
        },
        -- The relative placement of the pots
        pots = {
            -- Row A
            { optimal = true, showTent = false, autoWatering = false, coords = vec3(2, 2.5, 0.07),    rotation = vec3(0, 0, 180) },
            { optimal = true, showTent = false, autoWatering = false, coords = vec3(2, 1.75, 0.07),   rotation = vec3(0, 0, 180) },
            { optimal = true, showTent = false, autoWatering = false, coords = vec3(2, 1, 0.07),      rotation = vec3(0, 0, 180) },
            { optimal = true, showTent = false, autoWatering = false, coords = vec3(2, 0.25, 0.07),   rotation = vec3(0, 0, 180) },
            { optimal = true, showTent = false, autoWatering = false, coords = vec3(2, -0.5, 0.07),   rotation = vec3(0, 0, 180) },
            { optimal = true, showTent = false, autoWatering = false, coords = vec3(2, -1.25, 0.07),  rotation = vec3(0, 0, 180) },
            -- Row B
            { optimal = true, showTent = false, autoWatering = false, coords = vec3(0.2, 2.5, 0.07),  rotation = vec3(0, 0, 0) },
            { optimal = true, showTent = false, autoWatering = false, coords = vec3(0.2, 1.75, 0.07), rotation = vec3(0, 0, 0) },
            { optimal = true, showTent = false, autoWatering = false, coords = vec3(0.2, 1, 0.07),    rotation = vec3(0, 0, 0) },
            { optimal = true, showTent = false, autoWatering = false, coords = vec3(0.2, 0.25, 0.07), rotation = vec3(0, 0, 0) },
        },
        -- Randomized props which may spawn inside the lockup
        props = {
            {
                -- Chance of the prop spawning inside a location (seeded by its location)
                chance = 60,
                -- Possible models of the prop
                models = {
                    'hei_prop_hei_skid_chair',
                    'bkr_prop_weed_chair_01a',
                    'prop_chair_02',
                    'v_serv_abox_1',
                },
                -- Relative coordinates of the prop
                coords = vec3(1.85, -2.6, 0.07),
                rotation = vec3(0, 0, 210),
            },
            {
                chance = 65,
                models = {
                    'prop_rub_couch03',
                    'prop_rub_couch01',
                    'v_res_tre_sofa_mess_b',
                    'v_tre_sofa_mess_c_s',
                    'v_res_tre_sofa_s',
                    'v_res_d_sofa',
                    'v_res_j_sofa',
                    'v_ind_meatbench',
                    'v_ret_ml_beerlog2',
                },
                coords = vec3(0.1, -2.85, 0.07),
                rotation = vec3(0, 0, 181),
            },
            {
                chance = 60,
                model = 'prop_barrel_02b',
                coords = vec3(-2.25, 2.95, 0.07),
                rotation = vec3(0, 0, 240),
            },
            {
                chance = 60,
                model = 'prop_barrel_02b',
                coords = vec3(-2.25, 2.4, 0.07),
                rotation = vec3(0, 0, 30),
            },
            {
                chance = 30,
                model = 'prop_rub_binbag_04',
                coords = vec3(-1.5, 2.79, 0.02),
                rotation = vec3(20, 0, 140),
            },
            {
                chance = 50,
                models = {
                    'v_ind_cf_chckbox1',
                    'v_ind_meatboxsml_02',
                    'v_ind_cs_box02',
                },
                coords = vec3(-2.15, -0.13, 0.07),
                rotation = vec3(0, 0, 9),
            },
            {
                chance = 50,
                model = 'v_ind_cfbox2',
                coords = vec3(1.99, 3.0, 0.08),
                rotation = vec3(0, 0, 354),
            },
        },
    },
    ['container_2'] = {
        model = 'kq_weed_container_02',
        locations = {
            {
                coords = vec3(943.63, -2980.51, 4.90),
                rotation = vec3(0, 0, 270),
                color = 14,
            },
            {
                coords = vec3(1219.7, 354.82, 80.99),
                rotation = vec3(0, 0, 148),
                color = 3,
            },
            {
                coords = vec3(-68.65, -2414.24, 7.83),
                rotation = vec3(0, 0, 90),
                color = 1,
            },
            {
                coords = vec3(-679.46, -1172.38, 9.61),
                rotation = vec3(0, 0, 220),
                color = 2,
            },
            {
                coords = vec3(653.43, -1093.64, 24.18),
                rotation = vec3(0, 0, 181),
                color = 13,
            },
            {
                coords = vec3(-1666.72, 3120.59, 30.72),
                rotation = vec3(0, 0, 88),
                color = 10,
            },
            {
                coords = vec3(-3186.58, 1050.73, 19.91),
                rotation = vec3(0, 0, 67),
                color = 6,
            },
        },

        door = {
            model = 'kq_weed_container_door',
            coords = vec3(-2.61, -3.4, -0.0),
            rotation = vec3(0, 0, 0)
        },
        interactions = {
            lights = vec3(-2.15, 3.21, 1.56),
        },
        tables = {
            {
                coords = vec3(-2.1, 0.4, 0.07),
                rotation = vec3(0, 0, 90),
            }
        },
        presses = {
            {
                coords = vec3(-2.2, -1.3, 0.07),
                rotation = vec3(0, 0, 90),
            },
        },
        props = {
            {
                chance = 60,
                model = 'prop_barrel_02b',
                coords = vec3(-2.25, 2.95, 0.07),
                rotation = vec3(0, 0, 240),
            },
            {
                chance = 60,
                model = 'prop_barrel_02b',
                coords = vec3(-2.25, 2.4, 0.07),
                rotation = vec3(0, 0, 30),
            },
            {
                chance = 30,
                model = 'prop_rub_binbag_04',
                coords = vec3(-1.5, 2.79, 0.02),
                rotation = vec3(20, 0, 140),
            },
            {
                chance = 60,
                models = {
                    'prop_barrel_02b',
                    'v_corp_sidechair',
                    'bkr_prop_weed_chair_01a',
                },
                coords = vec3(-1.0, -2.95, 0.07),
                rotation = vec3(0, 0, 181),
            },
            {
                chance = 50,
                models = {
                    'v_ind_cf_chckbox1',
                    'v_ind_meatboxsml_02',
                    'v_ind_cs_box02',
                },
                coords = vec3(-2.15, -0.13, 0.07),
                rotation = vec3(0, 0, 9),
            },
        },
        pots = {
            -- Row A
            { optimal = true, showTent = false, autoWatering = false, coords = vec3(2.1, 3.5, 0.07),    rotation = vec3(0, 0, 270) },
            { optimal = true, showTent = false, autoWatering = false, coords = vec3(1.35, 3.5, 0.07),   rotation = vec3(0, 0, 270) },
            { optimal = true, showTent = false, autoWatering = false, coords = vec3(0.6, 3.5, 0.07),    rotation = vec3(0, 0, 270) },
            -- Row B
            { optimal = true, showTent = false, autoWatering = false, coords = vec3(2.1, 1.85, 0.07),   rotation = vec3(0, 0, 270) },
            { optimal = true, showTent = false, autoWatering = false, coords = vec3(1.35, 1.85, 0.07),  rotation = vec3(0, 0, 270) },
            { optimal = true, showTent = false, autoWatering = false, coords = vec3(0.6, 1.85, 0.07),   rotation = vec3(0, 0, 270) },
            -- Row C
            { optimal = true, showTent = false, autoWatering = false, coords = vec3(2.1, 0.2, 0.07),    rotation = vec3(0, 0, 270) },
            { optimal = true, showTent = false, autoWatering = false, coords = vec3(1.35, 0.2, 0.07),   rotation = vec3(0, 0, 270) },
            { optimal = true, showTent = false, autoWatering = false, coords = vec3(0.6, 0.2, 0.07),    rotation = vec3(0, 0, 270) },
            -- Row D
            { optimal = true, showTent = false, autoWatering = false, coords = vec3(2.1, -1.45, 0.07),  rotation = vec3(0, 0, 270) },
            { optimal = true, showTent = false, autoWatering = false, coords = vec3(1.35, -1.45, 0.07), rotation = vec3(0, 0, 270) },
            { optimal = true, showTent = false, autoWatering = false, coords = vec3(0.6, -1.45, 0.07),  rotation = vec3(0, 0, 270) },
        },
    },
    ['container_3'] = {
        model = 'kq_weed_container_03',
        locations = {
            {
                coords = vec3(316.43, -2934.90, 4.99),
                rotation = vec3(0, 0, 270),
                color = 0,
            },
            {
                coords = vec3(341.16, 3389.02, 35.40),
                rotation = vec3(0, 0, 110),
                color = 6,
            },
            {
                coords = vec3(689.41, 1286.04, 359.29),
                rotation = vec3(0, 0, 271),
                color = 7,
            },
            {
                coords = vec3(-39.69, -2237.61, 6.82),
                rotation = vec3(0, 0, 176),
                color = 4,
            },
            {
                coords = vec3(-805.73, -2847.07, 12.94),
                rotation = vec3(0, 0, 60),
                color = 8,
            },
            {
                coords = vec3(1150.44, -1277.24, 33.65),
                rotation = vec3(0, 0, 174),
                color = 1,
            },
            {
                coords = vec3(2791.66, 1408.73, 23.46),
                rotation = vec3(0, 0, 85),
                color = 13,
            },
            {
                coords = vec3(917.17, 3660.13, 31.59),
                rotation = vec3(-0.5, 1.8, 270),
                color = 14,
            },
            {
                coords = vec3(207.34, 6412.20, 30.34),
                rotation = vec3(0, 0, 111),
                color = 5,
            },
        },

        door = {
            model = 'kq_weed_container_door',
            coords = vec3(-2.61, -3.4, -0.0),
            rotation = vec3(0, 0, 0)
        },
        interactions = {
            lights = vec3(-2.5, -1.4, 1.57),
        },
        tables = {
            {
                coords = vec3(2.1, -1.4, 0.07),
                rotation = vec3(0, 0, 270),
            }
        },
        presses = {
            {
                coords = vec3(0.055, -2.95, 0.07),
                rotation = vec3(0, 0, 182),
            },
        },
        props = {
            {
                chance = 60,
                models = {
                    'prop_barrel_02b',
                    'bkr_prop_weed_chair_01a',
                },
                coords = vec3(-1.05, -2.95, 0.07),
                rotation = vec3(0, 0, 185),
            },
            {
                chance = 30,
                model = 'prop_rub_binbag_04',
                coords = vec3(-1.5, 2.78, 0.02),
                rotation = vec3(20, 0, 140),
            },
            {
                chance = 50,
                model = 'v_ind_cfbox2',
                coords = vec3(1.99, 3.0, 0.08),
                rotation = vec3(0, 0, 354),
            },
        },
        pots = {
            -- Row A
            { optimal = true, showTent = false, autoWatering = false, coords = vec3(2, 2.5, 0.07),      rotation = vec3(0, 0, 180) },
            { optimal = true, showTent = false, autoWatering = false, coords = vec3(2, 1.75, 0.07),     rotation = vec3(0, 0, 180) },
            { optimal = true, showTent = false, autoWatering = false, coords = vec3(2, 1, 0.07),        rotation = vec3(0, 0, 180) },
            -- Row B
            { optimal = true, showTent = false, autoWatering = false, coords = vec3(0.35, 2.5, 0.07),   rotation = vec3(0, 0, 0) },
            { optimal = true, showTent = false, autoWatering = false, coords = vec3(0.35, 1.75, 0.07),  rotation = vec3(0, 0, 0) },
            { optimal = true, showTent = false, autoWatering = false, coords = vec3(0.35, 1, 0.07),     rotation = vec3(0, 0, 0) },
            -- Row C
            { optimal = true, showTent = false, autoWatering = false, coords = vec3(-0.35, 2.5, 0.07),  rotation = vec3(0, 0, 180) },
            { optimal = true, showTent = false, autoWatering = false, coords = vec3(-0.35, 1.75, 0.07), rotation = vec3(0, 0, 180) },
            { optimal = true, showTent = false, autoWatering = false, coords = vec3(-0.35, 1, 0.08),    rotation = vec3(0, 0, 180) },
            -- Row D
            { optimal = true, showTent = false, autoWatering = false, coords = vec3(-2, 2.5, 0.07),     rotation = vec3(0, 0, 0) },
            { optimal = true, showTent = false, autoWatering = false, coords = vec3(-2, 1.75, 0.07),    rotation = vec3(0, 0, 0) },
            { optimal = true, showTent = false, autoWatering = false, coords = vec3(-2, 1, 0.07),       rotation = vec3(0, 0, 0) },
        },
    },
}
