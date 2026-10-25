Citizen.CreateThread(function()
    if not Config.Creators['Pazeee_CatUAI'] then return end
    
    local Animations = {
        Dances = {
            ["pcatui"] = {
                "pcatui@animations",
                "pcatuiclip",
                "Meme Cat UI Dance",
                animationOptions = {
                    emoteLoop = true
                }
            },
            ["pcatuai1"] = {
                "pcatuai1@animations",
                "pcatuai1clip",
                "Meme Cat UAI Dance",
                animationOptions = {
                    emoteLoop = true
                }
            },
            ["pcatuai2"] = {
                "pcatuai2@animations",
                "pcatuai2clip",
                "Meme Cat UAI Dance Fast",
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