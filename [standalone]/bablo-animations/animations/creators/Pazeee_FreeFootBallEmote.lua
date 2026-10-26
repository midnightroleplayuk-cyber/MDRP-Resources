Citizen.CreateThread(function()
    if not Config.Creators['Pazeee_FreeFootBallEmote'] then return end

    local Animations = {
        Dances = {},

        Emotes = {
            ["pfootball1"] = { -- Custom Emote By Pazeee
                "pazeee@football1@animations",
                "pazeee@football1@clip",
                "Football Back Middle",
                animationOptions = {
                    emoteLoop = true
                }
            },
            ["pfootball2"] = { -- Custom Emote By Pazeee
                "pazeee@football2@animations",
                "pazeee@football2@clip",
                "Football Back Right",
                animationOptions = {
                    emoteLoop = true
                }
            },
            ["pfootball3"] = { -- Custom Emote By Pazeee
                "pazeee@football3@animations",
                "pazeee@football3@clip",
                "Football Front Right",
                animationOptions = {
                    emoteLoop = true
                }
            },
            ["pfootball4"] = { -- Custom Emote By Pazeee
                "pazeee@football4@animations",
                "pazeee@football4@clip",
                "Football Front Middle",
                animationOptions = {
                    emoteLoop = true
                }
            },
            ["pfootball5"] = { -- Custom Emote By Pazeee
                "pazeee@football5@animations",
                "pazeee@football5@clip",
                "Football Front Left",
                animationOptions = {
                    emoteLoop = true
                }
            },
            ["pfootball6"] = { -- Custom Emote By Pazeee
                "pazeee@football6@animations",
                "pazeee@football6@clip",
                "Football Back Left",
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