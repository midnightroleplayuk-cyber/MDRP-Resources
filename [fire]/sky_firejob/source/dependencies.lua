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
-- Shared by this resource's Lua file initializers; Jobs Base owns startup completion.
SkyJobsReady = promise.new()
SkyJobsStartupReady = promise.new()
Sky = exports["sky_base"]:Get(IsDuplicityVersion() and RegisterCommand or nil)
local resource_name = GetCurrentResourceName()
local scripts_loaded = IsDuplicityVersion()
local dependencies_ready, settled, waiting = false, false, false
local handlers = {}
local startup_handler

if not scripts_loaded then
    startup_handler = AddEventHandler("onClientResourceStart", SkyCallbackProfiler.Named("Bbf94767429f2791e7ad75dbb98189278", "Cab18b054afee1a18c61331fb", function(resource)
        if resource ~= resource_name then return end
        RemoveEventHandler(startup_handler)
        startup_handler = nil
        scripts_loaded = true
        if dependencies_ready then SkyJobsStartupReady:resolve(true) end
    end))
end

-- An initializer registered after a yielded file load must still run once.
function SkyJobsOnStart(callback)
    CreateThread(SkyCallbackProfiler.Named("Bbf94767429f2791e7ad75dbb98189278", "C1e1b449b53ef786392150777", function()
        if not Citizen.Await(SkyJobsReady) then return end
        callback(resource_name)
    end))
end

local function finish(success, failure)
    if settled then return end
    settled = true
    for _, handler in ipairs(handlers) do RemoveEventHandler(handler) end
    if success then
        Sky_Jobs = exports["sky_jobs_base"]:Get()
        if waiting then print(("[%s] Dependencies initialized"):format(resource_name)) end
    else
        if startup_handler then RemoveEventHandler(startup_handler); startup_handler = nil end
        print(("^1[%s] Resource initialization aborted: %s. Check the dependency's first error.^0")
            :format(resource_name, failure))
    end
    SkyJobsReady:resolve(success)
    dependencies_ready = success
    if scripts_loaded or not success then SkyJobsStartupReady:resolve(success) end
end

local function initialize()
    if settled then return end
    local state = exports["sky_jobs_base"]:GetStartupState()
    if state.error then
        finish(false, ("sky_jobs_base %s failed: %s"):format(state.stage, state.error))
    elseif state.ready then
        finish(true)
    end
    return state
end

handlers[#handlers + 1] = AddEventHandler("sky_jobs_base:ready:local", SkyCallbackProfiler.Named("Bbf94767429f2791e7ad75dbb98189278", "Ca81fb1da26830c358c6be3b0", initialize))
handlers[#handlers + 1] = AddEventHandler("sky_jobs_base:ready:failed", SkyCallbackProfiler.Named("Bbf94767429f2791e7ad75dbb98189278", "C351b044ce813f61e6e56d8f1", initialize))
handlers[#handlers + 1] = AddEventHandler("onResourceStop", SkyCallbackProfiler.Named("Bbf94767429f2791e7ad75dbb98189278", "Ca9cf68a9c1ada700760adb3f", function(resource)
    if resource == "sky_base" or resource == "sky_jobs_base" then
        finish(false, resource .. " stopped before initialization completed")
    end
end))

-- Subscribe before reading state, so completion cannot be missed during startup.
local state = initialize()
if not settled then
    waiting = true
    print(("[%s] Waiting for sky_jobs_base initialization (%s)"):format(resource_name, table.concat(state.pending, ", ")))
end
Citizen.Await(SkyJobsReady)
