Zones = {}

-- The territory the script knows about: every claimed hex on the server, and on each player's game only the
-- hexes their gang may know about. Both sides fill this with Zones.Set (server/systems/hexes.lua, client/hexes.lua).
Config.Zones = {}
local bounds = {}

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

---Replaces the known set of hexes (each { label, value, points }).
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

---@param coords vector3|vector2
---@return string|nil key
function Zones.FromCoords(coords)
    local x, y = coords.x, coords.y
    for key, b in pairs(bounds) do
        if x >= b[1] and x <= b[3] and y >= b[2] and y <= b[4] then
            if Zones.PointInPolygon(Config.Zones[key].points, x, y) then return key end
        end
    end
    return nil
end

function Zones.Label(key)
    local zone = key and Config.Zones[key]
    return zone and zone.label or 'Unknown'
end
