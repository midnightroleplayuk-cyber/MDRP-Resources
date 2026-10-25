Config.Animal = {
    ["bdogbark"] = {
        "creatures@rottweiler@amb@world_dog_barking@idle_a",
        "idle_a",
        "Bark (big dog)",
        animationOptions = {
            emoteLoop = true,
            onlyAnimals = true,
        }
    },
    ["bdogindicateahead"] = {
        "creatures@rottweiler@indication@",
        "indicate_ahead",
        "Indicate Ahead (big dog)",
        animationOptions = {
            emoteLoop = true,
            onlyAnimals = true,
        }
    },
    ["bdogindicatehigh"] = {
        "creatures@rottweiler@indication@",
        "indicate_high",
        "Indicate High (big dog)",
        animationOptions = {
            emoteLoop = true,
            onlyAnimals = true,
        }
    },
    ["bdogindicatelow"] = {
        "creatures@rottweiler@indication@",
        "indicate_low",
        "Indicate Low (big dog)",
        animationOptions = {
            emoteLoop = true,
            onlyAnimals = true,
        }
    },
    ["bdogbeg"] = {
        "creatures@rottweiler@tricks@",
        "beg_loop",
        "Beg (big dog)",
        animationOptions = {
            emoteLoop = true,
            onlyAnimals = true,
        }
    },
    ["bdogbeg2"] = {
        "creatures@rottweiler@tricks@",
        "paw_right_loop",
        "Beg 2 (big dog)",
        animationOptions = {
            emoteLoop = true,
            onlyAnimals = true,
        }
    },
    ["bdoglayright"] = {
        "creatures@rottweiler@move",
        "dead_right",
        "Lay Right (big dog)",
        animationOptions = {
            emoteLoop = true,
            onlyAnimals = true,
        }
    },
    ["bdoglayleft"] = {
        "creatures@rottweiler@move",
        "dead_left",
        "Lay Left (big dog)",
        animationOptions = {
            emoteLoop = true,
            onlyAnimals = true,
        }
    },
    ["bdogsitcar"] = {
        "creatures@rottweiler@incar@",
        "sit",
        "Sit in car (big dog)",
        animationOptions = {
            emoteLoop = false,
            onlyAnimals = true,
            customMovementType = 1
        }
    },
    ["bdogfhump"] = {
        "creatures@rottweiler@amb@",
        "hump_loop_ladydog",
        "Female Hump (big dog)",
        animationOptions = {
            emoteLoop = true,
            onlyAnimals = true,
        },
        AdultAnimation = true,
        AnimalEmote = true
    },
    ["bdogmhump"] = {
        "creatures@rottweiler@amb@",
        "hump_loop_chop",
        "Male Hump (big dog)",
        animationOptions = {
            emoteLoop = true,
            onlyAnimals = true,
        },
        AdultAnimation = true,
        AnimalEmote = true
    },
    ["bdogshit"] = {
        "creatures@rottweiler@move",
        "dump_loop",
        "Shit (big dog)",
        animationOptions = {
            emoteLoop = true,
            onlyAnimals = true,
            emoteMoving = false,
            ptfxAsset = "scr_amb_chop",
            ptfxName = "ent_anim_dog_poo",
            ptfxNoProp = true,
            ptfxPlacement = {
                0.10,
                -0.08,
                0.0,
                0.0,
                90.0,
                180.0,
                1.0
            },
            ptfxInfo = "to pee",
            ptfxWait = 0,
            ptfxCanHold = true
        }
    },
    ["bdogitch"] = {
        "creatures@rottweiler@amb@world_dog_sitting@idle_a",
        "idle_a",
        "Itch (big dog)",
        animationOptions = {
            emoteDuration = 2000
        }
    },
    ["bdogsleep"] = {
        "creatures@rottweiler@amb@sleep_in_kennel@",
        "sleep_in_kennel",
        "Sleep (big dog)",
        animationOptions = {
            emoteLoop = true,
            onlyAnimals = true,
        }
    },
    ["bdogsit"] = {
        "creatures@rottweiler@amb@world_dog_sitting@base",
        "base",
        "Sit (big dog)",
        animationOptions = {
            emoteLoop = true,
            onlyAnimals = true,
        }
    },
    ["bdogpee"] = {
        "creatures@rottweiler@move",
        "pee_left_idle",
        "Pee (big dog)",
        animationOptions = {
            emoteLoop = true,
            onlyAnimals = true,
            ptfxAsset = "scr_amb_chop",
            ptfxName = "ent_anim_dog_peeing",
            ptfxNoProp = true,
            ptfxPlacement = {
                -0.15,
                -0.35,
                0.0,
                0.0,
                90.0,
                180.0,
                1.0
            },
            ptfxInfo = "to pee",
            ptfxWait = 0,
            ptfxCanHold = true
        }
    },
    ["bdogpee2"] = {
        "creatures@rottweiler@move",
        "pee_right_idle",
        "Pee 2 (big dog)",
        animationOptions = {
            emoteLoop = true,
            onlyAnimals = true,
            ptfxAsset = "scr_amb_chop",
            ptfxName = "ent_anim_dog_peeing",
            ptfxNoProp = true,
            ptfxPlacement = {
                0.15,
                -0.35,
                0.0,
                0.0,
                90.0,
                0.0,
                1.0
            },
            ptfxInfo = "to pee",
            ptfxWait = 0,
            ptfxCanHold = true
        }
    },
    ["bdogglowa"] = {
        "creatures@rottweiler@amb@world_dog_sitting@base",
        "nill",
        "Glow Stick (big dog)",
        animationOptions = {
            prop = 'ba_prop_battle_glowstick_01',
            propBone = 31086,
            propPlacement = {
                0.2000,
                0.000,
                -0.0600,
                90.00,
                0.00,
                0.00
            },
            emoteLoop = true,
            onlyAnimals = true,
            emoteMoving = true
        }
    },
    ["bdogglowb"] = {
        "creatures@rottweiler@amb@world_dog_sitting@base",
        "base",
        "Glow Stick Sitting (big dog)",
        animationOptions = {
            prop = 'ba_prop_battle_glowstick_01',
            propBone = 31086,
            propPlacement = {
                0.2000,
                0.000,
                -0.0600,
                90.00,
                0.00,
                0.00
            },
            emoteLoop = true,
            onlyAnimals = true,
        }
    },
    ["bdogpridea"] = {
        "creatures@rottweiler@amb@world_dog_sitting@base",
        "base",
        "Sit Pride A (big dog)",
        animationOptions = {
            prop = 'lilprideflag1', -- Rainbow
            propBone = 31086,
            propPlacement = {
                0.1900,
                0.0000,
                -0.0500,
                100.0000,
                90.0000,
                0.0000
            },
            secondProp = 'lilprideflag1',
            secondPropBone = 31086,
            secondPropPlacement = {
                0.1940,
                0.020,
                -0.0500,
                -90.0000,
                -90.0000,
                0.0000
            },
            emoteLoop = true,
            onlyAnimals = true,
        }
    },
    ["bdogprideb"] = {
        "creatures@rottweiler@amb@world_dog_sitting@base",
        "base",
        "Sit Pride B - LGBTQIA (big dog)",
        animationOptions = {
            prop = 'lilprideflag2', -- LGBTQIA
            propBone = 31086,
            propPlacement = {
                0.1900,
                0.0000,
                -0.0500,
                100.0000,
                90.0000,
                0.0000
            },
            secondProp = 'lilprideflag2',
            secondPropBone = 31086,
            secondPropPlacement = {
                0.1940,
                0.020,
                -0.0500,
                -90.0000,
                -90.0000,
                0.0000
            },
            emoteLoop = true,
            onlyAnimals = true,
        }
    },
    ["bdogpridec"] = {
        "creatures@rottweiler@amb@world_dog_sitting@base",
        "base",
        "Sit Pride C - Bisexual (big dog)",
        animationOptions = {
            prop = 'lilprideflag3', -- Bisexual
            propBone = 31086,
            propPlacement = {
                0.1900,
                0.0000,
                -0.0500,
                100.0000,
                90.0000,
                0.0000
            },
            secondProp = 'lilprideflag3',
            secondPropBone = 31086,
            secondPropPlacement = {
                0.1940,
                0.020,
                -0.0500,
                -90.0000,
                -90.0000,
                0.0000
            },
            emoteLoop = true,
            onlyAnimals = true,
        }
    },
    ["bdogprided"] = {
        "creatures@rottweiler@amb@world_dog_sitting@base",
        "base",
        "Sit Pride D - Lesbian (big dog)",
        animationOptions = {
            prop = 'lilprideflag4', -- Lesbian
            propBone = 31086,
            propPlacement = {
                0.1900,
                0.0000,
                -0.0500,
                100.0000,
                90.0000,
                0.0000
            },
            secondProp = 'lilprideflag4',
            secondPropBone = 31086,
            secondPropPlacement = {
                0.1940,
                0.020,
                -0.0500,
                -90.0000,
                -90.0000,
                0.0000
            },
            emoteLoop = true,
            onlyAnimals = true,
        }
    },
    ["bdogpridee"] = {
        "creatures@rottweiler@amb@world_dog_sitting@base",
        "base",
        "Sit Pride E - Pansexual (big dog)",
        animationOptions = {
            prop = 'lilprideflag5', -- Pansexual
            propBone = 31086,
            propPlacement = {
                0.1900,
                0.0000,
                -0.0500,
                100.0000,
                90.0000,
                0.0000
            },
            secondProp = 'lilprideflag5',
            secondPropBone = 31086,
            secondPropPlacement = {
                0.1940,
                0.020,
                -0.0500,
                -90.0000,
                -90.0000,
                0.0000
            },
            emoteLoop = true,
            onlyAnimals = true,
        }
    },
    ["bdogpridef"] = {
        "creatures@rottweiler@amb@world_dog_sitting@base",
        "base",
        "Sit Pride F - Transgender  (big dog)",
        animationOptions = {
            prop = 'lilprideflag6', -- Transgender
            propBone = 31086,
            propPlacement = {
                0.1900,
                0.0000,
                -0.0500,
                100.0000,
                90.0000,
                0.0000
            },
            secondProp = 'lilprideflag6',
            secondPropBone = 31086,
            secondPropPlacement = {
                0.1940,
                0.020,
                -0.0500,
                -90.0000,
                -90.0000,
                0.0000
            },
            emoteLoop = true,
            onlyAnimals = true,
        }
    },
    ["bdogprideg"] = {
        "creatures@rottweiler@amb@world_dog_sitting@base",
        "base",
        "Sit Pride G - Non Binary (big dog)",
        animationOptions = {
            prop = 'lilprideflag7', -- Non Binary
            propBone = 31086,
            propPlacement = {
                0.1900,
                0.0000,
                -0.0500,
                100.0000,
                90.0000,
                0.0000
            },
            secondProp = 'lilprideflag7',
            secondPropBone = 31086,
            secondPropPlacement = {
                0.1940,
                0.020,
                -0.0500,
                -90.0000,
                -90.0000,
                0.0000
            },
            emoteLoop = true,
            onlyAnimals = true,
        }
    },
    ["bdogprideh"] = {
        "creatures@rottweiler@amb@world_dog_sitting@base",
        "base",
        "Sit Pride H - Asexual (big dog)",
        animationOptions = {
            prop = 'lilprideflag8', -- Asexual
            propBone = 31086,
            propPlacement = {
                0.1900,
                0.0000,
                -0.0500,
                100.0000,
                90.0000,
                0.0000
            },
            secondProp = 'lilprideflag8',
            secondPropBone = 31086,
            secondPropPlacement = {
                0.1940,
                0.020,
                -0.0500,
                -90.0000,
                -90.0000,
                0.0000
            },
            emoteLoop = true,
            onlyAnimals = true,
        }
    },
    ["bdogpridei"] = {
        "creatures@rottweiler@amb@world_dog_sitting@base",
        "base",
        "Sit Pride I - Straight Ally (big dog)",
        animationOptions = {
            prop = 'lilprideflag9', -- Straight Ally
            propBone = 31086,
            propPlacement = {
                0.1900,
                0.0000,
                -0.0500,
                100.0000,
                90.0000,
                0.0000
            },
            secondProp = 'lilprideflag9',
            secondPropBone = 31086,
            secondPropPlacement = {
                0.1940,
                0.020,
                -0.0500,
                -90.0000,
                -90.0000,
                0.0000
            },
            emoteLoop = true,
            onlyAnimals = true,
        }
    },
    ["bdogfw"] = {
        "creatures@rottweiler@amb@world_dog_sitting@base",
        "nill",
        "Firework - Big Dog",
        animationOptions = {
            prop = 'ind_prop_firework_01', -- blue, green, red, purple pink, cyan, yellow, white
            propBone = 31086,
            propPlacement = {
                0.1400,
                0.3300,
                -0.0800,
                -85.6060,
                -176.7400,
                -9.8767
            },
            emoteLoop = true,
            onlyAnimals = true,
            emoteMoving = true,
            ptfxAsset = "scr_indep_fireworks",
            ptfxName = "scr_indep_firework_trail_spawn",
            ptfxPlacement = {
                0.0,
                0.0,
                0.0,
                0.0,
                0.0,
                0.0,
                0.6
            },
            ptfxInfo = "to light up the night",
            ptfxWait = 200
        }
    },
    ["bdogfris"] = {
        "creatures@rottweiler@amb@world_dog_sitting@base",
        "nill",
        "Frisbee (big dog)",
        animationOptions = {
            prop = 'p_ld_frisbee_01',
            propBone = 31086,
            propPlacement = {
                0.2600,
                0.0200,
               -0.0600,
               -173.7526,
               -169.4149,
                21.4173
            },
            emoteLoop = true,
            onlyAnimals = true,
            emoteMoving = true
        }
    },

    ["sdogbark"] = {
        "creatures@pug@amb@world_dog_barking@idle_a",
        "idle_a",
        "Bark (small dog)",
        animationOptions = {
            emoteLoop = true,
            onlyAnimals = true,
        }
    },
    ["sdogitch"] = {
        "creatures@pug@amb@world_dog_sitting@idle_a",
        "idle_a",
        "Itch (small dog)",
        animationOptions = {
            emoteLoop = true,
            onlyAnimals = true,
        }
    },
    ["sdogsit"] = {
        "creatures@pug@amb@world_dog_sitting@idle_a",
        "idle_b",
        "Sit (small dog)",
        animationOptions = {
            emoteLoop = true,
            onlyAnimals = true,
        }
    },
    ["sdogld"] = {
        "misssnowie@little_doggy_lying_down",
        "base",
        "Lay Down (small dog)",
        animationOptions = {
            emoteLoop = true,
            onlyAnimals = true,
        }
    },
    ["sdogshake"] = {
        "creatures@pug@amb@world_dog_barking@idle_a",
        "idle_c",
        "Shake (small dog)",
        animationOptions = {
            emoteLoop = true,
            onlyAnimals = true,
        }
    },
    ["sdogdance"] = {
        "creatures@pug@move",
        "idle_turn_0",
        "Dance (small dog)",
        animationOptions = {
            prop = 'ba_prop_battle_glowstick_01',
            propBone = 31086,
            propPlacement = {
                0.1500,
                -0.0300,
                0.0,
                0.0,
                0.0
            },
            emoteLoop = true,
            onlyAnimals = true,
            emoteMoving = false
        }
    },
    ["sdogdance2"] = {
        "creatures@pug@move",
        "idle_turn_0",
        "Dance 2 (small dog)",
        animationOptions = {
            prop = 'ba_prop_battle_glowstick_01',
            propBone = 31086,
            propPlacement = {
                0.1500,
                -0.0300,
                0.0,
                0.0,
                0.0
            },
            secondProp = 'prop_cs_sol_glasses',
            secondPropBone = 31086,
            secondPropPlacement = {
                0.0500,
                0.0300,
                0.000,
                -100.0000003,
                90.00,
                0.00
            },
            emoteLoop = true,
            onlyAnimals = true,
            emoteMoving = false
        }
    },
    ["sdogdancepridea"] = {
        "creatures@pug@move",
        "idle_turn_0",
        "Dance Pride A (small dog)",
        animationOptions = {
            prop = 'lilprideflag1',
            propBone = 31086,
            propPlacement = {
                0.1240,
                -0.0080,
                0.000,
                0.0,
                0.0,
                -74.6999
            },
            secondProp = 'prop_cs_sol_glasses',
            secondPropBone = 31086,
            secondPropPlacement = {
                0.0500,
                0.0300,
                0.000,
                -100.0000003,
                90.00,
                0.00
            },
            emoteLoop = true,
            onlyAnimals = true,
            emoteMoving = false
        }
    },
    ["sdogdanceprideb"] = {
        "creatures@pug@move",
        "idle_turn_0",
        "Dance Pride B - LGBTQIA (small dog)",
        animationOptions = {
            prop = 'lilprideflag2', -- LGBTQIA
            propBone = 31086,
            propPlacement = {
                0.1240,
                -0.0080,
                0.000,
                0.0,
                0.0,
                -74.6999
            },
            secondProp = 'prop_cs_sol_glasses',
            secondPropBone = 31086,
            secondPropPlacement = {
                0.0500,
                0.0300,
                0.000,
                -100.0000003,
                90.00,
                0.00
            },
            emoteLoop = true,
            onlyAnimals = true,
            emoteMoving = false
        }
    },
    ["sdogdancepridec"] = {
        "creatures@pug@move",
        "idle_turn_0",
        "Dance Pride C - Bisexual (small dog)",
        animationOptions = {
            prop = 'lilprideflag3', -- Bisexual
            propBone = 31086,
            propPlacement = {
                0.1240,
                -0.0080,
                0.000,
                0.0,
                0.0,
                -74.6999
            },
            secondProp = 'prop_cs_sol_glasses',
            secondPropBone = 31086,
            secondPropPlacement = {
                0.0500,
                0.0300,
                0.000,
                -100.0000003,
                90.00,
                0.00
            },
            emoteLoop = true,
            onlyAnimals = true,
            emoteMoving = false
        }
    },
    ["sdogdanceprided"] = {
        "creatures@pug@move",
        "idle_turn_0",
        "Dance Pride D - Lesbian (small dog)",
        animationOptions = {
            prop = 'lilprideflag4', -- Lesbian
            propBone = 31086,
            propPlacement = {
                0.1240,
                -0.0080,
                0.000,
                0.0,
                0.0,
                -74.6999
            },
            secondProp = 'prop_cs_sol_glasses',
            secondPropBone = 31086,
            secondPropPlacement = {
                0.0500,
                0.0300,
                0.000,
                -100.0000003,
                90.00,
                0.00
            },
            emoteLoop = true,
            onlyAnimals = true,
            emoteMoving = false
        }
    },
    ["sdogdancepridee"] = {
        "creatures@pug@move",
        "idle_turn_0",
        "Dance Pride E - Pansexual (small dog)",
        animationOptions = {
            prop = 'lilprideflag5', -- Pansexual
            propBone = 31086,
            propPlacement = {
                0.1240,
                -0.0080,
                0.000,
                0.0,
                0.0,
                -74.6999
            },
            secondProp = 'prop_cs_sol_glasses',
            secondPropBone = 31086,
            secondPropPlacement = {
                0.0500,
                0.0300,
                0.000,
                -100.0000003,
                90.00,
                0.00
            },
            emoteLoop = true,
            onlyAnimals = true,
            emoteMoving = false
        }
    },
    ["sdogdancepridef"] = {
        "creatures@pug@move",
        "idle_turn_0",
        "Dance Pride F - Transgender  (small dog)",
        animationOptions = {
            prop = 'lilprideflag6', -- Transgender
            propBone = 31086,
            propPlacement = {
                0.1240,
                -0.0080,
                0.000,
                0.0,
                0.0,
                -74.6999
            },
            secondProp = 'prop_cs_sol_glasses',
            secondPropBone = 31086,
            secondPropPlacement = {
                0.0500,
                0.0300,
                0.000,
                -100.0000003,
                90.00,
                0.00
            },
            emoteLoop = true,
            onlyAnimals = true,
            emoteMoving = false
        }
    },
    ["sdogdanceprideg"] = {
        "creatures@pug@move",
        "idle_turn_0",
        "Dance Pride G - Non Binary (small dog)",
        animationOptions = {
            prop = 'lilprideflag7', -- Non Binary
            propBone = 31086,
            propPlacement = {
                0.1240,
                -0.0080,
                0.000,
                0.0,
                0.0,
                -74.6999
            },
            secondProp = 'prop_cs_sol_glasses',
            secondPropBone = 31086,
            secondPropPlacement = {
                0.0500,
                0.0300,
                0.000,
                -100.0000003,
                90.00,
                0.00
            },
            emoteLoop = true,
            onlyAnimals = true,
            emoteMoving = false
        }
    },
    ["sdogdanceprideh"] = {
        "creatures@pug@move",
        "idle_turn_0",
        "Dance Pride H - Asexual (small dog)",
        animationOptions = {
            prop = 'lilprideflag8', -- Asexual
            propBone = 31086,
            propPlacement = {
                0.1240,
                -0.0080,
                0.000,
                0.0,
                0.0,
                -74.6999
            },
            secondProp = 'prop_cs_sol_glasses',
            secondPropBone = 31086,
            secondPropPlacement = {
                0.0500,
                0.0300,
                0.000,
                -100.0000003,
                90.00,
                0.00
            },
            emoteLoop = true,
            onlyAnimals = true,
            emoteMoving = false
        }
    },
    ["sdogdancepridei"] = {
        "creatures@pug@move",
        "idle_turn_0",
        "Dance Pride I - Straight Ally (small dog)",
        animationOptions = {
            prop = 'lilprideflag9', -- Straight Ally
            propBone = 31086,
            propPlacement = {
                0.1240,
                -0.0080,
                0.000,
                0.0,
                0.0,
                -74.6999
            },
            secondProp = 'prop_cs_sol_glasses',
            secondPropBone = 31086,
            secondPropPlacement = {
                0.0500,
                0.0300,
                0.000,
                -100.0000003,
                90.00,
                0.00
            },
            emoteLoop = true,
            onlyAnimals = true,
            emoteMoving = false
        }
    },
    ["sdogbb"] = {
        "creatures@pug@move",
        "nill",
        "Baseball (small dog)",
        animationOptions = {
            prop = 'w_am_baseball',
            propBone = 31086,
            propPlacement = {
                0.1500,
                -0.0500,
                0.0,
                0.0,
                0.0
            },
            emoteLoop = true,
            onlyAnimals = true,
            emoteMoving = false
        }
    },
    ["sdogburger"] = {
        "creatures@pug@move",
        "nill",
        "Burger (small dog)",
        animationOptions = {
            prop = 'prop_cs_burger_01',
            propBone = 31086,
            propPlacement = {
                0.1500,
                -0.0400,
                0.0000,
                -90.0,
                0.0
            },
            emoteLoop = true,
            onlyAnimals = true,
            emoteMoving = false
        }
    },
    ["sdogcontroller"] = {
        "creatures@pug@move",
        "nill",
        "Controller (small dog)",
        animationOptions = {
            prop = 'prop_controller_01',
            propBone = 31086,
            propPlacement = {
                0.1800,
                -0.0300,
                0.0000,
                -180.000,
                90.0000,
                0.0000
            },
            emoteLoop = true,
            onlyAnimals = true,
            emoteMoving = false
        }
    },
    ["sdogdolla"] = {
        "creatures@pug@move",
        "nill",
        "Dollar Bill (small dog)",
        animationOptions = {
            prop = 'p_banknote_onedollar_s',
            propBone = 31086,
            propPlacement = {
                0.1700,
                -0.0100,
                0.0000,
                90.0000,
                0.0000,
                0.000
            },
            emoteLoop = true,
            onlyAnimals = true,
            emoteMoving = false
        }
    },
    ["sdogdolla2"] = {
        "creatures@pug@move",
        "nill",
        "Dollar Bill Scrunched  (small dog)",
        animationOptions = {
            prop = 'bkr_prop_scrunched_moneypage',
            propBone = 31086,
            propPlacement = {
                0.1700,
                0.000,
                0.0000,
                90.0000,
                00.0000,
                00.0000
            },
            emoteLoop = true,
            onlyAnimals = true,
            emoteMoving = false
        }
    },
    ["sdogdolla3"] = {
        "creatures@pug@move",
        "nill",
        "Money Stack  (small dog)",
        animationOptions = {
            prop = 'bkr_prop_money_wrapped_01',
            propBone = 31086,
            propPlacement = {
                0.1700,
                -0.0100,
                0.0000,
                90.0000,
                0.0000,
                0.000
            },
            emoteLoop = true,
            onlyAnimals = true,
            emoteMoving = false
        }
    },
    ["sdogdolla4"] = {
        "creatures@pug@move",
        "nill",
        "Money Bag  (small dog)",
        animationOptions = {
            prop = 'ch_prop_ch_moneybag_01a',
            propBone = 31086,
            propPlacement = {
                0.1200,
                -0.2000,
                0.0000,
                -79.9999997,
                90.00,
                0.0000
            },
            emoteLoop = true,
            onlyAnimals = true,
            emoteMoving = false
        }
    },
    ["sdogmic"] = {
        "creatures@pug@move",
        "nill",
        "Microphone (small dog)",
        animationOptions = {
            prop = 'p_ing_microphonel_01',
            propBone = 31086,
            propPlacement = {
                0.1500,
                -0.0170,
                0.0300,
                0.000,
                0.0000,
                0.0000
            },
            emoteLoop = true,
            onlyAnimals = true,
            emoteMoving = false
        }
    },
    ["sdogteddy"] = {
        "creatures@pug@move",
        "nill",
        "Teddy (small dog)",
        animationOptions = {
            prop = 'v_ilev_mr_rasberryclean',
            propBone = 31086,
            propPlacement = {
                0.1500,
                -0.1100,
                -0.23,
                0.000,
                0.0000,
                0.0000
            },
            emoteLoop = true,
            onlyAnimals = true,
            emoteMoving = false
        }
    },
    ["sdogteddy2"] = {
        "creatures@pug@amb@world_dog_sitting@idle_a",
        "idle_b",
        "Teddy 2 (small dog)",
        animationOptions = {
            prop = 'v_ilev_mr_rasberryclean',
            propBone = 31086,
            propPlacement = {
                0.1500,
                -0.1100,
                -0.23,
                0.000,
                0.0000,
                0.0000
            },
            emoteLoop = true,
            onlyAnimals = true,
        }
    },
    ["sdogtennis"] = {
        "creatures@pug@move",
        "nill",
        "Tennis Ball (small dog)",
        animationOptions = {
            prop = 'prop_tennis_ball',
            propBone = 31086,
            propPlacement = {
                0.1500,
                -0.0600,
                0.0,
                0.0,
                0.0,
                0.0
            },
            emoteLoop = true,
            onlyAnimals = true,
            emoteMoving = false
        }
    },
    ["sdogtennisr"] = {
        "creatures@pug@move",
        "nill",
        "Tennis Racket (small dog)",
        animationOptions = {
            prop = 'prop_tennis_rack_01',
            propBone = 31086,
            propPlacement = {
                0.1500,
                -0.0200,
                0.00,
                0.000,
                0.0000,
                -28.0000
            },
            emoteLoop = true,
            onlyAnimals = true,
            emoteMoving = false
        }
    },
    ["sdogrose"] = {
        "creatures@pug@move",
        "nill",
        "Rose (small dog)",
        animationOptions = {
            prop = 'prop_single_rose',
            propBone = 12844,
            propPlacement = {
                0.1090,
                -0.0140,
                0.0500,
                0.0,
                0.0,
                0.0
            },
            emoteLoop = true,
            onlyAnimals = true,
            emoteMoving = false
        }
    },
    ["sdogrose2"] = {
        "creatures@pug@amb@world_dog_sitting@idle_a",
        "idle_b",
        "Rose Sit (small dog)",
        animationOptions = {
            prop = 'prop_single_rose',
            propBone = 12844,
            propPlacement = {
                0.1090,
                -0.0140,
                0.0500,
                0.0,
                0.0,
                0.0
            },
            emoteLoop = true,
            onlyAnimals = true,
        }
    },
    ["sdogggun"] = {
        "creatures@pug@move",
        "nill",
        "Gun Gold (small dog)",
        animationOptions = {
            prop = 'w_pi_pistol_luxe',
            propBone = 12844,
            propPlacement = {
                0.2010,
                -0.0080,
                0.0,
                0.0,
                0.0,
                0.0
            },
            emoteLoop = true,
            onlyAnimals = true,
            emoteMoving = false
        }
    },
    ["sdoggun2"] = {
        "creatures@pug@amb@world_dog_sitting@idle_a",
        "idle_b",
        "Gun Gold Sit (small dog)",
        animationOptions = {
            prop = 'w_pi_pistol_luxe',
            propBone = 12844,
            propPlacement = {
                0.2010,
                -0.0080,
                0.0,
                0.0,
                0.0,
                0.0
            },
            emoteLoop = true,
            onlyAnimals = true,
        }
    },
    ["sdogstun"] = {
        "creatures@pug@move",
        "nill",
        "Stun Gun (small dog)",
        animationOptions = {
            prop = 'w_pi_stungun',
            propBone = 12844,
            propPlacement = {
                0.1400,
                -0.0100,
                0.0,
                0.0,
                0.0,
                0.0
            },
            emoteLoop = true,
            onlyAnimals = true,
            emoteMoving = false,
            ptfxAsset = "core",
            ptfxName = "blood_stungun",
            ptfxPlacement = {
                0.208,
                0.0,
                0.0,
                0.0,
                0.0,
                0.0,
                1.0
            },
            ptfxInfo = "Stun",
            ptfxWait = 200
        }
    },
    ["sdoggl1"] = {
        "creatures@pug@move",
        "nill",
        "Aviators (small dog)",
        animationOptions = {
            prop = 'prop_aviators_01',
            propBone = 31086,
            propPlacement = {
                0.0500,
                0.0400,
                0.000,
                -90.00,
                90.00,
                0.00
            },
            emoteLoop = true,
            onlyAnimals = true,
            emoteMoving = false
        }
    },
    ["sdoggl2"] = {
        "creatures@pug@amb@world_dog_sitting@idle_a",
        "idle_b",
        "Aviators Sitting (small dog)",
        animationOptions = {
            prop = 'prop_aviators_01',
            propBone = 31086,
            propPlacement = {
                0.0500,
                0.0400,
                0.000,
                -90.00,
                90.00,
                0.00
            },
            emoteLoop = true,
            onlyAnimals = true,
        }
    },
    ["sdoggl3"] = {
        "creatures@pug@move",
        "nill",
        "Sunglasses (small dog)",
        animationOptions = {
            prop = 'prop_cs_sol_glasses',
            propBone = 31086,
            propPlacement = {
                0.0500,
                0.0300,
                0.000,
                -100.0000003,
                90.00,
                0.00
            },
            emoteLoop = true,
            onlyAnimals = true,
            emoteMoving = false
        }
    },
    ["sdoggl4"] = {
        "creatures@pug@amb@world_dog_sitting@idle_a",
        "idle_b",
        "Sunglasses Sitting (small dog)",
        animationOptions = {
            prop = 'prop_cs_sol_glasses',
            propBone = 31086,
            propPlacement = {
                0.0500,
                0.0300,
                0.000,
                -100.0000003,
                90.00,
                0.00
            },
            emoteLoop = true,
            onlyAnimals = true,
        }
    },
    ["sdoghd1"] = {
        "creatures@pug@move",
        "nill",
        "Hot Dog (small dog)",
        animationOptions = {
            prop = 'prop_cs_hotdog_01',
            propBone = 31086,
            propPlacement = {
                0.1300,
                -0.0250,
                0.000,
                -88.272053,
                -9.8465858,
                -0.1488562
            },
            emoteLoop = true,
            onlyAnimals = true,
            emoteMoving = false
        }
    },
    ["sdoghd2"] = {
        "creatures@pug@amb@world_dog_sitting@idle_a",
        "idle_b",
        "Hot Dog Sitting (small dog)",
        animationOptions = {
            prop = 'prop_cs_hotdog_01',
            propBone = 31086,
            propPlacement = {
                0.1300,
                -0.0250,
                0.000,
                -88.272053,
                -9.8465858,
                -0.1488562
            },
            emoteLoop = true,
            onlyAnimals = true,
        }
    },
    ["sdoghlmt1"] = {
        "creatures@pug@move",
        "nill",
        "Helmet 1 (small dog)",
        animationOptions = {
            prop = 'ba_prop_battle_sports_helmet',
            propBone = 31086,
            propPlacement = {
                0.00,
                -0.0200,
                0.000,
                -90.00,
                90.00,
                0.00
            },
            emoteLoop = true,
            onlyAnimals = true,
            emoteMoving = false
        }
    },
    ["sdoghlmt2"] = {
        "creatures@pug@move",
        "nill",
        "Helmet 2 (small dog)",
        animationOptions = {
            prop = 'prop_hard_hat_01',
            propBone = 31086,
            propPlacement = {
                0.00,
                0.1300,
                0.000,
                -90.00,
                90.00,
                0.00
            },
            emoteLoop = true,
            onlyAnimals = true,
            emoteMoving = false
        }
    },
    ["sdoghat"] = {
        "creatures@pug@move",
        "nill",
        "Hat 1 (small dog)",
        animationOptions = {
            prop = 'prop_proxy_hat_01',
            propBone = 31086,
            propPlacement = {
                0.0,
                0.1200,
                0.000,
                -99.8510766,
                80.1489234,
                1.7279411
            },
            secondProp = 'prop_aviators_01',
            secondPropBone = 31086,
            secondPropPlacement = {
                0.0500,
                0.0400,
                0.000,
                -90.00,
                90.00,
                0.00
            },
            emoteLoop = true,
            onlyAnimals = true,
            emoteMoving = false
        }
    },
    ["sdoghat2"] = {
        "creatures@pug@amb@world_dog_sitting@idle_a",
        "idle_b",
        "Hat 2 Sitting (small dog)",
        animationOptions = {
            prop = 'prop_proxy_hat_01',
            propBone = 31086,
            propPlacement = {
                0.0,
                0.1200,
                0.000,
                -99.8510766,
                80.1489234,
                1.7279411
            },
            secondProp = 'prop_aviators_01',
            secondPropBone = 31086,
            secondPropPlacement = {
                0.0500,
                0.0400,
                0.000,
                -90.00,
                90.00,
                0.00
            },
            emoteLoop = true,
            onlyAnimals = true,
        }
    },
    ["sdogsteak"] = {
        "creatures@pug@move",
        "nill",
        "Steak (small dog)",
        animationOptions = {
            prop = 'prop_cs_steak',
            propBone = 31086,
            propPlacement = {
                0.1800,
                -0.0200,
                0.000,
                90.00,
                0.00,
                0.00
            },
            emoteLoop = true,
            onlyAnimals = true,
            emoteMoving = false
        }
    },
    ["sdogsteak2"] = {
        "creatures@pug@amb@world_dog_sitting@idle_a",
        "idle_c",
        "Steak 2 Lay Down (small dog)",
        animationOptions = {
            prop = 'prop_cs_steak',
            propBone = 31086,
            propPlacement = {
                0.1800,
                -0.0200,
                0.000,
                90.00,
                0.00,
                0.00
            },
            emoteLoop = true,
            onlyAnimals = true,
        }
    },
    ["sdogpridea"] = {
        "creatures@pug@move",
        "nill",
        "Pride A (small dog)",
        animationOptions = {
            prop = 'lilprideflag1',
            propBone = 31086,
            propPlacement = {
                0.1240,
                -0.0080,
                0.000,
                0.0,
                0.0,
                -74.6999
            },
            emoteLoop = true,
            onlyAnimals = true,
            emoteMoving = false
        }
    },
    ["sdogprideb"] = {
        "creatures@pug@move",
        "nill",
        "Pride B - LGBTQIA (small dog)",
        animationOptions = {
            prop = 'lilprideflag2', -- LGBTQIA
            propBone = 31086,
            propPlacement = {
                0.1240,
                -0.0080,
                0.000,
                0.0,
                0.0,
                -74.6999
            },
            emoteLoop = true,
            onlyAnimals = true,
            emoteMoving = false
        }
    },
    ["sdogpridec"] = {
        "creatures@pug@move",
        "nill",
        "Pride C - Bisexual (small dog)",
        animationOptions = {
            prop = 'lilprideflag3', -- Bisexual
            propBone = 31086,
            propPlacement = {
                0.1240,
                -0.0080,
                0.000,
                0.0,
                0.0,
                -74.6999
            },
            emoteLoop = true,
            onlyAnimals = true,
            emoteMoving = false
        }
    },
    ["sdogprided"] = {
        "creatures@pug@move",
        "nill",
        "Pride D - Lesbian (small dog)",
        animationOptions = {
            prop = 'lilprideflag4', -- Lesbian
            propBone = 31086,
            propPlacement = {
                0.1240,
                -0.0080,
                0.000,
                0.0,
                0.0,
                -74.6999
            },
            emoteLoop = true,
            onlyAnimals = true,
            emoteMoving = false
        }
    },
    ["sdogpridee"] = {
        "creatures@pug@move",
        "nill",
        "Pride E - Pansexual (small dog)",
        animationOptions = {
            prop = 'lilprideflag5', -- Pansexual
            propBone = 31086,
            propPlacement = {
                0.1240,
                -0.0080,
                0.000,
                0.0,
                0.0,
                -74.6999
            },
            emoteLoop = true,
            onlyAnimals = true,
            emoteMoving = false
        }
    },
    ["sdogpridef"] = {
        "creatures@pug@move",
        "nill",
        "Pride F - Transgender  (small dog)",
        animationOptions = {
            prop = 'lilprideflag6', -- Transgender
            propBone = 31086,
            propPlacement = {
                0.1240,
                -0.0080,
                0.000,
                0.0,
                0.0,
                -74.6999
            },
            emoteLoop = true,
            onlyAnimals = true,
            emoteMoving = false
        }
    },
    ["sdogprideg"] = {
        "creatures@pug@move",
        "nill",
        "Pride G - Non Binary (small dog)",
        animationOptions = {
            prop = 'lilprideflag6', -- Non Binary
            propBone = 31086,
            propPlacement = {
                0.1240,
                -0.0080,
                0.000,
                0.0,
                0.0,
                -74.6999
            },
            emoteLoop = true,
            onlyAnimals = true,
            emoteMoving = false
        }
    },
    ["sdogprideh"] = {
        "creatures@pug@move",
        "nill",
        "Pride H - Non Binary (small dog)",
        animationOptions = {
            prop = 'lilprideflag7', -- Non Binary
            propBone = 31086,
            propPlacement = {
                0.1240,
                -0.0080,
                0.000,
                0.0,
                0.0,
                -74.6999
            },
            emoteLoop = true,
            onlyAnimals = true,
            emoteMoving = false
        }
    },
    ["sdogpridei"] = {
        "creatures@pug@move",
        "nill",
        "Pride I - Asexual (small dog)",
        animationOptions = {
            prop = 'lilprideflag8', -- Asexual
            propBone = 31086,
            propPlacement = {
                0.1240,
                -0.0080,
                0.000,
                0.0,
                0.0,
                -74.6999
            },
            emoteLoop = true,
            onlyAnimals = true,
            emoteMoving = false
        }
    },
    ["sdogpridesita"] = {
        "creatures@pug@amb@world_dog_sitting@idle_a",
        "idle_b",
        "Pride A Sit (small dog)",
        animationOptions = {
            prop = 'lilprideflag1',
            propBone = 31086,
            propPlacement = {
                0.1240,
                -0.0080,
                0.000,
                0.0,
                0.0,
                -74.6999
            },
            emoteLoop = true,
            onlyAnimals = true,
        }
    },
    ["sdogpridesitb"] = {
        "creatures@pug@amb@world_dog_sitting@idle_a",
        "idle_b",
        "Pride B Sit LGBTQIA  (small dog)",
        animationOptions = {
            prop = 'lilprideflag2', -- LGBTQIA
            propBone = 31086,
            propPlacement = {
                0.1240,
                -0.0080,
                0.000,
                0.0,
                0.0,
                -74.6999
            },
            emoteLoop = true,
            onlyAnimals = true,
        }
    },
    ["sdogpridesitc"] = {
        "creatures@pug@amb@world_dog_sitting@idle_a",
        "idle_b",
        "Pride C Sit Bisexual  (small dog)",
        animationOptions = {
            prop = 'lilprideflag3', -- Bisexual
            propBone = 31086,
            propPlacement = {
                0.1240,
                -0.0080,
                0.000,
                0.0,
                0.0,
                -74.6999
            },
            emoteLoop = true,
            onlyAnimals = true,
        }
    },
    ["sdogpridesitd"] = {
        "creatures@pug@amb@world_dog_sitting@idle_a",
        "idle_b",
        "Pride D Sit Lesbian (small dog)",
        animationOptions = {
            prop = 'lilprideflag4', -- Lesbian
            propBone = 31086,
            propPlacement = {
                0.1240,
                -0.0080,
                0.000,
                0.0,
                0.0,
                -74.6999
            },
            emoteLoop = true,
            onlyAnimals = true,
        }
    },
    ["sdogpridesite"] = {
        "creatures@pug@amb@world_dog_sitting@idle_a",
        "idle_b",
        "Pride E Sit Pansexual  (small dog)",
        animationOptions = {
            prop = 'lilprideflag5', -- Pansexual
            propBone = 31086,
            propPlacement = {
                0.1240,
                -0.0080,
                0.000,
                0.0,
                0.0,
                -74.6999
            },
            emoteLoop = true,
            onlyAnimals = true,
        }
    },
    ["sdogpridesitf"] = {
        "creatures@pug@amb@world_dog_sitting@idle_a",
        "idle_b",
        "Pride F Sit Transgender   (small dog)",
        animationOptions = {
            prop = 'lilprideflag6', -- Transgender
            propBone = 31086,
            propPlacement = {
                0.1240,
                -0.0080,
                0.000,
                0.0,
                0.0,
                -74.6999
            },
            emoteLoop = true,
            onlyAnimals = true,
        }
    },
    ["sdogpridesitg"] = {
        "creatures@pug@amb@world_dog_sitting@idle_a",
        "idle_b",
        "Pride G Sit Non Binary (small dog)",
        animationOptions = {
            prop = 'lilprideflag7', -- Non Binary
            propBone = 31086,
            propPlacement = {
                0.1240,
                -0.0080,
                0.000,
                0.0,
                0.0,
                -74.6999
            },
            emoteLoop = true,
            onlyAnimals = true,
        }
    },
    ["sdogpridesith"] = {
        "creatures@pug@amb@world_dog_sitting@idle_a",
        "idle_b",
        "Pride H Sit Asexual  (small dog)",
        animationOptions = {
            prop = 'lilprideflag8',
            -- Asexual
            propBone = 31086,
            propPlacement = {
                0.1240,
                -0.0080,
                0.000,
                0.0,
                0.0,
                -74.6999
            },
            emoteLoop = true,
            onlyAnimals = true,
        }
    },
    ["sdogpridesiti"] = {
        "creatures@pug@amb@world_dog_sitting@idle_a",
        "idle_b",
        "Pride I Sit Straight Ally  (small dog)",
        animationOptions = {
            prop = 'lilprideflag9', -- Straight Ally
            propBone = 31086,
            propPlacement = {
                0.1240,
                -0.0080,
                0.000,
                0.0,
                0.0,
                -74.6999
            },
            emoteLoop = true,
            onlyAnimals = true,
        }
    },
    ["sdogpee"] = {
        "creatures@pug@move",
        "nill",
        "Pee (Small Dog)",
        animationOptions = {
            emoteLoop = true,
            onlyAnimals = true,
            ptfxAsset = "scr_amb_chop",
            ptfxName = "ent_anim_dog_peeing",
            ptfxNoProp = true,
            ptfxPlacement = {
                -0.01,
                -0.17,
                0.09,
                0.0,
                90.0,
                140.0,
                1.0
            },
            ptfxInfo = "Pee",
            ptfxWait = 0,
            ptfxCanHold = true
        }
    },
    ["sdogshit"] = {
        "creatures@pug@move",
        "nill",
        "Shit (Small Dog)",
        animationOptions = {
            emoteLoop = true,
            onlyAnimals = true,
            emoteMoving = true,
        }
    },
    ["sdogfw"] = {
        "creatures@pug@move",
        "nill",
        "Firework - Small Dog",
        animationOptions = {
            prop = 'ind_prop_firework_01', -- blue, green, red, purple pink, cyan, yellow, white
            propBone = 31086,
            propPlacement = {
                0.1330,
               -0.0210,
               -0.2760,
                0.0,
               -180.0,
                44.0000
            },
            emoteLoop = true,
            onlyAnimals = true,
            emoteMoving = true,
            ptfxAsset = "scr_indep_fireworks",
            ptfxName = "scr_indep_firework_trail_spawn",
            ptfxPlacement = {
                0.0,
                0.0,
                0.0,
                0.0,
                0.0,
                0.0,
                0.6
            },
            ptfxInfo = "Firework",
            ptfxWait = 200
        }
    },
    ["sdogfris"] = {
        "creatures@pug@move",
        "nill",
        "Frisbee (small dog)",
        animationOptions = {
            prop = 'p_ld_frisbee_01',
            propBone = 31086,
            propPlacement = {
                0.1900,
               -0.0150,
                0.0000,
              -90.0000,
              120.0000,
                0.000,
            },
            emoteLoop = true,
            onlyAnimals = true,
            emoteMoving = true
        }
    },
}