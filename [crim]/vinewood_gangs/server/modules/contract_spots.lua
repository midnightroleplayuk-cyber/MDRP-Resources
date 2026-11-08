-- Contract spots added in game. They join the built-in lists in config/contracts.lua straight away.
ContractSpots = {}

local POOLS = { general = true, vehicles = true, debtors = true }
local pools = Config.Contracts.locations

local function round2(n) return math.floor(n * 100 + 0.5) / 100 end

function ContractSpots.Load()
    -- Drop any previously loaded in-game spots (resource restart), then add them from the database
    for pool in pairs(POOLS) do
        for i = #pools[pool], 1, -1 do
            if pools[pool][i].dbId then table.remove(pools[pool], i) end
        end
    end
    for _, r in ipairs(MySQL.query.await('SELECT id, pool, label, x, y, z, w FROM vg_contract_spots')) do
        if POOLS[r.pool] then
            table.insert(pools[r.pool], { label = r.label, x = tonumber(r.x), y = tonumber(r.y), z = tonumber(r.z), w = tonumber(r.w), dbId = r.id })
        end
    end
end

---Adds a spot where the staff member is standing (facing = heading for cars and debtors).
function ContractSpots.Add(src, pool, label)
    if not POOLS[pool] then return false, 'invalid' end
    label = tostring(label or ''):gsub('[<>]', ''):match('^%s*(.-)%s*$'):sub(1, 64)
    if #label < 2 then return false, 'invalid_label' end
    local ped = GetPlayerPed(src)
    local c = GetEntityCoords(ped)
    local spot = { label = label, x = round2(c.x), y = round2(c.y), z = round2(c.z), w = round2(GetEntityHeading(ped)) }
    spot.dbId = MySQL.insert.await('INSERT INTO vg_contract_spots (pool, label, x, y, z, w, created_by) VALUES (?, ?, ?, ?, ?, ?, ?)',
        { pool, spot.label, spot.x, spot.y, spot.z, spot.w, Bridge.GetCitizenId(src) or 'console' })
    if not spot.dbId then return false, 'db_error' end
    table.insert(pools[pool], spot)
    Logger.Log(src, 'staff_contract_spot', ('added %s spot "%s" at %.1f, %.1f'):format(pool, label, spot.x, spot.y))
    return true
end

function ContractSpots.Delete(src, pool, id)
    id = tonumber(id)
    if not POOLS[pool] or not id then return false, 'invalid' end
    for i, spot in ipairs(pools[pool]) do
        if spot.dbId == id then
            table.remove(pools[pool], i)
            MySQL.update.await('DELETE FROM vg_contract_spots WHERE id = ?', { id })
            Logger.Log(src, 'staff_contract_spot_deleted', ('deleted %s spot "%s"'):format(pool, spot.label))
            return true
        end
    end
    return false, 'invalid'
end

function ContractSpots.List()
    local out = {}
    for pool in pairs(POOLS) do
        out[pool] = {}
        for i, spot in ipairs(pools[pool]) do
            local zone = Zones.FromCoords(vector3(spot.x, spot.y, spot.z))
            out[pool][#out[pool] + 1] = {
                index = i, id = spot.dbId, label = spot.label, added = spot.dbId ~= nil,
                area = zone and Zones.Label(zone) or nil, x = spot.x, y = spot.y, z = spot.z, w = spot.w,
            }
        end
    end
    return { spots = out, minRoute = Config.Contracts.minRouteDistance }
end

function ContractSpots.Coords(pool, index)
    local spot = POOLS[pool] and pools[pool][tonumber(index)]
    if not spot then return nil end
    return { x = spot.x, y = spot.y, z = spot.z + 1.0, w = spot.w or 0.0 }
end
