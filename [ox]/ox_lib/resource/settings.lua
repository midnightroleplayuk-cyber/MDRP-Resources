-- Some users have locale set from ox_lib v2
if GetResourceKvpInt('reset_locale') ~= 1 then
    DeleteResourceKvp('locale')
    SetResourceKvpInt('reset_locale', 1)
end

-- Jakers RS: one-time reset of saved HUD appearance (opaque panels, no tilt/gradient).
if GetResourceKvpInt('reset_ui_defaults_v1') ~= 1 then
    DeleteResourceKvp('ui_transparency')
    DeleteResourceKvp('ui_border_radius')
    DeleteResourceKvp('ui_gradient_intensity')
    DeleteResourceKvp('ui_perspective')
    SetResourceKvpInt('reset_ui_defaults_v1', 1)
end

-- v2: fix int KVP reads (missing keys returned 0 instead of defaults) + wipe bad saves.
if GetResourceKvpInt('reset_ui_defaults_v2') ~= 1 then
    DeleteResourceKvp('ui_transparency')
    DeleteResourceKvp('ui_border_radius')
    DeleteResourceKvp('ui_gradient_intensity')
    DeleteResourceKvp('ui_perspective')
    SetResourceKvpInt('reset_ui_defaults_v2', 1)
end

---@generic T
---@param fn fun(key): unknown
---@param key string
---@param default? T
---@return T
local function safeGetKvp(fn, key, default)
    local ok, result = pcall(fn, key)

    if not ok then
        DeleteResourceKvp(key)
        return default
    end

    if result == nil then return default end

    return result
end

--- GetResourceKvpInt returns 0 when a key is missing. Never call GetResourceKvpString
--- on int KVP keys — FiveM throws "bad cast" if the key was stored with SetResourceKvpInt.
---@param key string
---@param default integer
---@return integer
local function safeGetIntKvp(key, default)
    local strOk, str = pcall(GetResourceKvpString, key)

    if strOk then
        if str == nil then return default end
        return tonumber(str) or default
    end

    local intOk, result = pcall(GetResourceKvpInt, key)

    if not intOk then
        DeleteResourceKvp(key)
        return default
    end

    if result == nil then return default end

    return result
end

local settings = {
    default_locale = GetConvar('ox:locale', 'en'),
    notification_position = safeGetKvp(GetResourceKvpString, 'notification_position', 'top-right'),
    notification_audio = safeGetKvp(GetResourceKvpInt, 'notification_audio') == 1,
    ui_transparency = safeGetIntKvp('ui_transparency', 100),
    ui_border_radius = safeGetIntKvp('ui_border_radius', 10),
    ui_gradient_intensity = safeGetIntKvp('ui_gradient_intensity', 0),
    ui_perspective = safeGetKvp(GetResourceKvpString, 'ui_perspective', 'none'),
}

local userLocales = GetConvarInt('ox:userLocales', 1) == 1

settings.locale = userLocales and safeGetKvp(GetResourceKvpString, 'locale') or settings.default_locale

local function set(key, value)
    if settings[key] == value then return false end

    settings[key] = value
    local valueType = type(value)

    if valueType == 'nil' then
        DeleteResourceKvp(key)
    elseif valueType == 'string' then
        SetResourceKvp(key, value)
    elseif valueType == 'table' then
        SetResourceKvp(key, json.encode(value))
    elseif valueType == 'number' then
        SetResourceKvpInt(key, value)
    elseif valueType == 'boolean' then
        SetResourceKvpInt(key, value and 1 or 0)
    else
        return false
    end

    return true
end

RegisterCommand('ox_lib', function()
    local inputSettings = {
        {
            type = 'checkbox',
            label = locale('ui.settings.notification_audio'),
            checked = settings.notification_audio,
        },
        {
            type = 'select',
            label = locale('ui.settings.notification_position'),
            options = {
                { label = locale('ui.position.top-right'),    value = 'top-right' },
                { label = locale('ui.position.top'),          value = 'top' },
                { label = locale('ui.position.top-left'),     value = 'top-left' },
                { label = locale('ui.position.center-right'), value = 'center-right' },
                { label = locale('ui.position.center-left'),  value = 'center-left' },
                { label = locale('ui.position.bottom-right'), value = 'bottom-right' },
                { label = locale('ui.position.bottom'),       value = 'bottom' },
                { label = locale('ui.position.bottom-left'),  value = 'bottom-left' },
            },
            default = settings.notification_position,
            required = true,
            icon = 'message',
        },
    }

    if userLocales then
        table.insert(inputSettings,
            {
                type = 'select',
                label = locale('ui.settings.locale'),
                searchable = true,
                description = locale('ui.settings.locale_description', settings.locale),
                options = GlobalState['ox_lib:locales'],
                default = settings.locale,
                required = true,
                icon = 'book',
            })
    end

    table.insert(inputSettings, {
        type = 'slider',
        label = locale('ui.settings.ui_transparency'),
        default = settings.ui_transparency,
        min = 50,
        max = 100,
        step = 1,
        icon = 'droplet',
        preview = 'transparency',
    })

    table.insert(inputSettings, {
        type = 'slider',
        label = locale('ui.settings.ui_border_radius'),
        default = settings.ui_border_radius,
        min = 0,
        max = 20,
        step = 1,
        icon = 'square',
        preview = 'borderRadius',
    })

    table.insert(inputSettings, {
        type = 'slider',
        label = locale('ui.settings.ui_gradient_intensity'),
        default = settings.ui_gradient_intensity,
        min = 0,
        max = 100,
        step = 1,
        icon = 'palette',
        preview = 'gradientIntensity',
    })

    table.insert(inputSettings, {
        type = 'select',
        label = locale('ui.settings.ui_perspective'),
        options = {
            { label = locale('ui.perspective.none'),    value = 'none' },
            { label = locale('ui.perspective.tilt-10'), value = 'tilt-10' },
            { label = locale('ui.perspective.tilt-20'), value = 'tilt-20' },
            { label = locale('ui.perspective.tilt-30'), value = 'tilt-30' },
        },
        default = settings.ui_perspective,
        required = true,
        icon = 'cube',
        preview = 'perspective',
    })

    local input = lib.inputDialog(locale('settings'), inputSettings, {
        subtitle = 'Jakers Designs',
        badge = 'Settings',
    }) --[[@as table?]]

    if not input then return end

    local i = 1
    local notification_audio = input[i]
    i += 1
    local notification_position = input[i]
    i += 1
    local localeInput

    if userLocales then
        localeInput = input[i]
        i += 1
    end

    local transparency = input[i]
    i += 1
    local borderRadius = input[i]
    i += 1
    local gradientIntensity = input[i]
    i += 1
    local perspective = input[i]

    if userLocales and set('locale', localeInput) then lib.setLocale(localeInput) end

    set('notification_position', notification_position)
    set('notification_audio', notification_audio)
    set('ui_transparency', transparency)
    set('ui_border_radius', borderRadius)
    set('ui_gradient_intensity', gradientIntensity)
    set('ui_perspective', perspective)

    TriggerEvent('ox_lib:uiSettingsChanged', {
        transparency = math.max(50, settings.ui_transparency or 100),
        borderRadius = math.max(0, math.min(20, settings.ui_border_radius or 10)),
        gradientIntensity = math.max(0, math.min(100, settings.ui_gradient_intensity or 0)),
        perspective = settings.ui_perspective and settings.ui_perspective ~= '' and settings.ui_perspective or 'none',
    })
end)

return settings
