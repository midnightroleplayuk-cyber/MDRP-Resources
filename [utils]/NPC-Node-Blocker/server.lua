local RES = GetCurrentResourceName()
local FILE = 'zones.json'

local zones = {}
local ready = false

local function log(msg)
    print(('^1[%s] %s^7'):format(RES, msg))
end

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
    local count = MySQL.scalar.await(
        "SELECT COUNT(*) FROM information_schema.tables WHERE table_schema = DATABASE() AND table_name = 'npc_blocker_zones'"
    )
    local existed = (tonumber(count) or 0) > 0

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

    local rows = MySQL.query.await('SELECT id, data FROM npc_blocker_zones ORDER BY id')
    if not rows then error('could not read npc_blocker_zones, see the oxmysql error above') end

    for _, r in ipairs(rows) do
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

local function notify(src, msg)
    TriggerClientEvent('npcblocker:notify', src, msg)
end

MySQL.ready(function()
    CreateThread(function()
        local ok, err = pcall(load)
        if ok then
            print(('^2[%s] loaded %d zone(s) from the database^7'):format(RES, #zones))
        else
            log('could not load zones: ' .. tostring(err))
        end
    end)
end)

RegisterNetEvent('npcblocker:requestZones', function()
    local src = source
    while not ready do Wait(100) end
    TriggerClientEvent('npcblocker:setZones', src, zones)
end)

RegisterNetEvent('npcblocker:requestOpen', function()
    local src = source
    if not allowed(src) then
        notify(src, '~r~You do not have permission to edit NPC zones.')
        return
    end
    TriggerClientEvent('npcblocker:openUI', src, zones)
end)

RegisterNetEvent('npcblocker:saveZone', function(data)
    local src = source
    if not allowed(src) then return end
    if not ready then
        notify(src, '~r~Zone database is not loaded, check the server console.')
        return
    end

    local z = sanitize(data)
    if not z then
        notify(src, '~r~A zone needs at least 3 pins.')
        return
    end

    local ok, err = pcall(function()
        local index
        if z.id then
            for i, existing in ipairs(zones) do
                if existing.id == z.id then index = i break end
            end
        end

        if index then
            local changed = MySQL.update.await('UPDATE npc_blocker_zones SET data = ? WHERE id = ?', { encode(z), z.id })
            if changed == nil then error('update failed') end
            zones[index] = z
        else
            local id = MySQL.insert.await('INSERT INTO npc_blocker_zones (data) VALUES (?)', { encode(z) })
            if not id then error('insert failed') end
            z.id = id
            zones[#zones + 1] = z
        end
    end)

    if not ok then
        log('could not save zone: ' .. tostring(err))
        notify(src, '~r~Could not save to the database, check the server console.')
        return
    end

    broadcast()
    notify(src, ('~g~Saved zone "%s"'):format(z.name))
end)

RegisterNetEvent('npcblocker:deleteZone', function(id)
    local src = source
    if not allowed(src) then return end
    if not ready then
        notify(src, '~r~Zone database is not loaded, check the server console.')
        return
    end

    id = tonumber(id)
    for i, z in ipairs(zones) do
        if z.id == id then
            local changed = MySQL.update.await('DELETE FROM npc_blocker_zones WHERE id = ?', { id })
            if changed == nil then
                log('could not delete zone ' .. tostring(id))
                notify(src, '~r~Could not delete from the database, check the server console.')
                return
            end
            table.remove(zones, i)
            broadcast()
            notify(src, '~y~Zone deleted')
            return
        end
    end
end)
