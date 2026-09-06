Config = {} -- webhook link for logs can be placed in server/main_editable.lua

Config.Framework = 'qb' -- 'esx' | 'qb'
Config.NotificationType = 'qb' -- 'ox' | 'esx' | 'qb' | 'mythic'
Config.Locale = 'en' -- 'en' | 'fi'
Config.ImagePath = 'nui://ox_inventory/web/images/%s.png' -- path used for item images in UI
Config.DebugMode = false

Config.Inventory = 'ox' -- 'default' | 'ox' | 'qs'
Config.Target = 'ox' -- 'none' | 'ox' | 'qb'
Config.Dispatch = 'tk' -- 'tk' | 'cd' | 'none'
Config.UseOxLib = false -- false | true, remember to add " shared_script '@ox_lib/init.lua' " to fxmanifest.lua if set to true

Config.AdminCommand = 'drugsadminmenu'
Config.AdminGroups = {
    admin = true,
    god = true,
}

Config.UISettings = {
    color = 'violet', -- 'default' | 'red' | 'rose' | 'pink' | 'fuchsia' | 'purple' | 'violet' | 'indigo' | 'blue' | 'sky' | 'cyan' | 'teal' | 'emerald' | 'green' | 'lime' | 'yellow' | 'amber' | 'orange'
    shade = 6, -- 1-9,
    theme = 'dark', -- 'dark' | 'light'
}

Config.Controls = {
    interact = 38, -- E
    secondaryInteract = 47, -- G
    remove = 246, -- Y
}

Config.PoliceJobs = {
    police = true,
    sheriff = false,
}

Config.PoliceAlerts = {
    selling = {
        chance = {
            success = 0,
            failure = 50,
        },
        title = 'Drug Sale',
        code = 'Grade 3',
        priority = 'Grage 3',
        message = 'A %s is selling drugs at %s',
        jobs = {'police'},
        blip = {
            sprite = 140,
            color = 1,
            scale = 1.0,
            playSound = true,
        },
    },

    pickpocketing = {
        chance = {
            success = 0,
            failure = 25,
        },
        title = 'Suspicious Activity',
        code = 'Grade 2',
        priority = 'Grade 2',
        message = 'Someone is acting suspicious',
        jobs = {'police'},
        blip = {
            sprite = 51,
            color = 3,
            scale = 1.0,
            playSound = true,
        },
    },

    plugDelivery = {
        chance = 10,
        title = 'Drug Sale',
        code = 'Grade 2',
        priority = 'Grade 2',
        message = 'Possible Drugs Handoff',
        jobs = {'police'},
        blip = {
            sprite = 51,
            color = 3,
            scale = 1.0,
            playSound = true,
        },
    },

    drugMaking = {
        title = 'Drug Manufacturing',
        code = '10-66',
        priority = 'Priority 2',
        message = nil,
        jobs = {'police'},
        blip = {
            sprite = 51,
            color = 1,
            scale = 1.0,
            playSound = true,
        },
        chance = {
            bagging = 0,
            cauldron = 0,
            dropper = 0,
            joint_roller = 0,
            meth_cooking = 0,
            mixer = 0,
            oven = 0,
            press = 0,
            syringe = 0,
        },
    },
}

Config.FirstNames = {
    'James', 'Robert', 'Michael', 'David', 'John', 'William', 'Daniel',
    'Joseph', 'Thomas', 'Charles', 'Christopher', 'Matthew', 'Anthony',
    'Andrew', 'Joshua', 'Ryan', 'Brandon', 'Ethan', 'Nathan', 'Kevin',
    'Brian', 'Jason', 'Justin', 'Mark', 'Steven', 'Paul', 'Eric', 'Adam',
    'Jacob', 'Tyler', 'Aaron', 'Patrick', 'Sean', 'Connor', 'Liam',
}

Config.LastNames = {
    'Smith', 'Johnson', 'Williams', 'Brown', 'Jones', 'Garcia', 'Miller',
    'Davis', 'Rodriguez', 'Martinez', 'Hernandez', 'Lopez', 'Wilson', 'Anderson',
    'Thomas', 'Taylor', 'Moore', 'Jackson', 'Martin', 'Lee', 'Perez', 'Thompson',
    'White', 'Harris', 'Sanchez', 'Clark', 'Ramirez', 'Lewis', 'Robinson',
    'Walker', 'Young', 'Allen', 'King', 'Wright', 'Scott',
}

Config.Anims = {
    place = {
        dict = 'weapons@first_person@aim_rng@generic@projectile@sticky_bomb@',
        name = 'plant_floor',
        duration = 1000,
    },
    remove = {
        dict = 'weapons@first_person@aim_rng@generic@projectile@sticky_bomb@',
        name = 'plant_floor',
        duration = 1000,
    }
}

Config.DisabledAreas = { -- areas where you can't place anything (plants, equipment, etc.)
    --[[ {
        coords = vec3(161.88, -998.3, 29.35),
        radius = 50.0,
    }, ]]
}

Config.DisablePtfx = false -- false | true, disable particle effects
Config.ShowEquipmentName = false -- true | false, show the name of the equipment in target/text UI
Config.UseLocalEntities = true -- false | true, when true equipment interaction props are spawned as local entities
Config.PlaceOnlyInsideLabs = false -- false | true, when true you can only place equipment inside a drug lab

