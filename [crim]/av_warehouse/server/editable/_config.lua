Config = Config or {}
Config.Warehouses = {
    [1] = {
        level = 0, -- Required gang level (only available with av_gangs)
        item = 'phone', -- Item required to hack door, can be false or string (with item name)
        delay = 5, -- Alarm delay, will trigger dispatch after X seconds of hacking the entry
        difficulty = "easy", -- We are gonna use it for the hacking minigame client/editable/minigame.lua
        junkChance = 5, -- Chance (in %) of getting an empty crate. 0 = never, 100 = always
        entry = {x = 1087.8193, y = -3099.2656, z = -39.0000, heading = 272.5342}, -- Coords where our players will be tp inside
        guards = { -- List of NPC spawn points
            coords = {
                {x = 1091.5337, y = -3101.4368, z = -39.0000, heading = 348.1691},
                {x = 1103.8145, y = -3098.7190, z = -39.0000, heading = 87.7853},
                {x = 1103.4929, y = -3101.6475, z = -39.0000, heading = 80.0659},
                {x = 1099.4677, y = -3101.2676, z = -39.0000, heading = 350.5373},
            },
            weapons = {`WEAPON_NIGHTSTICK`}
        },
        crates = {
            models = { -- possible models to spawn, each model have their own list of items in config/rewards.lua
                `ex_prop_crate_ammo_bc`,
                `ex_prop_crate_med_bc`,
                `ex_prop_crate_gems_bc`,
                `ex_prop_crate_jewels_bc`,
                `ex_prop_crate_elec_bc`,
            },
            coords = {
                {x = 1088.8560791016, y = -3096.9172363281, z = -39.999931335449, heading = -0.11377192288637},
                {x = 1091.4412841797, y = -3096.9020996094, z = -39.999931335449, heading = -0.13788075745106},
                {x = 1095.1683349609, y = -3096.9384765625, z = -39.999931335449, heading = 0.39875793457031},
                {x = 1097.6860351562, y = -3096.9018554688, z = -39.999931335449, heading = -0.76215708255768},
                {x = 1101.3677978516, y = -3096.8579101562, z = -39.999931335449, heading = -0.46050861477852},
                {x = 1103.9466552734, y = -3096.8701171875, z = -39.999931335449, heading = 0.7244274020195},
            },
        },
    },
    [2] = {
        level = 5, -- Required gang level (only available with av_gangs)
        item = 'phone', -- Item required to hack door, can be false or string (with item name)
        delay = 15, -- Alarm delay, will trigger dispatch after X seconds of hacking the entry
        difficulty = "medium", -- We are gonna use it for the hacking minigame client/editable/minigame.lua
        junkChance = 10, -- Chance (in %) of getting an empty crate. 0 = never, 100 = always
        entry = {x = 1071.8654, y = -3102.4680, z = -38.9999, heading = 91.1963}, -- Coords where our players will be tp inside
        guards = { -- List of NPC spawn points
            coords = {
                {x = 1050.3733, y = -3095.8257, z = -38.9999, heading = 184.3979},
                {x = 1056.4373, y = -3107.6733, z = -38.9999, heading = 339.6067},
                {x = 1057.0972, y = -3104.8442, z = -38.9999, heading = 272.7549},
                {x = 1053.3884, y = -3097.7043, z = -38.9999, heading = 267.1900},
                {x = 1057.1757, y = -3099.0315, z = -39.0000, heading = 103.9404},
                {x = 1055.2218, y = -3100.1763, z = -39.0000, heading = 24.0382},
            },
            weapons = {`WEAPON_PISTOL`, `WEAPON_COMBATPISTOL`, `WEAPON_HEAVYPISTOL`}
        },
        crates = { -- Coords to spawn crates
            models = { -- possible models to spawn, each model have their own list of items in config/rewards.lua
                `ex_prop_crate_biohazard_bc`,
                `ex_prop_crate_bull_bc_02`,
                `ex_prop_crate_ammo_bc`,
                `ex_prop_crate_med_bc`,
                `ex_prop_crate_gems_bc`,
                `ex_prop_crate_jewels_bc`,
                `ex_prop_crate_elec_bc`,
                `ex_prop_crate_narc_bc`,
                `ex_prop_crate_tob_bc`,
                `ex_prop_crate_ammo_bc`,
                `ex_prop_crate_art_02_bc`,
                `ex_prop_crate_money_bc`,
            },
            coords = {
                {x = 1052.95, 	 y = -3110.31,  z = -39.99,	heading = 180.0},
                {x = 1055.56, 	 y = -3110.26,	z = -39.99,	heading = 180.0},
                {x = 1057.91, 	 y = -3110.14,  z = -39.99,	heading = 180.0},
                {x = 1060.26, 	 y = -3110.37,  z = -39.99,	heading = 180.0},
                {x = 1062.74,    y = -3110.54,  z = -39.99,	heading = 180.0},
                {x = 1065.12,    y = -3110.50,  z = -39.99,	heading = 180.0},
                {x = 1067.44,    y = -3110.62,  z = -39.99,	heading = 180.0},
                {x = 1067.44, 	 y = -3102.73,  z = -39.99,	heading = 0.0},
                {x = 1065.25, 	 y = -3102.79,  z = -39.99,	heading = 0.0},
                {x = 1062.81, 	 y = -3103.26,  z = -39.99,	heading = 0.0},
                {x = 1060.10, 	 y = -3103.00,  z = -39.99,	heading = 0.0},
                {x = 1057.83, 	 y = -3103.01,  z = -39.99,	heading = 0.0},
                {x = 1055.58, 	 y = -3103.02,  z = -39.99,	heading = 0.0},
                {x = 1053.06,	 y = -3103.05,  z = -39.99,	heading = 0.0},
                {x = 1053.13, 	 y = -3095.97,  z = -39.99,	heading = 0.0},
                {x = 1055.64,    y = -3095.93,  z = -39.99,	heading = 0.0},
                {x = 1057.88,	 y = -3095.97,  z = -39.99,	heading = 0.0},
                {x = 1060.34,	 y = -3095.87,  z = -39.99,	heading = 0.0},
                {x = 1062.74,	 y = -3095.90,  z = -39.99,	heading = 0.0},
                {x = 1065.34,	 y = -3095.99,  z = -39.99,	heading = 0.0},
                {x = 1067.60,  	 y = -3095.97,  z = -39.99,	heading = 0.0},
            }
        }
    },
    [3] = {
        level = 10, -- Required gang level (only available with av_gangs)
        item = 'phone', -- Item required to hack door, can be false or string (with item name)
        delay = 20, -- Alarm delay, will trigger dispatch after X seconds of hacking the entry
        difficulty = "hard", -- We are gonna use it for the hacking minigame client/editable/minigame.lua
        junkChance = 15, -- Chance (in %) of getting an empty crate. 0 = never, 100 = always
        entry = {x = 1026.5428, y = -3101.5127, z = -38.9999, heading = 92.3786}, -- Coords where our players will be tp inside
        guards = { -- List of NPC spawn points
            coords = {
                {x = 996.2552, y = -3109.6580, z = -38.9999, heading = 298.8156},
                {x = 996.9420, y = -3107.3496, z = -38.9999, heading = 289.7617},
                {x = 998.0793, y = -3109.6956, z = -38.9999, heading = 66.6270},
                {x = 1003.0041, y = -3105.9934, z = -38.9999, heading = 267.7911},
                {x = 1003.3818, y = -3100.8245, z = -38.9999, heading = 263.4813},
                {x = 1003.6382, y = -3098.6606, z = -38.9999, heading = 215.2605},
                -- {x = 1003.1505, y = -3093.3157, z = -38.9999, heading = 179.6694},
                -- {x = 1003.4881, y = -3095.4502, z = -38.9999, heading = 351.9373},
                -- {x = 1014.1795, y = -3094.4780, z = -38.9999, heading = 255.3145},
                -- {x = 1015.7844, y = -3112.6060, z = -38.9999, heading = 20.4480},
                -- {x = 1002.7005, y = -3104.4285, z = -38.9999, heading = 182.4146},
            },
            weapons = {`WEAPON_APPISTOL`, `WEAPON_COMBATPISTOL`, `WEAPON_MICROSMG`}
        },
        crates = { -- Coords to spawn crates
            models = { -- possible models to spawn, each model have their own list of items in config/rewards.lua
                `ex_prop_crate_biohazard_bc`,
                `ex_prop_crate_bull_bc_02`,
                `ex_prop_crate_ammo_bc`,
                `ex_prop_crate_med_bc`,
                `ex_prop_crate_gems_bc`,
                `ex_prop_crate_jewels_bc`,
                `ex_prop_crate_elec_bc`,
                `ex_prop_crate_narc_bc`,
                `ex_prop_crate_tob_bc`,
                `ex_prop_crate_ammo_bc`,
                `ex_prop_crate_art_02_bc`,
                `ex_prop_crate_money_bc`,
            },
            coords = {
                {x = 1018.2597045898, y = -3092.142578125, z = -39.999885559082, heading = 0.83437275886536},
                {x = 1015.8544921875, y = -3092.1982421875, z = -39.999885559082, heading = 1.0261734724045},
                {x = 1013.3865966797, y = -3092.2126464844, z = -39.999885559082, heading = 0.36639931797981},
                {x = 1010.854675293, y = -3092.1611328125, z = -39.999885559082, heading = 0.35159158706665},
                {x = 1008.5658569336, y = -3092.1557617188, z = -39.999885559082, heading = 0.32515135407448},
                {x = 1006.0751342773, y = -3092.1953125, z = -39.999885559082, heading = 1.1193429231644},
                {x = 1003.7087402344, y = -3092.1889648438, z = -39.999885559082, heading = 0.98783910274506},
                {x = 1003.6380615234, y = -3097.3317871094, z = -39.999885559082, heading = 0.9671026468277},
                {x = 1006.0658569336, y = -3097.2780761719, z = -39.999885559082, heading = -178.64855957031},
                {x = 1008.4689941406, y = -3097.3459472656, z = -39.999885559082, heading = 0.43614929914474},
                {x = 1010.9038696289, y = -3097.3271484375, z = -39.999885559082, heading = 1.5150504112244},
                {x = 1013.2772827148, y = -3097.3500976562, z = -39.999885559082, heading = 0.83772754669189},
                {x = 1015.5533447266, y = -3097.2819824219, z = -39.999885559082, heading = 1.0265471935272},
                {x = 1018.0604248047, y = -3097.298828125, z = -39.999885559082, heading = -0.86660432815552},
                {x = 1018.0151977539, y = -3102.6335449219, z = -39.999885559082, heading = -178.89016723633},
                {x = 1015.6408691406, y = -3102.6044921875, z = -39.999885559082, heading = -179.48896789551},
                {x = 1013.2571411133, y = -3102.6350097656, z = -39.999885559082, heading = -179.26126098633},
                {x = 1010.8049926758, y = -3102.619140625, z = -39.999885559082, heading = -179.6284942627},
                {x = 1008.371887207, y = -3102.6176757812, z = -39.999885559082, heading = -179.81704711914},
                {x = 1005.9314575195, y = -3102.6452636719, z = -39.999885559082, heading = 179.55252075195},
                {x = 1003.5145263672, y = -3102.5610351562, z = -39.999885559082, heading = -178.66766357422},
                {x = 1003.5921630859, y = -3108.3293457031, z = -39.999885559082, heading = 179.99075317383},
                {x = 1005.9518432617, y = -3108.3352050781, z = -39.999885559082, heading = -179.01483154297},
                {x = 1008.3929443359, y = -3108.3515625, z = -39.999885559082, heading = -177.25373840332},
                {x = 1010.8093261719, y = -3108.265625, z = -39.999885559082, heading = -177.45234680176},
                {x = 1013.2337036133, y = -3108.2033691406, z = -39.999885559082, heading = -176.98515319824},
                {x = 1015.6265258789, y = -3108.1264648438, z = -39.999885559082, heading = -177.26519775391},
                {x = 1017.9808959961, y = -3108.0729980469, z = -39.999885559082, heading = -177.99014282227},
            },
        },
    },
}