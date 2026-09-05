if Config.dispatchScript == "rcore_dispatch" then

    function sendDispatchAlert(title, message, blipData, coordsData, Type)
        local alertCoords = coordsData
        if not alertCoords then
            local playerData = exports['rcore_dispatch']:GetPlayerData()
            alertCoords = playerData and playerData.coords
        else
            alertCoords = vector3(alertCoords.x + 0.0, alertCoords.y + 0.0, alertCoords.z + 0.0)
        end

        local alertData = {
            code = Type,
            default_priority = 'medium',
            coords = alertCoords,
            job = 'police',
            text = message,
            type = 'alerts',
            blip_time = 5,
            blip = {
                sprite = blipData.sprite,
                colour = blipData.color,
                scale = 0.7,
                text = title,
                flashes = false,
                radius = 0,
            }
        }

        TriggerServerEvent('rcore_dispatch:server:sendAlert', alertData)
    end
end