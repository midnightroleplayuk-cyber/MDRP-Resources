local RES = GetCurrentResourceName()
local FILE = 'zones.json'

local zones = {}
local ready = false

local function valid(z)
    return type(z) == 'table' and type(z.points) == 'table' and #z.points >= 3
end

local function encode(z)
    local id = z.id
    z.id = nil
    local s = json.encode(z)
    z.id = id
    return s
end

local function load()
    local existed = (tonumber(MySQL.scalar.await(
        "SELECT COUNT(*) FROM information_schema.tables WHERE table_schema = DATABASE() AND table_name = 'npc_blocker_zones'"
    )) or 0) > 0

    MySQL.query.await('CREATE TABLE IF NOT EXISTS npc_blocker_zones (id INT AUTO_INCREMENT PRIMARY KEY, data LONGTEXT NOT NULL)')

    if not existed then
        local raw = LoadResourceFile(RES, FILE)
        if raw and raw ~= '' then
            local ok, list = pcall(json.decode, raw)
            if ok and type(list) == 'table' then
                for _, z in ipairs(list) do
                    if valid(z) then
                        z.id = nil
                        MySQL.insert.await('INSERT INTO npc_blocker_zones (data) VALUES (?)', { json.encode(z) })
                    end
                end
            end
        end
    end

    for _, r in ipairs(MySQL.query.await('SELECT id, data FROM npc_blocker_zones ORDER BY id')) do
        local ok, z = pcall(json.decode, r.data)
        if ok and valid(z) then
            z.id = r.id
            zones[#zones + 1] = z
        end
    end
    ready = true
end

local function clamp(v, lo, hi, default)
    v = tonumber(v)
    if not v then return default end
    return math.max(lo, math.min(hi, v))
end

local function sanitize(d)
    if type(d) ~= 'table' or type(d.points) ~= 'table' then return nil end

    local pts = {}
    for i, p in ipairs(d.points) do
        if i > 64 then break end
        if type(p) == 'table' and tonumber(p.x) and tonumber(p.y) then
            pts[#pts + 1] = { x = clamp(p.x, -10000, 10000, 0.0), y = clamp(p.y, -10000, 10000, 0.0) }
        end
    end
    if #pts < 3 then return nil end

    return {
        id = tonumber(d.id),
        name = tostring(d.name or 'Zone'):sub(1, 40),
        points = pts,
        z = clamp(d.z, -1000, 3000, 0.0),
        height = clamp(d.height, 1.0, 300, 10.0),
        blockPeds = d.blockPeds == true,
        blockScenarios = d.blockScenarios == true,
        blockVehicles = d.blockVehicles == true,
        clearPeds = d.clearPeds == true,
        clearVehicles = d.clearVehicles == true,
    }
end

local function allowed(src)
    return IsPlayerAceAllowed(src, Config.Ace)
end

local function broadcast()
    TriggerClientEvent('npcblocker:setZones', -1, zones)
end

CreateThread(load)

RegisterNetEvent('npcblocker:requestZones', function()
    local src = source
    while not ready do Wait(100) end
    TriggerClientEvent('npcblocker:setZones', src, zones)
end)

RegisterNetEvent('npcblocker:requestOpen', function()
    local src = source
    if not allowed(src) then
        TriggerClientEvent('npcblocker:notify', src, '~r~You do not have permission to edit NPC zones.')
        return
    end
    TriggerClientEvent('npcblocker:openUI', src, zones)
end)

RegisterNetEvent('npcblocker:saveZone', function(data)
    local src = source
    if not ready or not allowed(src) then return end
    local z = sanitize(data)
    if not z then
        TriggerClientEvent('npcblocker:notify', src, '~r~A zone needs at least 3 pins.')
        return
    end

    local found = false
    if z.id then
        for i, existing in ipairs(zones) do
            if existing.id == z.id then
                MySQL.update.await('UPDATE npc_blocker_zones SET data = ? WHERE id = ?', { encode(z), z.id })
                zones[i] = z
                found = true
                break
            end
        end
    end
    if not found then
        z.id = MySQL.insert.await('INSERT INTO npc_blocker_zones (data) VALUES (?)', { encode(z) })
        zones[#zones + 1] = z
    end

    broadcast()
    TriggerClientEvent('npcblocker:notify', src, ('~g~Saved zone "%s"'):format(z.name))
end)

RegisterNetEvent('npcblocker:deleteZone', function(id)
    local src = source
    if not ready or not allowed(src) then return end
    id = tonumber(id)
    for i, z in ipairs(zones) do
        if z.id == id then
            MySQL.update.await('DELETE FROM npc_blocker_zones WHERE id = ?', { id })
            table.remove(zones, i)
            broadcast()
            TriggerClientEvent('npcblocker:notify', src, '~y~Zone deleted')
            return
        end
    end
end)