Config.EquipmentItems = {
    meth_oven = {
        item = 'meth_oven',
        equipmentType = 'oven',
        placement = 'floor',
        objects = {
            {model = `bkr_prop_weed_table_01b`, offset = vec3(0.0, 0.0, 0.0)},
            {model = `bkr_prop_meth_scoop_01a`, offset = vec3(0.65, 0.1, 0.83), rotation = vec3(0.0, 0.0, 190.0)},
            {model = `tr_prop_meth_acetone`, offset = vec3(-0.72, -0.05, 0.85), rotation = vec3(0.0, 0.0, -22.0), scale = 0.5},
            {model = `tr_prop_meth_sodium`, offset = vec3(-0.55, -0.35, 0.85), rotation = vec3(0.0, 0.0, 12.0), scale = 0.5},
            {model = `tr_prop_meth_openbag_02`, offset = vec3(0.65, 0.40, 0.92), rotation = vec3(90.0, 0.0, -8.0)},
        },
        recipes = {
            {
                need = {
                    {name = 'liquid_meth', amount = 3, model = 'prop_cs_script_bottle_01', interactType = 'rotate'},
                    {name = 'empty_tray', amount = 1},
                },
                get = {
                    {name = 'liquid_meth_tray', amount = 1},
                },
                interactionType = 'combine',
                filledTray = {model = 'bkr_prop_meth_tray_01a', scale = 0.9, offset = vec3(0.0, 0.0, -0.008)},
            },
            {
                need = {
                    {name = 'meth_tray', amount = 1, model = 'bkr_prop_meth_tray_01a', scale = 0.9},
                },
                get = {
                    {name = 'meth', amount = 10},
                },
                interactionType = 'hammer',
                brokenTray = {model = 'tr_prop_meth_smashedtray_01_frag_', scale = 0.9, offset = vec3(0.0, 0.0, -0.008)},
            },
        },
    },
    coke_oven = {
        item = 'coke_oven',
        equipmentType = 'oven',
        placement = 'floor',
        objects = {
            {model = `bkr_prop_weed_table_01b`, offset = vec3(0.0, 0.0, 0.0)},
            {model = `h4_prop_h4_coke_scale_03`, offset = vec3(-0.55, 0.40, 0.83), rotation = vec3(0.0, 0.0, 20.0)},
            {model = `bkr_prop_coke_fullmetalbowl_02`, offset = vec3(0.65, 0.30, 0.84), rotation = vec3(0.0, 0.0, -15.0)},
            {model = `bkr_prop_meth_sacid`, offset = vec3(-0.72, -0.05, 0.84), rotation = vec3(0.0, 0.0, -8.0), scale = 0.5},
            {model = `xm3_prop_xm3_lab_tray_01b`, offset = vec3(0.72, 0.10, 0.83), rotation = vec3(0.0, 0.0, 25.0)},
        },
        recipes = {
            {
                need = {
                    {name = 'low_quality_coke_base', amount = 3, model = 'bkr_prop_coke_powder_02', interactType = 'teleport', scale = 0.01, trayObjects = {model = 'bkr_prop_coke_tablepowder', minScale = 0.2, maxScale = 0.4, zOffset = 0.01}},
                },
                get = {
                    {name = 'low_quality_cocaine', amount = 1},
                },
                interactionType = 'combine',
                useCutting = true,
            },
            {
                need = {
                    {name = 'medium_quality_coke_base', amount = 3, model = 'bkr_prop_coke_powder_02', interactType = 'teleport', scale = 0.01, trayObjects = {model = 'bkr_prop_coke_tablepowder', minScale = 0.2, maxScale = 0.4, zOffset = 0.01}},
                },
                get = {
                    {name = 'medium_quality_cocaine', amount = 1},
                },
                interactionType = 'combine',
                useCutting = true,
            },
            {
                need = {
                    {name = 'high_quality_coke_base', amount = 3, model = 'bkr_prop_coke_powder_02', interactType = 'teleport', scale = 0.01, trayObjects = {model = 'bkr_prop_coke_tablepowder', minScale = 0.2, maxScale = 0.4, zOffset = 0.01}},
                },
                get = {
                    {name = 'high_quality_cocaine', amount = 1},
                },
                interactionType = 'combine',
                useCutting = true,
            },
            {
                need = {
                    {name = 'exotic_quality_coke_base', amount = 3, model = 'bkr_prop_coke_powder_02', interactType = 'teleport', scale = 0.01, trayObjects = {model = 'bkr_prop_coke_tablepowder', minScale = 0.2, maxScale = 0.4, zOffset = 0.01}},
                },
                get = {
                    {name = 'exotic_quality_cocaine', amount = 1},
                },
                interactionType = 'combine',
                useCutting = true,
            }
        }
    },
    meth_cooking = {
        item = 'meth_cooking_table',
        equipmentType = 'meth_cooking',
        placement = 'floor',
        objects = {
            {model = `bkr_prop_weed_table_01b`, offset = vec3(0.0, 0.0, 0.0)},
            {model = `tr_prop_meth_acetone`, offset = vec3(-0.62, 0.32, 0.85), rotation = vec3(0.0, 0.0, 196.0)},
            {model = `xm3_prop_xm3_lsd_bottles2`, offset = vec3(-0.65, 0.0, 0.75), rotation = vec3(0.0, 0.0, 230.0)},
            {model = `bkr_prop_meth_sacid`, offset = vec3(0.98, 0.2, 0.85), rotation = vec3(0.0, 0.0, 85.0), scale = 0.8},
            {model = `bkr_prop_meth_tray_01b`, offset = vec3(0.6, -0.1, 0.83), rotation = vec3(0.0, 0.0, 178.0)},
        },
        flaskModel = {model = 'xm3_prop_xm3_lsd_beaker_02a', scale = 2.0},
        heaterModel = {model = 'xm3_prop_xm3_lsd_appar_03a'},
        stirStickModel = {model = 'xm3_prop_xm3_coke_spoon_01a'},
        recipes = {
            {
                need = {
                    {name = 'pseudo', amount = 1, model = 'xm3_prop_xm3_pill_01a', offset = vec3(-0.5, 0.0, 0.0), interactType = 'move'},
                    {name = 'phos', amount = 1, model = 'xm3_prop_xm3_bottle_pills_01a', interactType = 'rotate'},
                    {name = 'acid', amount = 1, model = 'prop_cs_script_bottle_01', interactType = 'rotate'},
                },
                get = {
                    {name = 'liquid_meth', amount = 1}
                }
            }
        }
    },
    mixer = {
        item = 'mixer',
        equipmentType = 'mixer',
        placement = 'floor',
        objects = {
            {model = `bkr_prop_weed_table_01b`, offset = vec3(0.0, 0.0, 0.0)},
            {model = `drug_prop_mixer`, offset = vec3(-0.05, 0.0, 0.72), rotation = vec3(-90.0, 0.0, -90.0)},
        },
        recipes = {
            {
                need = {
                    {name = 'meth', amount = 1, model = `p_meth_bag_01_s`},
                    {name = 'petrol_can', amount = 1, model = `prop_jerrycan_01a`},
                },
                get = {
                    {name = 'explosive_meth', amount = 1}
                }
            },
            {
                need = {
                    {name = 'low_quality_cocaine', amount = 1, model = `bkr_prop_coke_powder_02`, scale = 1.0},
                    {name = 'banana', amount = 1, model = `drug_prop_banana`},
                },
                get = {
                    {name = 'medium_quality_cocaine', amount = 1}
                }
            },
            {
                need = {
                    {name = 'medium_quality_cocaine', amount = 1, model = `bkr_prop_coke_powder_02`, scale = 1.0},
                    {name = 'caffeine_powder', amount = 1, model = `bkr_prop_coke_powder_02`, scale = 1.0},
                },
                get = {
                    {name = 'high_quality_cocaine', amount = 1}
                }
            },
            {
                need = {
                    {name = 'heroin_syringe', amount = 1, model = `prop_syringe_01`},
                    {name = 'bagged_meth', amount = 1, model = `xm3_prop_xm3_bag_small_01a`},
                },
                get = {
                    {name = 'speedball_syringe', amount = 1}
                }
            },
            {
                need = {
                    {name = 'exotic_quality_og_kush_joint', model = `p_cs_joint_01`, amount = 1},
                    {name = 'liquid_meth', amount = 1, model = `prop_meth_bag_01`},
                },
                get = {
                    {name = 'wet_joint', amount = 1}
                }
            },
            {
                need = {
                    {name = 'exotic_quality_northern_lights_joint', model = `p_cs_joint_01`, amount = 1},
                    {name = 'liquid_meth', amount = 1, model = `prop_meth_bag_01`},
                },
                get = {
                    {name = 'wet_joint', amount = 1}
                }
            },
            {
                need = {
                    {name = 'exotic_quality_dosidos_joint', model = `p_cs_joint_01`, amount = 1},
                    {name = 'liquid_meth', amount = 1, model = `prop_meth_bag_01`},
                },
                get = {
                    {name = 'wet_joint', amount = 1}
                }
            },
            {
                need = {
                    {name = 'exotic_quality_acapulco_gold_joint', model = `p_cs_joint_01`, amount = 1},
                    {name = 'liquid_meth', amount = 1, model = `prop_meth_bag_01`},
                },
                get = {
                    {name = 'wet_joint', amount = 1}
                }
            },
            {
                need = {
                    {name = 'explosive_meth', amount = 1, model = `p_meth_bag_01_s`},
                    {name = 'glitter_powder', amount = 1, model = `h4_prop_h4_coke_powderbottle_01`, scale = 1.0},
                },
                get = {
                    {name = 'glitter_bomb_meth', amount = 1}
                }
            },
        }
    },
    bagging_table = {
        item = 'bagging_table',
        equipmentType = 'bagging',
        placement = 'floor',
        objects = {
            {model = `bkr_prop_weed_table_01b`, offset = vec3(0.0, 0.0, 0.0)},
            {model = `bkr_prop_weed_scales_01a`, offset = vec3(0.9, 0.28, 0.83), rotation = vec3(0.0, 0.0, 170.0)},
            {model = `bkr_prop_weed_bigbag_03a`, offset = vec3(-0.10, 0.3, 0.8), rotation = vec3(0.0, 0.0, 158.0), scale = 0.5},
            {model = `bkr_prop_weed_spray_01a`, offset = vec3(-0.72, 0.32, 0.83), rotation = vec3(0.0, 0.0, 192.0)},
            {model = `xm3_prop_xm3_bag_weed_01a`, offset = vec3(-0.72, -0.32, 0.83), rotation = vec3(0.0, 15.0, 172.0)},
            {model = `xm3_prop_xm3_bag_weed_01a`, offset = vec3(-0.63, -0.26, 0.83), rotation = vec3(0.0, 0.0, 170.0)},
        },
        recipes = {
            {
                need = {
                    {name = 'low_quality_og_kush', amount = 1, model = `bkr_prop_weed_bud_01b`, scale = 0.5},
                    {name = 'baggy', amount = 1, model = `xm3_prop_xm3_bag_small_01a`, scale = 2.0},
                },
                get = {
                    {name = 'low_quality_bagged_og_kush', amount = 1}
                }
            },
            {
                need = {
                    {name = 'medium_quality_og_kush', amount = 1, model = `bkr_prop_weed_bud_01b`, scale = 0.5},
                    {name = 'baggy', amount = 1, model = `xm3_prop_xm3_bag_small_01a`, scale = 2.0},
                },
                get = {
                    {name = 'medium_quality_bagged_og_kush', amount = 1}
                }
            },
            {
                need = {
                    {name = 'high_quality_og_kush', amount = 1, model = `bkr_prop_weed_bud_01b`, scale = 0.5},
                    {name = 'baggy', amount = 1, model = `xm3_prop_xm3_bag_small_01a`, scale = 2.0},
                },
                get = {
                    {name = 'high_quality_bagged_og_kush', amount = 1}
                }
            },
            {
                need = {
                    {name = 'exotic_quality_og_kush', amount = 1, model = `bkr_prop_weed_bud_01b`, scale = 0.5},
                    {name = 'baggy', amount = 1, model = `xm3_prop_xm3_bag_small_01a`, scale = 2.0},
                },
                get = {
                    {name = 'exotic_quality_bagged_og_kush', amount = 1}
                }
            },
            {
                need = {
                    {name = 'low_quality_northern_lights', amount = 1, model = `bkr_prop_weed_bud_01b`, scale = 0.5},
                    {name = 'baggy', amount = 1, model = `xm3_prop_xm3_bag_small_01a`, scale = 2.0},
                },
                get = {
                    {name = 'low_quality_bagged_northern_lights', amount = 1}
                }
            },
            {
                need = {
                    {name = 'medium_quality_northern_lights', amount = 1, model = `bkr_prop_weed_bud_01b`, scale = 0.5},
                    {name = 'baggy', amount = 1, model = `xm3_prop_xm3_bag_small_01a`, scale = 2.0},
                },
                get = {
                    {name = 'medium_quality_bagged_northern_lights', amount = 1}
                }
            },
            {
                need = {
                    {name = 'high_quality_northern_lights', amount = 1, model = `bkr_prop_weed_bud_01b`, scale = 0.5},
                    {name = 'baggy', amount = 1, model = `xm3_prop_xm3_bag_small_01a`, scale = 2.0},
                },
                get = {
                    {name = 'high_quality_bagged_northern_lights', amount = 1}
                }
            },
            {
                need = {
                    {name = 'exotic_quality_northern_lights', amount = 1, model = `bkr_prop_weed_bud_01b`, scale = 0.5},
                    {name = 'baggy', amount = 1, model = `xm3_prop_xm3_bag_small_01a`, scale = 2.0},
                },
                get = {
                    {name = 'exotic_quality_bagged_northern_lights', amount = 1}
                }
            },
            {
                need = {
                    {name = 'low_quality_dosidos', amount = 1, model = `bkr_prop_weed_bud_01b`, scale = 0.5},
                    {name = 'baggy', amount = 1, model = `xm3_prop_xm3_bag_small_01a`, scale = 2.0},
                },
                get = {
                    {name = 'low_quality_bagged_dosidos', amount = 1}
                }
            },
            {
                need = {
                    {name = 'medium_quality_dosidos', amount = 1, model = `bkr_prop_weed_bud_01b`, scale = 0.5},
                    {name = 'baggy', amount = 1, model = `xm3_prop_xm3_bag_small_01a`, scale = 2.0},
                },
                get = {
                    {name = 'medium_quality_bagged_dosidos', amount = 1}
                }
            },
            {
                need = {
                    {name = 'high_quality_dosidos', amount = 1, model = `bkr_prop_weed_bud_01b`, scale = 0.5},
                    {name = 'baggy', amount = 1, model = `xm3_prop_xm3_bag_small_01a`, scale = 2.0},
                },
                get = {
                    {name = 'high_quality_bagged_dosidos', amount = 1}
                }
            },
            {
                need = {
                    {name = 'exotic_quality_dosidos', amount = 1, model = `bkr_prop_weed_bud_01b`, scale = 0.5},
                    {name = 'baggy', amount = 1, model = `xm3_prop_xm3_bag_small_01a`, scale = 2.0},
                },
                get = {
                    {name = 'exotic_quality_bagged_dosidos', amount = 1}
                }
            },
            {
                need = {
                    {name = 'low_quality_acapulco_gold', amount = 1, model = `bkr_prop_weed_bud_01b`, scale = 0.5},
                    {name = 'baggy', amount = 1, model = `xm3_prop_xm3_bag_small_01a`, scale = 2.0},
                },
                get = {
                    {name = 'low_quality_bagged_acapulco_gold', amount = 1}
                }
            },
            {
                need = {
                    {name = 'medium_quality_acapulco_gold', amount = 1, model = `bkr_prop_weed_bud_01b`, scale = 0.5},
                    {name = 'baggy', amount = 1, model = `xm3_prop_xm3_bag_small_01a`, scale = 2.0},
                },
                get = {
                    {name = 'medium_quality_bagged_acapulco_gold', amount = 1}
                }
            },
            {
                need = {
                    {name = 'high_quality_acapulco_gold', amount = 1, model = `bkr_prop_weed_bud_01b`, scale = 0.5},
                    {name = 'baggy', amount = 1, model = `xm3_prop_xm3_bag_small_01a`, scale = 2.0},
                },
                get = {
                    {name = 'high_quality_bagged_acapulco_gold', amount = 1}
                }
            },
            {
                need = {
                    {name = 'exotic_quality_acapulco_gold', amount = 1, model = `bkr_prop_weed_bud_01b`, scale = 0.5},
                    {name = 'baggy', amount = 1, model = `xm3_prop_xm3_bag_small_01a`, scale = 2.0},
                },
                get = {
                    {name = 'exotic_quality_bagged_acapulco_gold', amount = 1}
                }
            },
            {
                need = {
                    {name = 'meth', amount = 1, model = `drug_prop_crystal`, scale = 0.5},
                    {name = 'baggy', amount = 1, model = `xm3_prop_xm3_bag_small_01a`, scale = 2.0},
                },
                get = {
                    {name = 'bagged_meth', amount = 1}
                }
            },
            {
                need = {
                    {name = 'low_quality_cocaine', amount = 1, model = `bkr_prop_coke_powder_02`, scale = 0.5},
                    {name = 'baggy', amount = 1, model = `xm3_prop_xm3_bag_small_01a`, scale = 2.0},
                },
                get = {
                    {name = 'low_quality_bagged_cocaine', amount = 1}
                }
            },
            {
                need = {
                    {name = 'medium_quality_cocaine', amount = 1, model = `bkr_prop_coke_powder_02`, scale = 0.5},
                    {name = 'baggy', amount = 1, model = `xm3_prop_xm3_bag_small_01a`, scale = 2.0},
                },
                get = {
                    {name = 'medium_quality_bagged_cocaine', amount = 1}
                }
            },
            {
                need = {
                    {name = 'high_quality_cocaine', amount = 1, model = `bkr_prop_coke_powder_02`, scale = 0.5},
                    {name = 'baggy', amount = 1, model = `xm3_prop_xm3_bag_small_01a`, scale = 2.0},
                },
                get = {
                    {name = 'high_quality_bagged_cocaine', amount = 1}
                }
            },
            {
                need = {
                    {name = 'exotic_quality_cocaine', amount = 1, model = `bkr_prop_coke_powder_02`, scale = 0.5},
                    {name = 'baggy', amount = 1, model = `xm3_prop_xm3_bag_small_01a`, scale = 2.0},
                },
                get = {
                    {name = 'exotic_quality_bagged_cocaine', amount = 1}
                }
            },
            {
                need = {
                    {name = 'cooked_cubensis', amount = 1, model = `dl_shroom_41`, scale = 0.5},
                    {name = 'baggy', amount = 1, model = `xm3_prop_xm3_bag_small_01a`, scale = 2.0},
                },
                get = {
                    {name = 'bagged_cubensis', amount = 1}
                }
            },
            {
                need = {
                    {name = 'cooked_liberty_cap', amount = 1, model = `dl_shroom_12`, scale = 0.5},
                    {name = 'baggy', amount = 1, model = `xm3_prop_xm3_bag_small_01a`, scale = 2.0},
                },
                get = {
                    {name = 'bagged_liberty_cap', amount = 1}
                }
            },
            {
                need = {
                    {name = 'cooked_fly_agaric', amount = 1, model = `dl_shroom_20`, scale = 0.5},
                    {name = 'baggy', amount = 1, model = `xm3_prop_xm3_bag_small_01a`, scale = 2.0},
                },
                get = {
                    {name = 'bagged_fly_agaric', amount = 1}
                }
            },
        }
    },
    joint_roller_table = {
        item = 'joint_roller_table',
        equipmentType = 'joint_roller',
        placement = 'floor',
        objects = {
            {model = `bkr_prop_weed_table_01b`, offset = vec3(0.0, 0.0, 0.0)},
            {model = `bkr_prop_weed_scales_01a`, offset = vec3(-0.9, 0.28, 0.83), rotation = vec3(0.0, 0.0, -10.0)},
            {model = `xm3_prop_xm3_bag_weed_01a`, offset = vec3(0.72, 0.32, 0.83), rotation = vec3(0.0, 15.0, -8.0)},
            {model = `xm3_prop_xm3_bag_weed_01a`, offset = vec3(0.63, 0.26, 0.83), rotation = vec3(0.0, 0.0, -10.0)},
            {model = `p_cs_joint_02`, offset = vec3(-0.62, 0.20, 0.83), rotation = vec3(0.0, 0.0, 120.0)},
            {model = `p_cs_joint_02`, offset = vec3(-0.65, 0.26, 0.83), rotation = vec3(0.0, 0.0, 90.0)},
            {model = `p_cs_joint_02`, offset = vec3(-0.7, 0.26, 0.83), rotation = vec3(0.0, 0.0, 95.0)},
        },
        recipes = {
            {
                need = {
                    {name = 'low_quality_og_kush', amount = 1},
                    {name = 'rolling_paper', amount = 1},
                },
                get = {
                    {name = 'low_quality_og_kush_joint', amount = 1}
                },
            },
            {
                need = {
                    {name = 'medium_quality_og_kush', amount = 1},
                    {name = 'rolling_paper', amount = 1},
                },
                get = {
                    {name = 'medium_quality_og_kush_joint', amount = 1}
                },
            },
            {
                need = {
                    {name = 'high_quality_og_kush', amount = 1},
                    {name = 'rolling_paper', amount = 1},
                },
                get = {
                    {name = 'high_quality_og_kush_joint', amount = 1}
                },
            },
            {
                need = {
                    {name = 'exotic_quality_og_kush', amount = 1},
                    {name = 'rolling_paper', amount = 1},
                },
                get = {
                    {name = 'exotic_quality_og_kush_joint', amount = 1}
                },
            },
            {
                need = {
                    {name = 'low_quality_northern_lights', amount = 1},
                    {name = 'rolling_paper', amount = 1},
                },
                get = {
                    {name = 'low_quality_northern_lights_joint', amount = 1}
                },
            },
            {
                need = {
                    {name = 'medium_quality_northern_lights', amount = 1},
                    {name = 'rolling_paper', amount = 1},
                },
                get = {
                    {name = 'medium_quality_northern_lights_joint', amount = 1}
                },
            },
            {
                need = {
                    {name = 'high_quality_northern_lights', amount = 1},
                    {name = 'rolling_paper', amount = 1},
                },
                get = {
                    {name = 'high_quality_northern_lights_joint', amount = 1}
                },
            },
            {
                need = {
                    {name = 'exotic_quality_northern_lights', amount = 1},
                    {name = 'rolling_paper', amount = 1},
                },
                get = {
                    {name = 'exotic_quality_northern_lights_joint', amount = 1}
                },
            },
            {
                need = {
                    {name = 'low_quality_dosidos', amount = 1},
                    {name = 'rolling_paper', amount = 1},
                },
                get = {
                    {name = 'low_quality_dosidos_joint', amount = 1}
                },
            },
            {
                need = {
                    {name = 'medium_quality_dosidos', amount = 1},
                    {name = 'rolling_paper', amount = 1},
                },
                get = {
                    {name = 'medium_quality_dosidos_joint', amount = 1}
                },
            },
            {
                need = {
                    {name = 'high_quality_dosidos', amount = 1},
                    {name = 'rolling_paper', amount = 1},
                },
                get = {
                    {name = 'high_quality_dosidos_joint', amount = 1}
                },
            },
            {
                need = {
                    {name = 'exotic_quality_dosidos', amount = 1},
                    {name = 'rolling_paper', amount = 1},
                },
                get = {
                    {name = 'exotic_quality_dosidos_joint', amount = 1}
                },
            },
            {
                need = {
                    {name = 'low_quality_acapulco_gold', amount = 1},
                    {name = 'rolling_paper', amount = 1},
                },
                get = {
                    {name = 'low_quality_acapulco_gold_joint', amount = 1}
                },
            },
            {
                need = {
                    {name = 'medium_quality_acapulco_gold', amount = 1},
                    {name = 'rolling_paper', amount = 1},
                },
                get = {
                    {name = 'medium_quality_acapulco_gold_joint', amount = 1}
                },
            },
            {
                need = {
                    {name = 'high_quality_acapulco_gold', amount = 1},
                    {name = 'rolling_paper', amount = 1},
                },
                get = {
                    {name = 'high_quality_acapulco_gold_joint', amount = 1}
                },
            },
            {
                need = {
                    {name = 'exotic_quality_acapulco_gold', amount = 1},
                    {name = 'rolling_paper', amount = 1},
                },
                get = {
                    {name = 'exotic_quality_acapulco_gold_joint', amount = 1}
                },
            },
        },
    },
    cauldron = {
        item = 'cauldron',
        equipmentType = 'cauldron',
        placement = 'floor',
        objects = {
            {model = `prop_kitch_pot_huge`, offset = vec3(0.0, 0.0, 0.0)}
        },
        recipes = {
            {
                need = {
                    {name = 'low_quality_coca_leaf', amount = 3, model = 'bkr_prop_weed_leaf_01a'},
                    {name = 'petrol_can', amount = 1, model = 'prop_jerrycan_01a', pourable = true},
                },
                get = {
                    {name = 'low_quality_coke_base', amount = 1}
                },
            },
            {
                need = {
                    {name = 'medium_quality_coca_leaf', amount = 3, model = 'bkr_prop_weed_leaf_01a'},
                    {name = 'petrol_can', amount = 1, model = 'prop_jerrycan_01a', pourable = true},
                },
                get = {
                    {name = 'medium_quality_coke_base', amount = 1}
                },
            },
            {
                need = {
                    {name = 'high_quality_coca_leaf', amount = 3, model = 'bkr_prop_weed_leaf_01a'},
                    {name = 'petrol_can', amount = 1, model = 'prop_jerrycan_01a', pourable = true},
                },
                get = {
                    {name = 'high_quality_coke_base', amount = 1}
                },
            },
            {
                need = {
                    {name = 'exotic_quality_coca_leaf', amount = 3, model = 'bkr_prop_weed_leaf_01a'},
                    {name = 'petrol_can', amount = 1, model = 'prop_jerrycan_01a', pourable = true},
                },
                get = {
                    {name = 'exotic_quality_coke_base', amount = 1}
                },
            },
            {
                need = {
                    {name = 'dried_cubensis', amount = 1, model = 'dl_shroom_41'},
                },
                get = {
                    {name = 'cooked_cubensis', amount = 1}
                },
            },
            {
                need = {
                    {name = 'dried_liberty_cap', amount = 1, model = 'dl_shroom_12'},
                },
                get = {
                    {name = 'cooked_liberty_cap', amount = 1}
                },
            },
            {
                need = {
                    {name = 'dried_fly_agaric', amount = 1, model = 'dl_shroom_20'},
                },
                get = {
                    {name = 'cooked_fly_agaric', amount = 1}
                },
            }
        }
    },
    press = {
        item = 'press',
        equipmentType = 'press',
        placement = 'floor',
        objects = {
            {model = `bkr_prop_coke_press_01b`, offset = vec3(0.0, 0.0, 0.0)}
        },
        recipes = {
            {
                need = {
                    {name = 'low_quality_cocaine', amount = 10, model = `bkr_prop_coke_cutblock_01`},
                },
                get = {
                    {name = 'low_quality_coke_brick', amount = 1}
                },
            },
            {
                need = {
                    {name = 'medium_quality_cocaine', amount = 10, model = `bkr_prop_coke_cutblock_01`},
                },
                get = {
                    {name = 'medium_quality_coke_brick', amount = 1}
                },
            },
            {
                need = {
                    {name = 'high_quality_cocaine', amount = 10, model = `bkr_prop_coke_cutblock_01`},
                },
                get = {
                    {name = 'high_quality_coke_brick', amount = 1}
                },
            },
            {
                need = {
                    {name = 'exotic_quality_cocaine', amount = 10, model = `bkr_prop_coke_cutblock_01`},
                },
                get = {
                    {name = 'exotic_quality_coke_brick', amount = 1}
                },
            }
        }
    },
    heroin_cooking_table = {
        item = 'heroin_cooking_table',
        equipmentType = 'syringe',
        placement = 'floor',
        objects = {
            {model = `bkr_prop_weed_table_01b`, offset = vec3(0.0, 0.0, 0.0)},
            {model = `xm3_prop_xm3_rack_vial_01b`, offset = vec3(-0.65, 0.32, 0.85), rotation = vec3(0.0, 0.0, 12.0), scale = 1.5},
            {model = `xm3_prop_xm3_lsd_beaker_02a`, offset = vec3(-0.02, 0.0, 1.0), rotation = vec3(0.0, 180.0, 0.0), scale = 1.5},
            {model = `bkr_prop_meth_sacid`, offset = vec3(0.65, 0.30, 0.85), rotation = vec3(0.0, 0.0, -18.0), scale = 0.5},
        },
        spoonModel = 'xm3_prop_xm3_coke_spoon_01a',
        lighterModel = 'p_cs_lighter_01',
        syringeModel = 'prop_syringe_01',
        cookTime = 4000,
        recipes = {
            {
                need = {
                    {name = 'poppy_resin', amount = 1},
                    {name = 'acetic_anhydride', amount = 1},
                    {name = 'empty_syringe', amount = 1},
                },
                get = {
                    {name = 'heroin_syringe', amount = 1}
                },
            },
        },
    },
    lsd_table = {
        item = 'lsd_table',
        equipmentType = 'dropper',
        placement = 'floor',
        objects = {
            {model = `bkr_prop_weed_table_01b`, offset = vec3(0.0, 0.0, 0.0)},
            {model = `xm3_prop_xm3_lsd_appar_01a`, offset = vec3(-0.65, 0.25, 0.85), rotation = vec3(0.0, 0.0, 20.0), scale = 0.5},
            {model = `xm3_prop_xm3_lsd_beaker_02a`, offset = vec3(-0.65, -0.1, 0.85), rotation = vec3(0.0, 0.0,  5.0), scale = 1.5},
            {model = `xm3_prop_xm3_lsd_bottles3`, offset = vec3(0.65, 0.25, 0.85), rotation = vec3(0.0, 0.0, -10.0), scale = 0.5},
        },
        sheetModel = `p_a4_sheets_s`,
        dropperModel = `xm3_prop_xm3_pipette_01b`,
        gridSize = 3,
        cellSpacing = 0.05,
        cellRadius = 0.025,
        recipes = {
            {
                need = {
                    {name = 'rye_ergot', amount = 1, model = `bkr_prop_weed_bud_01b`, scale = 0.4},
                    {name = 'diethylamine', amount = 1, model = `xm3_prop_xm3_lsd_bottle_01a`},
                    {name = 'paper_sheet', amount = 1, model = `p_a4_sheets_s`},
                },
                get = {
                    {name = 'lsd_sheet', amount = 1}
                },
            },
        },
    },
    drug_shelf = {
        item = 'drug_shelf',
        equipmentType = 'shelf',
        placement = 'floor',
        objects = {
            {model = `v_ind_cf_shelf`, offset = vec3(0.0, 0.0, 0.0)},
        },
        allowedItems = {
            meth = {model = `drug_prop_crystal`, maxPerShelf = 100}, -- maxPerShelf is optional, unlimited if not set
            low_quality_og_kush = {model = `bkr_prop_weed_bud_01b`},
            medium_quality_og_kush = {model = `bkr_prop_weed_bud_01b`},
            high_quality_og_kush = {model = `bkr_prop_weed_bud_01b`},
            exotic_quality_og_kush = {model = `bkr_prop_weed_bud_01b`},
            low_quality_northern_lights = {model = `bkr_prop_weed_bud_01b`},
            medium_quality_northern_lights = {model = `bkr_prop_weed_bud_01b`},
            high_quality_northern_lights = {model = `bkr_prop_weed_bud_01b`},
            exotic_quality_northern_lights = {model = `bkr_prop_weed_bud_01b`},
            low_quality_dosidos = {model = `bkr_prop_weed_bud_01b`},
            medium_quality_dosidos = {model = `bkr_prop_weed_bud_01b`},
            high_quality_dosidos = {model = `bkr_prop_weed_bud_01b`},
            exotic_quality_dosidos = {model = `bkr_prop_weed_bud_01b`},
            low_quality_acapulco_gold = {model = `bkr_prop_weed_bud_01b`},
            medium_quality_acapulco_gold = {model = `bkr_prop_weed_bud_01b`},
            high_quality_acapulco_gold = {model = `bkr_prop_weed_bud_01b`},
            exotic_quality_acapulco_gold = {model = `bkr_prop_weed_bud_01b`},
            low_quality_coca_leaf = {model = `bkr_prop_weed_leaf_01a`},
            medium_quality_coca_leaf = {model = `bkr_prop_weed_leaf_01a`},
            high_quality_coca_leaf = {model = `bkr_prop_weed_leaf_01a`},
            exotic_quality_coca_leaf = {model = `bkr_prop_weed_leaf_01a`},
            low_quality_coke_base = {model = `bkr_prop_coke_powder_02`},
            medium_quality_coke_base = {model = `bkr_prop_coke_powder_02`},
            high_quality_coke_base = {model = `bkr_prop_coke_powder_02`},
            exotic_quality_coke_base = {model = `bkr_prop_coke_powder_02`},
            low_quality_cocaine = {model = `bkr_prop_coke_powder_02`},
            medium_quality_cocaine = {model = `bkr_prop_coke_powder_02`},
            high_quality_cocaine = {model = `bkr_prop_coke_powder_02`},
            exotic_quality_cocaine = {model = `bkr_prop_coke_powder_02`},
            low_quality_coke_brick = {model = `prop_coke_block_01`},
            medium_quality_coke_brick = {model = `prop_coke_block_01`},
            high_quality_coke_brick = {model = `prop_coke_block_01`},
            exotic_quality_coke_brick = {model = `prop_coke_block_01`},
            low_quality_bagged_og_kush = {model = `xm3_prop_xm3_bag_weed_01a`},
            medium_quality_bagged_og_kush = {model = `xm3_prop_xm3_bag_weed_01a`},
            high_quality_bagged_og_kush = {model = `xm3_prop_xm3_bag_weed_01a`},
            exotic_quality_bagged_og_kush = {model = `xm3_prop_xm3_bag_weed_01a`},
            low_quality_bagged_northern_lights = {model = `xm3_prop_xm3_bag_weed_01a`},
            medium_quality_bagged_northern_lights = {model = `xm3_prop_xm3_bag_weed_01a`},
            high_quality_bagged_northern_lights = {model = `xm3_prop_xm3_bag_weed_01a`},
            exotic_quality_bagged_northern_lights = {model = `xm3_prop_xm3_bag_weed_01a`},
            low_quality_bagged_dosidos = {model = `xm3_prop_xm3_bag_weed_01a`},
            medium_quality_bagged_dosidos = {model = `xm3_prop_xm3_bag_weed_01a`},
            high_quality_bagged_dosidos = {model = `xm3_prop_xm3_bag_weed_01a`},
            exotic_quality_bagged_dosidos = {model = `xm3_prop_xm3_bag_weed_01a`},
            low_quality_bagged_acapulco_gold = {model = `xm3_prop_xm3_bag_weed_01a`},
            medium_quality_bagged_acapulco_gold = {model = `xm3_prop_xm3_bag_weed_01a`},
            high_quality_bagged_acapulco_gold = {model = `xm3_prop_xm3_bag_weed_01a`},
            exotic_quality_bagged_acapulco_gold = {model = `xm3_prop_xm3_bag_weed_01a`},
            low_quality_bagged_cocaine = {model = `xm3_prop_xm3_bag_coke_01a`},
            medium_quality_bagged_cocaine = {model = `xm3_prop_xm3_bag_coke_01a`},
            high_quality_bagged_cocaine = {model = `xm3_prop_xm3_bag_coke_01a`},
            exotic_quality_bagged_cocaine = {model = `xm3_prop_xm3_bag_coke_01a`},
            cubensis = {model = `dl_shroom_41`},
            liberty_cap = {model = `dl_shroom_12`},
            fly_agaric = {model = `dl_shroom_20`},
            dried_cubensis = {model = `dl_shroom_41`},
            dried_liberty_cap = {model = `dl_shroom_12`},
            dried_fly_agaric = {model = `dl_shroom_20`},
            cooked_cubensis = {model = `dl_shroom_41`},
            cooked_liberty_cap = {model = `dl_shroom_12`},
            cooked_fly_agaric = {model = `dl_shroom_20`},
            bagged_cubensis = {model = `xm3_prop_xm3_bag_weed_01a`},
            bagged_liberty_cap = {model = `xm3_prop_xm3_bag_weed_01a`},
            bagged_fly_agaric = {model = `xm3_prop_xm3_bag_weed_01a`},
            bagged_meth = {model = `tr_prop_meth_smallbag_01a`},
            explosive_meth = {model = `tr_prop_meth_smallbag_01a`},
            liquid_meth = {model = `prop_cs_script_bottle_01`},
            empty_tray = {model = `ch_prop_ch_tray_01a`},
            liquid_meth_tray = {model = `bkr_prop_meth_tray_01a`},
            meth_tray = {model = `bkr_prop_meth_tray_02a`},
            phos = {model = `xm3_prop_xm3_bottle_pills_01a`},
            acid = {model = `prop_cs_script_bottle_01`},
            pseudo = {model = `xm3_prop_xm3_pill_01a`},
            heroin_syringe = {model = `prop_syringe_01`},
            empty_syringe = {model = `prop_syringe_01`},
            lsd_sheet = {model = `xm3_prop_xm3_sheet_acid_01a`},
            paper_sheet = {model = `xm3_prop_xm3_sheet_acid_01a`},
            poppy_resin = {model = `bkr_prop_weed_bud_pruned_01a`},
            acetic_anhydride = {model = `prop_cs_script_bottle_01`},
            rye_ergot = {model = `bkr_prop_weed_bud_01b`},
            diethylamine = {model = `prop_cs_script_bottle_01`},
            petrol_can = {model = `prop_jerrycan_01a`},
            baggy = {model = `xm3_prop_xm3_bag_small_01a`},
            rolling_paper = {model = `p_cs_joint_02`},
            low_quality_og_kush_joint = {model = `p_cs_joint_02`},
            medium_quality_og_kush_joint = {model = `p_cs_joint_02`},
            high_quality_og_kush_joint = {model = `p_cs_joint_02`},
            exotic_quality_og_kush_joint = {model = `p_cs_joint_02`},
            low_quality_northern_lights_joint = {model = `p_cs_joint_02`},
            medium_quality_northern_lights_joint = {model = `p_cs_joint_02`},
            high_quality_northern_lights_joint = {model = `p_cs_joint_02`},
            exotic_quality_northern_lights_joint = {model = `p_cs_joint_02`},
            low_quality_dosidos_joint = {model = `p_cs_joint_02`},
            medium_quality_dosidos_joint = {model = `p_cs_joint_02`},
            high_quality_dosidos_joint = {model = `p_cs_joint_02`},
            exotic_quality_dosidos_joint = {model = `p_cs_joint_02`},
            low_quality_acapulco_gold_joint = {model = `p_cs_joint_02`},
            medium_quality_acapulco_gold_joint = {model = `p_cs_joint_02`},
            high_quality_acapulco_gold_joint = {model = `p_cs_joint_02`},
            exotic_quality_acapulco_gold_joint = {model = `p_cs_joint_02`},
        },
        objectOffsets = {
            {offset = vec3(-0.9, 0.0, 1.3)},
            {offset = vec3(-0.3, 0.0, 1.3)},
            {offset = vec3(0.3, 0.0, 1.3)},
            {offset = vec3(0.9, 0.0, 1.3)},
            {offset = vec3(-0.9, 0.0, 0.72)},
            {offset = vec3(-0.3, 0.0, 0.72)},
            {offset = vec3(0.3, 0.0, 0.72)},
            {offset = vec3(0.9, 0.0, 0.72)},
        },
    },
    drying_rack = {
        item = 'drying_rack',
        equipmentType = 'processor',
        placement = 'floor',
        objects = {
            {model = `prop_bread_rack_01`, offset = vec3(0.0, 0.0, 0.0)},
        },
        items = {
            {
                need = {item = 'low_quality_og_kush', model = `bkr_prop_weed_bud_01b`},
                get = {item = 'medium_quality_og_kush', model = `bkr_prop_weed_bud_01b`},
                time = 1000 * 60 * 30, -- in milliseconds, default 30 minutes
            },
            {
                need = {item = 'medium_quality_og_kush', model = `bkr_prop_weed_bud_01b`},
                get = {item = 'high_quality_og_kush', model = `bkr_prop_weed_bud_01b`},
                time = 1000 * 60 * 30,
            },
            {
                need = {item = 'high_quality_og_kush', model = `bkr_prop_weed_bud_01b`},
                get = {item = 'exotic_quality_og_kush', model = `bkr_prop_weed_bud_01b`},
                time = 1000 * 60 * 30,
            },
            {
                need = {item = 'low_quality_northern_lights', model = `bkr_prop_weed_bud_01b`},
                get = {item = 'medium_quality_northern_lights', model = `bkr_prop_weed_bud_01b`},
                time = 1000 * 60 * 30,
            },
            {
                need = {item = 'medium_quality_northern_lights', model = `bkr_prop_weed_bud_01b`},
                get = {item = 'high_quality_northern_lights', model = `bkr_prop_weed_bud_01b`},
                time = 1000 * 60 * 30,
            },
            {
                need = {item = 'high_quality_northern_lights', model = `bkr_prop_weed_bud_01b`},
                get = {item = 'exotic_quality_northern_lights', model = `bkr_prop_weed_bud_01b`},
                time = 1000 * 60 * 30,
            },
            {
                need = {item = 'low_quality_dosidos', model = `bkr_prop_weed_bud_01b`},
                get = {item = 'medium_quality_dosidos', model = `bkr_prop_weed_bud_01b`},
                time = 1000 * 60 * 30,
            },
            {
                need = {item = 'medium_quality_dosidos', model = `bkr_prop_weed_bud_01b`},
                get = {item = 'high_quality_dosidos', model = `bkr_prop_weed_bud_01b`},
                time = 1000 * 60 * 30,
            },
            {
                need = {item = 'high_quality_dosidos', model = `bkr_prop_weed_bud_01b`},
                get = {item = 'exotic_quality_dosidos', model = `bkr_prop_weed_bud_01b`},
                time = 1000 * 60 * 30,
            },
            {
                need = {item = 'low_quality_acapulco_gold', model = `bkr_prop_weed_bud_01b`},
                get = {item = 'medium_quality_acapulco_gold', model = `bkr_prop_weed_bud_01b`},
                time = 1000 * 60 * 30,
            },
            {
                need = {item = 'medium_quality_acapulco_gold', model = `bkr_prop_weed_bud_01b`},
                get = {item = 'high_quality_acapulco_gold', model = `bkr_prop_weed_bud_01b`},
                time = 1000 * 60 * 30,
            },
            {
                need = {item = 'high_quality_acapulco_gold', model = `bkr_prop_weed_bud_01b`},
                get = {item = 'exotic_quality_acapulco_gold', model = `bkr_prop_weed_bud_01b`},
                time = 1000 * 60 * 30,
            },
            {
                need = {item = 'low_quality_coca_leaf', model = `bkr_prop_weed_leaf_01a`},
                get = {item = 'medium_quality_coca_leaf', model = `bkr_prop_weed_leaf_01a`},
                time = 1000 * 60 * 30,
            },
            {
                need = {item = 'medium_quality_coca_leaf', model = `bkr_prop_weed_leaf_01a`},
                get = {item = 'high_quality_coca_leaf', model = `bkr_prop_weed_leaf_01a`},
                time = 1000 * 60 * 30,
            },
            {
                need = {item = 'high_quality_coca_leaf', model = `bkr_prop_weed_leaf_01a`},
                get = {item = 'exotic_quality_coca_leaf', model = `bkr_prop_weed_leaf_01a`},
                time = 1000 * 60 * 30,
            },
            {
                need = {item = 'cubensis', model = `bkr_prop_weed_bud_01b`},
                get = {item = 'dried_cubensis', model = `bkr_prop_weed_bud_01b`},
                time = 1000 * 60 * 30,
            },
            {
                need = {item = 'liberty_cap', model = `bkr_prop_weed_bud_01b`},
                get = {item = 'dried_liberty_cap', model = `bkr_prop_weed_bud_01b`},
                time = 1000 * 60 * 30,
            },
            {
                need = {item = 'fly_agaric', model = `bkr_prop_weed_bud_01b`},
                get = {item = 'dried_fly_agaric', model = `bkr_prop_weed_bud_01b`},
                time = 1000 * 60 * 30,
            },
        },
        objectOffsets = {
            {offset = vec3(0.00, -0.23, 1.74), rotation = vec3(0.0, 180.0, 0.0)},
            {offset = vec3(0.00, -0.23, 1.47), rotation = vec3(0.0, 180.0, 0.0)},
            {offset = vec3(0.00, -0.23, 1.2), rotation = vec3(0.0, 180.0, 0.0)},
            {offset = vec3(0.00, -0.23, 0.93), rotation = vec3(0.0, 180.0, 0.0)},
            {offset = vec3(0.00, 0.23, 1.74), rotation = vec3(0.0, 180.0, 0.0)},
            {offset = vec3(0.00, 0.23, 1.47), rotation = vec3(0.0, 180.0, 0.0)},
            {offset = vec3(0.00, 0.23, 1.2), rotation = vec3(0.0, 180.0, 0.0)},
            {offset = vec3(0.00, 0.23, 0.93), rotation = vec3(0.0, 180.0, 0.0)},
        },
    },
    meth_chiller = {
        item = 'meth_chiller',
        equipmentType = 'processor',
        placement = 'floor',
        objects = {
            {model = `bkr_prop_meth_chiller_01a`, offset = vec3(0.0, 0.0, 0.0)},
        },
        items = {
            {
                need = {item = 'liquid_meth_tray', model = `bkr_prop_meth_tray_01a`},
                get = {item = 'meth_tray', model = `bkr_prop_meth_tray_02a`},
                time = 1000 * 60 * 30, -- in milliseconds, default 30 minutes
            },
        },
        objectOffsets = {
            {offset = vec3(-0.35, 0.0, 1.72)},
            {offset = vec3(-0.35, 0.0, 1.46)},
            {offset = vec3(-0.35, 0.0, 1.19)},
            {offset = vec3(-0.35, 0.0, 0.92)},
            {offset = vec3(-0.35, 0.0, 0.66)},
            {offset = vec3(-0.35, 0.0, 0.39)},
            {offset = vec3(0.37, 0.0, 1.72)},
            {offset = vec3(0.37, 0.0, 1.46)},
            {offset = vec3(0.37, 0.0, 1.19)},
            {offset = vec3(0.37, 0.0, 0.92)},
            {offset = vec3(0.37, 0.0, 0.66)},
            {offset = vec3(0.37, 0.0, 0.39)}
        },
    },
}

