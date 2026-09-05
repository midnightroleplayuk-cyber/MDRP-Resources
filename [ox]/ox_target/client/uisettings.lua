local state = require 'client.state'

local DEFAULT_UI_SETTINGS = {
    transparency = 100,
    borderRadius = 10,
    gradientIntensity = 0,
    perspective = 'none',
}

local function normalizeSettings(settings)
    if type(settings) ~= 'table' then return nil end

    return {
        transparency = settings.transparency or DEFAULT_UI_SETTINGS.transparency,
        borderRadius = settings.borderRadius or DEFAULT_UI_SETTINGS.borderRadius,
        gradientIntensity = settings.gradientIntensity or DEFAULT_UI_SETTINGS.gradientIntensity,
        perspective = settings.perspective or DEFAULT_UI_SETTINGS.perspective,
    }
end

local function getUiSettings()
    if lib.getUiSettings then
        local ok, settings = pcall(lib.getUiSettings)
        if ok then
            settings = normalizeSettings(settings)
            if settings then return settings end
        end
    end

    return DEFAULT_UI_SETTINGS
end

local function pushSettings(settings)
    settings = normalizeSettings(settings)
    if not settings then return end

    SendNUIMessage({
        event = 'uiSettings',
        data = settings,
    })

    if InteractionApplyUiSettings then
        InteractionApplyUiSettings(settings)
    end
end

RegisterNUICallback('uiLoaded', function(_, cb)
    cb(getUiSettings())
end)

RegisterNUICallback('getConfig', function(_, cb)
    cb({
        primaryColor = GetConvar('ox:primaryColor', 'jakers'),
        primaryShade = GetConvarInt('ox:primaryShade', 5),
    })
end)

RegisterNUICallback('releaseAlt', function(_, cb)
    cb(1)

    LocalPlayer.state.invHotkeys = true
    state.setActive(false)
end)

AddEventHandler('ox_lib:uiSettingsChanged', pushSettings)

AddEventHandler('onClientResourceStart', function(resource)
    if resource == cache.resource then
        SetTimeout(500, function()
            pushSettings(getUiSettings())
        end)
        return
    end

    if resource ~= 'ox_lib' then return end

    SetTimeout(1000, function()
        pushSettings(getUiSettings())
    end)
end)
