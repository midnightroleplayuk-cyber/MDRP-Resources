if Config.dispatchScript == "none" then

    function sendDispatchAlert(title, message, blipData, coords, Type)
        TriggerServerEvent('op-crime:dispatchAttempt', nil, 'none', title, Type)
    end
end