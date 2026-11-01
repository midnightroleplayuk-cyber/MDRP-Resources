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
Sky.Cb = {}

local MAX_REQUEST_ID = 999999999
local LATENT_EVENT_THRESHOLD = 16384
local IS_SERVER = IsDuplicityVersion()
local MAX_COMPRESSED_INPUT = IS_SERVER and 1048576 or 8388608
local MAX_COMPRESSED_OUTPUT = IS_SERVER and 8388608 or 1048576
local CallbackCore = {}
local registered_events = {}

CallbackCore.LatentBytesPerSecond = 1000000
CallbackCore.HiddenEventNames = Sky.Config.hideCallbackEventNames ~= false

function CallbackCore.EventName(event_name, callback_name)
    if CallbackCore.HiddenEventNames or type(callback_name) ~= "string" then
        return event_name
    end

    return event_name .. ":" .. callback_name
end

function CallbackCore.RegisterRequestEvent(event_name, callback_name, handler)
    event_name = CallbackCore.EventName(event_name, callback_name)
    if CallbackCore.HiddenEventNames or registered_events[event_name] then
        return
    end

    registered_events[event_name] = true
    -- Retain this route after its owner stops so subsequent requests still receive a missing-callback response.
    RegisterNetEvent(event_name, SkyCallbackProfiler.Named("B8db235160d00d15332116b24ee77da77", "Ccdc0ca0ba843b775ec7ba239", function(name, request_id, data)
        if name ~= callback_name then
            Sky.Debug("warn", ("Ignored callback request with key %s on event %s."):format(tostring(name), event_name))
            return
        end

        handler(name, request_id, data)
    end))
end

function CallbackCore.RegisterResponseEvents(callback_name, request_store, handlers)
    if CallbackCore.HiddenEventNames then
        return
    end

    for prefix, handler in pairs(handlers) do
        local event_name = CallbackCore.EventName(prefix, callback_name)
        if not registered_events[event_name] then
            registered_events[event_name] = true
            RegisterNetEvent(event_name, SkyCallbackProfiler.Named("B8db235160d00d15332116b24ee77da77", "Ca99aa259d9e1b779e2b1b4c7", function(request_id, ...)
                local request = request_store.Get(request_id)
                if request == nil then
                    return
                end

                if request.name ~= callback_name then
                    Sky.Debug("warn", ("Ignored callback response for key %s on event %s."):format(request.name, event_name))
                    return
                end

                handler(request_id, ...)
            end))
        end
    end
end

local function create_duration_stats()
    return {
        count = 0,
        total_ms = 0,
        last_ms = 0,
        min_ms = nil,
        max_ms = 0
    }
end

local function record_duration(stats, duration)
    duration = math.max(0, math.floor(duration))
    stats.count = stats.count + 1
    stats.total_ms = stats.total_ms + duration
    stats.last_ms = duration
    stats.max_ms = math.max(stats.max_ms, duration)

    if stats.min_ms == nil or duration < stats.min_ms then
        stats.min_ms = duration
    end
end

local function copy_duration_stats(stats)
    local average_ms = 0
    if stats.count > 0 then
        average_ms = stats.total_ms / stats.count
    end

    return {
        count = stats.count,
        total_ms = stats.total_ms,
        last_ms = stats.last_ms,
        min_ms = stats.min_ms or 0,
        max_ms = stats.max_ms,
        average_ms = average_ms
    }
end

function CallbackCore.IsCallable(value)
    local value_type = type(value)
    return value_type == "function"
        or (value_type == "table" and rawget(value, "__cfx_functionReference") ~= nil)
end

function CallbackCore.PackResponse(callback_result)
    local response = {
        n = callback_result.n - 1
    }

    for index = 2, callback_result.n do
        response[index - 1] = callback_result[index]
    end

    return response
end

function CallbackCore.PrepareEvent(...)
    local arguments = table.pack(...)
    local payload = msgpack.pack_args(...)
    if #payload >= LATENT_EVENT_THRESHOLD and #payload <= MAX_COMPRESSED_OUTPUT then
        local data = arguments[arguments.n]
        if type(data) == "table" then
            local encoded = Sky.Compression.Encode(data)
            if type(encoded) == "string" then
                arguments[arguments.n] = encoded
                payload = msgpack.pack_args(table.unpack(arguments, 1, arguments.n))
            end
        end
    end
    return arguments, #payload
