Config = {} -- Do not touch


Config.SkillsCategory = "laptop" -- If you don't have devhub_skillTree that doesn't work.

Config.MaxTaskTime = 5 -- Time in minutes between processing the next person in the queue
Config.PersonalCooldownTime = 15 -- Personal cooldown time in minutes after completing a task

Config.Vehicle = {
    locations = { -- At the beginning of the task, the script will select a random location where the car is located.
        vec4(-1107.679077, -1632.606567, 4.797119, 124.724411),
        vec4(871.081299, 2868.606689, 57.098877, 22.677164),
        vec4(350.571442, 3393.336182, 36.626343, 294.803162),
        vec4(2546.808838, 4659.428711, 34.301147, 204.094498),
        vec4(28.2604, -212.2797, 52.8573, 69.0219),
        vec4(-1549.6887, -414.2633, 41.9899, 143.6337),
        vec4(2317.5430, 2506.8269, 46.2816, 80.1825),
        vec4(-2170.6348, 4273.6533, 48.9538, 145.2884),
    },
    models = {
        {
            model = GetHashKey("burrito"), -- vehicle model
            size = "small", -- vehicle size (small, medium, large)
            trunkDoors = { 2, 3 }, -- doors that will be detected as trunk
            gridConfig = { -- grid config for the vehicle
                zoneType = 'vehicle',
                vehicleOffsets = {
                    { x = -0.9, y = -2.5, z = -0.2 },
                    { x =  0.9, y = -2.5, z = -0.2 },
                    { x =  0.9, y =  0.0, z = -0.2 },
                    { x = -0.9, y =  0.0, z = -0.2 },
                }
            },
        },
        {
            model = GetHashKey("benson"), -- vehicle model
            size = "medium", -- vehicle size (small, medium, large)
            trunkDoors = { 2, 3 }, -- doors that will be detected as trunk
            gridConfig = { -- grid config for the vehicle
                zoneType = 'vehicle',
                vehicleOffsets = {
                    { x = -1.1, y = -5.25, z = 0.1 },
                    { x = 1.1, y = -5.25, z = 0.1 },
                    { x = 1.1, y = 0.45, z = 0.1 },
                    { x = -1.1, y = 0.45, z = 0.1 },
                }
            }
        },
        {
            model = GetHashKey("mule"), -- vehicle model
            size = "large", -- vehicle size (small, medium, large)
            trunkDoors = { 2, 3 }, -- doors that will be detected as trunk
            gridConfig = { -- grid config for the vehicle
                zoneType = 'vehicle',
                vehicleOffsets = {
                    { x = -1.3, y = -3.6, z = -0.1 },
                    { x =  1.3, y = -3.6, z = -0.1 },
                    { x =  1.3, y =  1.7, z = -0.1 },
                    { x = -1.3, y =  1.7, z = -0.1 },
                }
            }
        },
    },
    lockedByDefault = false, -- if true, the task vehicle spawns with locked doors (status 2). Set to false to leave it unlocked on spawn.
    blip = { -- blip config for the vehicle
        sprite = 326, -- blip sprite (https://docs.fivem.net/docs/game-references/blips/)
        color = 5, -- blip color (https://docs.fivem.net/docs/game-references/blips/)
        scale = 1.0, -- blip scale
        routeColor = 5, -- blip route color (https://docs.fivem.net/docs/game-references/blips/)
    },
    targets = {
        getRequiredItems = { -- target for getting required items
            animation = {
                lib = "anim@amb@range@weapon_test@",
                anim = "note_taking_02_amy_skater_01",
                duration = 2000, -- in ms
                canStop = false,
            },
            options = { -- target options
                icon = 'fa-solid fa-hand', -- target icon (https://fontawesome.com/icons)
            }
        },
        toggleTrunk = { -- target for toggling the trunk
            enable = true, -- If you don't have your own system to open/close the trunk, you need to set it to true.
            options = { -- target options
                icon = 'fa-solid fa-car-rear', -- target icon (https://fontawesome.com/icons)
            }
        },
        putObjectToCar = { -- target for putting an object to the car
            animation = {
                lib = "anim@heists@load_box",
                anim = "load_box_2",
                duration = 1000, -- in ms
            },
            options = { -- target options
                icon = "fa-solid fa-box", -- target icon (https://fontawesome.com/icons)
            }
        },
        removeObjectFromCar = { -- target for removing an object from the car
            animation = {
                lib = "mini@repair",
                anim = "fixing_a_ped",
                duration = 1000, -- in ms
            },
            options = { -- target options
                icon = "fa-solid fa-trash", -- target icon (https://fontawesome.com/icons)
            }
        },
    }
}

Config.CrimeScene = {} -- Do not touch

Config.CrimeScene.Blip = { -- blip config for the crime scene
    sprite = 310, -- blip sprite (https://docs.fivem.net/docs/game-references/blips/)
    color = 5, -- blip color (https://docs.fivem.net/docs/game-references/blips/)
    scale = 1.0, -- blip scale
    routeColor = 5, -- blip route color (https://docs.fivem.net/docs/game-references/blips/)
}

Config.CrimeScene.Locations = {
    {
        coords = vec3(1709.854980, 4804.061523, 41.782471), -- blip coords
        locations = { -- locations where things will be spawned
            vec4(1714.483521, 4800.342773, 41.765625, 351.496063),
            vec4(1716.079102, 4804.549316, 41.748779, 257.952759),
            vec4(1709.406616, 4797.666016, 41.866699, 283.46456),
            vec4(1703.076904, 4799.077148, 41.816162, 104.881889),
            vec4(1695.125244, 4792.812988, 41.917236, 104.881889),
            vec4(1692.039551, 4798.839355, 41.866699, 39.685040),
            vec4(1694.070312, 4807.622070, 41.849854, 331.653534),
            vec4(1699.556030, 4808.294434, 41.849854, 283.464569),
            vec4(1699.872559, 4802.676758, 41.799316, 170.078735),
            vec4(1699.872559, 4802.676758, 41.799316, 170.078735),
            vec4(1711.740723, 4809.283691, 41.849854, 308.976379),
            vec4(1718.545044, 4810.377930, 41.681274, 161.574799),
        },
        spawns = {
            ["small"] = { -- vehicle size
                peds = {1, 1}, -- min, max
                blood = {1, 1}, -- min, max
                crates = {2, 3}, -- min, max
                lootableObjects = {1, 1}, -- min, max
                bodyParts = {1, 1}, -- min, max
            },
            ["medium"] = { -- vehicle size
                peds = {1, 2}, -- min, max
                blood = {1, 1}, -- min, max
                crates = {2, 3}, -- min, max
                lootableObjects = {1, 1}, -- min, max
                bodyParts = {1, 2}, -- min, max
            },
            ["large"] = { -- vehicle size
                peds = {1, 2}, -- min, max
                blood = {1, 2}, -- min, max
                crates = {2, 3}, -- min, max
                lootableObjects = {1, 2}, -- min, max
                bodyParts = {1, 2}, -- min, max
            }
        }
    },
    {
        coords = vec3(-2326.9033, 301.7589, 169.4666), -- blip coords
        locations = { -- locations where things will be spawned
            vec4(-2330.1399, 302.2634, 169.4671, 54.7598),
            vec4(-2329.8501, 298.8517, 169.4671, 189.3972),
            vec4(-2325.7114, 290.8890, 169.4671, 221.1808),
            vec4(-2319.8396, 284.7934, 169.4671, 234.6365),
            vec4(-2321.7810, 278.8517, 169.4671, 108.5568),
            vec4(-2311.3171, 282.4395, 169.4671, 283.3190),
            vec4(-2314.1421, 290.0085, 169.4671, 28.3065),
            vec4(-2317.4944, 296.0239, 169.4671, 27.9902),
            vec4(-2322.7266, 298.5685, 169.4671, 93.8050),
            vec4(-2321.8750, 304.8698, 169.4671, 2.8914),
            vec4(-2326.9346, 305.3901, 169.4671, 92.7535),
            vec4(-2324.8564, 311.9330, 169.4671, 342.9397),
        },
        spawns = {
            ["small"] = { -- vehicle size
                peds = {1, 1}, -- min, max
                blood = {1, 1}, -- min, max
                crates = {2, 3}, -- min, max
                lootableObjects = {1, 1}, -- min, max
                bodyParts = {1, 1}, -- min, max
            },
            ["medium"] = { -- vehicle size
                peds = {1, 2}, -- min, max
                blood = {1, 1}, -- min, max
                crates = {2, 3}, -- min, max
                lootableObjects = {1, 1}, -- min, max
                bodyParts = {1, 2}, -- min, max
            },
            ["large"] = { -- vehicle size
                peds = {1, 2}, -- min, max
                blood = {1, 1}, -- min, max
                crates = {2, 3}, -- min, max
                lootableObjects = {1, 2}, -- min, max
                bodyParts = {2, 3}, -- min, max
            }
        }
    },
    {
        coords = vec3(-619.081299, -1596.435181, 26.735474), -- blip coords
        locations = { -- locations where things will be spawned
            vec4(-623.986816, -1593.454956, 26.735474, 2.834646),
            vec4(-622.747253, -1603.160400, 26.735474, 204.094498),
            vec4(-616.272522, -1604.017578, 26.735474, 283.464569),
            vec4(-610.127441, -1600.193359, 26.735474, 308.976379),
            vec4(-608.307678, -1593.995605, 26.735474, 337.322845),
            vec4(-606.474731, -1591.173584, 26.735474, 51.023624),
            vec4(-601.200012, -1585.806641, 26.735474, 357.165344),
            vec4(-608.439575, -1584.870361, 26.735474, 99.212593),
            vec4(-597.824158, -1584.778076, 26.735474, 255.118103),
            vec4(-597.824158, -1584.778076, 26.735474, 255.118103),
            vec4(-599.934082, -1587.652710, 26.735474, 161.574799),
            vec4(-613.898926, -1592.426392, 26.735474, 127.559052)
        },
        spawns = {
            ["small"] = { -- vehicle size
                peds = {1, 1}, -- min, max
                blood = {1, 1}, -- min, max
                crates = {2, 3}, -- min, max
                lootableObjects = {1, 1}, -- min, max
                bodyParts = {1, 1}, -- min, max
            },
            ["medium"] = { -- vehicle size
                peds = {1, 2}, -- min, max
                blood = {1, 1}, -- min, max
                crates = {2, 3}, -- min, max
                lootableObjects = {1, 1}, -- min, max
                bodyParts = {1, 2}, -- min, max
            },
            ["large"] = { -- vehicle size
                peds = {1, 2}, -- min, max
                blood = {1, 1}, -- min, max
                crates = {2, 3}, -- min, max
                lootableObjects = {1, 2}, -- min, max
                bodyParts = {2, 3}, -- min, max
            }
        }
    },
    {
        coords = vec3(-2039.7762, -267.0157, 23.3858), -- blip coords
        locations = { -- locations where things will be spawned
            vec4(-2038.0785, -259.2330, 23.3859, 359.2451),
            vec4(-2042.9850, -263.6904, 23.3860, 141.3378),
            vec4(-2047.9822, -267.4672, 23.3920, 117.8763),
            vec4(-2046.5640, -272.4933, 23.3903, 207.6071),
            vec4(-2041.1765, -275.5880, 23.3857, 239.7417),
            vec4(-2036.5897, -272.1884, 23.3857, 328.2956),
            vec4(-2040.0214, -268.7884, 23.3858, 55.5658),
            vec4(-2035.7115, -265.9792, 23.3859, 297.1022),
            vec4(-2029.2648, -264.0123, 23.3860, 320.6598),
            vec4(-2032.3075, -260.8514, 23.3860, 61.1051),
            vec4(-2028.6476, -259.5088, 23.3860, 330.0994),
            vec4(-2024.9456, -254.2130, 23.4169, 324.9347),
        },
        spawns = {
            ["small"] = { -- vehicle size
                peds = {1, 1}, -- min, max
                blood = {1, 1}, -- min, max
                crates = {2, 3}, -- min, max
                lootableObjects = {1, 1}, -- min, max
                bodyParts = {1, 1}, -- min, max
            },
            ["medium"] = { -- vehicle size
                peds = {1, 2}, -- min, max
                blood = {1, 1}, -- min, max
                crates = {2, 3}, -- min, max
                lootableObjects = {1, 1}, -- min, max
                bodyParts = {1, 2}, -- min, max
            },
            ["large"] = { -- vehicle size
                peds = {1, 2}, -- min, max
                blood = {1, 1}, -- min, max
                crates = {2, 3}, -- min, max
                lootableObjects = {1, 2}, -- min, max
                bodyParts = {2, 3}, -- min, max
            }
        }
    },
    {
        coords = vec3(720.1696, -1294.8545, 26.2079), -- blip coords
        locations = { -- locations where things will be spawned
            vec4(716.9884, -1299.1866, 25.9823, 167.7346),
            vec4(720.2134, -1305.2349, 26.1373, 242.2842),
            vec4(726.9337, -1307.2738, 26.2944, 254.5774),
            vec4(728.1393, -1299.3602, 26.2848, 2.5977),
            vec4(728.2637, -1289.3162, 26.2842, 1.6296),
            vec4(730.3595, -1283.8737, 26.2852, 351.7017),
            vec4(724.6031, -1282.6592, 26.2842, 94.1014),
            vec4(715.6114, -1281.8970, 26.0442, 88.2450),
            vec4(715.6461, -1288.4077, 25.9902, 196.2773),
            vec4(722.6031, -1291.5394, 26.2917, 256.4791),
            vec4(722.3184, -1296.9784, 26.2632, 179.7817),
            vec4(712.1640, -1290.2767, 25.9631, 359.8041),
        },
        spawns = {
            ["small"] = { -- vehicle size
                peds = {1, 1}, -- min, max
                blood = {1, 1}, -- min, max
                crates = {2, 3}, -- min, max
                lootableObjects = {1, 1}, -- min, max
                bodyParts = {1, 1}, -- min, max
            },
            ["medium"] = { -- vehicle size
                peds = {1, 2}, -- min, max
                blood = {1, 1}, -- min, max
                crates = {2, 3}, -- min, max
                lootableObjects = {1, 1}, -- min, max
                bodyParts = {1, 2}, -- min, max
            },
            ["large"] = { -- vehicle size
                peds = {1, 2}, -- min, max
                blood = {1, 1}, -- min, max
                crates = {2, 3}, -- min, max
                lootableObjects = {1, 2}, -- min, max
                bodyParts = {2, 3}, -- min, max
            }
        }
    },
    {
        coords = vec3(-65.9656, 6401.2466, 31.4903), -- blip coords
        locations = { -- locations where things will be spawned
            vec4(-66.3795, 6400.8047, 31.4903, 139.9885),
            vec4(-71.5193, 6395.5620, 31.4903, 136.9953),
            vec4(-74.8545, 6391.8999, 31.4904, 140.5251),
            vec4(-77.4038, 6385.4854, 31.4906, 219.5529),
            vec4(-73.5599, 6386.1929, 31.4904, 315.8796),
            vec4(-72.5692, 6390.7769, 31.4904, 322.4902),
            vec4(-66.5329, 6391.9097, 31.4904, 282.8100),
            vec4(-61.3872, 6390.5918, 31.4901, 30.0007),
            vec4(-58.8434, 6393.8491, 31.4903, 306.3770),
            vec4(-53.7951, 6400.3701, 31.4903, 356.5938),
            vec4(-57.9619, 6402.0015, 31.4903, 161.1074),
            vec4(-53.2541, 6407.4844, 31.4903, 35.7649),
        },
        spawns = {
            ["small"] = { -- vehicle size
                peds = {1, 1}, -- min, max
                blood = {1, 1}, -- min, max
                crates = {2, 3}, -- min, max
                lootableObjects = {1, 1}, -- min, max
                bodyParts = {1, 1}, -- min, max
            },
            ["medium"] = { -- vehicle size
                peds = {1, 2}, -- min, max
                blood = {1, 1}, -- min, max
                crates = {2, 3}, -- min, max
                lootableObjects = {1, 1}, -- min, max
                bodyParts = {1, 2}, -- min, max
            },
            ["large"] = { -- vehicle size
                peds = {1, 2}, -- min, max
                blood = {1, 1}, -- min, max
                crates = {2, 3}, -- min, max
                lootableObjects = {1, 2}, -- min, max
                bodyParts = {2, 3}, -- min, max
            }
        }
    },
    {
        coords = vec3(1873.6587, 287.6003, 164.2738), -- blip coords
        locations = { -- locations where things will be spawned
            vec4(1868.7169, 287.9854, 164.2740, 154.2518),
            vec4(1865.2745, 280.5341, 164.2741, 156.4165),
            vec4(1866.2660, 273.7192, 164.2741, 211.8129),
            vec4(1873.4414, 270.9250, 164.2741, 268.9897),
            vec4(1872.6036, 275.4343, 164.2741, 42.2265),
            vec4(1876.9095, 279.0217, 164.2741, 291.0647),
            vec4(1882.3257, 283.9126, 164.2741, 314.4315),
            vec4(1886.0844, 288.6284, 164.2741, 283.6878),
            vec4(1885.7750, 293.5342, 164.2738, 50.4842),
            vec4(1880.4709, 293.8760, 164.3002, 136.9581),
            vec4(1876.6281, 286.6211, 164.2743, 145.9943),
            vec4(1871.5928, 280.0209, 164.3040, 140.8031),
        },
        spawns = {
            ["small"] = { -- vehicle size
                peds = {1, 1}, -- min, max
                blood = {1, 1}, -- min, max
                crates = {2, 3}, -- min, max
                lootableObjects = {1, 1}, -- min, max
                bodyParts = {1, 1}, -- min, max
            },
            ["medium"] = { -- vehicle size
                peds = {1, 2}, -- min, max
                blood = {1, 1}, -- min, max
                crates = {2, 3}, -- min, max
                lootableObjects = {1, 1}, -- min, max
                bodyParts = {1, 2}, -- min, max
            },
            ["large"] = { -- vehicle size
                peds = {1, 2}, -- min, max
                blood = {1, 1}, -- min, max
                crates = {2, 3}, -- min, max
                lootableObjects = {1, 2}, -- min, max
                bodyParts = {2, 3}, -- min, max
            }
        }
    },
}

Config.CrimeScene.CarryingObjects = {
    putDownButton = 73 -- Keybind to put down a carried object (https://docs.fivem.net/docs/game-references/controls/)
}

Config.CrimeScene.Objects = {
    ["peds"] = {
        models = { -- models for the peds
            "s_m_y_armymech_01",
            "s_m_m_autoshop_02",
            "ig_bankman",
            "a_m_m_business_01",
            "s_m_o_busker_01",
            "ig_barry",
            "ig_ballasog",
            "g_m_y_ballasout_01",
            "u_m_m_bankman",
            "g_m_y_famca_01",
            "g_m_y_famdnf_01",
            "a_m_y_eastsa_02",
            "csb_chin_goon",
            "s_m_m_chemsec_01",
        },
        
        requiredItem = "devhub_bodybag", -- required item for the packaging
        
        packaging = {
            animation = {
                lib = "amb@medic@standing@tendtodead@idle_a",
                anim = "idle_a"
            },
            
            duration = 5000, -- duration of the packaging animation in ms
            canStop = false,
            
            targetIcon = "fa-solid fa-box", -- target icon (https://fontawesome.com/icons)
        },

        packedModel = "xm_prop_body_bag", -- model of the packed ped

        lifting = {
            animation = {
                lib = "anim@heists@load_box",
                anim = "lift_box"
            },

            duration = 2000, -- duration of the lifting animation in ms
            canStop = false,

            targetIcon = "fa-solid fa-box", -- target icon (https://fontawesome.com/icons)
        },

        carrying = {
            animation = {
                lib = "anim@heists@box_carry@",
                anim = "idle"
            },

            attach = {
                offset = vec3(0.3, -0.2, -0.15), -- offset of the ped
                rotation = vec3(6, 24, -89), -- rotation of the ped
                bone = 28422, -- bone of the ped
            }
        }
    },
    ["crates"] = {
        models = { -- models for the crates
            {
                model = "hei_prop_heist_emp", -- model of the crate
                attach = {
                    offset = vec3(0.0, -0.2, 0.15), -- offset of the crate
                    rotation = vec3(6, 24, -89), -- rotation of the crate
                    bone = 28422, -- bone of the crate
                }
            },
            {
                model = "sm_prop_smug_crate_s_bones", -- model of the crate
                attach = {
                    offset = vec3(0.0, -0.4, 0.04), -- offset of the crate
                    rotation = vec3(30, 0, 0), -- rotation of the crate
                    bone = 28422, -- bone of the crate
                }
            },
            {
                model = "ex_prop_adv_case_sm", -- model of the crate
                attach = {
                    offset = vec3(0.0, -0.3, 0.04), -- offset of the crate
                    rotation = vec3(6, 32, -89), -- rotation of the crate
                    bone = 28422, -- bone of the crate
                }
            },
            {
                model = "sf_prop_sf_weed_bigbag_01a", -- model of the crate
                attach = {
                    offset = vec3(0.0, -0.2, -0.2), -- offset of the crate
                    rotation = vec3(4, 24, -89), -- rotation of the crate
                    bone = 28422, -- bone of the crate
                }
            },
            -- {
            --     model = "m23_2_prop_m32_bag_weapons_01a", -- model of the crate
            --     attach = {
            --         offset = vec3(0.0, -0.1, -0.14), -- offset of the crate
            --         rotation = vec3(24, -3, 0), -- rotation of the crate
            --         bone = 28422, -- bone of the crate
            --     }
            -- },
            {
                model = "ex_office_swag_drugbags", -- model of the crate
                attach = {
                    offset = vec3(0.0, -0.1, -0.15), -- offset of the crate
                    rotation = vec3(24, -3, 0), -- rotation of the crate
                    bone = 28422, -- bone of the crate
                }
            },
            {
                model = "ex_office_swag_ivory2", -- model of the crate
                attach = {
                    offset = vec3(0.0, -0.1, 0.0), -- offset of the crate
                    rotation = vec3(6, 40, -89), -- rotation of the crate
                    bone = 28422, -- bone of the crate
                }
            },
            {
                model = "prop_mp_drug_pack_red", -- model of the crate
                attach = {
                    offset = vec3(0.0, -0.2, -0.05), -- offset of the crate
                    rotation = vec3(32, -3, 0.0), -- rotation of the crate
                    bone = 28422, -- bone of the crate
                }
            },
            {
                model = "ch_prop_ch_crate_empty_01a", -- model of the crate
                attach = {
                    offset = vec3(0.0, -0.2, -0.2), -- offset of the crate
                    rotation = vec3(40, -3, 0), -- rotation of the crate
                    bone = 28422, -- bone of the crate
                }
            },
            {
                model = "bkr_prop_biker_case_shut", -- model of the crate
                attach = {
                    offset = vec3(0.0, -0.2, -0.15), -- offset of the crate
                    rotation = vec3(30, 0, 0), -- rotation of the crate
                    bone = 28422, -- bone of the crate
                }
            },
            {
                model = "h4_prop_h4_case_supp_01a", -- model of the crate
                attach = {
                    offset = vec3(0.0, -0.1, -0.15), -- offset of the crate
                    rotation = vec3(30, 0, 0), -- rotation of the crate
                    bone = 28422, -- bone of the crate
                }
            },
            {
                model = "prop_box_guncase_02a", -- model of the crate
                attach = {
                    offset = vec3(0.0, -0.1, -0.2), -- offset of the crate
                    rotation = vec3(0, 0, 0.0), -- rotation of the crate
                    bone = 28422, -- bone of the crate
                }
            },
            {
                model = "hei_p_attache_case_shut_s", -- model of the crate
                attach = {
                    offset = vec3(0.0, -0.2, -0.15), -- offset of the crate
                    rotation = vec3(30, 0, 0), -- rotation of the crate
                    bone = 28422, -- bone of the crate
                }
            },
            {
                model = "prop_ld_case_01_s", -- model of the crate
                attach = {
                    offset = vec3(0.0, 0.1, 0.0), -- offset of the crate
                    rotation = vec3(-70, 0, 0), -- rotation of the crate
                    bone = 28422, -- bone of the crate
                }
            },
            {
                model = "sf_prop_sf_flightcase_01b", -- model of the crate
                attach = {
                    offset = vec3(0.0, -0.2, -0.15), -- offset of the crate
                    rotation = vec3(6, 24, -89), -- rotation of the crate
                    bone = 28422, -- bone of the crate
                }
            },
            {
                model = "sf_prop_sf_flightcase_01c", -- model of the crate
                attach = {
                    offset = vec3(0.0, -0.2, -0.15), -- offset of the crate
                    rotation = vec3(6, 24, -89), -- rotation of the crate
                    bone = 28422, -- bone of the crate
                }
            },
            {
                model = "prop_suitcase_03b", -- model of the crate
                attach = {
                    offset = vec3(0.0, -0.15, 0.05), -- offset of the crate
                    rotation = vec3(-90, 24, -89), -- rotation of the crate
                    bone = 28422, -- bone of the crate
                }
            },
            {
                model = "tr_prop_tr_adv_case_01a", -- model of the crate
                attach = {
                    offset = vec3(0.0, -0.4, 0.05), -- offset of the crate
                    rotation = vec3(5, 32, -89), -- rotation of the crate
                    bone = 28422, -- bone of the crate
                }
            },
        },
     
        lifting = {
            animation = {
                lib = "anim@heists@load_box",
                anim = "lift_box"
            },

            duration = 2000, -- duration of the lifting animation in ms
            canStop = false,

            targetIcon = "fa-solid fa-box", -- target icon (https://fontawesome.com/icons)
        },

        carrying = {
            animation = {
                lib = "anim@heists@box_carry@",
                anim = "idle"
            },
        }
    },
    ["bodyParts"] = {
        models = { -- models for the body parts
            "v_ilev_body_parts"
        },
        
        requiredItem = "devhub_binbag", -- required item for the packaging
        
        packaging = {
            animation = {
                lib = "amb@medic@standing@tendtodead@idle_a",
                anim = "idle_a"
            },
            
            duration = 5000, -- duration of the packaging animation in ms
            canStop = false,
            
            targetIcon = "fa-solid fa-box", -- target icon (https://fontawesome.com/icons)
        },

        packedModel = "hei_prop_heist_binbag", -- model of the packed body parts

        lifting = {
            animation = {
                lib = "anim@heists@load_box",
                anim = "lift_box"
            },

            duration = 2000, -- duration of the lifting animation in ms
            canStop = false,

            targetIcon = "fa-solid fa-box", -- target icon (https://fontawesome.com/icons)
        },

        carrying = {
            animation = {
                lib = "anim@heists@narcotics@trash",
                anim = "walk"
            },

            attach = {
                offset = vec3(0.12, 0.0, 0.00), -- offset of the body parts
                rotation = vec3(0.0, 270.0, 0.0), -- rotation of the body parts
                bone = 57005, -- bone of the body parts
            }
        }
    },
    ["lootableObjects"] = {
        models = {
            {
                model = "ba_prop_battle_crate_art_02_bc", -- model of the lootable object
                loot = { -- loot for the lootable object
                    { 
                        item = "devhub_antiquevase", -- item name
                        count = { 1, 2 } -- min, max
                    },
                    -- { 
                    --     item = "water", -- item name
                    --     count = { 1, 2 } -- min, max
                    -- }
                },
            },
            {
                model = "sm_prop_smug_crate_l_narc", -- model of the lootable object
                loot = { -- loot for the lootable object
                    { 
                        item = "devhub_antiquevase", -- item name
                        count = { 1, 2 } -- min, max
                    },
                    -- { 
                    --     item = "water", -- item name
                    --     count = { 1, 2 } -- min, max
                    -- }
                }
            },
            {
                model = "ex_prop_crate_wlife_bc", -- model of the lootable object
                loot = { -- loot for the lootable object
                    { 
                        item = "devhub_antiquevase", -- item name
                        count = { 1, 2 } -- min, max
                    },
                    -- { 
                    --     item = "water", -- item name
                    --     count = { 1, 2 } -- min, max
                    -- }
                }
            },
            {
                model = "sm_prop_smug_crate_l_hazard", -- model of the lootable object
                loot = { -- loot for the lootable object
                    { 
                        item = "devhub_antiquevase", -- item name
                        count = { 1, 2 } -- min, max
                    },
                    -- { 
                    --     item = "water", -- item name
                    --     count = { 1, 2 } -- min, max
                    -- }
                }
            },
            {
                model = "ba_prop_battle_crate_gems_bc", -- model of the lootable object
                loot = { -- loot for the lootable object
                    { 
                        item = "devhub_antiquevase", -- item name
                        count = { 1, 2 } -- min, max
                    },
                    -- { 
                    --     item = "water", -- item name
                    --     count = { 1, 2 } -- min, max
                    -- }
                }
            },
            {
                model = "ex_prop_crate_pharma_sc", -- model of the lootable object
                loot = { -- loot for the lootable object
                    { 
                        item = "devhub_antiquevase", -- item name
                        count = { 1, 2 } -- min, max
                    },
                    -- { 
                    --     item = "water", -- item name
                    --     count = { 1, 2 } -- min, max
                    -- }
                }
            },
            {
                model = "sm_prop_smug_crate_l_fake", -- model of the lootable object
                loot = { -- loot for the lootable object
                    { 
                        item = "devhub_antiquevase", -- item name
                        count = { 1, 2 } -- min, max
                    },
                    -- { 
                    --     item = "water", -- item name
                    --     count = { 1, 2 } -- min, max
                    -- }
                }
            },
            {
                model = "ex_prop_crate_med_bc", -- model of the lootable object
                loot = { -- loot for the lootable object
                    { 
                        item = "devhub_antiquevase", -- item name
                        count = { 1, 2 } -- min, max
                    },
                    -- { 
                    --     item = "water", -- item name
                    --     count = { 1, 2 } -- min, max
                    -- }
                }
            },
            {
                model = "ex_prop_crate_jewels_racks_bc", -- model of the lootable object
                loot = { -- loot for the lootable object
                    { 
                        item = "devhub_antiquevase", -- item name
                        count = { 1, 2 } -- min, max
                    },
                    -- { 
                    --     item = "water", -- item name
                    --     count = { 1, 2 } -- min, max
                    -- }
                }
            },
            {
                model = "ex_prop_crate_med_sc", -- model of the lootable object
                loot = { -- loot for the lootable object
                    { 
                        item = "devhub_antiquevase", -- item name
                        count = { 1, 2 } -- min, max
                    },
                    -- { 
                    --     item = "water", -- item name
                    --     count = { 1, 2 } -- min, max
                    -- }
                }
            },
            {
                model = "sm_prop_smug_crate_m_jewellery", -- model of the lootable object
                loot = { -- loot for the lootable object
                    { 
                        item = "devhub_antiquevase", -- item name
                        count = { 1, 2 } -- min, max
                    },
                    -- { 
                    --     item = "water", -- item name
                    --     count = { 1, 2 } -- min, max
                    -- }
                }
            },
            {
                model = "ex_prop_crate_pharma_bc", -- model of the lootable object
                loot = { -- loot for the lootable object
                    { 
                        item = "devhub_antiquevase", -- item name
                        count = { 1, 2 } -- min, max
                    },
                    -- { 
                    --     item = "water", -- item name
                    --     count = { 1, 2 } -- min, max
                    -- }
                }
            },
            {
                model = "ba_prop_battle_crate_m_hazard", -- model of the lootable object
                loot = { -- loot for the lootable object
                    { 
                        item = "devhub_antiquevase", -- item name
                        count = { 1, 2 } -- min, max
                    },
                    -- { 
                    --     item = "water", -- item name
                    --     count = { 1, 2 } -- min, max
                    -- }
                }
            },
            {
                model = "ba_prop_battle_crate_m_bones", -- model of the lootable object
                loot = { -- loot for the lootable object
                    { 
                        item = "devhub_antiquevase", -- item name
                        count = { 1, 2 } -- min, max
                    },
                    -- { 
                    --     item = "water", -- item name
                    --     count = { 1, 2 } -- min, max
                    -- }
                },
                uniqueLoot = { -- If you don't have devhub_skillTree that doesn't work. Chance you can set in skill tree
                    item = "weapon_pistol", -- item name
                    count = { 1, 2 } -- min, max
                }
            },
        },

        looting = {
            animation = {
                lib = "amb@medic@standing@tendtodead@idle_a",
                anim = "idle_a"
            },
            
            duration = 5000, -- duration of the looting animation in ms
            canStop = false,
            
            targetIcon = "fa-solid fa-box", -- target icon (https://fontawesome.com/icons)
        },

        burn = {
            duration = 5000, -- duration of the setting fire animation in ms
            canStop = false,
            
            targetIcon = "fa-solid fa-fire", -- target icon (https://fontawesome.com/icons)
        }
    },
    ["blood"] = {
        models = {
            {
                model = "p_bloodsplat_s", -- model of the blood object
                rotation = vec3(-90.0, 0.0, 0.0), -- rotation of the blood object
                offset = vec3(0, 0, -0.25) -- offset of the blood object
            },
        },

        defaultAlpha = 80, -- default alpha of the blood object
        minDistance = 10.0, -- Minimum distance at which the UV flashlight works

        uvFlashlightWeapon = "WEAPON_POCKETLIGHT", -- weapon that will be used to see the blood

        cleaning = {
            animation = {
                lib = "move_mop",
                anim = "idle_scrub_small_player",

                animationObjectModel = GetHashKey("prop_cs_mop_s"), -- model of the mop
                objectAttach = {
                    offset = vec3(0, 0, 0.12), -- offset of the mop
                    rotation = vec3(0, 0, 0), -- rotation of the mop
                    bone = 28422, -- bone of the mop
                }
            },

            duration = 5000, -- duration of the cleaning animation in ms
            canStop = false,

            targetIcon = "fa-solid fa-broom", -- target icon (https://fontawesome.com/icons)

            requiredItem = "devhub_cleaningkit", -- required item for the cleaning
        },

        resetTime = 15000 -- duration of the reset time blood alpha in ms
    }
}

Config.VehicleDisposal = {
    ["burn"] = {
        enable = true,
        locations = { -- locations of the burn vehicle disposal
            {
                petrolCanCoords = vec4(2102.017578, 4626.474609, 34.402222, 201.259842),
                vehicleCoords = vec4(2094.514404, 4626.290039, 35.143555, 136.062988),
            },
            {
                petrolCanCoords = vec4(-738.474731, 5753.485840, 11.941406, 229.606293),
                vehicleCoords = vec4(-743.789001, 5746.786621, 10.374390, 252.283463),
            }
        },
        
        blip = {
            sprite = 361, -- sprite of the blip (https://docs.fivem.net/docs/game-references/blips/)
            color = 5, -- color of the blip (https://docs.fivem.net/docs/game-references/blips/)
            scale = 1.0, -- blip scale
            routeColor = 5, -- blip route color (https://docs.fivem.net/docs/game-references/blips/)
        },
        
        petrolCanModel = GetHashKey("w_am_jerrycan"), -- model of the petrol can

        targets = {
            getPetrolCan = { -- target for getting the petrol can
                animation = {
                    lib = "anim@heists@load_box",
                    anim = "lift_box"
                },
                
                duration = 2000, -- duration of the animation in ms
                canStop = false,
                
                icon = "fa-solid fa-hand", -- target icon (https://fontawesome.com/icons)
                radius = 0.5, -- radius of the target
            },
            pourPetrolCan = { -- target for pouring the petrol can
                animation = {
                    lib = "weapons@misc@jerrycan@",
                    anim = "fire",
                },
    
                duration = 10000, -- duration of the animation in ms
                canStop = false,
    
                icon = "fa-solid fa-gas-pump", -- target icon (https://fontawesome.com/icons)

                attach = {
                    offset = vec3(0.1, 0.05, -0.3), -- offset of the petrol can
                    rotation = vec3(204, -27, -32), -- rotation of the petrol can
                    bone = 57005, -- bone of the petrol can
                }
            },
        },

        holdingPetrolCan = { -- target for holding the petrol can
            animation = {
                lib = "move_weapon@jerrycan@generic",
                anim = "idle",
            },
            attach = {
                offset = vec3(0.3, 0, 0), -- offset of the petrol can
                rotation = vec3(-86,-34,87), -- rotation of the petrol can
                bone = 57005, -- bone of the petrol can
            }
        },

        timeBeforeExplosion = 10000, -- duration of the time before explosion in ms
    },
    ["push_off_cliff"] = {
        enable = false,
        locations = { -- locations of the push off cliff vehicle disposal
            {
                vehicleCoords = vec4(-3103.898926, 1743.125244, 35.008789, 73.700790),
                cameraOffset = vec3(-8.0, -6.0, 6.0),
                cameraAnimationTime = 2000, -- duration of the camera animation in ms
                pushingValues = {
                    pushingTime = 4000, -- duration of the pushing animation in ms
                    timeBeforeExplosion = 3000, -- duration of the time before explosion in ms
                    forceMagnitude = 30.0, -- force magnitude of the vehicle after pushing
                },
            },
            {
                vehicleCoords = vec4(-2110.918701, 4374.052734, 113.781738, 17.007874),
                cameraOffset = vec3(-8.0, -6.0, 6.0),
                cameraAnimationTime = 2000, -- duration of the camera animation in ms
                pushingValues = {
                    pushingTime = 4000, -- duration of the pushing animation in ms
                    timeBeforeExplosion = 3000, -- duration of the time before explosion in ms
                    forceMagnitude = 30.0, -- force magnitude of the vehicle after pushing
                },
            },
        },

        blip = {
            sprite = 515, -- sprite of the blip (https://docs.fivem.net/docs/game-references/blips/)
            color = 5, -- color of the blip (https://docs.fivem.net/docs/game-references/blips/)
            scale = 1.0, -- blip scale
            routeColor = 5, -- blip route color (https://docs.fivem.net/docs/game-references/blips/)
        },

        targetVehiclePositionMarker = {
            type = 1,
            color = { r = 253, g = 209, b = 64, a = 200 }, -- red, green, blue, alpha
            size = vec3(10.0, 10.0, 2.0), -- size of the marker
            rotation = vec3(0.0, 0.0, 0.0), -- rotation of the marker
            direction = vec3(0.0, 0.0, 0.0), -- direction of the marker
        },

        pushVehicleTarget = { -- target for pushing the vehicle off the cliff
            animation = {
                lib = "missfinale_c2ig_11",
                anim = "pushcar_offcliff_m",
            },

            targetIcon = "fa-solid fa-hand", -- target icon (https://fontawesome.com/icons)
        },
    },
    ["drown"] = {
        enable = false,
        locations = { -- locations of the drown vehicle disposal
            {
                vehicleCoords = vec4(-1466.545044, 5418.909668, 23.702515, 62.362206),
                cameraOffset = vec3(-8.0, -6.0, 6.0),
                cameraAnimationTime = 2000, -- duration of the camera animation in ms
                pushingValues = {
                    pushingTime = 4000, -- duration of the pushing animation in ms
                    timeBeforeExplosion = 2000, -- duration of the time before explosion in ms
                    forceMagnitude = 30.0, -- force magnitude of the vehicle after pushing
                },
            },
            {
                vehicleCoords = vec4(3935.406494, 3689.156006, 21.141357, 34.01574),
                cameraOffset = vec3(-8.0, -6.0, 6.0),
                cameraAnimationTime = 2000, -- duration of the camera animation in ms
                pushingValues = {
                    pushingTime = 4000, -- duration of the pushing animation in ms
                    timeBeforeExplosion = 2000, -- duration of the time before explosion in ms
                    forceMagnitude = 30.0, -- force magnitude of the vehicle after pushing
                },
            }
        },

        blip = {
            sprite = 768, -- sprite of the blip (https://docs.fivem.net/docs/game-references/blips/)
            color = 5, -- color of the blip (https://docs.fivem.net/docs/game-references/blips/)
            scale = 1.0, -- blip scale
            routeColor = 5, -- blip route color (https://docs.fivem.net/docs/game-references/blips/)
        },

        targetVehiclePositionMarker = {
            type = 1,
            color = { r = 253, g = 209, b = 64, a = 200 }, -- red, green, blue, alpha
            size = vec3(10.0, 10.0, 2.0), -- size of the marker
            rotation = vec3(0.0, 0.0, 0.0), -- rotation of the marker
            direction = vec3(0.0, 0.0, 0.0), -- direction of the marker
        },

        pushVehicleTarget = { -- target for pushing the vehicle off the cliff
            animation = {
                lib = "missfinale_c2ig_11",
                anim = "pushcar_offcliff_m",
            },

            targetIcon = "fa-solid fa-hand", -- target icon (https://fontawesome.com/icons)
        },
    }
}