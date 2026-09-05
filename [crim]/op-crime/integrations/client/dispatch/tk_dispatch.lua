if Config.dispatchScript == "tk_dispatch" then

    -- Client only prepares street label (native is client-side), then hands
    -- off to the server helper which calls tk_dispatch without a player source.
    function sendDispatchAlert(title, message, blipData, coords, Type)
        if not coords then return end

        local pos = vector3(coords.x + 0.0, coords.y + 0.0, coords.z + 0.0)

        local streetHash, crossingHash = GetStreetNameAtCoord(pos.x, pos.y, pos.z)
        local street = GetStreetNameFromHashKey(streetHash)
        local crossing = crossingHash and crossingHash ~= 0 and GetStreetNameFromHashKey(crossingHash) or nil
        local location = street or "Unknown"
        if crossing and crossing ~= "" then
            location = ("%s / %s"):format(location, crossing)
        end

        local alertMessage = message
        if alertMessage and alertMessage ~= "" then
            alertMessage = ("%s | %s"):format(alertMessage, location)
        else
            alertMessage = location
        end

        TriggerServerEvent('op-crime:tkDispatchAlert', {
            title = title,
            code = Type or 'C04',
            message = alertMessage,
            location = location,
            coords = { x = pos.x, y = pos.y, z = pos.z },
            blip = {
                color = blipData and blipData.color or 1,
                sprite = blipData and blipData.sprite or 161,
                scale = 1.0,
            },
        })
    end
end
