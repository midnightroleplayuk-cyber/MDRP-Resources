if Sky.Config.weather ~= "custom" then return end
if IsDuplicityVersion() then return end

-- Select Config.weather = "custom" after implementing these client-side functions.
-- Acquire returns CaptureWeatherState() with any provider token stored in state.token,
-- or false, reason before changing the provider. Set state.targets = true when the
-- provider handles both weather and time; state.deferred = true defers the first apply.
-- Acquire/apply must not yield. Never change server weather or time.
function Sky.Functions.AcquireWeatherOverride(weather, hour)
    -- Capture the clock, save the provider token and pause local synchronization.
    error("Custom weather integration: AcquireWeatherOverride is not implemented")
end

function Sky.Functions.ApplyWeatherOverride(weather, hour, state)
    -- Update the provider, or call ApplyNativeWeatherOverride(weather, hour).
    -- Providers that handle both targets must also call PauseClock(true).
    error("Custom weather integration: ApplyWeatherOverride is not implemented")
end

function Sky.Functions.ReleaseWeatherOverride(state)
    -- Call RestoreWeatherState(state), then restore the provider using state.token.
    error("Custom weather integration: ReleaseWeatherOverride is not implemented")
end
