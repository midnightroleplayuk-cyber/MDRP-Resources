Citizen.CreateThread(function()
    if not Config.Creators['Pazeee_FortniteDancePackV5'] then return end

    local musicEnabled = false
    local Animations = {
        Dances = {
            ["pfapt"] = {
                "pazeee@fortnite@apt@animations",
                "pazeee@fortnite@apt@clip",
                "Fortnite APT",
                animationOptions = {
                    emoteLoop = true,
                    musicURL = musicEnabled and "https://www.youtube.com/watch?v=EMz07eRFfjE" or nil,
                }
            },
            ["pfroar"] = {
                "pazeee@fortnite@roar@animations",
                "pazeee@fortnite@roar@clip",
                "Fortnite Roar",
                animationOptions = {
                    emoteLoop = true,
                    musicURL = musicEnabled and "https://www.youtube.com/watch?v=wxHBMEzHUPs" or nil,
                }
            },
            ["pffirework"] = {
                "pazeee@fortnite@firework@animations",
                "pazeee@fortnite@firework@clip",
                "Fortnite Firework",
                animationOptions = {
                    emoteLoop = true,
                    musicURL = musicEnabled and "https://www.youtube.com/watch?v=F_uITI1zuL8" or nil,
                }
            },
            ["pfhumble"] = {
                "pazeee@fortnite@humble@animations",
                "pazeee@fortnite@humble@clip",
                "Fortnite Humble",
                animationOptions = {
                    emoteLoop = true,
                    musicURL = musicEnabled and "https://www.youtube.com/watch?v=RC_gvQu-CD8" or nil,
                }
            },
            ["pf360"] = {
                "pazeee@fortnite@360@animations",
                "pazeee@fortnite@360@clip",
                "Fortnite 360",
                animationOptions = {
                    emoteLoop = true,
                    musicURL = musicEnabled and "https://www.youtube.com/watch?v=NCoLcfaZuLQ" or nil,
                }
            },
            ["pfchasemedown"] = {
                "pazeee@fortnite@chasemedown@animations",
                "pazeee@fortnite@chasemedown@clip",
                "Fortnite Chase Me Down",
                animationOptions = {
                    emoteLoop = true,
                    musicURL = musicEnabled and "https://www.youtube.com/watch?v=EIj6TZQ7PsU" or nil,
                }
            },
            ["pfsmitten"] = {
                "pazeee@fortnite@smitten@animations",
                "pazeee@fortnite@smitten@clip",
                "Fortnite Smitten",
                animationOptions = {
                    emoteLoop = true,
                    musicURL = musicEnabled and "https://www.youtube.com/watch?v=MQ24ScGfDUQ" or nil,
                }
            },
            ["pfitsavibe"] = {
                "pazeee@fortnite@itsavibe@animations",
                "pazeee@fortnite@itsavibe@clip",
                "Fortnite It's A Vibe",
                animationOptions = {
                    emoteLoop = true,
                    musicURL = musicEnabled and "https://www.youtube.com/watch?v=H9Mw6bGXic8" or nil,
                }
            },
            ["pfpopularvibe"] = {
                "pazeee@fortnite@popularvibe@animations",
                "pazeee@fortnite@popularvibe@clip",
                "Fortnite Popular Vibe",
                animationOptions = {
                    emoteLoop = true,
                    musicURL = musicEnabled and "https://www.youtube.com/watch?v=vOxCj2-gfak" or nil,
                }
            },
            ["pfsocialclimber"] = {
                "pazeee@fortnite@socialclimber@animations",
                "pazeee@fortnite@socialclimber@clip",
                "Fortnite Social Climber",
                animationOptions = {
                    emoteLoop = true,
                    musicURL = musicEnabled and "https://www.youtube.com/watch?v=U-V7iK9UBE8" or nil,
                }
            },
            ["pfcupidsarrow"] = {
                "pazeee@fortnite@cupidsarrow@animations",
                "pazeee@fortnite@cupidsarrow@clip",
                "Fortnite Cupid's Arrow",
                animationOptions = {
                    emoteLoop = true,
                    musicURL = musicEnabled and "https://www.youtube.com/watch?v=ZidgfDgrxEU" or nil,
                }
            },
            ["pfboysaliar"] = {
                "pazeee@fortnite@boysaliar@animations",
                "pazeee@fortnite@boysaliar@clip",
                "Fortnite Boy's A Liar",
                animationOptions = {
                    emoteLoop = true,
                    musicURL = musicEnabled and "https://www.youtube.com/watch?v=lGe6N6SsjzU" or nil,
                }
            },
            ["pfbizcochito"] = {
                "pazeee@fortnite@bizcochito@animations",
                "pazeee@fortnite@bizcochito@clip",
                "Fortnite Bizcochito",
                animationOptions = {
                    emoteLoop = true,
                    musicURL = musicEnabled and "https://www.youtube.com/watch?v=xSuOLETFLkw" or nil,
                }
            },
            ["pfcelebrateme"] = {
                "pazeee@fortnite@celebrateme@animations",
                "pazeee@fortnite@celebrateme@clip",
                "Fortnite Celebrate Me",
                animationOptions = {
                    emoteLoop = true,
                    musicURL = musicEnabled and "https://www.youtube.com/watch?v=rUkUrvBmcDE" or nil,
                }
            },
            ["pfgoated"] = {
                "pazeee@fortnite@goated@animations",
                "pazeee@fortnite@goated@clip",
                "Fortnite Goated",
                animationOptions = {
                    emoteLoop = true,
                    musicURL = musicEnabled and "https://www.youtube.com/watch?v=jYPHRr-ECm4" or nil,
                }
            },
            ["pfnightout"] = {
                "pazeee@fortnite@nightout@animations",
                "pazeee@fortnite@nightout@clip",
                "Fortnite Night Out",
                animationOptions = {
                    emoteLoop = true,
                    musicURL = musicEnabled and "https://www.youtube.com/watch?v=dYxEL9daI2A&pp=0gcJCY0JAYcqIYzv" or nil,
                }
            },
            ["pfrunitdown"] = {
                "pazeee@fortnite@runitdown@animations",
                "pazeee@fortnite@runitdown@clip",
                "Fortnite Run It Down",
                animationOptions = {
                    emoteLoop = true,
                    musicURL = musicEnabled and "https://www.youtube.com/watch?v=rYmtHTeJycA" or nil,
                }
            },
            ["pfwithoutyou"] = {
                "pazeee@fortnite@withoutyou@animations",
                "pazeee@fortnite@withoutyou@clip",
                "Fortnite Without You",
                animationOptions = {
                    emoteLoop = true,
                    musicURL = musicEnabled and "https://www.youtube.com/watch?v=UVUy0cw6VkQ&pp=0gcJCY0JAYcqIYzv" or nil,
                }
            },
            ["pfblahblahblah"] = {
                "pazeee@fortnite@blahblahblah@animations",
                "pazeee@fortnite@blahblahblah@clip",
                "Fortnite Blah Blah Blah",
                animationOptions = {
                    emoteLoop = true,
                    musicURL = musicEnabled and "https://www.youtube.com/watch?v=ejZnIL0vtjA" or nil,
                }
            },
            ["pfletsgetitstarted"] = {
                "pazeee@fortnite@letsgetitstarted@animations",
                "pazeee@fortnite@letsgetitstarted@clip",
                "Fortnite Let's Get It Started",
                animationOptions = {
                    emoteLoop = true,
                    musicURL = musicEnabled and "https://www.youtube.com/watch?v=ZTSSBtj5vnE" or nil,
                }
            },
            ["pfbet"] = {
                "pazeee@fortnite@bet@animations",
                "pazeee@fortnite@bet@clip",
                "Fortnite Bet",
                animationOptions = {
                    emoteLoop = true,
                    musicURL = musicEnabled and "https://www.youtube.com/watch?v=plq-ZMTJWhw" or nil,
                }
            },
            ["pfratatata"] = {
                "pazeee@fortnite@ratatata@animations",
                "pazeee@fortnite@ratatata@clip",
                "Fortnite Ratatata",
                animationOptions = {
                    emoteLoop = true,
                    musicURL = musicEnabled and "https://www.youtube.com/watch?v=MKrr-csRikc" or nil,
                }
            },
            ["pftaste"] = {
                "pazeee@fortnite@taste@animations",
                "pazeee@fortnite@taste@clip",
                "Fortnite Taste",
                animationOptions = {
                    emoteLoop = true,
                    musicURL = musicEnabled and "https://www.youtube.com/watch?v=6LI2KfOo1sI" or nil,
                }
            },
            ["pfpleasepleaseplease"] = {
                "pazeee@fortnite@pleasepleaseplease@animations",
                "pazeee@fortnite@pleasepleaseplease@clip",
                "Fortnite Please Please Please",
                animationOptions = {
                    emoteLoop = true,
                    musicURL = musicEnabled and "https://www.youtube.com/watch?v=JjDNWqnNuy4" or nil,
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
