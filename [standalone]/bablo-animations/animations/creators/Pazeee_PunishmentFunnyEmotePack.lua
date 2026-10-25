Citizen.CreateThread(function()
    if not Config.Creators['Pazeee_PunishmentFunnyEmotePack'] then return end

    local Animations = {
        Dances = {},
        Emotes = {
            ["ppunisha"] = {
                "pazeee@punish@a@animations",
                "pazeee@punish@a@clip",
                "Punish Ear Pull Right",
                animationOptions = {
                    emoteLoop = true,
                    emoteMoving = true
                }
            },
            ["ppunishb"] = {
                "pazeee@punish@b@animations",
                "pazeee@punish@b@clip",
                "Punish Ear Pull Left",
                animationOptions = {
                    emoteLoop = true,
                    emoteMoving = true
                }
            },
            ["ppunishc"] = {
                "pazeee@punish@c@animations",
                "pazeee@punish@c@clip",
                "Punish Ear Pull Shy Right & Left",
                animationOptions = {
                    emoteLoop = true
                }
            },
            ["ppunishd"] = {
                "pazeee@punish@d@animations",
                "pazeee@punish@d@clip",
                "Punish Ear Pull One Leg",
                animationOptions = {
                    emoteLoop = true
                }
            },
            ["ppunishe"] = {
                "pazeee@punish@e@animations",
                "pazeee@punish@e@clip",
                "Punish Ear Pull Squat",
                animationOptions = {
                    emoteLoop = true
                }
            },
            ["ppunishl"] = {
                "pazeee@punish@l@animations",
                "pazeee@punish@l@clip",
                "Punish Wall Upside Down",
                animationOptions = {
                    emoteLoop = true
                }
            },
            ["ppunishm"] = {
                "pazeee@punish@m@animations",
                "pazeee@punish@m@clip",
                "Punish Wall Upside Down Master",
                animationOptions = {
                    emoteLoop = true
                }
            },
            ["ppunishn"] = {
                "pazeee@punish@n@animations",
                "pazeee@punish@n@clip",
                "Punish Wall Upside Down Hand",
                animationOptions = {
                    emoteLoop = true
                }
            },
            ["ppunisho"] = {
                "pazeee@punish@o@animations",
                "pazeee@punish@o@clip",
                "Punish Duck Walk",
                animationOptions = {
                    emoteLoop = true,
                    customMovementType = 47
                }
            },
            ["ppunishp"] = {
                "pazeee@punish@p@animations",
                "pazeee@punish@p@clip",
                "Punish Duck Walk Hand On Head",
                animationOptions = {
                    emoteLoop = true,
                    customMovementType = 47
                }
            },
            ["ppunishq"] = {
                "pazeee@punish@q@animations",
                "pazeee@punish@q@clip",
                "Punish Duck Walk Ear Pull",
                animationOptions = {
                    emoteLoop = true,
                    customMovementType = 47
                }
            },
            ["ppunishr"] = {
                "pazeee@punish@r@animations",
                "pazeee@punish@r@clip",
                "Punish Shame Being Naked",
                animationOptions = {
                    emoteLoop = true
                }
            },
            ["ppunishs"] = {
                "pazeee@punish@s@animations",
                "pazeee@punish@s@clip",
                "Punish Shame Being Naked Runnn",
                animationOptions = {
                    emoteLoop = true,
                    emoteMoving = true
                }
            },
            ["ppunisht"] = {
                "pazeee@punish@t@animations",
                "pazeee@punish@t@clip",
                "Punish Salute",
                animationOptions = {
                    emoteLoop = true
                }
            },
            ["ppunishu"] = {
                "pazeee@punish@u@animations",
                "pazeee@punish@u@clip",
                "Punish Angry Yell In Someone Face",
                animationOptions = {
                    emoteLoop = true,
                    emoteMoving = true
                }
            },
            ["ppunishv"] = {
                "pazeee@punish@v@animations",
                "pazeee@punish@v@clip",
                "Punish No No No",
                animationOptions = {
                    emoteLoop = true,
                    emoteMoving = true
                }
            },
            ["ppunishw"] = {
                "pazeee@punish@w@animations",
                "pazeee@punish@w@clip",
                "Punish Cover Scared",
                animationOptions = {
                    emoteLoop = true
                }
            },
            ["ppunishzy"] = {
                "pazeee@punish@zy@animations",
                "pazeee@punish@zy@clip",
                "Punish Hog Rearing",
                animationOptions = {
                    emoteLoop = true
                }
            },
            ["ppunishzz"] = {
                "pazeee@punish@zz@animations",
                "pazeee@punish@zz@clip",
                "Punish Hog Serious Mode / Hog Race Event?",
                animationOptions = {
                    emoteLoop = true,
                    customMovementType = 47
                }
            },
            ["ppunishzza"] = {
                "pazeee@punish@zza@animations",
                "pazeee@punish@zza@clip",
                "Punish Bear Crawl Slow",
                animationOptions = {
                    emoteLoop = true,
                    customMovementType = 47
                }
            },
            ["ppunishzzb"] = {
                "pazeee@punish@zzb@animations",
                "pazeee@punish@zzb@clip",
                "Punish Bear Crawl Fast",
                animationOptions = {
                    emoteLoop = true,
                    customMovementType = 47
                }
            },
            ["ppunishzzc"] = {
                "pazeee@punish@zzc@animations",
                "pazeee@punish@zzc@clip",
                "Punish Bear Crawl Panic",
                animationOptions = {
                    emoteLoop = true,
                    customMovementType = 47
                }
            },
            ["ppunishzzd"] = {
                "pazeee@punish@zzd@animations",
                "pazeee@punish@zzd@clip",
                "Punish Baby Crawl",
                animationOptions = {
                    emoteLoop = true,
                    customMovementType = 47
                }
            },
            ["ppunishzze"] = {
                "pazeee@punish@zze@animations",
                "pazeee@punish@zze@clip",
                "Punish Baby Crawl Fast / Baby Crawl Race?",
                animationOptions = {
                    emoteLoop = true,
                    customMovementType = 47
                }
            },
            ["ppunishzzf"] = {
                "pazeee@punish@zzf@animations",
                "pazeee@punish@zzf@clip",
                "Punish Pig Idle Eat",
                animationOptions = {
                    emoteLoop = true
                }
            },
            ["ppunishzzg"] = {
                "pazeee@punish@zzg@animations",
                "pazeee@punish@zzg@clip",
                "Punish Pig Head Dance",
                animationOptions = {
                    emoteLoop = true
                }
            },
            ["ppunishzzh"] = {
                "pazeee@punish@zzh@animations",
                "pazeee@punish@zzh@clip",
                "Punish Pig Happy Dance",
                animationOptions = {
                    emoteLoop = true
                }
            },
            ["ppunishzzi"] = {
                "pazeee@punish@zzi@animations",
                "pazeee@punish@zzi@clip",
                "Punish Pig Obey",
                animationOptions = {
                    emoteLoop = true
                }
            },
            ["ppunishzzj"] = {
                "pazeee@punish@zzj@animations",
                "pazeee@punish@zzj@clip",
                "Punish Pig Cool Arrogant",
                animationOptions = {
                    emoteLoop = true
                }
            },
            ["ppunishzzk"] = {
                "pazeee@punish@zzk@animations",
                "pazeee@punish@zzk@clip",
                "Punish Pig Discuss Listen",
                animationOptions = {
                    emoteLoop = true
                }
            },
            ["ppunishzzl"] = {
                "pazeee@punish@zzl@animations",
                "pazeee@punish@zzl@clip",
                "Punish Pig Create Big Plan",
                animationOptions = {
                    emoteLoop = true
                }
            },
            ["ppunishzzm"] = {
                "pazeee@punish@zzm@animations",
                "pazeee@punish@zzm@clip",
                "Punish Shout Need Help",
                animationOptions = {
                    emoteLoop = true
                }
            },
            ["ppunishzzn"] = {
                "pazeee@punish@zzn@animations",
                "pazeee@punish@zzn@clip",
                "Punish Annoying Other People 1",
                animationOptions = {
                    emoteLoop = true
                }
            },
            ["ppunishzzo"] = {
                "pazeee@punish@zzo@animations",
                "pazeee@punish@zzo@clip",
                "Punish Annoying Other People 2",
                animationOptions = {
                    emoteLoop = true
                }
            },
            ["ppunishh"] = {
                "pazeee@punish@h@animations",
                "pazeee@punish@h@clip",
                "Punish Hold Book Side",
                animationOptions = {
                    prop = "prop_cs_stock_book",
                    propBone = 18905,
                    propPlacement = {
                        0.190,
                        0.02,
                        0.08,
                        -90.0,
                        -130.0,
                        -79.9,
                    },
                    secondProp = 'prop_cs_stock_book',
                    secondPropBone = 57005,
                    secondPropPlacement = {
                        0.20,
                        -0.01,
                        -0.06,
                        90.0,
                        99.9,
                        -79.9,
                    },
                    emoteLoop = true
                }
            },
            ["ppunishi"] = {
                "pazeee@punish@i@animations",
                "pazeee@punish@i@clip",
                "Punish Hold Book Front",
                animationOptions = {
                    prop = "prop_cs_stock_book",
                    propBone = 18905,
                    propPlacement = {
                        0.180,
                        0.0,
                        0.09,
                        -90.0,
                        -130.0,
                        -69.9,
                    },
                    secondProp = 'prop_cs_stock_book',
                    secondPropBone = 57005,
                    secondPropPlacement = {
                        0.20,
                        -0.01,
                        -0.1,
                        90.0,
                        120.0,
                        -69.9,
                    },
                    emoteLoop = true
                }
            },
            ["ppunishj"] = {
                "pazeee@punish@j@animations",
                "pazeee@punish@j@clip",
                "Punish Hold Multiple Book",
                animationOptions = {
                    prop = "vw_prop_book_stack_03b",
                    propBone = 31086,
                    propPlacement = {
                        0.230,
                        0.230,
                        -0.14,
                        9.999,
                        0.0,
                        49.999,
                    },
                    secondProp = 'vw_prop_book_stack_03b',
                    secondPropBone = 57005,
                    secondPropPlacement = {
                        0.020,
                        0.0,
                        -0.17,
                        -7.09,
                        111.17,
                        18.747,
                    },
                    emoteLoop = true
                }
            },
            ["ppunishk"] = {
                "pazeee@punish@k@animations",
                "pazeee@punish@k@clip",
                "Punish Lift Chair Overhead",
                animationOptions = {
                    prop = "prop_chair_08",
                    propBone = 57005,
                    propPlacement = {
                        0.110,
                        0.380,
                        -0.39,
                        130.32,
                        97.47,
                        -43.44,
                    },
                    emoteLoop = true,
                    emoteMoving = true
                }
            },
            ["ppunishzzzn"] = {
                "pazeee@punish@zzzn@animations",
                "pazeee@punish@zzzn@clip",
                "Punish Pull Anchor Ball Right",
                animationOptions = {
                    prop = "prop_dock_ropefloat",
                    propBone = 57005,
                    propPlacement = {
                        0.150,
                        0.010,
                        -0.04,
                        25.64,
                        -64.35,
                        61.94,
                    },
                    emoteLoop = true,
                    emoteMoving = true
                }
            },
            ["ppunishzzzo"] = {
                "pazeee@punish@zzzo@animations",
                "pazeee@punish@zzzo@clip",
                "Punish Pull Anchor Ball Left",
                animationOptions = {
                    prop = "prop_dock_ropefloat",
                    propBone = 18905,
                    propPlacement = {
                        0.160,
                        -0.010,
                        0.04,
                        0.0,
                        -135.99,
                        -90.0,
                    },
                    emoteLoop = true,
                    emoteMoving = true
                }
            },
            ["ppunishzzzp"] = {
                "pazeee@punish@zzzp@animations",
                "pazeee@punish@zzzp@clip",
                "Punish Pull Anchor Ball Double",
                animationOptions = {
                    prop = "prop_dock_ropefloat",
                    propBone = 57005,
                    propPlacement = {
                        0.150,
                        0.010,
                        -0.05,
                        -38.0,
                        0.0,
                        69.99,
                    },
                    secondProp = "prop_dock_ropefloat",
                    secondPropBone = 18905,
                    secondPropPlacement = {
                        0.160,
                        -0.010,
                        0.04,
                        0.0,
                        -135.99,
                        -90.0,
                    },
                    emoteLoop = true,
                    emoteMoving = true
                }
            },
            ["ppunishzzzq"] = {
                "pazeee@punish@zzzq@animations",
                "pazeee@punish@zzzq@clip",
                "Punish Pull Big Tires 1",
                animationOptions = {
                    prop = "prop_dock_ropetyre2",
                    propBone = 57005,
                    propPlacement = {
                        0.240,
                        0.020,
                        -0.05,
                        12.184,
                        -60.742,
                        6.947,
                    },
                    emoteLoop = true,
                    customMovementType = 47
                }
            },
            ["ppunishzzzr"] = {
                "pazeee@punish@zzzr@animations",
                "pazeee@punish@zzzr@clip",
                "Punish Pull Big Tires 2",
                animationOptions = {
                    prop = "prop_dock_ropetyre2",
                    propBone = 57005,
                    propPlacement = {
                        0.210,
                        0.00,
                        -0.04,
                        -12.41,
                        -120.81,
                        -39.422,
                    },
                    emoteLoop = true
                }
            },
        },
        Shared = {
            ["ppunishf"] = {
                "pazeee@punish@f@animations",
                "pazeee@punish@f@clip",
                "Punish Ear Pull Together 1",
                "ppunishg",
                animationOptions = {
                    syncOffsetFront = 0.8,
                    syncOffsetSide = 0.025,
                    emoteLoop = true
                }
            },
            ["ppunishg"] = {
                "pazeee@punish@g@animations",
                "pazeee@punish@g@clip",
                "Punish Ear Pull Together 2",
                "ppunishf",
                animationOptions = {
                    syncOffsetFront = 0.8,
                    syncOffsetSide = 0.025,
                    emoteLoop = true
                }
            },
            ["ppunishx"] = {
                "pazeee@punish@x@animations",
                "pazeee@punish@x@clip",
                "Punish Squat Carry 1",
                "ppunishy",
                animationOptions = {
                    emoteLoop = true
                }
            },
            ["ppunishy"] = {
                "pazeee@punish@y@animations",
                "pazeee@punish@y@clip",
                "Punish Squat Carry 2 Coach",
                "ppunishx",
                animationOptions = {
                    emoteLoop = true,
                    attachTo = true,
                    bone = 24818,
                    xPos = 0.400,
                    yPos = -0.230,
                    zPos = -0.200,
                    xRot = 0.000,
                    yRot = 0.000,
                    zRot = -20.000
                }
            },
            ["ppunishz"] = {
                "pazeee@punish@z@animations",
                "pazeee@punish@z@clip",
                "Punish Push Up Sit 1",
                "ppunishza",
                animationOptions = {
                    emoteLoop = true
                }
            },
            ["ppunishza"] = {
                "pazeee@punish@za@animations",
                "pazeee@punish@za@clip",
                "Punish Push Up Sit 2 Coach",
                "ppunishz",
                animationOptions = {
                    emoteLoop = true,
                    attachTo = true,
                    bone = 24818,
                    xPos = -0.080,
                    yPos = -0.110,
                    zPos = 0.000,
                    xRot = 180.000,
                    yRot = 180.000,
                    zRot = -79.9
                }
            },
            ["ppunishzb"] = {
                "pazeee@punish@zb@animations",
                "pazeee@punish@zb@clip",
                "Punish Push Up Serious 1",
                "ppunishzc",
                animationOptions = {
                    emoteLoop = true
                }
            },
            ["ppunishzc"] = {
                "pazeee@punish@zc@animations",
                "pazeee@punish@zc@clip",
                "Punish Push Up Serious 2 Coach Angry",
                "ppunishzb",
                animationOptions = {
                    emoteLoop = true,
                    attachTo = true,
                    bone = 24818,
                    xPos = -0.140,
                    yPos = -0.150,
                    zPos = 0.000,
                    xRot = 0.000,
                    yRot = 0.000,
                    zRot = -79.9
                }
            },
            ["ppunishzd"] = {
                "pazeee@punish@zd@animations",
                "pazeee@punish@zd@clip",
                "Punish Push Up One Hand 1",
                "ppunishze",
                animationOptions = {
                    emoteLoop = true
                }
            },
            ["ppunishze"] = {
                "pazeee@punish@ze@animations",
                "pazeee@punish@ze@clip",
                "Punish Push Up One Hand 2 Chill Coach ^^",
                "ppunishzd",
                animationOptions = {
                    emoteLoop = true,
                    attachTo = true,
                    bone = 24818,
                    xPos = -0.440,
                    yPos = -0.180,
                    zPos = -0.030,
                    xRot = 0.000,
                    yRot = 0.000,
                    zRot = -79.9
                }
            },
            ["ppunishzf"] = {
                "pazeee@punish@zf@animations",
                "pazeee@punish@zf@clip",
                "Punish Crawl Carry 1",
                "ppunishzg",
                animationOptions = {
                    emoteLoop = true,
                    customMovementType = 47
                }
            },
            ["ppunishzg"] = {
                "pazeee@punish@zg@animations",
                "pazeee@punish@zg@clip",
                "Punish Crawl Carry 2 Coach",
                "ppunishzf",
                animationOptions = {
                    emoteLoop = true,
                    attachTo = true,
                    bone = 24817,
                    xPos = -0.050,
                    yPos = -0.100,
                    zPos = -0.050,
                    xRot = 0.000,
                    yRot = 0.000,
                    zRot = -85.0
                }
            },
            ["ppunishzh"] = {
                "pazeee@punish@zh@animations",
                "pazeee@punish@zh@clip",
                "Punish Hog Rider Spirit 1",
                "ppunishzi",
                animationOptions = {
                    emoteLoop = true,
                    customMovementType = 47
                }
            },
            ["ppunishzi"] = {
                "pazeee@punish@zi@animations",
                "pazeee@punish@zi@clip",
                "Punish Hog Rider Spirit 2 Coach",
                "ppunishzh",
                animationOptions = {
                    emoteLoop = true,
                    prop = "w_me_stonehatchet",
                    propBone = 57005,
                    propPlacement = {
                        0.110,
                        0.02,
                        -0.02,
                        -58.43,
                        79.58,
                        17.22,
                    },
                    attachTo = true,
                    bone = 24816,
                    xPos = -0.030,
                    yPos = -0.060,
                    zPos = 0.00,
                    xRot = 0.000,
                    yRot = 0.000,
                    zRot = -90.0
                }
            },
            ["ppunishzj"] = {
                "pazeee@punish@zj@animations",
                "pazeee@punish@zj@clip",
                "Punish Hog Rider Enjoy Riding 1",
                "ppunishzk",
                animationOptions = {
                    emoteLoop = true,
                    customMovementType = 47
                }
            },
            ["ppunishzk"] = {
                "pazeee@punish@zk@animations",
                "pazeee@punish@zk@clip",
                "Punish Hog Rider Enjoy Riding 2 Coach",
                "ppunishzj",
                animationOptions = {
                    emoteLoop = true,
                    attachTo = true,
                    bone = 24816,
                    xPos = 0.00,
                    yPos = -0.10,
                    zPos = 0.00,
                    xRot = 0.000,
                    yRot = 0.000,
                    zRot = -90.0
                }
            },
            ["ppunishzl"] = {
                "pazeee@punish@zl@animations",
                "pazeee@punish@zl@clip",
                "Punish Hog Rider Cool Right 1",
                "ppunishzm",
                animationOptions = {
                    emoteLoop = true,
                    customMovementType = 47
                }
            },
            ["ppunishzm"] = {
                "pazeee@punish@zm@animations",
                "pazeee@punish@zm@clip",
                "Punish Hog Rider Cool Right 2 Coach",
                "ppunishzl",
                animationOptions = {
                    emoteLoop = true,
                    prop = "w_me_stonehatchet",
                    propBone = 57005,
                    propPlacement = {
                        0.110,
                        0.02,
                        -0.02,
                        -58.43,
                        79.58,
                        17.22,
                    },
                    attachTo = true,
                    bone = 24816,
                    xPos = -0.020,
                    yPos = -0.050,
                    zPos = 0.00,
                    xRot = 0.000,
                    yRot = 0.000,
                    zRot = -90.0
                }
            },
            ["ppunishzn"] = {
                "pazeee@punish@zn@animations",
                "pazeee@punish@zn@clip",
                "Punish Hog Rider Cool Left 1",
                "ppunishzo",
                animationOptions = {
                    emoteLoop = true,
                    customMovementType = 47
                }
            },
            ["ppunishzo"] = {
                "pazeee@punish@zo@animations",
                "pazeee@punish@zo@clip",
                "Punish Hog Rider Cool Left 2 Coach",
                "ppunishzn",
                animationOptions = {
                    emoteLoop = true,
                    prop = "w_me_stonehatchet",
                    propBone = 18905,
                    propPlacement = {
                        0.080,
                        0.0,
                        0.03,
                        -107.40,
                        -12.82,
                        -8.05,
                    },
                    attachTo = true,
                    bone = 24816,
                    xPos = -0.020,
                    yPos = -0.060,
                    zPos = -0.020,
                    xRot = 0.000,
                    yRot = 0.000,
                    zRot = -90.0
                }
            },
            ["ppunishzp"] = {
                "pazeee@punish@zp@animations",
                "pazeee@punish@zp@clip",
                "Punish Hog Rider Stand 1",
                "ppunishzq",
                animationOptions = {
                    emoteLoop = true,
                    customMovementType = 47
                }
            },
            ["ppunishzq"] = {
                "pazeee@punish@zq@animations",
                "pazeee@punish@zq@clip",
                "Punish Hog Rider Stand 2 Coach",
                "ppunishzp",
                animationOptions = {
                    emoteLoop = true,
                    prop = "w_me_stonehatchet",
                    propBone = 18905,
                    propPlacement = {
                        0.080,
                        0.0,
                        0.03,
                        -107.40,
                        -12.82,
                        -8.05,
                    },
                    secondProp = "w_me_stonehatchet",
                    secondPropBone = 57005,
                    secondPropPlacement = {
                        0.110,
                        0.02,
                        -0.02,
                        -58.43,
                        79.58,
                        17.22,
                    },
                    attachTo = true,
                    bone = 24817,
                    xPos = 0.040,
                    yPos = -0.850,
                    zPos = 0.10,
                    xRot = 0.000,
                    yRot = 0.000,
                    zRot = -90.0
                }
            },
            ["ppunishzr"] = {
                "pazeee@punish@zr@animations",
                "pazeee@punish@zr@clip",
                "Punish Hog Rider Stand Serious 1",
                "ppunishzs",
                animationOptions = {
                    emoteLoop = true,
                    customMovementType = 47
                }
            },
            ["ppunishzs"] = {
                "pazeee@punish@zs@animations",
                "pazeee@punish@zs@clip",
                "Punish Hog Rider Stand Serious 2 Coach",
                "ppunishzr",
                animationOptions = {
                    emoteLoop = true,
                    prop = "w_me_stonehatchet",
                    propBone = 18905,
                    propPlacement = {
                        0.080,
                        0.0,
                        0.03,
                        -107.40,
                        -12.82,
                        -8.05,
                    },
                    secondProp = "w_me_stonehatchet",
                    secondPropBone = 57005,
                    secondPropPlacement = {
                        0.110,
                        0.02,
                        -0.02,
                        -58.43,
                        79.58,
                        17.22,
                    },
                    attachTo = true,
                    bone = 24817,
                    xPos = -0.020,
                    yPos = -0.550,
                    zPos = 0.130,
                    xRot = 0.000,
                    yRot = 0.000,
                    zRot = -90.0
                }
            },
            ["ppunishzt"] = {
                "pazeee@punish@zt@animations",
                "pazeee@punish@zt@clip",
                "Punish Hog Rider Facing Back 1",
                "ppunishzu",
                animationOptions = {
                    emoteLoop = true,
                    customMovementType = 47
                }
            },
            ["ppunishzu"] = {
                "pazeee@punish@zu@animations",
                "pazeee@punish@zu@clip",
                "Punish Hog Rider Facing Back 2 Coach",
                "ppunishzt",
                animationOptions = {
                    emoteLoop = true,
                    attachTo = true,
                    bone = 24816,
                    xPos = 0.080,
                    yPos = -0.090,
                    zPos = -0.050,
                    xRot = 0.000,
                    yRot = 0.000,
                    zRot = -90.0
                }
            },
            ["ppunishzu1"] = {
                "pazeee@punish@zu1@animations",
                "pazeee@punish@zu1@clip",
                "Punish Hog Rider Player 1 To Player 2",
                "ppunishzx",
                animationOptions = {
                    emoteLoop = true
                }
            },
            ["ppunishzx"] = {
                "pazeee@punish@zx@animations",
                "pazeee@punish@zx@clip",
                "Punish Hog Rider Don't Press This",
                "ppunishzu1",
                animationOptions = {
                    emoteLoop = true,
                    attachTo = true,
                    bone = 0,
                    xPos = 0.0,
                    yPos = -0.260,
                    zPos = -0.090,
                    xRot = 0.000,
                    yRot = 0.000,
                    zRot = 0.0
                }
            },
            ["ppunishzv"] = {
                "pazeee@punish@zv@animations",
                "pazeee@punish@zv@clip",
                "Punish Hog Rider Player 3 To Player 1",
                "ppunishzw",
                animationOptions = {
                    emoteLoop = true,
                    customMovementType = 47
                }
            },
            ["ppunishzw"] = {
                "pazeee@punish@zw@animations",
                "pazeee@punish@zw@clip",
                "Punish Hog Rider Don't Press This",
                "ppunishzv",
                animationOptions = {
                    emoteLoop = true,
                    attachTo = true,
                    bone = 24816,
                    xPos = 0.20,
                    yPos = -0.10,
                    zPos = 0.00,
                    xRot = 0.000,
                    yRot = 0.000,
                    zRot = -90.0
                }
            },
            ["ppunishzzp"] = {
                "pazeee@punish@zzp@animations",
                "pazeee@punish@zzp@clip",
                "Punish Pull With Shovel Right 1",
                "ppunishzzq",
                animationOptions = {
                    emoteLoop = true,
                    emoteMoving = true,
                    prop = "prop_tool_shovel4",
                    propBone = 24817,
                    propPlacement = {
                        -1.40,
                        -0.610,
                        -0.810,
                        -25.69,
                        84.302,
                        25.43,
                    },
                }
            },
            ["ppunishzzq"] = {
                "pazeee@punish@zzq@animations",
                "pazeee@punish@zzq@clip",
                "Punish Pull With Shovel Right 2",
                "ppunishzzp",
                animationOptions = {
                    emoteLoop = true,
                    attachTo = true,
                    bone = 24817,
                    xPos = -1.290,
                    yPos = -0.640,
                    zPos = -0.870,
                    xRot = 0.000,
                    yRot = 0.000,
                    zRot = -20.0
                }
            },
            ["ppunishzzr"] = {
                "pazeee@punish@zzr@animations",
                "pazeee@punish@zzr@clip",
                "Punish Pull With Shovel Left 1",
                "ppunishzzs",
                animationOptions = {
                    emoteLoop = true,
                    emoteMoving = true,
                    prop = "prop_tool_shovel4",
                    propBone = 24818,
                    propPlacement = {
                        -1.650,
                        -0.470,
                        0.50,
                        -10.0,
                        90.0,
                        0.0,
                    },
                }
            },
            ["ppunishzzs"] = {
                "pazeee@punish@zzs@animations",
                "pazeee@punish@zzs@clip",
                "Punish Pull With Shovel Left 2",
                "ppunishzzr",
                animationOptions = {
                    emoteLoop = true,
                    attachTo = true,
                    bone = 24818,
                    xPos = -1.560,
                    yPos = -0.590,
                    zPos = 0.560,
                    xRot = 0.000,
                    yRot = 0.000,
                    zRot = -25.0
                }
            },
            ["ppunishzzt"] = {
                "pazeee@punish@zzt@animations",
                "pazeee@punish@zzt@clip",
                "Punish Slap Slow Hard 1",
                "ppunishzzu",
                animationOptions = {
                    syncOffsetFront = 0.85,
                    emoteLoop = true
                }
            },
            ["ppunishzzu"] = {
                "pazeee@punish@zzu@animations",
                "pazeee@punish@zzu@clip",
                "Punish Slap Slow Hard 2",
                "ppunishzzt",
                animationOptions = {
                    syncOffsetFront = 0.9,
                    emoteLoop = true
                }
            },
            ["ppunishzzv"] = {
                "pazeee@punish@zzv@animations",
                "pazeee@punish@zzv@clip",
                "Punish Slap Fast 1",
                "ppunishzzw",
                animationOptions = {
                    syncOffsetFront = 0.9,
                    emoteLoop = true
                }
            },
            ["ppunishzzw"] = {
                "pazeee@punish@zzw@animations",
                "pazeee@punish@zzw@clip",
                "Punish Slap Fast 2",
                "ppunishzzv",
                animationOptions = {
                    syncOffsetFront = 0.9,
                    emoteLoop = true
                }
            },
            ["ppunishzzx"] = {
                "pazeee@punish@zzx@animations",
                "pazeee@punish@zzx@clip",
                "Punish Pull Someone Ear 1",
                "ppunishzzy",
                animationOptions = {
                    emoteLoop = true,
                    emoteMoving = true
                }
            },
            ["ppunishzzy"] = {
                "pazeee@punish@zzy@animations",
                "pazeee@punish@zzy@clip",
                "Punish Pull Someone Ear 2",
                "ppunishzzx",
                animationOptions = {
                    emoteLoop = true,
                    attachTo = true,
                    bone = 24818,
                    xPos = -1.120,
                    yPos = 0.080,
                    zPos = -0.50,
                    xRot = 0.000,
                    yRot = 0.000,
                    zRot = -25.0
                }
            },
            ["ppunishzzz"] = {
                "pazeee@punish@zzz@animations",
                "pazeee@punish@zzz@clip",
                "Punish Pull People Tantrum Behind 1",
                "ppunishzzza",
                animationOptions = {
                    emoteLoop = true,
                    emoteMoving = true
                }
            },
            ["ppunishzzza"] = {
                "pazeee@punish@zzza@animations",
                "pazeee@punish@zzza@clip",
                "Punish Pull People Tantrum Behind 2",
                "ppunishzzz",
                animationOptions = {
                    emoteLoop = true,
                    attachTo = true,
                    bone = 24818,
                    xPos = -1.140,
                    yPos = -0.270,
                    zPos = -0.040,
                    xRot = -180.000,
                    yRot = -180.000,
                    zRot = 10.0
                }
            },
            ["ppunishzzzb"] = {
                "pazeee@punish@zzzb@animations",
                "pazeee@punish@zzzb@clip",
                "Punish Massage 1",
                "ppunishzzzc",
                animationOptions = {
                    syncOffsetFront = 0.55,
                    emoteLoop = true
                }
            },
            ["ppunishzzzc"] = {
                "pazeee@punish@zzzc@animations",
                "pazeee@punish@zzzc@clip",
                "Punish Massage 2",
                "ppunishzzzb",
                animationOptions = {
                    syncOffsetFront = 0.6,
                    emoteLoop = true
                }
            },
            ["ppunishzzzd"] = {
                "pazeee@punish@zzzd@animations",
                "pazeee@punish@zzzd@clip",
                "Punish Kicked 1",
                "ppunishzzze",
                animationOptions = {
                    syncOffsetFront = 0.7,
                    syncOffsetSide = 0.4,
                }
            },
            ["ppunishzzze"] = {
                "pazeee@punish@zzze@animations",
                "pazeee@punish@zzze@clip",
                "Punish Kicked 2",
                "ppunishzzzd",
                animationOptions = {
                    syncOffsetFront = 0.7,
                    syncOffsetSide = 0.4,
                    customMovementType = 1
                }
            },
            ["ppunishzzzf"] = {
                "pazeee@punish@zzzf@animations",
                "pazeee@punish@zzzf@clip",
                "Punish Hit Hand Pole Front 1",
                "ppunishzzzg",
                animationOptions = {
                    syncOffsetFront = 1.1,
                    syncOffsetSide = -0.7,
                    emoteLoop = true,
                    prop = "prop_scaffold_pole",
                    propBone = 57005,
                    propPlacement = {
                        0.130,
                        0.060,
                        -0.02,
                        -90.0,
                        0.0,
                        -44.999,
                    },
                }
            },
            ["ppunishzzzg"] = {
                "pazeee@punish@zzzg@animations",
                "pazeee@punish@zzzg@clip",
                "Punish Hit Hand Pole Front 2",
                "ppunishzzzf",
                animationOptions = {
                    syncOffsetFront = 1.1,
                    syncOffsetSide = -0.7,
                    emoteLoop = true
                }
            },
            ["ppunishzzzh"] = {
                "pazeee@punish@zzzh@animations",
                "pazeee@punish@zzzh@clip",
                "Punish Hit Hand Pole Behind 1",
                "ppunishzzzi",
                animationOptions = {
                    syncOffsetFront = 0.85,
                    syncOffsetSide = 0.3,
                    emoteLoop = true,
                    prop = "prop_scaffold_pole",
                    propBone = 57005,
                    propPlacement = {
                        0.10,
                        0.060,
                        0.0,
                        -90.0,
                        0.0,
                        -30.0,
                    },
                }
            },
            ["ppunishzzzi"] = {
                "pazeee@punish@zzzi@animations",
                "pazeee@punish@zzzi@clip",
                "Punish Hit Hand Pole Behind 2",
                "ppunishzzzh",
                animationOptions = {
                    syncOffsetFront = 1.0,
                    syncOffsetSide = 0.3,
                    emoteLoop = true
                }
            },
            ["ppunishzzzj"] = {
                "pazeee@punish@zzzj@animations",
                "pazeee@punish@zzzj@clip",
                "Punish Hit Back Pole 1",
                "ppunishzzzk",
                animationOptions = {
                    syncOffsetFront = 1.15,
                    syncOffsetSide = -0.1,
                    emoteLoop = true,
                    prop = "prop_scaffold_pole",
                    propBone = 57005,
                    propPlacement = {
                        0.110,
                        0.060,
                        -0.01,
                        -78.491,
                        5.725,
                        -29.49,
                    },
                }
            },
            ["ppunishzzzk"] = {
                "pazeee@punish@zzzk@animations",
                "pazeee@punish@zzzk@clip",
                "Punish Hit Back Pole 2",
                "ppunishzzzj",
                animationOptions = {
                    syncOffsetFront = 1.15,
                    syncOffsetSide = -0.1,
                    emoteLoop = true
                }
            },
            ["ppunishzzzl"] = {
                "pazeee@punish@zzzl@animations",
                "pazeee@punish@zzzl@clip",
                "Punish Hit Butt Pole 1",
                "ppunishzzzm",
                animationOptions = {
                    syncOffsetFront = 0.95,
                    syncOffsetSide = -0.25,
                    emoteLoop = true,
                    prop = "prop_scaffold_pole",
                    propBone = 57005,
                    propPlacement = {
                        0.10,
                        0.030,
                        -0.02,
                        -65.252,
                        30.898,
                        -23.800,
                    },
                }
            },
            ["ppunishzzzm"] = {
                "pazeee@punish@zzzm@animations",
                "pazeee@punish@zzzm@clip",
                "Punish Hit Butt Pole 2",
                "ppunishzzzl",
                animationOptions = {
                    syncOffsetFront = 0.95,
                    syncOffsetSide = -0.25,
                    emoteLoop = true
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
