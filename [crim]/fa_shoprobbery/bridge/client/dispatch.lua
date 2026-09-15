Bridge = Bridge or {}

local detectedDispatch

local function detectDispatch()
    if detectedDispatch then return detectedDispatch end

    if Config.Dispatch ~= 'auto' then
        detectedDispatch = Config.Dispatch
        return detectedDispatch
    end

    if ResourceStarted('ps-dispatch') then
        detectedDispatch = 'ps-dispatch'
    elseif ResourceStarted('cd_dispatch') then
        detectedDispatch = 'cd_dispatch'
    elseif ResourceStarted('qs-dispatch') then
        detectedDispatch = 'qs-dispatch'
    elseif ResourceStarted('rcore_dispatch') then
        detectedDispatch = 'rcore_dispatch'
    elseif ResourceStarted('tk_dispatch') then
        detectedDispatch = 'tk_dispatch'
    elseif ResourceStarted('p_mdt') then
        detectedDispatch = 'p_mdt'
    else
        detectedDispatch = 'none'
    end

    return detectedDispatch
end

function Bridge.GetDetectedDispatch()
    return detectDispatch()
end

function Bridge.SendDispatch(store, coords, alertType)
    local dispatch = detectDispatch()
    local message = alertType == 'fight' and locale('police_alert_fight', store.label, store.cameraId or 'N/A') or locale('police_alert', store.label, store.cameraId or 'N/A')

    if dispatch == 'ps-dispatch' then
        exports['ps-dispatch']:CustomAlert({
            coords = coords,
            message = message,
            dispatchCode = '10-90',
            description = 'Store Robbery',
            radius = 0,
            sprite = 59,
            color = 1,
            scale = 1.1,
            length = 180000
        })
        return
    end

    if dispatch == 'cd_dispatch' then
        TriggerServerEvent('cd_dispatch:AddNotification', {
            job_table = Config.PoliceJobs,
            coords = coords,
            title = '10-90 - Store Robbery',
            message = message,
            flash = 0,
            unique_id = tostring(math.random(1000000, 9999999)),
            blip = {
                sprite = 59,
                scale = 1.1,
                colour = 1,
                flashes = false,
                text = 'Store Robbery',
                time = 180
            }
        })
        return
    end

    if dispatch == 'qs-dispatch' then
        exports['qs-dispatch']:StoreRobbery()
        return
    end

    if dispatch == 'rcore_dispatch' then
        TriggerServerEvent('rcore_dispatch:server:sendAlert', {
            code = '10-90',
            default_priority = 'high',
            coords = coords,
            job = Config.PoliceJobs,
            text = message,
            type = 'shop_robbery',
            blip = {
                sprite = 59,
                color = 1,
                scale = 1.1,
                label = ('Store Robbery - %s'):format(store.label)
            }
        })
        return
    end

    if dispatch == 'tk_dispatch' then
        exports.tk_dispatch:addCall({
            title = 'Store Robbery',
            message = message,
            coords = coords,
            showLocation = true,
            showGender = true,
            playSound = true,
            blip = { color = 1, sprite = 59, scale = 1.1 },
            jobs = Config.PoliceJobs
        })
        return
    end

    if dispatch == 'qb' then
        TriggerServerEvent('police:server:policeAlert', message)
        return
    end

    if dispatch == 'p_mdt' then
        TriggerServerEvent('p_mdt/createAlert', {
            priority = 'high',
            code = '10-90',
            title = ('10-90 - %s'):format(store.label),
            description = message,
            coords = coords,
            fields = {
                { icon = 'fa-solid fa-store', label = 'Store', value = store.label },
                { icon = 'fa-solid fa-video', label = 'Camera', value = tostring(store.cameraId or 'N/A') },
                { icon = 'fa-solid fa-triangle-exclamation', label = 'Alert', value = alertType }
            },
            alertTime = 120,
            sound = 'shots_fired',
            blip = {
                sprite = 59,
                color = 1,
                scale = 1.1,
                shortRange = true,
                name = ('Store Robbery - %s'):format(store.label)
            }
        })
        return
    end

    if dispatch == 'custom' then
        -- put your dispatch export over here, if you want it added to the script, please contact us at our discord -> discord.gg/ePYv5V5b8w
        print('No dispatch system detected. Please configure one in the bridge/client/dispatch.lua file.')
    end
end