end

function CallbackCore.DecodeData(data, context)
    if type(data) ~= "string" then return data end
    local success, decoded = pcall(Sky.Compression.Decode, data, MAX_COMPRESSED_INPUT)
    if not success then
        Sky.Debug("error", ("Invalid compressed %s: %s"):format(context, tostring(decoded)))
        return nil
    end
    return decoded
end

function CallbackCore.SendServerEvent(event_name, ...)
    local arguments, payload_size = CallbackCore.PrepareEvent(...)

    if payload_size >= LATENT_EVENT_THRESHOLD then
        TriggerLatentServerEvent(event_name, CallbackCore.LatentBytesPerSecond, table.unpack(arguments, 1, arguments.n))
    else
        TriggerServerEvent(event_name, table.unpack(arguments, 1, arguments.n))
    end
end

function CallbackCore.SendClientEvent(event_name, player_id, ...)
    local arguments, payload_size = CallbackCore.PrepareEvent(...)

    if payload_size >= LATENT_EVENT_THRESHOLD then
        TriggerLatentClientEvent(event_name, player_id, CallbackCore.LatentBytesPerSecond, table.unpack(arguments, 1, arguments.n))
    else
        TriggerClientEvent(event_name, player_id, table.unpack(arguments, 1, arguments.n))
    end
end

function CallbackCore.CreatePerformanceTracker()
    local callback_stats = {}
    local tracker = {}

    local function get_callback_stats(name)
        local stats = callback_stats[name]
        if stats ~= nil then
            return stats
        end

        stats = {
            name = name,
            execution = create_duration_stats(),
            round_trip = create_duration_stats(),
            slow_executions = 0,
            slow_warnings = 0,
            suppressed_since_warning = 0,
            last_warning_at = nil,
            execution_errors = 0,
            request_errors = 0,
            timeouts = 0,
            missing = 0,
            cancelled = 0
        }
        callback_stats[name] = stats
        return stats
    end

    function tracker.RecordExecution(name, duration, status)
        local stats = get_callback_stats(name)
        record_duration(stats.execution, duration)

        if status == "error" then
            stats.execution_errors = stats.execution_errors + 1
        end
    end

    function tracker.RecordCompletion(name, duration, status)
        local stats = get_callback_stats(name)
        record_duration(stats.round_trip, duration)

        if status == "error" then
            stats.request_errors = stats.request_errors + 1
        elseif status == "timeout" then
            stats.timeouts = stats.timeouts + 1
        elseif status == "missing" then
            stats.missing = stats.missing + 1
        elseif status == "cancelled" then
            stats.cancelled = stats.cancelled + 1
        end
    end

    function tracker.RecordSlowExecution(name)
        local stats = get_callback_stats(name)
        stats.slow_executions = stats.slow_executions + 1
    end

    function tracker.TakeWarningSlot(name, timestamp, cooldown)
        local stats = get_callback_stats(name)
        local elapsed = stats.last_warning_at and timestamp - stats.last_warning_at or nil

        if elapsed ~= nil and elapsed >= 0 and elapsed < cooldown then
            stats.suppressed_since_warning = stats.suppressed_since_warning + 1
            return false, 0
        end

        local suppressed = stats.suppressed_since_warning
        stats.last_warning_at = timestamp
        stats.suppressed_since_warning = 0
        stats.slow_warnings = stats.slow_warnings + 1
        return true, suppressed
    end

    function tracker.GetStats(minimum_ms)
        local results = {}

        for name, stats in pairs(callback_stats) do
            local highest_duration = math.max(stats.execution.max_ms, stats.round_trip.max_ms)
            if highest_duration >= minimum_ms then
                results[#results + 1] = {
                    name = name,
                    execution = copy_duration_stats(stats.execution),
                    round_trip = copy_duration_stats(stats.round_trip),
                    slow_executions = stats.slow_executions,
                    slow_warnings = stats.slow_warnings,
                    execution_errors = stats.execution_errors,
                    request_errors = stats.request_errors,
                    timeouts = stats.timeouts,
                    missing = stats.missing,
                    cancelled = stats.cancelled
                }
            end
        end

        table.sort(results, function(left, right)
            local left_duration = math.max(left.execution.max_ms, left.round_trip.max_ms)
            local right_duration = math.max(right.execution.max_ms, right.round_trip.max_ms)
            if left_duration == right_duration then
                return left.name < right.name
            end

            return left_duration > right_duration
        end)

        return results
    end

    function tracker.Reset()
        callback_stats = {}
    end

    return tracker
