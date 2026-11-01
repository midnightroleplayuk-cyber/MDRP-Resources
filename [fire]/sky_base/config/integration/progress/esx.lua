if Sky.Config.progressbar ~= "esx" then return end

local RESOURCE = "esx_progressbar"

local function convert_animation(animation)
    if not animation then return nil end

    local scenario = animation.scenario or animation.task or animation.Scenario
    if scenario then
        return { type = "Scenario", Scenario = scenario }
    end

    local dict = animation.dict or animation.animDict
    local clip = animation.clip or animation.anim or animation.lib
    if not dict or not clip then return nil end

    return { type = "anim", dict = dict, lib = clip }
end

local function normalize_progress_data(label_or_data, duration, options, cb)
    if type(label_or_data) == "table" then
        local data = label_or_data
        return data.label or data.text or "Progress", data.duration or data.length or 5000, data, duration
    end

    if type(options) == "function"
        or (type(options) == "table" and rawget(options, "__cfx_functionReference") ~= nil) then
        cb = options
        options = {}
    end

    options = options or {}
    options.label = options.label or label_or_data or "Progress"
    options.duration = options.duration or duration or 5000

    return options.label, options.duration, options, cb
end

function Sky.Functions.Progress(label_or_data, duration, options, cb)
    local label, length, data, callback = normalize_progress_data(label_or_data, duration, options, cb)
    local completed = false
    local function complete(cancelled)
        if completed then return end
        completed = true
        if callback then callback(cancelled) end
    end

    local started = exports[RESOURCE]:Progressbar(label, length, {
        FreezePlayer = data.FreezePlayer or data.freezePlayer or false,
        animation = convert_animation(data.anim or data.animation),
        onFinish = function()
            complete(false)
        end,
        onCancel = function()
            complete(true)
        end
    })

    if started == false then
        complete(true)
        return false
    end

    return true
end

Sky.Functions.Bar = Sky.Functions.Progress
Sky.Functions.ProgressBar = Sky.Functions.Progress

function Sky.Functions.CancelProgress()
    exports[RESOURCE]:CancelProgressbar()
end

Sky.Functions.CancelBar = Sky.Functions.CancelProgress
Sky.Functions.CancelProgressBar = Sky.Functions.CancelProgress
Sky.Functions.CancelProgressbar = Sky.Functions.CancelProgress
