Citizen.CreateThread(function()
    if not Config.Creators['Pazeee_VehicleFunnyEmote'] then return end
    
    local Animations = {
        Dances = {},

        InVehicle = {
           ["pavehcar1l"] = {
                "pavehcar1l@animations",
                "pavehcar1lclip",
                "Veh Sit-Up Left",
                animationOptions = {
                    emoteLoop = true,
                    emoteMoving = false,
                    customMovementType = 33
                }
            },
            ["pavehcar1r"] = {
                "pavehcar1r@animations",
                "pavehcar1rclip",
                "Veh Sit-Up Right",
                animationOptions = {
                    emoteLoop = true,
                    emoteMoving = false,
                    customMovementType = 33
                }
            },
            ["pavehcar2r"] = {
                "pavehcar2r@animations",
                "pavehcar2rclip",
                "Veh Hold On Tight Right",
                animationOptions = {
                    emoteLoop = true,
                    emoteMoving = false,
                    customMovementType = 33
                }
            },
            ["pavehcar2l"] = {
                "pavehcar2l@animations",
                "pavehcar2lclip",
                "Veh Hold On Tight Left",
                animationOptions = {
                    emoteLoop = true,
                    emoteMoving = false,
                    customMovementType = 33
                }
            },
            ["pavehcar3r"] = {
                "pavehcar3r@animations",
                "pavehcar3rclip",
                "Veh Sit Relaxs Right",
                animationOptions = {
                    emoteLoop = true,
                    emoteMoving = false,
                    customMovementType = 33
                }
            },
            ["pavehcar3l"] = {
                "pavehcar3l@animations",
                "pavehcar3lclip",
                "Veh Sit Relaxs Left",
                animationOptions = {
                    emoteLoop = true,
                    emoteMoving = false,
                    customMovementType = 33
                }
            },
            ["pavehcar4r"] = {
                "pavehcar4r@animations",
                "pavehcar4rclip",
                "Veh Sit and Wave Right",
                animationOptions = {
                    emoteLoop = true,
                    emoteMoving = false,
                    customMovementType = 33
                }
            },
            ["pavehcar4l"] = {
                "pavehcar4l@animations",
                "pavehcar4lclip",
                "Veh Sit Cool Left",
                animationOptions = {
                    emoteLoop = true,
                    emoteMoving = false,
                    customMovementType = 33
                }
            },
            ["pavehcar5r"] = {
                "pavehcar5r@animations",
                "pavehcar5rclip",
                "Veh Rock And Roll Right",
                animationOptions = {
                    emoteLoop = true,
                    emoteMoving = false,
                    customMovementType = 33
                }
            },
            ["pavehcar5l"] = {
                "pavehcar5l@animations",
                "pavehcar5lclip",
                "Veh Rock And Roll Left",
                animationOptions = {
                    emoteLoop = true,
                    emoteMoving = false,
                    customMovementType = 33
                }
            },
            ["pavehcar6r"] = {
                "pavehcar6r@animations",
                "pavehcar6rclip",
                "Veh Sit Relaxs Roof Right",
                animationOptions = {
                    emoteLoop = true,
                    emoteMoving = false,
                    customMovementType = 33
                }
            },
            ["pavehcar6l"] = {
                "pavehcar6l@animations",
                "pavehcar6lclip",
                "Veh Sit Relaxs Roof Left",
                animationOptions = {
                    emoteLoop = true,
                    emoteMoving = false,
                    customMovementType = 33
                }
            },
            ["pavehcar7r"] = {
                "pavehcar7r@animations",
                "pavehcar7rclip",
                "Veh Sit Happy Right",
                animationOptions = {
                    emoteLoop = true,
                    emoteMoving = false,
                    customMovementType = 33
                }
            },
            ["pavehcar7l"] = {
                "pavehcar7l@animations",
                "pavehcar7lclip",
                "Veh Sit Happy Left",
                animationOptions = {
                    emoteLoop = true,
                    emoteMoving = false,
                    customMovementType = 33
                }
            },
            ["pavehcar8r"] = {
                "pavehcar8r@animations",
                "pavehcar8rclip",
                "Veh Sleep Right",
                animationOptions = {
                    emoteLoop = true,
                    emoteMoving = false,
                    customMovementType = 33
                }
            },
            ["pavehcar8l"] = {
                "pavehcar8l@animations",
                "pavehcar8lclip",
                "Veh Sleep Left",
                animationOptions = {
                    emoteLoop = true,
                    emoteMoving = false,
                    customMovementType = 33
                }
            },
            ["pavehcar9r"] = {
                "pavehcar9r@animations",
                "pavehcar9rclip",
                "Veh Take Video Right",
                animationOptions = {
                    prop = "prop_phone_ing",
                    propBone = 28422,
                    propPlacement = {
                        0.05,
                        0.0100,
                        0.060,
                        -174.961,
                        149.618,
                        8.649,
                    },
                    emoteLoop = true,
                    emoteMoving = false,
                    customMovementType = 33
                }
            },
            ["pavehcar9l"] = {
                "pavehcar9l@animations",
                "pavehcar9lclip",
                "Veh Take Video Left",
                animationOptions = {
                    prop = "prop_phone_ing",
                    propBone = 58866,
                    propPlacement = {
                        0.07,
                        -0.0500,
                        0.010,
                        -105.33,
                        -168.30,
                        48.97,
                    },
                    emoteLoop = true,
                    emoteMoving = false,
                    customMovementType = 33
                }
            },
            ["pavehcar10"] = {
                "pavehcar10@animations",
                "pavehcar10clip",
                "Veh Sit Enjoy Lucia",
                animationOptions = {
                    emoteLoop = true,
                    emoteMoving = false,
                    customMovementType = 33
                }
            },
            ["pbvehcar1"] = {
                "pbvehcar1@animations",
                "pbvehcar1clip",
                "Veh Sit Here I Am",
                animationOptions = {
                    emoteLoop = true,
                    emoteMoving = false,
                    customMovementType = 33
                }
            },
            ["pbvehcar2"] = {
                "pbvehcar2@animations",
                "pbvehcar2clip",
                "Veh Sit Enjoy The Wind",
                animationOptions = {
                    emoteLoop = true,
                    emoteMoving = false,
                    customMovementType = 33
                }
            },
            ["pbvehcar3r"] = {
                "pbvehcar3r@animations",
                "pbvehcar3rclip",
                "Veh Sit Enjoy The Ride Right",
                animationOptions = {
                    emoteLoop = true,
                    emoteMoving = false,
                    customMovementType = 1
                }
            },
            ["pbvehcar3l"] = {
                "pbvehcar3l@animations",
                "pbvehcar3lclip",
                "Veh Sit Enjoy The Ride Left",
                animationOptions = {
                    emoteLoop = true,
                    emoteMoving = false,
                    customMovementType = 33
                }
            },
            ["pbvehcar4r"] = {
                "pbvehcar4r@animations",
                "pbvehcar4rclip",
                "Veh Sit Enjoy The Ride 2 Right",
                animationOptions = {
                    emoteLoop = true,
                    emoteMoving = false,
                    customMovementType = 33
                }
            },
            ["pbvehcar4l"] = {
                "pbvehcar4l@animations",
                "pbvehcar4lclip",
                "Veh Sit Enjoy The Ride 2 Left",
                animationOptions = {
                    emoteLoop = true,
                    emoteMoving = false,
                    customMovementType = 33
                }
            },
            ["pbvehcar5r"] = {
                "pbvehcar5r@animations",
                "pbvehcar5rclip",
                "Veh Sit Looking The View Right",
                animationOptions = {
                    emoteLoop = true,
                    emoteMoving = false,
                    customMovementType = 33
                }
            },
            ["pbvehcar5l"] = {
                "pbvehcar5l@animations",
                "pbvehcar5lclip",
                "Veh Sit Looking The View Left",
                animationOptions = {
                    emoteLoop = true,
                    emoteMoving = false,
                    customMovementType = 33
                }
            },
            ["pbvehcar6r"] = {
                "pbvehcar6r@animations",
                "pbvehcar6rclip",
                "Veh Twerk Right",
                animationOptions = {
                    emoteLoop = true,
                    emoteMoving = false,
                    customMovementType = 33
                }
            },
            ["pbvehcar6l"] = {
                "pbvehcar6l@animations",
                "pbvehcar6lclip",
                "Veh Twerk Left",
                animationOptions = {
                    emoteLoop = true,
                    emoteMoving = false,
                    customMovementType = 33
                }
            },
            ["pbvehcar7l"] = {
                "pbvehcar7l@animations",
                "pbvehcar7lclip",
                "Veh Standing At The Driver Left",
                animationOptions = {
                    emoteLoop = true,
                    emoteMoving = false,
                    customMovementType = 33
                }
            },
            ["pbvehcar8"] = {
                "pbvehcar8@animations",
                "pbvehcar8clip",
                "Veh Sleep On The Roof",
                animationOptions = {
                    emoteLoop = true,
                    emoteMoving = false,
                    customMovementType = 33
                }
            },
            ["pbvehcar9"] = {
                "pbvehcar9@animations",
                "pbvehcar9clip",
                "Veh Sit Relaxs On The Roof",
                animationOptions = {
                    emoteLoop = true,
                    emoteMoving = false,
                    customMovementType = 33
                }
            },
            ["pbvehcar10"] = {
                "pbvehcar10@animations",
                "pbvehcar10clip",
                "Veh Relaxs On The Roof",
                animationOptions = {
                    emoteLoop = true,
                    emoteMoving = false,
                    customMovementType = 33
                }
            },
            ["pcvehcar1"] = {
                "pcvehcar1@animations",
                "pcvehcar1clip",
                "Veh Sit Enjoy On The Roof",
                animationOptions = {
                    emoteLoop = true,
                    emoteMoving = false,
                    customMovementType = 33
                }
            },
            ["pcvehcar2r"] = {
                "pcvehcar2r@animations",
                "pcvehcar2rclip",
                "Veh Sit Trunk Right",
                animationOptions = {
                    emoteLoop = true,
                    emoteMoving = false,
                    customMovementType = 33
                }
            },
            ["pcvehcar2l"] = {
                "pcvehcar2l@animations",
                "pcvehcar2lclip",
                "Veh Sit Trunk Left",
                animationOptions = {
                    emoteLoop = true,
                    emoteMoving = false,
                    customMovementType = 33
                }
            },
            ["pcvehcar3r"] = {
                "pcvehcar3r@animations",
                "pcvehcar3rclip",
                "Veh Sit Trunk Lower Right",
                animationOptions = {
                    emoteLoop = true,
                    emoteMoving = false,
                    customMovementType = 33
                }
            },
            ["pcvehcar3l"] = {
                "pcvehcar3l@animations",
                "pcvehcar3lclip",
                "Veh Sit Trunk Lower Left",
                animationOptions = {
                    emoteLoop = true,
                    emoteMoving = false,
                    customMovementType = 33
                }
            },
            ["pcvehcar4r"] = {
                "pcvehcar4r@animations",
                "pcvehcar4rclip",
                "Veh Fly Right",
                animationOptions = {
                    emoteLoop = true,
                    emoteMoving = false,
                    customMovementType = 33
                }
            },
            ["pcvehcar4l"] = {
                "pcvehcar4l@animations",
                "pcvehcar4lclip",
                "Veh Fly Left",
                animationOptions = {
                    emoteLoop = true,
                    emoteMoving = false,
                    customMovementType = 33
                }
            },
            ["pcvehcar5"] = {
                "pcvehcar5@animations",
                "pcvehcar5clip",
                "Veh Fly Random",
                animationOptions = {
                    emoteLoop = true,
                    emoteMoving = false,
                    customMovementType = 33
                }
            },
            ["pcvehcar6"] = {
                "pcvehcar6@animations",
                "pcvehcar6clip",
                "Veh Fly Higher",
                animationOptions = {
                    emoteLoop = true,
                    emoteMoving = false,
                    customMovementType = 33
                }
            },
            ["pcvehcar7"] = {
                "pcvehcar7@animations",
                "pcvehcar7clip",
                "Veh Motorcycle Hold On Tight",
                animationOptions = {
                    emoteLoop = true,
                    emoteMoving = false,
                    customMovementType = 33
                }
            },
            ["pcvehcar8"] = {
                "pcvehcar8@animations",
                "pcvehcar8clip",
                "Veh Motorcycle Two Gun",
                animationOptions = {
                    prop = 'w_pi_pistol',
                    propBone = 26611,
                    propPlacement = {
                        0.07,
                        -.01,
                        0.01,
                        -29.999,
                        0.0,
                        10.000
                    },
                    Secondprop = 'w_pi_pistol',
                    SecondpropBone = 58867,
                    SecondpropPlacement = {
                        0.07,
                        0.01,
                        0.01,
                        29.999,
                        0.0,
                        -10.000
                    },
                    emoteLoop = true,
                    emoteMoving = false,
                    customMovementType = 33
                }
            },
            ["pcvehcar9"] = {
                "pcvehcar9@animations",
                "pcvehcar9clip",
                "Veh Motorcycle Sit Facing Back",
                animationOptions = {
                    emoteLoop = true,
                    emoteMoving = false,
                    customMovementType = 33
                }
            },

            -- custom add

            ["pbablovehcar1l"] = {
                "pbablovehcar1l@animations",
                "pbablovehcar1lclip",
                "Veh Dab Left",
                animationOptions = {
                    emoteLoop = true,
                    emoteMoving = false,
                    customMovementType = 33
                }
            },
            ["pbablovehcar1r"] = {
                "pbablovehcar1r@animations",
                "pbablovehcar1rclip",
                "Veh Dab Right",
                animationOptions = {
                    emoteLoop = true,
                    emoteMoving = false,
                    customMovementType = 33
                }
            },
            ["pbablovehcar2r"] = {
                "pbablovehcar2r@animations",
                "pbablovehcar2rclip",
                "Veh Superman Right",
                animationOptions = {
                    emoteLoop = true,
                    emoteMoving = false,
                    customMovementType = 33
                }
            },
            ["pbablovehcar2l"] = {
                "pbablovehcar2l@animations",
                "pbablovehcar2lclip",
                "Veh Superman Left",
                animationOptions = {
                    emoteLoop = true,
                    emoteMoving = false,
                    customMovementType = 33
                }
            },
            ["pbablovehcar3r"] = {
                "pbablovehcar3r@animations",
                "pbablovehcar3rclip",
                "Veh MicroSMG Right",
                animationOptions = {
                    prop = "w_sb_microsmg",
                    propBone = 58867,
                    propPlacement = {
                        0.02,
                        -0.0200,
                        0.030,
                        69.999,
                        0,
                        0,
                    },
                    emoteLoop = true,
                    emoteMoving = false,
                    customMovementType = 33
                }
            },
            ["pbablovehcar3l"] = {
                "pbablovehcar3l@animations",
                "pbablovehcar3lclip",
                "Veh MicroSMG Left",
                animationOptions = {
                    prop = "w_sb_microsmg",
                    propBone = 26611,
                    propPlacement = {
                        0.02,
                        -0.0200,
                        0.020,
                        0,
                        10.000,
                        0,
                    },
                    emoteLoop = true,
                    emoteMoving = false,
                    customMovementType = 33
                }
            },
            ["pbablovehcar4r"] = {
                "pbablovehcar4r@animations",
                "pbablovehcar4rclip",
                "Veh Holding Door Right",
                animationOptions = {
                    emoteLoop = true,
                    emoteMoving = false,
                    customMovementType = 33
                }
            },
            ["pbablovehcar4l"] = {
                "pbablovehcar4l@animations",
                "pbablovehcar4lclip",
                "Veh Holding Door Left",
                animationOptions = {
                    emoteLoop = true,
                    emoteMoving = false,
                    customMovementType = 33
                }
            },
            ["pbablovehcar5r"] = {
                "pbablovehcar5r@animations",
                "pbablovehcar5rclip",
                "Veh Fly Lower Right",
                animationOptions = {
                    emoteLoop = true,
                    emoteMoving = false,
                    customMovementType = 33
                }
            },
            ["pbablovehcar5l"] = {
                "pbablovehcar5l@animations",
                "pbablovehcar5lclip",
                "Veh Fly Lower Left",
                animationOptions = {
                    emoteLoop = true,
                    emoteMoving = false,
                    customMovementType = 33
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