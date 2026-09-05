local syncPaused = false
local pauseHours = nil
local pauseMinutes = nil
local pauseWeather = nil

local function getProvider()
    local provider = Config and Config.WeatherResource
    if type(provider) ~= "string" or provider == "" or provider == "none" then
        return nil
    end
    return provider
end

local function resourceStarted(name)
    return GetResourceState(name) == "started"
end

local function easytimePaused()
    if not resourceStarted("cd_easytime") then
        return false
    end
    local ok, state = pcall(function()
        return exports["cd_easytime"]:GetPauseSyncState()
    end)
    return ok and state == true
end

local function freezeAvWeather(hours, minutes, weather)
    TriggerEvent(
        "av_weather:freeze",
        true,
        hours or 12,
        minutes or 0,
        weather or "CLEAR",
        false,
        false,
        false
    )
end

local function setRenewedPlayerWeather(weather)
    local w = (type(weather) == "string" and weather ~= "") and weather or "EXTRASUNNY"
    LocalPlayer.state:set("playerWeather", w, true)
    pauseWeather = w
end

local function setRenewedSync(enabled)
    LocalPlayer.state:set("syncWeather", enabled and true or false, true)
end

function stopWeatherResource(opts)
    local provider = getProvider()
    if not provider then
        return false
    end

    if type(opts) == "number" then
        opts = { hours = opts }
    end
    opts = type(opts) == "table" and opts or {}

    if syncPaused then
        if provider == "cd_easytime" and opts.hours ~= nil and opts.hours ~= pauseHours then
            pauseHours = tonumber(opts.hours) or 20
            TriggerEvent("cd_easytime:PauseSync", false)
            Wait(50)
            CreateThread(function()
                TriggerEvent("cd_easytime:PauseSync", true, pauseHours)
            end)
            Wait(100)
        elseif provider == "av_weather" then
            local nextHours = opts.hours ~= nil and (tonumber(opts.hours) or pauseHours) or pauseHours
            local nextMinutes = opts.minutes ~= nil and (tonumber(opts.minutes) or pauseMinutes) or pauseMinutes
            local nextWeather = opts.weather or pauseWeather
            if nextHours ~= pauseHours or nextMinutes ~= pauseMinutes or nextWeather ~= pauseWeather then
                pauseHours = nextHours or 12
                pauseMinutes = nextMinutes or 0
                pauseWeather = nextWeather or "CLEAR"
                freezeAvWeather(pauseHours, pauseMinutes, pauseWeather)
            end
        elseif provider == "Renewed-Weathersync" then
            if opts.weather and opts.weather ~= pauseWeather then
                setRenewedPlayerWeather(opts.weather)
            end
            if opts.hours ~= nil then
                pauseHours = tonumber(opts.hours) or pauseHours
            end
            if opts.minutes ~= nil then
                pauseMinutes = tonumber(opts.minutes) or pauseMinutes
            end
        end
        return true
    end

    if provider == "qb-weathersync" or provider == "qbx_weathersync" then
        if not resourceStarted(provider) and not resourceStarted("qb-weathersync") and not resourceStarted("qbx_weathersync") then
            debugPrint(("[WeatherSync] %s is not started"):format(provider))
            return false
        end
        TriggerEvent("qb-weathersync:client:DisableSync")
        syncPaused = true
        debugPrint(("[WeatherSync] Disabled %s"):format(provider))
        return true
    end

    if provider == "weathersync" then
        if not resourceStarted("weathersync") then
            debugPrint("[WeatherSync] weathersync is not started")
            return false
        end
        TriggerEvent("weathersync:toggleSync")
        syncPaused = true
        debugPrint("[WeatherSync] Toggled weathersync off")
        return true
    end

    if provider == "cd_easytime" then
        if not resourceStarted("cd_easytime") then
            debugPrint("[WeatherSync] cd_easytime is not started")
            return false
        end

        pauseHours = opts.hours ~= nil and (tonumber(opts.hours) or 20) or 20

        CreateThread(function()
            TriggerEvent("cd_easytime:PauseSync", true, pauseHours)
        end)

        local deadline = GetGameTimer() + 1500
        while GetGameTimer() < deadline do
            if easytimePaused() then
                break
            end
            Wait(50)
        end

        if not easytimePaused() then
            CreateThread(function()
                TriggerEvent("cd_easytime:PauseSync", true, pauseHours)
            end)
            Wait(100)
        end
        syncPaused = true
        local verified = easytimePaused()
        if not verified then
            debugPrint("^3[WeatherSync]^0 cd_easytime PauseSync did not verify — relying on local keep-alive")
        end
        debugPrint(("[WeatherSync] Paused cd_easytime sync (hours=%s, verified=%s)"):format(
            tostring(pauseHours),
            tostring(verified)
        ))
        return true
    end

    if provider == "av_weather" then
        if not resourceStarted("av_weather") then
            debugPrint("[WeatherSync] av_weather is not started")
            return false
        end

        pauseHours = opts.hours ~= nil and (tonumber(opts.hours) or 12) or 12
        pauseMinutes = opts.minutes ~= nil and (tonumber(opts.minutes) or 0) or 0
        pauseWeather = (type(opts.weather) == "string" and opts.weather ~= "") and opts.weather or "CLEAR"

        freezeAvWeather(pauseHours, pauseMinutes, pauseWeather)
        syncPaused = true
        debugPrint(("[WeatherSync] Frozen av_weather (hours=%s, mins=%s, weather=%s)"):format(
            tostring(pauseHours),
            tostring(pauseMinutes),
            tostring(pauseWeather)
        ))
        return true
    end

    if provider == "Renewed-Weathersync" then
        if not resourceStarted("Renewed-Weathersync") then
            debugPrint("[WeatherSync] Renewed-Weathersync is not started")
            return false
        end

        pauseHours = opts.hours ~= nil and (tonumber(opts.hours) or 12) or 12
        pauseMinutes = opts.minutes ~= nil and (tonumber(opts.minutes) or 0) or 0

        setRenewedPlayerWeather(opts.weather)
        setRenewedSync(false)
        TriggerEvent("qb-weathersync:client:DisableSync")
        TriggerEvent("vSync:toggle", false)

        syncPaused = true
        debugPrint(("[WeatherSync] Disabled Renewed-Weathersync (playerWeather=%s)"):format(
            tostring(pauseWeather)
        ))
        return true
    end

    if provider == "vSync" then
        if not resourceStarted(provider) then
            debugPrint(("[WeatherSync] %s is not started"):format(provider))
            return false
        end
        TriggerEvent("vSync:toggle", false)
        syncPaused = true
        debugPrint(("[WeatherSync] Disabled %s"):format(provider))
        return true
    end

    if provider == "ft_qb_weathersystem" or provider == "ft_weathersystem" then
        if not resourceStarted(provider) then
            debugPrint(("[WeatherSync] %s is not started"):format(provider))
            return false
        end
        syncPaused = true
        debugPrint(("[WeatherSync] Paused %s (local keep-alive)"):format(provider))
        return true
    end

    debugPrint(("^3[WeatherSync]^0 Unknown Config.WeatherResource: %s"):format(tostring(provider)))
    return false