end

function CallbackCore.CreateRequestStore(on_resolve)
    assert(CallbackCore.IsCallable(on_resolve), "Parameter \"onResolve\" must be callable!")

    local requests = {}
    local generation = 0
    local store = {}

    function store.Add(request, timeout)
        local request_id = math.random(MAX_REQUEST_ID)

        while requests[request_id] ~= nil do
            request_id = math.random(MAX_REQUEST_ID)
        end

        generation = generation + 1
        local request_generation = generation
        request.generation = request_generation
        request.timeout = timeout
        requests[request_id] = request

        -- Keep only the id/generation in the timer, not a completed response or callback.
        SetTimeout(timeout, SkyCallbackProfiler.Named("B8db235160d00d15332116b24ee77da77", "Cf0130bc01d3719f5d6e5c5ac", function()
            local pending = requests[request_id]
            if pending == nil or pending.generation ~= request_generation then
                return
            end

            store.Resolve(request_id, {
                success = false,
                status = "timeout"
            })
        end))

        return request_id
    end

    function store.Get(request_id)
        return requests[request_id]
    end

    function store.Resolve(request_id, result)
        local request = requests[request_id]
        if request == nil then
            return
        end

        requests[request_id] = nil
        on_resolve(request, result)

        if request.promise then
            request.promise:resolve(result)
        elseif request.callback then
            local callback = request.callback
            CreateThread(SkyCallbackProfiler.Named("B8db235160d00d15332116b24ee77da77", "Cfe8e3e0fbe0f36f980717fb5", function()
                if result.success then
                    callback(table.unpack(result.data, 1, result.data.n or #result.data))
                else
                    callback()
                end
            end))
        end
    end

    function store.CancelWhere(predicate, result, discard_callbacks)
        for request_id, request in pairs(requests) do
            if predicate(request) then
                if discard_callbacks then
                    request.callback = nil
                end
                store.Resolve(request_id, result)
            end
        end
    end

    return store
end

function CallbackCore.CreateTrace()
    local sessions = {}
    local active_session
    local sequence = 0
    local trace = {}

    local function mask(value, depth, seen, secret, budget)
        if budget.left <= 0 then return "[truncated]" end
        local kind = type(value)
        if kind == "string" then
            if secret ~= "" then
                local cursor = 1
                local parts = {}
                while true do
                    local first, last = value:find(secret, cursor, true)
                    if not first then parts[#parts + 1] = value:sub(cursor); break end
                    parts[#parts + 1] = value:sub(cursor, first - 1) .. "[redacted]"
                    cursor = last + 1
                end
                value = table.concat(parts)
            end
            value = value:gsub("[Ll][Ii][Cc][Ee][Nn][Ss][Ee]2?:[%w]+", "[redacted identifier]")
                :gsub("[Ss][Tt][Ee][Aa][Mm]:[%w]+", "[redacted identifier]")
                :gsub("[Dd][Ii][Ss][Cc][Oo][Rr][Dd]:[%w]+", "[redacted identifier]")
            local limit = math.min(1024, budget.left)
            budget.left = budget.left - math.min(#value, limit)
            return value:sub(1, limit)
        end
        if kind ~= "table" then
            budget.left = budget.left - 16
            if kind == "nil" or kind == "boolean" or kind == "number" then return value end
            return tostring(value):sub(1, 120)
        end
        if depth >= 4 or seen[value] then return "[nested value omitted]" end
        seen[value] = true
        local result = {}
        local count = 0
        for key, item in pairs(value) do
            count = count + 1
            if count > 30 or budget.left <= 0 then result.truncated = true; break end
            local name = tostring(key):lower()
            budget.left = budget.left - math.min(#name, 120)
            local sensitive = name:find("token", 1, true) or name:find("password", 1, true)
                or name:find("secret", 1, true) or name:find("authorization", 1, true)
                or name:find("identifier", 1, true) or name:find("license", 1, true)
                or name:find("webhook", 1, true) or name:find("apikey", 1, true)
                or name:find("api_key", 1, true) or name:find("cookie", 1, true)
            result[type(key) == "string" and key:sub(1, 120) or key] = sensitive and "[redacted]" or mask(item, depth + 1, seen, secret, budget)
        end
        seen[value] = nil
        return result
    end

    local function slots(values, secret)
        local result = {}
        local budget = { left = 2048 }
        if not values then return result end
        for index = 1, math.min(values.n or #values, 20) do
            result[index] = values[index] == nil and { isNil = true }
                or { value = mask(values[index], 0, {}, secret, budget) }
        end
        return result
    end

    function trace.Start(options)
        options = options or {}
        local duration = options.durationMs or 15000
        local limit = options.maxEntries or 200
        assert(type(duration) == "number" and duration >= 100 and duration <= 120000, "Trace durationMs must be 100..120000.")
        assert(type(limit) == "number" and limit % 1 == 0 and limit >= 1 and limit <= 500, "Trace maxEntries must be 1..500.")
        assert(options.filter == nil or (type(options.filter) == "string" and #options.filter <= 120), "Trace filter must be a string up to 120 characters.")
        assert(active_session == nil, "A callback trace is already recording. Preserve it or stop that capture explicitly.")
        sequence = sequence + 1
        local id = ("callback-%s-%s"):format(GetGameTimer(), sequence)
        local session = { id = id, state = "recording", startedAt = GetGameTimer(), durationMs = duration,
            filter = options.filter, maxEntries = limit, entries = {}, dropped = 0, secret = GetConvar("sky_mcp_token", "") }
        sessions[#sessions + 1] = session
        if #sessions > 8 then table.remove(sessions, 1) end
        active_session = session
        SetTimeout(duration, SkyCallbackProfiler.Named("B8db235160d00d15332116b24ee77da77", "C666407fc44b89c0cdd45064a", function()
            if active_session == session then trace.Stop(id) end
        end))
        return trace.Get(id)
    end

    function trace.Get(id)
        local session
        for _, item in ipairs(sessions) do if item.id == id then session = item; break end end
        assert(session ~= nil, "Unknown callback trace.")
        local entries = {}
        local pending = 0
        local function copy(value)
            if type(value) ~= "table" then return value end
            local result = {}
            for key, child in pairs(value) do result[key] = copy(child) end
            return result
        end
        for index, entry in ipairs(session.entries) do
            entries[index] = copy(entry)
            if entry.status == "pending" then pending = pending + 1 end
        end
        return { id = session.id, state = session.state, startedAt = session.startedAt, endedAt = session.endedAt,
            durationMs = session.durationMs, filter = session.filter, entries = entries, dropped = session.dropped, pending = pending }
    end

    function trace.Stop(id)
        assert(active_session ~= nil and active_session.id == id, "This callback trace is not the active capture.")
        active_session.state = "stopped"
        active_session.endedAt = GetGameTimer()
        active_session = nil
        return trace.Get(id)
    end

    function trace.Begin(phase, name, owner, args, peer, request_id)
        local session = active_session
        if not session or (session.filter and not name:find(session.filter, 1, true)) then return end
        if #session.entries >= session.maxEntries then session.dropped = session.dropped + 1; return end
        local entry = { phase = phase, name = name, resource = owner, peer = peer, requestId = request_id,
            startedAt = GetGameTimer(), status = "pending", arguments = slots(args, session.secret) }
        session.entries[#session.entries + 1] = entry
        return { session = session, entry = entry }
    end

    function trace.Finish(token, status, response, error_message)
        if not token then return end
        token.entry.status = status
        token.entry.endedAt = GetGameTimer()
        token.entry.durationMs = (token.entry.endedAt - token.entry.startedAt) % 4294967296
        token.entry.values = slots(response, token.session.secret)
        token.entry.error = error_message and mask(tostring(error_message), 0, {}, token.session.secret, { left = 1024 }) or nil
    end

    function trace.Event(name, values)
        assert(type(name) == "string" and #name <= 120, "Trace event name must be a string up to 120 characters.")
        local token = trace.Begin("event", name, GetInvokingResource() or GetCurrentResourceName(), table.pack(values))
        trace.Finish(token, "observed")
        return token ~= nil
    end

    Sky.Cb.StartTrace = trace.Start
    Sky.Cb.GetTrace = trace.Get
    Sky.Cb.StopTrace = trace.Stop
    Sky.Cb.TraceEvent = trace.Event
    return trace
end

Sky.Cb.__core = CallbackCore
