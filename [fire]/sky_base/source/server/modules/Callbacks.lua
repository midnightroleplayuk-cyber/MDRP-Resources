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
local requested_callback_routes = {}
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
        Sky.Debug("error", ("ClientCallback \"%s\" timed out after %sms for player %s!"):format(
            request.name, request.timeout, request.player_id
        ))
    end

    if not performance_config.enabled then
        return
    end

    performance_tracker.RecordCompletion(request.name, GetGameTimer() - request.started_at, result.status)
end

local waiting_callbacks = callback_core.CreateRequestStore(record_request_completion)

local function invoke_callback(callback, src, data)
    return callback(src, table.unpack(data, 1, data.n or #data))
end

local function record_callback_execution(name, player_id, started_at, success)
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
                Sky.Debug("warn", ("Server callback performance warning: \"%s\" took %sms (threshold: %sms, player: %s%s)."):format(
                    name,
                    duration,
                    performance_config.warningThreshold,
                    player_id,
                    suppression_note
                ))
            end
        end
    end
end

local function get_waiting_callback(request_id, src)
    local request = waiting_callbacks.Get(request_id)
    if request == nil then
        return
    end

    if request.player_id ~= src then
        Sky.Debug("warn", ("Ignored callback response for request %s from unexpected player %s."):format(tostring(request_id), tostring(src)))
        return
    end

    return request
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
    assert(registered_callbacks[name] == nil, ("ServerCallback \"%s\" is already registered!"):format(name))

    registered_callbacks[name] = {
        callback = callback,
        resource = GetInvokingResource() or GetCurrentResourceName()
    }
    callback_core.RegisterRequestEvent("sky_base:sc", name, handle_callback_request)
end

exports("RegisterServerCallback", SkyCallbackProfiler.Named("B8db235160d00d15332116b24ee77da77", "Ca28fdf83590508e7f31aa764", function(name, callback)
    Sky.Cb.Register(name, SkyCallbackProfiler.Wrap("B8db235160d00d15332116b24ee77da77", "C4406641eac4cf55c222f53ea", callback))
end))

exports("HasServerCallbackApi", SkyCallbackProfiler.Named("B8db235160d00d15332116b24ee77da77", "C28b489fb854e1cf1dec49bf0", function()
    return true
end))

local function start_request(name, player_id, timeout, callback_function, ...)
    assert(type(name) == "string", "Parameter \"name\" must be a string!")
    assert(type(player_id) == "number", "Parameter \"playerId\" must be a number!")
    assert(type(timeout) == "number" and timeout > 0, "Parameter \"timeout\" must be a positive number!")

    local request = {
        name = name,
        player_id = player_id,
        promise = not callback_function and promise.new() or nil,
        callback = callback_function,
        resource = GetInvokingResource() or GetCurrentResourceName(),
        started_at = performance_config.enabled and GetGameTimer() or nil
    }
    local request_id = waiting_callbacks.Add(request, timeout)
    local arguments = table.pack(...)
    request.trace = callback_trace.Begin("request", name, request.resource, arguments, player_id, request_id)
    callback_core.RegisterResponseEvents(name, waiting_callbacks, response_handlers)
    local event_name = "sky_base:cc"
    if not callback_core.HiddenEventNames then
        if not requested_callback_routes[player_id] then
            requested_callback_routes[player_id] = true
            remote_callbacks[player_id] = {}
            TriggerClientEvent("sky_base:ccRoutesRequest", player_id)
        end

        if remote_callbacks[player_id][name] then
            event_name = callback_core.EventName(event_name, name)
        end
    end
    local sent, send_error = pcall(callback_core.SendClientEvent, event_name, player_id, name, request_id, arguments)

    if not sent then
        Sky.Debug("error", ("ClientCallback \"%s\" could not be sent to player %s: %s"):format(name, player_id, tostring(send_error)))
        waiting_callbacks.Resolve(request_id, {
            success = false,
            status = "error"
        })
    end

    return request
end

function Sky.Cb.Trigger(name, player_id, ...)
    assert(type(name) == "string", "Parameter \"name\" must be a string!")
    assert(type(player_id) == "number", "Parameter \"playerId\" must be a number!")

    return Sky.Cb.TriggerWithTimeout(name, player_id, Sky.Config.defaultCallbackTimeout or 300000, ...)
end

function Sky.Cb.TriggerWithTimeout(name, player_id, timeout, ...)
    local request = start_request(name, player_id, timeout, nil, ...)
    local result = Citizen.Await(request.promise)
    if not result.success then
        return
    end

    return table.unpack(result.data, 1, result.data.n or #result.data)
end

function Sky.Cb.TriggerAsync(name, player_id, callback_function, ...)
    assert(callback_core.IsCallable(callback_function), "Parameter \"callbackFunction\" must be callable!")

    start_request(name, player_id, Sky.Config.defaultCallbackTimeout or 300000, callback_function, ...)
end

function Sky.Cb.TriggerWithTimeoutAsync(name, player_id, timeout, callback_function, ...)
    assert(callback_core.IsCallable(callback_function), "Parameter \"callbackFunction\" must be callable!")

    start_request(name, player_id, timeout, callback_function, ...)
end

function handle_callback_request(name, request_id, data)
    local src = source
    local callback = registered_callbacks[name]

    if callback == nil then
        callback_trace.Finish(callback_trace.Begin("execution", tostring(name), nil, nil, src, request_id), "missing")
        Sky.Debug("error", ("ServerCallback \"%s\" does not exist!"):format(tostring(name)))
        TriggerClientEvent(callback_core.EventName("sky_base:scDoesNotExist", name), src, request_id)
        return
    end

    data = callback_core.DecodeData(data, ("server callback %s request from player %s"):format(name, src))
    if type(data) ~= "table" then
        Sky.Debug("error", ("ServerCallback \"%s\" received an invalid argument payload from player %s!"):format(name, src))
        TriggerClientEvent(callback_core.EventName("sky_base:scError", name), src, request_id)
        return
    end

    local started_at = performance_config.enabled and GetGameTimer() or nil
    local trace_entry = callback_trace.Begin("execution", name, callback.resource, data, src, request_id)
    local callback_result = table.pack(pcall(invoke_callback, callback.callback, src, data))
    record_callback_execution(name, src, started_at, callback_result[1])
    if trace_entry then
        callback_trace.Finish(trace_entry, callback_result[1] and "success" or "error",
            callback_result[1] and callback_core.PackResponse(callback_result) or nil,
            not callback_result[1] and callback_result[2] or nil)
    end

    if not callback_result[1] then
        Sky.Debug("error", ("ServerCallback \"%s\" failed: %s"):format(name, tostring(callback_result[2])))
        TriggerClientEvent(callback_core.EventName("sky_base:scError", name), src, request_id)
        return
    end

    local response = callback_core.PackResponse(callback_result)
    local sent, send_error = pcall(callback_core.SendClientEvent, callback_core.EventName("sky_base:scResponse", name), src, request_id, response)
    if not sent then
        Sky.Debug("error", ("ServerCallback \"%s\" could not send its response to player %s: %s"):format(name, src, tostring(send_error)))
        TriggerClientEvent(callback_core.EventName("sky_base:scError", name), src, request_id)
    end
end

response_handlers["sky_base:ccResponse"] = function(request_id, data)
    local request = get_waiting_callback(request_id, source)
    if request == nil then
        return
    end
    if not callback_core.HiddenEventNames then
        remote_callbacks[request.player_id][request.name] = true
    end

    data = callback_core.DecodeData(data, ("client callback %s response from player %s"):format(request.name, source))
    if type(data) ~= "table" then
        Sky.Debug("error", ("ClientCallback \"%s\" returned an invalid response payload!"):format(request.name))
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

response_handlers["sky_base:ccDoesNotExist"] = function(request_id)
    local request = get_waiting_callback(request_id, source)
    if request == nil then
        return
    end

    Sky.Debug("error", ("ClientCallback \"%s\" does not exist for player %s!"):format(request.name, request.player_id))
    waiting_callbacks.Resolve(request_id, {
        success = false,
        status = "missing"
    })
end

response_handlers["sky_base:ccError"] = function(request_id, error_message)
    local request = get_waiting_callback(request_id, source)
    if request == nil then
        return
    end
    if not callback_core.HiddenEventNames then
        remote_callbacks[request.player_id][request.name] = true
    end

    Sky.Debug("error", ("ClientCallback \"%s\" failed for player %s: %s"):format(request.name, request.player_id, tostring(error_message)))
    waiting_callbacks.Resolve(request_id, {
        success = false,
        status = "error"
    })
end

RegisterNetEvent("sky_base:sc", SkyCallbackProfiler.Named("B8db235160d00d15332116b24ee77da77", "Cfbf7e01c33e2aedfe3fc40a5", handle_callback_request))
for event_name, handler in pairs(response_handlers) do
    RegisterNetEvent(event_name, SkyCallbackProfiler.Named("B8db235160d00d15332116b24ee77da77", "C023f548264252136b246a4a2", handler))
end

if not callback_core.HiddenEventNames then
    RegisterNetEvent("sky_base:scRoutesRequest", SkyCallbackProfiler.Named("B8db235160d00d15332116b24ee77da77", "Cface287b806b9dee56d01687", function()
        local names = {}
        for name in pairs(registered_callbacks) do
            names[#names + 1] = name
        end
        callback_core.SendClientEvent("sky_base:scRoutes", source, names)
    end))

    RegisterNetEvent("sky_base:ccRoutes", SkyCallbackProfiler.Named("B8db235160d00d15332116b24ee77da77", "C233a14bb09c4762cc1affc33", function(names)
        local src = source
        local routes = remote_callbacks[src]
        if routes == nil then
            Sky.Debug("warn", ("Ignored an unsolicited client callback route list from player %s."):format(src))
            return
        end
        names = callback_core.DecodeData(names, ("client callback routes from player %s"):format(src))
        if type(names) ~= "table" then
            Sky.Debug("error", ("Received an invalid client callback route list from player %s."):format(src))
            return
        end

        for _, name in ipairs(names) do
            if type(name) ~= "string" then
                Sky.Debug("error", ("Received a client callback route with an invalid key from player %s."):format(src))
                return
            end
            routes[name] = true
        end
    end))
end

AddEventHandler("playerDropped", SkyCallbackProfiler.Named("B8db235160d00d15332116b24ee77da77", "C1adb58642a057fc0eae7c58b", function()
    local player_id = source
    remote_callbacks[player_id] = nil
    requested_callback_routes[player_id] = nil

    waiting_callbacks.CancelWhere(function(request)
        return request.player_id == player_id
    end, {
        success = false,
        status = "cancelled"
    })
end))

AddEventHandler("onResourceStop", SkyCallbackProfiler.Named("B8db235160d00d15332116b24ee77da77", "C25da54077413a1b8bfdda943", function(resource)
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

RegisterCommand("sky_callback_stats", function(command_source, args)
    if command_source ~= 0 then
        Sky.Debug("warn", "The sky_callback_stats command can only be used from the server console.")
        return
    end

    local minimum_ms = performance_config.warningThreshold
    if args[1] ~= nil then
        minimum_ms = tonumber(args[1])
        if minimum_ms == nil or minimum_ms < 0 then
            Sky.Debug("warn", "Usage: sky_callback_stats [minimum_ms]")
            return
        end
    end

    local stats = Sky.Cb.GetPerformanceStats(minimum_ms)
    if #stats == 0 then
        Sky.Debug("info", ("No callback performance entries matched the minimum of %sms."):format(minimum_ms))
        return
    end

    Sky.Debug("info", ("Callback performance stats: %s entries with a maximum duration of at least %sms."):format(#stats, minimum_ms))

    for index = 1, #stats do
        local entry = stats[index]
        Sky.Debug("info", ("%s | execution: count=%s avg=%.1fms max=%sms slow=%s | round-trip: count=%s avg=%.1fms max=%sms | warnings=%s execution-errors=%s request-errors=%s timeouts=%s missing=%s cancelled=%s"):format(
            entry.name,
            entry.execution.count,
            entry.execution.average_ms,
            entry.execution.max_ms,
            entry.slow_executions,
            entry.round_trip.count,
            entry.round_trip.average_ms,
            entry.round_trip.max_ms,
            entry.slow_warnings,
            entry.execution_errors,
            entry.request_errors,
            entry.timeouts,
            entry.missing,
            entry.cancelled
        ))
    end
end, true)

RegisterCommand("sky_callback_stats_reset", function(command_source)
    if command_source ~= 0 then
        Sky.Debug("warn", "The sky_callback_stats_reset command can only be used from the server console.")
        return
    end

    Sky.Cb.ResetPerformanceStats()
    Sky.Debug("info", "Callback performance stats were reset.")
end, true)
