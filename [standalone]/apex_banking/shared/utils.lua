--[[
    Apex Banking — Shared Utils
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
    if Config and Config.debug then _print('DBG ', COL.dim, ...) end
end

-- ─── Table helpers ────────────────────────────────────────
function Utils.deepcopy(t)
    if type(t) ~= 'table' then return t end
    local out = {}
    for k, v in pairs(t) do out[k] = Utils.deepcopy(v) end
    return out
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

function Utils.clamp(v, lo, hi)
    if v < lo then return lo end
    if v > hi then return hi end
    return v
end

-- ─── UUID-ish id generator ────────────────────────────────
math.randomseed(IS_SERVER and os.time() or GetGameTimer())
function Utils.uid(prefix)
    local s = ('%x%x%x%x'):format(
        math.random(0, 0xffff), math.random(0, 0xffff),
        math.random(0, 0xffff), math.random(0, 0xffff)
    )
    return (prefix or 'id') .. '_' .. s
end

-- ─── IBAN generator (prefix + N digits) ───────────────────
function Utils.makeIban()
    local cfg = (Config and Config.iban) or { prefix = 'AP', digits = 10 }
    local n = cfg.digits or 10
    local prefix = cfg.prefix or 'AP'
    local out = {}
    for i = 1, n do out[i] = tostring(math.random(0, 9)) end
    return prefix .. table.concat(out)
end

function Utils.prettyIban(iban)
    local cfg = (Config and Config.iban) or { groupBy = 4 }
    local gb = cfg.groupBy or 4
    if not iban or iban == '' then return '' end
    local prefix = iban:sub(1, 2)
    local rest   = iban:sub(3)
    local parts  = { prefix }
    for i = 1, #rest, gb do
        parts[#parts+1] = rest:sub(i, i + gb - 1)
    end
    return table.concat(parts, ' ')
end

function Utils.makePin()
    local cfg = (Config and Config.pin) or { length = 4 }
    local n = cfg.length or 4
    local out = {}
    for i = 1, n do out[i] = tostring(math.random(0, 9)) end
    return table.concat(out)
end

-- ─── Money formatter (uses Config.currency) ──────────────
function Utils.money(n)
    local cur = (Config and Config.currency) or { symbol = '$', position = 'before' }
    n = math.floor(tonumber(n) or 0)
    -- Group thousands with comma; negatives keep their sign.
    local neg = n < 0
    n = math.abs(n)
    local s = tostring(n)
    local groups = {}
    while #s > 3 do
        groups[#groups+1] = s:sub(-3)
        s = s:sub(1, -4)
    end
    groups[#groups+1] = s
    local final = ''
    for i = #groups, 1, -1 do
        final = final .. groups[i] .. (i > 1 and ',' or '')
    end
    if neg then final = '-' .. final end
    return cur.position == 'after'
        and (final .. ' ' .. cur.symbol)
        or  (cur.symbol .. final)
end

-- ─── JSON file I/O (SERVER ONLY) ──────────────────────────
if IS_SERVER then
    function Utils.readJson(relPath, fallback)
        local raw = LoadResourceFile(resName, relPath)
        if not raw or raw == '' then return fallback end
        local ok, data = pcall(json.decode, raw)
        if not ok then
            Utils.Err('Failed to parse JSON', relPath, data)
            return fallback
        end
        return data
    end

    function Utils.writeJson(relPath, tbl)
        local ok, str = pcall(json.encode, tbl, { indent = true })
        if not ok then Utils.Err('json encode failed', str); return false end
        local saved = SaveResourceFile(resName, relPath, str, -1)
        return saved == 1 or saved == true
    end
end

-- ─── Vector helpers ───────────────────────────────────────
function Utils.vec3ToTbl(v)
    if not v then return nil end
    if type(v) == 'vector3' or type(v) == 'vector4' then
        return { x = v.x, y = v.y, z = v.z }
    end
    return v
end

function Utils.vec4ToTbl(v)
    if not v then return nil end
    if type(v) == 'vector4' then
        return { x = v.x, y = v.y, z = v.z, w = v.w }
    end
    if type(v) == 'vector3' then
        return { x = v.x, y = v.y, z = v.z, w = 0.0 }
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

-- ─── Permission helpers (sub-accounts) ───────────────────
Utils.PERMISSIONS = { 'view', 'deposit', 'withdraw', 'transfer', 'manage' }

function Utils.defaultSubPerms()
    return {
        view     = true,
        deposit  = true,
        withdraw = false,
        transfer = false,
        manage   = false,
        dailyLimit = 0,
    }
end
