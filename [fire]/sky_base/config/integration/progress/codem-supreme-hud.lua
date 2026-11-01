if Sky.Config.progressbar ~= "codem-supreme-hud" then return end

local RESOURCE = "codem-supreme-hud"

local helpers = Sky._ProgressAdapter

function Sky.Functions.Progress(label_or_data, duration, options, callback)
    local data, cb = helpers.Normalize(label_or_data, duration, options, callback)
    local finish = helpers.Completion(cb)
    if exports[RESOURCE]:isDoingSomething() then
        finish(true)
        return false
    end
    exports[RESOURCE]:Progress({
        label = data.label, duration = data.duration,
        icon = data.icon, color = data.color, canCancel = data.canCancel,
    }, function() finish(false) end, function() finish(true) end)
end

Sky.Functions.Bar = Sky.Functions.Progress
Sky.Functions.ProgressBar = Sky.Functions.Progress

function Sky.Functions.CancelProgress()
    exports[RESOURCE]:CancelProgress()
end

Sky.Functions.CancelBar = Sky.Functions.CancelProgress
Sky.Functions.CancelProgressBar = Sky.Functions.CancelProgress
Sky.Functions.CancelProgressbar = Sky.Functions.CancelProgress
