if Sky.Config.progressbar ~= "qb" then return end

local RESOURCE = "progressbar"

local function normalize_progress_data(label_or_data, duration, options, cb)
    if type(label_or_data) == "table" then
        local data = label_or_data
        data.name = data.name or "sky_progress"
        data.label = data.label or data.text or "Progress"
        data.duration = data.duration or data.length or 5000
        data.canCancel = data.canCancel ~= false
        data.useWhileDead = data.useWhileDead or false
        data.controlDisables = data.controlDisables or data.disable or {
            disableMovement = false,
            disableCarMovement = false,
            disableMouse = false,
            disableCombat = true,
        }
        return data, duration
    end

    if type(options) == "function"
        or (type(options) == "table" and rawget(options, "__cfx_functionReference") ~= nil) then
        cb = options
        options = {}
    end

    local data = options or {}
    data.name = data.name or "sky_progress"
    data.label = data.label or label_or_data or "Progress"
    data.duration = data.duration or duration or 5000
    data.canCancel = data.canCancel ~= false
    data.useWhileDead = data.useWhileDead or false
    data.controlDisables = data.controlDisables or data.disable or {
        disableMovement = false,
        disableCarMovement = false,
        disableMouse = false,
        disableCombat = true,
    }

    return data, cb
end

function Sky.Functions.Progress(label_or_data, duration, options, cb)
    local data, callback = normalize_progress_data(label_or_data, duration, options, cb)

    exports[RESOURCE]:Progress(data, function(cancelled)
        if callback then callback(cancelled) end
    end)
end

Sky.Functions.Bar = Sky.Functions.Progress

Sky.Functions.ProgressBar = Sky.Functions.Progress

function Sky.Functions.CancelProgress()
    if exports[RESOURCE]:isDoingSomething() then
        TriggerEvent("progressbar:client:cancel")
    end
end

Sky.Functions.CancelBar = Sky.Functions.CancelProgress
Sky.Functions.CancelProgressBar = Sky.Functions.CancelProgress
Sky.Functions.CancelProgressbar = Sky.Functions.CancelProgress
