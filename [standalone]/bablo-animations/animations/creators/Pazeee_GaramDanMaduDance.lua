Citizen.CreateThread(function()
    if not Config.Creators['Pazeee_GaramDanMaduDance'] then return end
    
    local Animations = {
        Dances = {
            ["pgaramdanmadu"] = {
                "pgaramdanmadu@animations",
                "pgaramdanmaduclip",
                "Garam Dan Madu Dance",
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