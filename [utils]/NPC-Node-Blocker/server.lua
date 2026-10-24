local RES = GetCurrentResourceName()
local FILE = 'zones.json'

local zones = {}
local nextId = 1

local function persist()
    SaveResourceFile(RES, FILE, json.encode(zones), -1)
end

local function load()
    local raw = LoadResourceFile(RES, FILE)
    if raw and raw ~= '' then
        local ok, data = pcall(json.decode, raw)
        if ok and type(data) == 'table' then zones = data end
    end
    local kept = {}
    for _, z in ipairs(zones) do
        if type(z.points) == 'table' and #z.points >= 3 then kept[#kept + 1] = z end
    end
    zones = kept
    for _, z in ipairs(zones) do
        if z.id and z.id >= nextId then nextId = z.id + 1 end
    end
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
    TriggerClientEvent('npcblocker:setZones', source, zones)
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
    if not allowed(src) then return end
    local z = sanitize(data)
    if not z then
        TriggerClientEvent('npcblocker:notify', src, '~r~A zone needs at least 3 pins.')
        return
    end

    local found = false
    if z.id then
        for i, existing in ipairs(zones) do
            if existing.id == z.id then
                zones[i] = z
                found = true
                break
            end
        end
    end
    if not found then
        z.id = nextId
        nextId = nextId + 1
        zones[#zones + 1] = z
    end

    persist()
    broadcast()
    TriggerClientEvent('npcblocker:notify', src, ('~g~Saved zone "%s"'):format(z.name))
end)

RegisterNetEvent('npcblocker:deleteZone', function(id)
    local src = source
    if not allowed(src) then return end
    id = tonumber(id)
    for i, z in ipairs(zones) do
        if z.id == id then
            table.remove(zones, i)
            persist()
            broadcast()
            TriggerClientEvent('npcblocker:notify', src, '~y~Zone deleted')
            return
        end
    end
end)
