Citizen.CreateThread(function()
    if not Config.Creators['Pazeee_CarryFunnyEmotePack'] then return end
    
    local Animations = {
        Dances = {},

        Shared = {
            ["pcarrya1"] = {
                "pcarrya1@animations",
                "pcarrya1clip",
                "PCarry 1 Shoulder Covering Eyes",
                "pcarrya2",
                animationOptions = {
                    emoteMoving = true,
                    emoteLoop = true
                }
            },
            ["pcarrya2"] = {
                "pcarrya2@animations",
                "pcarrya2clip",
                "PCarry 2 Shoulder Covering Eyes",
                "pcarrya1",
                animationOptions = {
                    emoteMoving = false,
                    emoteLoop = true,
                    attachTo = true,
                    bone = 24818,
                    xPos = 0.000,
                    yPos = 0.000,
                    zPos = 0.000,
                    xRot = 0.000,
                    yRot = 0.000,
                    zRot = 0.000
                }
            },
            ["pcarryb1"] = {
                "pcarryb1@animations",
                "pcarryb1clip",
                "PCarry 1 Struggle Behind",
                "pcarryb2",
                animationOptions = {
                    emoteMoving = true,
                    emoteLoop = true
                }
            },
            ["pcarryb2"] = {
                "pcarryb2@animations",
                "pcarryb2clip",
                "PCarry 2 Struggle Behind",
                "pcarryb1",
                animationOptions = {
                    emoteMoving = false,
                    emoteLoop = true,
                    attachTo = true,
                    bone = 24818,
                    xPos = 0.000,
                    yPos = 0.000,
                    zPos = 0.000,
                    xRot = 0.000,
                    yRot = 0.000,
                    zRot = 0.000
                }
            },
            ["pcarryc1"] = {
                "pcarryc1@animations",
                "pcarryc1clip",
                "PCarry 1 Dead Behind",
                "pcarryc2",
                animationOptions = {
                    emoteMoving = true,
                    emoteLoop = true
                }
            },
            ["pcarryc2"] = {
                "pcarryc2@animations",
                "pcarryc2clip",
                "PCarry 2 Dead Behind",
                "pcarryc1",
                animationOptions = {
                    emoteMoving = false,
                    emoteLoop = true,
                    attachTo = true,
                    bone = 24818,
                    xPos = -0.360,
                    yPos = 0.000,
                    zPos = -0.020,
                    xRot = 0.0,
                    yRot = 0.0,
                    zRot = -10.0
                }
            },
            ["pcarryd1"] = {
                "pcarryd1@animations",
                "pcarryd1clip",
                "PCarry 1 Firemans Shoulder",
                "pcarryd2",
                animationOptions = {
                    emoteMoving = true,
                    emoteLoop = true
                }
            },
            ["pcarryd2"] = {
                "pcarryd2@animations",
                "pcarryd2clip",
                "PCarry 2 Firemans Shoulder",
                "pcarryd1",
                animationOptions = {
                    emoteMoving = false,
                    emoteLoop = true,
                    attachTo = true,
                    bone = 24818,
                    xPos = -0.120,
                    yPos = -0.150,
                    zPos = -0.050,
                    xRot = 0.000,
                    yRot = 0.000,
                    zRot = -3.000
                }
            },
            ["pcarrye1"] = {
                "pcarrye1@animations",
                "pcarrye1clip",
                "PCarry 1 Standing Shoulder",
                "pcarrye2",
                animationOptions = {
                    emoteMoving = true,
                    emoteLoop = true
                }
            },
            ["pcarrye2"] = {
                "pcarrye2@animations",
                "pcarrye2clip",
                "PCarry 2 Standing Shoulder",
                "pcarrye1",
                animationOptions = {
                    emoteMoving = false,
                    emoteLoop = true,
                    attachTo = true,
                    bone = 24818,
                    xPos = 1.230,
                    yPos = 0.020,
                    zPos = 0.000,
                    xRot = 0.000,
                    yRot = 0.000,
                    zRot = 0.000
                }
            },
            ["pcarryf1"] = {
                "pcarryf1@animations",
                "pcarryf1clip",
                "PCarry 1 Meditation Feet On Head",
                "pcarryf2",
                animationOptions = {
                    emoteMoving = true,
                    emoteLoop = true
                }
            },
            ["pcarryf2"] = {
                "pcarryf2@animations",
                "pcarryf2clip",
                "PCarry 2 Meditation Feet On Head",
                "pcarryf1",
                animationOptions = {
                    emoteMoving = false,
                    emoteLoop = true,
                    attachTo = true,
                    bone = 24818,
                    xPos = 1.230,
                    yPos = 0.020,
                    zPos = 0.000,
                    xRot = 0.000,
                    yRot = 0.000,
                    zRot = 0.000
                }
            },
            ["pcarryg1"] = {
                "pcarryg1@animations",
                "pcarryg1clip",
                "PCarry 1 Superman",
                "pcarryg2",
                animationOptions = {
                    emoteMoving = true,
                    emoteLoop = true
                }
            },
            ["pcarryg2"] = {
                "pcarryg2@animations",
                "pcarryg2clip",
                "PCarry 2 Superman",
                "pcarryg1",
                animationOptions = {
                    emoteMoving = false,
                    emoteLoop = true,
                    attachTo = true,
                    bone = 24818,
                    xPos = 0.850,
                    yPos = -0.120,
                    zPos = -0.020,
                    xRot = 0.000,
                    yRot = 0.000,
                    zRot = 0.000
                }
            },
            ["pcarryh1"] = {
                "pcarryh1@animations",
                "pcarryh1clip",
                "PCarry 1 Cute Shoulder Back",
                "pcarryh2",
                animationOptions = {
                    emoteMoving = true,
                    emoteLoop = true
                }
            },
            ["pcarryh2"] = {
                "pcarryh2@animations",
                "pcarryh2clip",
                "PCarry 2 Cute Shoulder Back",
                "pcarryh1",
                animationOptions = {
                    emoteMoving = false,
                    emoteLoop = true,
                    attachTo = true,
                    bone = 24818,
                    xPos = -0.130,
                    yPos = -0.130,
                    zPos = -0.050,
                    xRot = 0.000,
                    yRot = 0.000,
                    zRot = 0.000
                }
            },
            ["pcarryi1"] = {
                "pcarryi1@animations",
                "pcarryi1clip",
                "PCarry 1 Bird",
                "pcarryi2",
                animationOptions = {
                    emoteMoving = true,
                    emoteLoop = true
                }
            },
            ["pcarryi2"] = {
                "pcarryi2@animations",
                "pcarryi2clip",
                "PCarry 2 Bird",
                "pcarryi1",
                animationOptions = {
                    emoteMoving = false,
                    emoteLoop = true,
                    attachTo = true,
                    bone = 24818,
                    xPos = 0.700,
                    yPos = -0.330,
                    zPos = 0.000,
                    xRot = 0.000,
                    yRot = 0.000,
                    zRot = -15.000
                }
            },
            ["pcarryj1"] = {
                "pcarryj1@animations",
                "pcarryj1clip",
                "PCarry 1 Woohoo",
                "pcarryj2",
                animationOptions = {
                    emoteMoving = true,
                    emoteLoop = true
                }
            },
            ["pcarryj2"] = {
                "pcarryj2@animations",
                "pcarryj2clip",
                "PCarry 2 Woohoo",
                "pcarryj1",
                animationOptions = {
                    emoteMoving = false,
                    emoteLoop = true,
                    attachTo = true,
                    bone = 24818,
                    xPos = 0.350,
                    yPos = -0.490,
                    zPos = 0.000,
                    xRot = 0.000,
                    yRot = 0.000,
                    zRot = -30.000
                }
            },
            ["pcarryk1"] = {
                "pcarryk1@animations",
                "pcarryk1clip",
                "PCarry 1 Sad Curl Up",
                "pcarryk2",
                animationOptions = {
                    emoteMoving = true,
                    emoteLoop = true
                }
            },
            ["pcarryk2"] = {
                "pcarryk2@animations",
                "pcarryk2clip",
                "PCarry 2 Sad Curl Up",
                "pcarryk1",
                animationOptions = {
                    emoteMoving = false,
                    emoteLoop = true,
                    attachTo = true,
                    bone = 24818,
                    xPos = 0.060,
                    yPos = 0.100,
                    zPos = 0.000,
                    xRot = 0.000,
                    yRot = 0.000,
                    zRot = 0.000
                }
            },
            ["pcarryl1"] = {
                "pcarryl1@animations",
                "pcarryl1clip",
                "PCarry 1 Sad Front",
                "pcarryl2",
                animationOptions = {
                    emoteMoving = true,
                    emoteLoop = true
                }
            },
            ["pcarryl2"] = {
                "pcarryl2@animations",
                "pcarryl2clip",
                "PCarry 2 Sad Front",
                "pcarryl1",
                animationOptions = {
                    emoteMoving = false,
                    emoteLoop = true,
                    attachTo = true,
                    bone = 24818,
                    xPos = 0.050,
                    yPos = 0.070,
                    zPos = 0.020,
                    xRot = 0.000,
                    yRot = 0.000,
                    zRot = 0.000
                }
            },
            ["pcarrym1"] = {
                "pcarrym1@animations",
                "pcarrym1clip",
                "PCarry 1 Standing Upside Down",
                "pcarrym2",
                animationOptions = {
                    emoteMoving = true,
                    emoteLoop = true
                }
            },
            ["pcarrym2"] = {
                "pcarrym2@animations",
                "pcarrym2clip",
                "PCarry 2 Standing Upside Down",
                "pcarrym1",
                animationOptions = {
                    emoteMoving = false,
                    emoteLoop = true,
                    attachTo = true,
                    bone = 24818,
                    xPos = 1.820,
                    yPos = 0.150,
                    zPos = -0.020,
                    xRot = 0.000,
                    yRot = 0.000,
                    zRot = 5.000
                }
            },
            ["pcarryn1"] = {
                "pcarryn1@animations",
                "pcarryn1clip",
                "PCarry 1 Salute",
                "pcarryn2",
                animationOptions = {
                    emoteMoving = true,
                    emoteLoop = true
                }
            },
            ["pcarryn2"] = {
                "pcarryn2@animations",
                "pcarryn2clip",
                "PCarry 2 Salute",
                "pcarryn1",
                animationOptions = {
                    emoteMoving = false,
                    emoteLoop = true,
                    attachTo = true,
                    bone = 24818,
                    xPos = 1.230,
                    yPos = 0.020,
                    zPos = 0.000,
                    xRot = 0.000,
                    yRot = 0.000,
                    zRot = 0.000
                }
            },
            ["pcarryo1"] = {
                "pcarryo1@animations",
                "pcarryo1clip",
                "PCarry 1 Arrogant",
                "pcarryo2",
                animationOptions = {
                    emoteMoving = true,
                    emoteLoop = true
                }
            },
            ["pcarryo2"] = {
                "pcarryo2@animations",
                "pcarryo2clip",
                "PCarry 2 Arrogant",
                "pcarryo1",
                animationOptions = {
                    emoteMoving = false,
                    emoteLoop = true,
                    attachTo = true,
                    bone = 24818,
                    xPos = 0.550,
                    yPos = 0.010,
                    zPos = 0.000,
                    xRot = 0.000,
                    yRot = 0.000,
                    zRot = 0.000
                }
            },
            ["pcarryp1"] = {
                "pcarryp1@animations",
                "pcarryp1clip",
                "PCarry 1 Dab",
                "pcarryp2",
                animationOptions = {
                    emoteMoving = true,
                    emoteLoop = true
                }
            },
            ["pcarryp2"] = {
                "pcarryp2@animations",
                "pcarryp2clip",
                "PCarry 2 Dab",
                "pcarryp1",
                animationOptions = {
                    emoteMoving = false,
                    emoteLoop = true,
                    attachTo = true,
                    bone = 24818,
                    xPos = 0.550,
                    yPos = 0.010,
                    zPos = 0.000,
                    xRot = 0.000,
                    yRot = 0.000,
                    zRot = 0.000
                }
            },
            ["pcarryq1"] = {
                "pcarryq1@animations",
                "pcarryq1clip",
                "PCarry 1 Bull Meditation",
                "pcarryq2",
                animationOptions = {
                    emoteMoving = true,
                    emoteLoop = true
                }
            },
            ["pcarryq2"] = {
                "pcarryq2@animations",
                "pcarryq2clip",
                "PCarry 2 Bull Meditation",
                "pcarryq1",
                animationOptions = {
                    emoteMoving = false,
                    emoteLoop = true,
                    attachTo = true,
                    bone = 24818,
                    xPos = -0.200,
                    yPos = -0.500,
                    zPos = 0.000,
                    xRot = 0.000,
                    yRot = 0.000,
                    zRot = -80.000
                }
            },
            ["pcarryr1"] = {
                "pcarryr1@animations",
                "pcarryr1clip",
                "PCarry 1 Cute Shy Shoulder",
                "pcarryr2",
                animationOptions = {
                    emoteMoving = true,
                    emoteLoop = true
                }
            },
            ["pcarryr2"] = {
                "pcarryr2@animations",
                "pcarryr2clip",
                "PCarry 2 Cute Shy Shoulder",
                "pcarryr1",
                animationOptions = {
                    emoteMoving = false,
                    emoteLoop = true,
                    attachTo = true,
                    bone = 24818,
                    xPos = -0.070,
                    yPos = -0.100,
                    zPos = -0.280,
                    xRot = 0.000,
                    yRot = 0.000,
                    zRot = 0.000
                }
            },
            ["pcarrys1"] = {
                "pcarrys1@animations",
                "pcarrys1clip",
                "PCarry 2 Sleep Over Head",
                "pcarrys2",
                animationOptions = {
                    emoteMoving = true,
                    emoteLoop = true
                }
            },
            ["pcarrys2"] = {
                "pcarrys2@animations",
                "pcarrys2clip",
                "PCarry 2 Sleep Over Head",
                "pcarrys1",
                animationOptions = {
                    emoteMoving = false,
                    emoteLoop = true,
                    attachTo = true,
                    bone = 24818,
                    xPos = 0.880,
                    yPos = 0.000,
                    zPos = -0.080,
                    xRot = 0.000,
                    yRot = 0.000,
                    zRot = 0.000
                }
            },
            ["pcarryt1"] = {
                "pcarryt1@animations",
                "pcarryt1clip",
                "PCarry 1 Riding Motorcycle",
                "pcarryt2",
                animationOptions = {
                    emoteMoving = true,
                    emoteLoop = true
                }
            },
            ["pcarryt2"] = {
                "pcarryt2@animations",
                "pcarryt2clip",
                "PCarry 2 Riding Motorcycle",
                "pcarryt1",
                animationOptions = {
                    emoteMoving = false,
                    emoteLoop = true,
                    attachTo = true,
                    bone = 24818,
                    xPos = 0.520,
                    yPos = 0.030,
                    zPos = -0.010,
                    xRot = 0.000,
                    yRot = 0.000,
                    zRot = 0.000
                }
            },
            ["pcarryu1"] = {
                "pcarryu1@animations",
                "pcarryu1clip",
                "PCarry 1 Cute Sit Shoulder",
                "pcarryu2",
                animationOptions = {
                    emoteMoving = true,
                    emoteLoop = true
                }
            },
            ["pcarryu2"] = {
                "pcarryu2@animations",
                "pcarryu2clip",
                "PCarry 2 Cute Sit Shoulder",
                "pcarryu1",
                animationOptions = {
                    emoteMoving = false,
                    emoteLoop = true,
                    attachTo = true,
                    bone = 24818,
                    xPos = 0.290,
                    yPos = 0.040,
                    zPos = -0.220,
                    xRot = 0.000,
                    yRot = 0.000,
                    zRot = 0.000
                }
            },
            ["pcarryv1"] = {
                "pcarryv1@animations",
                "pcarryv1clip",
                "PCarry 1 Pull Head Back",
                "pcarryv2",
                animationOptions = {
                    emoteMoving = true,
                    emoteLoop = true
                }
            },
            ["pcarryv2"] = {
                "pcarryv2@animations",
                "pcarryv2clip",
                "PCarry 2 Pull Head Back",
                "pcarryv1",
                animationOptions = {
                    emoteMoving = false,
                    emoteLoop = true,
                    attachTo = true,
                    bone = 24818,
                    xPos = -0.340,
                    yPos = -0.180,
                    zPos = 0.150,
                    xRot = 0.000,
                    yRot = 0.000,
                    zRot = 50.000
                }
            },
            ["pcarryw1"] = {
                "pcarryw1@animations",
                "pcarryw1clip",
                "PCarry 1 Disgusting",
                "pcarryw2",
                animationOptions = {
                    emoteMoving = true,
                    emoteLoop = true
                }
            },
            ["pcarryw2"] = {
                "pcarryw2@animations",
                "pcarryw2clip",
                "PCarry 2 Disgusting",
                "pcarryw1",
                animationOptions = {
                    emoteMoving = false,
                    emoteLoop = true,
                    attachTo = true,
                    bone = 28422,
                    xPos = 0.000,
                    yPos = -0.140,
                    zPos = -0.410,
                    xRot = 0.000,
                    yRot = 0.000,
                    zRot = 0.000
                }
            },
            ["pcarryx1"] = {
                "pcarryx1@animations",
                "pcarryx1clip",
                "PCarry 1 Caught",
                "pcarryx2",
                animationOptions = {
                    emoteMoving = true,
                    emoteLoop = true
                }
            },
            ["pcarryx2"] = {
                "pcarryx2@animations",
                "pcarryx2clip",
                "PCarry 2 Caught",
                "pcarryx1",
                animationOptions = {
                    emoteMoving = false,
                    emoteLoop = true,
                    attachTo = true,
                    bone = 28422,
                    xPos = 0.250,
                    yPos = -0.200,
                    zPos = 0.130,
                    xRot = 0.000,
                    yRot = 0.000,
                    zRot = 0.000
                }
            },
            ["pcarryy1"] = {
                "pcarryy1@animations",
                "pcarryy1clip",
                "PCarry 1 Torture",
                "pcarryy2",
                animationOptions = {
                    emoteMoving = true,
                    emoteLoop = true
                }
            },
            ["pcarryy2"] = {
                "pcarryy2@animations",
                "pcarryy2clip",
                "PCarry 2 Torture",
                "pcarryy1",
                animationOptions = {
                    emoteMoving = false,
                    emoteLoop = true,
                    attachTo = true,
                    bone = 28422,
                    xPos = 0.240,
                    yPos = -0.560,
                    zPos = 0.750,
                    xRot = 0.000,
                    yRot = 0.000,
                    zRot = -160.000
                }
            },
            ["pcarryz1"] = {
                "pcarryz1@animations",
                "pcarryz1clip",
                "PCarry 1 Bazoka",
                "pcarryz2",
                animationOptions = {
                    emoteMoving = true,
                    emoteLoop = true
                }
            },
            ["pcarryz2"] = {
                "pcarryz2@animations",
                "pcarryz2clip",
                "PCarry 2 Bazoka",
                "pcarryz1",
                animationOptions = {
                    emoteMoving = false,
                    emoteLoop = true,
                    attachTo = true,
                    bone = 57005,
                    xPos = 0.020,
                    yPos = 0.190,
                    zPos = -0.220,
                    xRot = 0.0,
                    yRot = 0.0,
                    zRot = -79.999
                }
            },
            ["pcarryza1"] = {
                "pcarryza1@animations",
                "pcarryza1clip",
                "PCarry 1 Drunk Behind",
                "pcarryza2",
                animationOptions = {
                    emoteMoving = true,
                    emoteLoop = true
                }
            },
            ["pcarryza2"] = {
                "pcarryza2@animations",
                "pcarryza2clip",
                "PCarry 2 Drunk Behind",
                "pcarryza1",
                animationOptions = {
                    emoteMoving = false,
                    emoteLoop = true,
                    attachTo = true,
                    bone = 24818,
                    xPos = -0.560,
                    yPos = 0.030,
                    zPos = 0.000,
                    xRot = 0.000,
                    yRot = 0.000,
                    zRot = 0.000
                }
            },
            ["pcarryzb1"] = {
                "pcarryzb1@animations",
                "pcarryzb1clip",
                "PCarry 1 Peek High",
                "pcarryzb2",
                animationOptions = {
                    emoteMoving = true,
                    emoteLoop = true
                }
            },
            ["pcarryzb2"] = {
                "pcarryzb2@animations",
                "pcarryzb2clip",
                "PCarry 2 Peek High",
                "pcarryzb1",
                animationOptions = {
                    emoteMoving = false,
                    emoteLoop = true,
                    attachTo = true,
                    bone = 24818,
                    xPos = 1.943,
                    yPos = -0.010,
                    zPos = -0.024,
                    xRot = 0.000,
                    yRot = 0.000,
                    zRot = 0.000
                }
            },
            ["pcarryzc1"] = {
                "pcarryzc1@animations",
                "pcarryzc1clip",
                "PCarry 1 Meditation Master",
                "pcarryzc2",
                animationOptions = {
                    emoteMoving = true,
                    emoteLoop = true
                }
            },
            ["pcarryzc2"] = {
                "pcarryzc2@animations",
                "pcarryzc2clip",
                "PCarry 2 Meditation Master",
                "pcarryzc1",
                animationOptions = {
                    emoteMoving = false,
                    emoteLoop = true,
                    attachTo = true,
                    bone = 24818,
                    xPos = 1.160,
                    yPos = 0.020,
                    zPos = -0.020,
                    xRot = 0.000,
                    yRot = 0.000,
                    zRot = 0.000
                }
            },
            ["pcarryzd1"] = {
                "pcarryzd1@animations",
                "pcarryzd1clip",
                "PCarry 1 Strongman",
                "pcarryzd2",
                animationOptions = {
                    emoteMoving = true,
                    emoteLoop = true
                }
            },
            ["pcarryzd2"] = {
                "pcarryzd2@animations",
                "pcarryzd2clip",
                "PCarry 2 Strongman",
                "pcarryzd1",
                animationOptions = {
                    emoteMoving = false,
                    emoteLoop = true,
                    attachTo = true,
                    bone = 24818,
                    xPos = 0.590,
                    yPos = 0.010,
                    zPos = -0.020,
                    xRot = 0.000,
                    yRot = 0.000,
                    zRot = 0.000
                }
            },
            ["pcarryze1"] = {
                "pcarryze1@animations",
                "pcarryze1clip",
                "PCarry 1 Cute Piggyback",
                "pcarryze2",
                animationOptions = {
                    emoteMoving = true,
                    emoteLoop = true
                }
            },
            ["pcarryze2"] = {
                "pcarryze2@animations",
                "pcarryze2clip",
                "PCarry 2 Cute Piggyback",
                "pcarryze1",
                animationOptions = {
                    emoteMoving = false,
                    emoteLoop = true,
                    attachTo = true,
                    bone = 24818,
                    xPos = 0.180,
                    yPos = -0.020,
                    zPos = -0.020,
                    xRot = 0.000,
                    yRot = 0.000,
                    zRot = -10.000
                }
            },
            ["pcarryzf1"] = {
                "pcarryzf1@animations",
                "pcarryzf1clip",
                "PCarry 1 Piggyback Run",
                "pcarryzf2",
                animationOptions = {
                    emoteMoving = true,
                    emoteLoop = true
                }
            },
            ["pcarryzf2"] = {
                "pcarryzf2@animations",
                "pcarryzf2clip",
                "PCarry 2 Piggyback Run",
                "pcarryzf1",
                animationOptions = {
                    emoteMoving = false,
                    emoteLoop = true,
                    attachTo = true,
                    bone = 24818,
                    xPos = -0.210,
                    yPos = -0.270,
                    zPos = -0.020,
                    xRot = 0.000,
                    yRot = 0.000,
                    zRot = -90.000
                }
            },
            ["pcarryzg1"] = {
                "pcarryzg1@animations",
                "pcarryzg1clip",
                "PCarry 1 Pulling Hands Back",
                "pcarryzg2",
                animationOptions = {
                    emoteMoving = true,
                    emoteLoop = true
                }
            },
            ["pcarryzg2"] = {
                "pcarryzg2@animations",
                "pcarryzg2clip",
                "PCarry 2 Pulling Hands Back",
                "pcarryzg1",
                animationOptions = {
                    emoteMoving = false,
                    emoteLoop = true,
                    attachTo = true,
                    bone = 24818,
                    xPos = -0.150,
                    yPos = -0.670,
                    zPos = -0.010,
                    xRot = 0.000,
                    yRot = 0.000,
                    zRot = -80.000
                }
            },
            ["pcarryzh1"] = {
                "pcarryzh1@animations",
                "pcarryzh1clip",
                "PCarry 1 Pole",
                "pcarryzh2",
                animationOptions = {
                    emoteMoving = true,
                    emoteLoop = true
                }
            },
            ["pcarryzh2"] = {
                "pcarryzh2@animations",
                "pcarryzh2clip",
                "PCarry 2 Pole",
                "pcarryzh1",
                animationOptions = {
                    emoteMoving = false,
                    emoteLoop = true,
                    attachTo = true,
                    bone = 24818,
                    xPos = -0.110,
                    yPos = 0.120,
                    zPos = -0.270,
                    xRot = 0.000,
                    yRot = 0.000,
                    zRot = -10.000
                }
            },
            ["pcarryzi1"] = {
                "pcarryzi1@animations",
                "pcarryzi1clip",
                "PCarry 1 Cute Front",
                "pcarryzi2",
                animationOptions = {
                    emoteMoving = true,
                    emoteLoop = true
                }
            },
            ["pcarryzi2"] = {
                "pcarryzi2@animations",
                "pcarryzi2clip",
                "PCarry 2 Cute Front",
                "pcarryzi1",
                animationOptions = {
                    emoteMoving = false,
                    emoteLoop = true,
                    attachTo = true,
                    bone = 24818,
                    xPos = 0.100,
                    yPos = 0.250,
                    zPos = 0.000,
                    xRot = 0.000,
                    yRot = 0.000,
                    zRot = 0.000
                }
            },
            ["pcarryzj1"] = {
                "pcarryzj1@animations",
                "pcarryzj1clip",
                "PCarry 1 Caress Head",
                "pcarryzj2",
                animationOptions = {
                    emoteMoving = true,
                    emoteLoop = true
                }
            },
            ["pcarryzj2"] = {
                "pcarryzj2@animations",
                "pcarryzj2clip",
                "PCarry 2 Caress Head",
                "pcarryzj1",
                animationOptions = {
                    emoteMoving = false,
                    emoteLoop = true,
                    attachTo = true,
                    bone = 24818,
                    xPos = 0.270,
                    yPos = 0.010,
                    zPos = -0.060,
                    xRot = 0.000,
                    yRot = 0.000,
                    zRot = 0.000
                }
            },
            ["pcarryzk1"] = {
                "pcarryzk1@animations",
                "pcarryzk1clip",
                "PCarry 1 Cute Scared",
                "pcarryzk2",
                animationOptions = {
                    emoteMoving = true,
                    emoteLoop = true
                }
            },
            ["pcarryzk2"] = {
                "pcarryzk2@animations",
                "pcarryzk2clip",
                "PCarry 2 Cute Scared",
                "pcarryzk1",
                animationOptions = {
                    emoteMoving = false,
                    emoteLoop = true,
                    attachTo = true,
                    bone = 24818,
                    xPos = -0.200,
                    yPos = 0.010,
                    zPos = 0.100,
                    xRot = 0.000,
                    yRot = 0.000,
                    zRot = 0.000
                }
            },
            ["pcarryzl1"] = {
                "pcarryzl1@animations",
                "pcarryzl1clip",
                "PCarry 1 Bag",
                "pcarryzl2",
                animationOptions = {
                    emoteMoving = true,
                    emoteLoop = true
                }
            },
            ["pcarryzl2"] = {
                "pcarryzl2@animations",
                "pcarryzl2clip",
                "PCarry 2 Bag",
                "pcarryzl1",
                animationOptions = {
                    emoteMoving = false,
                    emoteLoop = true,
                    attachTo = true,
                    bone = 24818,
                    xPos = 0.040,
                    yPos = 0.060,
                    zPos = -0.030,
                    xRot = 0.000,
                    yRot = 0.000,
                    zRot = 0.000
                }
            },
            ["pcarryzm1"] = {
                "pcarryzm1@animations",
                "pcarryzm1clip",
                "PCarry 1 Bag Flip",
                "pcarryzm2",
                animationOptions = {
                    emoteMoving = true,
                    emoteLoop = true
                }
            },
            ["pcarryzm2"] = {
                "pcarryzm2@animations",
                "pcarryzm2clip",
                "PCarry 2 Bag Flip",
                "pcarryzm1",
                animationOptions = {
                    emoteMoving = false,
                    emoteLoop = true,
                    attachTo = true,
                    bone = 24818,
                    xPos = -0.120,
                    yPos = 0.050,
                    zPos = -0.020,
                    xRot = 0.000,
                    yRot = 0.000,
                    zRot = -15.000
                }
            },
            ["pcarryzn1"] = {
                "pcarryzn1@animations",
                "pcarryzn1clip",
                "PCarry 1 Hug Back Flip",
                "pcarryzn2",
                animationOptions = {
                    emoteMoving = true,
                    emoteLoop = true
                }
            },
            ["pcarryzn2"] = {
                "pcarryzn2@animations",
                "pcarryzn2clip",
                "PCarry 2 Hug Back Flip",
                "pcarryzn1",
                animationOptions = {
                    emoteMoving = false,
                    emoteLoop = true,
                    attachTo = true,
                    bone = 24818,
                    xPos = -0.210,
                    yPos = 0.050,
                    zPos = -0.020,
                    xRot = 0.000,
                    yRot = 0.000,
                    zRot = -15.000
                }
            },
            ["pcarryzo1"] = {
                "pcarryzo1@animations",
                "pcarryzo1clip",
                "PCarry 1 Sit & Wave Over Head",
                "pcarryzo2",
                animationOptions = {
                    emoteMoving = true,
                    emoteLoop = true
                }
            },
            ["pcarryzo2"] = {
                "pcarryzo2@animations",
                "pcarryzo2clip",
                "PCarry 2 Sit & Wave Over Head",
                "pcarryzo1",
                animationOptions = {
                    emoteMoving = false,
                    emoteLoop = true,
                    attachTo = true,
                    bone = 24818,
                    xPos = 1.190,
                    yPos = -0.020,
                    zPos = -0.020,
                    xRot = 0.000,
                    yRot = 0.000,
                    zRot = 0.000
                }
            },
            ["pcarryzp1"] = {
                "pcarryzp1@animations",
                "pcarryzp1clip",
                "PCarry 1 Cute Punch Head",
                "pcarryzp2",
                animationOptions = {
                    emoteMoving = true,
                    emoteLoop = true
                }
            },
            ["pcarryzp2"] = {
                "pcarryzp2@animations",
                "pcarryzp2clip",
                "PCarry 2 Cute Punch Head",
                "pcarryzp1",
                animationOptions = {
                    emoteMoving = false,
                    emoteLoop = true,
                    attachTo = true,
                    bone = 24818,
                    xPos = 0.450,
                    yPos = -0.160,
                    zPos = -0.030,
                    xRot = 0.000,
                    yRot = 0.000,
                    zRot = 0.000
                }
            },
            ["pcarryzq1"] = {
                "pcarryzq1@animations",
                "pcarryzq1clip",
                "PCarry 1 Superhero",
                "pcarryzq2",
                animationOptions = {
                    emoteMoving = true,
                    emoteLoop = true
                }
            },
            ["pcarryzq2"] = {
                "pcarryzq2@animations",
                "pcarryzq2clip",
                "PCarry 2 Superhero",
                "pcarryzq1",
                animationOptions = {
                    emoteMoving = false,
                    emoteLoop = true,
                    attachTo = true,
                    bone = 24818,
                    xPos = 0.270,
                    yPos = 0.540,
                    zPos = -0.020,
                    xRot = 0.000,
                    yRot = 0.000,
                    zRot = 0.000
                }
            },
            ["pcarryzr1"] = {
                "pcarryzr1@animations",
                "pcarryzr1clip",
                "PCarry 1 Shoulder Leg Cross Head",
                "pcarryzr2",
                animationOptions = {
                    emoteMoving = true,
                    emoteLoop = true
                }
            },
            ["pcarryzr2"] = {
                "pcarryzr2@animations",
                "pcarryzr2clip",
                "PCarry 2 Shoulder Leg Cross Head",
                "pcarryzr1",
                animationOptions = {
                    emoteMoving = false,
                    emoteLoop = true,
                    attachTo = true,
                    bone = 24818,
                    xPos = 0.600,
                    yPos = -0.090,
                    zPos = 0.020,
                    xRot = 0.000,
                    yRot = 0.000,
                    zRot = 0.000
                }
            },
            ["pcarryzs1"] = {
                "pcarryzs1@animations",
                "pcarryzs1clip",
                "PCarry 1 Can't Breath",
                "pcarryzs2",
                animationOptions = {
                    emoteMoving = true,
                    emoteLoop = true
                }
            },
            ["pcarryzs2"] = {
                "pcarryzs2@animations",
                "pcarryzs2clip",
                "PCarry 2 Can't Breath",
                "pcarryzs1",
                animationOptions = {
                    emoteMoving = false,
                    emoteLoop = true,
                    attachTo = true,
                    bone = 24818,
                    xPos = -0.030,
                    yPos = -0.180,
                    zPos = 0.020,
                    xRot = 0.000,
                    yRot = 0.000,
                    zRot = 0.000
                }
            },
            ["pcarryzt1"] = {
                "pcarryzt1@animations",
                "pcarryzt1clip",
                "PCarry 1 Firemans Back",
                "pcarryzt2",
                animationOptions = {
                    emoteMoving = true,
                    emoteLoop = true
                }
            },
            ["pcarryzt2"] = {
                "pcarryzt2@animations",
                "pcarryzt2clip",
                "PCarry 2 Firemans Back",
                "pcarryzt1",
                animationOptions = {
                    emoteMoving = false,
                    emoteLoop = true,
                    attachTo = true,
                    bone = 24818,
                    xPos = -0.330,
                    yPos = 0.000,
                    zPos = -0.040,
                    xRot = 0.000,
                    yRot = 0.000,
                    zRot = -80.000
                }
            },
            ["pcarryzu1"] = {
                "pcarryzu1@animations",
                "pcarryzu1clip",
                "PCarry 1 Happy Behind",
                "pcarryzu2",
                animationOptions = {
                    emoteMoving = true,
                    emoteLoop = true
                }
            },
            ["pcarryzu2"] = {
                "pcarryzu2@animations",
                "pcarryzu2clip",
                "PCarry 2 Happy Behind",
                "pcarryzu1",
                animationOptions = {
                    emoteMoving = false,
                    emoteLoop = true,
                    attachTo = true,
                    bone = 24818,
                    xPos = -0.290,
                    yPos = -0.300,
                    zPos = -0.020,
                    xRot = 0.000,
                    yRot = 0.000,
                    zRot = -80.000
                }
            },
            ["pcarryzv1"] = {
                "pcarryzv1@animations",
                "pcarryzv1clip",
                "PCarry 1 Happy Swing",
                "pcarryzv2",
                animationOptions = {
                    emoteMoving = true,
                    emoteLoop = true
                }
            },
            ["pcarryzv2"] = {
                "pcarryzv2@animations",
                "pcarryzv2clip",
                "PCarry 2 Happy Swing",
                "pcarryzv1",
                animationOptions = {
                    emoteMoving = false,
                    emoteLoop = true,
                    attachTo = true,
                    bone = 24818,
                    xPos = -0.040,
                    yPos = -0.720,
                    zPos = -0.600,
                    xRot = 0.000,
                    yRot = 0.000,
                    zRot = 0.000
                }
            },
            ["pcarryzw1"] = {
                "pcarryzw1@animations",
                "pcarryzw1clip",
                "PCarry 1 Piggyback Head",
                "pcarryzw2",
                animationOptions = {
                    emoteMoving = true,
                    emoteLoop = true
                }
            },
            ["pcarryzw2"] = {
                "pcarryzw2@animations",
                "pcarryzw2clip",
                "PCarry 2 Piggyback Head",
                "pcarryzw1",
                animationOptions = {
                    emoteMoving = false,
                    emoteLoop = true,
                    attachTo = true,
                    bone = 24818,
                    xPos = 0.320,
                    yPos = -0.220,
                    zPos = -0.020,
                    xRot = 0.000,
                    yRot = 0.000,
                    zRot = -80.000
                }
            },
            ["pcarryzx1"] = {
                "pcarryzx1@animations",
                "pcarryzx1clip",
                "PCarry 1 Pose Over Head",
                "pcarryzx2",
                animationOptions = {
                    emoteMoving = true,
                    emoteLoop = true
                }
            },
            ["pcarryzx2"] = {
                "pcarryzx2@animations",
                "pcarryzx2clip",
                "PCarry 2 Pose Over Head",
                "pcarryzx1",
                animationOptions = {
                    emoteMoving = false,
                    emoteLoop = true,
                    attachTo = true,
                    bone = 24818,
                    xPos = 0.430,
                    yPos = -0.860,
                    zPos = 0.000,
                    xRot = 0.000,
                    yRot = 0.000,
                    zRot = -80.000
                }
            },
            ["pcarryzy1"] = {
                "pcarryzy1@animations",
                "pcarryzy1clip",
                "PCarry 1 Piggyback Hold Head",
                "pcarryzy2",
                animationOptions = {
                    emoteMoving = true,
                    emoteLoop = true
                }
            },
            ["pcarryzy2"] = {
                "pcarryzy2@animations",
                "pcarryzy2clip",
                "PCarry 2 Piggyback Hold Head",
                "pcarryzy1",
                animationOptions = {
                    emoteMoving = false,
                    emoteLoop = true,
                    attachTo = true,
                    bone = 24818,
                    xPos = 0.060,
                    yPos = -0.070,
                    zPos = -0.020,
                    xRot = 0.000,
                    yRot = 0.000,
                    zRot = -20.000
                }
            },
            ["pcarryzz1"] = {
                "pcarryzz1@animations",
                "pcarryzz1clip",
                "PCarry 1 Heart Power",
                "pcarryzz2",
                animationOptions = {
                    emoteMoving = true,
                    emoteLoop = true
                }
            },
            ["pcarryzz2"] = {
                "pcarryzz2@animations",
                "pcarryzz2clip",
                "PCarry 2 Heart Power",
                "pcarryzz1",
                animationOptions = {
                    emoteMoving = false,
                    emoteLoop = true,
                    attachTo = true,
                    bone = 24818,
                    xPos = 1.110,
                    yPos = 0.210,
                    zPos = -0.780,
                    xRot = 0.000,
                    yRot = 0.000,
                    zRot = 0.000
                }
            },
        }
    }

    while not Config.Convert do Wait(0) end

    for arrayName, array in pairs(Animations) do
        if Config.Convert[arrayName] then
            for emoteName, emoteData in pairs(array) do
                Config.Convert[arrayName][emoteName] = emoteData
            end
        end
    end
end)