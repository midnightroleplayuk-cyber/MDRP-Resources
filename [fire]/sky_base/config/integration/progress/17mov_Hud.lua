if Sky.Config.progressbar ~= "17mov_Hud" then return end

local RESOURCE = "17mov_Hud"

local helpers = Sky._ProgressAdapter
local active

function Sky.Functions.Progress(label_or_data, duration, options, callback)
    local data, cb = helpers.Normalize(label_or_data, duration, options, callback)
    local finish = helpers.Completion(cb)
    if active then
        finish(true)
        return false
    end
    local request = { cancelled = false }
    active = request
    exports[RESOURCE]:StartProgress({
        label = data.label, duration = data.duration,
        canCancel = data.canCancel, useWhileDead = data.useWhileDead,
        controlDisables = helpers.Disable(data, "qb"),
        animation = helpers.Animation(data, "qb"),
        prop = helpers.Prop(data.prop, "qb"), propTwo = helpers.Prop(data.propTwo, "qb"),
    }, data.onStart, data.onTick, function(cancelled)
        if active == request then active = nil end
        finish(request.cancelled or cancelled)
    end)
end

Sky.Functions.Bar = Sky.Functions.Progress
Sky.Functions.ProgressBar = Sky.Functions.Progress

function Sky.Functions.CancelProgress()
    if active then
        -- The StopProgress documentation reports false to onFinish; retain our cancel intent.
        active.cancelled = true
        exports[RESOURCE]:StopProgress()
    end
end

Sky.Functions.CancelBar = Sky.Functions.CancelProgress
Sky.Functions.CancelProgressBar = Sky.Functions.CancelProgress
Sky.Functions.CancelProgressbar = Sky.Functions.CancelProgress
