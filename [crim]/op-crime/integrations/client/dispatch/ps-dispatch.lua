if Config.dispatchScript == "ps-dispatch" then

    function sendDispatchAlert(title, message, blipData, coordsData, Type)
        local dispatchData = {
            message = message, -- add this into your locale
            codeName = Type, -- this should be the same as in config.lua
            code = Type,
            icon = 'fas fa-car-burst',
            priority = 2,
            coords = coordsData,
            street = GetStreetNameFromHashKey(GetStreetNameAtCoord(coordsData.x, coordsData.y, coordsData.z)),
            heading = coordsData.w or 0.0,
            jobs = { 'police' }
        }

        TriggerServerEvent('ps-dispatch:server:notify', dispatchData)
    end
end