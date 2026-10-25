Citizen.CreateThread(function()
    if not Config.Creators['Pazeee_FunHide'] then return end
    
    local Animations = {
        Dances = {},

        Emotes = {
            ["hidef"] = {"hidef@animations", "hidefclip", "Hide Forward", animationOptions =
            {
                emoteLoop = true,
            }},
            ["hideb"] = {"hideb@animations", "hidebclip", "Hide Backward", animationOptions =
            {
                emoteLoop = true,
            }},
            ["hider"] = {"hider@animations", "hiderclip", "Hide Right", animationOptions =
            {
                emoteLoop = true,
            }},
            ["hidel"] = {"hidel@animations", "hidelclip", "Hide Left", animationOptions =
            {
                emoteLoop = true,
            }},
            ["hidecarf"] = {"hidecarf@animations", "hidecarfclip", "Hide Car Forward", animationOptions =
            {
                emoteLoop = true,
            }},
            ["hidecarb"] = {"hidecarb@animations", "hidecarbclip", "Hide Car Backward", animationOptions =
            {
                emoteLoop = true,
            }},
            ["hidecarr"] = {"hidecarr@animations", "hidecarrclip", "Hide Car Right", animationOptions =
            {
                emoteLoop = true,
            }},
            ["hidecarl"] = {"hidecarl@animations", "hidecarlclip", "Hide Car Left", animationOptions =
            {
                emoteLoop = true,
            }},
            ["hidepole"] = {"hidepole@animations", "hidepoleclip", "Hide Pole", animationOptions =
            {
                emoteLoop = true,
            }},
            ["hidepolehigh"] = {"hidepolehigh@animations", "hidepolehighclip", "Hide Pole High", animationOptions =
            {
                emoteLoop = true,
            }},
            ["hidepolehigh2"] = {"hidepolehigh2@animations", "hidepolehigh2clip", "Hide Pole High 2", animationOptions =
            {
                emoteLoop = true,
            }},
            ["hidepoleveryhigh"] = {"hidepoleveryhigh@animations", "hidepoleveryhighclip", "Hide Pole Very High", animationOptions =
            {
                emoteLoop = true,
            }},
            ["hidepoleveryhigh2"] = {"hidepoleveryhigh2@animations", "hidepoleveryhigh2clip", "Hide Pole Very High 2", animationOptions =
            {
                emoteLoop = true,
            }},
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