if Sky.Config.progressbar ~= "hex" then return end

local hex_progressbar_resources = {
    "hex_4_hud",
    "hex_2_hud",
    "hex_final_hud",
    "hex_finalhud_v2",
    "hex_future_hud",
    "hex_genesis_hud",
    "hex_hud_prem",
}

local active_progress

local function complete_progress(request, cancelled)
    if active_progress ~= request then return end
    active_progress = nil
    if request.callback then request.callback(cancelled) end
end

local function get_hex_progressbar_resource()
    for _, resource in ipairs(hex_progressbar_resources) do
        if GetResourceState(resource) == "started" then
            return resource
        end
    end
end

local function normalize_progress_data(label_or_data, duration, options, cb)
    if type(label_or_data) == "table" then
        local data = label_or_data
        return data.duration or data.length or 5000, data.label or data.text or data.name or "Progress", duration
    end

    if type(options) == "function"
        or (type(options) == "table" and rawget(options, "__cfx_functionReference") ~= nil) then
        cb = options
    end

    return duration or 5000, label_or_data or "Progress", cb
end

function Sky.Functions.Progress(label_or_data, duration, options, cb)
    local ms, name, callback = normalize_progress_data(label_or_data, duration, options, cb)
    if active_progress then
        if callback then callback(true) end
        return false
    end

    local resource = get_hex_progressbar_resource()

    if not resource then
        Sky.Debug("error", "Sky.Config.progressbar is set to hex but no supported HEX HUD resource is started.")
        if callback then callback(true) end
        return false
    end

    exports[resource]:StartProgressbar(ms, name)

    local request = { resource = resource, callback = callback }
    active_progress = request
    CreateThread(function()
        Wait(ms)
        complete_progress(request, request.cancelled == true or GetResourceState(resource) ~= "started")
    end)

    return true
end

Sky.Functions.Bar = Sky.Functions.Progress

Sky.Functions.ProgressBar = Sky.Functions.Progress

function Sky.Functions.CancelProgress()
    local request = active_progress
    if request then request.cancelled = true end
    local resource = request and request.resource or get_hex_progressbar_resource()

    if not resource or GetResourceState(resource) ~= "started" then
        Sky.Debug("error", "Sky.Config.progressbar is set to hex but no supported HEX HUD resource is started.")
        if request then complete_progress(request, true) end
        return false
    end

    exports[resource]:StopProgressbar()
    if request then complete_progress(request, true) end
    return true
end

Sky.Functions.CancelBar = Sky.Functions.CancelProgress
Sky.Functions.CancelProgressBar = Sky.Functions.CancelProgress
Sky.Functions.CancelProgressbar = Sky.Functions.CancelProgress

AddEventHandler("onResourceStop", function(resource_name)
    local request = active_progress
    if not request then return end
    if resource_name == GetCurrentResourceName() then
        Sky.Functions.CancelProgress()
    elseif resource_name == request.resource then
        complete_progress(request, true)
    end
end)
