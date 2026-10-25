Citizen.CreateThread(function()
    if not Config.Creators['Pazeee_FortnitePack_1'] then return end
    
    local musicEnabled = false
    local Animations = {
        Emotes = {},

        Dances = {
           ["pfriches"] = {
                "pfriches@animations",
                "pfrichesclip",
                "Fortnite Riches",
                animationOptions = {
                    emoteLoop = true,
                    musicURL = musicEnabled and "https://www.youtube.com/watch?v=xHueGjCO1Ug" or nil,
                }
            },
            ["pfdesirable"] = {
                "pfdesirable@animations",
                "pfdesirableclip",
                "Fortnite Desirable",
                animationOptions = {
                    emoteLoop = true,
                    musicURL = musicEnabled and "https://www.youtube.com/watch?v=AcBj5NTU-IE" or nil,
                }
            },
            ["pftakeitslow"] = {
                "pftakeitslow@animations",
                "pftakeitslowclip",
                "Fortnite Take It Slow",
                animationOptions = {
                    emoteLoop = true,
                    musicURL = musicEnabled and "https://www.youtube.com/watch?v=c3-TKwqWBP8" or nil,
                }
            },
            ["pfthedog"] = {
                "pfthedog@animations",
                "pfthedogclip",
                "Fortnite The Dog",
                animationOptions = {
                    emoteLoop = true,
                    musicURL = musicEnabled and "https://www.youtube.com/watch?v=voidvHMoto4" or nil,
                }
            },
            ["pfsnoopswalk"] = {
                "pfsnoopswalk@animations",
                "pfsnoopswalkclip",
                "Fortnite Snoop's Walk",
                animationOptions = {
                    emoteLoop = true,
                    musicURL = musicEnabled and "https://www.youtube.com/watch?v=voidvHMoto4" or nil,
                }
            },
            ["pfrhythmofchaos"] = {
                "pfrhythmofchaos@animations",
                "pfrhythmofchaosclip",
                "Fortnite Rhythm of Chaos",
                animationOptions = {
                    emoteLoop = true,
                    musicURL = musicEnabled and "https://www.youtube.com/watch?v=HzuRw5LduCg" or nil,
                }
            },
            ["pfmoongazer"] = {
                "pfmoongazer@animations",
                "pfmoongazerclip",
                "Fortnite Moongazer",
                animationOptions = {
                    emoteLoop = true,
                    musicURL = musicEnabled and "https://www.youtube.com/watch?v=uk1k2zG_8bw" or nil,
                }
            },
            ["pfcaffeinated"] = {
                "pfcaffeinated@animations",
                "pfcaffeinatedclip",
                "Fortnite Caffeinated",
                animationOptions = {
                    emoteLoop = true,
                    musicURL = musicEnabled and "https://www.youtube.com/watch?v=OvSwA2RZdVM" or nil,
                }
            },
            ["pfcaffeinatedold"] = {
                "pfcaffeinatedold@animations",
                "pfcaffeinatedoldclip",
                "Fortnite Caffeinated Old",
                animationOptions = {
                    emoteLoop = true,
                    musicURL = musicEnabled and "https://www.youtube.com/watch?v=2PqRzkI5tZc" or nil,
                }
            },
            ["pfcommitted"] = {
                "pfcommitted@animations",
                "pfcommittedclip",
                "Fortnite Committed",
                animationOptions = {
                    emoteLoop = true,
                    musicURL = musicEnabled and "https://www.youtube.com/watch?v=v_VMAadciG8" or nil,
                }
            },
            ["pfdimensional"] = {
                "pfdimensional@animations",
                "pfdimensionalclip",
                "Fortnite Dimensional",
                animationOptions = {
                    emoteLoop = true,
                    musicURL = musicEnabled and "https://www.youtube.com/watch?v=FKe0XnbyaBU" or nil,
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