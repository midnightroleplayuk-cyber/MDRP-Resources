if IsDuplicityVersion() then return end

-- Shared native operations used by the selected weather integration.
function Sky.Functions.CaptureWeatherState()
    local started = GetGameTimer()
    return {
        started = started,
        clock = GetClockHours() * 3600 + GetClockMinutes() * 60 + GetClockSeconds(),
        rate = GetMillisecondsPerGameMinute(),
    }
end

function Sky.Functions.ApplyNativeWeatherOverride(weather, hour)
    SetOverrideWeather(weather)
    SetRainLevel((weather == "CLEAR" or weather == "EXTRASUNNY") and 0.0 or -1.0)
    NetworkOverrideClockTime(hour, 0, 0)
    PauseClock(true)
end

function Sky.Functions.RestoreWeatherState(state, provider_stopped)
    if not state.targets or provider_stopped then
        ClearOverrideWeather()
        SetRainLevel(-1.0)
        NetworkClearClockTimeOverride()
        local elapsed = (GetGameTimer() - state.started) & 0xffffffff
        local time = math.floor(state.clock + elapsed * 60 / state.rate) % 86400
        SetClockTime(math.floor(time / 3600), math.floor(time / 60) % 60, time % 60)
        SetMillisecondsPerGameMinute(state.rate)
    end
    PauseClock(false)
end

if Sky.Config.weather == "native" then
    Sky.Functions.AcquireWeatherOverride = Sky.Functions.CaptureWeatherState
    Sky.Functions.ApplyWeatherOverride = Sky.Functions.ApplyNativeWeatherOverride
    Sky.Functions.ReleaseWeatherOverride = Sky.Functions.RestoreWeatherState
end
