if Sky.Config.progressbar ~= "msk_core" then return end

local RESOURCE = "msk_core"

local helpers = Sky._ProgressAdapter

local function run(label_or_data, duration, options, callback, shape)
    local data, cb = helpers.Normalize(label_or_data, duration, options, callback)
    data.disable = helpers.Disable(data, "ox")
    data.animation = helpers.Animation(data, "ox")
    data.anim = nil
    data.prop = helpers.Prop(data.prop, "ox")
    if shape then data.type = shape end
    local finished
    if data.type == "circle" then
        finished = exports[RESOURCE]:ProgressCircle(data)
    else
        finished = exports[RESOURCE]:Progressbar(data)
    end
    if cb then cb(not finished) end
    return finished
end

function Sky.Functions.Progress(label_or_data, duration, options, callback)
    return run(label_or_data, duration, options, callback)
end

function Sky.Functions.Circle(label_or_data, duration, options, callback)
    return run(label_or_data, duration, options, callback, "circle")
end

function Sky.Functions.Bar(label_or_data, duration, options, callback)
    return run(label_or_data, duration, options, callback, "bar")
end
Sky.Functions.ProgressBar = Sky.Functions.Progress

function Sky.Functions.CancelProgress()
    exports[RESOURCE]:ProgressStop()
end

Sky.Functions.CancelBar = Sky.Functions.CancelProgress
Sky.Functions.CancelProgressBar = Sky.Functions.CancelProgress
Sky.Functions.CancelProgressbar = Sky.Functions.CancelProgress
