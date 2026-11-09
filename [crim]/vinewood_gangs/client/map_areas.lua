-- Areas on the in-game map, filled in the owning gang's colour.
-- GTA can only draw rectangles on the map, so each area is filled with small squares that follow its outline.

local cfg = Config.Territory.map or { enabled = true, showTo = 'gangs', alpha = 90, cellSize = 40.0, maxCells = 150, maxTotal = 900 }

---On or off, the minimap, and who sees it: what staff set in /gangadmin > Turf (config until then).
local function live()
    local m = GlobalState.vg_turf_map
    if type(m) ~= 'table' then return { enabled = cfg.enabled ~= false, minimap = cfg.minimap == true, showTo = cfg.showTo } end
    return m
end

local blips = {} -- every blip we've made
local lastKey    -- what was drawn last time, so we only redraw when something changes

-- GTA blip colours (approximate RGB) to match each gang's chosen colour against
local PALETTE = {
    { id = 1,  rgb = { 224, 50, 50 } },   -- red
    { id = 2,  rgb = { 114, 204, 114 } }, -- green
    { id = 3,  rgb = { 93, 182, 229 } },  -- light blue
    { id = 5,  rgb = { 238, 198, 78 } },  -- yellow
    { id = 7,  rgb = { 156, 110, 175 } }, -- violet
    { id = 8,  rgb = { 255, 123, 196 } }, -- pink
    { id = 17, rgb = { 236, 140, 50 } },  -- orange
    { id = 25, rgb = { 60, 120, 60 } },   -- dark green
    { id = 27, rgb = { 171, 60, 230 } },  -- purple
    { id = 29, rgb = { 45, 110, 185 } },  -- dark blue
    { id = 38, rgb = { 30, 70, 160 } },   -- navy
    { id = 46, rgb = { 236, 240, 41 } },  -- gold
    { id = 49, rgb = { 150, 40, 40 } },   -- dark red
    { id = 0,  rgb = { 240, 240, 240 } }, -- white
    { id = 40, rgb = { 75, 75, 75 } },    -- dark grey
}
local UNCLAIMED = 39 -- grey

local function nearestColour(hex)
    if type(hex) ~= 'string' or not hex:match('^#%x%x%x%x%x%x$') then return UNCLAIMED end
    local r, g, b = tonumber(hex:sub(2, 3), 16), tonumber(hex:sub(4, 5), 16), tonumber(hex:sub(6, 7), 16)
    local best, bestD
    for _, c in ipairs(PALETTE) do
        -- Weighted distance: the eye is more sensitive to green
        local d = 2 * (r - c.rgb[1]) ^ 2 + 4 * (g - c.rgb[2]) ^ 2 + 3 * (b - c.rgb[3]) ^ 2
        if not bestD or d < bestD then best, bestD = c.id, d end
    end
    return best
end

local function clear()
    for _, b in ipairs(blips) do
        if DoesBlipExist(b) then RemoveBlip(b) end
    end
    blips = {}
end

local function shouldShow()
    if not live().enabled then return false end -- staff turned turf off on the map
    if live().showTo == 'everyone' then return true end
    return GetPlayerGang() ~= nil
end