Config.EquipmentLocations = {
    --[[ oven_grove = {
        coords = vec3(6.1368, -1810.5800, 25.3458),
        rotation = vec3(0.0, 0.0, 137.2),
        configIndex = 'meth_oven',
    }, ]]
}

Config.CleanUpIPL = { -- will remove all default props in the interiors
    meth = true,
    weed = true,
    coke = true,
}

Config.LabInteriors = {
    meth = {
        label = 'Meth Lab',
        exit = vec4(997.0766, -3200.8137, -36.3937, 272.2013),
    },
    weed = {
        label = 'Weed Lab',
        exit = vec4(1066.2338, -3183.4260, -39.1636, 90.5153),
    },
    coke = {
        label = 'Coke Lab',
        exit = vec4(1088.5713, -3187.6255, -38.9935, 179.5658),
    },
}

Config.Labs = {
    {entrance = vec4(-924.73, -1163.82, 4.82, 35.25), labType = 'meth'},
    {entrance = vec4(-428.6, -1728.14, 19.78, 69.75), labType = 'weed'},
    {entrance = vec4(-77.26, 364.46, 112.44, 153.22), labType = 'coke'},
    {entrance = vec4(-321.41, 6302.61, 36.68, 317.92), labType = 'meth'},
    {entrance = vec4(35.41, 153.92, 117.52, 158.7), labType = 'weed'},
    {entrance = vec4(1737.65, -1474.97, 113.94, 339.68), labType = 'coke'},
    {entrance = vec4(-286.92, 6181.18, 31.49, 141.7), labType = 'meth'},
    {entrance = vec4(-80.09, 6525.9, 31.49, 43.94), labType = 'weed'},
    {entrance = vec4(813.02, -2398.62, 23.66, 176.62), labType = 'coke'},
    {entrance = vec4(-439.69, 295.18, 83.33, 88.82), labType = 'meth'},
    {entrance = vec4(1865.44, 3759.91, 33.0, 302.21), labType = 'weed'},
}

