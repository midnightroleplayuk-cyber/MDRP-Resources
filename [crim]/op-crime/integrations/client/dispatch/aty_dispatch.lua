if Config.dispatchScript == "aty_dispatchv2" then
    function sendDispatchAlert(title, message, blipData, coords, Type)
        exports["aty_dispatchv2"]:SendDispatch({
            title = title,           -- Required: Title of the dispatch
            code = "10-90",                   -- Required: Dispatch code
            blipType = blipData.sprite,                   -- Optional: Blip sprite ID (default: 1)
            blipName = title,        -- Optional: Name of the blip on the map
            jobs = {"police", "sheriff"},     -- Optional: Specific jobs that will receive this dispatch
            coords = coords,        -- Optional: Custom coordinates (defaults to player pos)
        })
    end
end