Citizen.CreateThread(function()
    if not Config.Creators['Pazeee_SnowEmotePackV2'] then return end

    local Animations = {
        Dances = {},
        Emotes = {
            ["psnowa"] = {
                "pazeee@snowa@animations",
                "pazeee@snowa@clip",
                "Snow Slide Slow & Enjoy",
                animationOptions = {
                    customMovementType = 34
                }
            },
            ["psnowb"] = {
                "pazeee@snowb@animations",
                "pazeee@snowb@clip",
                "Snow Slide Chill Facing Right",
                animationOptions = {
                    customMovementType = 4194337
                }
            },
            ["psnowc"] = {
                "pazeee@snowc@animations",
                "pazeee@snowc@clip",
                "Snow Slide Chill Facing Left",
                animationOptions = {
                    customMovementType = 4194337
                }
            },
            ["psnowd"] = {
                "pazeee@snowd@animations",
                "pazeee@snowd@clip",
                "Snow Slide Look Sky",
                animationOptions = {
                    customMovementType = 4194337
                }
            },
            ["psnowe"] = {
                "pazeee@snowe@animations",
                "pazeee@snowe@clip",
                "Snow Slide Superman",
                animationOptions = {
                    customMovementType = 4194337
                }
            },
            ["psnowp"] = {
                "pazeee@snowp@animations",
                "pazeee@snowp@clip",
                "Snow Slide Panic",
                animationOptions = {
                    customMovementType = 4194337
                }
            },
            ["psnowq"] = {
                "pazeee@snowq@animations",
                "pazeee@snowq@clip",
                "Snow Slide Scared",
                animationOptions = {
                    customMovementType = 33
                }
            },
            ["psnowr"] = {
                "pazeee@snowr@animations",
                "pazeee@snowr@clip",
                "Snow Head Stuck",
                animationOptions = {
                    emoteLoop = true
                }
            },
            ["psnows"] = {
                "pazeee@snows@animations",
                "pazeee@snows@clip",
                "Snow Body Stuck Female",
                animationOptions = {
                    emoteLoop = true
                }
            },
            ["psnows1"] = {
                "pazeee@snows1@animations",
                "pazeee@snows1@clip",
                "Snow Body Stuck Male",
                animationOptions = {
                    emoteLoop = true
                }
            },
            ["psnowt"] = {
                "pazeee@snowt@animations",
                "pazeee@snowt@clip",
                "Snow Foot Stuck Female",
                animationOptions = {
                    emoteLoop = true
                }
            },
            ["psnowt1"] = {
                "pazeee@snowt1@animations",
                "pazeee@snowt1@clip",
                "Snow Foot Stuck Male",
                animationOptions = {
                    emoteLoop = true
                }
            },
            ["psnowu"] = {
                "pazeee@snowu@animations",
                "pazeee@snowu@clip",
                "Snow Help Pull Stuck",
                animationOptions = {
                    emoteLoop = true
                }
            },
            ["psnowv"] = {
                "pazeee@snowv@animations",
                "pazeee@snowv@clip",
                "Snow Happy Splash Right",
                animationOptions = {
                    emoteLoop = true
                }
            },
            ["psnoww"] = {
                "pazeee@snoww@animations",
                "pazeee@snoww@clip",
                "Snow Happy Splash Front",
                animationOptions = {
                    emoteLoop = true
                }
            },
            ["psnowx"] = {
                "pazeee@snowx@animations",
                "pazeee@snowx@clip",
                "Snow Happy Splash Back",
                animationOptions = {
                    emoteLoop = true
                }
            },
            ["psnowy"] = {
                "pazeee@snowy@animations",
                "pazeee@snowy@clip",
                "Snow Lay Stars 1",
                animationOptions = {
                    emoteLoop = true
                }
            },
            ["psnowz"] = {
                "pazeee@snowz@animations",
                "pazeee@snowz@clip",
                "Snow Lay Stars 2",
                animationOptions = {
                    emoteLoop = true
                }
            },
            ["psnowza"] = {
                "pazeee@snowza@animations",
                "pazeee@snowza@clip",
                "Snow Lay Stars 3",
                animationOptions = {
                    emoteLoop = true
                }
            },
            ["psnowzb"] = {
                "pazeee@snowzb@animations",
                "pazeee@snowzb@clip",
                "Snow Lay Stars 4",
                animationOptions = {
                    emoteLoop = true
                }
            },
            ["psnowzc"] = {
                "pazeee@snowzc@animations",
                "pazeee@snowzc@clip",
                "Snow Warming Campfire Stand",
                animationOptions = {
                    emoteLoop = true,
                    emoteMoving = true
                }
            },
            ["psnowze"] = {
                "pazeee@snowze@animations",
                "pazeee@snowze@clip",
                "Snow Warming Campfire Sit 2",
                animationOptions = {
                    emoteLoop = true
                }
            },
            ["psnowzf"] = {
                "pazeee@snowzf@animations",
                "pazeee@snowzf@clip",
                "Snow Warming Campfire Crouch",
                animationOptions = {
                    emoteLoop = true
                }
            },
            ["psnowzg"] = {
                "pazeee@snowzg@animations",
                "pazeee@snowzg@clip",
                "Snow Warming Campfire Kneel",
                animationOptions = {
                    emoteLoop = true
                }
            },
            ["psnowzi"] = {
                "pazeee@snowzi@animations",
                "pazeee@snowzi@clip",
                "Snow Warming Campfire Sit Down 2",
                animationOptions = {
                    emoteLoop = true
                }
            },
            ["psnowzl"] = {
                "pazeee@snowzl@animations",
                "pazeee@snowzl@clip",
                "Snow Cover Face 1",
                animationOptions = {
                    emoteLoop = true,
                    emoteMoving = true
                }
            },
            ["psnowzm"] = {
                "pazeee@snowzm@animations",
                "pazeee@snowzm@clip",
                "Snow Cover Face 2",
                animationOptions = {
                    emoteLoop = true,
                    emoteMoving = true
                }
            },
            ["psnowzn"] = {
                "pazeee@snowzn@animations",
                "pazeee@snowzn@clip",
                "Snow Freezing Move",
                animationOptions = {
                    emoteLoop = true,
                    emoteMoving = true
                }
            },
            ["psnowzo"] = {
                "pazeee@snowzo@animations",
                "pazeee@snowzo@clip",
                "Snow Freezing Idle",
                animationOptions = {
                    emoteLoop = true
                }
            },
            ["psnowzp"] = {
                "pazeee@snowzp@animations",
                "pazeee@snowzp@clip",
                "Snow Freezing Hope",
                animationOptions = {
                    customMovementType = 2
                }
            },
            ["psnowzq"] = {
                "pazeee@snowzq@animations",
                "pazeee@snowzq@clip",
                "Snow Freezing Cool",
                animationOptions = {
                    customMovementType = 2
                }
            },
            ["psnowzr"] = {
                "pazeee@snowzr@animations",
                "pazeee@snowzr@clip",
                "Snow Freezing Cute",
                animationOptions = {
                    customMovementType = 2
                }
            },
            ["psnowzs"] = {
                "pazeee@snowzs@animations",
                "pazeee@snowzs@clip",
                "Snow Freezing Handsome",
                animationOptions = {
                    customMovementType = 2
                }
            },
            ["psnowzt"] = {
                "pazeee@snowzt@animations",
                "pazeee@snowzt@clip",
                "Snow Pushed Low Wind",
                animationOptions = {
                    emoteLoop = true
                }
            },
            ["psnowzu"] = {
                "pazeee@snowzu@animations",
                "pazeee@snowzu@clip",
                "Snow Pushed Heavy Wind",
                animationOptions = {
                    emoteLoop = true
                }
            },
            ["psnowzv"] = {
                "pazeee@snowzv@animations",
                "pazeee@snowzv@clip",
                "Snow Pushed Snowstorm",
                animationOptions = {
                    emoteLoop = true
                }
            },
            ["psnowzw"] = {
                "pazeee@snowzw@animations",
                "pazeee@snowzw@clip",
                "Snow Enjoying Snowfall 1",
                animationOptions = {
                    emoteLoop = true,
                    emoteMoving = true
                }
            },
            ["psnowzx"] = {
                "pazeee@snowzx@animations",
                "pazeee@snowzx@clip",
                "Snow Enjoying Snowfall 2",
                animationOptions = {
                    emoteLoop = true,
                    emoteMoving = true
                }
            },
            ["psnowzy"] = {
                "pazeee@snowzy@animations",
                "pazeee@snowzy@clip",
                "Snow Enjoying Snowfall 3",
                animationOptions = {
                    emoteLoop = true,
                    emoteMoving = true
                }
            },
            ["psnowzz"] = {
                "pazeee@snowzz@animations",
                "pazeee@snowzz@clip",
                "Snow Stuck Flip",
                animationOptions = {
                    emoteLoop = true
                }
            },
            ["psnowzza"] = {
                "pazeee@snowzza@animations",
                "pazeee@snowzza@clip",
                "Snow Stuck Frozen Stiff",
                animationOptions = {
                    emoteLoop = true
                }
            },
            ["psnowh"] = {
                "pazeee@snowh@animations",
                "pazeee@snowh@clip",
                "Snow Slide Box Alone",
                animationOptions = {
                    prop = "prop_skid_box_04",
                    propBone = 0,
                    propPlacement = {
                        0.0050, 0.250, -0.20,
                        -166.999, 180.0, 0.0,
                    },
                    customMovementType = 33
                }
            },
            ["psnowk"] = {
                "pazeee@snowk@animations",
                "pazeee@snowk@clip",
                "Snow Slide Surf Board",
                animationOptions = {
                    prop = "prop_surf_board_ldn_01",
                    propBone = 0,
                    propPlacement = {
                        -0.090, 0.620, -0.140,
                        -88.171, -3.786, 6.940,
                    },
                    customMovementType = 33
                }
            },
            ["psnown"] = {
                "pazeee@snown@animations",
                "pazeee@snown@clip",
                "Snow Slide Swim Ring",
                animationOptions = {
                    prop = "prop_beach_ring_01",
                    propBone = 0,
                    propPlacement = {
                        0.0, 0.0, -0.110,
                        -41.786, -5.213, 4.677,
                    },
                    customMovementType = 33
                }
            },
            ["psnowo"] = {
                "pazeee@snowo@animations",
                "pazeee@snowo@clip",
                "Snow Ice Skating",
                animationOptions = {
                    prop = "a3d_pole",
                    propBone = 18905,
                    propPlacement = {
                        -0.04, -0.620, 0.390,
                        -120.381, -5.038, -8.649,
                    },
                    secondProp = 'a3d_pole',
                    secondPropBone = 57005,
                    secondPropPlacement = {
                        -0.050, -0.720, -0.280,
                        -69.716, 3.4511, -9.391,
                    },
                    customMovementType = 4194337
                }
            },
            ["psnowzd"] = {
                "pazeee@snowzd@animations",
                "pazeee@snowzd@clip",
                "Snow Warming Campfire Sit 1 Log",
                animationOptions = {
                    prop = "prop_tree_log_01",
                    propBone = 0,
                    propPlacement = {
                        -0.80, -0.110, -0.70,
                        0.0, 2.0, 0.0,
                    },
                    emoteLoop = true
                }
            },
            ["psnowzh"] = {
                "pazeee@snowzh@animations",
                "pazeee@snowzh@clip",
                "Snow Warming Campfire Sit Down 1",
                animationOptions = {
                    prop = "prop_beach_fire",
                    propBone = 0,
                    propPlacement = {
                        0.0, 1.30, -0.20,
                        0.0, 0.0, 0.0,
                    },
                    emoteLoop = true
                }
            },
        },
        Shared = {
            ["psnowf"] = {
                "pazeee@snowf@animations",
                "pazeee@snowf@clip",
                "Snow Slide Driver",
                "psnowg",
                animationOptions = {
                    customMovementType = 33
                }
            },
            ["psnowg"] = {
                "pazeee@snowg@animations",
                "pazeee@snowg@clip",
                "Snow Slide Passenger",
                "psnowf",
                animationOptions = {
                    emoteLoop = true,
                    attachTo = true,
                    bone = 11816,
                    xPos = 0.00,
                    yPos = -0.3000,
                    zPos = -0.0500,
                    xRot = 0.000,
                    yRot = 0.000,
                    zRot = -10.000
                }
            },
            ["psnowi"] = {
                "pazeee@snowi@animations",
                "pazeee@snowi@clip",
                "Snow Slide Box Together Front",
                "psnowj",
                animationOptions = {
                    prop = "prop_skid_box_04",
                    propBone = 0,
                    propPlacement = {
                        0.04, -0.190, -0.370,
                        -7.000, 0.000, 3.000
                    },
                    customMovementType = 33
                }
            },
            ["psnowj"] = {
                "pazeee@snowj@animations",
                "pazeee@snowj@clip",
                "Snow Slide Box Together Back",
                "psnowi",
                animationOptions = {
                    emoteLoop = true,
                    attachTo = true,
                    bone = 11816,
                    xPos = 0.200,
                    yPos = -0.6000,
                    zPos = 0.000,
                    xRot = 0.000,
                    yRot = 0.000,
                    zRot = -10.000
                }
            },
            ["psnowl"] = {
                "pazeee@snowl@animations",
                "pazeee@snowl@clip",
                "Snow Slide Friends Surf 1",
                "psnowm",
                animationOptions = {
                    customMovementType = 33
                }
            },
            ["psnowm"] = {
                "pazeee@snowm@animations",
                "pazeee@snowm@clip",
                "Snow Slide Friends Surf 2",
                "psnowl",
                animationOptions = {
                    emoteLoop = true,
                    attachTo = true,
                    bone = 11816,
                    xPos = 0.00,
                    yPos = -0.8000,
                    zPos = 0.000,
                    xRot = 0.000,
                    yRot = 0.000,
                    zRot = 90.000
                }
            },
            ["psnowzj"] = {
                "pazeee@snowzj@animations",
                "pazeee@snowzj@clip",
                "Snow Burn Your Friends 1",
                "psnowzk",
                animationOptions = {
                    prop = "a3d_pole",
                    propBone = 24818,
                    propPlacement = {
                        -0.14, 0.40, -0.010,
                        -90.000, 0.000, -60.000
                    },
                    emoteMoving = true
                }
            },
            ["psnowzk"] = {
                "pazeee@snowzk@animations",
                "pazeee@snowzk@clip",
                "Snow Burn Your Friends 2",
                "psnowzj",
                animationOptions = {
                    emoteLoop = true,
                    attachTo = true,
                    bone = 24818,
                    xPos = 0.4400,
                    yPos = 1.27000,
                    zPos = -0.0400,
                    xRot = 0.000,
                    yRot = 0.000,
                    zRot = 10.000
                }
            },
        },
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