Config.Selling = {
    interactionDistance = 2.5, -- distance to interact with NPCs
    minPolice = 0, -- min cops online required
    moneyType = 'money',
    props = {
        drug = 'prop_meth_bag_01',
        money = 'prop_anim_cash_note',
    },
    items = {
        {
            name = 'low_quality_bagged_og_kush',
            price = {min = 35, max = 90},
            maxAmount = 15,
            baseChance = 85,
        },
        {
            name = 'medium_quality_bagged_og_kush',
            price = {min = 70, max = 150},
            maxAmount = 15,
            baseChance = 85,
        },
        {
            name = 'high_quality_bagged_og_kush',
            price = {min = 110, max = 220},
            maxAmount = 15,
            baseChance = 85,
        },
        {
            name = 'exotic_quality_bagged_og_kush',
            price = {min = 170, max = 330},
            maxAmount = 15,
            baseChance = 85,
        },
        {
            name = 'low_quality_bagged_northern_lights',
            price = {min = 30, max = 80},
            maxAmount = 15,
            baseChance = 85,
        },
        {
            name = 'medium_quality_bagged_northern_lights',
            price = {min = 60, max = 130},
            maxAmount = 15,
            baseChance = 85,
        },
        {
            name = 'high_quality_bagged_northern_lights',
            price = {min = 100, max = 200},
            maxAmount = 15,
            baseChance = 85,
        },
        {
            name = 'exotic_quality_bagged_northern_lights',
            price = {min = 150, max = 300},
            maxAmount = 15,
            baseChance = 85,
        },
        {
            name = 'low_quality_bagged_dosidos',
            price = {min = 30, max = 80},
            maxAmount = 15,
            baseChance = 85,
        },
        {
            name = 'medium_quality_bagged_dosidos',
            price = {min = 60, max = 130},
            maxAmount = 15,
            baseChance = 85,
        },
        {
            name = 'high_quality_bagged_dosidos',
            price = {min = 100, max = 200},
            maxAmount = 15,
            baseChance = 85,
        },
        {
            name = 'exotic_quality_bagged_dosidos',
            price = {min = 150, max = 300},
            maxAmount = 15,
            baseChance = 85,
        },
        {
            name = 'low_quality_bagged_acapulco_gold',
            price = {min = 25, max = 70},
            maxAmount = 15,
            baseChance = 85,
        },
        {
            name = 'medium_quality_bagged_acapulco_gold',
            price = {min = 55, max = 120},
            maxAmount = 15,
            baseChance = 85,
        },
        {
            name = 'high_quality_bagged_acapulco_gold',
            price = {min = 90, max = 185},
            maxAmount = 15,
            baseChance = 85,
        },
        {
            name = 'exotic_quality_bagged_acapulco_gold',
            price = {min = 140, max = 280},
            maxAmount = 15,
            baseChance = 85,
        },
        {
            name = 'low_quality_og_kush_joint',
            price = {min = 45, max = 110},
            maxAmount = 15,
            baseChance = 85,
        },
        {
            name = 'medium_quality_og_kush_joint',
            price = {min = 90, max = 185},
            maxAmount = 15,
            baseChance = 85,
        },
        {
            name = 'high_quality_og_kush_joint',
            price = {min = 145, max = 285},
            maxAmount = 15,
            baseChance = 85,
        },
        {
            name = 'exotic_quality_og_kush_joint',
            price = {min = 220, max = 440},
            maxAmount = 15,
            baseChance = 85,
        },
        {
            name = 'low_quality_northern_lights_joint',
            price = {min = 40, max = 100},
            maxAmount = 15,
            baseChance = 85,
        },
        {
            name = 'medium_quality_northern_lights_joint',
            price = {min = 80, max = 170},
            maxAmount = 15,
            baseChance = 85,
        },
        {
            name = 'high_quality_northern_lights_joint',
            price = {min = 130, max = 260},
            maxAmount = 15,
            baseChance = 85,
        },
        {
            name = 'exotic_quality_northern_lights_joint',
            price = {min = 200, max = 400},
            maxAmount = 15,
            baseChance = 85,
        },
        {
            name = 'low_quality_dosidos_joint',
            price = {min = 40, max = 100},
            maxAmount = 15,
            baseChance = 85,
        },
        {
            name = 'medium_quality_dosidos_joint',
            price = {min = 80, max = 170},
            maxAmount = 15,
            baseChance = 85,
        },
        {
            name = 'high_quality_dosidos_joint',
            price = {min = 130, max = 260},
            maxAmount = 15,
            baseChance = 85,
        },
        {
            name = 'exotic_quality_dosidos_joint',
            price = {min = 200, max = 400},
            maxAmount = 15,
            baseChance = 85,
        },
        {
            name = 'low_quality_acapulco_gold_joint',
            price = {min = 35, max = 90},
            maxAmount = 15,
            baseChance = 85,
        },
        {
            name = 'medium_quality_acapulco_gold_joint',
            price = {min = 70, max = 150},
            maxAmount = 15,
            baseChance = 85,
        },
        {
            name = 'high_quality_acapulco_gold_joint',
            price = {min = 115, max = 230},
            maxAmount = 15,
            baseChance = 85,
        },
        {
            name = 'exotic_quality_acapulco_gold_joint',
            price = {min = 175, max = 350},
            maxAmount = 15,
            baseChance = 85,
        },
        {
            name = 'bagged_meth',
            price = {min = 100, max = 220},
            maxAmount = 5,
            baseChance = 85,
        },
        {
            name = 'low_quality_bagged_cocaine',
            price = {min = 40, max = 100},
            maxAmount = 5,
            baseChance = 85,
        },
        {
            name = 'medium_quality_bagged_cocaine',
            price = {min = 80, max = 180},
            maxAmount = 5,
            baseChance = 85,
        },
        {
            name = 'high_quality_bagged_cocaine',
            price = {min = 140, max = 280},
            maxAmount = 5,
            baseChance = 85,
        },
        {
            name = 'exotic_quality_bagged_cocaine',
            price = {min = 200, max = 400},
            maxAmount = 5,
            baseChance = 85,
        },
        {
            name = 'low_quality_coke_brick',
            price = {min = 200, max = 450},
            maxAmount = 3,
            baseChance = 60,
        },
        {
            name = 'medium_quality_coke_brick',
            price = {min = 350, max = 700},
            maxAmount = 3,
            baseChance = 60,
        },
        {
            name = 'high_quality_coke_brick',
            price = {min = 500, max = 1000},
            maxAmount = 3,
            baseChance = 60,
        },
        {
            name = 'exotic_quality_coke_brick',
            price = {min = 800, max = 1500},
            maxAmount = 3,
            baseChance = 60,
        },
        {
            name = 'bagged_cubensis',
            price = {min = 80, max = 200},
            maxAmount = 8,
            baseChance = 85,
        },
        {
            name = 'bagged_liberty_cap',
            price = {min = 60, max = 160},
            maxAmount = 8,
            baseChance = 85,
        },
        {
            name = 'bagged_fly_agaric',
            price = {min = 40, max = 120},
            maxAmount = 8,
            baseChance = 85,
        },
        {
            name = 'heroin_syringe',
            price = {min = 100, max = 300},
            maxAmount = 5,
            baseChance = 75,
        },
        {
            name = 'speedball_syringe',
            price = {min = 400, max = 900},
            maxAmount = 3,
            baseChance = 70,
        },
        {
            name = 'wet_joint',
            price = {min = 350, max = 700},
            maxAmount = 8,
            baseChance = 75,
        },
    },
}

