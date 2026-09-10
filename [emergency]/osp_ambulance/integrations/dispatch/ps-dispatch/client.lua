Dispatch = Dispatch or {}

Dispatch['ps-dispatch'] = {
    alert = function(coords, message)
        -- Prefer injured civilian alert; fall back to custom if export is missing
        if GetResourceState('ps-dispatch') ~= 'started' then
            return
        end

        local ok = pcall(function()
            exports['ps-dispatch']:InjuriedPerson()
        end)

        if ok then
            return
        end

        pcall(function()
            exports['ps-dispatch']:CustomAlert({
                coords = coords,
                message = message,
                dispatchCode = '10-69',
                description = message,
                radius = 0,
                sprite = 61,
                color = 1,
                scale = 1.2,
                length = 3,
                jobs = { 'ems' },
            })
        end)
    end
}
