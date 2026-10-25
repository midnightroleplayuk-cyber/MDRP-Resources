Citizen.CreateThread(function()
    if not Config.Creators['Pazeee_FlagEmotePack'] then return end

    local Animations = {
        Dances = {},

        Emotes = {
            ["flagzw4"] = {
                "pazeee@flagzw4@animations",
                "pazeee@flagzw4@clip",
                "Flag Kneel Salute Member",
                animationOptions = {
                    emoteLoop = true
                }
            },
            ["trophycupc"] = {
                "pazeee@trophycupc@animations",
                "pazeee@trophycupc@clip",
                "Trophy Cup Team Celebration 1",
                animationOptions = {
                    emoteLoop = true
                }
            },
            ["trophycupd"] = {
                "pazeee@trophycupd@animations",
                "pazeee@trophycupd@clip",
                "Trophy Cup Team Celebration 1 Move",
                animationOptions = {
                    emoteLoop = true,
                    emoteMoving = true
                }
            },
            ["trophycupe"] = {
                "pazeee@trophycupe@animations",
                "pazeee@trophycupe@clip",
                "Trophy Cup Team Celebration 2",
                animationOptions = {
                    emoteLoop = true
                }
            },
            ["trophycupf"] = {
                "pazeee@trophycupf@animations",
                "pazeee@trophycupf@clip",
                "Trophy Cup Team Celebration 2 Move",
                animationOptions = {
                    emoteLoop = true,
                    emoteMoving = true
                }
            },
            ["trophycupg"] = {
                "pazeee@trophycupg@animations",
                "pazeee@trophycupg@clip",
                "Trophy Cup Team Celebration 3",
                animationOptions = {
                    emoteLoop = true
                }
            },
            ["trophycuph"] = {
                "pazeee@trophycuph@animations",
                "pazeee@trophycuph@clip",
                "Trophy Cup Team Celebration 4",
                animationOptions = {
                    emoteLoop = true
                }
            },
            ["trophycupn"] = {
                "pazeee@trophycupn@animations",
                "pazeee@trophycupn@clip",
                "Mexican Wave No Chair",
                animationOptions = {
                    emoteLoop = true
                }
            },
            ["flaga"] = {
                "pazeee@flaga@animations",
                "pazeee@flaga@clip",
                "Flag R Stand Still",
                animationOptions = {
                    prop = "prop_fnccorgm_02pole",
                    propBone = 57005,
                    propPlacement = {
                        0.0,
                        -0.880,
                        -0.540,
                        -59.905,
                        2.504,
                        -4.328
                    },
                    secondProp = 'prop_flag_sapd_s',
                    secondPropBone = 57005,
                    secondPropPlacement = {
                        0.150,
                        0.700,
                        0.350,
                        -59.905,
                        2.504,
                        -4.328
                    },
                    emoteLoop = true
                }
            },
            ["flagb"] = {
                "pazeee@flagb@animations",
                "pazeee@flagb@clip",
                "Flag L Stand Still",
                animationOptions = {
                    prop = "prop_fnccorgm_02pole",
                    propBone = 18905,
                    propPlacement = {
                        -0.17,
                        -0.910,
                        0.350,
                        -110.64,
                        -5.236,
                        -14.076
                    },
                    secondProp = 'prop_flag_sa_s',
                    secondPropBone = 18905,
                    secondPropPlacement = {
                        0.30,
                        0.750,
                        -0.240,
                        -110.64,
                        -5.236,
                        -14.076
                    },
                    emoteLoop = true
                }
            },
            ["flagc"] = {
                "pazeee@flagc@animations",
                "pazeee@flagc@clip",
                "Flag R Idle Lower",
                animationOptions = {
                    prop = "a3d_pole",
                    propBone = 57005,
                    propPlacement = {
                        0.03,
                        -0.140,
                        -0.070,
                        -70.00,
                        0.0,
                        -20.0
                    },
                    secondProp = 'prop_flag_lsfd_s',
                    secondPropBone = 57005,
                    secondPropPlacement = {
                        0.460,
                        1.050,
                        0.380,
                        -70.00,
                        0.0,
                        -20.0
                    },
                    emoteLoop = true,
                    emoteMoving = true
                }
            },
            ["flagd"] = {
                "pazeee@flagd@animations",
                "pazeee@flagd@clip",
                "Flag L Idle Lower",
                animationOptions = {
                    prop = "a3d_pole",
                    propBone = 18905,
                    propPlacement = {
                        0.0,
                        -0.210,
                        0.060,
                        -100.627,
                        -3.616,
                        -19.683
                    },
                    secondProp = 'prop_flag_lsservices_s',
                    secondPropBone = 18905,
                    secondPropPlacement = {
                        0.440,
                        1.020,
                        -0.140,
                        -100.627,
                        -3.616,
                        -19.683
                    },
                    emoteLoop = true,
                    emoteMoving = true
                }
            },
            ["flage"] = {
                "pazeee@flage@animations",
                "pazeee@flage@clip",
                "Flag R Idle Middle",
                animationOptions = {
                    prop = "a3d_pole",
                    propBone = 57005,
                    propPlacement = {
                        0.03,
                        -0.140,
                        -0.070,
                        -70.00,
                        0.0,
                        -20.0
                    },
                    secondProp = 'prop_flag_us_s',
                    secondPropBone = 57005,
                    secondPropPlacement = {
                        0.460,
                        1.050,
                        0.380,
                        -70.00,
                        0.0,
                        -20.0
                    },
                    emoteLoop = true,
                    emoteMoving = true
                }
            },
            ["flagf"] = {
                "pazeee@flagf@animations",
                "pazeee@flagf@clip",
                "Flag L Idle Middle",
                animationOptions = {
                    prop = "a3d_pole",
                    propBone = 18905,
                    propPlacement = {
                        0.0,
                        -0.210,
                        0.060,
                        -100.627,
                        -3.616,
                        -19.683
                    },
                    secondProp = 'prop_flag_japan_s',
                    secondPropBone = 18905,
                    secondPropPlacement = {
                        0.440,
                        1.020,
                        -0.140,
                        -100.627,
                        -3.616,
                        -19.683
                    },
                    emoteLoop = true,
                    emoteMoving = true
                }
            },
            ["flagg"] = {
                "pazeee@flagg@animations",
                "pazeee@flagg@clip",
                "Flag R Idle High",
                animationOptions = {
                    prop = "a3d_pole",
                    propBone = 57005,
                    propPlacement = {
                        0.03,
                        -0.140,
                        -0.070,
                        -70.00,
                        0.0,
                        -20.0
                    },
                    secondProp = 'prop_flag_eu_s',
                    secondPropBone = 57005,
                    secondPropPlacement = {
                        0.460,
                        1.050,
                        0.380,
                        -70.00,
                        0.0,
                        -20.0
                    },
                    emoteLoop = true,
                    emoteMoving = true
                }
            },
            ["flagh"] = {
                "pazeee@flagh@animations",
                "pazeee@flagh@clip",
                "Flag L Idle High",
                animationOptions = {
                    prop = "a3d_pole",
                    propBone = 18905,
                    propPlacement = {
                        0.0,
                        -0.210,
                        0.060,
                        -100.627,
                        -3.616,
                        -19.683
                    },
                    secondProp = 'prop_flag_german_s',
                    secondPropBone = 18905,
                    secondPropPlacement = {
                        0.440,
                        1.020,
                        -0.160,
                        -100.627,
                        -3.616,
                        -19.683
                    },
                    emoteLoop = true,
                    emoteMoving = true
                }
            },
            ["flagi"] = {
                "pazeee@flagi@animations",
                "pazeee@flagi@clip",
                "Flag R Idle On Top!",
                animationOptions = {
                    prop = "a3d_pole",
                    propBone = 57005,
                    propPlacement = {
                        0.03,
                        -0.140,
                        -0.070,
                        -70.00,
                        0.0,
                        -20.0
                    },
                    secondProp = 'prop_flag_russia_s',
                    secondPropBone = 57005,
                    secondPropPlacement = {
                        0.460,
                        1.050,
                        0.380,
                        -70.00,
                        0.0,
                        -20.0
                    },
                    emoteLoop = true,
                    emoteMoving = true
                }
            },
            ["flagj"] = {
                "pazeee@flagj@animations",
                "pazeee@flagj@clip",
                "Flag L Idle On Top!",
                animationOptions = {
                    prop = "a3d_pole",
                    propBone = 18905,
                    propPlacement = {
                        -0.05,
                        -0.210,
                        0.060,
                        -101.508,
                        -5.725,
                        -29.498
                    },
                    secondProp = 'prop_flag_france_s',
                    secondPropBone = 18905,
                    secondPropPlacement = {
                        0.630,
                        0.930,
                        -0.140,
                        -101.508,
                        -5.725,
                        -29.498
                    },
                    emoteLoop = true,
                    emoteMoving = true
                }
            },
            ["flagk"] = {
                "pazeee@flagk@animations",
                "pazeee@flagk@clip",
                "Flag R Boost Spirit!!!",
                animationOptions = {
                    prop = "a3d_pole",
                    propBone = 57005,
                    propPlacement = {
                        0.03,
                        -0.140,
                        -0.070,
                        -70.00,
                        0.0,
                        -20.0
                    },
                    secondProp = 'prop_flag_uk_s',
                    secondPropBone = 57005,
                    secondPropPlacement = {
                        0.460,
                        1.050,
                        0.380,
                        -70.00,
                        0.0,
                        -20.0
                    },
                    emoteLoop = true
                }
            },
            ["flagl"] = {
                "pazeee@flagl@animations",
                "pazeee@flagl@clip",
                "Flag L Boost Spirit!!!",
                animationOptions = {
                    prop = "a3d_pole",
                    propBone = 18905,
                    propPlacement = {
                        -0.05,
                        -0.210,
                        0.060,
                        -101.508,
                        -5.725,
                        -29.498
                    },
                    secondProp = 'prop_flag_mexico_s',
                    secondPropBone = 18905,
                    secondPropPlacement = {
                        0.630,
                        0.930,
                        -0.140,
                        -101.508,
                        -5.725,
                        -29.498
                    },
                    emoteLoop = true
                }
            },
            ["flagm"] = {
                "pazeee@flagm@animations",
                "pazeee@flagm@clip",
                "Flag R We Are Strong",
                animationOptions = {
                    prop = "a3d_pole",
                    propBone = 57005,
                    propPlacement = {
                        0.03,
                        -0.140,
                        -0.070,
                        -70.00,
                        0.0,
                        -20.0
                    },
                    secondProp = 'prop_flag_eu_s',
                    secondPropBone = 57005,
                    secondPropPlacement = {
                        0.460,
                        1.050,
                        0.380,
                        -70.00,
                        0.0,
                        -20.0
                    },
                    emoteLoop = true,
                    emoteMoving = true
                }
            },
            ["flagn"] = {
                "pazeee@flagn@animations",
                "pazeee@flagn@clip",
                "Flag L We Are Strong",
                animationOptions = {
                    prop = "a3d_pole",
                    propBone = 18905,
                    propPlacement = {
                        -0.05,
                        -0.210,
                        0.060,
                        -101.508,
                        -5.725,
                        -29.498
                    },
                    secondProp = 'prop_flag_canada_s',
                    secondPropBone = 18905,
                    secondPropPlacement = {
                        0.630,
                        0.930,
                        -0.140,
                        -101.508,
                        -5.725,
                        -29.498
                    },
                    emoteLoop = true,
                    emoteMoving = true
                }
            },
            ["flago"] = {
                "pazeee@flago@animations",
                "pazeee@flago@clip",
                "Flag Double Power",
                animationOptions = {
                    prop = "ind_prop_dlc_flag_01",
                    propBone = 57005,
                    propPlacement = {
                        0.05,
                        -0.150,
                        -0.090,
                        -69.716,
                        3.4511,
                        -9.391
                    },
                    secondProp = 'ind_prop_dlc_flag_01',
                    secondPropBone = 18905,
                    secondPropPlacement = {
                        0.030,
                        -0.150,
                        0.040,
                        -100.627,
                        -3.616,
                        -19.683
                    },
                    emoteLoop = true,
                    emoteMoving = true
                }
            },
            ["flagp"] = {
                "pazeee@flagp@animations",
                "pazeee@flagp@clip",
                "Flag R To The Top!",
                animationOptions = {
                    prop = "a3d_pole",
                    propBone = 57005,
                    propPlacement = {
                        0.03,
                        -0.140,
                        -0.070,
                        -70.00,
                        0.0,
                        -20.0
                    },
                    secondProp = 'prop_flag_ireland_s',
                    secondPropBone = 57005,
                    secondPropPlacement = {
                        0.460,
                        1.050,
                        0.380,
                        -70.00,
                        0.0,
                        -20.0
                    },
                    emoteLoop = true
                }
            },
            ["flagq"] = {
                "pazeee@flagq@animations",
                "pazeee@flagq@clip",
                "Flag Start Race",
                animationOptions = {
                    prop = "prop_fnccorgm_02pole",
                    propBone = 57005,
                    propPlacement = {
                        0.04,
                        -0.240,
                        -0.10,
                        -69.716,
                        3.451,
                        -9.391
                    },
                    secondProp = 'apa_prop_flag_italy',
                    secondPropBone = 57005,
                    secondPropPlacement = {
                        0.30,
                        1.190,
                        0.430,
                        -69.716,
                        3.451,
                        -9.391
                    },
                    emoteLoop = true
                }
            },
            ["flagr"] = {
                "pazeee@flagr@animations",
                "pazeee@flagr@clip",
                "Flag R Wave Slowly",
                animationOptions = {
                    prop = "a3d_pole",
                    propBone = 57005,
                    propPlacement = {
                        0.03,
                        -0.140,
                        -0.070,
                        -70.00,
                        0.0,
                        -20.0
                    },
                    secondProp = 'prop_flag_scotland_s',
                    secondPropBone = 57005,
                    secondPropPlacement = {
                        0.460,
                        1.050,
                        0.380,
                        -70.00,
                        0.0,
                        -20.0
                    },
                    emoteLoop = true,
                    emoteMoving = true
                }
            },
            ["flags"] = {
                "pazeee@flags@animations",
                "pazeee@flags@clip",
                "Flag L Wave Slowly",
                animationOptions = {
                    prop = "a3d_pole",
                    propBone = 18905,
                    propPlacement = {
                        -0.05,
                        -0.210,
                        0.060,
                        -101.508,
                        -5.725,
                        -29.498
                    },
                    secondProp = 'prop_flag_sheriff_s',
                    secondPropBone = 18905,
                    secondPropPlacement = {
                        0.630,
                        0.930,
                        -0.140,
                        -101.508,
                        -5.725,
                        -29.498
                    },
                    emoteLoop = true,
                    emoteMoving = true
                }
            },
            ["flagt"] = {
                "pazeee@flagt@animations",
                "pazeee@flagt@clip",
                "Flag R Wave Happy",
                animationOptions = {
                    prop = "a3d_pole",
                    propBone = 57005,
                    propPlacement = {
                        0.03,
                        -0.140,
                        -0.070,
                        -70.00,
                        0.0,
                        -20.0
                    },
                    secondProp = 'prop_flag_sapd_s',
                    secondPropBone = 57005,
                    secondPropPlacement = {
                        0.460,
                        1.050,
                        0.380,
                        -70.00,
                        0.0,
                        -20.0
                    },
                    emoteLoop = true
                }
            },
            ["flagu"] = {
                "pazeee@flagu@animations",
                "pazeee@flagu@clip",
                "Flag L Wave Happy",
                animationOptions = {
                    prop = "a3d_pole",
                    propBone = 18905,
                    propPlacement = {
                        -0.05,
                        -0.210,
                        0.060,
                        -101.508,
                        -5.725,
                        -29.498
                    },
                    secondProp = 'prop_flag_lsfd_s',
                    secondPropBone = 18905,
                    secondPropPlacement = {
                        0.630,
                        0.930,
                        -0.140,
                        -101.508,
                        -5.725,
                        -29.498
                    },
                    emoteLoop = true
                }
            },
            ["flagv"] = {
                "pazeee@flagv@animations",
                "pazeee@flagv@clip",
                "Flag R Wave High",
                animationOptions = {
                    prop = "a3d_pole",
                    propBone = 57005,
                    propPlacement = {
                        0.03,
                        -0.140,
                        -0.070,
                        -70.00,
                        0.0,
                        -20.0
                    },
                    secondProp = 'prop_flag_sa_s',
                    secondPropBone = 57005,
                    secondPropPlacement = {
                        0.460,
                        1.050,
                        0.380,
                        -70.00,
                        0.0,
                        -20.0
                    },
                    emoteLoop = true
                }
            },
            ["flagw"] = {
                "pazeee@flagw@animations",
                "pazeee@flagw@clip",
                "Flag L Wave High",
                animationOptions = {
                    prop = "a3d_pole",
                    propBone = 18905,
                    propPlacement = {
                        -0.05,
                        -0.210,
                        0.060,
                        -101.508,
                        -5.725,
                        -29.498
                    },
                    secondProp = 'prop_flag_canada_s',
                    secondPropBone = 18905,
                    secondPropPlacement = {
                        0.630,
                        0.930,
                        -0.140,
                        -101.508,
                        -5.725,
                        -29.498
                    },
                    emoteLoop = true
                }
            },
            ["flagx"] = {
                "pazeee@flagx@animations",
                "pazeee@flagx@clip",
                "Flag R Big Wave High",
                animationOptions = {
                    prop = "prop_fnccorgm_02pole",
                    propBone = 57005,
                    propPlacement = {
                        0.04,
                        -0.240,
                        -0.10,
                        -69.716,
                        3.451,
                        -9.391
                    },
                    secondProp = 'apa_prop_flag_australia',
                    secondPropBone = 57005,
                    secondPropPlacement = {
                        0.30,
                        1.190,
                        0.430,
                        -69.716,
                        3.451,
                        -9.391
                    },
                    emoteLoop = true
                }
            },
            ["flagy"] = {
                "pazeee@flagy@animations",
                "pazeee@flagy@clip",
                "Flag L Big Wave High",
                animationOptions = {
                    prop = "prop_fnccorgm_02pole",
                    propBone = 18905,
                    propPlacement = {
                        0.04,
                        -0.20,
                        0.10,
                        -110.283,
                        -3.451,
                        -9.391
                    },
                    secondProp = 'prop_flag_sheriff',
                    secondPropBone = 18905,
                    secondPropPlacement = {
                        0.30,
                        1.230,
                        -0.410,
                        -110.283,
                        -3.451,
                        -9.391
                    },
                    emoteLoop = true
                }
            },
            ["flagz"] = {
                "pazeee@flagz@animations",
                "pazeee@flagz@clip",
                "Flag R Big Wave Side",
                animationOptions = {
                    prop = "prop_fnccorgm_02pole",
                    propBone = 57005,
                    propPlacement = {
                        0.04,
                        -0.240,
                        -0.10,
                        -69.716,
                        3.451,
                        -9.391
                    },
                    secondProp = 'prop_flag_uk',
                    secondPropBone = 57005,
                    secondPropPlacement = {
                        0.30,
                        1.190,
                        0.430,
                        -69.716,
                        3.451,
                        -9.391
                    },
                    emoteLoop = true
                }
            },
            ["flagza"] = {
                "pazeee@flagza@animations",
                "pazeee@flagza@clip",
                "Flag L Big Wave Side",
                animationOptions = {
                    prop = "prop_fnccorgm_02pole",
                    propBone = 18905,
                    propPlacement = {
                        0.04,
                        -0.20,
                        0.10,
                        -110.283,
                        -3.451,
                        -9.391
                    },
                    secondProp = 'prop_flag_mexico',
                    secondPropBone = 18905,
                    secondPropPlacement = {
                        0.30,
                        1.230,
                        -0.410,
                        -110.283,
                        -3.451,
                        -9.391
                    },
                    emoteLoop = true
                }
            },
            ["flagzb"] = {
                "pazeee@flagzb@animations",
                "pazeee@flagzb@clip",
                "Flag R Wave Side Fast",
                animationOptions = {
                    prop = "a3d_pole",
                    propBone = 57005,
                    propPlacement = {
                        0.03,
                        -0.140,
                        -0.070,
                        -70.00,
                        0.0,
                        -20.0
                    },
                    secondProp = 'prop_flag_german_s',
                    secondPropBone = 57005,
                    secondPropPlacement = {
                        0.460,
                        1.050,
                        0.380,
                        -70.00,
                        0.0,
                        -20.0
                    },
                    emoteLoop = true
                }
            },
            ["flagzc"] = {
                "pazeee@flagzc@animations",
                "pazeee@flagzc@clip",
                "Flag L Wave Side Fast",
                animationOptions = {
                    prop = "a3d_pole",
                    propBone = 18905,
                    propPlacement = {
                        -0.05,
                        -0.210,
                        0.060,
                        -101.508,
                        -5.725,
                        -29.498
                    },
                    secondProp = 'prop_flag_eu_s',
                    secondPropBone = 18905,
                    secondPropPlacement = {
                        0.630,
                        0.930,
                        -0.140,
                        -101.508,
                        -5.725,
                        -29.498
                    },
                    emoteLoop = true
                }
            },
            ["flagzd"] = {
                "pazeee@flagzd@animations",
                "pazeee@flagzd@clip",
                "Flag R Wave Rythm",
                animationOptions = {
                    prop = "a3d_pole",
                    propBone = 57005,
                    propPlacement = {
                        0.03,
                        -0.140,
                        -0.070,
                        -70.00,
                        0.0,
                        -20.0
                    },
                    secondProp = 'prop_flag_scotland_s',
                    secondPropBone = 57005,
                    secondPropPlacement = {
                        0.460,
                        1.050,
                        0.380,
                        -70.00,
                        0.0,
                        -20.0
                    },
                    emoteLoop = true
                }
            },
            ["flagze"] = {
                "pazeee@flagze@animations",
                "pazeee@flagze@clip",
                "Flag L Wave Rythm",
                animationOptions = {
                    prop = "a3d_pole",
                    propBone = 18905,
                    propPlacement = {
                        -0.05,
                        -0.210,
                        0.060,
                        -101.508,
                        -5.725,
                        -29.498
                    },
                    secondProp = 'prop_flag_russia_s',
                    secondPropBone = 18905,
                    secondPropPlacement = {
                        0.630,
                        0.930,
                        -0.140,
                        -101.508,
                        -5.725,
                        -29.498
                    },
                    emoteLoop = true
                }
            },
            ["flagzf"] = {
                "pazeee@flagzf@animations",
                "pazeee@flagzf@clip",
                "Flag R Wave Dance",
                animationOptions = {
                    prop = "a3d_pole",
                    propBone = 57005,
                    propPlacement = {
                        0.03,
                        -0.140,
                        -0.070,
                        -70.00,
                        0.0,
                        -20.0
                    },
                    secondProp = 'prop_flag_ireland_s',
                    secondPropBone = 57005,
                    secondPropPlacement = {
                        0.460,
                        1.050,
                        0.380,
                        -70.00,
                        0.0,
                        -20.0
                    },
                    emoteLoop = true
                }
            },
            ["flagzg"] = {
                "pazeee@flagzg@animations",
                "pazeee@flagzg@clip",
                "Flag L Wave Dance",
                animationOptions = {
                    prop = "a3d_pole",
                    propBone = 18905,
                    propPlacement = {
                        -0.05,
                        -0.210,
                        0.060,
                        -101.508,
                        -5.725,
                        -29.498
                    },
                    secondProp = 'prop_flag_mexico_s',
                    secondPropBone = 18905,
                    secondPropPlacement = {
                        0.630,
                        0.930,
                        -0.140,
                        -101.508,
                        -5.725,
                        -29.498
                    },
                    emoteLoop = true
                }
            },
            ["flagzh"] = {
                "pazeee@flagzh@animations",
                "pazeee@flagzh@clip",
                "Flag Spread Double",
                animationOptions = {
                    prop = "ind_prop_dlc_flag_01",
                    propBone = 57005,
                    propPlacement = {
                        0.05,
                        -0.150,
                        -0.090,
                        -68.326,
                        5.4849,
                        -13.982
                    },
                    secondProp = 'ind_prop_dlc_flag_01',
                    secondPropBone = 18905,
                    secondPropPlacement = {
                        0.030,
                        -0.150,
                        0.040,
                        -100.627,
                        -3.616,
                        -19.683
                    },
                    emoteLoop = true,
                    emoteMoving = true
                }
            },
            ["flagzi"] = {
                "pazeee@flagzi@animations",
                "pazeee@flagzi@clip",
                "Flag R Carry Shoulders",
                animationOptions = {
                    prop = "a3d_pole",
                    propBone = 57005,
                    propPlacement = {
                        0.03,
                        -0.140,
                        -0.070,
                        -70.00,
                        0.0,
                        -20.0
                    },
                    secondProp = 'prop_flag_france_s',
                    secondPropBone = 57005,
                    secondPropPlacement = {
                        0.460,
                        1.050,
                        0.380,
                        -70.00,
                        0.0,
                        -20.0
                    },
                    emoteLoop = true,
                    emoteMoving = true
                }
            },
            ["flagzj"] = {
                "pazeee@flagzj@animations",
                "pazeee@flagzj@clip",
                "Flag L Carry Shoulders",
                animationOptions = {
                    prop = "a3d_pole",
                    propBone = 18905,
                    propPlacement = {
                        -0.05,
                        -0.210,
                        0.060,
                        -101.508,
                        -5.725,
                        -29.498
                    },
                    secondProp = 'prop_flag_uk_s',
                    secondPropBone = 18905,
                    secondPropPlacement = {
                        0.630,
                        0.930,
                        -0.140,
                        -101.508,
                        -5.725,
                        -29.498
                    },
                    emoteLoop = true,
                    emoteMoving = true
                }
            },
            ["flagzk"] = {
                "pazeee@flagzk@animations",
                "pazeee@flagzk@clip",
                "Flag R Big Carry Shoulders",
                animationOptions = {
                    prop = "prop_fnccorgm_02pole",
                    propBone = 57005,
                    propPlacement = {
                        0.04,
                        -0.240,
                        -0.10,
                        -69.716,
                        3.451,
                        -9.391
                    },
                    secondProp = 'prop_flag_russia',
                    secondPropBone = 57005,
                    secondPropPlacement = {
                        0.30,
                        1.190,
                        0.430,
                        -69.716,
                        3.451,
                        -9.391
                    },
                    emoteLoop = true,
                    emoteMoving = true
                }
            },
            ["flagzl"] = {
                "pazeee@flagzl@animations",
                "pazeee@flagzl@clip",
                "Flag L Big Carry Shoulders",
                animationOptions = {
                    prop = "prop_fnccorgm_02pole",
                    propBone = 18905,
                    propPlacement = {
                        0.04,
                        -0.20,
                        0.10,
                        -110.283,
                        -3.451,
                        -9.391
                    },
                    secondProp = 'apa_prop_flag_brazil',
                    secondPropBone = 18905,
                    secondPropPlacement = {
                        0.30,
                        1.230,
                        -0.410,
                        -110.283,
                        -3.451,
                        -9.391
                    },
                    emoteLoop = true,
                    emoteMoving = true
                }
            },
            ["flagzm"] = {
                "pazeee@flagzm@animations",
                "pazeee@flagzm@clip",
                "Flag R Carry Front",
                animationOptions = {
                    prop = "prop_fnccorgm_02pole",
                    propBone = 57005,
                    propPlacement = {
                        0.08,
                        -0.070,
                        -0.050,
                        -72.753,
                        2.951,
                        -9.558
                    },
                    secondProp = 'prop_flag_german',
                    secondPropBone = 57005,
                    secondPropPlacement = {
                        0.360,
                        1.390,
                        0.390,
                        -72.753,
                        2.951,
                        -9.558
                    },
                    emoteLoop = true,
                    emoteMoving = true
                }
            },
            ["flagzn"] = {
                "pazeee@flagzn@animations",
                "pazeee@flagzn@clip",
                "Flag L Carry Front",
                animationOptions = {
                    prop = "prop_fnccorgm_02pole",
                    propBone = 18905,
                    propPlacement = {
                        0.05,
                        -0.130,
                        0.080,
                        -112.606,
                        -5.335,
                        -12.962
                    },
                    secondProp = 'apa_prop_flag_france',
                    secondPropBone = 18905,
                    secondPropPlacement = {
                        0.410,
                        1.250,
                        -0.480,
                        -112.606,
                        -5.335,
                        -12.962
                    },
                    emoteLoop = true,
                    emoteMoving = true
                }
            },
            ["flagzo"] = {
                "pazeee@flagzo@animations",
                "pazeee@flagzo@clip",
                "Flag Hold Front Stand",
                animationOptions = {
                    prop = "prop_fnccorgm_02pole",
                    propBone = 18905,
                    propPlacement = {
                        0.05,
                        -0.130,
                        0.080,
                        -112.606,
                        -5.335,
                        -12.962
                    },
                    secondProp = 'apa_prop_flag_austria',
                    secondPropBone = 18905,
                    secondPropPlacement = {
                        0.410,
                        1.250,
                        -0.480,
                        -112.606,
                        -5.335,
                        -12.962
                    },
                    emoteLoop = true,
                    emoteMoving = true
                }
            },
            ["flagzp"] = {
                "pazeee@flagzp@animations",
                "pazeee@flagzp@clip",
                "Flag Hold Front Tilt",
                animationOptions = {
                    prop = "prop_fnccorgm_02pole",
                    propBone = 18905,
                    propPlacement = {
                        0.14,
                        0.240,
                        -0.10,
                        63.497,
                        -5.323,
                        -10.770
                    },
                    secondProp = 'apa_prop_flag_china',
                    secondPropBone = 18905,
                    secondPropPlacement = {
                        -0.180,
                        -1.10,
                        0.550,
                        63.497,
                        -5.323,
                        -10.770
                    },
                    emoteLoop = true,
                    emoteMoving = true
                }
            },
            ["flagzq"] = {
                "pazeee@flagzq@animations",
                "pazeee@flagzq@clip",
                "Flag Big Wave Slow",
                animationOptions = {
                    prop = "prop_fnccorgm_02pole",
                    propBone = 18905,
                    propPlacement = {
                        0.05,
                        -0.130,
                        0.080,
                        -112.606,
                        -5.335,
                        -12.962
                    },
                    secondProp = 'apa_prop_flag_argentina',
                    secondPropBone = 18905,
                    secondPropPlacement = {
                        0.410,
                        1.250,
                        -0.480,
                        -112.606,
                        -5.335,
                        -12.962
                    },
                    emoteLoop = true
                }
            },
            ["flagzr"] = {
                "pazeee@flagzr@animations",
                "pazeee@flagzr@clip",
                "Flag Big Wave Fast",
                animationOptions = {
                    prop = "prop_fnccorgm_02pole",
                    propBone = 18905,
                    propPlacement = {
                        0.05,
                        -0.130,
                        0.080,
                        -112.606,
                        -5.335,
                        -12.962
                    },
                    secondProp = 'apa_prop_flag_portugal',
                    secondPropBone = 18905,
                    secondPropPlacement = {
                        0.410,
                        1.250,
                        -0.480,
                        -112.606,
                        -5.335,
                        -12.962
                    },
                    emoteLoop = true
                }
            },
            ["flagzs"] = {
                "pazeee@flagzs@animations",
                "pazeee@flagzs@clip",
                "Flag Big Wave Wide",
                animationOptions = {
                    prop = "prop_fnccorgm_02pole",
                    propBone = 18905,
                    propPlacement = {
                        0.05,
                        -0.130,
                        0.080,
                        -112.606,
                        -5.335,
                        -12.962
                    },
                    secondProp = 'apa_prop_flag_southkorea',
                    secondPropBone = 18905,
                    secondPropPlacement = {
                        0.410,
                        1.250,
                        -0.480,
                        -112.606,
                        -5.335,
                        -12.962
                    },
                    emoteLoop = true
                }
            },
            ["flagzt"] = {
                "pazeee@flagzt@animations",
                "pazeee@flagzt@clip",
                "Flag Respect",
                animationOptions = {
                    prop = "a3d_pole",
                    propBone = 18905,
                    propPlacement = {
                        -0.08,
                        -0.80,
                        0.20,
                        -103.280,
                        -2.737,
                        -11.688
                    },
                    secondProp = 'prop_flag_russia_s',
                    secondPropBone = 18905,
                    secondPropPlacement = {
                        0.180,
                        0.460,
                        -0.090,
                        -103.280,
                        -2.737,
                        -11.688
                    },
                    emoteLoop = true,
                    emoteMoving = true
                }
            },
            ["flagzu"] = {
                "pazeee@flagzu@animations",
                "pazeee@flagzu@clip",
                "Flag Hold High",
                animationOptions = {
                    prop = "a3d_pole",
                    propBone = 18905,
                    propPlacement = {
                        0.0,
                        -0.190,
                        0.060,
                        -102.008,
                        -5.045,
                        -23.514
                    },
                    secondProp = 'prop_flag_us_s',
                    secondPropBone = 18905,
                    secondPropPlacement = {
                        0.550,
                        1.0,
                        -0.180,
                        -102.008,
                        -5.045,
                        -23.514
                    },
                    emoteLoop = true,
                    emoteMoving = true
                }
            },
            ["flagzv"] = {
                "pazeee@flagzv@animations",
                "pazeee@flagzv@clip",
                "Flag Hold On Top!",
                animationOptions = {
                    prop = "a3d_pole",
                    propBone = 18905,
                    propPlacement = {
                        0.0,
                        -0.190,
                        0.060,
                        -102.008,
                        -5.045,
                        -23.514
                    },
                    secondProp = 'prop_flag_canada_s',
                    secondPropBone = 18905,
                    secondPropPlacement = {
                        0.550,
                        1.0,
                        -0.180,
                        -102.008,
                        -5.045,
                        -23.514
                    },
                    emoteLoop = true,
                    emoteMoving = true
                }
            },
            ["flagzw"] = {
                "pazeee@flagzw@animations",
                "pazeee@flagzw@clip",
                "Flag Hold Spirit!",
                animationOptions = {
                    prop = "a3d_pole",
                    propBone = 18905,
                    propPlacement = {
                        0.0,
                        -0.190,
                        0.060,
                        -102.008,
                        -5.045,
                        -23.514
                    },
                    secondProp = 'prop_flag_eu_s',
                    secondPropBone = 18905,
                    secondPropPlacement = {
                        0.550,
                        1.0,
                        -0.180,
                        -102.008,
                        -5.045,
                        -23.514
                    },
                    emoteLoop = true,
                    emoteMoving = true
                }
            },
            ["flagzw2"] = {
                "pazeee@flagzw2@animations",
                "pazeee@flagzw2@clip",
                "Flag Wave Edge",
                animationOptions = {
                    prop = "prop_fnccorgm_02pole",
                    propBone = 57005,
                    propPlacement = {
                        0.07,
                        -0.140,
                        -0.070,
                        -72.753,
                        2.9511,
                        -9.558
                    },
                    secondProp = 'apa_prop_flag_italy',
                    secondPropBone = 57005,
                    secondPropPlacement = {
                        0.330,
                        1.310,
                        0.370,
                        -72.753,
                        2.9511,
                        -9.558
                    },
                    emoteLoop = true
                }
            },
            ["flagzw3"] = {
                "pazeee@flagzw3@animations",
                "pazeee@flagzw3@clip",
                "Flag Kneel Salute Leader",
                animationOptions = {
                    prop = "prop_fnccorgm_02pole",
                    propBone = 52301,
                    propPlacement = {
                        1.10,
                        0.350,
                        -0.350,
                        -90.0,
                        0.0,
                        20.0
                    },
                    secondProp = 'prop_flag_sapd_s',
                    secondPropBone = 52301,
                    secondPropPlacement = {
                        0.470,
                        2.080,
                        -0.350,
                        -90.0,
                        0.0,
                        20.0
                    },
                    emoteLoop = true
                }
            },
            ["flagzx"] = {
                "pazeee@flagzx@animations",
                "pazeee@flagzx@clip",
                "Flag Raise Giant Flag",
                animationOptions = {
                    prop = "stt_prop_flagpole_1a",
                    propBone = 57005,
                    propPlacement = {
                        0.1,
                        -1.0,
                        -0.070,
                        -90.0,
                        0.0,
                        0.0
                    },
                    emoteLoop = true
                }
            },
            ["flagzy"] = {
                "pazeee@flagzy@animations",
                "pazeee@flagzy@clip",
                "Flag Hold Giant Flag",
                animationOptions = {
                    prop = "stt_prop_flagpole_1b",
                    propBone = 57005,
                    propPlacement = {
                        -0.35,
                        -1.160,
                        -0.640,
                        -64.2307,
                        6.46,
                        -13.566
                    },
                    emoteLoop = true
                }
            },
            ["flagzz"] = {
                "pazeee@flagzz@animations",
                "pazeee@flagzz@clip",
                "Flag Giant Wave 1",
                animationOptions = {
                    prop = "stt_prop_flagpole_1c",
                    propBone = 57005,
                    propPlacement = {
                        -0.06,
                        -1.090,
                        -0.390,
                        -74.859,
                        2.083,
                        -7.725
                    },
                    emoteLoop = true
                }
            },
            ["flagzza"] = {
                "pazeee@flagzza@animations",
                "pazeee@flagzza@clip",
                "Flag Giant Wave 2",
                animationOptions = {
                    prop = "stt_prop_flagpole_1d",
                    propBone = 57005,
                    propPlacement = {
                        -0.04,
                        -0.890,
                        -0.320,
                        -74.859,
                        2.083,
                        -7.725
                    },
                    emoteLoop = true
                }
            },
            ["flagzzb"] = {
                "pazeee@flagzzb@animations",
                "pazeee@flagzzb@clip",
                "Flag Hold With Style",
                animationOptions = {
                    prop = "stt_prop_flagpole_1e",
                    propBone = 57005,
                    propPlacement = {
                        1.09,
                        0.90,
                        0.180,
                        110.753,
                        14.5108,
                        -43.079
                    },
                    emoteLoop = true
                }
            },
            ["flagzzb2"] = {
                "pazeee@flagzzb2@animations",
                "pazeee@flagzzb2@clip",
                "Flag Giant Pirate Low",
                animationOptions = {
                    prop = "stt_prop_flagpole_1f",
                    propBone = 52301,
                    propPlacement = {
                        0.40,
                        -0.70,
                        0.150,
                        -111.172,
                        7.0959,
                        18.7472
                    },
                    emoteLoop = true
                }
            },
            ["flagzzb3"] = {
                "pazeee@flagzzb3@animations",
                "pazeee@flagzzb3@clip",
                "Flag Giant Pirate High",
                animationOptions = {
                    prop = "stt_prop_flagpole_1a",
                    propBone = 52301,
                    propPlacement = {
                        1.170,
                        -3.240,
                        1.260,
                        -112.903,
                        6.5335,
                        15.728
                    },
                    emoteLoop = true
                }
            },
            ["flagzze"] = {
                "pazeee@flagzze@animations",
                "pazeee@flagzze@clip",
                "Flag Show Front Small",
                animationOptions = {
                    prop = 'prop_flag_lsfd_s',
                    propBone = 18905,
                    propPlacement = {
                        0.22,
                        0.260,
                        0.020,
                        -97.444,
                        -2.539,
                        -19.8446
                    },
                    emoteLoop = true,
                    emoteMoving = true
                }
            },
            ["flagzzf"] = {
                "pazeee@flagzzf@animations",
                "pazeee@flagzzf@clip",
                "Flag Show Front Big",
                animationOptions = {
                    prop = 'prop_flag_us',
                    propBone = 18905,
                    propPlacement = {
                        0.24,
                        0.30,
                        0.010,
                        -98.619,
                        -3.2183,
                        -21.774
                    },
                    emoteLoop = true,
                    emoteMoving = true
                }
            },
            ["flagzzg"] = {
                "pazeee@flagzzg@animations",
                "pazeee@flagzzg@clip",
                "Flag Cape Behind Small",
                animationOptions = {
                    prop = 'prop_flag_sa_s',
                    propBone = 18905,
                    propPlacement = {
                        0.12,
                        0.0,
                        0.210,
                        -169.0147,
                        -2.944,
                        -0.572
                    },
                    emoteLoop = true,
                    emoteMoving = true
                }
            },
            ["flagzzh"] = {
                "pazeee@flagzzh@animations",
                "pazeee@flagzzh@clip",
                "Flag Cape Behind Big",
                animationOptions = {
                    prop = 'apa_prop_flag_belgium',
                    propBone = 18905,
                    propPlacement = {
                        0.09,
                        -0.060,
                        0.410,
                        12.952,
                        -4.872,
                        -1.123
                    },
                    emoteLoop = true,
                    emoteMoving = true
                }
            },
            ["flagzzi"] = {
                "pazeee@flagzzi@animations",
                "pazeee@flagzzi@clip",
                "Flag Spread High Small",
                animationOptions = {
                    prop = 'prop_flag_japan_s',
                    propBone = 18905,
                    propPlacement = {
                        0.13,
                        0.0,
                        0.210,
                        -168.999,
                        0.0,
                        0.0
                    },
                    emoteLoop = true,
                    emoteMoving = true
                }
            },
            ["flagzzj"] = {
                "pazeee@flagzzj@animations",
                "pazeee@flagzzj@clip",
                "Flag Spread High Big",
                animationOptions = {
                    prop = 'apa_prop_flag_spain',
                    propBone = 18905,
                    propPlacement = {
                        0.09,
                        -0.060,
                        0.410,
                        12.952,
                        -4.872,
                        -1.123
                    },
                    emoteLoop = true,
                    emoteMoving = true
                }
            },
            ["flagzzk"] = {
                "pazeee@flagzzk@animations",
                "pazeee@flagzzk@clip",
                "Flag Spread Wide",
                animationOptions = {
                    prop = 'apa_prop_flag_france',
                    propBone = 18905,
                    propPlacement = {
                        -0.19,
                        -0.20,
                        0.640,
                        19.363,
                        -25.364,
                        -10.695
                    },
                    emoteLoop = true,
                    emoteMoving = true
                }
            },
            ["flagzzl"] = {
                "pazeee@flagzzl@animations",
                "pazeee@flagzzl@clip",
                "Flag Superman Cape",
                animationOptions = {
                    prop = 'prop_flag_us_s',
                    propBone = 24818,
                    propPlacement = {
                        0.21,
                        -0.13,
                        -0.040,
                        171.134,
                        -9.879,
                        1.556
                    },
                    emoteLoop = true,
                    emoteMoving = true
                }
            },
            ["flagzzm"] = {
                "pazeee@flagzzm@animations",
                "pazeee@flagzzm@clip",
                "Flag R Car Hold",
                animationOptions = {
                    prop = "a3d_pole",
                    propBone = 57005,
                    propPlacement = {
                        0.03,
                        -0.140,
                        -0.070,
                        -70.00,
                        0.0,
                        -20.0
                    },
                    secondProp = 'prop_flag_lsservices_s',
                    secondPropBone = 57005,
                    secondPropPlacement = {
                        0.460,
                        1.050,
                        0.380,
                        -70.00,
                        0.0,
                        -20.0
                    },
                    emoteLoop = true,
                    Flag = 1
                }
            },
            ["flagzzn"] = {
                "pazeee@flagzzn@animations",
                "pazeee@flagzzn@clip",
                "Flag L Car Hold",
                animationOptions = {
                    prop = "a3d_pole",
                    propBone = 18905,
                    propPlacement = {
                        0.05,
                        -0.190,
                        0.140,
                        -120.381,
                        -5.0383,
                        -8.649
                    },
                    secondProp = 'prop_flag_uk_s',
                    secondPropBone = 18905,
                    secondPropPlacement = {
                        0.290,
                        0.940,
                        -0.520,
                        -120.381,
                        -5.0383,
                        -8.649
                    },
                    emoteLoop = true,
                    Flag = 1
                }
            },
            ["flagzzo"] = {
                "pazeee@flagzzo@animations",
                "pazeee@flagzzo@clip",
                "Flag R Car Wave One Hand",
                animationOptions = {
                    prop = "a3d_pole",
                    propBone = 57005,
                    propPlacement = {
                        0.03,
                        -0.140,
                        -0.070,
                        -70.00,
                        0.0,
                        -20.0
                    },
                    secondProp = 'prop_flag_sheriff_s',
                    secondPropBone = 57005,
                    secondPropPlacement = {
                        0.460,
                        1.050,
                        0.380,
                        -70.00,
                        0.0,
                        -20.0
                    },
                    emoteLoop = true,
                    Flag = 1
                }
            },
            ["flagzzp"] = {
                "pazeee@flagzzp@animations",
                "pazeee@flagzzp@clip",
                "Flag L Car Wave One Hand",
                animationOptions = {
                    prop = "a3d_pole",
                    propBone = 18905,
                    propPlacement = {
                        0.05,
                        -0.190,
                        0.140,
                        -120.381,
                        -5.0383,
                        -8.649
                    },
                    secondProp = 'prop_flag_mexico_s',
                    secondPropBone = 18905,
                    secondPropPlacement = {
                        0.290,
                        0.940,
                        -0.520,
                        -120.381,
                        -5.0383,
                        -8.649
                    },
                    emoteLoop = true,
                    Flag = 1
                }
            },
            ["flagzzq"] = {
                "pazeee@flagzzq@animations",
                "pazeee@flagzzq@clip",
                "Flag R Car Hold Big",
                animationOptions = {
                    prop = "prop_fnccorgm_02pole",
                    propBone = 57005,
                    propPlacement = {
                        0.0,
                        -0.20,
                        -0.090,
                        -69.875,
                        6.757,
                        -18.867
                    },
                    secondProp = 'apa_prop_flag_italy',
                    secondPropBone = 57005,
                    secondPropPlacement = {
                        0.520,
                        1.160,
                        0.370,
                        -69.875,
                        6.757,
                        -18.867
                    },
                    emoteLoop = true,
                    Flag = 1
                }
            },
            ["flagzzr"] = {
                "pazeee@flagzzr@animations",
                "pazeee@flagzzr@clip",
                "Flag L Car Hold Big",
                animationOptions = {
                    prop = "prop_fnccorgm_02pole",
                    propBone = 18905,
                    propPlacement = {
                        0.05,
                        -0.130,
                        0.080,
                        -112.606,
                        -5.335,
                        -12.962
                    },
                    secondProp = 'apa_prop_flag_belgium',
                    secondPropBone = 18905,
                    secondPropPlacement = {
                        0.410,
                        1.250,
                        -0.480,
                        -112.606,
                        -5.335,
                        -12.962
                    },
                    emoteLoop = true,
                    Flag = 1
                }
            },
            ["flagzzs"] = {
                "pazeee@flagzzs@animations",
                "pazeee@flagzzs@clip",
                "Flag R Car Wave Inside",
                animationOptions = {
                    prop = "prop_fnccorgm_02pole",
                    propBone = 57005,
                    propPlacement = {
                        0.0,
                        -0.20,
                        -0.090,
                        -69.875,
                        6.757,
                        -18.867
                    },
                    secondProp = 'apa_prop_flag_brazil',
                    secondPropBone = 57005,
                    secondPropPlacement = {
                        0.520,
                        1.160,
                        0.370,
                        -69.875,
                        6.757,
                        -18.867
                    },
                    emoteLoop = true,
                    Flag = 1
                }
            },
            ["flagzzt"] = {
                "pazeee@flagzzt@animations",
                "pazeee@flagzzt@clip",
                "Flag L Car Wave Inside",
                animationOptions = {
                    prop = "prop_fnccorgm_02pole",
                    propBone = 18905,
                    propPlacement = {
                        0.05,
                        -0.130,
                        0.080,
                        -112.606,
                        -5.335,
                        -12.962
                    },
                    secondProp = 'apa_prop_flag_portugal',
                    secondPropBone = 18905,
                    secondPropPlacement = {
                        0.410,
                        1.250,
                        -0.480,
                        -112.606,
                        -5.335,
                        -12.962
                    },
                    emoteLoop = true,
                    Flag = 1
                }
            },
            ["flagzzu"] = {
                "pazeee@flagzzu@animations",
                "pazeee@flagzzu@clip",
                "Flag R Car Hold Window",
                animationOptions = {
                    prop = "a3d_pole",
                    propBone = 57005,
                    propPlacement = {
                        0.03,
                        -0.140,
                        -0.070,
                        -70.00,
                        0.0,
                        -20.0
                    },
                    secondProp = 'prop_flag_german_s',
                    secondPropBone = 57005,
                    secondPropPlacement = {
                        0.460,
                        1.050,
                        0.380,
                        -70.00,
                        0.0,
                        -20.0
                    },
                    emoteLoop = true,
                    Flag = 1
                }
            },
            ["flagzzu2"] = {
                "pazeee@flagzzu2@animations",
                "pazeee@flagzzu2@clip",
                "Flag R Car Hold Window V2",
                animationOptions = {
                    prop = "a3d_pole",
                    propBone = 57005,
                    propPlacement = {
                        0.03,
                        -0.140,
                        -0.070,
                        -70.00,
                        0.0,
                        -20.0
                    },
                    secondProp = 'prop_flag_sapd_s',
                    secondPropBone = 57005,
                    secondPropPlacement = {
                        0.460,
                        1.050,
                        0.380,
                        -70.00,
                        0.0,
                        -20.0
                    },
                    emoteLoop = true,
                    Flag = 1
                }
            },
            ["flagzzv"] = {
                "pazeee@flagzzv@animations",
                "pazeee@flagzzv@clip",
                "Flag L Car Hold Window",
                animationOptions = {
                    prop = "a3d_pole",
                    propBone = 18905,
                    propPlacement = {
                        0.05,
                        -0.190,
                        0.140,
                        -120.381,
                        -5.0383,
                        -8.649
                    },
                    secondProp = 'prop_flag_france_s',
                    secondPropBone = 18905,
                    secondPropPlacement = {
                        0.290,
                        0.940,
                        -0.520,
                        -120.381,
                        -5.0383,
                        -8.649
                    },
                    emoteLoop = true,
                    Flag = 1
                }
            },
            ["flagzzv2"] = {
                "pazeee@flagzzv2@animations",
                "pazeee@flagzzv2@clip",
                "Flag L Car Hold Window V2",
                animationOptions = {
                    prop = "a3d_pole",
                    propBone = 18905,
                    propPlacement = {
                        0.05,
                        -0.190,
                        0.140,
                        -120.381,
                        -5.0383,
                        -8.649
                    },
                    secondProp = 'prop_flag_uk_s',
                    secondPropBone = 18905,
                    secondPropPlacement = {
                        0.290,
                        0.940,
                        -0.520,
                        -120.381,
                        -5.0383,
                        -8.649
                    },
                    emoteLoop = true,
                    Flag = 1
                }
            },
            ["flagzzw"] = {
                "pazeee@flagzzw@animations",
                "pazeee@flagzzw@clip",
                "Flag R Car Window Wave",
                animationOptions = {
                    prop = "prop_fnccorgm_02pole",
                    propBone = 57005,
                    propPlacement = {
                        0.0,
                        -0.20,
                        -0.090,
                        -69.875,
                        6.757,
                        -18.867
                    },
                    secondProp = 'apa_prop_flag_argentina',
                    secondPropBone = 57005,
                    secondPropPlacement = {
                        0.520,
                        1.160,
                        0.370,
                        -69.875,
                        6.757,
                        -18.867
                    },
                    emoteLoop = true,
                    Flag = 1
                }
            },
            ["flagzzw2"] = {
                "pazeee@flagzzw2@animations",
                "pazeee@flagzzw2@clip",
                "Flag R Car Window Wave V2",
                animationOptions = {
                    prop = "prop_fnccorgm_02pole",
                    propBone = 57005,
                    propPlacement = {
                        0.0,
                        -0.20,
                        -0.090,
                        -69.875,
                        6.757,
                        -18.867
                    },
                    secondProp = 'apa_prop_flag_australia',
                    secondPropBone = 57005,
                    secondPropPlacement = {
                        0.520,
                        1.160,
                        0.370,
                        -69.875,
                        6.757,
                        -18.867
                    },
                    emoteLoop = true,
                    Flag = 1
                }
            },
            ["flagzzx"] = {
                "pazeee@flagzzx@animations",
                "pazeee@flagzzx@clip",
                "Flag L Car Window Wave",
                animationOptions = {
                    prop = "prop_fnccorgm_02pole",
                    propBone = 18905,
                    propPlacement = {
                        0.05,
                        -0.130,
                        0.080,
                        -112.606,
                        -5.335,
                        -12.962
                    },
                    secondProp = 'apa_prop_flag_china',
                    secondPropBone = 18905,
                    secondPropPlacement = {
                        0.410,
                        1.250,
                        -0.480,
                        -112.606,
                        -5.335,
                        -12.962
                    },
                    emoteLoop = true,
                    Flag = 1
                }
            },
            ["flagzzx2"] = {
                "pazeee@flagzzx2@animations",
                "pazeee@flagzzx2@clip",
                "Flag L Car Window Wave V2",
                animationOptions = {
                    prop = "prop_fnccorgm_02pole",
                    propBone = 18905,
                    propPlacement = {
                        0.05,
                        -0.130,
                        0.080,
                        -112.606,
                        -5.335,
                        -12.962
                    },
                    secondProp = 'apa_prop_flag_spain',
                    secondPropBone = 18905,
                    secondPropPlacement = {
                        0.410,
                        1.250,
                        -0.480,
                        -112.606,
                        -5.335,
                        -12.962
                    },
                    emoteLoop = true,
                    Flag = 1
                }
            },
            ["flagzzy"] = {
                "pazeee@flagzzy@animations",
                "pazeee@flagzzy@clip",
                "Flag R Car Window Wave Side",
                animationOptions = {
                    prop = "prop_fnccorgm_02pole",
                    propBone = 57005,
                    propPlacement = {
                        0.0,
                        -0.20,
                        -0.090,
                        -69.875,
                        6.757,
                        -18.867
                    },
                    secondProp = 'apa_prop_flag_turkey',
                    secondPropBone = 57005,
                    secondPropPlacement = {
                        0.520,
                        1.160,
                        0.370,
                        -69.875,
                        6.757,
                        -18.867
                    },
                    emoteLoop = true,
                    Flag = 1
                }
            },
            ["flagzzy2"] = {
                "pazeee@flagzzy2@animations",
                "pazeee@flagzzy2@clip",
                "Flag R Car Window Wave Side V2",
                animationOptions = {
                    prop = "prop_fnccorgm_02pole",
                    propBone = 57005,
                    propPlacement = {
                        0.0,
                        -0.20,
                        -0.090,
                        -69.875,
                        6.757,
                        -18.867
                    },
                    secondProp = 'prop_flag_us',
                    secondPropBone = 57005,
                    secondPropPlacement = {
                        0.520,
                        1.160,
                        0.370,
                        -69.875,
                        6.757,
                        -18.867
                    },
                    emoteLoop = true,
                    Flag = 1
                }
            },
            ["flagzzz"] = {
                "pazeee@flagzzz@animations",
                "pazeee@flagzzz@clip",
                "Flag L Car Window Wave Side",
                animationOptions = {
                    prop = "prop_fnccorgm_02pole",
                    propBone = 57005,
                    propPlacement = {
                        0.0,
                        -0.20,
                        -0.090,
                        -69.875,
                        6.757,
                        -18.867
                    },
                    secondProp = 'prop_flag_uk',
                    secondPropBone = 57005,
                    secondPropPlacement = {
                        0.520,
                        1.160,
                        0.370,
                        -69.875,
                        6.757,
                        -18.867
                    },
                    emoteLoop = true,
                    Flag = 1
                }
            },
            ["flagzzz2"] = {
                "pazeee@flagzzz2@animations",
                "pazeee@flagzzz2@clip",
                "Flag L Car Window Wave Side V2",
                animationOptions = {
                    prop = "prop_fnccorgm_02pole",
                    propBone = 57005,
                    propPlacement = {
                        0.0,
                        -0.20,
                        -0.090,
                        -69.875,
                        6.757,
                        -18.867
                    },
                    secondProp = 'apa_prop_flag_poland',
                    secondPropBone = 57005,
                    secondPropPlacement = {
                        0.520,
                        1.160,
                        0.370,
                        -69.875,
                        6.757,
                        -18.867
                    },
                    emoteLoop = true,
                    Flag = 1
                }
            },
            ["flagzzza"] = {
                "pazeee@flagzzza@animations",
                "pazeee@flagzzza@clip",
                "Flag R Car Hold Giant",
                animationOptions = {
                    prop = "stt_prop_flagpole_1a",
                    propBone = 24818,
                    propPlacement = {
                        -0.290,
                        0.280,
                        0.020,
                        10.0,
                        90.0,
                        0.0
                    },
                    emoteLoop = true,
                    Flag = 1
                }
            },
            ["flagzzza2"] = {
                "pazeee@flagzzza2@animations",
                "pazeee@flagzzza2@clip",
                "Flag R Car Hold Giant V2",
                animationOptions = {
                    prop = "stt_prop_flagpole_1a",
                    propBone = 24818,
                    propPlacement = {
                        -0.290,
                        0.280,
                        0.020,
                        10.0,
                        90.0,
                        0.0
                    },
                    emoteLoop = true,
                    Flag = 1
                }
            },
            ["flagzzzb"] = {
                "pazeee@flagzzzb@animations",
                "pazeee@flagzzzb@clip",
                "Flag L Car Hold Giant",
                animationOptions = {
                    prop = "stt_prop_flagpole_1b",
                    propBone = 24818,
                    propPlacement = {
                        -0.290,
                        0.280,
                        0.020,
                        10.0,
                        90.0,
                        0.0
                    },
                    emoteLoop = true,
                    Flag = 1
                }
            },
            ["flagzzzb2"] = {
                "pazeee@flagzzzb2@animations",
                "pazeee@flagzzzb2@clip",
                "Flag L Car Hold Giant V2",
                animationOptions = {
                    prop = "stt_prop_flagpole_1b",
                    propBone = 24818,
                    propPlacement = {
                        -0.290,
                        0.280,
                        0.020,
                        10.0,
                        90.0,
                        0.0
                    },
                    emoteLoop = true,
                    Flag = 1
                }
            },
            ["flagzzzc"] = {
                "pazeee@flagzzzc@animations",
                "pazeee@flagzzzc@clip",
                "Flag R Car Hold Giant Side",
                animationOptions = {
                    prop = "stt_prop_flagpole_1c",
                    propBone = 24818,
                    propPlacement = {
                        -0.270,
                        0.240,
                        0.020,
                        5.0,
                        90.0,
                        0.0
                    },
                    emoteLoop = true,
                    Flag = 1
                }
            },
            ["flagzzzc2"] = {
                "pazeee@flagzzzc2@animations",
                "pazeee@flagzzzc2@clip",
                "Flag R Car Hold Giant Side V2",
                animationOptions = {
                    prop = "stt_prop_flagpole_1c",
                    propBone = 24818,
                    propPlacement = {
                        -0.270,
                        0.240,
                        0.020,
                        5.0,
                        90.0,
                        0.0
                    },
                    emoteLoop = true,
                    Flag = 1
                }
            },
            ["flagzzzd"] = {
                "pazeee@flagzzzd@animations",
                "pazeee@flagzzzd@clip",
                "Flag L Car Hold Giant Side",
                animationOptions = {
                    prop = "stt_prop_flagpole_1d",
                    propBone = 24818,
                    propPlacement = {
                        -0.270,
                        0.240,
                        0.020,
                        5.0,
                        90.0,
                        0.0
                    },
                    emoteLoop = true,
                    Flag = 1
                }
            },
            ["flagzzzd2"] = {
                "pazeee@flagzzzd2@animations",
                "pazeee@flagzzzd2@clip",
                "Flag L Car Hold Giant Side V2",
                animationOptions = {
                    prop = "stt_prop_flagpole_1d",
                    propBone = 24818,
                    propPlacement = {
                        -0.270,
                        0.240,
                        0.020,
                        5.0,
                        90.0,
                        0.0
                    },
                    emoteLoop = true,
                    Flag = 1
                }
            },
            ["flagzzze"] = {
                "pazeee@flagzzze@animations",
                "pazeee@flagzzze@clip",
                "Flag R Car Spirit",
                animationOptions = {
                    prop = "a3d_pole",
                    propBone = 57005,
                    propPlacement = {
                        0.03,
                        -0.140,
                        -0.070,
                        -70.00,
                        0.0,
                        -20.0
                    },
                    secondProp = 'prop_flag_eu_s',
                    secondPropBone = 57005,
                    secondPropPlacement = {
                        0.460,
                        1.050,
                        0.380,
                        -70.00,
                        0.0,
                        -20.0
                    },
                    emoteLoop = true,
                    Flag = 1
                }
            },
            ["flagzzze2"] = {
                "pazeee@flagzzze2@animations",
                "pazeee@flagzzze2@clip",
                "Flag R Car Spirit V2",
                animationOptions = {
                    prop = "a3d_pole",
                    propBone = 57005,
                    propPlacement = {
                        0.03,
                        -0.140,
                        -0.070,
                        -70.00,
                        0.0,
                        -20.0
                    },
                    secondProp = 'prop_flag_lsfd_s',
                    secondPropBone = 57005,
                    secondPropPlacement = {
                        0.460,
                        1.050,
                        0.380,
                        -70.00,
                        0.0,
                        -20.0
                    },
                    emoteLoop = true,
                    Flag = 1
                }
            },
            ["flagzzzf"] = {
                "pazeee@flagzzzf@animations",
                "pazeee@flagzzzf@clip",
                "Flag L Car Spirit",
                animationOptions = {
                    prop = "a3d_pole",
                    propBone = 18905,
                    propPlacement = {
                        0.05,
                        -0.190,
                        0.140,
                        -120.381,
                        -5.0383,
                        -8.649
                    },
                    secondProp = 'prop_flag_france_s',
                    secondPropBone = 18905,
                    secondPropPlacement = {
                        0.290,
                        0.940,
                        -0.520,
                        -120.381,
                        -5.0383,
                        -8.649
                    },
                    emoteLoop = true,
                    Flag = 1
                }
            },
            ["flagzzzf2"] = {
                "pazeee@flagzzzf2@animations",
                "pazeee@flagzzzf2@clip",
                "Flag L Car Spirit V2",
                animationOptions = {
                    prop = "a3d_pole",
                    propBone = 18905,
                    propPlacement = {
                        0.05,
                        -0.190,
                        0.140,
                        -120.381,
                        -5.0383,
                        -8.649
                    },
                    secondProp = 'prop_flag_us_s',
                    secondPropBone = 18905,
                    secondPropPlacement = {
                        0.290,
                        0.940,
                        -0.520,
                        -120.381,
                        -5.0383,
                        -8.649
                    },
                    emoteLoop = true,
                    Flag = 1
                }
            },
            ["flagzzzg"] = {
                "pazeee@flagzzzg@animations",
                "pazeee@flagzzzg@clip",
                "Flag R Car Hold No Pole",
                animationOptions = {
                    prop = 'prop_flag_sa_s',
                    propBone = 24818,
                    propPlacement = {
                        0.690,
                        0.0,
                        0.020,
                        173.0,
                        0.0,
                        0.0
                    },
                    emoteLoop = true,
                    Flag = 1
                }
            },
            ["flagzzzg2"] = {
                "pazeee@flagzzzg2@animations",
                "pazeee@flagzzzg2@clip",
                "Flag R Car Hold No Pole V2",
                animationOptions = {
                    prop = 'prop_flag_canada_s',
                    propBone = 24818,
                    propPlacement = {
                        0.690,
                        0.0,
                        0.020,
                        173.0,
                        0.0,
                        0.0
                    },
                    emoteLoop = true,
                    Flag = 1
                }
            },
            ["flagzzzh"] = {
                "pazeee@flagzzzh@animations",
                "pazeee@flagzzzh@clip",
                "Flag L Car Hold No Pole",
                animationOptions = {
                    prop = 'prop_flag_japan_s',
                    propBone = 24818,
                    propPlacement = {
                        0.660,
                        -0.02,
                        0.020,
                        -164.0023,
                        0.961,
                        0.2756
                    },
                    emoteLoop = true,
                    Flag = 1
                }
            },
            ["flagzzzh2"] = {
                "pazeee@flagzzzh2@animations",
                "pazeee@flagzzzh2@clip",
                "Flag L Car Hold No Pole V2",
                animationOptions = {
                    prop = 'prop_flag_ireland_s',
                    propBone = 24818,
                    propPlacement = {
                        0.660,
                        -0.02,
                        0.020,
                        -164.0023,
                        0.961,
                        0.2756
                    },
                    emoteLoop = true,
                    Flag = 1
                }
            },
            ["flagzzzi"] = {
                "pazeee@flagzzzi@animations",
                "pazeee@flagzzzi@clip",
                "Flag R Car Wave Roof Fast",
                animationOptions = {
                    prop = "prop_fnccorgm_02pole",
                    propBone = 57005,
                    propPlacement = {
                        0.0,
                        -0.20,
                        -0.090,
                        -69.875,
                        6.757,
                        -18.867
                    },
                    secondProp = 'prop_flag_canada',
                    secondPropBone = 57005,
                    secondPropPlacement = {
                        0.520,
                        1.160,
                        0.370,
                        -69.875,
                        6.757,
                        -18.867
                    },
                    emoteLoop = true,
                    Flag = 1
                }
            },
            ["flagzzzi2"] = {
                "pazeee@flagzzzi2@animations",
                "pazeee@flagzzzi2@clip",
                "Flag R Car Wave Roof Fast V2",
                animationOptions = {
                    prop = "prop_fnccorgm_02pole",
                    propBone = 57005,
                    propPlacement = {
                        0.0,
                        -0.20,
                        -0.090,
                        -69.875,
                        6.757,
                        -18.867
                    },
                    secondProp = 'apa_prop_flag_brazil',
                    secondPropBone = 57005,
                    secondPropPlacement = {
                        0.520,
                        1.160,
                        0.370,
                        -69.875,
                        6.757,
                        -18.867
                    },
                    emoteLoop = true,
                    Flag = 1
                }
            },
            ["flagzzzj"] = {
                "pazeee@flagzzzj@animations",
                "pazeee@flagzzzj@clip",
                "Flag L Car Wave Roof Fast",
                animationOptions = {
                    prop = "prop_fnccorgm_02pole",
                    propBone = 57005,
                    propPlacement = {
                        0.0,
                        -0.20,
                        -0.090,
                        -69.875,
                        6.757,
                        -18.867
                    },
                    secondProp = 'apa_prop_flag_france',
                    secondPropBone = 57005,
                    secondPropPlacement = {
                        0.520,
                        1.160,
                        0.370,
                        -69.875,
                        6.757,
                        -18.867
                    },
                    emoteLoop = true,
                    Flag = 1
                }
            },
            ["flagzzzj2"] = {
                "pazeee@flagzzzj2@animations",
                "pazeee@flagzzzj2@clip",
                "Flag L Car Wave Roof Fast V2",
                animationOptions = {
                    prop = "prop_fnccorgm_02pole",
                    propBone = 57005,
                    propPlacement = {
                        0.0,
                        -0.20,
                        -0.090,
                        -69.875,
                        6.757,
                        -18.867
                    },
                    secondProp = 'apa_prop_flag_belgium',
                    secondPropBone = 57005,
                    secondPropPlacement = {
                        0.520,
                        1.160,
                        0.370,
                        -69.875,
                        6.757,
                        -18.867
                    },
                    emoteLoop = true,
                    Flag = 1
                }
            },
            ["flagzzzk"] = {
                "pazeee@flagzzzk@animations",
                "pazeee@flagzzzk@clip",
                "Flag R Car Wave Roof Slow",
                animationOptions = {
                    prop = "prop_fnccorgm_02pole",
                    propBone = 57005,
                    propPlacement = {
                        0.0,
                        -0.20,
                        -0.090,
                        -69.875,
                        6.757,
                        -18.867
                    },
                    secondProp = 'apa_prop_flag_italy',
                    secondPropBone = 57005,
                    secondPropPlacement = {
                        0.520,
                        1.160,
                        0.370,
                        -69.875,
                        6.757,
                        -18.867
                    },
                    emoteLoop = true,
                    Flag = 1
                }
            },
            ["flagzzzk2"] = {
                "pazeee@flagzzzk2@animations",
                "pazeee@flagzzzk2@clip",
                "Flag R Car Wave Roof Slow V2",
                animationOptions = {
                    prop = "prop_fnccorgm_02pole",
                    propBone = 57005,
                    propPlacement = {
                        0.0,
                        -0.20,
                        -0.090,
                        -69.875,
                        6.757,
                        -18.867
                    },
                    secondProp = 'prop_flag_german',
                    secondPropBone = 57005,
                    secondPropPlacement = {
                        0.520,
                        1.160,
                        0.370,
                        -69.875,
                        6.757,
                        -18.867
                    },
                    emoteLoop = true,
                    Flag = 1
                }
            },
            ["flagzzzl"] = {
                "pazeee@flagzzzl@animations",
                "pazeee@flagzzzl@clip",
                "Flag L Car Wave Roof Slow",
                animationOptions = {
                    prop = "prop_fnccorgm_02pole",
                    propBone = 57005,
                    propPlacement = {
                        0.0,
                        -0.20,
                        -0.090,
                        -69.875,
                        6.757,
                        -18.867
                    },
                    secondProp = 'apa_prop_flag_china',
                    secondPropBone = 57005,
                    secondPropPlacement = {
                        0.520,
                        1.160,
                        0.370,
                        -69.875,
                        6.757,
                        -18.867
                    },
                    emoteLoop = true,
                    Flag = 1
                }
            },
            ["flagzzzl2"] = {
                "pazeee@flagzzzl2@animations",
                "pazeee@flagzzzl2@clip",
                "Flag L Car Wave Roof Slow V2",
                animationOptions = {
                    prop = "prop_fnccorgm_02pole",
                    propBone = 57005,
                    propPlacement = {
                        0.0,
                        -0.20,
                        -0.090,
                        -69.875,
                        6.757,
                        -18.867
                    },
                    secondProp = 'apa_prop_flag_australia',
                    secondPropBone = 57005,
                    secondPropPlacement = {
                        0.520,
                        1.160,
                        0.370,
                        -69.875,
                        6.757,
                        -18.867
                    },
                    emoteLoop = true,
                    Flag = 1
                }
            },
            ["flagzzzm"] = {
                "pazeee@flagzzzm@animations",
                "pazeee@flagzzzm@clip",
                "Flag R Car Wave Sit",
                animationOptions = {
                    prop = "a3d_pole",
                    propBone = 57005,
                    propPlacement = {
                        0.03,
                        -0.140,
                        -0.070,
                        -70.00,
                        0.0,
                        -20.0
                    },
                    secondProp = 'prop_flag_scotland_s',
                    secondPropBone = 57005,
                    secondPropPlacement = {
                        0.460,
                        1.050,
                        0.380,
                        -70.00,
                        0.0,
                        -20.0
                    },
                    emoteLoop = true,
                    Flag = 1
                }
            },
            ["flagzzzm2"] = {
                "pazeee@flagzzzm2@animations",
                "pazeee@flagzzzm2@clip",
                "Flag R Car Wave Sit V2",
                animationOptions = {
                    prop = "a3d_pole",
                    propBone = 57005,
                    propPlacement = {
                        0.03,
                        -0.140,
                        -0.070,
                        -70.00,
                        0.0,
                        -20.0
                    },
                    secondProp = 'prop_flag_lsservices_s',
                    secondPropBone = 57005,
                    secondPropPlacement = {
                        0.460,
                        1.050,
                        0.380,
                        -70.00,
                        0.0,
                        -20.0
                    },
                    emoteLoop = true,
                    Flag = 1
                }
            },
            ["flagzzzn"] = {
                "pazeee@flagzzzn@animations",
                "pazeee@flagzzzn@clip",
                "Flag L Car Wave Sit",
                animationOptions = {
                    prop = "a3d_pole",
                    propBone = 57005,
                    propPlacement = {
                        0.03,
                        -0.140,
                        -0.070,
                        -70.00,
                        0.0,
                        -20.0
                    },
                    secondProp = 'prop_flag_russia_s',
                    secondPropBone = 57005,
                    secondPropPlacement = {
                        0.460,
                        1.050,
                        0.380,
                        -70.00,
                        0.0,
                        -20.0
                    },
                    emoteLoop = true,
                    Flag = 1
                }
            },
            ["flagzzzn2"] = {
                "pazeee@flagzzzn2@animations",
                "pazeee@flagzzzn2@clip",
                "Flag L Car Wave Sit V2",
                animationOptions = {
                    prop = "a3d_pole",
                    propBone = 57005,
                    propPlacement = {
                        0.03,
                        -0.140,
                        -0.070,
                        -70.00,
                        0.0,
                        -20.0
                    },
                    secondProp = 'prop_flag_uk_s',
                    secondPropBone = 57005,
                    secondPropPlacement = {
                        0.460,
                        1.050,
                        0.380,
                        -70.00,
                        0.0,
                        -20.0
                    },
                    emoteLoop = true,
                    Flag = 1
                }
            },
            ["flagzzzo"] = {
                "pazeee@flagzzzo@animations",
                "pazeee@flagzzzo@clip",
                "Flag R Car Wave Sit Big",
                animationOptions = {
                    prop = "prop_fnccorgm_02pole",
                    propBone = 57005,
                    propPlacement = {
                        0.0,
                        -0.20,
                        -0.090,
                        -69.875,
                        6.757,
                        -18.867
                    },
                    secondProp = 'apa_prop_flag_brazil',
                    secondPropBone = 57005,
                    secondPropPlacement = {
                        0.520,
                        1.160,
                        0.370,
                        -69.875,
                        6.757,
                        -18.867
                    },
                    emoteLoop = true,
                    Flag = 1
                }
            },
            ["flagzzzo2"] = {
                "pazeee@flagzzzo2@animations",
                "pazeee@flagzzzo2@clip",
                "Flag R Car Wave Sit Big V2",
                animationOptions = {
                    prop = "prop_fnccorgm_02pole",
                    propBone = 57005,
                    propPlacement = {
                        0.0,
                        -0.20,
                        -0.090,
                        -69.875,
                        6.757,
                        -18.867
                    },
                    secondProp = 'prop_flag_sapd',
                    secondPropBone = 57005,
                    secondPropPlacement = {
                        0.520,
                        1.160,
                        0.370,
                        -69.875,
                        6.757,
                        -18.867
                    },
                    emoteLoop = true,
                    Flag = 1
                }
            },
            ["flagzzzp"] = {
                "pazeee@flagzzzp@animations",
                "pazeee@flagzzzp@clip",
                "Flag L Car Wave Sit Big",
                animationOptions = {
                    prop = "prop_fnccorgm_02pole",
                    propBone = 57005,
                    propPlacement = {
                        0.0,
                        -0.20,
                        -0.090,
                        -69.875,
                        6.757,
                        -18.867
                    },
                    secondProp = 'prop_flag_lsfd',
                    secondPropBone = 57005,
                    secondPropPlacement = {
                        0.520,
                        1.160,
                        0.370,
                        -69.875,
                        6.757,
                        -18.867
                    },
                    emoteLoop = true,
                    Flag = 1
                }
            },
            ["flagzzzp2"] = {
                "pazeee@flagzzzp2@animations",
                "pazeee@flagzzzp2@clip",
                "Flag L Car Wave Sit Big V2",
                animationOptions = {
                    prop = "prop_fnccorgm_02pole",
                    propBone = 57005,
                    propPlacement = {
                        0.0,
                        -0.20,
                        -0.090,
                        -69.875,
                        6.757,
                        -18.867
                    },
                    secondProp = 'apa_prop_flag_italy',
                    secondPropBone = 57005,
                    secondPropPlacement = {
                        0.520,
                        1.160,
                        0.370,
                        -69.875,
                        6.757,
                        -18.867
                    },
                    emoteLoop = true,
                    Flag = 1
                }
            },
            ["flagzzzq"] = {
                "pazeee@flagzzzq@animations",
                "pazeee@flagzzzq@clip",
                "Flag R Wave Open Door / Heli",
                animationOptions = {
                    prop = "prop_fnccorgm_02pole",
                    propBone = 57005,
                    propPlacement = {
                        0.0,
                        -0.20,
                        -0.090,
                        -69.875,
                        6.757,
                        -18.867
                    },
                    secondProp = 'apa_prop_flag_turkey',
                    secondPropBone = 57005,
                    secondPropPlacement = {
                        0.520,
                        1.160,
                        0.370,
                        -69.875,
                        6.757,
                        -18.867
                    },
                    emoteLoop = true,
                    Flag = 1
                }
            },
            ["flagzzzr"] = {
                "pazeee@flagzzzr@animations",
                "pazeee@flagzzzr@clip",
                "Flag L Wave Open Door / Heli",
                animationOptions = {
                    prop = "prop_fnccorgm_02pole",
                    propBone = 57005,
                    propPlacement = {
                        0.0,
                        -0.20,
                        -0.090,
                        -69.875,
                        6.757,
                        -18.867
                    },
                    secondProp = 'apa_prop_flag_argentina',
                    secondPropBone = 57005,
                    secondPropPlacement = {
                        0.520,
                        1.160,
                        0.370,
                        -69.875,
                        6.757,
                        -18.867
                    },
                    emoteLoop = true,
                    Flag = 1
                }
            },
            ["trophycupa"] = {
                "pazeee@trophycupa@animations",
                "pazeee@trophycupa@clip",
                "Trophy Cup Leader Celebration",
                animationOptions = {
                    prop = "xs_prop_trophy_cup_01a",
                    propBone = 18905,
                    propPlacement = {
                        0.01,
                        -0.130,
                        0.070,
                        -119.7605,
                        -46.523,
                        -7.253
                    },
                    emoteLoop = true
                }
            },
            ["trophycupb"] = {
                "pazeee@trophycupb@animations",
                "pazeee@trophycupb@clip",
                "Trophy Cup Leader Celebration Move",
                animationOptions = {
                    prop = "xs_prop_trophy_cup_01a",
                    propBone = 18905,
                    propPlacement = {
                        0.01,
                        -0.130,
                        0.070,
                        -119.7605,
                        -46.523,
                        -7.253
                    },
                    emoteLoop = true,
                    emoteMoving = true
                }
            },
            ["trophycupi"] = {
                "pazeee@trophycupi@animations",
                "pazeee@trophycupi@clip",
                "Trophy Cup Hug",
                animationOptions = {
                    prop = "xs_prop_trophy_cup_01a",
                    propBone = 18905,
                    propPlacement = {
                        0.18,
                        -0.560,
                        0.150,
                        -90.0,
                        -150.0,
                        -10.0
                    },
                    emoteLoop = true,
                    emoteMoving = true
                }
            },
            ["trophycupj"] = {
                "pazeee@trophycupj@animations",
                "pazeee@trophycupj@clip",
                "Trophy Cup Show The World!",
                animationOptions = {
                    prop = "xs_prop_trophy_cup_01a",
                    propBone = 18905,
                    propPlacement = {
                        -0.14,
                        -0.30,
                        0.070,
                        -132.898,
                        -84.342,
                        -31.149
                    },
                    emoteLoop = true,
                    emoteMoving = true
                }
            },
            ["trophycupk"] = {
                "pazeee@trophycupk@animations",
                "pazeee@trophycupk@clip",
                "Trophy Cup Head",
                animationOptions = {
                    prop = "xs_prop_trophy_cup_01a",
                    propBone = 24818,
                    propPlacement = {
                        0.52,
                        0.070,
                        0.0,
                        0.0,
                        90.0,
                        0.0
                    },
                    emoteLoop = true,
                    emoteMoving = true
                }
            },
            ["trophycupl"] = {
                "pazeee@trophycupl@animations",
                "pazeee@trophycupl@clip",
                "Trophy Cup Double Champions",
                animationOptions = {
                    prop = "xs_prop_trophy_cup_01a",
                    propBone = 18905,
                    propPlacement = {
                        0.01,
                        -0.130,
                        0.070,
                        -119.7605,
                        -46.523,
                        -7.253
                    },
                    secondProp = 'xs_prop_trophy_cup_01a',
                    secondPropBone = 57005,
                    secondPropPlacement = {
                        0.030,
                        -0.160,
                        -0.090,
                        -60.479,
                        29.5201,
                        -2.083
                    },
                    emoteLoop = true,
                    emoteMoving = true
                }
            },
            ["trophycupm"] = {
                "pazeee@trophycupm@animations",
                "pazeee@trophycupm@clip",
                "Mexican Wave With Chair",
                animationOptions = {
                    prop = "v_ilev_chair02_ped",
                    propBone = 52301,
                    propPlacement = {
                        -0.48,
                        0.270,
                        0.09,
                        -103.262,
                        117.992,
                        -12.304
                    },
                    emoteLoop = true
                }
            },
        },
        Shared = {
            ["flagzzc"] = {
                "pazeee@flagzzc@animations",
                "pazeee@flagzzc@clip",
                "Flag Hold Giant Together 1",
                "flagzzd",
                animationOptions = {
                    syncOffsetFront = 0.9,
                    prop = "stt_prop_flagpole_1a",
                    propBone = 57005,
                    propPlacement = {
                        -0.79,
                        -1.130,
                        -0.420,
                        -69.052,
                        12.424,
                        -35.135
                    },
                    emoteLoop = true
                }
            },
            ["flagzzd"] = {
                "pazeee@flagzzd@animations",
                "pazeee@flagzzd@clip",
                "Flag Hold Giant Together 2",
                "flagzzd",
                animationOptions = {
                    syncOffsetFront = 0.9,
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