-- RunningSpeedIncrease: Makes you run faster
-- InfiniteStamina: You never get tired from sprinting
-- HealthRegen: Slowly heals you over time
-- ArmorBoost: Adds armor
-- DrunkEffect: You walk like you are drunk
-- BlurredVision: Blurry screen effect
-- SuperJump: You jump much higher
-- FocusEffect: Dark edges screen effect
-- FogEffect: Foggy screen effect
-- ConfusionEffect: Red screen effect
-- CameraShake: Shakes the screen once
-- WhiteoutEffect: Bright screen effect
-- IntenseEffect: Purple screen effect
-- ExplosiveEffect: You explode after a short delay
-- Tremors: Shakes the screen on and off
-- Nausea: Drops you to the ground every so often
-- Paranoia: Red flashing screen effect
-- Blur: Wavy screen effect
-- Cravings: Fading screen effect
-- Stumble: Drops you to the ground for a moment
-- GlitterBomb: Spawns a glitter ptfx around you

-- animation: 'pill' | 'blunt' | 'sniff' | 'syringe' | 'bong'
Config.Drugs = {
    explosive_meth = {
        drugType = 'Meth', -- for addiction menu
        animation = 'pill',
        effects = {'ExplosiveEffect'}, -- effects applied on use
        debuffs = {'Tremors', 'Nausea', 'Paranoia'}, -- effects that will be applied for being addicted to the drug
    },
    low_quality_og_kush_joint = {
        drugType = 'Weed',
        animation = 'blunt',
        effects = {'DrunkEffect'},
        debuffs = {'Nausea'},
    },
    medium_quality_og_kush_joint = {
        drugType = 'Weed',
        animation = 'blunt',
        effects = {'DrunkEffect', 'BlurredVision'},
        debuffs = {'Nausea'},
    },
    high_quality_og_kush_joint = {
        drugType = 'Weed',
        animation = 'blunt',
        effects = {'DrunkEffect', 'BlurredVision', 'FogEffect'},
        debuffs = {'Blur'},
    },
    exotic_quality_og_kush_joint = {
        drugType = 'Weed',
        animation = 'blunt',
        effects = {'DrunkEffect', 'BlurredVision', 'FogEffect', 'WhiteoutEffect'},
        debuffs = {'Cravings'},
    },
    low_quality_northern_lights_joint = {
        drugType = 'Weed',
        animation = 'blunt',
        effects = {'DrunkEffect'},
        debuffs = {'Nausea'},
    },
    medium_quality_northern_lights_joint = {
        drugType = 'Weed',
        animation = 'blunt',
        effects = {'DrunkEffect', 'BlurredVision'},
        debuffs = {'Nausea'},
    },
    high_quality_northern_lights_joint = {
        drugType = 'Weed',
        animation = 'blunt',
        effects = {'DrunkEffect', 'BlurredVision', 'FogEffect'},
        debuffs = {'Blur'},
    },
    exotic_quality_northern_lights_joint = {
        drugType = 'Weed',
        animation = 'blunt',
        effects = {'DrunkEffect', 'BlurredVision', 'FogEffect', 'WhiteoutEffect'},
        debuffs = {'Cravings'},
    },
    low_quality_dosidos_joint = {
        drugType = 'Weed',
        animation = 'blunt',
        effects = {'DrunkEffect'},
        debuffs = {'Nausea'},
    },
    medium_quality_dosidos_joint = {
        drugType = 'Weed',
        animation = 'blunt',
        effects = {'DrunkEffect', 'BlurredVision'},
        debuffs = {'Nausea'},
    },
    high_quality_dosidos_joint = {
        drugType = 'Weed',
        animation = 'blunt',
        effects = {'DrunkEffect', 'BlurredVision', 'FogEffect'},
        debuffs = {'Blur'},
    },
    exotic_quality_dosidos_joint = {
        drugType = 'Weed',
        animation = 'blunt',
        effects = {'DrunkEffect', 'BlurredVision', 'FogEffect', 'WhiteoutEffect'},
        debuffs = {'Cravings'},
    },
    low_quality_acapulco_gold_joint = {
        drugType = 'Weed',
        animation = 'blunt',
        effects = {'DrunkEffect'},
        debuffs = {'Nausea'},
    },
    medium_quality_acapulco_gold_joint = {
        drugType = 'Weed',
        animation = 'blunt',
        effects = {'DrunkEffect', 'BlurredVision'},
        debuffs = {'Nausea'},
    },
    high_quality_acapulco_gold_joint = {
        drugType = 'Weed',
        animation = 'blunt',
        effects = {'DrunkEffect', 'BlurredVision', 'FogEffect'},
        debuffs = {'Blur'},
    },
    exotic_quality_acapulco_gold_joint = {
        drugType = 'Weed',
        animation = 'blunt',
        effects = {'DrunkEffect', 'BlurredVision', 'FogEffect', 'WhiteoutEffect'},
        debuffs = {'Cravings'},
    },
    low_quality_cocaine = {
        drugType = 'Cocaine',
        animation = 'sniff',
        effects = {'FocusEffect'},
        debuffs = {'Paranoia'},
    },
    medium_quality_cocaine = {
        drugType = 'Cocaine',
        animation = 'sniff',
        effects = {'FocusEffect', 'ConfusionEffect'},
        debuffs = {'Paranoia'},
    },
    high_quality_cocaine = {
        drugType = 'Cocaine',
        animation = 'sniff',
        effects = {'FocusEffect', 'ConfusionEffect', 'IntenseEffect'},
        debuffs = {'Tremors'},
    },
    exotic_quality_cocaine = {
        drugType = 'Cocaine',
        animation = 'sniff',
        effects = {'FocusEffect', 'ConfusionEffect', 'IntenseEffect', 'CameraShake'},
        debuffs = {'Stumble'},
    },
    heroin_syringe = {
        drugType = 'Heroin',
        animation = 'syringe',
        effects = {'HealthRegen', 'DrunkEffect', 'BlurredVision'},
        debuffs = {'Tremors', 'Nausea', 'Stumble'},
    },
    cooked_cubensis = {
        drugType = 'Mushrooms',
        animation = 'pill',
        effects = {'ConfusionEffect', 'BlurredVision'},
        debuffs = {'Nausea'},
    },
    cooked_liberty_cap = {
        drugType = 'Mushrooms',
        animation = 'pill',
        effects = {'ConfusionEffect', 'BlurredVision', 'FogEffect'},
        debuffs = {'Paranoia'},
    },
    cooked_fly_agaric = {
        drugType = 'Mushrooms',
        animation = 'pill',
        effects = {'ConfusionEffect', 'BlurredVision', 'FogEffect', 'WhiteoutEffect'},
        debuffs = {'Stumble'},
    },
    speedball_syringe = {
        drugType = 'Heroin',
        animation = 'syringe',
        effects = {'HealthRegen', 'FocusEffect', 'IntenseEffect'},
        debuffs = {'Tremors', 'Stumble', 'Paranoia'},
    },
    wet_joint = {
        drugType = 'Weed',
        animation = 'blunt',
        effects = {'WhiteoutEffect', 'FocusEffect', 'FogEffect', 'ConfusionEffect'},
        debuffs = {'Stumble', 'Cravings'},
    },
    glitter_bomb_meth = {
        drugType = 'Meth',
        animation = 'pill',
        effects = {'GlitterBomb', 'ExplosiveEffect'},
        debuffs = {'Tremors'},
    },
    lsd_sheet = {
        drugType = 'LSD',
        animation = 'pill',
        effects = {'ConfusionEffect', 'BlurredVision', 'FogEffect', 'IntenseEffect'},
        debuffs = {'Paranoia', 'Nausea', 'Stumble'},
    },
}

