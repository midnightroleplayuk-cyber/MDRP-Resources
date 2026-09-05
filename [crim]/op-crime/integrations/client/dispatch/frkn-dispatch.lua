if Config.dispatchScript == "frkn-dispatch" then
    function sendDispatchAlert(title, message, blipData, coords, Type)
        exports['frkn-dispatch']:CustomAlert({
            message = message,
            dispatchCode = title,
            code = message,
            icon = 'fas fa-phone',
            priority = 2,
            alert = { sprite = blipData.sprite, scale = 0.5 },
            coords = coords,
        })
    end
end