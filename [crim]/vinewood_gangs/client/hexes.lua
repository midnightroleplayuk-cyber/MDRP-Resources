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
CreateThread(function() Wait(4000) refresh() end)
