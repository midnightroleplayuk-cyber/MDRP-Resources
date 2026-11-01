--[[
    Apex Laundry — Shared Utils
]]

Utils = Utils or {}

local resName  = GetCurrentResourceName()
local IS_SERVER = IsDuplicityVersion()

-- ─── Logging ──────────────────────────────────────────────
local COL = { reset = '^7', info = '^5', ok = '^2', warn = '^3', err = '^1', dim = '^6' }

local function _print(tag, color, ...)
    local args, out = { ... }, {}
    for i = 1, select('#', ...) do out[#out+1] = tostring(args[i]) end
    print(('%s[%s]%s %s%s%s %s'):format(color, tag, COL.reset, COL.dim, resName, COL.reset, table.concat(out, ' ')))
end

function Utils.Info(...) _print('INFO', COL.info, ...) end
function Utils.Ok(...)   _print(' OK ', COL.ok,   ...) end
function Utils.Warn(...) _print('WARN', COL.warn, ...) end
function Utils.Err(...)  _print('ERR ', COL.err,  ...) end
function Utils.Debug(...) if Config and Config.debug then _print('DBG ', COL.dim, ...) end end

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

-- ─── Money formatter (uses Config.currency) ──────────────
function Utils.money(n)
    local cur = (Config and Config.currency) or { symbol = '£', position = 'before' }
    n = math.floor(tonumber(n) or 0)
    local neg = n < 0; n = math.abs(n)
    local s = tostring(n)
    local groups = {}
    while #s > 3 do groups[#groups+1] = s:sub(-3); s = s:sub(1, -4) end
    groups[#groups+1] = s
    local final = ''
    for i = #groups, 1, -1 do final = final .. groups[i] .. (i > 1 and ',' or '') end
    if neg then final = '-' .. final end
    return cur.position == 'after' and (final .. ' ' .. cur.symbol) or (cur.symbol .. final)
end

-- ─── Vector helpers ───────────────────────────────────────
function Utils.vec3ToTbl(v)
    if not v then return nil end
    if type(v) == 'vector3' or type(v) == 'vector4' then return { x = v.x, y = v.y, z = v.z } end
    return v
end

function Utils.vec4ToTbl(v)
    if not v then return nil end
    if type(v) == 'vector4' then return { x = v.x, y = v.y, z = v.z, w = v.w } end
    if type(v) == 'vector3' then return { x = v.x, y = v.y, z = v.z, w = 0.0 } end
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
                color       = color or (Config and Config.webhookColor) or 2055679,
                footer      = { text = resName .. ' • ' .. os.date('%Y-%m-%d %H:%M') },
            }},
        }), { ['Content-Type'] = 'application/json' })
    end
end
