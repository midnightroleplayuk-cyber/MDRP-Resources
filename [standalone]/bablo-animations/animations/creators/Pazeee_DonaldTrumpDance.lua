Citizen.CreateThread(function()
    if not Config.Creators['Pazeee_DonaldTrumpDance'] then return end
    
    local Animations = {
        Dances = {
            ["ptrump"] = {
                "ptrump@animations",
                "ptrumpclip",
                "Trump Dance",
                animationOptions = {
                    emoteLoop = true
                }
            },
            ["ptrumpsup"] = {
                "ptrumpsup@animations",
                "ptrumpsupclip",
                "Trump Supporters Dance",
                animationOptions = {
                    emoteLoop = true
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