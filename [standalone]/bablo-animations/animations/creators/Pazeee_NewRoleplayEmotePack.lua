Citizen.CreateThread(function()
    if not Config.Creators['Pazeee_NewRoleplayEmotePack'] then return end

    local Animations = {
        Dances = {},

        Emotes = {
            ["pgreetingsa"] = {
                "pazeee@greetings@a@animations",
                "pazeee@greetings@a@clip",
                "Greetings A",
                AnimationOptions = {
                    EmoteLoop = true,
                    EmoteMoving = true
                }
            },
            ["pgreetingsb"] = {
                "pazeee@greetings@b@animations",
                "pazeee@greetings@b@clip",
                "Greetings B",
                AnimationOptions = {
                    EmoteLoop = true,
                    EmoteMoving = true
                }
            },
            ["pgreetingsc"] = {
                "pazeee@greetings@c@animations",
                "pazeee@greetings@c@clip",
                "Greetings C",
                AnimationOptions = {
                    EmoteLoop = true,
                    EmoteMoving = true
                }
            },
            ["pgreetingsd"] = {
                "pazeee@greetings@d@animations",
                "pazeee@greetings@d@clip",
                "Greetings D",
                AnimationOptions = {
                    EmoteLoop = true,
                    EmoteMoving = true
                }
            },
            ["pgreetingse"] = {
                "pazeee@greetings@e@animations",
                "pazeee@greetings@e@clip",
                "Greetings E",
                AnimationOptions = {
                    EmoteLoop = true,
                    EmoteMoving = true
                }
            },
            ["pbowinga"] = {
                "pazeee@bowing@a@animations",
                "pazeee@bowing@a@clip",
                "Bowing A",
                AnimationOptions = {
                    EmoteLoop = true,
                }
            },
            ["pbowingb"] = {
                "pazeee@bowing@b@animations",
                "pazeee@bowing@b@clip",
                "Bowing B",
                AnimationOptions = {
                    EmoteLoop = true,
                }
            },
            ["pbowingc"] = {
                "pazeee@bowing@c@animations",
                "pazeee@bowing@c@clip",
                "Bowing C",
                AnimationOptions = {
                    EmoteLoop = true,
                }
            },
            ["pbowingd"] = {
                "pazeee@bowing@d@animations",
                "pazeee@bowing@d@clip",
                "Bowing D",
                AnimationOptions = {
                    EmoteLoop = true,
                }
            },
            ["pbowinge"] = {
                "pazeee@bowing@e@animations",
                "pazeee@bowing@e@clip",
                "Bowing E",
                AnimationOptions = {
                    EmoteLoop = true,
                }
            },
            ["papologya"] = {
                "pazeee@apology@a@animations",
                "pazeee@apology@a@clip",
                "Apology A",
                AnimationOptions = {
                    EmoteLoop = true,
                }
            },
            ["papologyb"] = {
                "pazeee@apology@b@animations",
                "pazeee@apology@b@clip",
                "Apology B",
                AnimationOptions = {
                    EmoteLoop = true,
                }
            },
            ["papologyc"] = {
                "pazeee@apology@c@animations",
                "pazeee@apology@c@clip",
                "Apology C",
                AnimationOptions = {
                    EmoteLoop = true,
                }
            },
            ["papologyd"] = {
                "pazeee@apology@d@animations",
                "pazeee@apology@d@clip",
                "Apology D",
                AnimationOptions = {
                    EmoteLoop = true,
                }
            },
            ["papologye"] = {
                "pazeee@apology@e@animations",
                "pazeee@apology@e@clip",
                "Apology E",
                AnimationOptions = {
                    EmoteLoop = true,
                }
            },
            ["papologyf"] = {
                "pazeee@apology@f@animations",
                "pazeee@apology@f@clip",
                "Apology F",
                AnimationOptions = {
                    EmoteLoop = true,
                }
            },
            ["papologyg"] = {
                "pazeee@apology@g@animations",
                "pazeee@apology@g@clip",
                "Apology G",
                AnimationOptions = {
                    EmoteLoop = true,
                }
            },
            ["papologyh"] = {
                "pazeee@apology@h@animations",
                "pazeee@apology@h@clip",
                "Apology H",
                AnimationOptions = {
                    EmoteLoop = true,
                }
            },
            ["pohhnooa"] = {
                "pazeee@ohhnoo@a@animations",
                "pazeee@ohhnoo@a@clip",
                "Oh Noo A",
                AnimationOptions = {
                    EmoteLoop = true,
                    EmoteMoving = true
                }
            },
            ["pohhnoob"] = {
                "pazeee@ohhnoo@b@animations",
                "pazeee@ohhnoo@b@clip",
                "Oh Noo B",
                AnimationOptions = {
                    EmoteLoop = true,
                    EmoteMoving = true
                }
            },
            ["phehehe"] = {
                "pazeee@hehehe@a@animations",
                "pazeee@hehehe@a@clip",
                "Awkward Scracth Hehehe",
                AnimationOptions = {
                    EmoteLoop = true,
                    EmoteMoving = true
                }
            },
            ["pconfused"] = {
                "pazeee@confused@a@animations",
                "pazeee@confused@a@clip",
                "Confused or I don't know",
                AnimationOptions = {
                    EmoteLoop = true,
                    EmoteMoving = true
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
