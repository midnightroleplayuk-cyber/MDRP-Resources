Citizen.CreateThread(function()
    if not Config.Creators['Pazeee_SquidGameRoundAndRound'] then return end
    
    local Animations = {
        Dances = {
            ["psquidgameround"] = {
                "psquidgameround@animations",
                "psquidgameroundclip",
                "Squid Game Round and Round",
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