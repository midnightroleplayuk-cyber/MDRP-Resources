Citizen.CreateThread(function()
    if not Config.Creators['Pazeee_PUBGMeninaDoJob'] then return end
    
    local Animations = {
        Dances = {
            ["pmeninadojob"] = {
                "pmeninadojob@animations",
                "pmeninadojobclip",
                "PUBG Menina Do Job Dance",
                animationOptions = {
                    customMovementType = 33,
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