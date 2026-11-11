-- Courtroom areas, shared by server and client.
-- A room is either a circle (centre + radius, the original way) or a drawn shape:
--   shape = { type = 'poly', points = { { x, y }, ... }, minZ, maxZ }
-- Drawn shapes follow the actual walls, so neighbouring courtrooms don't overlap.
Zones = {}

local function inPoly(pts, x, y)
    local inside, j = false, #pts
    for i = 1, #pts do
        local xi, yi, xj, yj = pts[i].x, pts[i].y, pts[j].x, pts[j].y
        if ((yi > y) ~= (yj > y)) and (x < (xj - xi) * (y - yi) / ((yj - yi) ~= 0 and (yj - yi) or 1e-9) + xi) then inside = not inside end
        j = i
    end
    return inside
end

local function segDist(px, py, ax, ay, bx, by)
    local dx, dy = bx - ax, by - ay
    local len = dx * dx + dy * dy
    local t = len > 0 and math.max(0, math.min(1, ((px - ax) * dx + (py - ay) * dy) / len)) or 0
    local cx, cy = ax + t * dx, ay + t * dy
    return math.sqrt((px - cx) ^ 2 + (py - cy) ^ 2)
end

local function edgeDist(pts, x, y)
    local best, j = math.huge, #pts
    for i = 1, #pts do
        best = math.min(best, segDist(x, y, pts[j].x, pts[j].y, pts[i].x, pts[i].y))
        j = i
    end
    return best
end

function Zones.IsPoly(room) return room and type(room.shape) == 'table' and room.shape.type == 'poly' and #(room.shape.points or {}) >= 3 end

--- Clean a shape sent from the editor. Returns the shape or nil, reason.
function Zones.Clean(shape)
    if type(shape) ~= 'table' or type(shape.points) ~= 'table' then return nil, 'No shape.' end
    local pts = {}
    for _, p in ipairs(shape.points) do
        local x, y = tonumber(p.x), tonumber(p.y)
        if x and y then pts[#pts + 1] = { x = math.floor(x * 100) / 100, y = math.floor(y * 100) / 100 } end
    end
    if #pts < 3 then return nil, 'A room needs at least 3 corners.' end
    if #pts > 40 then return nil, 'A room can have up to 40 corners.' end
    local minZ, maxZ = tonumber(shape.minZ), tonumber(shape.maxZ)
    if not minZ or not maxZ or maxZ - minZ < 1.5 then return nil, 'The room needs a floor and a ceiling at least 1.5 m apart.' end
    if maxZ - minZ > 40 then return nil, 'That room is taller than 40 m.' end
    return { type = 'poly', points = pts, minZ = math.floor(minZ * 100) / 100, maxZ = math.floor(maxZ * 100) / 100 }
end

--- Centre (for waypoints and teleporting) and an equivalent radius (for microphone range and sound) of a shape.
function Zones.Fit(shape)
    local sx, sy, n = 0, 0, #shape.points
    for _, p in ipairs(shape.points) do sx, sy = sx + p.x, sy + p.y end
    local cx, cy = sx / n, sy / n
    local r = 0
    for _, p in ipairs(shape.points) do r = math.max(r, math.sqrt((p.x - cx) ^ 2 + (p.y - cy) ^ 2)) end
    return { x = cx, y = cy, z = shape.minZ + 1.0 }, math.max(3.0, r)
end

--- Is pos inside the room? margin = metres of leeway outside the walls.
function Zones.Contains(room, pos, margin)
    margin = margin or 0.0
    if Zones.IsPoly(room) then
        local s = room.shape
        if pos.z < s.minZ - math.min(margin, 2.0) or pos.z > s.maxZ + math.min(margin, 2.0) then return false end
        if inPoly(s.points, pos.x, pos.y) then return true end
        return margin > 0 and edgeDist(s.points, pos.x, pos.y) <= margin
    end
    local c = room and room.centre
    if not c or not c.x then return false end
    local dx, dy, dz = pos.x - c.x, pos.y - c.y, pos.z - c.z
    return math.sqrt(dx * dx + dy * dy + dz * dz) <= (room.radius or 20.0) + margin
end

--- How far into a room someone is, for choosing between overlapping rooms: being inside a
--- drawn shape beats being inside a circle; otherwise the nearer centre wins. Lower is better.
function Zones.Rank(room, pos)
    local c = room.centre or { x = 0, y = 0, z = 0 }
    local d = math.sqrt((pos.x - c.x) ^ 2 + (pos.y - c.y) ^ 2 + (pos.z - (c.z or pos.z)) ^ 2)
    if Zones.IsPoly(room) and Zones.Contains(room, pos, 0.0) then return d * 0.01 end
    return d + 1000.0
end

--- Do two rooms' areas overlap? (Shapes: a corner or centre of one inside the other.)
function Zones.Overlap(a, b)
    if not Zones.IsPoly(a) and not Zones.IsPoly(b) then
        if not (a.centre and a.centre.x and b.centre and b.centre.x) then return false end
        local d = math.sqrt((a.centre.x - b.centre.x) ^ 2 + (a.centre.y - b.centre.y) ^ 2 + (a.centre.z - b.centre.z) ^ 2)
        return d < (a.radius + b.radius)
    end
    local function anyInside(x, y)
        local zA = Zones.IsPoly(x) and (x.shape.minZ + 1.0) or (x.centre and x.centre.z) or 0
        if Zones.IsPoly(x) then
            for _, p in ipairs(x.shape.points) do
                -- pull each corner slightly towards the centre, so rooms sharing a wall don't count
                local c = x.centre
                local px, py = p.x + (c.x - p.x) * 0.05, p.y + (c.y - p.y) * 0.05
                if Zones.Contains(y, { x = px, y = py, z = zA }, 0.0) then return true end
            end
        end
        return x.centre and x.centre.x and Zones.Contains(y, { x = x.centre.x, y = x.centre.y, z = zA }, 0.0)
    end
    return anyInside(a, b) or anyInside(b, a)
end
