--[[
    Apex Restaurant — Shared Utils
]]

Utils = Utils or {}

local resName = GetCurrentResourceName()
local IS_SERVER = IsDuplicityVersion()

-- ─── Logging ──────────────────────────────────────────────
local COL = {
    reset = '^7',
    info  = '^5',
    ok    = '^2',
    warn  = '^3',
    err   = '^1',
    dim   = '^6',
}

local function _print(tag, color, ...)
    local args = { ... }
    local out = {}
    for i = 1, select('#', ...) do
        out[#out+1] = tostring(args[i])
    end
    print(('%s[%s]%s %s%s%s %s'):format(color, tag, COL.reset, COL.dim, resName, COL.reset, table.concat(out, ' ')))
end

function Utils.Info(...)  _print('INFO', COL.info, ...) end
function Utils.Ok(...)    _print(' OK ', COL.ok,   ...) end
function Utils.Warn(...)  _print('WARN', COL.warn, ...) end
function Utils.Err(...)   _print('ERR ', COL.err,  ...) end

function Utils.Debug(...)
    if Config.debug then _print('DBG ', COL.dim, ...) end
end

-- ─── Table helpers ────────────────────────────────────────
function Utils.deepcopy(t)
    if type(t) ~= 'table' then return t end
    local out = {}
    for k, v in pairs(t) do out[k] = Utils.deepcopy(v) end
    return out
end

function Utils.merge(dst, src)
    for k, v in pairs(src or {}) do
        if type(v) == 'table' and type(dst[k]) == 'table' then
            Utils.merge(dst[k], v)
        else
            dst[k] = v
        end
    end
    return dst
end

function Utils.size(t)
    local n = 0; for _ in pairs(t or {}) do n = n + 1 end; return n
end

function Utils.find(list, predicate)
    for i, v in ipairs(list or {}) do
        if predicate(v, i) then return v, i end
    end
end

-- ─── Math / coords ────────────────────────────────────────
function Utils.dist(a, b)
    local dx, dy, dz = a.x - b.x, a.y - b.y, a.z - b.z
    return math.sqrt(dx*dx + dy*dy + dz*dz)
end

function Utils.round(v, p)
    p = 10 ^ (p or 0)
    return math.floor(v * p + 0.5) / p
end

-- ─── Calorie → hunger/thirst conversion ─────────────────
-- Returns the hunger / thirst gain (% points, capped) for a single
-- unit of `itemName`. `metaCalories` overrides items.lua when set
-- (used when the inventory item carries a per-stack calorie value
-- in its metadata — e.g. universal `restaurant_food` items).
function Utils.calorieEffect(itemName, metaCalories)
    local cfg = (Config and Config.calorieSystem) or {}
    if cfg.enabled == false then return 0, 0 end

    local def      = (Items and Items.get and Items.get(itemName)) or {}
    local category = def.category or ''
    local kcal     = tonumber(metaCalories)
                  or (Items and Items.calories and Items.calories(itemName))
                  or 0
    if kcal <= 0 then return 0, 0 end

    local hPer = tonumber(cfg.hungerPerCalorie) or 0.10
    local tPer = tonumber(cfg.thirstPerCalorie) or 0.05
    local foodMul   = tonumber(cfg.foodMultiplier)  or 1.0
    local drinkMul  = tonumber(cfg.drinkMultiplier) or 1.0
    local solidPen  = tonumber(cfg.solidPenalty)    or 0.10
    local liquidPen = tonumber(cfg.liquidPenalty)   or 0.20
    local cap       = tonumber(cfg.maxFillPerItem)  or 100

    local hunger, thirst
    if category == 'drink' then
        hunger = kcal * hPer * solidPen
        thirst = kcal * tPer * drinkMul
    elseif category == 'food' or category == 'raw' or category == 'cutted' or category == 'universal' then
        hunger = kcal * hPer * foodMul
        thirst = kcal * tPer * liquidPen
    else
        hunger = kcal * hPer
        thirst = kcal * tPer
    end
    if hunger > cap then hunger = cap end
    if thirst > cap then thirst = cap end
    return math.floor(hunger + 0.5), math.floor(thirst + 0.5)
end

-- ─── Recipe duration ─────────────────────────────────────
-- Computes how long a preparation/cooking recipe takes:
--   1) `rc.time` (explicit per-recipe override) always wins
--   2) otherwise: base + (units − 1) × extra
-- where `units` is the sum of ingredient quantities for cooking, or
-- the input count (always 1) for preparation. Pulls base/extra from
-- Config.times so all timings live in one place.
function Utils.recipeTime(rc, kind, stationKind)
    if rc and tonumber(rc.time) and rc.time > 0 then return rc.time end
    local t = (Config and Config.times) or {}
    if kind == 'preparation' then
        return t.prepareBase or 3000
    end
    local units = 0
    if rc and rc.ingredients then
        for _, qty in pairs(rc.ingredients) do
            units = units + (tonumber(qty) or 1)
        end
    end
    if units <= 0 then units = 1 end
    local base = (t.cookBase or 4000) + math.max(0, units - 1) * (t.cookExtra or 800)
    -- Per-station multiplier (grill is slow on purpose; drinks are fast)
    local mul = t.kindMultiplier and stationKind and t.kindMultiplier[stationKind] or 1.0
    return math.floor(base * mul)
