if Sky.Config.progressbar ~= "aty_uikitv2" then return end

local RESOURCE = "aty_uikitv2"

local helpers = Sky._ProgressAdapter

function Sky.Functions.Progress(label_or_data, duration, options, callback)
    local data, cb = helpers.Normalize(label_or_data, duration, options, callback)
    local finish = helpers.Completion(cb)
    exports[RESOURCE]:StartProgress({
        name = data.name, label = data.label, message = data.message or "",
        duration = data.duration, icon = data.icon,
        canCancel = data.canCancel, useWhileDead = data.useWhileDead,
        controlDisables = helpers.Disable(data, "qb"),
        anim = helpers.Animation(data, "aty"), prop = helpers.Prop(data.prop, "ox"),
    }, function(success) finish(not success) end)
end

Sky.Functions.Bar = Sky.Functions.Progress
Sky.Functions.ProgressBar = Sky.Functions.Progress

function Sky.Functions.CancelProgress()
    Sky.Debug("warn", "ATY UI Kit v2 does not document a progress cancellation export.")
    return false
end

Sky.Functions.CancelBar = Sky.Functions.CancelProgress
Sky.Functions.CancelProgressBar = Sky.Functions.CancelProgress
Sky.Functions.CancelProgressbar = Sky.Functions.CancelProgress
