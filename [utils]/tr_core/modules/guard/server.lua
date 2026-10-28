---@alias TRRateLimit integer | { max: integer, window?: integer } max calls per window (ms, default 1000)

---@class TRGuard
local guard = {}

local resource = GetCurrentResourceName()
local buckets = {} ---@type table<integer, table<string, { tokens: number, updated: integer }>>

-- Flags reported per player: the first in a window is logged and sent to Discord, the rest are
-- counted and sent as one summary when the window ends, so a player sending bad data on purpose
-- can't flood the console or the webhook queue.
local FLAG_WINDOW = 60000 -- ms
local flags = {} ---@type table<integer, { name: string, count: integer, last?: string }>

local summarize

local locks = {} ---@type table<integer, table<string, true>>

AddEventHandler('playerDropped', function()
    local src = source
    buckets[src] = nil
    locks[src] = nil
    summarize(src, flags[src])
end)

---Takes a per-player lock, for work that checks, yields (database, a client) and then acts: while
---it's held, the same player can't start that work again. Returns a function that releases it, or
---nil when the player already holds it. TR.callback / TR.net `exclusive` handlers hold the lock
---named after the callback, so other ways into the same handler can take that name too.
---
---    local release = TR.guard.lock(src, 'tr_bank:withdraw')
---    if not release then return false, 'in_progress' end
---    local ok, err = pcall(withdraw, src, amount)
---    release()
---@param src integer
---@param key string
---@return fun()? release
function guard.lock(src, key)
    local held = locks[src]
    if held and held[key] then return nil end
    if not held then
        held = {}
        locks[src] = held
    end
    held[key] = true

    local released = false
    return function()
        if released then return end
        released = true
        -- The player may have left (and their table gone) while it was held.
        local now = locks[src]
        if now == held then
            now[key] = nil
            if next(now) == nil then locks[src] = nil end
        end
    end
end

---Runs `fn(...)` holding `key`'s lock for `src` (see lock), and returns what it returns; false, 'in_progress'
---when the player already holds it. Errors in `fn` release the lock and are raised again.
---@param src integer
---@param key string
---@param fn function
---@return ...
function guard.exclusive(src, key, fn, ...)
    local release = guard.lock(src, key)
    if not release then return false, 'in_progress' end
    local result = table.pack(pcall(fn, ...))
    release()
    if not result[1] then error(result[2], 0) end
    return table.unpack(result, 2, result.n)
end

---Token-bucket rate limiter. Returns false when `src` exceeded the limit for `key`.
---@param src integer
---@param key string
---@param limit TRRateLimit
---@return boolean allowed
function guard.ratelimit(src, key, limit)
    local max, window

    if type(limit) == 'table' then
        max, window = limit.max, limit.window or 1000
    else
        max, window = limit, 1000
    end

    local now = GetGameTimer()
    local playerBuckets = buckets[src]

    if not playerBuckets then
        playerBuckets = {}
        buckets[src] = playerBuckets
    end

    local bucket = playerBuckets[key]

    if not bucket then
        playerBuckets[key] = { tokens = max - 1, updated = now }
        return true
    end

    bucket.tokens = math.min(max, bucket.tokens + (now - bucket.updated) * (max / window))
    bucket.updated = now

    if bucket.tokens < 1 then return false end

    bucket.tokens = bucket.tokens - 1
    return true
end

---Server-side position check (requires OneSync). Coordinates have no routing bucket of their own, so
---give `bucket` where the spot is in one (an instanced interior): a player in another instance at the
---same coordinates isn't near it then. Near an entity (a car, a prop) use isNearEntity, which checks
---the entity's bucket itself.
---@param src integer
---@param coords vector3 | vector4 | table
---@param maxDistance number
---@param bucket? integer routing bucket the player must be in
---@return boolean
function guard.isNear(src, coords, maxDistance, bucket)
    local ped = GetPlayerPed(src)
    if not ped or ped == 0 then return false end
    if bucket and GetPlayerRoutingBucket(src) ~= bucket then return false end

    return #(GetEntityCoords(ped) - TR.utils.toVector3(coords)) <= maxDistance
end

---Whether a player is within `maxDistance` of an entity and in the same routing bucket as it.
---@param src integer
---@param entity integer
---@param maxDistance number
---@return boolean
function guard.isNearEntity(src, entity, maxDistance)
    if not entity or entity == 0 or not DoesEntityExist(entity) then return false end
    if GetPlayerRoutingBucket(src) ~= GetEntityRoutingBucket(entity) then return false end
    return guard.isNear(src, GetEntityCoords(entity), maxDistance)
end

local function report(src, name, title, reason, details)
    local fields = {
        { name = 'Player', value = ('%s (%d)'):format(name, src), inline = true },
        { name = 'Resource', value = resource, inline = true },
    }
    if details then
        local ok, encoded = pcall(json.encode, details)
        encoded = ok and tostring(encoded) or tostring(details)
        -- Cut here, not by the webhook, so the code block stays closed.
        if #encoded > 990 then encoded = encoded:sub(1, 990) .. '...' end
        fields[3] = { name = 'Details', value = ('```json\n%s\n```'):format(encoded) }
    end

    TR.log.discord('security', { title = title, description = reason, color = 0xE74C3C, fields = fields })
end

---Sends what a player's window counted after its first flag, and closes the window.
function summarize(src, window)
    if not window or flags[src] ~= window then return end
    flags[src] = nil
    if window.count == 0 then return end

    local reason = ('%d more in %d s; the last: %s'):format(window.count, FLAG_WINDOW // 1000, window.last)
    TR.log.warn('flagged %s (%d) %s', window.name, src, reason)
    report(src, window.name, 'Player flagged again', reason)
end

---Reports suspicious behaviour. Logs it, sends it to the 'security' webhook and fires
---`tr:playerFlagged` (src, resource, reason, details) so an anticheat or ban system can act on it.
---The event fires for every flag; the log and webhook get a player's first flag in a minute, then
---one summary of the rest.
---@param src integer
---@param reason string
---@param details? table
function guard.flag(src, reason, details)
    local window = flags[src]

    if window then
        window.count, window.last = window.count + 1, reason
    else
        local name = GetPlayerName(src) or 'unknown'
        window = { name = name, count = 0 }
        flags[src] = window
        SetTimeout(FLAG_WINDOW, function() summarize(src, window) end)

        TR.log.warn('flagged %s (%d): %s', name, src, reason)
        report(src, name, 'Player flagged', reason, details)
    end

    TriggerEvent('tr:playerFlagged', src, resource, reason, details)
end

return guard
