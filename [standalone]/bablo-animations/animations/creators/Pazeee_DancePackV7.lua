Citizen.CreateThread(function()
    if not Config.Creators['Pazeee_DancePackV7'] then return end

    local musicEnabled = false
    local Animations = {
        Emotes = {},

        Dances = {
            ["pfnomoney"] = {
                "pazeee@4nite@nomoney@animations",
                "pazeee@4nite@nomoney@clip",
                "Fortnite No Money",
                animationOptions = {
                    emoteLoop = true
                }
            },
            ["pfthelargest"] = {
                "pazeee@4nite@thelargest@animations",
                "pazeee@4nite@thelargest@clip",
                "Fortnite The Largest",
                animationOptions = {
                    emoteLoop = true
                }
            },
            ["pfjtcoming"] = {
                "pazeee@4nite@jtcoming@animations",
                "pazeee@4nite@jtcoming@clip",
                "Fortnite JT Coming",
                animationOptions = {
                    emoteLoop = true
                }
            },
            ["pfsmeeze"] = {
                "pazeee@4nite@smeeze@animations",
                "pazeee@4nite@smeeze@clip",
                "Fortnite Smeeze",
                animationOptions = {
                    emoteLoop = true
                }
            },
            ["pftouch"] = {
                "pazeee@4nite@touch@animations",
                "pazeee@4nite@touch@clip",
                "Fortnite Touch",
                animationOptions = {
                    emoteLoop = true
                }
            },
            ["pfwhiplash"] = {
                "pazeee@4nite@whiplash@animations",
                "pazeee@4nite@whiplash@clip",
                "Fortnite Whiplash",
                animationOptions = {
                    emoteLoop = true
                }
            },
            ["pflikejennie"] = {
                "pazeee@4nite@likejennie@animations",
                "pazeee@4nite@likejennie@clip",
                "Fortnite Like Jennie",
                animationOptions = {
                    emoteLoop = true
                }
            },
            ["pftiktok"] = {
                "pazeee@4nite@tiktok@animations",
                "pazeee@4nite@tiktok@clip",
                "Fortnite Tik Tok",
                animationOptions = {
                    emoteLoop = true
                }
            },
            ["pfallaboutthatbass"] = {
                "pazeee@4nite@allaboutthatbass@animations",
                "pazeee@4nite@allaboutthatbass@clip",
                "Fortnite All About That Bass",
                animationOptions = {
                    emoteLoop = true
                }
            },
            ["pfdare"] = {
                "pazeee@4nite@dare@animations",
                "pazeee@4nite@dare@clip",
                "Fortnite Dare",
                animationOptions = {
                    emoteLoop = true
                }
            },
            ["pfsong2"] = {
                "pazeee@4nite@song2@animations",
                "pazeee@4nite@song2@clip",
                "Fortnite Song 2",
                animationOptions = {
                    emoteLoop = true
                }
            },
            ["pflookatme"] = {
                "pazeee@4nite@lookatme@animations",
                "pazeee@4nite@lookatme@clip",
                "Fortnite Look At Me",
                animationOptions = {
                    emoteLoop = true
                }
            },
            ["pfthespark"] = {
                "pazeee@4nite@thespark@animations",
                "pazeee@4nite@thespark@clip",
                "Fortnite The Spark",
                animationOptions = {
                    emoteLoop = true
                }
            },
            ["pfbedcherm"] = {
                "pazeee@4nite@bedcherm@animations",
                "pazeee@4nite@bedcherm@clip",
                "Fortnite Bed Cherm",
                animationOptions = {
                    emoteLoop = true
                }
            },
            ["pfimage"] = {
                "pazeee@4nite@image@animations",
                "pazeee@4nite@image@clip",
                "Fortnite Image",
                animationOptions = {
                    emoteLoop = true
                }
            },
            ["pfdreamykeys"] = {
                "pazeee@4nite@dreamykeys@animations",
                "pazeee@4nite@dreamykeys@clip",
                "Fortnite Dreamy Keys",
                animationOptions = {
                    emoteLoop = true
                }
            },
            ["pfminglegamedance"] = {
                "pazeee@4nite@minglegamedance@animations",
                "pazeee@4nite@minglegamedance@clip",
                "Fortnite Mingle Game Dance",
                animationOptions = {
                    emoteLoop = true
                }
            },
            ["pfoblivion"] = {
                "pazeee@4nite@oblivion@animations",
                "pazeee@4nite@oblivion@clip",
                "Fortnite Oblivion",
                animationOptions = {
                    emoteLoop = true
                }
            },
            ["pftakeonme"] = {
                "pazeee@4nite@takeonme@animations",
                "pazeee@4nite@takeonme@clip",
                "Fortnite Take On Me",
                animationOptions = {
                    emoteLoop = true
                }
            },
            ["pfwakemeup"] = {
                "pazeee@4nite@wakemeup@animations",
                "pazeee@4nite@wakemeup@clip",
                "Fortnite Wake Me Up",
                animationOptions = {
                    emoteLoop = true
                }
            },
            ["pfsidestep"] = {
                "pazeee@4nite@sidestep@animations",
                "pazeee@4nite@sidestep@clip",
                "Fortnite Side Step",
                animationOptions = {
                    emoteLoop = true
                }
            },
            ["pfchildlikethings"] = {
                "pazeee@4nite@childlikethings@animations",
                "pazeee@4nite@childlikethings@clip",
                "Fortnite Child Like Things",
                animationOptions = {
                    emoteLoop = true
                }
            },
            ["pfswingmyway"] = {
                "pazeee@4nite@swingmyway@animations",
                "pazeee@4nite@swingmyway@clip",
                "Fortnite Swing My Way",
                animationOptions = {
                    emoteLoop = true
                }
            },
            ["pftwo"] = {
                "pazeee@4nite@two@animations",
                "pazeee@4nite@two@clip",
                "Fortnite Two",
                animationOptions = {
                    emoteLoop = true
                }
            },
            ["pfthetylildance"] = {
                "pazeee@4nite@thetylildance@animations",
                "pazeee@4nite@thetylildance@clip",
                "Fortnite The Tylil Dance",
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
