if Sky.Config.progressbar ~= "frkn-uikit" then return end

local RESOURCE = "frkn-uikit"

local helpers = Sky._ProgressAdapter

function Sky.Functions.Progress(label_or_data, duration, options, callback)
    local data, cb = helpers.Normalize(label_or_data, duration, options, callback)
    local finish = helpers.Completion(cb)
    exports[RESOURCE]:Progressbar(
        data.style or "progressbar-1", data.label, data.duration,
        data.useWhileDead, data.canCancel,
        helpers.Disable(data, "qb") or {}, helpers.Animation(data, "qb") or {},
        helpers.Prop(data.prop, "qb") or {}, helpers.Prop(data.propTwo, "qb") or {},
        function() finish(false) end, function() finish(true) end
    )
end

Sky.Functions.Bar = Sky.Functions.Progress
Sky.Functions.ProgressBar = Sky.Functions.Progress

function Sky.Functions.CancelProgress()
    Sky.Debug("warn", "FRKN UI Kit does not document a progress cancellation export.")
    return false
end

Sky.Functions.CancelBar = Sky.Functions.CancelProgress
Sky.Functions.CancelProgressBar = Sky.Functions.CancelProgress
Sky.Functions.CancelProgressbar = Sky.Functions.CancelProgress
