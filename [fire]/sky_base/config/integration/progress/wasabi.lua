if Sky.Config.progressbar ~= "wasabi" then return end

local RESOURCE = "wasabi_uikit"

local function convert_disable(disable)
    if not disable then return nil end

    return {
        move = disable.move or disable.disableMovement or false,
        car = disable.car or disable.disableCarMovement or false,
        combat = disable.combat or disable.disableCombat or false,
        mouse = disable.mouse or disable.disableMouse or false,
    }
end

local function convert_animation(animation)
    if not animation then return nil end
    if animation.dict and animation.clip then return animation end

    return {
        dict = animation.dict or animation.animDict,
        clip = animation.clip or animation.anim or animation.lib,
    }
end

local function normalize_progress_data(label_or_data, duration, options, cb)
    if type(label_or_data) == "table" then
        local data = label_or_data
        data.label = data.label or data.text or "Progress"
        data.duration = data.duration or data.length or 5000
        data.disable = convert_disable(data.disable or data.controlDisables)
        data.anim = convert_animation(data.anim or data.animation)

        return data, data.type or "bar", duration
    end

    if type(options) == "function"
        or (type(options) == "table" and rawget(options, "__cfx_functionReference") ~= nil) then
        cb = options
        options = {}
    end

    local data = options or {}
    data.label = data.label or label_or_data or "Progress"
    data.duration = data.duration or duration or 5000
    data.disable = convert_disable(data.disable or data.controlDisables)
    data.anim = convert_animation(data.anim or data.animation)

    return data, data.type or "bar", cb
end

function Sky.Functions.Progress(label_or_data, duration, options, cb)
    local data, progress_type, callback = normalize_progress_data(label_or_data, duration, options, cb)
    local finished = exports[RESOURCE]:ProgressBar(data, progress_type)

    if callback then callback(not finished) end
    return finished
end

function Sky.Functions.Bar(label_or_data, duration, options, cb)
    local data, _, callback = normalize_progress_data(label_or_data, duration, options, cb)
    data.type = "bar"

    return Sky.Functions.Progress(data, callback)
end

function Sky.Functions.Circle(label_or_data, duration, options, cb)
    local data, _, callback = normalize_progress_data(label_or_data, duration, options, cb)
    data.type = "circle"

    return Sky.Functions.Progress(data, callback)
end

Sky.Functions.ProgressBar = Sky.Functions.Progress

function Sky.Functions.CancelProgress()
    Sky.Debug("warn", "Wasabi UI Kit progressbar does not provide a documented cancel export.")
end

Sky.Functions.CancelBar = Sky.Functions.CancelProgress
Sky.Functions.CancelProgressBar = Sky.Functions.CancelProgress
Sky.Functions.CancelProgressbar = Sky.Functions.CancelProgress
