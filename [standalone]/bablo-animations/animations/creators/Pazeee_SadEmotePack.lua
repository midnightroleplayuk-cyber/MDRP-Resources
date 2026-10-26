Citizen.CreateThread(function()
    if not Config.Creators['Pazeee_SadEmotePack'] then return end

    local Animations = {
        Emotes = {
            ["pdeada"] = {
                "pazeee@deada@animations",
                "pazeee@deada@clip",
                "Dead A Refuse To Dead",
                animationOptions = {
                }
            },
            ["pdeadb"] = {
                "pazeee@deadb@animations",
                "pazeee@deadb@clip",
                "Dead B Idle",
                animationOptions = {
                    emoteLoop = true
                }
            },
            ["pdeadc"] = {
                "pazeee@deadc@animations",
                "pazeee@deadc@clip",
                "Dead C Fly High",
                animationOptions = {
                    customMovementType = 2
                }
            },
            ["psada"] = {
                "pazeee@sada@animations",
                "pazeee@sada@clip",
                "Sad Can't Believe",
                animationOptions = {
                    emoteLoop = true
                }
            },
            ["psadb"] = {
                "pazeee@sadb@animations",
                "pazeee@sadb@clip",
                "Sad Kneel Crying",
                animationOptions = {
                    customMovementType = 2
                }
            },
            ["psadc"] = {
                "pazeee@sadc@animations",
                "pazeee@sadc@clip",
                "Sad Sit Ground Idle",
                animationOptions = {
                    emoteLoop = true
                }
            },
            ["psadd"] = {
                "pazeee@sadd@animations",
                "pazeee@sadd@clip",
                "Sad Stand Crying",
                animationOptions = {
                    emoteLoop = true
                }
            },
            ["psade"] = {
                "pazeee@sade@animations",
                "pazeee@sade@clip",
                "Sad Stand Hand Pocket A",
                animationOptions = {
                    emoteLoop = true
                }
            },
            ["psadf"] = {
                "pazeee@sadf@animations",
                "pazeee@sadf@clip",
                "Sad Stand Hand Pocket B",
                animationOptions = {
                    emoteLoop = true
                }
            },
            ["psadg"] = {
                "pazeee@sadg@animations",
                "pazeee@sadg@clip",
                "Sad Stand Crossarms",
                animationOptions = {
                    emoteLoop = true
                }
            },
            ["psadh"] = {
                "pazeee@sadh@animations",
                "pazeee@sadh@clip",
                "Sad Stand Hold Head A",
                animationOptions = {
                    emoteLoop = true
                }
            },
            ["psadi"] = {
                "pazeee@sadi@animations",
                "pazeee@sadi@clip",
                "Sad Stand Hold Head B",
                animationOptions = {
                    emoteLoop = true
                }
            },
            ["psadj"] = {
                "pazeee@sadj@animations",
                "pazeee@sadj@clip",
                "Sad Stand Cover Face A",
                animationOptions = {
                    emoteLoop = true
                }
            },
            ["psadk"] = {
                "pazeee@sadk@animations",
                "pazeee@sadk@clip",
                "Sad Stand Cover Face B",
                animationOptions = {
                    emoteLoop = true
                }
            },
            ["psadl"] = {
                "pazeee@sadl@animations",
                "pazeee@sadl@clip",
                "Sad Stand Hand On Chest A",
                animationOptions = {
                    emoteLoop = true
                }
            },
            ["psadm"] = {
                "pazeee@sadm@animations",
                "pazeee@sadm@clip",
                "Sad Stand Hand On Chest B",
                animationOptions = {
                    emoteLoop = true
                }
            },
            ["psadn"] = {
                "pazeee@sadn@animations",
                "pazeee@sadn@clip",
                "Sad Stand Hand On Chest C",
                animationOptions = {
                    emoteLoop = true
                }
            },
            ["psado"] = {
                "pazeee@sado@animations",
                "pazeee@sado@clip",
                "Sad Sit Cover Face",
                animationOptions = {
                    emoteLoop = true
                }
            },
            ["psadp"] = {
                "pazeee@sadp@animations",
                "pazeee@sadp@clip",
                "Sad Sit Depression",
                animationOptions = {
                    emoteLoop = true
                }
            },
            ["psadq"] = {
                "pazeee@sadq@animations",
                "pazeee@sadq@clip",
                "Sad Sit Ground A",
                animationOptions = {
                    emoteLoop = true
                }
            },
            ["psadr"] = {
                "pazeee@sadr@animations",
                "pazeee@sadr@clip",
                "Sad Sit Ground B",
                animationOptions = {
                    emoteLoop = true
                }
            },
            ["psads"] = {
                "pazeee@sads@animations",
                "pazeee@sads@clip",
                "Sad Sit Ground C",
                animationOptions = {
                    emoteLoop = true
                }
            },
            ["psadt"] = {
                "pazeee@sadt@animations",
                "pazeee@sadt@clip",
                "Sad Sit Ground D",
                animationOptions = {
                    emoteLoop = true
                }
            },
            ["psadu"] = {
                "pazeee@sadu@animations",
                "pazeee@sadu@clip",
                "Sad Sit Ground E",
                animationOptions = {
                    emoteLoop = true
                }
            },
            ["psadv"] = {
                "pazeee@sadv@animations",
                "pazeee@sadv@clip",
                "Sad Sit Ground F",
                animationOptions = {
                    emoteLoop = true
                }
            },
            ["psadw"] = {
                "pazeee@sadw@animations",
                "pazeee@sadw@clip",
                "Sad Kneel Strong",
                animationOptions = {
                    emoteLoop = true
                }
            },
            ["psadx"] = {
                "pazeee@sadx@animations",
                "pazeee@sadx@clip",
                "Sad Stand Praying",
                animationOptions = {
                    emoteLoop = true
                }
            },
            ["psady"] = {
                "pazeee@sady@animations",
                "pazeee@sady@clip",
                "Sad Kneel Praying",
                animationOptions = {
                    emoteLoop = true
                }
            },
            ["psadz"] = {
                "pazeee@sadz@animations",
                "pazeee@sadz@clip",
                "Sad Lying Down",
                animationOptions = {
                    emoteLoop = true
                }
            },
            ["psadza"] = {
                "pazeee@sadza@animations",
                "pazeee@sadza@clip",
                "Sad Crying So Much A",
                animationOptions = {
                    emoteLoop = true
                }
            },
            ["psadzb"] = {
                "pazeee@sadzb@animations",
                "pazeee@sadzb@clip",
                "Sad Crying So Much B",
                animationOptions = {
                    emoteLoop = true
                }
            },
            ["psadzc"] = {
                "pazeee@sadzc@animations",
                "pazeee@sadzc@clip",
                "Sad Shock A",
                animationOptions = {
                    customMovementType = 2
                }
            },
            ["psadzd"] = {
                "pazeee@sadzd@animations",
                "pazeee@sadzd@clip",
                "Sad Shock B",
                animationOptions = {
                    customMovementType = 2
                }
            },
            ["psadze"] = {
                "pazeee@sadze@animations",
                "pazeee@sadze@clip",
                "Sad Shock C",
                animationOptions = {
                    customMovementType = 2
                }
            },
            ["psadzf"] = {
                "pazeee@sadzf@animations",
                "pazeee@sadzf@clip",
                "Sad Shock D",
                animationOptions = {
                    customMovementType = 2
                }
            },
            ["psadzg"] = {
                "pazeee@sadzg@animations",
                "pazeee@sadzg@clip",
                "Sad Salute A",
                animationOptions = {
                    emoteLoop = true
                }
            },
            ["psadzh"] = {
                "pazeee@sadzh@animations",
                "pazeee@sadzh@clip",
                "Sad Salute B",
                animationOptions = {
                }
            },
            ["psadzi"] = {
                "pazeee@sadzi@animations",
                "pazeee@sadzi@clip",
                "Sad Shock I",
                animationOptions = {
                }
            },
            ["psadzj"] = {
                "pazeee@sadzj@animations",
                "pazeee@sadzj@clip",
                "Sad Shock J",
                animationOptions = {
                    customMovementType = 2
                }
            },
            ["psadzk"] = {
                "pazeee@sadzk@animations",
                "pazeee@sadzk@clip",
                "Sad Shock K",
                animationOptions = {
                    customMovementType = 2
                }
            },
            ["psadzl"] = {
                "pazeee@sadzl@animations",
                "pazeee@sadzl@clip",
                "Sad Shock L",
                animationOptions = {
                    customMovementType = 2
                }
            },
            ["psadzt"] = {
                "pazeee@sadzt@animations",
                "pazeee@sadzt@clip",
                "Sad Magic Power A",
                animationOptions = {
                    emoteLoop = true,
                    ptfxBone = 18905,
                    ptfxAsset = "scr_rcbarry1",
                    ptfxName = "scr_alien_teleport",
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
                        0.1,
                        0.0,
                        0.0,
                        0.0,
                        -80.0,
                        0.0,
                        0.06
                    },
                    ptfxWait = 200,
                    ptfxCanHold = true
                }
            },
            ["psadzu"] = {
                "pazeee@sadzu@animations",
                "pazeee@sadzu@clip",
                "Sad Magic Power B",
                animationOptions = {
                    customMovementType = 2,
                    ptfxBone = 18905,
                    ptfxAsset = "scr_rcbarry1",
                    ptfxName = "scr_alien_teleport",
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
                        0.1,
                        0.0,
                        0.0,
                        0.0,
                        -80.0,
                        0.0,
                        0.06
                    },
                    ptfxWait = 200,
                    ptfxCanHold = true
                }
            },
            ["psadzv"] = {
                "pazeee@sadzv@animations",
                "pazeee@sadzv@clip",
                "Sad Stand Hand Pocket C Move",
                animationOptions = {
                    emoteLoop = true,
                    EmoteMoving = true
                }
            },
            ["pdeadd"] = {
                "pazeee@deadd@animations",
                "pazeee@deadd@clip",
                "Dead D Box",
                animationOptions = {
                    emoteLoop = true,
                    prop = 'prop_coffin_01',
                    propBone = 0,
                    propPlacement = {
                        0.0, 0.1, -0.06,
                        -78.0, 0.0, -5.0
                    },
                    ptfxAsset = "scr_rcbarry1",
                    ptfxName = "scr_alien_teleport",
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
                        90.0,
                        0.0,
                        0.0,
                        1.5
                    },
                    ptfxWait = 200,
                    ptfxCanHold = true
                }
            },
            ["psadzm"] = {
                "pazeee@sadzm@animations",
                "pazeee@sadzm@clip",
                "Sad Stand Umbrella A",
                animationOptions = {
                    emoteLoop = true,
                    prop = 'paze_umb',
                    propBone = 57005,
                    propPlacement = {
                        0.085, 0.01, -0.02,
                        -71.233, 84.602, 16.144
                    },
                }
            },
            ["psadzn"] = {
                "pazeee@sadzn@animations",
                "pazeee@sadzn@clip",
                "Sad Stand Umbrella B",
                animationOptions = {
                    emoteLoop = true,
                    prop = 'paze_umb',
                    propBone = 57005,
                    propPlacement = {
                        0.085, 0.01, -0.02,
                        -71.233, 84.602, 16.144
                    },
                }
            },
            ["psadzo"] = {
                "pazeee@sadzo@animations",
                "pazeee@sadzo@clip",
                "Sad Stand Umbrella C",
                animationOptions = {
                    emoteLoop = true,
                    prop = 'paze_umb',
                    propBone = 57005,
                    propPlacement = {
                        0.085, 0.01, -0.02,
                        -71.233, 84.602, 16.144
                    },
                }
            },
            ["psadzp"] = {
                "pazeee@sadzp@animations",
                "pazeee@sadzp@clip",
                "Sad Stand Umbrella D",
                animationOptions = {
                    emoteLoop = true,
                    prop = 'paze_umb',
                    propBone = 57005,
                    propPlacement = {
                        0.085, 0.01, -0.02,
                        -71.233, 84.602, 16.144
                    },
                    EmoteMoving = true
                }
            },
            ["psadzq"] = {
                "pazeee@sadzq@animations",
                "pazeee@sadzq@clip",
                "Sad Stand Umbrella E",
                animationOptions = {
                    emoteLoop = true,
                    prop = 'paze_umb',
                    propBone = 57005,
                    propPlacement = {
                        0.085, 0.01, -0.02,
                        -71.233, 84.602, 16.144
                    },
                    EmoteMoving = true
                }
            },
            ["psadzzn"] = {
                "pazeee@sadzzn@animations",
                "pazeee@sadzzn@clip",
                "Sad Stand Umbrella F",
                animationOptions = {
                    emoteLoop = true,
                    prop = 'p_amb_brolly_01',
                    propBone = 57005,
                    propPlacement = {
                        0.085, 0.01, -0.02,
                        -71.233, 84.602, 16.144
                    },
                    EmoteMoving = true
                }
            },
            ["psadzr"] = {
                "pazeee@sadzr@animations",
                "pazeee@sadzr@clip",
                "Sad Kneel Umbrella A",
                animationOptions = {
                    emoteLoop = true,
                    prop = 'paze_umb',
                    propBone = 57005,
                    propPlacement = {
                        0.085, 0.01, -0.02,
                        -71.233, 84.602, 16.144
                    },
                }
            },
            ["psadzs"] = {
                "pazeee@sadzs@animations",
                "pazeee@sadzs@clip",
                "Sad Kneel Umbrella B",
                animationOptions = {
                    emoteLoop = true,
                    prop = 'paze_umb',
                    propBone = 57005,
                    propPlacement = {
                        0.085, 0.01, -0.02,
                        -74.177, 84.907, 18.329
                    },
                }
            },
            ["psadzw"] = {
                "pazeee@sadzw@animations",
                "pazeee@sadzw@clip",
                "Sad Flower A",
                animationOptions = {
                    prop = 'prop_snow_flower_02',
                    propBone = 28422,
                    propPlacement = {
                        0.03, -0.06, -0.04,
                        -39.568, -97.692, 6.408
                    },
                }
            },
            ["psadzx"] = {
                "pazeee@sadzx@animations",
                "pazeee@sadzx@clip",
                "Sad Flower B",
                animationOptions = {
                    prop = 'prop_snow_flower_02',
                    propBone = 28422,
                    propPlacement = {
                        -0.02, -0.06, -0.04,
                        -39.568, -97.692, 6.408
                    },
                }
            },
            ["psadzy"] = {
                "pazeee@sadzy@animations",
                "pazeee@sadzy@clip",
                "Sad Flower C",
                animationOptions = {
                    prop = 'prop_snow_flower_02',
                    propBone = 28422,
                    propPlacement = {
                        -0.07, -0.1, -0.04,
                        -39.568, -97.692, 6.408
                    },
                }
            },
        },
        Shared = {
            ["psadzz"] = {
                "pazeee@sadzz@animations",
                "pazeee@sadzz@clip",
                "Sad Shared A",
                "psadzza",
                animationOptions = {
                    emoteLoop = true
                }
            },
            ["psadzza"] = {
                "pazeee@sadzza@animations",
                "pazeee@sadzza@clip",
                "Sad Shared B",
                "psadzz",
                animationOptions = {
                    emoteLoop = true,
                    attachTo = true,
                    bone = 28422,
                    xPos = 0.4150,
                    yPos = -0.0150,
                    zPos = 0.9680,
                    xRot = 0.000,
                    yRot = 0.000,
                    zRot = 0.000
                }
            },
            ["psadzzb"] = {
                "pazeee@sadzzb@animations",
                "pazeee@sadzzb@clip",
                "Sad Shared C",
                "psadzzc",
                animationOptions = {
                    emoteLoop = true
                }
            },
            ["psadzzc"] = {
                "pazeee@sadzzc@animations",
                "pazeee@sadzzc@clip",
                "Sad Shared D",
                "psadzzb",
                animationOptions = {
                    emoteLoop = true,
                    attachTo = true,
                    bone = 28422,
                    xPos = 0.4500,
                    yPos = -0.010,
                    zPos = -0.030,
                    xRot = 0.000,
                    yRot = 0.000,
                    zRot = 0.000
                }
            },
            ["psadzzd"] = {
                "pazeee@sadzzd@animations",
                "pazeee@sadzzd@clip",
                "Sad Shared E",
                "psadzze",
                animationOptions = {
                    prop = 'paze_umb',
                    propBone = 18905,
                    propPlacement = {
                        0.0900, 0.0, 0.02,
                        -93.213, -88.849, 20.969
                    },
                    emoteLoop = true
                }
            },
            ["psadzze"] = {
                "pazeee@sadzze@animations",
                "pazeee@sadzze@clip",
                "Sad Shared F",
                "psadzzd",
                animationOptions = {
                    emoteLoop = true,
                    attachTo = true,
                    bone = 28422,
                    xPos = 0.450,
                    yPos = 0.000,
                    zPos = -0.03,
                    xRot = 0.000,
                    yRot = 0.000,
                    zRot = 0.000
                }
            },
            ["psadzzf"] = {
                "pazeee@sadzzf@animations",
                "pazeee@sadzzf@clip",
                "Sad Shared G",
                "psadzzg",
                animationOptions = {
                    prop = 'paze_umb',
                    propBone = 18905,
                    propPlacement = {
                        0.0900, 0.0, 0.02,
                        -93.213, -88.849, 20.969
                    },
                    emoteLoop = true
                }
            },
            ["psadzzg"] = {
                "pazeee@sadzzg@animations",
                "pazeee@sadzzg@clip",
                "Sad Shared H",
                "psadzzf",
                animationOptions = {
                    emoteLoop = true,
                    attachTo = true,
                    bone = 28422,
                    xPos = 0.480,
                    yPos = 0.000,
                    zPos = 0.000,
                    xRot = 0.000,
                    yRot = 0.000,
                    zRot = 0.000
                }
            },
            ["psadzzh"] = {
                "pazeee@sadzzh@animations",
                "pazeee@sadzzh@clip",
                "Sad Shared I",
                "psadzzi",
                animationOptions = {
                    emoteLoop = true
                }
            },
            ["psadzzi"] = {
                "pazeee@sadzzi@animations",
                "pazeee@sadzzi@clip",
                "Sad Shared J",
                "psadzzh",
                animationOptions = {
                    emoteLoop = true,
                    attachTo = true,
                    bone = 28422,
                    xPos = 0.480,
                    yPos = 0.000,
                    zPos = 0.000,
                    xRot = 0.000,
                    yRot = 0.000,
                    zRot = 0.000
                }
            },
            ["psadzzj"] = {
                "pazeee@sadzzj@animations",
                "pazeee@sadzzj@clip",
                "Sad Shared K",
                "psadzzk",
                animationOptions = {
                    emoteLoop = true
                }
            },
            ["psadzzk"] = {
                "pazeee@sadzzk@animations",
                "pazeee@sadzzk@clip",
                "Sad Shared L",
                "psadzzj",
                animationOptions = {
                    emoteLoop = true,
                    attachTo = true,
                    bone = 28422,
                    xPos = 0.480,
                    yPos = 0.000,
                    zPos = -0.010,
                    xRot = 0.000,
                    yRot = 0.000,
                    zRot = 0.000
                }
            },
            ["psadzzl"] = {
                "pazeee@sadzzl@animations",
                "pazeee@sadzzl@clip",
                "Sad Shared M",
                "psadzzm",
                animationOptions = {
                    emoteLoop = true
                }
            },
            ["psadzzm"] = {
                "pazeee@sadzzm@animations",
                "pazeee@sadzzm@clip",
                "Sad Shared N",
                "psadzzl",
                animationOptions = {
                    emoteLoop = true,
                    attachTo = true,
                    bone = 28422,
                    xPos = 0.470,
                    yPos = 0.000,
                    zPos = -0.010,
                    xRot = 0.000,
                    yRot = 0.000,
                    zRot = 0.000
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