end

-- ─── UUID-ish id generator ────────────────────────────────
-- `os` is server-only in the FiveM Lua runtime. On the client we fall
-- back to GetGameTimer() (milliseconds since FiveM started).
math.randomseed(IS_SERVER and os.time() or GetGameTimer())
function Utils.uid(prefix)
    local s = ('%x%x%x%x'):format(
        math.random(0, 0xffff), math.random(0, 0xffff),
        math.random(0, 0xffff), math.random(0, 0xffff)
    )
    return (prefix or 'id') .. '_' .. s
end

-- ─── JSON file I/O (SERVER ONLY) ──────────────────────────
-- IMPORTANT — FiveM's `json` global is **dkjson**, which does NOT raise
-- on malformed input: `json.decode` returns `nil, pos, errmsg` and
-- `json.encode` returns `nil, errmsg`. Wrapping them in pcall() is
-- therefore useless — pcall always succeeds and you get a nil VALUE.
-- Every check below inspects the returned value, never just `ok`.
if IS_SERVER then
    function Utils.readJson(relPath, fallback)
        local raw = LoadResourceFile(resName, relPath)
        if not raw or raw == '' then return fallback end
        -- dkjson: ok, <value>, <pos>, <errmsg>
        local ok, data, _, derr = pcall(json.decode, raw)
        if not ok then
            Utils.Err('Failed to parse JSON', relPath, tostring(data))
            return fallback
        end
        if type(data) ~= 'table' then
            -- Empty / whitespace-only / truncated / hand-edited file.
            -- Returning `data` here would hand callers a nil and blow up
            -- at their first index — always fall back instead.
            Utils.Err('Invalid JSON in', relPath, tostring(derr or 'not a JSON object'), '— using defaults')
            return fallback
        end
        return data
    end

    function Utils.writeJson(relPath, tbl)
        local ok, str = pcall(json.encode, tbl, { indent = true })
        if not ok then Utils.Err('json encode failed', relPath, tostring(str)); return false end
        if type(str) ~= 'string' or str == '' then
            -- Never truncate the file to nothing: an empty/!string payload
            -- would make the NEXT boot read an unparseable file.
            Utils.Err('json encode returned no data for', relPath, '— refusing to overwrite it')
            return false
        end
        local saved = SaveResourceFile(resName, relPath, str, -1)
        return saved == 1 or saved == true
    end
end

-- ─── Vector helpers (serialization for JSON) ──────────────
function Utils.vec3ToTbl(v)
    if not v then return nil end
    if type(v) == 'vector3' or type(v) == 'vector4' then
        return { x = v.x, y = v.y, z = v.z }
    end
    return v
end

function Utils.tblToVec3(t)
    if not t then return nil end
    if type(t) == 'vector3' then return t end
    return vec3(t.x or t[1], t.y or t[2], t.z or t[3])
end

function Utils.tblToVec4(t)
    if not t then return nil end
    if type(t) == 'vector4' then return t end
    return vector4(t.x or t[1], t.y or t[2], t.z or t[3], t.w or t.heading or t[4] or 0.0)
end

-- ─── Discord webhook (server-only) ────────────────────────
if IS_SERVER then
    function Utils.Webhook(url, title, description, color)
        if not url or url == '' then return end
        PerformHttpRequest(url, function() end, 'POST', json.encode({
            embeds = {{
                title       = title,
                description = description,
                color       = color or 0x8D21E8,
                footer      = { text = resName .. ' • ' .. os.date('%Y-%m-%d %H:%M') },
            }},
        }), { ['Content-Type'] = 'application/json' })
    end
end
