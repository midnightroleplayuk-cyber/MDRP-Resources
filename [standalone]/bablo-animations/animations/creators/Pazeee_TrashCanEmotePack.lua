Citizen.CreateThread(function()
    if not Config.Creators['Pazeee_TrashCanEmotePack'] then return end
    
    local Animations = {
        Dances = {},

        Emotes = {
            ["ptrashcana"] = {
                "ptrashcana@animations",
                "ptrashcanaclip",
                "Trash Can Hide A Loop",
                animationOptions = {
                    prop = "prop_recyclebin_03_a",
                    propBone = 52301,
                    propPlacement = {
                        0.08,
                        -0.0900,
                    -0.10,
                        -90,
                        0,
                        20.000,
                    },
                    emoteLoop = true
                }
            },
            ["ptrashcanb"] = {
                "ptrashcanb@animations",
                "ptrashcanbclip",
                "Trash Can Hide A Look & Peek",
                animationOptions = {
                    prop = "prop_recyclebin_03_a",
                    propBone = 52301,
                    propPlacement = {
                        0.06,
                        -0.1170,
                    -0.090,
                        -90,
                        0,
                        18.00,
                    },
                    emoteLoop = true
                }
            },
            ["ptrashcanc"] = {
                "ptrashcanc@animations",
                "ptrashcancclip",
                "Trash Can Hide A Peek",
                animationOptions = {
                    prop = "prop_recyclebin_03_a",
                    propBone = 52301,
                    propPlacement = {
                        0.08,
                        -0.0900,
                    -0.10,
                        -90,
                        0,
                        20.000,
                    },
                    emoteLoop = true
                }
            },
            ["ptrashcand"] = {
                "ptrashcand@animations",
                "ptrashcandclip",
                "Trash Can Stuck Struggle",
                animationOptions = {
                    prop = "prop_recyclebin_03_a",
                    propBone = 0,
                    propPlacement = {
                        -0.02,
                        -0.5900,
                    0.030,
                        -88.000,
                        0,
                        0,
                    },
                    emoteLoop = true
                }
            },
            ["ptrashcane"] = {
                "ptrashcane@animations",
                "ptrashcaneclip",
                "Trash Can Stuck Upside Down",
                animationOptions = {
                    prop = "prop_recyclebin_03_a",
                    propBone = 39317,
                    propPlacement = {
                        0,
                        -0.100,
                    0.0,
                        -90.000,
                        0,
                        -20,
                    },
                    emoteLoop = true
                }
            },
            ["ptrashcanf"] = {
                "ptrashcanf@animations",
                "ptrashcanfclip",
                "Trash Can Stuck Flip",
                animationOptions = {
                    prop = "prop_recyclebin_03_a",
                    propBone = 18905,
                    propPlacement = {
                        0.15,
                        0.100,
                        0.050,
                        -9.400,
                        -160.280,
                        -3.40,
                    },
                    emoteLoop = true
                }
            },
            ["ptrashcang"] = {
                "ptrashcang@animations",
                "ptrashcangclip",
                "Trash Can Full Stuck Upside Down",
                animationOptions = {
                    prop = "prop_recyclebin_03_a",
                    propBone = 18905,
                    propPlacement = {
                        0.13,
                        0.1100,
                        0.050,
                        -9.51,
                        -162.25,
                        -3.0,
                    },
                    emoteLoop = true
                }
            },
            ["ptrashcanh"] = {
                "ptrashcanh@animations",
                "ptrashcanhclip",
                "Trash Can Hide B Loop",
                animationOptions = {
                    prop = "prop_recyclebin_03_a",
                    propBone = 0,
                    propPlacement = {
                        0.0,
                        0.100,
                        0.725,
                        0.000,
                        180,
                        0,
                    },
                    emoteLoop = true
                    
                }
            },
            ["ptrashcani"] = {
                "ptrashcani@animations",
                "ptrashcaniclip",
                "Trash Can Hide B Sneaky",
                animationOptions = {
                    prop = "prop_recyclebin_03_a",
                    propBone = 0,
                    propPlacement = {
                        0.0,
                        0.100,
                        0.80,
                        0.000,
                        180,
                        0,
                    },
                    emoteLoop = true
                }
            },
            ["ptrashcanj"] = {
                "ptrashcanj@animations",
                "ptrashcanjclip",
                "Trash Can Hide B Walk",
                animationOptions = {
                    prop = "prop_recyclebin_03_a",
                    propBone = 0,
                    propPlacement = {
                        0.005,
                        0.125,
                        0.780,
                        0.000,
                        180,
                        0,
                    },
                    emoteLoop = true
                }
            },
            ["ptrashcank"] = {
                "ptrashcank@animations",
                "ptrashcankclip",
                "Trash Can Hide B Panic",
                animationOptions = {
                    prop = "prop_recyclebin_03_a",
                    propBone = 0,
                    propPlacement = {
                        0.005,
                        0.125,
                        0.780,
                        0.000,
                        180,
                        0,
                    },
                    emoteLoop = true
                }
            },
            ["ptrashcanl"] = {
                "ptrashcanl@animations",
                "ptrashcanlclip",
                "Trash Can Hide B Run For Your Lifeee",
                animationOptions = {
                    prop = "prop_recyclebin_03_a",
                    propBone = 24817,
                    propPlacement = {
                        0.580,
                        0.1500,
                        0,
                        10.000,
                        -90,
                        0,
                    },
                    emoteMoving = true,
                    emoteLoop = true
                    
                }
            },
            ["ptrashcanm"] = {
                "ptrashcanm@animations",
                "ptrashcanmclip",
                "Trash Can Dance Happy 1",
                animationOptions = {
                    prop = "prop_recyclebin_03_a",
                    propBone = 24817,
                    propPlacement = {
                        0.70,
                        0.175,
                        0,
                        10.000,
                        -90,
                        0,
                    },
                    emoteLoop = true
                    
                }
            },
            ["ptrashcann"] = {
                "ptrashcann@animations",
                "ptrashcannclip",
                "Trash Can Dance Happy 2",
                animationOptions = {
                    prop = "prop_recyclebin_03_a",
                    propBone = 24817,
                    propPlacement = {
                        0.70,
                        0.175,
                        0,
                        10.000,
                        -90,
                        0,
                    },
                    emoteLoop = true
                    
                }
            },
            ["ptrashcano"] = {
                "ptrashcano@animations",
                "ptrashcanoclip",
                "Trash Can Dance Happy 3",
                animationOptions = {
                    prop = "prop_recyclebin_03_a",
                    propBone = 24817,
                    propPlacement = {
                        0.70,
                        0.175,
                        0,
                        10.000,
                        -90,
                        0,
                    },
                    emoteLoop = true
                    
                }
            },
            ["ptrashcanp"] = {
                "ptrashcanp@animations",
                "ptrashcanpclip",
                "Trash Can Cool Lean",
                animationOptions = {
                    prop = "prop_recyclebin_03_a",
                    propBone = 52301,
                    propPlacement = {
                        0.08,
                        -0.0900,
                    -0.10,
                        -90,
                        0,
                        20.000,
                    },
                    emoteLoop = true
                }
            },
            ["ptrashcanq"] = {
                "ptrashcanq@animations",
                "ptrashcanqclip",
                "Trash Can Jump Slow",
                animationOptions = {
                    prop = "prop_recyclebin_03_a",
                    propBone = 52301,
                    propPlacement = {
                        0.08,
                        -0.0900,
                    -0.10,
                        -90,
                        0,
                        20.000,
                    },
                    emoteLoop = true
                }
            },
            ["ptrashcanr"] = {
                "ptrashcanr@animations",
                "ptrashcanrclip",
                "Trash Can Jump Fast",
                animationOptions = {
                    prop = "prop_recyclebin_03_a",
                    propBone = 52301,
                    propPlacement = {
                        0.08,
                        -0.0900,
                    -0.10,
                        -90,
                        0,
                        20.000,
                    },
                    emoteLoop = true
                }
            },
            ["ptrashcans"] = {
                "ptrashcans@animations",
                "ptrashcansclip",
                "Trash Can Jump Long",
                animationOptions = {
                    prop = "prop_recyclebin_03_a",
                    propBone = 52301,
                    propPlacement = {
                        0.08,
                        -0.0900,
                    -0.10,
                        -90,
                        0,
                        20.000,
                    },
                    emoteLoop = true
                }
            },
            ["ptrashcant"] = {
                "ptrashcant@animations",
                "ptrashcantclip",
                "Trash Can Turtle Stuck",
                animationOptions = {
                    prop = "prop_recyclebin_03_a",
                    propBone = 0,
                    propPlacement = {
                        0.0,
                        -0.4100,
                    -0.340,
                        -40,
                        0,
                        0.000,
                    },
                    emoteLoop = true
                }
            },
            ["ptrashcanu"] = {
                "ptrashcanu@animations",
                "ptrashcanuclip",
                "Trash Can Turtle Enjoy",
                animationOptions = {
                    prop = "prop_recyclebin_03_a",
                    propBone = 0,
                    propPlacement = {
                        0.0,
                        -0.4100,
                    -0.340,
                        -40,
                        0,
                        0.000,
                    },
                    emoteLoop = true
                }
            },
            ["ptrashcanv"] = {
                "ptrashcanv@animations",
                "ptrashcanvclip",
                "Trash Can Turtle Walk Struggle",
                animationOptions = {
                    prop = "prop_recyclebin_03_a",
                    propBone = 0,
                    propPlacement = {
                        0.0,
                        -0.470,
                    -0.390,
                        -40,
                        0,
                        0.000,
                    },
                    emoteLoop = true
                }
            },
            ["ptrashcanw"] = {
                "ptrashcanw@animations",
                "ptrashcanwclip",
                "Trash Can Turtle Walk Normal",
                animationOptions = {
                    prop = "prop_recyclebin_03_a",
                    propBone = 0,
                    propPlacement = {
                        0.0,
                        -0.400,
                    -0.440,
                        -35,
                        0,
                        0.000,
                    },
                    emoteLoop = true
                }
            },
            ["ptrashcanx"] = {
                "ptrashcanx@animations",
                "ptrashcanxclip",
                "Trash Can Turtle Walk Panic",
                animationOptions = {
                    prop = "prop_recyclebin_03_a",
                    propBone = 0,
                    propPlacement = {
                        0.0,
                        -0.400,
                    -0.440,
                        -35,
                        0,
                        0.000,
                    },
                    emoteLoop = true
                }
            },
            ["ptrashcany"] = {
                "ptrashcany@animations",
                "ptrashcanyclip",
                "Trash Can Hide C Look Around",
                animationOptions = {
                    prop = "prop_recyclebin_03_a",
                    propBone = 0,
                    propPlacement = {
                        0.0,
                        -0.0600,
                    -0.230,
                        -35,
                        0,
                        0.000,
                    },
                    emoteLoop = true
                }
            },
            ["ptrashcanz"] = {
                "ptrashcanz@animations",
                "ptrashcanzclip",
                "Trash Can Hide C Loop",
                animationOptions = {
                    prop = "prop_recyclebin_03_a",
                    propBone = 52301,
                    propPlacement = {
                        0.03,
                        -0.1300,
                        0.02,
                        -98,
                        0,
                        20.000,
                    },
                    emoteLoop = true
                }
            },
            ["ptrashcanza"] = {
                "ptrashcanza@animations",
                "ptrashcanzaclip",
                "Trash Can Spin",
                animationOptions = {
                    prop = "prop_recyclebin_03_a",
                    propBone = 52301,
                    propPlacement = {
                        0.03,
                        -0.1300,
                        0.02,
                        -98,
                        0,
                        20.000,
                    },
                    emoteLoop = true
                }
            },
            ["ptrashcanzb"] = {
                "ptrashcanzb@animations",
                "ptrashcanzbclip",
                "Trash Can Spin Fast",
                animationOptions = {
                    prop = "prop_recyclebin_03_a",
                    propBone = 52301,
                    propPlacement = {
                        0.03,
                        -0.1300,
                        0.02,
                        -98,
                        0,
                        20.000,
                    },
                    emoteLoop = true
                }
            },
            ["ptrashcanzc"] = {
                "ptrashcanzc@animations",
                "ptrashcanzcclip",
                "Trash Can Roll Slow",
                animationOptions = {
                    prop = "prop_recyclebin_03_a",
                    propBone = 0,
                    propPlacement = {
                        0.0,
                        -0.0600,
                    -0.230,
                        -35,
                        0,
                        0.000,
                    },
                    emoteLoop = true
                }
            },
            ["ptrashcanzd"] = {
                "ptrashcanzd@animations",
                "ptrashcanzdclip",
                "Trash Can Roll Fast",
                animationOptions = {
                    prop = "prop_recyclebin_03_a",
                    propBone = 0,
                    propPlacement = {
                        0.0,
                        -0.0600,
                    -0.230,
                        -35,
                        0,
                        0.000,
                    },
                    emoteLoop = true
                }
            },
            ["ptrashcanze"] = {
                "ptrashcanze@animations",
                "ptrashcanzeclip",
                "Trash Can Roll Out Of Control",
                animationOptions = {
                    prop = "prop_recyclebin_03_a",
                    propBone = 0,
                    propPlacement = {
                        0.0,
                        -0.0600,
                    -0.230,
                        -35,
                        0,
                        0.000,
                    },
                    emoteLoop = true
                }
            },
            ["ptrashcanzf"] = {
                "ptrashcanzf@animations",
                "ptrashcanzfclip",
                "Trash Can Cool Sit 1",
                animationOptions = {
                    prop = "prop_recyclebin_03_a",
                    propBone = 0,
                    propPlacement = {
                        0.0,
                        0.10,
                    -0.150,
                        164.9,
                        0,
                        0.000,
                    },
                    emoteLoop = true
                }
            },
            ["ptrashcanzg"] = {
                "ptrashcanzg@animations",
                "ptrashcanzgclip",
                "Trash Can Cool Sit 2",
                animationOptions = {
                    prop = "prop_recyclebin_03_a",
                    propBone = 0,
                    propPlacement = {
                        0.0,
                        0.10,
                    -0.150,
                        169.9,
                        0,
                        0.000,
                    },
                    emoteLoop = true
                }
            },
            ["ptrashcanzh"] = {
                "ptrashcanzh@animations",
                "ptrashcanzhclip",
                "Trash Can Impossible Pose 1",
                animationOptions = {
                    prop = "prop_recyclebin_03_a",
                    propBone = 52301,
                    propPlacement = {
                        0.120,
                        -0.980,
                        00,
                        -90,
                        0,
                        -20.000,
                    },
                    secondProp = 'prop_recyclebin_03_a',
                    secondPropBone = 64097,
                    secondPropPlacement = {
                        0.20,
                        -0.20,
                        0.000,
                    -38.255,
                    74.42,
                        12.700,
                    },
                    emoteLoop = true
                }
            },
            ["ptrashcanzi"] = {
                "ptrashcanzi@animations",
                "ptrashcanziclip",
                "Trash Can Impossible Pose 2",
                animationOptions = {
                    prop = "prop_recyclebin_03_a",
                    propBone = 14201,
                    propPlacement = {
                        0.10,
                        -0.050,
                        0.0,
                        90,
                        0,
                        20,
                    },
                    secondProp = 'prop_recyclebin_03_a',
                    secondPropBone = 31086,
                    secondPropPlacement = {
                        0.140,
                        0.10,
                        0.000,
                        -90,
                        0,
                        -40,
                    },
                    emoteLoop = true
                }
            },
            ["ptrashcanzj"] = {
                "ptrashcanzj@animations",
                "ptrashcanzjclip",
                "Trash Can Impossible Pose 3",
                animationOptions = {
                    prop = "prop_recyclebin_03_a",
                    propBone = 52301,
                    propPlacement = {
                        0.110,
                        -0.050,
                        -0.150,
                        90,
                        0,
                        20.000,
                    },
                    secondProp = 'prop_recyclebin_03_a',
                    secondPropBone = 24817,
                    secondPropPlacement = {
                        0.09,
                        -0.10,
                        0.000,
                        90,
                        0,
                        5.0,
                    },
                    emoteLoop = true
                }
            },
            ["ptrashcanzk"] = {
                "ptrashcanzk@animations",
                "ptrashcanzkclip",
                "Trash Can Carry 1",
                animationOptions = {
                    prop = "prop_bin_07d",
                    propBone = 57005,
                    propPlacement = {
                        0.090,
                        -0.640,
                        -0.37,
                        -85.076,
                        -0.867,
                        -0.037,
                    },
                    emoteMoving = true,
                    emoteLoop = true
                }
            },
            ["ptrashcanzl"] = {
                "ptrashcanzl@animations",
                "ptrashcanzlclip",
                "Trash Can Carry 2",
                animationOptions = {
                    prop = "prop_bin_07d",
                    propBone = 57005,
                    propPlacement = {
                        -0.17,
                        -0.370,
                        -0.370,
                        -79.372,
                        3.616,
                        -19.683,
                    },
                    secondProp = 'prop_bin_07d',
                    secondPropBone = 18905,
                    secondPropPlacement = {
                        -0.15,
                        -0.34,
                        0.370,
                        -100.62,
                        -3.616,
                        -19.683,
                    },
                    emoteMoving = true,
                    emoteLoop = true
                }
            },
            ["ptrashcanzm"] = {
                "ptrashcanzm@animations",
                "ptrashcanzmclip",
                "Trash Can Carry Overhead",
                animationOptions = {
                    prop = "prop_bin_07d",
                    propBone = 57005,
                    propPlacement = {
                        -0.090,
                        0.060,
                        -0.31,
                        0,
                        79.999,
                        0,
                    },
                    emoteMoving = true,
                    emoteLoop = true
                }
            },
            ["ptrashcanzn"] = {
                "ptrashcanzn@animations",
                "ptrashcanznclip",
                "Trash Can I Can't See",
                animationOptions = {
                    prop = "prop_bin_07d",
                    propBone = 24818,
                    propPlacement = {
                        1.04,
                        0.10,
                        0.0,
                        0,
                        -90,
                        -10,
                    },
                    emoteMoving = true,
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