Config.EffectDurations = {
    RunningSpeedIncrease = 60000, -- 1 minute
    InfiniteStamina = 60000,
    HealthRegen = 60000,
    ArmorBoost = 60000,
    DrunkEffect = 60000,
    BlurredVision = 60000,
    SuperJump = 60000,
    FocusEffect = 60000,
    FogEffect = 60000,
    ConfusionEffect = 60000,
    CameraShake = 60000,
    WhiteoutEffect = 60000,
    IntenseEffect = 60000,
    Tremors = 30000,
    Nausea = 45000,
    Blur = 30000,
    Paranoia = 25000,
    Stumble = 1500,
    Cravings = 30000,
}

Config.EffectAmounts = {
    RunningSpeedIncrease = 1.4, -- speed multiplier
    HealthRegen = 5, -- heal per tick (tick is 2s)
    ArmorBoost = 25, -- armor added
}

Config.Addiction = {
    command = 'addiction', -- command to open the addiction menu
    incrementPerUse = 5, -- addiction "level" added per use
    maxLevel = 100,
    saveInterval = 60 * 1000, -- ms between db saves
    decay = {
        perTick = 1, -- decay per tick when drug not used
        interval = 60 * 60 * 1000, -- 60 minutes
    },
    debuff = {
        threshold = 30, -- no debuffs below this level
        interval = { -- how often to apply debuffs
            minMs = 20 * 60 * 1000,
            maxMs = 60 * 60 * 1000,
            jitter = 0.2,
        },
        extraStrength = 1.5, -- at level 100 debuff lasts 1,5x normal
    },
    reliever = { -- items that pause addiction debuffs for all drugs for a certain duration
        items = {
            {name = 'methadone', durationMs = 30 * 60 * 1000, animation = 'syringe'}, -- 30 min
            {name = 'addiction_meds', durationMs = 45 * 60 * 1000, animation = 'pill'}, -- 45 min
        },
    },
}

