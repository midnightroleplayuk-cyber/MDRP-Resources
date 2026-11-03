-- This is used for the replay system
local hours, mins, seconds = 0, 0, 0

AddEventHandler('av_weather:timeUpdated',function(h, m, s)
    hours, mins, seconds = h, m, s
end)

function getWeatherSettings()
    local data = {
        hours = hours,
        mins = mins,
        seconds = seconds,
    }
    if GetResourceState("av_weather") == "started" then
        local zone = exports['av_weather']:getZone()
        data.weather = zone and zone['weather'] or "CLEAR"
    else
        data.weather = "CLEAR"
        data.hours = GetClockHours()
        data.mins = GetClockMinutes()
        data.seconds = GetClockSeconds()
    end
--    dbug("Current weather settings:", json.encode(data))
    return data
end

function setWeatherSettings(weatherData)
    ClearOverrideWeather()
    ClearWeatherTypePersist()
    SetWeatherTypeNow(weatherData.weather)
    SetWeatherTypePersist(weatherData.weather)
    NetworkOverrideClockTime(weatherData.hours, weatherData.mins, weatherData.seconds)
end

function stopWeather(state)
    if state then
        -- Freeze weather for local player during playback to prevent desync with recorded weather
        TriggerEvent('av_weather:freeze', true)
    else
        -- Unfreeze weather after playback ends to allow it to update again based on time and zone
        TriggerEvent('av_weather:freeze', false)
    end
end