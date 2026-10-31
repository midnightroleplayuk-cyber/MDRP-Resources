local RES = GetCurrentResourceName()
local TABLE = Config.Table

local zones = {}
local ready = false
local saving = false

local function log(msg)
    print(('^1[%s] %s^7'):format(RES, msg))
end

local function encode(z)
    local id = z.id
    z.id = nil
    local s = json.encode(z)
    z.id = id
    return s
end

local function clamp(v, lo, hi, default)
    v = tonumber(v)
    if not v then return default end
    return math.max(lo, math.min(hi, v))
end

-- runs on everything coming in from a client AND everything read back from the database
local function sanitize(d)
    if type(d) ~= 'table' or type(d.points) ~= 'table' then return nil, 'A zone needs at least 3 pins.' end

    local pts = {}
    for i, p in ipairs(d.points) do
        if i > 64 then break end
        if type(p) == 'table' and tonumber(p.x) and tonumber(p.y) then
            pts[#pts + 1] = { x = clamp(p.x, -10000, 10000, 0.0), y = clamp(p.y, -10000, 10000, 0.0) }
        end
    end
    if #pts < 3 then return nil, 'A zone needs at least 3 pins.' end

    local minx, miny, maxx, maxy = math.huge, math.huge, -math.huge, -math.huge
    for _, p in ipairs(pts) do
        minx, maxx = math.min(minx, p.x), math.max(maxx, p.x)
        miny, maxy = math.min(miny, p.y), math.max(maxy, p.y)
    end
    local size = math.max(maxx - minx, maxy - miny)
    if size > 1000 then
        return nil, 'Zone is too large (max 1000 m across). Check for a stray pin.'
    end
    if Config.RoadNodes and d.blockVehicles == true and size > Config.MaxVehicleZoneSize then
        return nil, ('Vehicle-blocking zones can be at most %d m across.'):format(Config.MaxVehicleZoneSize)
    end

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

-- zones with vehicle blocking on, optionally not counting one id (the zone being edited)
local function vehicleZoneCount(except)
    local n = 0
    for _, z in ipairs(zones) do
        if z.blockVehicles and z.id ~= except then n = n + 1 end
    end
    return n
end

local function load()
    MySQL.query.await(('CREATE TABLE IF NOT EXISTS %s (id INT AUTO_INCREMENT PRIMARY KEY, data LONGTEXT NOT NULL)'):format(TABLE))

    local rows = MySQL.query.await(('SELECT id, data FROM %s ORDER BY id'):format(TABLE))
    if not rows then error(('could not read %s, see the oxmysql error above'):format(TABLE)) end

    for _, r in ipairs(rows) do
        local ok, raw = pcall(json.decode, r.data)
        local z = ok and sanitize(raw) or nil
        if not z then
            log(('skipping zone row %s, its data is invalid'):format(tostring(r.id)))
        else
            z.id = r.id
            if Config.RoadNodes and z.blockVehicles and vehicleZoneCount() >= Config.MaxVehicleZones then
                z.blockVehicles = false -- memory only, the row is untouched
                log(('zone %s "%s" is over the vehicle zone limit (%d), its vehicle blocking is off'):format(
                    tostring(z.id), z.name, Config.MaxVehicleZones))
            end
            zones[#zones + 1] = z
        end
    end
    ready = true
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
            print(('^2[%s] loaded %d zone(s) from %s^7'):format(RES, #zones, TABLE))
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

    local z, why = sanitize(data)
    if not z then
        notify(src, '~r~' .. why)
        return
    end

    -- one save at a time, so two admins can't both pass the zone limits before either has been stored
    while saving do Wait(25) end
    saving = true

    local reject
    local ok, err = pcall(function()
        local index
        if z.id then
            for i, existing in ipairs(zones) do
                if existing.id == z.id then index = i break end
            end
        end

        if not index and #zones >= Config.MaxZones then
            reject = ('Zone limit reached (%d). Delete one first.'):format(Config.MaxZones)
            return
        end
        if Config.RoadNodes and z.blockVehicles and vehicleZoneCount(z.id) >= Config.MaxVehicleZones then
            reject = ('Only %d zones can have vehicle blocking on. Turn it off on another zone first.'):format(
                Config.MaxVehicleZones)
            return
        end

        if index then
            local changed = MySQL.update.await(('UPDATE %s SET data = ? WHERE id = ?'):format(TABLE), { encode(z), z.id })
            if changed == nil then error('update failed') end
            zones[index] = z
        else
            local id = MySQL.insert.await(('INSERT INTO %s (data) VALUES (?)'):format(TABLE), { encode(z) })
            if not id then error('insert failed') end
            z.id = id
            zones[#zones + 1] = z
        end
    end)
    saving = false

    if not ok then
        log('could not save zone: ' .. tostring(err))
        notify(src, '~r~Could not save to the database, check the server console.')
        return
    end
    if reject then
        notify(src, '~r~' .. reject)
        return
    end

    TriggerClientEvent('npcblocker:zoneList', src, zones)
    notify(src, ('~g~Saved zone "%s". Run /%s to apply it.'):format(z.name, Config.RefreshCommand))
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
            local changed = MySQL.update.await(('DELETE FROM %s WHERE id = ?'):format(TABLE), { id })
            if changed == nil then
                log('could not delete zone ' .. tostring(id))
                notify(src, '~r~Could not delete from the database, check the server console.')
                return
            end
            table.remove(zones, i)
            TriggerClientEvent('npcblocker:zoneList', src, zones)
            notify(src, ('~y~Zone deleted. Run /%s to apply it.'):format(Config.RefreshCommand))
            return
        end
    end
end)

RegisterCommand(Config.RefreshCommand, function(src)
    if src ~= 0 and not allowed(src) then
        notify(src, '~r~You do not have permission to refresh NPC zones.')
        return
    end
    if not ready then
        if src ~= 0 then notify(src, '~r~Zone database is not loaded, check the server console.') end
        return
    end
    broadcast()
    if src == 0 then
        print(('^2[%s] zones refreshed for all players^7'):format(RES))
    else
        notify(src, '~g~Zones refreshed for all players')
    end
end, false)