Config.Shops = {
    {
        name = 'General Store',
        coords = vec4(-1164.78, -1566.37, 4.45, 299.5),
        ped = 's_m_y_robber_01',
        moneyType = 'money',
        items = {
            {name = 'petrol_can', price = 100, amount = 1},
            {name = 'og_kush_seed', price = 120, amount = 1},
            {name = 'northern_lights_seed', price = 110, amount = 1},
            {name = 'dosidos_seed', price = 100, amount = 1},
            {name = 'acapulco_gold_seed', price = 130, amount = 1},
            {name = 'coca_seed', price = 200, amount = 1},
            {name = 'plant_pot', price = 10, amount = 1},
            {name = 'fertilizer', price = 10, amount = 1},
            {name = 'water_bottle', price = 10, amount = 1},
            {name = 'poppy_resin', price = 75, amount = 1},
            {name = 'acetic_anhydride', price = 90, amount = 1},
            {name = 'empty_syringe', price = 15, amount = 1},
            {name = 'rye_ergot', price = 100, amount = 1},
            {name = 'diethylamine', price = 60, amount = 1},
            {name = 'paper_sheet', price = 10, amount = 1},
            {name = 'rolling_paper', price = 10, amount = 1},
            {name = 'banana', price = 25, amount = 1},
            {name = 'caffeine_powder', price = 50, amount = 1},
            {name = 'glitter_powder', price = 30, amount = 1},
            {name = 'pseudo', price = 10, amount = 1},
            {name = 'acid', price = 10, amount = 1},
            {name = 'phos', price = 10, amount = 1},
            {name = 'baggy', price = 1, amount = 1},
            {name = 'empty_tray', price = 5, amount = 1},
            {name = 'trap_phone', price = 500, amount = 1}, --
        }
    },
    {
        name = 'Equipment Store',
        coords = vec4(-68.82, 6256.33, 31.09, 153.0),
        ped = 's_m_y_robber_01',
        moneyType = 'money',
        items = {
            {name = 'meth_oven', price = 1000, amount = 1},
            {name = 'meth_cooking_table', price = 1000, amount = 1},
            {name = 'meth_chiller', price = 1000, amount = 1},
            {name = 'coke_oven', price = 1000, amount = 1},
            {name = 'mixer', price = 1000, amount = 1},
            {name = 'bagging_table', price = 1000, amount = 1},
            {name = 'cauldron', price = 1000, amount = 1},
            {name = 'press', price = 1000, amount = 1},
            {name = 'default_lamp', price = 100, amount = 1},
            {name = 'ac_unit', price = 1500, amount = 1},
            {name = 'drug_shelf', price = 1500, amount = 1},
            {name = 'drying_rack', price = 1500, amount = 1},
            {name = 'heroin_cooking_table', price = 1500, amount = 1},
            {name = 'lsd_table', price = 1500, amount = 1},
            {name = 'joint_roller_table', price = 1500, amount = 1},
        }
    },
}

Config.Plants = {
    og_kush_seed = {
        item = 'og_kush_seed',
        neededItems = {
            {name = 'plant_pot', amount = 1, remove = true},
        },
        budModel = 'bkr_prop_weed_bud_01b',
        leafModel = 'bkr_prop_weed_bud_01b',
        stages = {
            {model = `ng_prop_weed_s_ogkush_c`, time = 60 * 60, offset = vec3(0.0, 0.0, 0.0)},
            {model = `ng_prop_weed_s_ogkush_a`, time = 60 * 60, offset = vec3(0.0, 0.0, 0.0)},
            {model = `ng_prop_weed_m_ogkush_a`, time = 60 * 60, offset = vec3(0.0, 0.0, 0.0)},
            {model = `ng_prop_weed_b_ogkush_a`, time = 60 * 500, offset = vec3(0.0, 0.0, 0.0)}, -- time for last stage will determine how long for plant to die if it's not harvested
        },
        yield = {-- chance is rolled for each item individually (so you can get multiple items)
            {item = 'low_quality_og_kush', amount = {min = 3, max = 8}, chance = 100},
            {item = 'og_kush_seed', amount = {min = 0, max = 1}, chance = 50},
        },
    },
    northern_lights_seed = {
        item = 'northern_lights_seed',
        neededItems = {
            {name = 'plant_pot', amount = 1, remove = true},
        },
        budModel = 'bkr_prop_weed_bud_01b',
        leafModel = 'bkr_prop_weed_bud_01b',
        stages = {
            {model = `ng_prop_weed_s_nlights_c`, time = 60 * 60, offset = vec3(0.0, 0.0, 0.0)},
            {model = `ng_prop_weed_s_nlights_a`, time = 60 * 60, offset = vec3(0.0, 0.0, 0.0)},
            {model = `ng_prop_weed_m_nlights_a`, time = 60 * 60, offset = vec3(0.0, 0.0, 0.0)},
            {model = `ng_prop_weed_b_nlights_a`, time = 60 * 500, offset = vec3(0.0, 0.0, 0.0)},
        },
        yield = {
            {item = 'low_quality_northern_lights', amount = {min = 3, max = 8}, chance = 100},
            {item = 'northern_lights_seed', amount = {min = 0, max = 1}, chance = 50},
        },
    },
    dosidos_seed = {
        item = 'dosidos_seed',
        neededItems = {
            {name = 'plant_pot', amount = 1, remove = true},
        },
        budModel = 'bkr_prop_weed_bud_01b',
        leafModel = 'bkr_prop_weed_bud_01b',
        stages = {
            {model = `ng_prop_weed_s_dosidos_c`, time = 60 * 60, offset = vec3(0.0, 0.0, 0.0)},
            {model = `ng_prop_weed_s_dosidos_a`, time = 60 * 60, offset = vec3(0.0, 0.0, 0.0)},
            {model = `ng_prop_weed_m_dosidos_a`, time = 60 * 60, offset = vec3(0.0, 0.0, 0.0)},
            {model = `ng_prop_weed_b_dosidos_a`, time = 60 * 500, offset = vec3(0.0, 0.0, 0.0)},
        },
        yield = {
            {item = 'low_quality_dosidos', amount = {min = 3, max = 8}, chance = 100},
            {item = 'dosidos_seed', amount = {min = 0, max = 1}, chance = 50},
        },
    },
    acapulco_gold_seed = {
        item = 'acapulco_gold_seed',
        neededItems = {
            {name = 'plant_pot', amount = 1, remove = true},
        },
        budModel = 'bkr_prop_weed_bud_01b',
        leafModel = 'bkr_prop_weed_bud_01b',
        stages = {
            {model = `ng_prop_weed_s_acagold_c`, time = 60 * 60, offset = vec3(0.0, 0.0, 0.0)},
            {model = `ng_prop_weed_s_acagold_a`, time = 60 * 60, offset = vec3(0.0, 0.0, 0.0)},
            {model = `ng_prop_weed_m_acagold_a`, time = 60 * 60, offset = vec3(0.0, 0.0, 0.0)},
            {model = `ng_prop_weed_b_acagold_a`, time = 60 * 500, offset = vec3(0.0, 0.0, 0.0)},
        },
        yield = {
            {item = 'low_quality_acapulco_gold', amount = {min = 3, max = 8}, chance = 100},
            {item = 'acapulco_gold_seed', amount = {min = 0, max = 1}, chance = 50},
        },
    },
    coca_seed = {
        item = 'coca_seed',
        neededItems = {
            {name = 'plant_pot', amount = 1, remove = true},
        },
        budModel = 'bkr_prop_weed_bud_01b',
        leafModel = 'bkr_prop_weed_leaf_01a',
        stages = {
            {model = `bkr_prop_weed_01_small_01c`, time = 60 * 60, offset = vec3(0.0, 0.0, 0.0)},
            {model = `bkr_prop_weed_01_small_01a`, time = 60 * 60, offset = vec3(0.0, 0.0, 0.0)},
            {model = `bkr_prop_weed_med_01b`, time = 60 * 60, offset = vec3(0.0, 0.0, -2.5)},
            {model = `bkr_prop_weed_lrg_01b`, time = 60 * 500, offset = vec3(0.0, 0.0, -2.5)},
        },
        yield = {
            {item = 'low_quality_coca_leaf', amount = {min = 3, max = 10}, chance = 100},
            {item = 'coca_seed', amount = {min = 0, max = 2}, chance = 50},
        }
    },
}

Config.PlantSettings = {
    maxPlantsPerPlayer = 100, -- max plants a player can have at once, set to nil to disable
    --maxPlantsInArea = {radius = 50.0, amount = 20}, -- max plants within a radius around the coords where you are placing a new plant
    waterDecayRate = 0.2, -- per minute on 0-100 scale
    fertilizerDecayRate = 0.1, -- per minute on 0-100 scale
    updateInterval = 60000, -- tick interval in ms
    water = {
        item = 'water_bottle',
        amount = 1,
        model = `prop_ld_flow_bottle`,
        fxOffset = vec3(0.0, 0.0, 0.1),
        rotateOffset = vec3(10.0, 0.0, 0.0),
    },
    fertilizer = {
        item = 'fertilizer',
        amount = 1,
        model = `prop_cs_sack_01`,
        fxOffset = vec3(0.0, 0.0, 0.1),
        rotateOffset = vec3(10.0, 0.0, 0.0),
    },
    defaultWater = 50,
    defaultFertilizer = 50,
}

Config.OnlineOnlyGrowth = false -- when true, plants only grow while their owner is online

Config.Boosters = { -- items that boost plant growth speed and "processor" equipment speed
    default_lamp = {
        item = 'default_lamp',
        model = `xm_prop_base_tripod_lampb`,
        offset = vec3(0.0, 0.0, 0.0),
        radius = 3.0, -- area of effect radius
        speedMultiplier = 1.5,
        placement = 'floor',
        allowedEquipment = {'og_kush_seed', 'northern_lights_seed', 'dosidos_seed', 'acapulco_gold_seed', 'coca_seed'}, -- what equipment/plants will this booster affect
    },
    ac_unit = {
        item = 'ac_unit',
        model = `prop_aircon_s_02b`,
        offset = vec3(0.0, 0.0, -1.0),
        radius = 3.0,
        speedMultiplier = 1.5,
        placement = 'wall',
        allowedEquipment = {'meth_chiller', 'drying_rack'},
    },
}

Config.PickPocketing = {
    cells = {min = 5, max = 5}, -- total cells per ped
    itemsPerPed = {min = 2, max = 4}, -- how many cells have an item
    arrowSpeed = 1.0,

    cooldown = 60000, -- ms between pickpockets per player, 0 to disable

    interactDistance = 2.5, -- max distance from ped in meters
    behindAngle = 90.0, -- size of the cone behind the ped in degrees

    disabledModels = {}, -- ped models that cannot be pickpocketed

    -- difficulty: smaller = easier
    items = {
        {name = 'money', amount = {min = 25, max = 200}, chance = 60, difficulty = 0.5},
        {name = 'og_kush_seed', amount = {min = 1, max = 2}, chance = 8, difficulty = 0.7},
        {name = 'northern_lights_seed', amount = {min = 1, max = 2}, chance = 8, difficulty = 0.7},
        {name = 'dosidos_seed', amount = {min = 1, max = 2}, chance = 8, difficulty = 0.7},
        {name = 'acapulco_gold_seed', amount = {min = 1, max = 2}, chance = 8, difficulty = 0.7},
        {name = 'coca_seed', amount = {min = 1, max = 2}, chance = 15, difficulty = 0.8},
        {name = 'fertilizer', amount = {min = 1, max = 2}, chance = 25, difficulty = 0.4},
        {name = 'water_bottle', amount = {min = 1, max = 2}, chance = 25, difficulty = 0.4},
        {name = 'poppy_resin', amount = {min = 1, max = 2}, chance = 20, difficulty = 0.6},
    },
}

