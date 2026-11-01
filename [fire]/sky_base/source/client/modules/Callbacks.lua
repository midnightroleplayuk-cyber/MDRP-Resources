if not SkyCallbackProfiler then
-- Included by diagnostic builds in the resource that owns the callback.
-- Public labels contain random build/callsite IDs only. No debug metadata is read.
SkyCallbackProfiler = {}

-- Set before starting resources; replicated to clients by `setr` in server.cfg.
-- Read once so disabled resources register the original callbacks unchanged.
local profiler_enabled = GetConvarInt("sky_profiler", 0) ~= 0
local named_factories = {}
local named_template = [[
local callback, is_recording, enter_scope, exit_scope, call_label = ...
return function(...)
    if is_recording() then
        enter_scope(call_label)
        exit_scope()
    end
    return callback(...)
end
]]

function SkyCallbackProfiler.Named(build_id, symbol_id, callback)
    if not profiler_enabled then
        return callback
    end

    assert(type(build_id) == "string" and build_id:match("^B%x+$") and #build_id == 33,
        "Invalid profiler build identifier.")
    assert(type(symbol_id) == "string" and symbol_id:match("^C%x+$") and #symbol_id == 25,
        "Invalid profiler callback identifier.")
    -- Optional callback arguments retain the native API's original behavior.
    if callback == nil or callback == false then
        return callback
    end
    assert(type(callback) == "function" or
        (type(callback) == "table" and rawget(callback, "__cfx_functionReference") ~= nil),
        "Profiler callback must be callable.")

    -- The fixed template contains no application source. Its 59-character opaque
    -- chunk name fits Lua's short_src and names the existing native coroutine.
    -- Native thread/timer/event handles and yield/resume behavior stay unchanged.
    local label = build_id .. ":" .. symbol_id
    local factory = named_factories[label]
    if not factory then
        factory = assert(load(named_template, "=" .. label, "t", {}))
        named_factories[label] = factory
    end
    return factory(callback, ProfilerIsRecording, ProfilerEnterScope, ProfilerExitScope,
        "SKY|" .. build_id .. "|" .. symbol_id .. "|C")
end

function SkyCallbackProfiler.Wrap(build_id, symbol_id, callback)
    if not profiler_enabled then
        return callback
    end

    assert(type(build_id) == "string" and build_id:match("^B%x+$") and #build_id == 33,
        "Invalid profiler build identifier.")
    assert(type(symbol_id) == "string" and symbol_id:match("^C%x+$") and #symbol_id == 25,
        "Invalid profiler callback identifier.")
    assert(type(callback) == "function" or
        (type(callback) == "table" and rawget(callback, "__cfx_functionReference") ~= nil),
        "Profiler callback must be callable.")

    local label = "SKY|" .. build_id .. "|" .. symbol_id
    local call_label = label .. "|C"

    return function(...)
        if not ProfilerIsRecording() then
            return callback(...)
        end

        -- This marker never yields. Execution scopes below belong to the scheduler,
        -- which closes/reopens them at each yield/resume instead of spanning waits.
        ProfilerEnterScope(call_label)
        ProfilerExitScope()

        local arguments = table.pack(...)
        local result
        local pending
        local yielded = Citizen.CreateThreadNow(function()
            result = table.pack(pcall(callback, table.unpack(arguments, 1, arguments.n)))
            if pending then
                pending:resolve(result)
            end
        end, label)

        if yielded then
            pending = promise.new()
            result = Citizen.Await(pending)
        end

        if not result[1] then
            error(result[2], 0)
        end

        return table.unpack(result, 2, result.n)
    end
end

end
local callback_core = Sky.Cb.__core
local performance_config = Sky.Config.callbackPerformance
local performance_tracker = callback_core.CreatePerformanceTracker()
local callback_trace = callback_core.CreateTrace()
local registered_callbacks = {}
local remote_callbacks = {}
local response_handlers = {}
local handle_callback_request

Sky.Cb.__core = nil

assert(type(performance_config) == "table", "Sky.Config.callbackPerformance must be a table!")
assert(type(performance_config.enabled) == "boolean", "Sky.Config.callbackPerformance.enabled must be a boolean!")
assert(type(performance_config.warningsEnabled) == "boolean", "Sky.Config.callbackPerformance.warningsEnabled must be a boolean!")
assert(type(performance_config.warningThreshold) == "number" and performance_config.warningThreshold >= 0,
    "Sky.Config.callbackPerformance.warningThreshold must be a non-negative number!")
assert(type(performance_config.warningCooldown) == "number" and performance_config.warningCooldown >= 0,
    "Sky.Config.callbackPerformance.warningCooldown must be a non-negative number!")

local function record_request_completion(request, result)
    callback_trace.Finish(request.trace, result.status, result.data)
    if result.status == "timeout" then
        Sky.Debug("error", ("ServerCallback \"%s\" timed out after %sms!"):format(request.name, request.timeout))
    end

    if not performance_config.enabled then
        return
    end

    performance_tracker.RecordCompletion(request.name, GetGameTimer() - request.started_at, result.status)
