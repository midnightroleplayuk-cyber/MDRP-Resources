Zones = {}

-- Areas come from config/zones.lua plus any drawn in game (vg_zones). The server merges both
-- and replicates the result through GlobalState.vg_zone_defs, so clients always match.
local bounds = {}
local configKeys = {}
for key in pairs(Config.Zones) do configKeys[key] = true end

function Zones.PointInPolygon(points, x, y)
    local inside = false
    local j = #points
    for i = 1, #points do
        local pi, pj = points[i], points[j]
        if ((pi.y > y) ~= (pj.y > y)) and (x < (pj.x - pi.x) * (y - pi.y) / (pj.y - pi.y) + pi.x) then
            inside = not inside
        end
        j = i
    end
    return inside
end

---Replaces the active zone set and rebuilds lookup bounds.
function Zones.Set(defs)
    Config.Zones = defs
    bounds = {}
    for key, zone in pairs(defs) do
        local minX, minY, maxX, maxY = math.huge, math.huge, -math.huge, -math.huge
        for _, p in ipairs(zone.points) do
            minX, maxX = math.min(minX, p.x), math.max(maxX, p.x)
            minY, maxY = math.min(minY, p.y), math.max(maxY, p.y)
        end
        bounds[key] = { minX, minY, maxX, maxY }
    end
end

function Zones.IsFromConfig(key) return configKeys[key] == true end

---@param coords vector3|vector2
---@return string|nil zoneKey
function Zones.FromCoords(coords)
    local x, y = coords.x, coords.y
    for key, b in pairs(bounds) do
        if x >= b[1] and x <= b[3] and y >= b[2] and y <= b[4] then
            if Zones.PointInPolygon(Config.Zones[key].points, x, y) then
                return key
            end
        end
    end
    return nil
end

function Zones.Label(key)
    local zone = key and Config.Zones[key]
    return zone and zone.label or 'Unknown'
end

---Plain, serialisable copy (vec2 -> {x, y}) for state bags and the NUI.
function Zones.Serialise(defs)
    local out = {}
    for key, z in pairs(defs or Config.Zones) do
        local pts = {}
        for i, p in ipairs(z.points) do pts[i] = { x = p.x + 0.0, y = p.y + 0.0 } end
        out[key] = { label = z.label, value = z.value or 1.0, points = pts }
    end
    return out
end

Zones.Set(Zones.Serialise(Config.Zones))

if not IsDuplicityVersion() then
    -- Client: follow the server's merged set
    local function apply(value) if type(value) == 'table' then Zones.Set(value) end end
    apply(GlobalState.vg_zone_defs)
    AddStateBagChangeHandler('vg_zone_defs', 'global', function(_, _, value) apply(value) end)
end