---The name marker in the middle of an area (shown when hovering on the map and in the legend).
local function addLabel(zone, owner, colour, display)
    local cx, cy = 0, 0
    for _, p in ipairs(zone.points) do cx, cy = cx + p.x, cy + p.y end
    cx, cy = cx / #zone.points, cy / #zone.points
    local label = AddBlipForCoord(cx, cy, 0.0)
    SetBlipSprite(label, 437)
    SetBlipColour(label, colour)
    SetBlipScale(label, 0.7)
    SetBlipDisplay(label, display)
    SetBlipAsShortRange(label, true)
    BeginTextCommandSetBlipName('STRING')
    AddTextComponentSubstringPlayerName(owner and locale('map_area_held', zone.label, owner.label) or locale('map_area_unclaimed', zone.label))
    EndTextCommandSetBlipName(label)
    blips[#blips + 1] = label
end

---Shades every area with ONE grid shared across the whole map: each square goes to the area its centre is in, so
---neighbouring areas meet with no gaps and no double shading. Squares side by side in the same colour are merged
---into one strip (across neighbouring hexes of the same gang too), which keeps the number of map blips down.
local function shade(drawn, display)
    -- Square size: a fifth of a hex (smooth edges), grown if needed to stay inside the blip budget
    local hexSize = Hex and Hex.Enabled and Hex.Enabled() and Hex.Grid().size or nil
    local size = hexSize and math.max(4.0, hexSize / 5) or cfg.cellSize
    local rowsNeeded = function(sz)
        local n = 0
        for _, d in ipairs(drawn) do
            local minY, maxY = math.huge, -math.huge
            for _, p in ipairs(d.zone.points) do minY, maxY = math.min(minY, p.y), math.max(maxY, p.y) end
            n = n + math.ceil((maxY - minY) / sz) + 1
        end
        return n
    end
    local budget = (cfg.maxTotal or 900) - #drawn -- leave room for the name markers
    while rowsNeeded(size) > budget and size < 500 do size = size * 1.25 end

    -- Which colour each grid square gets: cells[row][col] = colour
    local cells = {}
    for _, d in ipairs(drawn) do
        local pts = d.zone.points
        local minX, minY, maxX, maxY = math.huge, math.huge, -math.huge, -math.huge
        for _, p in ipairs(pts) do
            minX, maxX = math.min(minX, p.x), math.max(maxX, p.x)
            minY, maxY = math.min(minY, p.y), math.max(maxY, p.y)
        end
        for row = math.floor(minY / size), math.floor(maxY / size) do
            local y = (row + 0.5) * size
            for col = math.floor(minX / size), math.floor(maxX / size) do
                local x = (col + 0.5) * size
                if Zones.PointInPolygon(pts, x, y) then
                    cells[row] = cells[row] or {}
                    if not cells[row][col] then cells[row][col] = d.colour end
                end
            end
        end
    end

    -- Merge each row into strips of one colour, and draw them
    for row, cols in pairs(cells) do
        local list = {}
        for col in pairs(cols) do list[#list + 1] = col end
        table.sort(list)
        local i = 1
        while i <= #list do
            local first, colour = list[i], cols[list[i]]
            local last = first
            while i < #list and list[i + 1] == last + 1 and cols[list[i + 1]] == colour do
                i = i + 1
                last = list[i]
            end
            local width = (last - first + 1) * size
            local b = AddBlipForArea((first * size) + width / 2, (row + 0.5) * size, 0.0, width, size)
            SetBlipColour(b, colour)
            SetBlipAlpha(b, cfg.alpha or 90)
            SetBlipDisplay(b, display)
            SetBlipAsShortRange(b, true)
            blips[#blips + 1] = b
            i = i + 1
        end
    end
end

local function redraw()
    local owners = ZoneOwners()
    local show = shouldShow()

    -- Build a fingerprint of what we'd draw, and skip the work if nothing changed
    local parts = { tostring(show), tostring(live().minimap), tostring(Hex and Hex.Grid and Hex.Grid().size or '') }
    for key, zone in pairs(Config.Zones) do
        local o = owners[key]
        local p1 = zone.points[1] or {}
        parts[#parts + 1] = ('%s:%d:%.1f:%.1f:%s:%s'):format(key, #zone.points, p1.x or 0, p1.y or 0, o and o.owner or '-', o and o.colour or '-')
    end
    table.sort(parts)
    local fingerprint = table.concat(parts, '|')
    if fingerprint == lastKey then return end
    lastKey = fingerprint

    clear()
    if not show then return end
    local drawn = {}
    for key, zone in pairs(Config.Zones) do
        local o = owners[key]
        local owner = o and o.owner and o or nil
        if owner or cfg.showUnclaimed then
            drawn[#drawn + 1] = { key = key, zone = zone, owner = owner, colour = owner and nearestColour(owner.colour) or UNCLAIMED }
        end
    end
    table.sort(drawn, function(x, y) return x.key < y.key end)
    local display = live().minimap and 2 or 3 -- 3 = main map only
    shade(drawn, display)
    for _, d in ipairs(drawn) do addLabel(d.zone, d.owner, d.colour, display) end
end

-- Redraw when ownership changes, areas are drawn or deleted, or we join or leave a gang
AddEventHandler('vinewood_gangs:client:hexesUpdated', function() SetTimeout(250, redraw) end)
-- Staff changed the map setting in /gangadmin > Turf
AddStateBagChangeHandler('vg_turf_map', 'global', function() SetTimeout(250, redraw) end)
AddEventHandler('vinewood_gangs:client:gangUpdated', function() SetTimeout(250, redraw) end)

CreateThread(function()
    Wait(3000)
    redraw()
end)

AddEventHandler('onResourceStop', function(res)
    if res == GetCurrentResourceName() then clear() end
end)
