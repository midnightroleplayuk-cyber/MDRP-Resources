Influence = {}

local cache  = {} -- cache[zone][gangId] = influence
local owners = {} -- owners[zone] = gangId | false
local dirty  = {} -- dirty['zone|gangId'] = true

local function key(zone, gangId) return ('%s|%d'):format(zone, gangId) end

function Influence.Load()
    cache, owners = {}, {}
    for _, r in ipairs(MySQL.query.await('SELECT zone, gang_id, influence FROM vg_zone_influence')) do
        if Config.Zones[r.zone] then
            cache[r.zone] = cache[r.zone] or {}
            cache[r.zone][r.gang_id] = tonumber(r.influence)
        end
    end
    for _, s in ipairs(MySQL.query.await('SELECT zone, owner_gang_id FROM vg_zone_state')) do
        owners[s.zone] = s.owner_gang_id or false
    end
    Influence.Publish()
end

function Influence.Add(zone, gangId, amount)
    if not Config.Zones[zone] or not Gangs.Get(gangId) or amount == 0 then return end
    cache[zone] = cache[zone] or {}
    local value = (cache[zone][gangId] or 0) + amount * (Config.Zones[zone].value or 1.0)
    value = math.max(0, math.min(Config.Influence.maxPerZone, value))
    cache[zone][gangId] = value > 0 and value or nil
    dirty[key(zone, gangId)] = true
end

function Influence.Get(zone, gangId)
    return cache[zone] and cache[zone][gangId] or 0
end

function Influence.GetOwner(zone)
    return owners[zone] or nil
end

function Influence.GetZoneBreakdown(zone)
    local list = {}
    for gangId, value in pairs(cache[zone] or {}) do
        list[#list + 1] = { gangId = gangId, influence = Utils.Round(value, 1) }
    end
    table.sort(list, function(a, b) return a.influence > b.influence end)
    return list
end

local function decayScale()
    local p = Config.Influence.population
    local players = #GetPlayers()
    if players <= p.minPlayers then return p.minScale end
    if players >= p.fullAt then return 1.0 end
    return p.minScale + (1.0 - p.minScale) * ((players - p.minPlayers) / (p.fullAt - p.minPlayers))
end

local function resolveOwner(zone)
    local cfg = Config.Influence
    local zoneCache = cache[zone] or {}
    local top, topVal, secondVal = nil, 0, 0

    for gangId, value in pairs(zoneCache) do
        if value > topVal then
            secondVal = topVal
            top, topVal = gangId, value
        elseif value > secondVal then
            secondVal = value
        end
    end

    if top and topVal >= cfg.captureThreshold and (topVal - secondVal) >= cfg.ownershipMargin then
        return top
    end

    local current = owners[zone] or nil
    if current and (zoneCache[current] or 0) >= cfg.holdThreshold then
        return current
    end
    return nil
end

function Influence.Flush()
    if not next(dirty) then return end
    local upserts, deletes = {}, {}
    for k in pairs(dirty) do
        local zone, gangId = k:match('^(.+)|(%d+)$')
        gangId = tonumber(gangId)
        local value = cache[zone] and cache[zone][gangId]
        if value and value > 0 then
            upserts[#upserts + 1] = { zone, gangId, Utils.Round(value, 2) }
        else
            deletes[#deletes + 1] = { zone, gangId }
        end
    end
    dirty = {}

    if #upserts > 0 then
        MySQL.prepare('INSERT INTO vg_zone_influence (zone, gang_id, influence) VALUES (?, ?, ?) ON DUPLICATE KEY UPDATE influence = VALUES(influence)', upserts)
    end
    if #deletes > 0 then
        MySQL.prepare('DELETE FROM vg_zone_influence WHERE zone = ? AND gang_id = ?', deletes)
    end
end

---Replicates zone ownership to every client via a single GlobalState key.
function Influence.Publish()
    local state = {}
    for zone in pairs(Config.Zones) do
        local owner = owners[zone] or nil
        local gang = owner and Gangs.Get(owner)
        state[zone] = { owner = owner, label = gang and gang.label or nil, colour = gang and gang.colour or nil }
    end
    GlobalState.vg_zones = state
end

local function tick()
    local cfg = Config.Influence
    local factor = 1 - (cfg.decayPercentPerHour / 100) * (cfg.tickMinutes / 60) * decayScale()
    local changed = false

    for zone in pairs(Config.Zones) do
        local zoneCache = cache[zone]
        if zoneCache then
            for gangId, value in pairs(zoneCache) do
                local decayed = value * factor
                zoneCache[gangId] = decayed >= cfg.pruneBelow and decayed or nil
                dirty[key(zone, gangId)] = true
            end
        end

        local newOwner = resolveOwner(zone)
        local oldOwner = owners[zone] or nil
        if newOwner ~= oldOwner then
            owners[zone] = newOwner or false
            changed = true
            MySQL.prepare(
                'INSERT INTO vg_zone_state (zone, owner_gang_id, owned_since) VALUES (?, NULLIF(?, 0), NOW()) ON DUPLICATE KEY UPDATE owner_gang_id = VALUES(owner_gang_id), owned_since = NOW()',
                { zone, newOwner or 0 }
            )
            TriggerEvent('vinewood_gangs:server:zoneOwnerChanged', zone, oldOwner, newOwner)
        end
    end

    Influence.Flush()
    if changed then Influence.Publish() end
end

---Clears a disbanded gang from the cache (database rows are removed by Gangs.Disband).
function Influence.RemoveGang(gangId)
    for zone, zoneCache in pairs(cache) do
        zoneCache[gangId] = nil
        dirty[key(zone, gangId)] = nil
    end
    local changed = false
    for zone, owner in pairs(owners) do
        if owner == gangId then
            owners[zone] = false
            changed = true
        end
    end
    if changed then Influence.Publish() end
end

---Forget everything about a deleted area.
function Influence.ClearZone(zone)
    cache[zone] = nil
    owners[zone] = nil
    for k in pairs(dirty) do
        if k:sub(1, #zone + 1) == zone .. '|' then dirty[k] = nil end
    end
    Influence.Publish()
end

Influence.Tick = tick

function Influence.Start()
    CreateThread(function()
        while true do
            Wait(Config.Influence.tickMinutes * 60000)
            tick()
        end
    end)
end

AddEventHandler('onResourceStop', function(res)
    if res == GetCurrentResourceName() then Influence.Flush() end
end)
