Citizen.CreateThread(function()
    if not Config.Creators['Pazeee_SixFunnyEmotePack'] then return end

    local Animations = {
        Dances = {},

        Emotes = {
            ["psixf"] = {
                "pazeee@sixf@animations",
                "pazeee@sixf@clip",
                "Six Sit Ground 1",
                animationOptions = {
                    emoteLoop = true
                }
            },
            ["psixg"] = {
                "pazeee@sixg@animations",
                "pazeee@sixg@clip",
                "Six Sit Ground 2",
                animationOptions = {
                    emoteLoop = true
                }
            },
            ["psixj"] = {
                "pazeee@sixj@animations",
                "pazeee@sixj@clip",
                "Six Watch Phone 3 Shock",
                animationOptions = {
                    emoteLoop = true
                }
            },
            ["psixy"] = {
                "pazeee@sixy@animations",
                "pazeee@sixy@clip",
                "Six Street Photo Together 1",
                animationOptions = {
                    emoteLoop = true
                }
            },
            ["psixz"] = {
                "pazeee@sixz@animations",
                "pazeee@sixz@clip",
                "Six Street Photo Together 2",
                animationOptions = {
                    emoteLoop = true
                }
            },
            ["psixza"] = {
                "pazeee@sixza@animations",
                "pazeee@sixza@clip",
                "Six Street Photo Together 3",
                animationOptions = {
                    emoteLoop = true
                }
            },
            ["psixzb"] = {
                "pazeee@sixzb@animations",
                "pazeee@sixzb@clip",
                "Six Street Photo Together 4",
                animationOptions = {
                    emoteLoop = true
                }
            },
            ["psixzr"] = {
                "pazeee@sixzr@animations",
                "pazeee@sixzr@clip",
                "Six Love You",
                animationOptions = {
                    emoteLoop = true
                }
            },
            ["psixzs"] = {
                "pazeee@sixzs@animations",
                "pazeee@sixzs@clip",
                "Six Love You So Much",
                animationOptions = {
                    emoteLoop = true
                }
            },
            ["psixzt"] = {
                "pazeee@sixzt@animations",
                "pazeee@sixzt@clip",
                "Six Stunned Watching You",
                animationOptions = {
                    emoteLoop = true,
                    emoteMoving = true
                }
            },
            ["psixzu"] = {
                "pazeee@sixzu@animations",
                "pazeee@sixzu@clip",
                "Six Wave Facing Left",
                animationOptions = {
                    emoteLoop = true,
                    emoteMoving = true
                }
            },
            ["psixzv"] = {
                "pazeee@sixzv@animations",
                "pazeee@sixzv@clip",
                "Six Wave Front",
                animationOptions = {
                    emoteLoop = true,
                    emoteMoving = true
                }
            },
            ["psixzw"] = {
                "pazeee@sixzw@animations",
                "pazeee@sixzw@clip",
                "Six Wave Front 2 Hand",
                animationOptions = {
                    emoteLoop = true,
                    emoteMoving = true
                }
            },
            ["psixzx"] = {
                "pazeee@sixzx@animations",
                "pazeee@sixzx@clip",
                "Six Wave Cute",
                animationOptions = {
                    emoteLoop = true
                }
            },
            ["psixzy"] = {
                "pazeee@sixzy@animations",
                "pazeee@sixzy@clip",
                "Six Sit Edge 1 Female",
                animationOptions = {
                    emoteLoop = true
                }
            },
            ["psixzy2"] = {
                "pazeee@sixzy2@animations",
                "pazeee@sixzy2@clip",
                "Six Sit Edge 1 Male",
                animationOptions = {
                    emoteLoop = true
                }
            },
            ["psixzz"] = {
                "pazeee@sixzz@animations",
                "pazeee@sixzz@clip",
                "Six Sit Edge 2 Female",
                animationOptions = {
                    emoteLoop = true
                }
            },
            ["psixzz2"] = {
                "pazeee@sixzz2@animations",
                "pazeee@sixzz2@clip",
                "Six Sit Edge 2 Male",
                animationOptions = {
                    emoteLoop = true
                }
            },
            ["psixzza"] = {
                "pazeee@sixzza@animations",
                "pazeee@sixzza@clip",
                "Six Sit Edge 3 Female",
                animationOptions = {
                    emoteLoop = true
                }
            },
            ["psixzza2"] = {
                "pazeee@sixzza2@animations",
                "pazeee@sixzza2@clip",
                "Six Sit Edge 3 Male",
                animationOptions = {
                    emoteLoop = true
                }
            },
            ["psixzzb"] = {
                "pazeee@sixzzb@animations",
                "pazeee@sixzzb@clip",
                "Six Sit Edge 4 Female",
                animationOptions = {
                    emoteLoop = true
                }
            },
            ["psixzzb2"] = {
                "pazeee@sixzzb2@animations",
                "pazeee@sixzzb2@clip",
                "Six Sit Edge 4 Male",
                animationOptions = {
                    emoteLoop = true
                }
            },
            ["psixzzd"] = {
                "pazeee@sixzzd@animations",
                "pazeee@sixzzd@clip",
                "Six Lean 1",
                animationOptions = {
                    emoteLoop = true
                }
            },
            ["psixzze"] = {
                "pazeee@sixzze@animations",
                "pazeee@sixzze@clip",
                "Six Lean 2",
                animationOptions = {
                    emoteLoop = true
                }
            },
            ["psixzzf"] = {
                "pazeee@sixzzf@animations",
                "pazeee@sixzzf@clip",
                "Six Lean 3 Bar Bring The Bell",
                animationOptions = {
                    emoteLoop = true
                }
            },
            ["psixzzg"] = {
                "pazeee@sixzzg@animations",
                "pazeee@sixzzg@clip",
                "Six Table Discussion 1",
                animationOptions = {
                    emoteLoop = true
                }
            },
            ["psixzzh"] = {
                "pazeee@sixzzh@animations",
                "pazeee@sixzzh@clip",
                "Six Table Discussion 2",
                animationOptions = {
                    emoteLoop = true
                }
            },
            ["psixzzi"] = {
                "pazeee@sixzzi@animations",
                "pazeee@sixzzi@clip",
                "Six Table Discussion 3",
                animationOptions = {
                    emoteLoop = true
                }
            },
            ["psixzzl"] = {
                "pazeee@sixzzl@animations",
                "pazeee@sixzzl@clip",
                "Six Cool Pose Lucia",
                animationOptions = {
                    emoteLoop = true
                }
            },
            ["psixzzp"] = {
                "pazeee@sixzzp@animations",
                "pazeee@sixzzp@clip",
                "Six Surrender Hand On The Wall",
                animationOptions = {
                    emoteLoop = true
                }
            },
            ["psixzzq"] = {
                "pazeee@sixzzq@animations",
                "pazeee@sixzzq@clip",
                "Six Frisk / Search",
                animationOptions = {
                    emoteLoop = true
                }
            },
            ["psixzzr"] = {
                "pazeee@sixzzr@animations",
                "pazeee@sixzzr@clip",
                "Six Like Brap Brap Brap",
                animationOptions = {
                    emoteLoop = true
                }
            },
            ["psixzzs"] = {
                "pazeee@sixzzs@animations",
                "pazeee@sixzzs@clip",
                "Six Yes Yes Yes Please",
                animationOptions = {
                    emoteLoop = true
                }
            },
            ["psixzzze"] = {
                "pazeee@sixzzze@animations",
                "pazeee@sixzzze@clip",
                "Six Funny Walk Move",
                animationOptions = {
                    emoteLoop = true,
                    customMovementType = 47
                }
            },
            ["psixzzzm"] = {
                "pazeee@sixzzzm@animations",
                "pazeee@sixzzzm@clip",
                "Six Say VCB 2",
                animationOptions = {
                    emoteLoop = true
                }
            },
            ["psixzzzn"] = {
                "pazeee@sixzzzn@animations",
                "pazeee@sixzzzn@clip",
                "Six Say VCB 3",
                animationOptions = {
                    emoteLoop = true
                }
            },
            ["psixzzzo"] = {
                "pazeee@sixzzzo@animations",
                "pazeee@sixzzzo@clip",
                "Six Say VCB 4",
                animationOptions = {
                    emoteLoop = true
                }
            },
            ["psixzzzp"] = {
                "pazeee@sixzzzp@animations",
                "pazeee@sixzzzp@clip",
                "Six Car Enjoy 1",
                animationOptions = {
                    emoteLoop = true,
                    customMovementType = 1
                }
            },
            ["psixzzzq"] = {
                "pazeee@sixzzzq@animations",
                "pazeee@sixzzzq@clip",
                "Six Car Enjoy 2",
                animationOptions = {
                    emoteLoop = true,
                    customMovementType = 33
                }
            },
            ["psixzzzr"] = {
                "pazeee@sixzzzr@animations",
                "pazeee@sixzzzr@clip",
                "Six Car Enjoy 3",
                animationOptions = {
                    emoteLoop = true,
                    customMovementType = 1
                }
            },
            ["psixzzzc"] = {
                "pazeee@sixzzzc@animations",
                "pazeee@sixzzzc@clip",
                "Six Cute Drag Lucia",
                "psixzzzd",
                animationOptions = {
                    emoteLoop = true,
                    customMovementType = 47
                }
            },
            ["psixa"] = {
                "pazeee@sixa@animations",
                "pazeee@sixa@clip",
                "Six Homeless 1",
                animationOptions = {
                    prop = "v_ret_gc_cup",
                    propBone = 57005,
                    propPlacement = {
                        0.110,
                        0.04,
                        -0.04,
                        -60.0,
                        0.0,
                        0.0,
                    },
                    emoteLoop = true
                }
            },
            ["psixb"] = {
                "pazeee@sixb@animations",
                "pazeee@sixb@clip",
                "Six Homeless 2",
                animationOptions = {
                    prop = "v_ret_gc_cup",
                    propBone = 57005,
                    propPlacement = {
                        0.110,
                        0.04,
                        -0.04,
                        -60.0,
                        0.0,
                        0.0,
                    },
                    emoteLoop = true
                }
            },
            ["psixc"] = {
                "pazeee@sixc@animations",
                "pazeee@sixc@clip",
                "Six Homeless 3",
                animationOptions = {
                    prop = "v_ret_gc_cup",
                    propBone = 57005,
                    propPlacement = {
                        0.110,
                        0.04,
                        -0.04,
                        -60.0,
                        0.0,
                        0.0,
                    },
                    emoteLoop = true
                }
            },
            ["psixd"] = {
                "pazeee@sixd@animations",
                "pazeee@sixd@clip",
                "Six Homeless 4",
                animationOptions = {
                    prop = "v_ret_gc_cup",
                    propBone = 18905,
                    propPlacement = {
                        0.110,
                        0.04,
                        0.04,
                        -115.4,
                        -16.012,
                        -37.158,
                    },
                    emoteLoop = true
                }
            },
            ["psixe"] = {
                "pazeee@sixe@animations",
                "pazeee@sixe@clip",
                "Six Homeless 5",
                animationOptions = {
                    prop = "v_ret_gc_cup",
                    propBone = 52301,
                    propPlacement = {
                        0.330,
                        0.060,
                        -0.560,
                        -90.0,
                        0.0,
                        20.0,
                    },
                    emoteLoop = true
                }
            },
            ["psixh"] = {
                "pazeee@sixh@animations",
                "pazeee@sixh@clip",
                "Six Watch Phone 1",
                animationOptions = {
                    prop = "prop_player_phone_02",
                    propBone = 57005,
                    propPlacement = {
                        0.150,
                        0.06,
                        -0.05,
                        -176.3,
                        -10.6,
                        19.6,
                    },
                    emoteLoop = true
                }
            },
            ["psixi"] = {
                "pazeee@sixi@animations",
                "pazeee@sixi@clip",
                "Six Watch Phone 2 Shock",
                animationOptions = {
                    prop = "prop_player_phone_02",
                    propBone = 57005,
                    propPlacement = {
                        0.130,
                        0.04,
                        -0.08,
                        -176.3,
                        -10.6,
                        19.6,
                    },
                    emoteLoop = true
                }
            },
            ["psixk"] = {
                "pazeee@sixk@animations",
                "pazeee@sixk@clip",
                "Six Watch Phone 4 Tiktok",
                animationOptions = {
                    prop = "prop_player_phone_02",
                    propBone = 57005,
                    propPlacement = {
                        0.150,
                        0.069,
                        -0.0240,
                        -126.4,
                        -112.6,
                        20.3,
                    },
                    emoteLoop = true
                }
            },
            ["psixl"] = {
                "pazeee@sixl@animations",
                "pazeee@sixl@clip",
                "Six Trash / Garbage Collector 1",
                animationOptions = {
                    prop = "a3d_grabber",
                    propBone = 57005,
                    propPlacement = {
                        0.10,
                        0.01,
                        -0.01,
                        -113.3,
                        -153.4,
                        14.6,
                    },
                    secondProp = 'a3d_trashbag',
                    secondPropBone = 18905,
                    secondPropPlacement = {
                        0.0100,
                        0.2500,
                        0.160,
                        -5.0,
                        -120.3,
                        -8.6,
                    },
                    emoteLoop = true
                }
            },
            ["psixm"] = {
                "pazeee@sixm@animations",
                "pazeee@sixm@clip",
                "Six Trash / Garbage Collector 2",
                animationOptions = {
                    prop = "a3d_grabber",
                    propBone = 57005,
                    propPlacement = {
                        0.10,
                        0.01,
                        -0.01,
                        -113.3,
                        -153.4,
                        14.6,
                    },
                    secondProp = 'a3d_trashbag',
                    secondPropBone = 18905,
                    secondPropPlacement = {
                        0.100,
                        0.100,
                        0.260,
                        0.0,
                        -90.0,
                        -90.0,
                    },
                    emoteLoop = true
                }
            },
            ["psixn"] = {
                "pazeee@sixn@animations",
                "pazeee@sixn@clip",
                "Six Trash / Garbage Collector 3",
                animationOptions = {
                    prop = "a3d_grabber",
                    propBone = 57005,
                    propPlacement = {
                        0.10,
                        0.01,
                        -0.01,
                        -113.3,
                        -153.4,
                        14.6,
                    },
                    secondProp = 'a3d_trashbag',
                    secondPropBone = 18905,
                    secondPropPlacement = {
                        0.3100,
                        -0.0700,
                        -0.090,
                        -5.24,
                        -148.0,
                        52.0,
                    },
                    emoteLoop = true
                }
            },
            ["psixo"] = {
                "pazeee@sixo@animations",
                "pazeee@sixo@clip",
                "Six Trash / Garbage Collector 4",
                animationOptions = {
                    prop = "a3d_grabber",
                    propBone = 57005,
                    propPlacement = {
                        0.10,
                        0.01,
                        -0.01,
                        -113.3,
                        -153.4,
                        14.6,
                    },
                    secondProp = 'a3d_trashbag',
                    secondPropBone = 18905,
                    secondPropPlacement = {
                        0.100,
                        0.200,
                        0.240,
                        0.0,
                        -90.0,
                        -90.0,
                    },
                    emoteLoop = true
                }
            },
            ["psixp"] = {
                "pazeee@sixp@animations",
                "pazeee@sixp@clip",
                "Six Phone Take Photo Video 1",
                animationOptions = {
                    prop = "prop_player_phone_02",
                    propBone = 57005,
                    propPlacement = {
                        0.130,
                        0.07,
                        -0.02,
                        -119.5,
                        -103.6,
                        -3.7,
                    },
                    emoteLoop = true
                }
            },
            ["psixq"] = {
                "pazeee@sixq@animations",
                "pazeee@sixq@clip",
                "Six Phone Take Photo Video 2",
                animationOptions = {
                    prop = "prop_player_phone_02",
                    propBone = 57005,
                    propPlacement = {
                        0.130,
                        0.07,
                        -0.02,
                        -119.5,
                        -103.6,
                        -3.7,
                    },
                    emoteLoop = true
                }
            },
            ["psixr"] = {
                "pazeee@sixr@animations",
                "pazeee@sixr@clip",
                "Six Phone Take Photo Video 3",
                animationOptions = {
                    prop = "prop_player_phone_02",
                    propBone = 57005,
                    propPlacement = {
                        0.130,
                        0.11,
                        -0.05,
                        -102.7,
                        -39.4,
                        -5.4,
                    },
                    emoteLoop = true
                }
            },
            ["psixs"] = {
                "pazeee@sixs@animations",
                "pazeee@sixs@clip",
                "Six Phone Take Photo Video 4",
                animationOptions = {
                    prop = "prop_player_phone_02",
                    propBone = 57005,
                    propPlacement = {
                        0.140,
                        0.06,
                        -0.06,
                        -129.8,
                        -31.4,
                        -19.3,
                    },
                    secondProp = 'prop_player_phone_02',
                    secondPropBone = 18905,
                    secondPropPlacement = {
                        0.120,
                        0.060,
                        0.040,
                        -72.8,
                        -162.8,
                        32.2,
                    },
                    emoteLoop = true
                }
            },
            ["psixt"] = {
                "pazeee@sixt@animations",
                "pazeee@sixt@clip",
                "Six Phone Take Photo Video 5",
                animationOptions = {
                    prop = "prop_player_phone_02",
                    propBone = 57005,
                    propPlacement = {
                        0.1280,
                        0.06,
                        -0.03,
                        -139.2,
                        -111.6,
                        -5.4,
                    },
                    emoteLoop = true
                }
            },
            ["psixu"] = {
                "pazeee@sixu@animations",
                "pazeee@sixu@clip",
                "Six Phone Take Photo Video 6",
                animationOptions = {
                    prop = "prop_player_phone_02",
                    propBone = 57005,
                    propPlacement = {
                        0.120,
                        0.08,
                        -0.06,
                        -113.3,
                        -26.5,
                        -14.66,
                    },
                    emoteLoop = true
                }
            },
            ["psixv"] = {
                "pazeee@sixv@animations",
                "pazeee@sixv@clip",
                "Six Phone Take Photo Video 7",
                animationOptions = {
                    prop = "prop_player_phone_02",
                    propBone = 18905,
                    propPlacement = {
                        0.140,
                        0.05,
                        0.02,
                        -83.16,
                        -5.31,
                        -20.2,
                    },
                    emoteLoop = true
                }
            },
            ["psixw"] = {
                "pazeee@sixw@animations",
                "pazeee@sixw@clip",
                "Six Phone Take Photo Video 8 Move",
                animationOptions = {
                    prop = "prop_player_phone_02",
                    propBone = 57005,
                    propPlacement = {
                        0.160,
                        0.07,
                        -0.02,
                        -144.9,
                        -117.3,
                        6.1,
                    },
                    emoteLoop = true,
                    emoteMoving = true
                }
            },
            ["psixx"] = {
                "pazeee@sixx@animations",
                "pazeee@sixx@clip",
                "Six Phone Take Photo Video 9 Lay",
                animationOptions = {
                    prop = "prop_player_phone_02",
                    propBone = 57005,
                    propPlacement = {
                        0.160,
                        0.07,
                        -0.02,
                        -144.9,
                        -117.3,
                        6.1,
                    },
                    emoteLoop = true
                }
            },
            ["psixzc"] = {
                "pazeee@sixzc@animations",
                "pazeee@sixzc@clip",
                "Six Carry Box 1 Move",
                animationOptions = {
                    prop = "hei_prop_heist_wooden_box",
                    propBone = 57005,
                    propPlacement = {
                        0.180,
                        -0.120,
                        -0.350,
                        -70.07,
                        -6.79,
                        8.8,
                    },
                    emoteLoop = true,
                    emoteMoving = true
                }
            },
            ["psixzd"] = {
                "pazeee@sixzd@animations",
                "pazeee@sixzd@clip",
                "Six Carry Box 2",
                animationOptions = {
                    prop = "hei_prop_heist_wooden_box",
                    propBone = 57005,
                    propPlacement = {
                        0.50,
                        0.130,
                        -0.09,
                        -1.01,
                        -30.5,
                        72.7,
                    },
                    emoteLoop = true,
                    customMovementType = 47
                }
            },
            ["psixze"] = {
                "pazeee@sixze@animations",
                "pazeee@sixze@clip",
                "Six Carry Box 3 Panic",
                animationOptions = {
                    prop = "hei_prop_heist_wooden_box",
                    propBone = 57005,
                    propPlacement = {
                        0.50,
                        0.130,
                        -0.09,
                        -1.01,
                        -30.5,
                        72.7,
                    },
                    emoteLoop = true,
                    customMovementType = 47
                }
            },
            ["psixzf"] = {
                "pazeee@sixzf@animations",
                "pazeee@sixzf@clip",
                "Six Drag Box 4",
                animationOptions = {
                    prop = "hei_prop_heist_ammo_box",
                    propBone = 57005,
                    propPlacement = {
                        0.430,
                        0.210,
                        -0.220,
                        -103.4,
                        5.25,
                        49.6,
                    },
                    emoteLoop = true,
                    customMovementType = 47
                }
            },
            ["psixzg"] = {
                "pazeee@sixzg@animations",
                "pazeee@sixzg@clip",
                "Six Drag Box 5 Panic",
                animationOptions = {
                    prop = "hei_prop_heist_ammo_box",
                    propBone = 57005,
                    propPlacement = {
                        0.430,
                        0.210,
                        -0.220,
                        -103.4,
                        5.25,
                        49.6,
                    },
                    emoteLoop = true,
                    customMovementType = 47
                }
            },
            ["psixzh"] = {
                "pazeee@sixzh@animations",
                "pazeee@sixzh@clip",
                "Six Carry Box 6 Move",
                animationOptions = {
                    prop = "hei_prop_heist_wooden_box",
                    propBone = 57005,
                    propPlacement = {
                        0.210,
                        0.270,
                        -0.28,
                        9.9,
                        0.0,
                        -30.0,
                    },
                    emoteLoop = true,
                    emoteMoving = true
                }
            },
            ["psixzi"] = {
                "pazeee@sixzi@animations",
                "pazeee@sixzi@clip",
                "Six Carry Big Box 7 Move",
                animationOptions = {
                    prop = "prop_box_wood06a",
                    propBone = 24818,
                    propPlacement = {
                        -0.310,
                        -0.50,
                        0.0,
                        10.0,
                        90.0,
                        0.0,
                    },
                    emoteLoop = true,
                    emoteMoving = true
                }
            },
            ["psixzj"] = {
                "pazeee@sixzj@animations",
                "pazeee@sixzj@clip",
                "Six Carry Big Box 8 Move",
                animationOptions = {
                    prop = "prop_box_wood08a",
                    propBone = 24818,
                    propPlacement = {
                        0.150,
                        -0.150,
                        0.0,
                        79.9,
                        -90.0,
                        0.0,
                    },
                    emoteLoop = true,
                    emoteMoving = true
                }
            },
            ["psixzk"] = {
                "pazeee@sixzk@animations",
                "pazeee@sixzk@clip",
                "Six Gym Barbell 1",
                animationOptions = {
                    prop = "prop_barbell_02",
                    propBone = 18905,
                    propPlacement = {
                        0.120,
                        0.20,
                        -0.02,
                        -14.35,
                        40.54,
                        75.98,
                    },
                    secondProp = 'prop_muscle_bench_03',
                    secondPropBone = 52301,
                    secondPropPlacement = {
                        -0.690,
                        0.420,
                        0.110,
                        -107.4,
                        118.4,
                        -9.84,
                    },
                    emoteLoop = true
                }
            },
            ["psixzl"] = {
                "pazeee@sixzl@animations",
                "pazeee@sixzl@clip",
                "Six Gym Barbell 2",
                animationOptions = {
                    prop = "prop_barbell_02",
                    propBone = 57005,
                    propPlacement = {
                        0.110,
                        0.060,
                        0.0,
                        25.5,
                        -27.2,
                        67.7,
                    },
                    secondProp = 'prop_muscle_bench_01',
                    secondPropBone = 52301,
                    secondPropPlacement = {
                        -0.590,
                        -0.050,
                        0.0,
                        -108.8,
                        108.8,
                        -6.7,
                    },
                    emoteLoop = true
                }
            },
            ["psixzm"] = {
                "pazeee@sixzm@animations",
                "pazeee@sixzm@clip",
                "Six Gym Barbell 3",
                animationOptions = {
                    prop = "prop_barbell_02",
                    propBone = 18905,
                    propPlacement = {
                        0.080,
                        0.0,
                        0.03,
                        25.5,
                        -27.2,
                        67.7,
                    },
                    secondProp = 'prop_muscle_bench_01',
                    secondPropBone = 52301,
                    secondPropPlacement = {
                        -0.480,
                        -0.030,
                        0.360,
                        -100.3,
                        148.4,
                        -17.2,
                    },
                    emoteLoop = true
                }
            },
            ["psixzn"] = {
                "pazeee@sixzn@animations",
                "pazeee@sixzn@clip",
                "Six Gym Barbell 4",
                animationOptions = {
                    prop = "prop_barbell_02",
                    propBone = 18905,
                    propPlacement = {
                        0.080,
                        -0.060,
                        0.01,
                        44.56,
                        -45.4,
                        75.8,
                    },
                    secondProp = 'prop_barbell_02',
                    secondPropBone = 57005,
                    secondPropPlacement = {
                        0.110,
                        0.050,
                        -0.03,
                        16.73,
                        -19.42,
                        58.52,
                    },
                    emoteLoop = true
                }
            },
            ["psixzo"] = {
                "pazeee@sixzo@animations",
                "pazeee@sixzo@clip",
                "Six Gym Barbell 5",
                animationOptions = {
                    prop = "prop_barbell_02",
                    propBone = 57005,
                    propPlacement = {
                        0.250,
                        0.250,
                        0.07,
                        43.02,
                        -27.08,
                        52.88,
                    },
                    emoteLoop = true
                }
            },
            ["psixzp"] = {
                "pazeee@sixzp@animations",
                "pazeee@sixzp@clip",
                "Six Gym Master Barbell 6 Move",
                animationOptions = {
                    prop = "prop_barbell_02",
                    propBone = 57005,
                    propPlacement = {
                        0.250,
                        0.250,
                        0.07,
                        43.02,
                        -27.08,
                        52.88,
                    },
                    emoteLoop = true,
                    emoteMoving = true
                }
            },
            ["psixzq"] = {
                "pazeee@sixzq@animations",
                "pazeee@sixzq@clip",
                "Six Gym Barbell 7 Easy",
                animationOptions = {
                    prop = "prop_barbell_02",
                    propBone = 57005,
                    propPlacement = {
                        0.110,
                        0.060,
                        0.0,
                        25.50,
                        -27.27,
                        67.73,
                    },
                    emoteLoop = true
                }
            },
            ["psixzzc"] = {
                "pazeee@sixzzc@animations",
                "pazeee@sixzzc@clip",
                "Six Sit Edge 5 Phone Female",
                animationOptions = {
                    prop = "prop_player_phone_02",
                    propBone = 57005,
                    propPlacement = {
                        0.10,
                        0.050,
                        -0.05,
                        -99.52,
                        -5.05,
                        -9.5,
                    },
                    emoteLoop = true
                }
            },
            ["psixzzc2"] = {
                "pazeee@sixzzc2@animations",
                "pazeee@sixzzc2@clip",
                "Six Sit Edge 5 Phone Male",
                animationOptions = {
                    prop = "prop_player_phone_02",
                    propBone = 57005,
                    propPlacement = {
                        0.10,
                        0.050,
                        -0.05,
                        -99.52,
                        -5.05,
                        -9.5,
                    },
                    emoteLoop = true
                }
            },
            ["psixzzj"] = {
                "pazeee@sixzzj@animations",
                "pazeee@sixzzj@clip",
                "Six Evaluate Pen Clipboard",
                animationOptions = {
                    prop = "p_amb_clipboard_01",
                    propBone = 60309,
                    propPlacement = {
                        0.150,
                        0.060,
                        0.1,
                        -164.42,
                        -51.74,
                        12.7,
                    },
                    secondProp = 'bkr_prop_fakeid_penclipboard',
                    secondPropBone = 28422,
                    secondPropPlacement = {
                        0.070,
                        0.070,
                        0.01,
                        70.0,
                        0.0,
                        0.0,
                    },
                    emoteLoop = true
                }
            },
            ["psixzzk"] = {
                "pazeee@sixzzk@animations",
                "pazeee@sixzzk@clip",
                "Six Cool Pose Jason",
                animationOptions = {
                    prop = "w_pi_pistol50",
                    propBone = 60309,
                    propPlacement = {
                        0.10,
                        0.060,
                        -0.01,
                        -118.62,
                        -5.07,
                        11.274,
                    },
                    emoteLoop = true
                }
            },
            ["psixzzm"] = {
                "pazeee@sixzzm@animations",
                "pazeee@sixzzm@clip",
                "Six Cool Weapon Pose Jason",
                animationOptions = {
                    prop = "w_pi_pistol50",
                    propBone = 28422,
                    propPlacement = {
                        0.0980,
                        0.0620,
                        -0.01,
                        -57.70,
                        12.55,
                        -20.62,
                    },
                    emoteLoop = true
                }
            },
            ["psixzzn"] = {
                "pazeee@sixzzn@animations",
                "pazeee@sixzzn@clip",
                "Six Cool Weapon Pose Lucia",
                animationOptions = {
                    prop = "w_pi_pistol50",
                    propBone = 28422,
                    propPlacement = {
                        0.0990,
                        0.050,
                        0.0,
                        -57.70,
                        12.55,
                        -20.62,
                    },
                    secondProp = 'ch_prop_ch_security_case_02a',
                    secondPropBone = 60309,
                    secondPropPlacement = {
                        -0.130,
                        0.160,
                        0.28,
                        -54.46,
                        7.569,
                        32.08,
                    },
                    emoteLoop = true
                }
            },
            ["psixzzo"] = {
                "pazeee@sixzzo@animations",
                "pazeee@sixzzo@clip",
                "Six Cool Weapon Pose Lucia Lower",
                animationOptions = {
                    prop = "w_pi_pistol50",
                    propBone = 28422,
                    propPlacement = {
                        0.0990,
                        0.050,
                        0.0,
                        -57.70,
                        12.55,
                        -20.62,
                    },
                    secondProp = 'ch_prop_ch_security_case_02a',
                    secondPropBone = 60309,
                    secondPropPlacement = {
                        -0.130,
                        0.160,
                        0.28,
                        -54.46,
                        7.569,
                        32.08,
                    },
                    emoteLoop = true
                }
            },
            ["psixzzt"] = {
                "pazeee@sixzzt@animations",
                "pazeee@sixzzt@clip",
                "Six Crazy People With Weapon",
                animationOptions = {
                    prop = "w_mg_mg",
                    propBone = 57005,
                    propPlacement = {
                        0.130,
                        0.06,
                        0.0,
                        -50.0,
                        0.0,
                        0.0,
                    },
                    emoteLoop = true
                }
            },
            ["psixzzu"] = {
                "pazeee@sixzzu@animations",
                "pazeee@sixzzu@clip",
                "Six Cool Baseball 1",
                animationOptions = {
                    prop = "p_cs_bbbat_01",
                    propBone = 57005,
                    propPlacement = {
                        0.110,
                        0.03,
                        0.0,
                        -68.82,
                        7.09,
                        -18.74,
                    },
                    emoteLoop = true,
                    emoteMoving = true
                }
            },
            ["psixzzv"] = {
                "pazeee@sixzzv@animations",
                "pazeee@sixzzv@clip",
                "Six Cool Baseball 2",
                animationOptions = {
                    prop = "p_cs_bbbat_01",
                    propBone = 57005,
                    propPlacement = {
                        0.110,
                        0.04,
                        0.0,
                        -63.65,
                        4.41,
                        -8.97,
                    },
                    emoteLoop = true,
                    emoteMoving = true
                }
            },
            ["psixzzw"] = {
                "pazeee@sixzzw@animations",
                "pazeee@sixzzw@clip",
                "Six Cool Baseball 3",
                animationOptions = {
                    prop = "p_cs_bbbat_01",
                    propBone = 57005,
                    propPlacement = {
                        0.090,
                        0.06,
                        0.0,
                        -70.0,
                        0.0,
                        0.0,
                    },
                    emoteLoop = true,
                    emoteMoving = true
                }
            },
            ["psixzzx"] = {
                "pazeee@sixzzx@animations",
                "pazeee@sixzzx@clip",
                "Six Cool Baseball 4",
                animationOptions = {
                    prop = "p_cs_bbbat_01",
                    propBone = 57005,
                    propPlacement = {
                        0.090,
                        0.06,
                        0.0,
                        -70.0,
                        0.0,
                        0.0,
                    },
                    emoteLoop = true,
                    emoteMoving = true
                }
            },
            ["psixzzy"] = {
                "pazeee@sixzzy@animations",
                "pazeee@sixzzy@clip",
                "Six Cool Golf Clubs",
                animationOptions = {
                    prop = "prop_golf_iron_01",
                    propBone = 57005,
                    propPlacement = {
                        0.140,
                        0.07,
                        0.0,
                        52.99,
                        -112.7,
                        -33.82,
                    },
                    emoteLoop = true,
                    emoteMoving = true
                }
            },
            ["psixzzz"] = {
                "pazeee@sixzzz@animations",
                "pazeee@sixzzz@clip",
                "Six Carry Bag 1",
                animationOptions = {
                    prop = "prop_big_bag_01",
                    propBone = 57005,
                    propPlacement = {
                        0.260,
                        -0.04,
                        -0.08,
                        -45.55,
                        -31.31,
                        64.97,
                    },
                    emoteLoop = true,
                    emoteMoving = true
                }
            },
            ["psixzzza"] = {
                "pazeee@sixzzza@animations",
                "pazeee@sixzzza@clip",
                "Six Carry Bag 2",
                animationOptions = {
                    prop = "prop_big_bag_01",
                    propBone = 18905,
                    propPlacement = {
                        0.240,
                        -0.07,
                        -0.07,
                        -118.59,
                        64.091,
                        62.655,
                    },
                    emoteLoop = true,
                    emoteMoving = true
                }
            },
            ["psixzzzb"] = {
                "pazeee@sixzzzb@animations",
                "pazeee@sixzzzb@clip",
                "Six Carry Box Beer",
                animationOptions = {
                    prop = "v_ret_ml_beerbar",
                    propBone = 18905,
                    propPlacement = {
                        0.1890,
                        0.08,
                        0.09,
                        13.59,
                        -133.82,
                        -28.66,
                    },
                    emoteLoop = true,
                    emoteMoving = true
                }
            },
            ["psixzzzf"] = {
                "pazeee@sixzzzf@animations",
                "pazeee@sixzzzf@clip",
                "Six Worker Hammer 1",
                animationOptions = {
                    prop = "w_me_hammer",
                    propBone = 57005,
                    propPlacement = {
                        0.080,
                        -0.01,
                        -0.02,
                        -76.832,
                        41.763,
                        -15.18,
                    },
                    emoteLoop = true
                }
            },
            ["psixzzzg"] = {
                "pazeee@sixzzzg@animations",
                "pazeee@sixzzzg@clip",
                "Six Worker Hammer 2 Hit Hand",
                animationOptions = {
                    prop = "w_me_hammer",
                    propBone = 57005,
                    propPlacement = {
                        0.080,
                        -0.01,
                        -0.02,
                        -77.241,
                        39.48,
                        -5.44,
                    },
                    emoteLoop = true
                }
            },
            ["psixzzzh"] = {
                "pazeee@sixzzzh@animations",
                "pazeee@sixzzzh@clip",
                "Six Worker Dual Hammer Move",
                animationOptions = {
                    prop = "w_me_hammer",
                    propBone = 57005,
                    propPlacement = {
                        0.080,
                        -0.01,
                        -0.02,
                        -70.0,
                        0.0,
                        0.0,
                    },
                    secondProp = 'w_me_hammer',
                    secondPropBone = 18905,
                    secondPropPlacement = {
                        0.080,
                        -0.02,
                        0.03,
                        -110.0,
                        0.0,
                        0.0,
                    },
                    emoteMoving = true,
                    emoteLoop = true
                }
            },
            ["psixzzzi"] = {
                "pazeee@sixzzzi@animations",
                "pazeee@sixzzzi@clip",
                "Six Funny Hammer Dance 1",
                animationOptions = {
                    prop = "w_me_hammer",
                    propBone = 57005,
                    propPlacement = {
                        0.080,
                        -0.01,
                        -0.02,
                        -76.832,
                        41.763,
                        -15.18,
                    },
                    secondProp = 'w_me_hammer',
                    secondPropBone = 18905,
                    secondPropPlacement = {
                        0.080,
                        -0.02,
                        0.03,
                        -110.0,
                        0.0,
                        0.0,
                    },
                    emoteLoop = true
                }
            },
            ["psixzzzj"] = {
                "pazeee@sixzzzj@animations",
                "pazeee@sixzzzj@clip",
                "Six Funny Hammer Dance 2",
                animationOptions = {
                    prop = "w_me_hammer",
                    propBone = 57005,
                    propPlacement = {
                        0.080,
                        -0.01,
                        -0.02,
                        -76.832,
                        41.763,
                        -15.18,
                    },
                    secondProp = 'w_me_hammer',
                    secondPropBone = 18905,
                    secondPropPlacement = {
                        0.080,
                        -0.02,
                        0.03,
                        -110.0,
                        0.0,
                        0.0,
                    },
                    emoteLoop = true
                }
            },
            ["psixzzzk"] = {
                "pazeee@sixzzzk@animations",
                "pazeee@sixzzzk@clip",
                "Six Hammer Backward Move",
                animationOptions = {
                    prop = "w_me_hammer",
                    propBone = 57005,
                    propPlacement = {
                        0.080,
                        -0.01,
                        -0.02,
                        -76.832,
                        41.763,
                        -15.18,
                    },
                    emoteLoop = true
                }
            },
            ["psixzzzl"] = {
                "pazeee@sixzzzl@animations",
                "pazeee@sixzzzl@clip",
                "Six Say VCB 1 Hold Phone",
                animationOptions = {
                    prop = "prop_player_phone_02",
                    propBone = 18905,
                    propPlacement = {
                        0.130,
                        0.05,
                        0.01,
                        -99.99,
                        -3.45,
                        -9.70,
                    },
                    emoteLoop = true
                }
            },
            ["psixzzzd"] = {
                "pazeee@sixzzzd@animations",
                "pazeee@sixzzzd@clip",
                "Six Drunk Drag Jason",
                "pcarrya1",
                animationOptions = {
                    prop = "prop_amb_beer_bottle",
                    propBone = 18905,
                    propPlacement = {
                        0.110,
                        0.05,
                        0.01,
                        -120.0,
                        0.0,
                        0.0,
                    },
                    emoteLoop = true,
                    customMovementType = 47
                }
            },
        }
    }

    while not Config.Custom do Wait(0) end

    for arrayName, array in pairs(Animations) do
        if Config.Custom[arrayName] then
            for emoteName, emoteData in pairs(array) do
                Config.Custom[arrayName][emoteName] = emoteData
            end
        end
    end
end)
