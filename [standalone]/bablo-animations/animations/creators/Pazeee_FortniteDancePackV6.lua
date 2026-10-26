Citizen.CreateThread(function()
    if not Config.Creators['Pazeee_FortniteDancePackV6'] then return end

    local musicEnabled = true
    local Animations = {
        Dances = {
            ["pfoutwest"] = {
                "pazeee@fournite@outwest@animations",
                "pazeee@fournite@outwest@clip",
                "Fortnite Outwest",
                animationOptions = {
                    emoteLoop = true,
                    musicURL = musicEnabled and "https://www.youtube.com/watch?v=Sa690Db3yKk" or nil,
                }
            },
            ["pfrollie"] = {
                "pazeee@fournite@rollie@animations",
                "pazeee@fournite@rollie@clip",
                "Fortnite Rollie",
                animationOptions = {
                    emoteLoop = true,
                    musicURL = musicEnabled and "https://www.youtube.com/watch?v=0dXyN51ApII" or nil,
                }
            },
            ["pfthesquabble"] = {
                "pazeee@fournite@thesquabble@animations",
                "pazeee@fournite@thesquabble@clip",
                "Fortnite Thesquabble",
                animationOptions = {
                    emoteLoop = true,
                    musicURL = musicEnabled and "https://www.youtube.com/watch?v=TuD4MRaMmH0" or nil,
                }
            },
            ["pfbillybounce"] = {
                "pazeee@fournite@billybounce@animations",
                "pazeee@fournite@billybounce@clip",
                "Fortnite Billybounce",
                animationOptions = {
                    emoteLoop = true,
                    musicURL = musicEnabled and "https://www.youtube.com/watch?v=O5DdYHPiVvs&pp=0gcJCY0JAYcqIYzv" or nil,
                }
            },
            ["pfmaximumbounce"] = {
                "pazeee@fournite@maximumbounce@animations",
                "pazeee@fournite@maximumbounce@clip",
                "Fortnite Maximumbounce",
                animationOptions = {
                    emoteLoop = true,
                    musicURL = musicEnabled and "https://www.youtube.com/watch?v=g3UNkLVAqm0" or nil,
                }
            },
            ["pfstuck"] = {
                "pazeee@fournite@stuck@animations",
                "pazeee@fournite@stuck@clip",
                "Fortnite Stuck",
                animationOptions = {
                    emoteLoop = true,
                    musicURL = musicEnabled and "https://www.youtube.com/watch?v=Wp-rmyFubBk" or nil,
                }
            },
            ["pfsocks"] = {
                "pazeee@fournite@socks@animations",
                "pazeee@fournite@socks@clip",
                "Fortnite Socks",
                animationOptions = {
                    emoteLoop = true,
                    musicURL = musicEnabled and "https://www.youtube.com/watch?v=1xGu9gtRWfA" or nil,
                }
            },
            ["pfpullup"] = {
                "pazeee@fournite@pullup@animations",
                "pazeee@fournite@pullup@clip",
                "Fortnite Pullup",
                animationOptions = {
                    emoteLoop = true,
                    musicURL = musicEnabled and "https://www.youtube.com/watch?v=-DjJzV7-GL0" or nil,
                }
            },
            ["pfchickenwingit"] = {
                "pazeee@fournite@chickenwingit@animations",
                "pazeee@fournite@chickenwingit@clip",
                "Fortnite Chickenwingit",
                animationOptions = {
                    emoteLoop = true,
                    musicURL = musicEnabled and "https://www.youtube.com/watch?v=_ngPSplSpgc" or nil,
                }
            },
            ["pfsavage"] = {
                "pazeee@fournite@savage@animations",
                "pazeee@fournite@savage@clip",
                "Fortnite Savage",
                animationOptions = {
                    emoteLoop = true,
                    musicURL = musicEnabled and "https://www.youtube.com/watch?v=nTbu--YLWLA" or nil,
                }
            },
            ["pfimdiamond"] = {
                "pazeee@fournite@imdiamond@animations",
                "pazeee@fournite@imdiamond@clip",
                "Fortnite Imdiamond",
                animationOptions = {
                    emoteLoop = true,
                    musicURL = musicEnabled and "https://www.youtube.com/watch?v=I5zYXJ1yiYE" or nil,
                }
            },
            ["pfitsdynamite"] = {
                "pazeee@fournite@itsdynamite@animations",
                "pazeee@fournite@itsdynamite@clip",
                "Fortnite Itsdynamite",
                animationOptions = {
                    emoteLoop = true,
                    musicURL = musicEnabled and "https://www.youtube.com/watch?v=XsEWL_TsW-E&pp=ygUWaXQncyBkeW5hbWl0ZSBmb3J0bml0ZQ%3D%3D" or nil,
                }
            },
            ["pftoosieslide"] = {
                "pazeee@fournite@toosieslide@animations",
                "pazeee@fournite@toosieslide@clip",
                "Fortnite Toosieslide",
                animationOptions = {
                    emoteLoop = true,
                    musicURL = musicEnabled and "https://www.youtube.com/watch?v=EauUZdh87FY" or nil,
                }
            },
            ["pftherenegade"] = {
                "pazeee@fournite@therenegade@animations",
                "pazeee@fournite@therenegade@clip",
                "Fortnite Therenegade",
                animationOptions = {
                    emoteLoop = true,
                    musicURL = musicEnabled and "https://www.youtube.com/watch?v=LKiMz03HXBE" or nil,
                }
            },
            ["pfdontstartnow"] = {
                "pazeee@fournite@dontstartnow@animations",
                "pazeee@fournite@dontstartnow@clip",
                "Fortnite Dontstartnow",
                animationOptions = {
                    emoteLoop = true,
                    musicURL = musicEnabled and "https://www.youtube.com/watch?v=rzgcajCBBqk" or nil,
                }
            },
            ["pfambitious"] = {
                "pazeee@fournite@ambitious@animations",
                "pazeee@fournite@ambitious@clip",
                "Fortnite Ambitious",
                animationOptions = {
                    emoteLoop = true,
                    musicURL = musicEnabled and "https://www.youtube.com/watch?v=fZD7QUzdRFw" or nil,
                }
            },
            ["pflunarparty"] = {
                "pazeee@fournite@lunarparty@animations",
                "pazeee@fournite@lunarparty@clip",
                "Fortnite Lunarparty",
                animationOptions = {
                    emoteLoop = true,
                    musicURL = musicEnabled and "https://www.youtube.com/watch?v=SvgwOyZZsCY" or nil,
                }
            },
            ["pfhitit"] = {
                "pazeee@fournite@hitit@animations",
                "pazeee@fournite@hitit@clip",
                "Fortnite Hitit",
                animationOptions = {
                    emoteLoop = true,
                    musicURL = musicEnabled and "https://www.youtube.com/watch?v=Ybt92PJ0Ctg" or nil,
                }
            },
            ["pfnocure"] = {
                "pazeee@fournite@nocure@animations",
                "pazeee@fournite@nocure@clip",
                "Fortnite Nocure",
                animationOptions = {
                    emoteLoop = true,
                    musicURL = musicEnabled and "https://www.youtube.com/watch?v=ueji9Y-aupI" or nil,
                }
            },
            ["pfclickclickflash"] = {
                "pazeee@fournite@clickclickflash@animations",
                "pazeee@fournite@clickclickflash@clip",
                "Fortnite Clickclickflash",
                animationOptions = {
                    emoteLoop = true,
                    musicURL = musicEnabled and "https://www.youtube.com/watch?v=TEROXMSYs2A" or nil,
                }
            },
            ["pfwannaseeme"] = {
                "pazeee@fournite@wannaseeme@animations",
                "pazeee@fournite@wannaseeme@clip",
                "Fortnite Wannaseeme",
                animationOptions = {
                    emoteLoop = true,
                    musicURL = musicEnabled and "https://www.youtube.com/watch?v=5Agma1nPrr8" or nil,
                }
            },
            ["pfheadbanger"] = {
                "pazeee@fournite@headbanger@animations",
                "pazeee@fournite@headbanger@clip",
                "Fortnite Headbanger",
                animationOptions = {
                    emoteLoop = true,
                    musicURL = musicEnabled and "https://www.youtube.com/watch?v=CaDt-ityPJA" or nil,
                }
            },
            ["pfrage"] = {
                "pazeee@fournite@rage@animations",
                "pazeee@fournite@rage@clip",
                "Fortnite Rage",
                animationOptions = {
                    emoteLoop = true,
                    musicURL = musicEnabled and "https://www.youtube.com/watch?v=ml9Sc0zlXHQ" or nil,
                }
            },
            ["pfbigdawgs"] = {
                "pazeee@fournite@bigdawgs@animations",
                "pazeee@fournite@bigdawgs@clip",
                "Fortnite Bigdawgs",
                animationOptions = {
                    emoteLoop = true,
                    musicURL = musicEnabled and "https://www.youtube.com/watch?v=Tskza_xMhK0" or nil,
                }
            },
            ["pfbigdawgsmove"] = {
                "pazeee@fournite@bigdawgsmove@animations",
                "pazeee@fournite@bigdawgsmove@clip",
                "Fortnite Bigdawgsmove",
                animationOptions = {
                    emoteLoop = true,
                    musicURL = musicEnabled and "https://www.youtube.com/watch?v=Tskza_xMhK0" or nil,
                    customMovementType = 47
                }
            },
        },

        Emotes = {}
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