Config.WorkerSettings = {
    tickInterval = 1000,
    walkSpeed = 1.0,
    speedMultipliers = {0.7, 0.85, 1.0, 1.25, 1.6}, -- speeds for worker levels 1-5, length must match speedWeights
    pickupDurationMs = 1000, -- pickup time in ms
    dropDurationMs = 1000, -- drop time in ms
    maxPerLab = 10, -- max workers per lab
    maxHired = 10, -- max workers per player across all labs
    pool = {
        maxSize = 10, -- max workers available to hire at once
        refillInterval = 5 * 60 * 1000, -- 5 minutes
        availableExpirySeconds = 24 * 60 * 60, -- workers available to hire will expire after this many seconds, default 24 hours
        hireCost = {
            min = 2000,
            max = 12000,
        },
        speedWeights = {50, 28, 15, 5, 2}, -- how common each worker level is when new worker is generated (higher = more common), length must match speedMultipliers
    },
    processingTime = {
        default = 30000, -- fallback in ms
        oven = 30000,
        meth_cooking = 30000,
        mixer = 20000,
        bagging = 15000,
        cauldron = 30000,
        press = 30000,
        syringe = 30000,
        dropper = 25000,
    },
    pedModel = {
        's_m_m_dockwork_01',
        's_m_y_construct_01',
        'a_m_m_hillbilly_01',
        'g_m_y_lost_01',
    },
    idleAnim = {scenario = 'WORLD_HUMAN_STAND_IMPATIENT'},
    workAnim = {dict = 'mini@repair', name = 'fixing_a_player', flag = 49},
    fetchAnim = {dict = 'mini@repair', name = 'fixing_a_player', flag = 49},
}

Config.Fields = {
    {
        coords = vec3(-2017.22, 1450.02, 276.13),
        radius = 20.0,
        maxActivePlants = 20, -- max active plants at once
        plants = {
            {item = 'cubensis', amount = {min = 1, max = 1}, chance = 50, model = `dl_shroom_41`, scale = 10.0, textOffset = vec3(0.0, 0.0, -0.9)},
            {item = 'liberty_cap', amount = {min = 1, max = 1}, chance = 50, model = `dl_shroom_12`, scale = 10.0, textOffset = vec3(0.0, 0.0, -0.9)},
            {item = 'fly_agaric', amount = {min = 1, max = 1}, chance = 50, model = `dl_shroom_20`, scale = 3.0, textOffset = vec3(0.0, 0.0, -0.9)},
            {item = 'rye_ergot', amount = {min = 1, max = 1}, chance = 50, model = `prop_weed_02`, scale = 1.0, textOffset = vec3(0.0, 0.0, -0.6)},
        }
    }
}

Config.PhoneSettings = {
    item = 'trap_phone',
    apps = {
        listings = true, -- change true to false to disable app
        crew = true,
        plug = true,
        settings = true,
    },
    moneyAccount = 'bank', -- money account for purchases
    labPrice = 50000, -- how much does a drug lab cost
    sellPercentage = 50, -- percentage of the price that you get when selling a lab, set to nil to disable selling labs
    maxOwnedLabs = 1, -- max labs a player can own
    walkIn = { -- settings for ped that spawns near lab when you hire a worker
        triggerDistance = 50.0, -- how close you need to be to lab entrance for ped to spawn
        spawnDistance = 15.0,
        durationSeconds = 12,
        walkSpeed = 1.0,
    },
}

Config.PlugApp = {
    sellMode = 'walkup', -- 'delivery' | 'walkup', delivery = players goes to NPC coords, walkup = NPC spawns near player and walks up to them
    moneyType = 'money',
    cooldownMinutes = 20, -- cooldown per customer after interaction
    interactionDistance = 3.0,
    handoffDistance = 2.5,
    pedDespawnDelayMs = 15000,
    walkupSpawnDistance = 20.0, -- ped spawn distance from player

    contacts = {
        addChance = 15, -- % chance per successful sale
        max = 10, -- max contacts per player
        initial = { -- customers that are automatically added to every player's contacts
            {name = 'Marco', pedModel = 'a_m_y_hipster_01', rep = 0},
        },
    },
    counter = {
        maxRounds = 3, -- how many times can a customer counter offer
        delayMs = {min = 2500, max = 5000}, -- ms reply delay
    },
    delivery = {
        spawnDelayMs = {min = 4000, max = 8000}, -- ms delay before location reveal
        timeoutMinutes = 10,
    },
    rep = {
        tiers = {
            {minRep = 0, name = 'Stranger', maxAmountMultiplier = 0.4, priceMultiplier = 0.40},
            {minRep = 50, name = 'Acquaintance', maxAmountMultiplier = 0.6, priceMultiplier = 0.55},
            {minRep = 150, name = 'Regular', maxAmountMultiplier = 0.8, priceMultiplier = 0.70},
            {minRep = 750, name = 'Trusted', maxAmountMultiplier = 1.0, priceMultiplier = 0.85},
            {minRep = 2500, name = 'Plug', maxAmountMultiplier = 1.2, priceMultiplier = 1.00},
        },
        gainPerSale = 5,
    },

    pedModels = {
        'a_m_y_hipster_01', 'a_m_y_hipster_02', 'a_m_y_hipster_03',
        'a_m_y_skater_01', 'a_m_y_skater_02',
        'a_m_y_downtown_01', 'a_m_y_genstreet_01', 'a_m_y_stbla_02',
        'a_f_y_hipster_01', 'a_f_y_hipster_02', 'a_f_y_hipster_03',
        'a_f_y_genhot_01'
    },

    -- maxAmount: maximum amount you can sell at a time (multiplied by rep tier maxAmountMultiplier)
    -- fairMin/fairMax: control what the customer considers a "fair" price per one, affects counter offer logic and the final price
    items = {
        {name = 'low_quality_bagged_og_kush', maxAmount = 25, fairMin = 30, fairMax = 80},
        {name = 'medium_quality_bagged_og_kush', maxAmount = 20, fairMin = 55, fairMax = 125},
        {name = 'high_quality_bagged_og_kush', maxAmount = 15, fairMin = 95, fairMax = 185},
        {name = 'exotic_quality_bagged_og_kush', maxAmount = 10, fairMin = 145, fairMax = 275},
        {name = 'low_quality_bagged_northern_lights', maxAmount = 25, fairMin = 25, fairMax = 70},
        {name = 'medium_quality_bagged_northern_lights', maxAmount = 20, fairMin = 50, fairMax = 110},
        {name = 'high_quality_bagged_northern_lights', maxAmount = 15, fairMin = 85, fairMax = 170},
        {name = 'exotic_quality_bagged_northern_lights', maxAmount = 10, fairMin = 130, fairMax = 250},
        {name = 'low_quality_bagged_dosidos', maxAmount = 25, fairMin = 25, fairMax = 70},
        {name = 'medium_quality_bagged_dosidos', maxAmount = 20, fairMin = 50, fairMax = 110},
        {name = 'high_quality_bagged_dosidos', maxAmount = 15, fairMin = 85, fairMax = 170},
        {name = 'exotic_quality_bagged_dosidos', maxAmount = 10, fairMin = 130, fairMax = 250},
        {name = 'low_quality_bagged_acapulco_gold', maxAmount = 25, fairMin = 20, fairMax = 60},
        {name = 'medium_quality_bagged_acapulco_gold', maxAmount = 20, fairMin = 45, fairMax = 100},
        {name = 'high_quality_bagged_acapulco_gold', maxAmount = 15, fairMin = 75, fairMax = 155},
        {name = 'exotic_quality_bagged_acapulco_gold', maxAmount = 10, fairMin = 115, fairMax = 225},
        {name = 'low_quality_bagged_cocaine', maxAmount = 25, fairMin = 35, fairMax = 85},
        {name = 'medium_quality_bagged_cocaine', maxAmount = 20, fairMin = 70, fairMax = 150},
        {name = 'high_quality_bagged_cocaine', maxAmount = 15, fairMin = 120, fairMax = 240},
        {name = 'exotic_quality_bagged_cocaine', maxAmount = 10, fairMin = 170, fairMax = 340},
        {name = 'low_quality_coke_brick', maxAmount = 5, fairMin = 180, fairMax = 380},
        {name = 'medium_quality_coke_brick', maxAmount = 5, fairMin = 300, fairMax = 600},
        {name = 'high_quality_coke_brick', maxAmount = 5, fairMin = 450, fairMax = 850},
        {name = 'exotic_quality_coke_brick', maxAmount = 5, fairMin = 700, fairMax = 1300},
        {name = 'bagged_cubensis', maxAmount = 15, fairMin = 90, fairMax = 180},
        {name = 'bagged_liberty_cap', maxAmount = 15, fairMin = 70, fairMax = 140},
        {name = 'bagged_fly_agaric', maxAmount = 15, fairMin = 50, fairMax = 110},
        {name = 'bagged_meth', maxAmount = 15, fairMin = 80, fairMax = 220},
        {name = 'heroin_syringe', maxAmount = 10, fairMin = 90, fairMax = 250},
    },

    blip = { -- blip used for the delivery
        sprite = 280,
        color = 2,
        scale = 0.9,
    },
}

Config.DeliveryCoords = { -- coords where the plug app delivery NPC can spawn
    vec4(-954.3112, -897.4698, 2.1631, 252.0240),
    vec4(-1201.8463, -1798.2870, 3.9086, 112.3684),
    vec4(-1166.6790, -2026.1301, 13.1606, 96.3059),
    vec4(-337.1262, -2441.7097, 6.0006, 27.9284),
    vec4(1150.0983, -1408.0233, 34.6756, 131.3635),
    vec4(-1986.4216, -314.3056, 48.1063, 102.2270),
    vec4(-1603.3248, -832.8965, 10.0766, 349.0566),
    vec4(215.0884, -3136.1389, 5.7903, 334.9254),
    vec4(243.6711, -1968.5625, 21.9617, 221.6919),
    vec4(-552.6535, -1802.2335, 22.4855, 54.1508),
    vec4(2578.8657, 285.7567, 108.6070, 276.5376),
    vec4(2670.5530, 1606.8339, 24.5007, 290.7734),
    vec4(2353.1973, 1841.6737, 102.3372, 51.3286),
    vec4(-1927.7257, 2039.2531, 140.8333, 255.9864),
    vec4(-3188.9487, 1071.9424, 20.8407, 40.1232),
    vec4(-2541.4624, 2319.2581, 33.2153, 358.2238),
    vec4(-1127.3806, 2694.1992, 18.8004, 71.2564),
    vec4(885.6114, 2850.1533, 56.6693, 96.7197),
    vec4(2591.8579, 4669.4121, 34.0767, 227.1386),
    vec4(1697.1654, 6429.7329, 32.6863, 134.4772),
    vec4(1536.6567, 6341.9736, 24.1378, 128.2433),
    vec4(1424.7181, 6339.8032, 23.9892, 309.8332),
    vec4(146.3021, 6647.1304, 31.6551, 165.6942),
    vec4(-86.2771, 6373.5645, 31.4903, 284.1078),
    vec4(-244.1666, 6063.3394, 31.8105, 143.9101),
    vec4(-361.1337, 6102.5791, 31.4952, 266.6971),
    vec4(-284.3962, 6303.8037, 31.4922, 98.9378),
    vec4(-775.7163, 5593.2222, 33.6328, 199.0702),
    vec4(-571.7877, 5363.1187, 70.2152, 234.2661),
}