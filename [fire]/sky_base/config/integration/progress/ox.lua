if Sky.Config.progressbar ~= "ox" then return end

local RESOURCE = "ox_lib"

local function convert_disable(disable)
    if not disable then return nil end

    return {
        move = disable.move or disable.disableMovement or false,
        car = disable.car or disable.disableCarMovement or false,
        mouse = disable.mouse or disable.disableMouse or false,
        combat = disable.combat or disable.disableCombat or false,
        sprint = disable.sprint or false,
    }
end

local function normalize_animation_string(value)
    if type(value) ~= "string" then return nil end
    value = value:match("^%s*(.-)%s*$")
    return value ~= "" and value or nil
end

local function convert_animation(animation)
    if not animation then return nil end

    local scenario = normalize_animation_string(animation.scenario) or normalize_animation_string(animation.task)
    if scenario then
        return {
            scenario = scenario,
            duration = animation.duration,
            playEnter = animation.playEnter,
        }
    end

    local dict = normalize_animation_string(animation.dict) or normalize_animation_string(animation.animDict)
    local clip = normalize_animation_string(animation.clip)
        or normalize_animation_string(animation.anim)
        or normalize_animation_string(animation.lib)

    if not dict or not clip then return nil end

    return {
        dict = dict,
        clip = clip,
        flag = animation.flag or animation.flags,
        blendIn = animation.blendIn,
        blendOut = animation.blendOut,
        duration = animation.duration,
        playbackRate = animation.playbackRate,
        lockX = animation.lockX,
        lockY = animation.lockY,
        lockZ = animation.lockZ,
        playEnter = animation.playEnter,
    }
end

local function normalize_progress_data(label_or_data, duration, options, cb)
    if type(label_or_data) == "table" then
        local data = label_or_data
        data.label = data.label or data.text or "Progress"
        data.duration = data.duration or data.length or 5000
        data.canCancel = data.canCancel ~= false
        data.disable = convert_disable(data.disable or data.controlDisables)
        data.anim = convert_animation(data.anim or data.animation)
        return data, duration
    end

    if type(options) == "function"
        or (type(options) == "table" and rawget(options, "__cfx_functionReference") ~= nil) then
        cb = options
        options = {}
    end

    local data = options or {}
    data.label = data.label or label_or_data or "Progress"
    data.duration = data.duration or duration or 5000
    data.canCancel = data.canCancel ~= false
    data.disable = convert_disable(data.disable or data.controlDisables)
    data.anim = convert_animation(data.anim or data.animation)

    return data, cb
end

function Sky.Functions.Progress(label_or_data, duration, options, cb)
    local data, callback = normalize_progress_data(label_or_data, duration, options, cb)
    local finished = exports[RESOURCE]:progressBar(data)

    if callback then callback(not finished) end
    return finished
end

Sky.Functions.Bar = Sky.Functions.Progress

Sky.Functions.ProgressBar = Sky.Functions.Progress

function Sky.Functions.CancelProgress()
    if exports[RESOURCE]:progressActive() then
        exports[RESOURCE]:cancelProgress()
    end
end

Sky.Functions.CancelBar = Sky.Functions.CancelProgress
Sky.Functions.CancelProgressBar = Sky.Functions.CancelProgress
Sky.Functions.CancelProgressbar = Sky.Functions.CancelProgress
