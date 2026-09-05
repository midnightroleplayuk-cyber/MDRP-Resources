if Config.dispatchScript == "codem_dispatch" then

    function sendDispatchAlert(title, message, blipData, coords, Type)
        local Data = {
            type = Type,
            header = title,
            text = message,
            code = Config.DispatchTypes[Type] and Config.DispatchTypes[Type].code or "Unknown",
            coords = coords
        }

        exports['codem-dispatch']:CustomDispatch(Data)
    end
end