function Weather(freeze)
    local weatherScript = exports['av_laptop']:getWeatherScript()
    if freeze then -- freeze time
        if weatherScript == "av_weather" then
            TriggerEvent('av_weather:freeze',true, 22, 0, 'CLEAR')
            return
        end
        if weatherScript == "qb-weathersync" then
            TriggerEvent('qb-weathersync:client:DisableSync')
        end
    else  -- unfreeze time
        if weatherScript == "av_weather" then
            TriggerEvent('av_weather:freeze',false)
            return
        end
        if weatherScript == "qb-weathersync" then
            TriggerEvent('qb-weathersync:client:EnableSync')
            return
        end
    end
    TriggerEvent('cd_easytime:PauseSync', freeze) -- for cd_easytime
    overrideTime()
end

function overrideTime()
    SetWeatherTypePersist('CLEAR')
    SetWeatherTypeNow('CLEAR')
    SetWeatherTypeNowPersist('CLEAR')
    NetworkOverrideClockTime(20, 0, 0)
end