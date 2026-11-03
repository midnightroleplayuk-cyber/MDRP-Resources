if Sky.Config.weather ~= "qb-weathersync" then return end
if IsDuplicityVersion() then return end

-- Setup: https://www.sky-systems.net/docs/base/weather-integrations#qb-weathersync
function Sky.Functions.AcquireWeatherOverride()
    if GetResourceMetadata("qb-weathersync", "sky_weather_pause", 0) ~= "1" then
        return false, "Complete the qb-weathersync setup in the Sky Base weather integration tutorial."
    end
    local state = Sky.Functions.CaptureWeatherState()
    TriggerEvent("qb-weathersync:client:DisableSync")
    return state
end

Sky.Functions.ApplyWeatherOverride = Sky.Functions.ApplyNativeWeatherOverride

function Sky.Functions.ReleaseWeatherOverride(state)
    Sky.Functions.RestoreWeatherState(state)
    TriggerEvent("qb-weathersync:client:EnableSync")
end