end

local waiting_callbacks = callback_core.CreateRequestStore(record_request_completion)

local function invoke_callback(callback, data)
    return callback(table.unpack(data, 1, data.n or #data))
end

local function record_callback_execution(name, started_at, success)
    if started_at == nil then
        return
    end

    local duration = GetGameTimer() - started_at
    performance_tracker.RecordExecution(name, duration, success and "success" or "error")

    if duration >= performance_config.warningThreshold then
        performance_tracker.RecordSlowExecution(name)

        if performance_config.warningsEnabled then
            local should_warn, suppressed = performance_tracker.TakeWarningSlot(
                name,
                GetGameTimer(),
                performance_config.warningCooldown
            )

            if should_warn then
                local suppression_note = suppressed > 0 and (", suppressed since last warning: %s"):format(suppressed) or ""
                Sky.Debug("warn", ("Client callback performance warning: \"%s\" took %sms (threshold: %sms%s)."):format(
                    name,
                    duration,
                    performance_config.warningThreshold,
                    suppression_note
                ))
            end
        end
    end
end

function Sky.Cb.GetPerformanceStats(minimum_ms)
    minimum_ms = minimum_ms or 0
    assert(type(minimum_ms) == "number" and minimum_ms >= 0, "Parameter \"minimumMs\" must be a non-negative number!")

    return performance_tracker.GetStats(minimum_ms)
end

function Sky.Cb.ResetPerformanceStats()
    performance_tracker.Reset()
end

function Sky.Cb.Register(name, callback)
    assert(type(name) == "string", "Parameter \"name\" must be a string!")
    assert(callback_core.IsCallable(callback), "Parameter \"callback\" must be callable!")
    assert(registered_callbacks[name] == nil, ("ClientCallback \"%s\" is already registered!"):format(name))

    registered_callbacks[name] = {
        callback = callback,
        resource = GetInvokingResource() or GetCurrentResourceName()
    }
    callback_core.RegisterRequestEvent("sky_base:cc", name, handle_callback_request)
end

local function start_request(name, timeout, callback_function, ...)
    assert(type(name) == "string", "Parameter \"name\" must be a string!")
    assert(type(timeout) == "number" and timeout > 0, "Parameter \"timeout\" must be a positive number!")

    local request = {
        name = name,
        promise = not callback_function and promise.new() or nil,
        callback = callback_function,
        resource = GetInvokingResource() or GetCurrentResourceName(),
        started_at = performance_config.enabled and GetGameTimer() or nil
    }
    local request_id = waiting_callbacks.Add(request, timeout)
    local arguments = table.pack(...)
    request.trace = callback_trace.Begin("request", name, request.resource, arguments, "server", request_id)
    callback_core.RegisterResponseEvents(name, waiting_callbacks, response_handlers)
    -- Unknown routes keep the generic dispatcher, which can report a missing callback immediately.
    local event_name = remote_callbacks[name] and callback_core.EventName("sky_base:sc", name) or "sky_base:sc"
    local sent, send_error = pcall(callback_core.SendServerEvent, event_name, name, request_id, arguments)

    if not sent then
        Sky.Debug("error", ("ServerCallback \"%s\" could not be sent: %s"):format(name, tostring(send_error)))
        waiting_callbacks.Resolve(request_id, {
            success = false,
            status = "error"
        })
    end

    return request
end

function Sky.Cb.Trigger(name, ...)
    assert(type(name) == "string", "Parameter \"name\" must be a string!")

    return Sky.Cb.TriggerWithTimeout(name, Sky.Config.defaultCallbackTimeout or 300000, ...)
end

function Sky.Cb.TriggerWithTimeout(name, timeout, ...)
    local request = start_request(name, timeout, nil, ...)
    local result = Citizen.Await(request.promise)
    if not result.success then
        return
    end

    return table.unpack(result.data, 1, result.data.n or #result.data)
end

function Sky.Cb.TriggerAsync(name, callback_function, ...)
    assert(callback_core.IsCallable(callback_function), "Parameter \"callbackFunction\" must be callable!")

    start_request(name, Sky.Config.defaultCallbackTimeout or 300000, callback_function, ...)
end

function Sky.Cb.TriggerWithTimeoutAsync(name, timeout, callback_function, ...)
    assert(callback_core.IsCallable(callback_function), "Parameter \"callbackFunction\" must be callable!")

    start_request(name, timeout, callback_function, ...)
end

function handle_callback_request(name, request_id, data)
    local callback = registered_callbacks[name]

    if callback == nil then
        callback_trace.Finish(callback_trace.Begin("execution", tostring(name), nil, nil, "server", request_id), "missing")
        Sky.Debug("error", ("ClientCallback \"%s\" does not exist!"):format(tostring(name)))
        TriggerServerEvent(callback_core.EventName("sky_base:ccDoesNotExist", name), request_id)
        return
    end

    data = callback_core.DecodeData(data, ("client callback %s request"):format(name))
    if type(data) ~= "table" then
        Sky.Debug("error", ("ClientCallback \"%s\" received an invalid argument payload!"):format(name))
        TriggerServerEvent(callback_core.EventName("sky_base:ccError", name), request_id, "Invalid callback argument payload")
        return
    end

    local started_at = performance_config.enabled and GetGameTimer() or nil
    local trace_entry = callback_trace.Begin("execution", name, callback.resource, data, "server", request_id)
    local callback_result = table.pack(pcall(invoke_callback, callback.callback, data))
    record_callback_execution(name, started_at, callback_result[1])
    if trace_entry then
        callback_trace.Finish(trace_entry, callback_result[1] and "success" or "error",
            callback_result[1] and callback_core.PackResponse(callback_result) or nil,
            not callback_result[1] and callback_result[2] or nil)
    end

    if not callback_result[1] then
        Sky.Debug("error", ("ClientCallback \"%s\" failed: %s"):format(name, tostring(callback_result[2])))
        TriggerServerEvent(callback_core.EventName("sky_base:ccError", name), request_id, tostring(callback_result[2]))
        return
    end

    local response = callback_core.PackResponse(callback_result)
    local sent, send_error = pcall(callback_core.SendServerEvent, callback_core.EventName("sky_base:ccResponse", name), request_id, response)
    if not sent then
        Sky.Debug("error", ("ClientCallback \"%s\" could not send its response: %s"):format(name, tostring(send_error)))
        TriggerServerEvent(callback_core.EventName("sky_base:ccError", name), request_id, "Failed to serialize or send callback response")
    end
end

response_handlers["sky_base:scResponse"] = function(request_id, data)
    local request = waiting_callbacks.Get(request_id)
    if request == nil then
        return
    end
    remote_callbacks[request.name] = true

    data = callback_core.DecodeData(data, ("server callback %s response"):format(request.name))
    if type(data) ~= "table" then
        Sky.Debug("error", ("ServerCallback \"%s\" returned an invalid response payload!"):format(request.name))
        waiting_callbacks.Resolve(request_id, {
            success = false,
            status = "error"
        })
        return
    end

    waiting_callbacks.Resolve(request_id, {
        success = true,
        status = "success",
        data = data
    })
end

response_handlers["sky_base:scDoesNotExist"] = function(request_id)
    local request = waiting_callbacks.Get(request_id)
    if request == nil then
        return
    end

    Sky.Debug("error", ("ServerCallback \"%s\" does not exist!"):format(request.name))
    waiting_callbacks.Resolve(request_id, {
        success = false,
        status = "missing"
    })
end

response_handlers["sky_base:scError"] = function(request_id)
    local request = waiting_callbacks.Get(request_id)
    if request == nil then
        return
    end
    remote_callbacks[request.name] = true

    Sky.Debug("error", ("ServerCallback \"%s\" failed! Check the server console for errors."):format(request.name))
    waiting_callbacks.Resolve(request_id, {
        success = false,
        status = "error"
    })
end

RegisterNetEvent("sky_base:cc", SkyCallbackProfiler.Named("B8db235160d00d15332116b24ee77da77", "C718e78d568026b9db90fb477", handle_callback_request))
for event_name, handler in pairs(response_handlers) do
    RegisterNetEvent(event_name, SkyCallbackProfiler.Named("B8db235160d00d15332116b24ee77da77", "C161976678ff4bb43e92f9ff6", handler))
end

if not callback_core.HiddenEventNames then
    RegisterNetEvent("sky_base:scRoutes", SkyCallbackProfiler.Named("B8db235160d00d15332116b24ee77da77", "C5d7172f763a9546bad49c0ed", function(names)
        names = callback_core.DecodeData(names, "server callback routes")
        if type(names) ~= "table" then
            Sky.Debug("error", "Received an invalid server callback route list.")
            return
        end

        for _, name in ipairs(names) do
            if type(name) ~= "string" then
                Sky.Debug("error", "Received a server callback route with an invalid key.")
                return
            end
            remote_callbacks[name] = true
        end
    end))

    RegisterNetEvent("sky_base:ccRoutesRequest", SkyCallbackProfiler.Named("B8db235160d00d15332116b24ee77da77", "C8b5de86c45e3603a2ed6c3d0", function()
        local names = {}
        for name in pairs(registered_callbacks) do
            names[#names + 1] = name
        end
        callback_core.SendServerEvent("sky_base:ccRoutes", names)
    end))

    -- Discover existing server routes once; no lookup event is sent for individual callbacks.
    TriggerServerEvent("sky_base:scRoutesRequest")
end

AddEventHandler("onResourceStop", SkyCallbackProfiler.Named("B8db235160d00d15332116b24ee77da77", "C714b42ad61019788bbe20672", function(resource)
    for name, callback in pairs(registered_callbacks) do
        if callback.resource == resource then
            registered_callbacks[name] = nil
        end
    end

    waiting_callbacks.CancelWhere(function(request)
        return request.resource == resource
    end, {
        success = false,
        status = "cancelled"
    }, true)
end))
