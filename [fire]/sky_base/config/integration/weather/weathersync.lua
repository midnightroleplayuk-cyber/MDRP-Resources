if Sky.Config.weather ~= "weathersync" then return end
if IsDuplicityVersion() then return end

local RESOURCE = "weathersync"

function Sky.Functions.AcquireWeatherOverride()
    local state = Sky.Functions.CaptureWeatherState()
    state.targets = true
    return state
end

function Sky.Functions.ApplyWeatherOverride(weather, hour)
    exports[RESOURCE]:setMyWeather(weather, 0.0, false)
    exports[RESOURCE]:setMyTime(hour, 0, 0, 0.0)
    PauseClock(true)
end

function Sky.Functions.ReleaseWeatherOverride(state)
    Sky.Functions.RestoreWeatherState(state)
    exports[RESOURCE]:setSyncEnabled(true)
    TriggerServerEvent("weathersync:init")
end
