if Sky.Config.progressbar ~= "risk-notify" then return end

local RESOURCE = "risk-notify"

local helpers = Sky._ProgressAdapter

function Sky.Functions.Progress(label_or_data, duration, options, callback)
    local data, cb = helpers.Normalize(label_or_data, duration, options, callback)
    local finish = helpers.Completion(cb)
    local disable = helpers.Disable(data, "ox")
    local prop = data.prop
    if type(prop) == "table" then prop = prop.model end
    local freeze = data.freeze
    if freeze == nil then freeze = disable and disable.move or false end
    exports[RESOURCE]:startProgress(data.duration, data.label, {
        prop = prop, freeze = freeze, anim = helpers.Animation(data, "risk"),
        onFinish = function() finish(false) end,
        onCancel = function() finish(true) end,
    })
end

Sky.Functions.Bar = Sky.Functions.Progress
Sky.Functions.ProgressBar = Sky.Functions.Progress

function Sky.Functions.CancelProgress()
    exports[RESOURCE]:cancelProgress()
end

Sky.Functions.CancelBar = Sky.Functions.CancelProgress
Sky.Functions.CancelProgressBar = Sky.Functions.CancelProgress
Sky.Functions.CancelProgressbar = Sky.Functions.CancelProgress
