Citizen.CreateThread(function()
    if not Config.Creators['Pazeee_FireworkEmotePack'] then return end

    local Animations = {
        Dances = {},

        Emotes = {
            ["pfireworksu"] = {
                "pazeee@fireworksu@animations",
                "pazeee@fireworksu@clip",
                "Fireworks Scared Cover Ears",
                animationOptions = {
                    emoteLoop = true,
                    emoteMoving = true
                }
            },
            ["pfireworksv"] = {
                "pazeee@fireworksv@animations",
                "pazeee@fireworksv@clip",
                "Fireworks Really Scared Cover Ears 1",
                animationOptions = {
                    emoteLoop = true
                }
            },
            ["pfireworksw"] = {
                "pazeee@fireworksw@animations",
                "pazeee@fireworksw@clip",
                "Fireworks Really Scared Cover Ears 2",
                animationOptions = {
                    emoteLoop = true
                }
            },
            ["pfireworksx"] = {
                "pazeee@fireworksx@animations",
                "pazeee@fireworksx@clip",
                "Fireworks Really Really Scared",
                animationOptions = {
                    emoteLoop = true
                }
            },
            ["pfireworksz"] = {
                "pazeee@fireworksz@animations",
                "pazeee@fireworksz@clip",
                "Fireworks Shocked 1",
            },
            ["pfireworksza"] = {
                "pazeee@fireworksza@animations",
                "pazeee@fireworksza@clip",
                "Fireworks Shocked 2",
            },
            ["pfireworksa"] = {
                "pazeee@fireworksa@animations",
                "pazeee@fireworksa@clip",
                "Fireworks Normal",
                animationOptions = {
                    emoteLoop = true,
                    emoteMoving = true,
                    prop = 'pazeeefireworks',
                    propBone = 57005, -- 28422
                    propPlacement = {
                        0.1200, 0.160, 0.01,
                        -77.6938, 2.748, -12.7111
                    },
                    ptfxAsset = "scr_indep_fireworks",
                    ptfxName = "scr_indep_firework_starburst",
                    ptfxColor = {
                        { R = 255, G = 0,   B = 0,   A = 1.0 },
                        { R = 0,   G = 255, B = 0,   A = 1.0 },
                        { R = 0,   G = 0,   B = 255, A = 1.0 },
                        { R = 177, G = 5,   B = 245, A = 1.0 },
                        { R = 251, G = 3,   B = 255, A = 1.0 },
                        { R = 2,   G = 238, B = 250, A = 1.0 },
                        { R = 252, G = 248, B = 0,   A = 1.0 },
                        { R = 245, G = 245, B = 245, A = 1.0 }
                    },
                    ptfxPlacement = {
                        0.0,
                        0.0,
                        0.0,
                        0.0,
                        0.0,
                        0.0,
                        1.0
                    },
                    ptfxWait = 200,
                    ptfxCanHold = true
                }
            },
            ["pfireworksb"] = {
                "pazeee@fireworksb@animations",
                "pazeee@fireworksb@clip",
                "Fireworks High",
                animationOptions = {
                    emoteLoop = true,
                    emoteMoving = true,
                    prop = 'pazeeefireworks',
                    propBone = 57005,
                    propPlacement = {
                        0.1200, 0.160, 0.01,
                        -77.6938, 2.748, -12.7111
                    },
                    ptfxAsset = "scr_indep_fireworks",
                    ptfxName = "scr_indep_firework_starburst",
                    ptfxColor = {
                        { R = 255, G = 0,   B = 0,   A = 1.0 },
                        { R = 0,   G = 255, B = 0,   A = 1.0 },
                        { R = 0,   G = 0,   B = 255, A = 1.0 },
                        { R = 177, G = 5,   B = 245, A = 1.0 },
                        { R = 251, G = 3,   B = 255, A = 1.0 },
                        { R = 2,   G = 238, B = 250, A = 1.0 },
                        { R = 252, G = 248, B = 0,   A = 1.0 },
                        { R = 245, G = 245, B = 245, A = 1.0 }
                    },
                    ptfxPlacement = {
                        0.0,
                        0.0,
                        0.0,
                        0.0,
                        0.0,
                        0.0,
                        1.0
                    },
                    ptfxWait = 200,
                    ptfxCanHold = true
                }
            },
            ["pfireworksc"] = {
                "pazeee@fireworksc@animations",
                "pazeee@fireworksc@clip",
                "Fireworks Front",
                animationOptions = {
                    emoteLoop = true,
                    emoteMoving = true,
                    prop = 'pazeeefireworks',
                    propBone = 57005,
                    propPlacement = {
                        0.1200, 0.160, 0.01,
                        -77.6938, 2.748, -12.7111
                    },
                    ptfxAsset = "scr_indep_fireworks",
                    ptfxName = "scr_indep_firework_starburst",
                    ptfxColor = {
                        { R = 255, G = 0,   B = 0,   A = 1.0 },
                        { R = 0,   G = 255, B = 0,   A = 1.0 },
                        { R = 0,   G = 0,   B = 255, A = 1.0 },
                        { R = 177, G = 5,   B = 245, A = 1.0 },
                        { R = 251, G = 3,   B = 255, A = 1.0 },
                        { R = 2,   G = 238, B = 250, A = 1.0 },
                        { R = 252, G = 248, B = 0,   A = 1.0 },
                        { R = 245, G = 245, B = 245, A = 1.0 }
                    },
                    ptfxPlacement = {
                        0.0,
                        0.0,
                        0.0,
                        0.0,
                        0.0,
                        0.0,
                        1.0
                    },
                    ptfxWait = 200,
                    ptfxCanHold = true
                }
            },
            ["pfireworksd"] = {
                "pazeee@fireworksd@animations",
                "pazeee@fireworksd@clip",
                "Fireworks Back Right",
                animationOptions = {
                    emoteLoop = true,
                    emoteMoving = true,
                    prop = 'pazeeefireworks',
                    propBone = 57005,
                    propPlacement = {
                        0.1200, 0.160, 0.01,
                        -77.6938, 2.748, -12.7111
                    },
                    ptfxAsset = "scr_indep_fireworks",
                    ptfxName = "scr_indep_firework_starburst",
                    ptfxColor = {
                        { R = 255, G = 0,   B = 0,   A = 1.0 },
                        { R = 0,   G = 255, B = 0,   A = 1.0 },
                        { R = 0,   G = 0,   B = 255, A = 1.0 },
                        { R = 177, G = 5,   B = 245, A = 1.0 },
                        { R = 251, G = 3,   B = 255, A = 1.0 },
                        { R = 2,   G = 238, B = 250, A = 1.0 },
                        { R = 252, G = 248, B = 0,   A = 1.0 },
                        { R = 245, G = 245, B = 245, A = 1.0 }
                    },
                    ptfxPlacement = {
                        0.0,
                        0.0,
                        0.0,
                        0.0,
                        0.0,
                        0.0,
                        1.0
                    },
                    ptfxWait = 200,
                    ptfxCanHold = true
                }
            },
            ["pfireworkse"] = {
                "pazeee@fireworkse@animations",
                "pazeee@fireworkse@clip",
                "Fireworks Back Left",
                animationOptions = {
                    emoteLoop = true,
                    emoteMoving = true,
                    prop = 'pazeeefireworks',
                    propBone = 18905,
                    propPlacement = {
                        0.1300, 0.160, 0.0,
                        -98.2076, -1.84, -12.871
                    },
                    ptfxAsset = "scr_indep_fireworks",
                    ptfxName = "scr_indep_firework_starburst",
                    ptfxColor = {
                        { R = 255, G = 0,   B = 0,   A = 1.0 },
                        { R = 0,   G = 255, B = 0,   A = 1.0 },
                        { R = 0,   G = 0,   B = 255, A = 1.0 },
                        { R = 177, G = 5,   B = 245, A = 1.0 },
                        { R = 251, G = 3,   B = 255, A = 1.0 },
                        { R = 2,   G = 238, B = 250, A = 1.0 },
                        { R = 252, G = 248, B = 0,   A = 1.0 },
                        { R = 245, G = 245, B = 245, A = 1.0 }
                    },
                    ptfxPlacement = {
                        0.0,
                        0.0,
                        0.0,
                        0.0,
                        0.0,
                        0.0,
                        1.0
                    },
                    ptfxWait = 200,
                    ptfxCanHold = true
                }
            },
            ["pfireworksf"] = {
                "pazeee@fireworksf@animations",
                "pazeee@fireworksf@clip",
                "Fireworks Scared",
                animationOptions = {
                    emoteLoop = true,
                    prop = 'pazeeefireworks',
                    propBone = 57005,
                    propPlacement = {
                        0.1200, 0.160, 0.01,
                        -77.6938, 2.748, -12.7111
                    },
                    ptfxAsset = "scr_indep_fireworks",
                    ptfxName = "scr_indep_firework_starburst",
                    ptfxColor = {
                        { R = 255, G = 0,   B = 0,   A = 1.0 },
                        { R = 0,   G = 255, B = 0,   A = 1.0 },
                        { R = 0,   G = 0,   B = 255, A = 1.0 },
                        { R = 177, G = 5,   B = 245, A = 1.0 },
                        { R = 251, G = 3,   B = 255, A = 1.0 },
                        { R = 2,   G = 238, B = 250, A = 1.0 },
                        { R = 252, G = 248, B = 0,   A = 1.0 },
                        { R = 245, G = 245, B = 245, A = 1.0 }
                    },
                    ptfxPlacement = {
                        0.0,
                        0.0,
                        0.0,
                        0.0,
                        0.0,
                        0.0,
                        1.0
                    },
                    ptfxWait = 200,
                    ptfxCanHold = true
                }
            },
            ["pfireworksg"] = {
                "pazeee@fireworksg@animations",
                "pazeee@fireworksg@clip",
                "Fireworks Random Idle 1",
                animationOptions = {
                    emoteLoop = true,
                    emoteMoving = true,
                    prop = 'pazeeefireworks',
                    propBone = 57005,
                    propPlacement = {
                        0.1200, 0.160, 0.01,
                        -77.6938, 2.748, -12.7111
                    },
                    ptfxAsset = "scr_indep_fireworks",
                    ptfxName = "scr_indep_firework_starburst",
                    ptfxColor = {
                        { R = 255, G = 0,   B = 0,   A = 1.0 },
                        { R = 0,   G = 255, B = 0,   A = 1.0 },
                        { R = 0,   G = 0,   B = 255, A = 1.0 },
                        { R = 177, G = 5,   B = 245, A = 1.0 },
                        { R = 251, G = 3,   B = 255, A = 1.0 },
                        { R = 2,   G = 238, B = 250, A = 1.0 },
                        { R = 252, G = 248, B = 0,   A = 1.0 },
                        { R = 245, G = 245, B = 245, A = 1.0 }
                    },
                    ptfxPlacement = {
                        0.0,
                        0.0,
                        0.0,
                        0.0,
                        0.0,
                        0.0,
                        1.0
                    },
                    ptfxWait = 200,
                    ptfxCanHold = true
                }
            },
            ["pfireworksh"] = {
                "pazeee@fireworksh@animations",
                "pazeee@fireworksh@clip",
                "Fireworks Random Idle 2",
                animationOptions = {
                    emoteLoop = true,
                    emoteMoving = true,
                    prop = 'pazeeefireworks',
                    propBone = 57005,
                    propPlacement = {
                        0.1200, 0.160, 0.01,
                        -77.6938, 2.748, -12.7111
                    },
                    ptfxAsset = "scr_indep_fireworks",
                    ptfxName = "scr_indep_firework_starburst",
                    ptfxColor = {
                        { R = 255, G = 0,   B = 0,   A = 1.0 },
                        { R = 0,   G = 255, B = 0,   A = 1.0 },
                        { R = 0,   G = 0,   B = 255, A = 1.0 },
                        { R = 177, G = 5,   B = 245, A = 1.0 },
                        { R = 251, G = 3,   B = 255, A = 1.0 },
                        { R = 2,   G = 238, B = 250, A = 1.0 },
                        { R = 252, G = 248, B = 0,   A = 1.0 },
                        { R = 245, G = 245, B = 245, A = 1.0 }
                    },
                    ptfxPlacement = {
                        0.0,
                        0.0,
                        0.0,
                        0.0,
                        0.0,
                        0.0,
                        1.0
                    },
                    ptfxWait = 200,
                    ptfxCanHold = true
                }
            },
            ["pfireworksi"] = {
                "pazeee@fireworksi@animations",
                "pazeee@fireworksi@clip",
                "Fireworks Magican",
                animationOptions = {
                    emoteLoop = true,
                    emoteMoving = true,
                    prop = 'pazeeefireworks',
                    propBone = 57005,
                    propPlacement = {
                        0.1200, 0.160, 0.01,
                        -77.6938, 2.748, -12.7111
                    },
                    ptfxAsset = "scr_indep_fireworks",
                    ptfxName = "scr_indep_firework_starburst",
                    ptfxColor = {
                        { R = 255, G = 0,   B = 0,   A = 1.0 },
                        { R = 0,   G = 255, B = 0,   A = 1.0 },
                        { R = 0,   G = 0,   B = 255, A = 1.0 },
                        { R = 177, G = 5,   B = 245, A = 1.0 },
                        { R = 251, G = 3,   B = 255, A = 1.0 },
                        { R = 2,   G = 238, B = 250, A = 1.0 },
                        { R = 252, G = 248, B = 0,   A = 1.0 },
                        { R = 245, G = 245, B = 245, A = 1.0 }
                    },
                    ptfxPlacement = {
                        0.0,
                        0.0,
                        0.0,
                        0.0,
                        0.0,
                        0.0,
                        1.0
                    },
                    ptfxWait = 200,
                    ptfxCanHold = true
                }
            },
            ["pfireworksj"] = {
                "pazeee@fireworksj@animations",
                "pazeee@fireworksj@clip",
                "Fireworks Master Style",
                animationOptions = {
                    emoteLoop = true,
                    prop = 'pazeeefireworks',
                    propBone = 57005,
                    propPlacement = {
                        0.1200, 0.160, 0.01,
                        -77.6938, 2.748, -12.7111
                    },
                    ptfxAsset = "scr_indep_fireworks",
                    ptfxName = "scr_indep_firework_starburst",
                    ptfxColor = {
                        { R = 255, G = 0,   B = 0,   A = 1.0 },
                        { R = 0,   G = 255, B = 0,   A = 1.0 },
                        { R = 0,   G = 0,   B = 255, A = 1.0 },
                        { R = 177, G = 5,   B = 245, A = 1.0 },
                        { R = 251, G = 3,   B = 255, A = 1.0 },
                        { R = 2,   G = 238, B = 250, A = 1.0 },
                        { R = 252, G = 248, B = 0,   A = 1.0 },
                        { R = 245, G = 245, B = 245, A = 1.0 }
                    },
                    ptfxPlacement = {
                        0.0,
                        0.0,
                        0.0,
                        0.0,
                        0.0,
                        0.0,
                        1.0
                    },
                    ptfxWait = 200,
                    ptfxCanHold = true
                }
            },
            ["pfireworksk"] = {
                "pazeee@fireworksk@animations",
                "pazeee@fireworksk@clip",
                "Fireworks 2 Stick Wide",
                animationOptions = {
                    emoteLoop = true,
                    emoteMoving = true,
                    prop = 'pazeeefireworks',
                    propBone = 57005,
                    propPlacement = {
                        0.1200, 0.160, 0.01,
                        -77.6938, 2.748, -12.7111
                    },
                    ptfxAsset = "scr_indep_fireworks",
                    ptfxName = "scr_indep_firework_starburst",
                    ptfxColor = {
                        { R = 255, G = 0,   B = 0,   A = 1.0 },
                        { R = 0,   G = 255, B = 0,   A = 1.0 },
                        { R = 0,   G = 0,   B = 255, A = 1.0 },
                        { R = 177, G = 5,   B = 245, A = 1.0 },
                        { R = 251, G = 3,   B = 255, A = 1.0 },
                        { R = 2,   G = 238, B = 250, A = 1.0 },
                        { R = 252, G = 248, B = 0,   A = 1.0 },
                        { R = 245, G = 245, B = 245, A = 1.0 }
                    },
                    ptfxPlacement = {
                        0.0,
                        0.0,
                        0.0,
                        0.0,
                        0.0,
                        0.0,
                        1.0
                    },
                    secondProp = 'pazeeefireworks',
                    secondPropBone = 18905,
                    secondPropPlacement = {
                        0.1300, 0.160, 0.0,
                        -98.2076, -1.84, -12.871
                    },
                    secondPtfxAsset = "scr_indep_fireworks",
                    secondPtfxName = "scr_indep_firework_starburst",
                    secondPtfxColor = {
                        { R = 255, G = 0,   B = 0,   A = 1.0 },
                        { R = 0,   G = 255, B = 0,   A = 1.0 },
                        { R = 0,   G = 0,   B = 255, A = 1.0 },
                        { R = 177, G = 5,   B = 245, A = 1.0 },
                        { R = 251, G = 3,   B = 255, A = 1.0 },
                        { R = 2,   G = 238, B = 250, A = 1.0 },
                        { R = 252, G = 248, B = 0,   A = 1.0 },
                        { R = 245, G = 245, B = 245, A = 1.0 }
                    },
                    secondPtfxPlacement = {
                        0.0,
                        0.0,
                        0.0,
                        0.0,
                        0.0,
                        0.0,
                        1.0
                    },
                    ptfxWait = 200,
                    ptfxCanHold = true
                }
            },
            ["pfireworksl"] = {
                "pazeee@fireworksl@animations",
                "pazeee@fireworksl@clip",
                "Fireworks 2 Stick Front",
                animationOptions = {
                    emoteLoop = true,
                    emoteMoving = true,
                    prop = 'pazeeefireworks',
                    propBone = 57005,
                    propPlacement = {
                        0.1200, 0.160, 0.01,
                        -77.6938, 2.748, -12.7111
                    },
                    ptfxAsset = "scr_indep_fireworks",
                    ptfxName = "scr_indep_firework_starburst",
                    ptfxColor = {
                        { R = 255, G = 0,   B = 0,   A = 1.0 },
                        { R = 0,   G = 255, B = 0,   A = 1.0 },
                        { R = 0,   G = 0,   B = 255, A = 1.0 },
                        { R = 177, G = 5,   B = 245, A = 1.0 },
                        { R = 251, G = 3,   B = 255, A = 1.0 },
                        { R = 2,   G = 238, B = 250, A = 1.0 },
                        { R = 252, G = 248, B = 0,   A = 1.0 },
                        { R = 245, G = 245, B = 245, A = 1.0 }
                    },
                    ptfxPlacement = {
                        0.0,
                        0.0,
                        0.0,
                        0.0,
                        0.0,
                        0.0,
                        1.0
                    },
                    secondProp = 'pazeeefireworks',
                    secondPropBone = 18905,
                    secondPropPlacement = {
                        0.1300, 0.160, 0.0,
                        -98.2076, -1.84, -12.871
                    },
                    secondPtfxAsset = "scr_indep_fireworks",
                    secondPtfxName = "scr_indep_firework_starburst",
                    secondPtfxColor = {
                        { R = 255, G = 0,   B = 0,   A = 1.0 },
                        { R = 0,   G = 255, B = 0,   A = 1.0 },
                        { R = 0,   G = 0,   B = 255, A = 1.0 },
                        { R = 177, G = 5,   B = 245, A = 1.0 },
                        { R = 251, G = 3,   B = 255, A = 1.0 },
                        { R = 2,   G = 238, B = 250, A = 1.0 },
                        { R = 252, G = 248, B = 0,   A = 1.0 },
                        { R = 245, G = 245, B = 245, A = 1.0 }
                    },
                    secondPtfxPlacement = {
                        0.0,
                        0.0,
                        0.0,
                        0.0,
                        0.0,
                        0.0,
                        1.0
                    },
                    ptfxWait = 200,
                    ptfxCanHold = true
                }
            },
            ["pfireworksm"] = {
                "pazeee@fireworksm@animations",
                "pazeee@fireworksm@clip",
                "Fireworks 2 Stick Shoulder Back",
                animationOptions = {
                    emoteLoop = true,
                    emoteMoving = true,
                    prop = 'pazeeefireworks',
                    propBone = 57005,
                    propPlacement = {
                        0.1200, 0.160, 0.01,
                        -77.6938, 2.748, -12.7111
                    },
                    ptfxAsset = "scr_indep_fireworks",
                    ptfxName = "scr_indep_firework_starburst",
                    ptfxColor = {
                        { R = 255, G = 0,   B = 0,   A = 1.0 },
                        { R = 0,   G = 255, B = 0,   A = 1.0 },
                        { R = 0,   G = 0,   B = 255, A = 1.0 },
                        { R = 177, G = 5,   B = 245, A = 1.0 },
                        { R = 251, G = 3,   B = 255, A = 1.0 },
                        { R = 2,   G = 238, B = 250, A = 1.0 },
                        { R = 252, G = 248, B = 0,   A = 1.0 },
                        { R = 245, G = 245, B = 245, A = 1.0 }
                    },
                    ptfxPlacement = {
                        0.0,
                        0.0,
                        0.0,
                        0.0,
                        0.0,
                        0.0,
                        1.0
                    },
                    secondProp = 'pazeeefireworks',
                    secondPropBone = 18905,
                    secondPropPlacement = {
                        0.1300, 0.160, 0.0,
                        -98.2076, -1.84, -12.871
                    },
                    secondPtfxAsset = "scr_indep_fireworks",
                    secondPtfxName = "scr_indep_firework_starburst",
                    secondPtfxColor = {
                        { R = 255, G = 0,   B = 0,   A = 1.0 },
                        { R = 0,   G = 255, B = 0,   A = 1.0 },
                        { R = 0,   G = 0,   B = 255, A = 1.0 },
                        { R = 177, G = 5,   B = 245, A = 1.0 },
                        { R = 251, G = 3,   B = 255, A = 1.0 },
                        { R = 2,   G = 238, B = 250, A = 1.0 },
                        { R = 252, G = 248, B = 0,   A = 1.0 },
                        { R = 245, G = 245, B = 245, A = 1.0 }
                    },
                    secondPtfxPlacement = {
                        0.0,
                        0.0,
                        0.0,
                        0.0,
                        0.0,
                        0.0,
                        1.0
                    },
                    ptfxWait = 200,
                    ptfxCanHold = true
                }
            },
            ["pfireworksn"] = {
                "pazeee@fireworksn@animations",
                "pazeee@fireworksn@clip",
                "Fireworks 2 Stick With Style",
                animationOptions = {
                    emoteLoop = true,
                    prop = 'pazeeefireworks',
                    propBone = 57005,
                    propPlacement = {
                        0.1200, 0.160, 0.01,
                        -77.6938, 2.748, -12.7111
                    },
                    ptfxAsset = "scr_indep_fireworks",
                    ptfxName = "scr_indep_firework_starburst",
                    ptfxColor = {
                        { R = 255, G = 0,   B = 0,   A = 1.0 },
                        { R = 0,   G = 255, B = 0,   A = 1.0 },
                        { R = 0,   G = 0,   B = 255, A = 1.0 },
                        { R = 177, G = 5,   B = 245, A = 1.0 },
                        { R = 251, G = 3,   B = 255, A = 1.0 },
                        { R = 2,   G = 238, B = 250, A = 1.0 },
                        { R = 252, G = 248, B = 0,   A = 1.0 },
                        { R = 245, G = 245, B = 245, A = 1.0 }
                    },
                    ptfxPlacement = {
                        0.0,
                        0.0,
                        0.0,
                        0.0,
                        0.0,
                        0.0,
                        1.0
                    },
                    secondProp = 'pazeeefireworks',
                    secondPropBone = 18905,
                    secondPropPlacement = {
                        0.1300, 0.160, 0.0,
                        -98.2076, -1.84, -12.871
                    },
                    secondPtfxAsset = "scr_indep_fireworks",
                    secondPtfxName = "scr_indep_firework_starburst",
                    secondPtfxColor = {
                        { R = 255, G = 0,   B = 0,   A = 1.0 },
                        { R = 0,   G = 255, B = 0,   A = 1.0 },
                        { R = 0,   G = 0,   B = 255, A = 1.0 },
                        { R = 177, G = 5,   B = 245, A = 1.0 },
                        { R = 251, G = 3,   B = 255, A = 1.0 },
                        { R = 2,   G = 238, B = 250, A = 1.0 },
                        { R = 252, G = 248, B = 0,   A = 1.0 },
                        { R = 245, G = 245, B = 245, A = 1.0 }
                    },
                    secondPtfxPlacement = {
                        0.0,
                        0.0,
                        0.0,
                        0.0,
                        0.0,
                        0.0,
                        1.0
                    },
                    ptfxWait = 200,
                    ptfxCanHold = true
                }
            },
            ["pfireworkso"] = {
                "pazeee@fireworkso@animations",
                "pazeee@fireworkso@clip",
                "Fireworks 2 Stick Happy Dance",
                animationOptions = {
                    emoteLoop = true,
                    prop = 'pazeeefireworks',
                    propBone = 18905,
                    propPlacement = {
                        0.1300, 0.160, 0.0,
                        -98.2076, -1.84, -12.871
                    },
                    ptfxAsset = "scr_indep_fireworks",
                    ptfxName = "scr_indep_firework_starburst",
                    ptfxColor = {
                        { R = 255, G = 0,   B = 0,   A = 1.0 },
                        { R = 0,   G = 255, B = 0,   A = 1.0 },
                        { R = 0,   G = 0,   B = 255, A = 1.0 },
                        { R = 177, G = 5,   B = 245, A = 1.0 },
                        { R = 251, G = 3,   B = 255, A = 1.0 },
                        { R = 2,   G = 238, B = 250, A = 1.0 },
                        { R = 252, G = 248, B = 0,   A = 1.0 },
                        { R = 245, G = 245, B = 245, A = 1.0 }
                    },
                    ptfxPlacement = {
                        0.0,
                        0.0,
                        0.0,
                        0.0,
                        0.0,
                        0.0,
                        1.0
                    },
                    secondProp = 'pazeeefireworks',
                    secondPropBone = 57005,
                    secondPropPlacement = {
                        0.1200, 0.160, 0.01,
                        -77.6938, 2.748, -12.7111
                    },
                    ptfxWait = 200,
                    ptfxCanHold = true
                }
            },
            ["pfireworksp"] = {
                "pazeee@fireworksp@animations",
                "pazeee@fireworksp@clip",
                "Fireworks Box Front 1",
                animationOptions = {
                    emoteLoop = true,
                    emoteMoving = true,
                    prop = 'ind_prop_firework_03',
                    propBone = 57005,
                    propPlacement = {
                        0.14, 0.04, -0.07,
                        -90.0, -123.999, -6.999
                    },
                    ptfxAsset = "scr_indep_fireworks",
                    ptfxName = "scr_indep_firework_fountain",
                    ptfxColor = {
                        { R = 255, G = 0,   B = 0,   A = 1.0 },
                        { R = 0,   G = 255, B = 0,   A = 1.0 },
                        { R = 0,   G = 0,   B = 255, A = 1.0 },
                        { R = 177, G = 5,   B = 245, A = 1.0 },
                        { R = 251, G = 3,   B = 255, A = 1.0 },
                        { R = 2,   G = 238, B = 250, A = 1.0 },
                        { R = 252, G = 248, B = 0,   A = 1.0 },
                        { R = 245, G = 245, B = 245, A = 1.0 }
                    },
                    ptfxPlacement = {
                        0.0,
                        0.0,
                        0.0,
                        0.0,
                        0.0,
                        0.0,
                        0.25
                    },
                    ptfxWait = 200,
                    ptfxCanHold = true
                }
            },
            ["pfireworksq"] = {
                "pazeee@fireworksq@animations",
                "pazeee@fireworksq@clip",
                "Fireworks Box Front 2",
                animationOptions = {
                    emoteLoop = true,
                    emoteMoving = true,
                    prop = 'ind_prop_firework_03',
                    propBone = 57005,
                    propPlacement = {
                        0.14, 0.04, -0.07,
                        -90.0, -123.999, -6.999
                    },
                    ptfxAsset = "scr_indep_fireworks",
                    ptfxName = "scr_indep_firework_fountain",
                    ptfxColor = {
                        { R = 255, G = 0,   B = 0,   A = 1.0 },
                        { R = 0,   G = 255, B = 0,   A = 1.0 },
                        { R = 0,   G = 0,   B = 255, A = 1.0 },
                        { R = 177, G = 5,   B = 245, A = 1.0 },
                        { R = 251, G = 3,   B = 255, A = 1.0 },
                        { R = 2,   G = 238, B = 250, A = 1.0 },
                        { R = 252, G = 248, B = 0,   A = 1.0 },
                        { R = 245, G = 245, B = 245, A = 1.0 }
                    },
                    ptfxPlacement = {
                        0.0,
                        0.0,
                        0.0,
                        0.0,
                        0.0,
                        0.0,
                        0.25
                    },
                    ptfxWait = 200,
                    ptfxCanHold = true
                }
            },
            ["pfireworksr"] = {
                "pazeee@fireworksr@animations",
                "pazeee@fireworksr@clip",
                "Fireworks Box High",
                animationOptions = {
                    emoteLoop = true,
                    emoteMoving = true,
                    prop = 'ind_prop_firework_03',
                    propBone = 57005,
                    propPlacement = {
                        0.14, 0.04, -0.07,
                        -90.0, -123.999, -6.999
                    },
                    ptfxAsset = "scr_indep_fireworks",
                    ptfxName = "scr_indep_firework_fountain",
                    ptfxColor = {
                        { R = 255, G = 0,   B = 0,   A = 1.0 },
                        { R = 0,   G = 255, B = 0,   A = 1.0 },
                        { R = 0,   G = 0,   B = 255, A = 1.0 },
                        { R = 177, G = 5,   B = 245, A = 1.0 },
                        { R = 251, G = 3,   B = 255, A = 1.0 },
                        { R = 2,   G = 238, B = 250, A = 1.0 },
                        { R = 252, G = 248, B = 0,   A = 1.0 },
                        { R = 245, G = 245, B = 245, A = 1.0 }
                    },
                    ptfxPlacement = {
                        0.0,
                        0.0,
                        0.0,
                        0.0,
                        0.0,
                        0.0,
                        0.25
                    },
                    ptfxWait = 200,
                    ptfxCanHold = true
                }
            },
            ["pfireworkss"] = {
                "pazeee@fireworkss@animations",
                "pazeee@fireworkss@clip",
                "Fireworks Box Sit Enjoy",
                animationOptions = {
                    emoteLoop = true,
                    prop = 'ind_prop_firework_03',
                    propBone = 52301,
                    propPlacement = {
                        1.0, 0.09, -0.08,
                        -104.074, 1.456, 5.821
                    },
                    ptfxAsset = "scr_indep_fireworks",
                    ptfxName = "scr_indep_firework_fountain",
                    ptfxColor = {
                        { R = 255, G = 0,   B = 0,   A = 1.0 },
                        { R = 0,   G = 255, B = 0,   A = 1.0 },
                        { R = 0,   G = 0,   B = 255, A = 1.0 },
                        { R = 177, G = 5,   B = 245, A = 1.0 },
                        { R = 251, G = 3,   B = 255, A = 1.0 },
                        { R = 2,   G = 238, B = 250, A = 1.0 },
                        { R = 252, G = 248, B = 0,   A = 1.0 },
                        { R = 245, G = 245, B = 245, A = 1.0 }
                    },
                    ptfxPlacement = {
                        0.0,
                        0.0,
                        0.0,
                        0.0,
                        0.0,
                        0.0,
                        0.25
                    },
                    ptfxWait = 200,
                    ptfxCanHold = true
                }
            },
            ["pfireworkst"] = {
                "pazeee@fireworkst@animations",
                "pazeee@fireworkst@clip",
                "Fireworks To The Moon",
                animationOptions = {
                    Flag = 1024,
                    prop = 'ind_prop_firework_01',
                    propBone = 24818,
                    propPlacement = {
                        0.100, -0.150, 0.1,
                        -5.0, 90.0, 0.0
                    },
                    secondProp = 'ind_prop_firework_01',
                    secondPropBone = 24818,
                    secondPropPlacement = {
                        0.100, -0.150, -0.1,
                        -5.0, 90.0, 0.0
                    },
                    ptfxNoprop = true,
                    ptfxAsset = "scr_indep_fireworks",
                    ptfxName = "scr_indep_firework_fountain",
                    ptfxColor = {
                        { R = 255, G = 0,   B = 0,   A = 1.0 },
                        { R = 0,   G = 255, B = 0,   A = 1.0 },
                        { R = 0,   G = 0,   B = 255, A = 1.0 },
                        { R = 177, G = 5,   B = 245, A = 1.0 },
                        { R = 251, G = 3,   B = 255, A = 1.0 },
                        { R = 2,   G = 238, B = 250, A = 1.0 },
                        { R = 252, G = 248, B = 0,   A = 1.0 },
                        { R = 245, G = 245, B = 245, A = 1.0 }
                    },
                    ptfxBone = 24818,
                    ptfxPlacement = {
                        0.1,
                        -0.15,
                        0.0,
                        -5.0,
                        -90.0,
                        0.0,
                        0.5
                    },
                    ptfxWait = 200
                }
            },
            ["pfireworksy"] = {
                "pazeee@fireworksy@animations",
                "pazeee@fireworksy@clip",
                "Fireworks Ground Little",
                animationOptions = {
                    prop = 'p_cs_lighter_01',
                    propBone = 57005,
                    propPlacement = {
                        0.100, 0.02, -0.02,
                        -116.589, -156.6768, 14.663
                    },
                    ptfxAsset = "core",
                    ptfxName = "exp_grd_train",
                    ptfxColor = {
                        { R = 255, G = 0,   B = 0,   A = 1.0 },
                        { R = 0,   G = 255, B = 0,   A = 1.0 },
                        { R = 0,   G = 0,   B = 255, A = 1.0 },
                        { R = 177, G = 5,   B = 245, A = 1.0 },
                        { R = 251, G = 3,   B = 255, A = 1.0 },
                        { R = 2,   G = 238, B = 250, A = 1.0 },
                        { R = 252, G = 248, B = 0,   A = 1.0 },
                        { R = 245, G = 245, B = 245, A = 1.0 }
                    },
                    ptfxWait = 1000,
                    ptfxPlacement = {
                        0.0,
                        0.0,
                        0.055,
                        0.0,
                        0.0,
                        0.0,
                        0.25
                    },
                    secondProp = 'ind_prop_firework_04',
                    secondPropBone = 52301,
                    secondPropPlacement = {
                        0.64, 0.14, -0.18,
                        -90.0, 0.0, 20.0
                    }
                }
            }
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
