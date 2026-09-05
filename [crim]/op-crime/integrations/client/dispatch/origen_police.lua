if Config.dispatchScript == "origen_police" then
    function sendDispatchAlert(title, message, blipData, coordsData, Type)
        TriggerServerEvent("SendAlert:police", {
            coords = coordsData,
            title = title,
            type = Type,
            message = message,
            job = 'police'
        })
    end
end