end

function startWeatherResource()
    if not syncPaused then return end
    syncPaused = false
    pauseHours = nil
    pauseMinutes = nil
    pauseWeather = nil

    local provider = getProvider()
    if not provider then return end

    if provider == "qb-weathersync" or provider == "qbx_weathersync" then
        TriggerEvent("qb-weathersync:client:EnableSync")
        debugPrint(("[WeatherSync] Re-enabled %s"):format(provider))
        return
    end

    if provider == "weathersync" then
        TriggerEvent("weathersync:toggleSync")
        debugPrint("[WeatherSync] Toggled weathersync on")
        return
    end

    if provider == "cd_easytime" then
        TriggerEvent("cd_easytime:PauseSync", false)
        debugPrint("[WeatherSync] Resumed cd_easytime sync")
        return
    end

    if provider == "av_weather" then
        TriggerEvent("av_weather:freeze", false)
        debugPrint("[WeatherSync] Unfroze av_weather sync")
        return
    end

    if provider == "Renewed-Weathersync" then
        setRenewedSync(true)
        TriggerEvent("qb-weathersync:client:EnableSync")
        TriggerEvent("vSync:toggle", true)
        debugPrint("[WeatherSync] Re-enabled Renewed-Weathersync")
        return
    end

    if provider == "vSync" then
        TriggerEvent("vSync:toggle", true)
        debugPrint(("[WeatherSync] Re-enabled %s"):format(provider))
        return
    end

    if provider == "ft_qb_weathersystem" then
        TriggerServerEvent("ft_qb_weather:requestSync")
        debugPrint("[WeatherSync] Re-synced ft_qb_weathersystem")
        return
    end

    if provider == "ft_weathersystem" then
        TriggerServerEvent("ft_weather:requestSync")
        debugPrint("[WeatherSync] Re-synced ft_weathersystem")
    end
end