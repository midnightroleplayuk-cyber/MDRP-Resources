-- What this player's game knows about turf. In hex mode the server only ever sends the gang's own hexes and
-- rival hexes the gang has found (fog of war), so nothing else can be seen here, even by poking at the client.

KnownHexes = {}  -- KnownHexes[key] = { key, q, r, label, mine, main, owner = { id, label, colour } }

---Who holds an area or hex, as far as this player knows: { owner = gangId, label, colour } or nil.
function ZoneOwnerInfo(key)
    if not key then return nil end
    if Hex.Enabled() then
        local h = KnownHexes[key]
        return h and h.owner and { owner = h.owner.id, label = h.owner.label, colour = h.owner.colour } or nil
    end
    return GlobalState.vg_zones and GlobalState.vg_zones[key] or nil
end

---Every known area's owner, for the map shading.
function ZoneOwners()
    if not Hex.Enabled() then return GlobalState.vg_zones or {} end
    local out = {}
    for key in pairs(KnownHexes) do out[key] = ZoneOwnerInfo(key) end
    return out
end

if not Hex.Enabled() then return end

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
local plainLabel = Zones.Label
function Zones.Label(key)
    local q, r = Hex.Parse(key)
    if q then return Hex.Label(q, r) end
    return plainLabel(key)
end

RegisterNetEvent('vinewood_gangs:client:hexes', apply)

local function refresh()
    apply(lib.callback.await('vinewood_gangs:server:hexView', false))
end
AddEventHandler('vinewood_gangs:client:gangUpdated', function() SetTimeout(500, refresh) end)
CreateThread(function() Wait(4000) refresh() end)
