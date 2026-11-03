if Sky.Config.weather ~= "esx_weather" then return end
if IsDuplicityVersion() then return end

local RESOURCE = "esx_weather"

function Sky.Functions.AcquireWeatherOverride()
    local state = Sky.Functions.CaptureWeatherState()
    exports[RESOURCE]:ToggleWeatherSync(false)
    exports[RESOURCE]:ToggleTimeSync(false)
    return state
end

Sky.Functions.ApplyWeatherOverride = Sky.Functions.ApplyNativeWeatherOverride

function Sky.Functions.ReleaseWeatherOverride(state)
    Sky.Functions.RestoreWeatherState(state)
    exports[RESOURCE]:ToggleWeatherSync(true)
    exports[RESOURCE]:ToggleTimeSync(true)
end
