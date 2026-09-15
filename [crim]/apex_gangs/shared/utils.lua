--[[
    Apex Gangs — Shared utilities (client + server)
]]

Utils = Utils or {}

-- ─── Logging ──────────────────────────────────────────────
local PREFIX = '^5[apex_gangs]^7'
function Utils.Info(...) if Config and Config.debug then print(PREFIX, ...) end end
function Utils.Log(level, fmt, ...)
    if level == 'debug' and not (Config and Config.debug) then return end
    local ok, msg = pcall(string.format, fmt, ...)
    print(('%s ^3%s^7 %s'):format(PREFIX, tostring(level):upper(), ok and msg or tostring(fmt)))
end
function Utils.Err(...) print(PREFIX, '^1ERROR^7', ...) end
Apex = Apex or {}
function Apex.log(level, fmt, ...) Utils.Log(level, fmt, ...) end

-- ─── Locale shortcut (resolved in _loader.lua) ────────────
function Utils.t(key, ...) return (L and L(key, ...)) or key end

-- ─── Math ─────────────────────────────────────────────────
function Utils.round(v, dp)
    local m = 10 ^ (dp or 0)
    return math.floor((tonumber(v) or 0) * m + 0.5) / m
end
function Utils.clamp(v, lo, hi) v = tonumber(v) or 0; if v < lo then return lo elseif v > hi then return hi end return v end
function Utils.dist2D(x1, y1, x2, y2) local dx, dy = x1 - x2, y1 - y2 return math.sqrt(dx*dx + dy*dy) end
function Utils.dist3D(a, b) local dx, dy, dz = a.x - b.x, a.y - b.y, a.z - b.z return math.sqrt(dx*dx + dy*dy + dz*dz) end

-- ─── Tables ───────────────────────────────────────────────
function Utils.tlength(t) local n = 0 if type(t) ~= 'table' then return 0 end for _ in pairs(t) do n = n + 1 end return n end
function Utils.contains(t, v) if type(t) ~= 'table' then return false end for _, x in ipairs(t) do if x == v then return true end end return false end
function Utils.keys(t) local out = {} for k in pairs(t or {}) do out[#out+1] = k end return out end
function Utils.shallowCopy(t) local o = {} for k, v in pairs(t or {}) do o[k] = v end return o end
function Utils.merge(a, b) local o = Utils.shallowCopy(a) for k, v in pairs(b or {}) do o[k] = v end return o end

-- ─── Strings ──────────────────────────────────────────────
function Utils.trim(s) return (tostring(s or ''):gsub('^%s+', ''):gsub('%s+$', '')) end
function Utils.slug(s)
    s = tostring(s or ''):lower():gsub('%s+', '_'):gsub('[^%w_]', '')
    return s
end
function Utils.titleCase(s) return (tostring(s or ''):gsub('(%a)([%w]*)', function(a, b) return a:upper() .. b:lower() end)) end

-- ─── IDs ──────────────────────────────────────────────────
local _ctr = 0
function Utils.uuid(prefix)
    _ctr = _ctr + 1
    local t = (IsDuplicityVersion() and os.time()) or GetGameTimer()
    return ('%s%d_%d'):format(prefix or 'id_', t, _ctr)
end

-- ─── Money formatting ─────────────────────────────────────
function Utils.money(n)
    n = math.floor(tonumber(n) or 0)
    local s = tostring(math.abs(n))
    local formatted = s:reverse():gsub('(%d%d%d)', '%1,'):reverse():gsub('^,', '')
    local sym = (Config and Config.currency and Config.currency.symbol) or '$'
    local pos = (Config and Config.currency and Config.currency.position) or 'before'
    local sign = n < 0 and '-' or ''
    if pos == 'before' then return ('%s%s%s'):format(sign, sym, formatted) end
    return ('%s%s%s'):format(sign, formatted, sym)
end

-- ─── Geometry helpers (turf) ──────────────────────────────
function Utils.pointInPoly(px, py, pts)
    local inside, n = false, #pts
    local j = n
    for i = 1, n do
        local xi, yi = pts[i].x, pts[i].y
        local xj, yj = pts[j].x, pts[j].y
        local dy = (yj - yi); if dy == 0 then dy = 1e-9 end
        if ((yi > py) ~= (yj > py)) and (px < (xj - xi) * (py - yi) / dy + xi) then inside = not inside end
        j = i
    end
    return inside
end
function Utils.polyCentroid(pts)
    local sx, sy, n = 0, 0, #pts
    for _, p in ipairs(pts) do sx = sx + p.x; sy = sy + p.y end
    if n == 0 then return { x = 0, y = 0 } end
    return { x = sx / n, y = sy / n }
end
function Utils.boundingRadius(center, pts)
    local m = 0
    for _, p in ipairs(pts) do local d = Utils.dist2D(center.x, center.y, p.x, p.y); if d > m then m = d end end
    return m
end
