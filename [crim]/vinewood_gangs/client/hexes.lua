-- What this player's game knows about turf. In hex mode the server only ever sends the gang's own hexes and
-- rival hexes the gang has found (fog of war), so nothing else can be seen here, even by poking at the client.

KnownHexes = {}  -- KnownHexes[key] = { key, q, r, label, mine, main, owner = { id, label, colour } }

---Who holds a hex, as far as this player knows: { owner = gangId, label, colour } or nil.
function ZoneOwnerInfo(key)
    local h = key and KnownHexes[key]
    return h and h.owner and { owner = h.owner.id, label = h.owner.label, colour = h.owner.colour } or nil
end

---Every known hex's owner, for the map shading.
function ZoneOwners()
    local out = {}
    for key in pairs(KnownHexes) do out[key] = ZoneOwnerInfo(key) end
    return out
end


local function apply(list)
    KnownHexes = {}
    local defs = {}
    for _, h in ipairs(type(list) == 'table' and list or {}) do
        KnownHexes[h.key] = h
        defs[h.key] = { label = h.label, value = 1.0, points = Hex.Corners(h.q, h.r) }
    end
    Zones.Set(defs)
    TriggerEvent('vinewood_gangs:client:hexesUpdated')
end

-- Areas are the hexes this player knows about
function Zones.FromCoords(coords)
    local key = Hex.Key(Hex.FromCoords(coords.x, coords.y))
    return KnownHexes[key] and key or nil
end
function Zones.Label(key)
    local q, r = Hex.Parse(key)
    return q and Hex.Label(q, r) or 'Unknown'
end

RegisterNetEvent('vinewood_gangs:client:hexes', apply)

local function refresh()
    apply(lib.callback.await('vinewood_gangs:server:hexView', false))
end
AddEventHandler('vinewood_gangs:client:gangUpdated', function() SetTimeout(500, refresh) end)
-- Staff resized the hexes: redraw our turf once the new grid has arrived
AddStateBagChangeHandler('vg_hex_grid', 'global', function() SetTimeout(750, refresh) end)
CreateThread(function() Wait(4000) refresh() end)

-------------------------------------------------------------------------------
-- Turf banner: a bar at the top of the screen for as long as you're on turf (the server says what it shows)
-------------------------------------------------------------------------------

local turfBanner = nil -- { own, label, main } or { rival, gang, colour } or nil on free ground

RegisterNetEvent('vinewood_gangs:client:turfBanner', function(info) turfBanner = info end)

local function hexToRgb(hex)
    hex = tostring(hex or ''):gsub('#', '')
    if #hex ~= 6 then return nil end
    return tonumber(hex:sub(1, 2), 16), tonumber(hex:sub(3, 4), 16), tonumber(hex:sub(5, 6), 16)
end

local function drawText(text, x, y, scale, r, g, b, a)
    SetTextFont(4)
    SetTextScale(0.0, scale)
    SetTextColour(r, g, b, a)
    SetTextCentre(true)
    SetTextOutline()
    BeginTextCommandDisplayText('STRING')
    AddTextComponentSubstringPlayerName(text)
    EndTextCommandDisplayText(x, y)
end

CreateThread(function()
    while true do
        if turfBanner and not IsPauseMenuActive() and not IsHudHidden() then
            local title, sub, r, g, b
            if turfBanner.own then
                title = turfBanner.main and locale('turf_banner_own_main') or locale('turf_banner_own')
                sub, r, g, b = turfBanner.label, 95, 191, 122
            elseif turfBanner.gang then
                title, sub = locale('turf_banner_known', tostring(turfBanner.gang):upper()), locale('turf_banner_careful')
                r, g, b = hexToRgb(turfBanner.colour)
                r, g, b = r or 232, g or 72, b or 77
            else
                title, sub, r, g, b = locale('turf_banner_rival'), locale('turf_banner_careful'), 232, 72, 77
            end
            DrawRect(0.5, 0.034, 0.17, 0.046, 12, 14, 18, 170)
            DrawRect(0.5, 0.0115, 0.17, 0.003, r, g, b, 230) -- a stripe in the turf's colour
            drawText(title, 0.5, 0.0145, 0.36, r, g, b, 255)
            drawText(sub, 0.5, 0.0335, 0.30, 225, 228, 232, 230)
            Wait(0)
        else
            Wait(500)
        end
    end
end)
