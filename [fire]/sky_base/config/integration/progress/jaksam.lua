if Sky.Config.progressbar ~= "jaksam" then return end

local jaksam_progressbar_events = {
    ["robberies_creator"] = "robberies_creator:startProgressBar",
    ["jobs_creator"] = "jobs_creator:startProgressBar",
    ["drugs_creator"] = "drugs_creator:startProgressBar",
}

local function get_jaksam_progressbar_event()
    for resource, event in pairs(jaksam_progressbar_events) do
        if GetResourceState(resource) == "started" then
            return event
        end
    end
end

local function normalize_progress_data(label_or_data, duration, options, cb)
    if type(label_or_data) == "table" then
        local data = label_or_data
        return data.duration or data.length or 5000,
            data.label or data.text or data.name or "Progress",
            data.hexColor or data.color,
            duration
    end

    if type(options) == "function"
        or (type(options) == "table" and rawget(options, "__cfx_functionReference") ~= nil) then
        cb = options
        options = {}
    end

    options = options or {}

    return duration or 5000, label_or_data or "Progress", options.hexColor or options.color, cb
end

function Sky.Functions.Progress(label_or_data, duration, options, cb)
    local ms, text, hex_color, callback = normalize_progress_data(label_or_data, duration, options, cb)
    local event = get_jaksam_progressbar_event()

    if not event then
        Sky.Debug("error", "Sky.Config.progressbar is set to jaksam but no supported Jaksam Creator resource is started.")
        if callback then callback(true) end
        return false
    end

    TriggerEvent(event, ms, text, hex_color)

    if callback then
        CreateThread(function()
            Wait(ms)
            callback(false)
        end)
    end

    return true
end

Sky.Functions.Bar = Sky.Functions.Progress

Sky.Functions.ProgressBar = Sky.Functions.Progress

function Sky.Functions.CancelProgress()
    Sky.Debug("warn", "Jaksam Creator progressbar does not provide a documented cancel event.")
end

Sky.Functions.CancelBar = Sky.Functions.CancelProgress
Sky.Functions.CancelProgressBar = Sky.Functions.CancelProgress
Sky.Functions.CancelProgressbar = Sky.Functions.CancelProgress
