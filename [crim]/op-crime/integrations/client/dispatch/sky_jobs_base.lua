if Config.dispatchScript == "sky_jobs_base" then
    function sendDispatchAlert(title, message, blipData, coords, Type)
        local code = Type or "10-90"
        local dispatchCoords = coords

        if dispatchCoords then
            if dispatchCoords.w then
                dispatchCoords = vec3(dispatchCoords.x, dispatchCoords.y, dispatchCoords.z)
            elseif type(dispatchCoords) == "table" and dispatchCoords.x and dispatchCoords.y and dispatchCoords.z then
                dispatchCoords = vec3(dispatchCoords.x, dispatchCoords.y, dispatchCoords.z)
            end
        end

        exports['sky_jobs_base']:createDispatch(
            ('%s - %s'):format(code, title),
            message,
            dispatchCoords,
            'police',
            {}
        )
    end
end