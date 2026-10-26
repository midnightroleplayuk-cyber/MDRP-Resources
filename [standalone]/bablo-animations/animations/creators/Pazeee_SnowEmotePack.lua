Citizen.CreateThread(function()
    if not Config.Creators['Pazeer_SnowEmotePack'] then return end
    
    local Animations = {
        Dances = {},

        Emotes = {
           ["pavehcar1l"] = {
                "pavehcar1l@animations",
                "pavehcar1lclip",
                "Veh Sit-Up Left",
                animationOptions = {
                    emoteLoop = true,
                    emoteMoving = false,
                    customMovementType = 1
                }
            },

            ["psnow1"] = {
                "psnow1@animations",
                "psnow1clip",
                "Snow Angels 1",
                animationOptions = {
                    emoteLoop = true
                }
            },
            ["psnow2"] = {
                "psnow2@animations",
                "psnow2clip",
                "Snow Angels 2",
                animationOptions = {
                    emoteLoop = true
                }
            },
            ["psnow3"] = {
                "psnow3@animations",
                "psnow3clip",
                "Snow Angels 3",
                animationOptions = {
                    emoteLoop = true
                }
            },
            ["psnow4"] = {
                "psnow4@animations",
                "psnow4clip",
                "Snow Crawl 1",
                animationOptions = {
                    emoteLoop = true
                }
            },
            ["psnow5"] = {
                "psnow5@animations",
                "psnow5clip",
                "Snow Crawl 2",
                animationOptions = {
                    emoteLoop = true
                }
            },
            ["psnow6"] = {
                "psnow6@animations",
                "psnow6clip",
                "Snow Feel",
                animationOptions = {
                    emoteLoop = true
                }
            },
            ["psnow7"] = {
                "psnow7@animations",
                "psnow7clip",
                "Snow Buried 1",
                animationOptions = {
                    emoteLoop = true
                }
            },
            ["psnow8"] = {
                "psnow8@animations",
                "psnow8clip",
                "Snow Buried 2",
                animationOptions = {
                    emoteLoop = true
                }
            },
            ["psnow9"] = {
                "psnow9@animations",
                "psnow9clip",
                "Snow Buried 3",
                animationOptions = {
                    emoteLoop = true,
                }
            },
            ["psnow10"] = {
                "psnow10@animations",
                "psnow10clip",
                "Snow Buried 4",
                animationOptions = {
                    emoteLoop = true
                }
            },
            ["psnow11"] = {
                "psnow11@animations",
                "psnow11clip",
                "Snow Sliding 1",
                animationOptions = {
                    emoteLoop = true
                }
            },
            ["psnow12"] = {
                "psnow12@animations",
                "psnow12clip",
                "Snow Sliding 2",
                animationOptions = {
                    emoteLoop = true
                }
            },
            ["psnow13"] = {
                "psnow13@animations",
                "psnow13clip",
                "Snow Sliding 3",
                animationOptions = {
                    emoteLoop = true
                }
            },
            ["psnow14"] = {
                "psnow14@animations",
                "psnow14clip",
                "Snow Sliding 4",
                animationOptions = {
                    emoteLoop = true
                }
            },
            ["psnow15"] = {
                "psnow15@animations",
                "psnow15clip",
                "Snow Sliding 5",
                animationOptions = {
                    emoteLoop = true
                }
            },

            ["psnow7female"] = {
                "psnow7b@animations",
                "psnow7bclip",
                "Snow Buried 1 Female",
                animationOptions = {
                    emoteLoop = true
                }
            },
            ["psnow8female"] = {
                "psnow8b@animations",
                "psnow8bclip",
                "Snow Buried 2 Female",
                animationOptions = {
                    emoteLoop = true
                }
            },
            ["psnow9female"] = {
                "psnow9b@animations",
                "psnow9bclip",
                "Snow Buried 3 Female",
                animationOptions = {
                    emoteLoop = true,
                }
            },
            ["psnow10female"] = {
                "psnow10b@animations",
                "psnow10bclip",
                "Snow Buried 4 Female",
                animationOptions = {
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