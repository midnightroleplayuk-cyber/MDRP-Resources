if Sky.Config.weather ~= "Renewed-Weathersync" then return end
if IsDuplicityVersion() then return end

function Sky.Functions.AcquireWeatherOverride(weather)
    local state = Sky.Functions.CaptureWeatherState()
    local player_state = LocalPlayer.state
    state.token = { sync = player_state.syncWeather, weather = player_state.playerWeather }
    state.deferred = true -- Apply after the provider's syncWeather state handler sets 21:00.
    player_state:set("playerWeather", weather, false)
    player_state:set("syncWeather", false, false)
    return state
end

function Sky.Functions.ApplyWeatherOverride(weather, hour)
    LocalPlayer.state:set("playerWeather", weather, false)
    Sky.Functions.ApplyNativeWeatherOverride(weather, hour)
end

function Sky.Functions.ReleaseWeatherOverride(state)
    Sky.Functions.RestoreWeatherState(state)
    local player_state = LocalPlayer.state
    player_state:set("playerWeather", state.token.weather, false)
    player_state:set("syncWeather", state.token.sync, false)
end
