if Sky.Config.progressbar ~= "prism_uipack" then return end

local RESOURCE = "prism_uipack"

local helpers = Sky._ProgressAdapter

function Sky.Functions.Progress(label_or_data, duration, options, callback)
    local data, cb = helpers.Normalize(label_or_data, duration, options, callback)
    data.disable = helpers.Disable(data, "ox")
    data.anim = helpers.Animation(data, "ox")
    data.animation = nil
    data.prop = helpers.Prop(data.prop, "ox")
    local finished = exports[RESOURCE]:ProgressBar(data)
    if cb then cb(not finished) end
    return finished
end

Sky.Functions.Bar = Sky.Functions.Progress
Sky.Functions.ProgressBar = Sky.Functions.Progress

function Sky.Functions.CancelProgress()
    if exports[RESOURCE]:ProgressActive() then
        exports[RESOURCE]:CancelProgress()
    end
end

Sky.Functions.CancelBar = Sky.Functions.CancelProgress
Sky.Functions.CancelProgressBar = Sky.Functions.CancelProgress
Sky.Functions.CancelProgressbar = Sky.Functions.CancelProgress
