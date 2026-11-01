if Sky.Config.weather ~= "cd_easytime" then return end
if IsDuplicityVersion() then return end

-- Setup: https://www.sky-systems.net/docs/base/weather-integrations#cd-easytime
local RESOURCE = "cd_easytime"

function Sky.Functions.AcquireWeatherOverride()
    if GetResourceMetadata("cd_easytime", "sky_weather_pause", 0) ~= "1" then
        return false, "Complete the cd_easytime setup in the Sky Base weather integration tutorial."
    end
    if exports[RESOURCE]:GetPauseSyncState() then
        return false, "provider_already_paused"
    end
    local state = Sky.Functions.CaptureWeatherState()
    state.targets = true
    return state
end

function Sky.Functions.ApplyWeatherOverride(weather, hour)
    TriggerEvent("cd_easytime:PauseSync", true, hour, weather)
    PauseClock(true)
end

function Sky.Functions.ReleaseWeatherOverride(state)
    Sky.Functions.RestoreWeatherState(state)
    TriggerEvent("cd_easytime:PauseSync", false)
end
