
-- Colors of GrowOps containers
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

Config.growops = {
    ['main'] = {
        interior = {
            model = 'kq_weed_growop_int',
            offset = vec3(0.3, 4.78, -4.3),
        },

        -- The Z offset of the shell (interior) entity
        shellZOffset = 1400.0,

        -- All the locations at which this grow op will spawn
        locations = {
            {
                coords = vec3(878.97, -2378.29, 27.01),
                rotation = vec3(0, 0, 57),

                -- Limit players of specific jobs to be able to access the grow ops
                jobs = { 'unemployed'},

                -- Set a required item which player will need to have in their inventory to open the grow op
                requiredItem = 'access_card',

                color = 12,
            },
            {
                coords = vec3(1094.57, -2245.65, 29.30),
                rotation = vec3(0, 0, 170),
                color = 2,
            },
            {
                coords = vec3(1038.96, -2980.47, 4.90),
                rotation = vec3(0, 0, 270),
                color = 4,
            },
            {
                coords = vec3(829.63, 2171.94, 51.28),
                rotation = vec3(0.5, -0.25, 148),
                color = 12,
            },
            {
                coords = vec3(-415.02, -2752.08, 5.0),
                rotation = vec3(0, 0, 0),
                color = 15,
            },
            {
                coords = vec3(2350.77, 4878.22, 40.84),
                rotation = vec3(0, 0, 141),
                color = 0,
            },
            {
                coords = vec3(662.66, 3099.49, 42.99),
                rotation = vec3(-1.9, -0.7, 350),
                color = 6,
            },
            {
                coords = vec3(-64.10, 6405.16, 30.50),
                rotation = vec3(0, 0, 43),
                color = 3,
            },
        },

        -- The relative placement of the tables
        tables = {
            {
                coords = vec3(-7.35, 5.1, -5.23),
                rotation = vec3(0, 0, 90),
            },
            {
                coords = vec3(-6.2, 9.17, -5.23),
                rotation = vec3(0, 0, 0),
            },
        },

        -- The relative placement of the presses
        presses = {
            {
                coords = vec3(-3.27, 4.2, -5.23),
                rotation = vec3(0, 0, 183),
            },
            {
                coords = vec3(-4.9, 4.16, -5.23),
                rotation = vec3(0, 0, 179),
            },
        },
        -- The relative position of the interactions
        interactions = {
            cctv = vec3(2.15, 4.3, -4.2),
        },
        pots = {
            -- Row 1A
            { optimal = true, showTent = false, autoWatering = true, coords = vec3(-3.25, 21.0, -5.25), rotation = vec3(0, 0, 270) },
            { optimal = true, showTent = false, autoWatering = true, coords = vec3(-2.4, 21.0, -5.25),  rotation = vec3(0, 0, 270) },
            { optimal = true, showTent = false, autoWatering = true, coords = vec3(-1.55, 21.0, -5.25), rotation = vec3(0, 0, 270) },
            { optimal = true, showTent = false, autoWatering = true, coords = vec3(-0.7, 21.0, -5.25),  rotation = vec3(0, 0, 270) },
            -- Row 1B
            { optimal = true, showTent = false, autoWatering = true, coords = vec3(-3.25, 18.5, -5.25), rotation = vec3(0, 0, 90) },
            { optimal = true, showTent = false, autoWatering = true, coords = vec3(-2.4, 18.5, -5.25),  rotation = vec3(0, 0, 90) },
            { optimal = true, showTent = false, autoWatering = true, coords = vec3(-1.55, 18.5, -5.25), rotation = vec3(0, 0, 90) },
            { optimal = true, showTent = false, autoWatering = true, coords = vec3(-0.7, 18.5, -5.25),  rotation = vec3(0, 0, 90) },

            -- Row 2A
            { optimal = true, showTent = false, autoWatering = true, coords = vec3(3.75, 20.8, -5.25),  rotation = vec3(0, 0, 270) },
            { optimal = true, showTent = false, autoWatering = true, coords = vec3(2.9, 20.8, -5.25),   rotation = vec3(0, 0, 270) },
            { optimal = true, showTent = false, autoWatering = true, coords = vec3(2.05, 20.8, -5.25),  rotation = vec3(0, 0, 270) },
            { optimal = true, showTent = false, autoWatering = true, coords = vec3(1.2, 20.8, -5.25),   rotation = vec3(0, 0, 270) },
            -- Row 2B
            { optimal = true, showTent = false, autoWatering = true, coords = vec3(3.75, 18.3, -5.25),  rotation = vec3(0, 0, 90) },
            { optimal = true, showTent = false, autoWatering = true, coords = vec3(2.9, 18.3, -5.25),   rotation = vec3(0, 0, 90) },
            { optimal = true, showTent = false, autoWatering = true, coords = vec3(2.05, 18.3, -5.25),  rotation = vec3(0, 0, 90) },
            { optimal = true, showTent = false, autoWatering = true, coords = vec3(1.2, 18.3, -5.25),   rotation = vec3(0, 0, 90) },

            -- Row 3A
            { optimal = true, showTent = false, autoWatering = true, coords = vec3(3.65, 15.25, -5.23), rotation = vec3(0, 0, 180) },
            { optimal = true, showTent = false, autoWatering = true, coords = vec3(3.7, 14.45, -5.23),  rotation = vec3(0, 0, 180) },
            { optimal = true, showTent = false, autoWatering = true, coords = vec3(3.75, 13.65, -5.23), rotation = vec3(0, 0, 180) },
            { optimal = true, showTent = false, autoWatering = true, coords = vec3(3.8, 12.85, -5.23),  rotation = vec3(0, 0, 180) },
            -- Row 3B
            { optimal = true, showTent = false, autoWatering = true, coords = vec3(1, 15.25, -5.23),    rotation = vec3(0, 0, 0) },
            { optimal = true, showTent = false, autoWatering = true, coords = vec3(1.05, 14.45, -5.23), rotation = vec3(0, 0, 0) },
            { optimal = true, showTent = false, autoWatering = true, coords = vec3(1.1, 13.65, -5.23),  rotation = vec3(0, 0, 0) },
            { optimal = true, showTent = false, autoWatering = true, coords = vec3(1.15, 12.85, -5.23), rotation = vec3(0, 0, 0) },
        },
        props = {
            {
                model = 'prop_cctv_01_sm',
                coords = vec3(2.7, 4.18, -4.36),
                rotation = vec3(0, 0, 200),
            },
            {
                model = 'prop_cctv_unit_03',
                coords = vec3(2.05, 4.2, -4.36),
                rotation = vec3(0, 0, 177),
            },
            {
                model = 'prop_cctv_cont_04',
                coords = vec3(2.15, 4.2, -4.74),
                rotation = vec3(0, 0, 182),
            },
            {
                model = 'bkr_prop_weed_fan_floor_01a',
                coords = vec3(-3.5, 19.8, -5.24),
                rotation = vec3(0, 0, 85),
            },
            {
                model = 'bkr_prop_weed_fan_floor_01a',
                coords = vec3(2.54, 11.56, -5.24),
                rotation = vec3(0, 0, 172),
            },
            {
                model = 'bkr_prop_weed_fan_floor_01a',
                coords = vec3(4.01, 19.8, -5.24),
                rotation = vec3(0, 0, 273),
            },
            {
                model = 'xm3_prop_xm3_tank_water_01a',
                coords = vec3(-2.6, 14.1, -5.43),
                rotation = vec3(0, 0, 88),
            },
            {
                model = 'xm3_prop_xm3_tank_water_01a',
                coords = vec3(-2.62, 12.1, -5.43),
                rotation = vec3(0, 0, 91),
            },
            {
                chance = 45,
                models = {
                    'prop_generator_01a',
                },
                coords = vec3(-1.18, 4.46, -5.25),
                rotation = vec3(0, 0, 91),
            },
            {
                chance = 65,
                models = {
                    'prop_generator_01a',
                },
                coords = vec3(3.39, 16.64, -5.25),
                rotation = vec3(0, 0, 273),
            },
            {
                chance = 60,
                models = {
                    'hei_prop_hei_skid_chair',
                    'bkr_prop_weed_chair_01a',
                    'prop_chair_02',
                },
                coords = vec3(-1.8, 13.1, -5.25),
                rotation = vec3(0, 0, 110),
            },
            {
                chance = 40,
                models = {
                    'hei_prop_hei_skid_chair',
                    'bkr_prop_weed_chair_01a',
                    'prop_chair_02',
                },
                coords = vec3(-1.04, 10.68, -5.25),
                rotation = vec3(0, 0, 188),
            },
            {
                chance = 75,
                models = {
                    'xm3_prop_xm3_box_wood_01a',
                    'xm3_prop_xm3_rub_matress_01a',
                    'xm3_prop_xm3_crate_phac_01b',
                    'v_res_tre_sofa_mess_b',
                    'xm3_prop_xm3_tarp_roll_01a',
                    'xm3_prop_xm3_crate_01a',
                    'prop_portaloo_01a',
                },
                coords = vec3(3.3, 7.4, -5.25),
                rotation = vec3(0, 0, 265),
            },
            {
                chance = 75,
                models = {
                    'xm3_prop_xm3_box_wood_01a',
                    'xm3_prop_xm3_rub_matress_01a',
                    'xm3_prop_xm3_crate_phac_01b',
                    'xm3_prop_xm3_tarp_roll_01a',
                    'xm3_prop_xm3_crate_01a',
                },
                coords = vec3(-1.60, 16.12, -5.25),
                rotation = vec3(0, 0, 182),
            },
            {
                models = {
                    'hei_prop_hei_skid_chair',
                    'bkr_prop_weed_chair_01a',
                    'prop_chair_02',
                },
                coords = vec3(-7.45, 6.86, -5.26),
                rotation = vec3(0, 0, 91),
            },
            {
                models = {
                    'hei_prop_hei_skid_chair',
                    'bkr_prop_weed_chair_01a',
                    'prop_chair_02',
                },
                coords = vec3(2.7, 5.0, -5.26),
                rotation = vec3(0, 0, 335),
            },
            {
                chance = 80,
                models = {
                    'bkr_prop_weed_bucket_01c', 'bkr_prop_weed_bucket_open_01a', 'ng_proc_leaves07',
                    'p_ld_cable_tie_01_s', 'ng_proc_cigpak01c', 'ng_proc_cigbuts02a', 'gr_prop_gr_pliers_01',
                },
                coords = vec3(-2.99, 10.77, -5.25),
                rotation = vec3(0, 0, 41),
            },
            {
                chance = 80,
                models = {
                    'bkr_prop_weed_bucket_01c', 'bkr_prop_weed_bucket_open_01a', 'ng_proc_leaves07',
                    'p_ld_cable_tie_01_s', 'ng_proc_cigpak01c', 'ng_proc_cigbuts02a', 'gr_prop_gr_pliers_01',
                },
                coords = vec3(-2.95, 15.82, -5.25),
                rotation = vec3(0, 0, 144),
            },
            {
                chance = 80,
                models = {
                    'bkr_prop_weed_bucket_01c', 'bkr_prop_weed_bucket_open_01a', 'ng_proc_leaves07',
                    'p_ld_cable_tie_01_s', 'ng_proc_cigpak01c', 'ng_proc_cigbuts02a', 'gr_prop_gr_pliers_01',
                },
                coords = vec3(3.04, 15.55, -5.25),
                rotation = vec3(0, 0, 32),
            },
            {
                chance = 80,
                models = {
                    'bkr_prop_weed_bucket_01c', 'bkr_prop_weed_bucket_open_01a', 'ng_proc_leaves07',
                    'p_ld_cable_tie_01_s', 'ng_proc_cigpak01c', 'ng_proc_cigbuts02a', 'gr_prop_gr_pliers_01',
                },
                coords = vec3(2.52, 21.55, -5.25),
                rotation = vec3(0, 0, 231),
            },
            {
                chance = 80,
                models = {
                    'bkr_prop_weed_bucket_01c', 'bkr_prop_weed_bucket_open_01a', 'ng_proc_leaves07',
                    'p_ld_cable_tie_01_s', 'ng_proc_cigpak01c', 'ng_proc_cigbuts02a', 'gr_prop_gr_pliers_01',
                },
                coords = vec3(-0.9, 18.96, -5.25),
                rotation = vec3(0, 0, 83),
            },
            {
                chance = 80,
                models = {
                    'bkr_prop_weed_bucket_01c', 'bkr_prop_weed_bucket_open_01a', 'ng_proc_leaves07',
                    'p_ld_cable_tie_01_s', 'ng_proc_cigpak01c', 'ng_proc_cigbuts02a', 'gr_prop_gr_pliers_01',
                },
                coords = vec3(-2.87, 21.77, -5.25),
                rotation = vec3(0, 0, 55),
            },
            {
                chance = 80,
                models = {
                    'bkr_prop_weed_bucket_01c', 'bkr_prop_weed_bucket_open_01a', 'ng_proc_leaves07',
                    'p_ld_cable_tie_01_s', 'ng_proc_cigpak01c', 'ng_proc_cigbuts02a', 'gr_prop_gr_pliers_01',
                },
                coords = vec3(3.67, 10.29, -5.25),
                rotation = vec3(0, 0, 32),
            },
            {
                models = {
                    'bkr_prop_weed_pallet', 'xm3_prop_xm3_crate_01b',
                },
                coords = vec3(-3.56, 8.8, -5.24),
                rotation = vec3(0, 0, 184),
            },
        },
    },
}
