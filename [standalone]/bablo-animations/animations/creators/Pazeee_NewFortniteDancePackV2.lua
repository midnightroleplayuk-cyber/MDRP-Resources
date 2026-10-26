Citizen.CreateThread(function()
    if not Config.Creators['Pazeee_NewFortniteDancePackV2'] then return end
    
    local musicEnabled = false
    local Animations = {
        Emotes = {},

        Dances = {
           ["pfflytotokyo"] = {
                "pfflytotokyo@animations",
                "pfflytotokyoclip",
                "Fortnite Fly To Tokyo",
                animationOptions = {
                    emoteLoop = true,
                    musicURL = musicEnabled and "https://www.youtube.com/watch?v=_1HaRISQAwE" or nil,
                }
            },
            ["pfattraction"] = {
                "pfattraction@animations",
                "pfattractionclip",
                "Fortnite Attraction",
                animationOptions = {
                    emoteLoop = true,
                    musicURL = musicEnabled and "https://www.youtube.com/watch?v=eOB2bXSewm0" or nil,
                }
            },
            ["pfluciddreams"] = {
                "pfluciddreams@animations",
                "pfluciddreamsclip",
                "Fortnite Lucid Dreams",
                animationOptions = {
                    emoteLoop = true,
                    musicURL = musicEnabled and "https://www.youtube.com/watch?v=2B0OPVgEDMs" or nil,
                }
            },
            ["pfskeledance"] = {
                "pfskeledance@animations",
                "pfskeledanceclip",
                "Fortnite Skele Dance",
                animationOptions = {
                    emoteLoop = true,
                    musicURL = musicEnabled and "https://www.youtube.com/watch?v=MU6RGn-RJao" or nil,
                }
            },
            ["pftheviper"] = {
                "pftheviper@animations",
                "pftheviperclip",
                "Fortnite The Viper",
                animationOptions = {
                    emoteLoop = true,
                    musicURL = musicEnabled and "https://www.youtube.com/watch?v=6V4TnPCBZCg" or nil,
                }
            },
            ["pfgethot"] = {
                "pfgethot@animations",
                "pfgethotclip",
                "Fortnite Get Hot",
                animationOptions = {
                    emoteLoop = true,
                    musicURL = musicEnabled and "https://www.youtube.com/watch?v=om_VWft1mL4" or nil,
                }
            },
            ["pfemptyoutyourpockets"] = {
                "pfemptyoutyourpockets@animations",
                "pfemptyoutyourpocketsclip",
                "Fortnite Empty Out Your Pockets",
                animationOptions = {
                    emoteLoop = true,
                    musicURL = musicEnabled and "https://www.youtube.com/watch?v=RnzWlmXfFag" or nil,
                }
            },
            ["pfrapmonster"] = {
                "pfrapmonster@animations",
                "pfrapmonsterclip",
                "Fortnite Rap Monster",
                animationOptions = {
                    emoteLoop = true,
                    musicURL = musicEnabled and "https://www.youtube.com/watch?v=yutSQQdFqMo" or nil,
                }
            },
            ["pfmaskoff"] = {
                "pfmaskoff@animations",
                "pfmaskoffclip",
                "Fortnite Mask Off",
                animationOptions = {
                    emoteLoop = true,
                    musicURL = musicEnabled and "https://www.youtube.com/watch?v=sdtsaSGHBGQ" or nil,
                }
            },
            ["pfnuthinbutagthang"] = {
                "pfnuthinbutagthang@animations",
                "pfnuthinbutagthangclip",
                "Fortnite Nuthin' But A G Thang",
                animationOptions = {
                    emoteLoop = true,
                    musicURL = musicEnabled and "https://www.youtube.com/watch?v=gZFlp7lAxis" or nil,
                }
            },
            ["pfcoffin"] = {
                "pfcoffin@animations",
                "pfcoffinclip",
                "Fortnite Coffin",
                animationOptions = {
                    emoteLoop = true,
                    musicURL = musicEnabled and "https://www.youtube.com/watch?v=ONUi8heRhnc" or nil,
                }
            },
            ["pfcoffinmove"] = {
                "pfcoffinmove@animations",
                "pfcoffinmoveclip",
                "Fortnite Coffin Move",
                animationOptions = {
                    emoteLoop = true,
                    musicURL = musicEnabled and "https://www.youtube.com/watch?v=ONUi8heRhnc" or nil,
                }
            },
            ["pfcalifornialove"] = {
                "pfcalifornialove@animations",
                "pfcalifornialoveclip",
                "Fortnite California Love",
                animationOptions = {
                    emoteLoop = true,
                    musicURL = musicEnabled and "https://www.youtube.com/watch?v=zloAnBpJaUk" or nil,
                }
            },
            ["pfbyebyebye"] = {
                "pfbyebyebye@animations",
                "pfbyebyebyeclip",
                "Fortnite Bye Bye Bye",
                animationOptions = {
                    emoteLoop = true,
                    musicURL = musicEnabled and "https://www.youtube.com/watch?v=tF9vteqYIIg" or nil,
                }
            },
            ["pfsoarabove"] = {
                "pfsoarabove@animations",
                "pfsoaraboveclip",
                "Fortnite Soar Above",
                animationOptions = {
                    emoteLoop = true,
                    musicURL = musicEnabled and "https://www.youtube.com/watch?v=tF9vteqYIIg" or nil,
                }
            },
            ["pfalliwantforchristmas"] = {
                "pfalliwantforchristmas@animations",
                "pfalliwantforchristmasclip",
                "Fortnite All I Want For Christmas",
                animationOptions = {
                    emoteLoop = true,
                    musicURL = musicEnabled and "https://www.youtube.com/watch?v=mKbZ2dnI5PE" or nil,
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