-- Areas on the in-game map, filled in the owning gang's colour.
-- GTA can only draw rectangles on the map, so each area is filled with small squares that follow its outline.

local cfg = Config.Territory.map
if not cfg.enabled then return end

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
    if cfg.showTo == 'everyone' then return true end
    return GetPlayerGang() ~= nil
end

local function drawArea(key, zone, owner, budget)
    local colour = owner and nearestColour(owner.colour) or UNCLAIMED
    local pts = zone.points

    local minX, minY, maxX, maxY = math.huge, math.huge, -math.huge, -math.huge
    local cx, cy = 0, 0
    for _, p in ipairs(pts) do
        minX, maxX = math.min(minX, p.x), math.max(maxX, p.x)
        minY, maxY = math.min(minY, p.y), math.max(maxY, p.y)
        cx, cy = cx + p.x, cy + p.y
    end
    cx, cy = cx / #pts, cy / #pts

    -- Grow the squares for big areas so we never place too many
    local area = (maxX - minX) * (maxY - minY)
    local size = math.max(cfg.cellSize, math.sqrt(area / (budget * 0.85))) -- headroom: a grid over a shape overshoots a little

    local display = cfg.minimap and 2 or 3 -- 3 = main map only
    for x = minX + size / 2, maxX, size do
        for y = minY + size / 2, maxY, size do
            if Zones.PointInPolygon(pts, x, y) then
                local b = AddBlipForArea(x, y, 0.0, size, size)
                SetBlipColour(b, colour)
                SetBlipAlpha(b, cfg.alpha)
                SetBlipDisplay(b, display)
                SetBlipAsShortRange(b, true)
                blips[#blips + 1] = b
            end
        end
    end

    -- A marker in the middle carries the name, shown when hovering on the map and in the legend
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

local function redraw()
    local owners = GlobalState.vg_zones or {}
    local show = shouldShow()

    -- Build a fingerprint of what we'd draw, and skip the work if nothing changed
    local parts = { tostring(show) }
    for key, zone in pairs(Config.Zones) do
        local o = owners[key]
        parts[#parts + 1] = ('%s:%d:%s:%s'):format(key, #zone.points, o and o.owner or '-', o and o.colour or '-')
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
        if owner or cfg.showUnclaimed then drawn[#drawn + 1] = { key = key, zone = zone, owner = owner } end
    end
    -- Share the marker budget between areas (one marker each goes on the name)
    local budget = math.max(4, math.min(cfg.maxCells, math.floor(cfg.maxTotal / math.max(1, #drawn)) - 1))
    for _, d in ipairs(drawn) do drawArea(d.key, d.zone, d.owner, budget) end
end

-- Redraw when ownership changes, areas are drawn or deleted, or we join or leave a gang
AddStateBagChangeHandler('vg_zones', 'global', function() SetTimeout(250, redraw) end)
AddStateBagChangeHandler('vg_zone_defs', 'global', function() SetTimeout(500, redraw) end)
AddEventHandler('vinewood_gangs:client:gangUpdated', function() SetTimeout(250, redraw) end)

CreateThread(function()
    Wait(3000)
    redraw()
end)

AddEventHandler('onResourceStop', function(res)
    if res == GetCurrentResourceName() then clear() end
end)
