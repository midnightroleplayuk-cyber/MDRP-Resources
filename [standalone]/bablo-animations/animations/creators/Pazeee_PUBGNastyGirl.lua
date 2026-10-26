Citizen.CreateThread(function()
    if not Config.Creators['Pazeee_PUBGNastyGirl'] then return end
    
    local Animations = {
        Dances = {
            ["pubgnastygirl"] = {"nastygirl@animations", "nastygirlclip", "PUBG Nasty Girl", animationOptions =
            {
                emoteLoop = true,
            }},
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