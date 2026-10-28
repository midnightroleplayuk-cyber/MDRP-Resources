--[[
    Request/response between client and server.

    client -> server:  TR.callback.register(name, handler, options)  /  client: TR.callback.await(name, ...)
    server -> client:  client: TR.callback.register(name, handler)    /  TR.callback.await(name, src, ...)
                       or TR.callback.awaitChecked(name, src, { schema = ... }, ...) to check the answer

    Failed calls return nil plus an error code: 'timeout', 'rate_limited', 'invalid_args', 'in_progress',
    'error'; asking a client can also give 'offline' (the player left) and 'invalid_answer'.
]]

---@class TRCallbackOptions
---@field schema? TRSpec[] positional argument specs, see TR.validate
---@field rateLimit? TRRateLimit
---@field flag? boolean report invalid payloads with TR.guard.flag (default true)
---@field exclusive? boolean one call per player at a time: while the handler runs (it may yield on the database or a client), another call from the same player gets nil, 'in_progress'. It holds TR.guard.lock(src, name)

---@class TRCallbackAskOptions
---@field schema? TRSpec[] positional specs the client's answer must match, see TR.validate
---@field flag? boolean report answers that don't match with TR.guard.flag (default true)
---@field timeout? integer ms to wait for this call (default: callback.setTimeout's)

---@class TRCallback
local callback = {}

local resource = GetCurrentResourceName()
local timeout = 10000
local pending = {} ---@type table<integer, { src: integer, promise: promise }>
local nextId = 0

---Registers a callback clients can call with TR.callback.await.
---@param name string use 'resource:action' naming
---@param handler fun(src: integer, ...: any): ...
---@param options? TRCallbackOptions
function callback.register(name, handler, options)
    options = options or {}

    RegisterNetEvent(('__tr_cb:%s'):format(name), function(origin, id, ...)
        local src = source

        if type(src) ~= 'number' or src <= 0 then return end
        if type(origin) ~= 'string' or not origin:match('^[%w_%-]+$') or math.type(id) ~= 'integer' then return end

        local function reply(...)
            TriggerClientEvent(('__tr_cbr:%s'):format(origin), src, id, ...)
        end

        if options.rateLimit and not TR.guard.ratelimit(src, name, options.rateLimit) then
            return reply(false, 'rate_limited')
        end

        if options.schema then
            local ok, err = TR.validate.args(options.schema, ...)

            if not ok then
                if options.flag ~= false then
                    TR.guard.flag(src, ('invalid payload for callback %s: %s'):format(name, err))
                end
                return reply(false, 'invalid_args')
            end
        end

        -- The lock is named after the callback (TR.guard.lock), so other ways in can share it.
        local release
        if options.exclusive then
            release = TR.guard.lock(src, name)
            if not release then return reply(false, 'in_progress') end
        end

        local result = table.pack(pcall(handler, src, ...))
        if release then release() end

        if not result[1] then
            TR.log.error('callback %s failed: %s', name, result[2])
            return reply(false, 'error')
        end

        reply(true, table.unpack(result, 2, result.n))
    end)
end

RegisterNetEvent(('__tr_cbr:%s'):format(resource), function(id, ...)
    local request = pending[id]

    -- Only the client the request was sent to may answer it.
    if not request or request.src ~= source then return end

    pending[id] = nil
    local answer = table.pack(...)
    answer.client = true
    request.promise:resolve(answer)
end)

-- A player who leaves can't answer: end their requests now rather than at the timeout.
AddEventHandler('playerDropped', function()
    local src = source
    for id, request in pairs(pending) do
        if request.src == src then
            pending[id] = nil
            request.promise:resolve(table.pack(false, 'offline'))
        end
    end
end)

---@param name string
---@param src integer
---@param options TRCallbackAskOptions
local function ask(name, src, options, ...)
    src = math.tointeger(tonumber(src)) -- GetPlayers() gives strings
    if not src or src <= 0 or not GetPlayerName(src) then return nil, 'offline' end

    nextId = nextId < 2147483647 and nextId + 1 or 1
    local id = nextId
    local p = promise.new()

    pending[id] = { src = src, promise = p }
    TriggerClientEvent(('__tr_cb:%s'):format(name), src, resource, id, ...)

    SetTimeout(options.timeout or timeout, function()
        if pending[id] then
            pending[id] = nil
            p:resolve(table.pack(false, 'timeout'))
        end
    end)

    local result = Citizen.Await(p)

    if not result[1] then
        -- A client only ever says 'error' (its handler failed); a modified one could send anything else.
        local code = result.client and 'error' or result[2]
        TR.log.debug('callback %s to %d failed: %s', name, src, code)
        return nil, code
    end

    if options.schema then
        local ok, err = TR.validate.args(options.schema, table.unpack(result, 2, result.n))
        if not ok then
            if options.flag ~= false then
                TR.guard.flag(src, ('invalid answer to callback %s: %s'):format(name, err))
            end
            return nil, 'invalid_answer'
        end
    end

    return table.unpack(result, 2, result.n)
end

local NO_OPTIONS = {}

---Asks a client for data and yields until it answers. The answer comes from the player's game, so
---a modified client can send anything back: check it, or use awaitChecked.
---@param name string
---@param src integer
---@param ... any
---@return ...
function callback.await(name, src, ...)
    return ask(name, src, NO_OPTIONS, ...)
end

---await with the answer checked against `options.schema` (positional specs, like a register
---schema). An answer that doesn't match gives nil, 'invalid_answer' and flags the player.
---@param name string
---@param src integer
---@param options TRCallbackAskOptions
---@param ... any
---@return ...
function callback.awaitChecked(name, src, options, ...)
    return ask(name, src, options or NO_OPTIONS, ...)
end

---Sets how long await waits for an answer (ms, default 10000).
---@param ms integer
function callback.setTimeout(ms)
    timeout = ms
end

return callback
