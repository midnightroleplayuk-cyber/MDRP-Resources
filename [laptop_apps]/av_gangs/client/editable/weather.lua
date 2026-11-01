function Weather(freeze)
    dbug('Weather(freeze?)', freeze)
    local weatherScript = exports['av_laptop']:getWeatherScript()
    if freeze then -- freeze time
        if weatherScript == "av_weather" then
            dbug("Using av_weather...")
            TriggerEvent('av_weather:freeze',true, 22, 0, 'CLEAR')
            return
        end
        if weatherScript == "qb-weathersync" then
            dbug("Using qb-weathersync...")
            TriggerEvent('qb-weathersync:client:DisableSync')
        end
    else  -- unfreeze time
        if weatherScript == "av_weather" then
            dbug("Using av_weather...")
            TriggerEvent('av_weather:freeze',false)
            return
        end
        if weatherScript == "qb-weathersync" then
            dbug("Using qb-weathersync...")
            TriggerEvent('qb-weathersync:client:EnableSync')
            return
        end
    end
    dbug("Using cd_easytime...")
    TriggerEvent('cd_easytime:PauseSync', freeze) -- for cd_easytime
    overrideTime()
end

function overrideTime()
    Wait(1000)
    SetWeatherTypePersist('CLEAR')
    SetWeatherTypeNow('CLEAR')
    SetWeatherTypeNowPersist('CLEAR')
    NetworkOverrideClockTime(20, 0, 0)
end