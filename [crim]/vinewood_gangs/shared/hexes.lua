-- Hex grid maths, the same on server and client. Pointy-top hexes in axial coordinates (q, r).
Hex = {}

local SQ3 = math.sqrt(3)

function Hex.Enabled() return true end -- territory is always hexes

local function cfg() return Config.Hexes end

function Hex.Key(q, r) return ('h:%d:%d'):format(q, r) end

function Hex.Parse(key)
    local q, r = tostring(key or ''):match('^h:(%-?%d+):(%-?%d+)$')
    return tonumber(q), tonumber(r)
end

local function round(n) return n >= 0 and math.floor(n + 0.5) or -math.floor(-n + 0.5) end

---Which hex a world position is in.
function Hex.FromCoords(x, y)
    local c = cfg()
    local R = c.size
    x, y = x - c.origin.x, y - c.origin.y
    local fq = (SQ3 / 3 * x - y / 3) / R
    local fr = (2 / 3 * y) / R
    local fs = -fq - fr
    local q, r, s = round(fq), round(fr), round(fs)
    local dq, dr, ds = math.abs(q - fq), math.abs(r - fr), math.abs(s - fs)
    if dq > dr and dq > ds then q = -r - s elseif dr > ds then r = -q - s end
    return q, r
end

function Hex.Centre(q, r)
    local c = cfg()
    return c.origin.x + c.size * SQ3 * (q + r / 2), c.origin.y + c.size * 1.5 * r
end

---The six corners as { x, y } tables.
function Hex.Corners(q, r)
    local cx, cy = Hex.Centre(q, r)
    local R, out = cfg().size, {}
    for i = 0, 5 do
        local a = math.rad(60 * i - 30)
        out[#out + 1] = { x = cx + R * math.cos(a), y = cy + R * math.sin(a) }
    end
    return out
end

local DIRS = { { 1, 0 }, { 1, -1 }, { 0, -1 }, { -1, 0 }, { -1, 1 }, { 0, 1 } }
function Hex.Neighbours(q, r)
    local out = {}
    for _, d in ipairs(DIRS) do out[#out + 1] = { q + d[1], r + d[2] } end
    return out
end

function Hex.Touching(q1, r1, q2, r2)
    local dq, dr = q1 - q2, r1 - r2
    return (math.abs(dq) + math.abs(dr) + math.abs(dq + dr)) == 2
end

---Name of the nearest district, plus the hex's grid reference so every hex is unique.
function Hex.Label(q, r)
    local cx, cy = Hex.Centre(q, r)
    local best, bestD = 'Hex', math.huge
    for _, d in ipairs(cfg().districts or {}) do
        local dd = (d[2] - cx) ^ 2 + (d[3] - cy) ^ 2
        if dd < bestD then best, bestD = d[1], dd end
    end
    return ('%s (%d, %d)'):format(best, q, r)
end
