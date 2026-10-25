Citizen.CreateThread(function()
    if not Config.Creators['Pazeee_CR7SIU'] then return end
    
    local Animations = {
        Dances = {},

        Emotes = {
            ["cr7siu"] = {
                "cr7siu@animations",
                "cr7siu_clip",
                "SIUUUU",
                animationOptions = {
                    emoteLoop = true,
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