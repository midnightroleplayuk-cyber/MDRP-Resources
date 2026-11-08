Director = {}

local cfg = Config.Director
local events = {}       -- active events by id
local nextId = 0
local lastStarted = {}  -- lastStarted[kind] = os.time()
local activity = {}     -- activity[zone] = { [timestamp] = influence } recent positive activity
local nextEventAt = 0

local function now() return os.time() end
local function v3(p) return vector3(p.x, p.y, p.z) end

-------------------------------------------------------------------------------
-- Modifiers read by the rest of the script
-------------------------------------------------------------------------------

---Multiplier for a kind of value. Returns 1.0 when nothing applies.
---kinds: supplyCost(type), price(type), heatZone(zone), heatGang(gangId), witnessZone(zone), contractReward()
function Director.Mult(kind, key)
    local m = 1.0
    for _, e in pairs(events) do
        local k = cfg.kinds[e.kind]
        if kind == 'supplyCost' and e.kind == 'shortage' and e.type == key then m = m * k.costMult
        elseif kind == 'price' and (e.kind == 'boom' or e.kind == 'crash') and e.type == key then m = m * k.priceMult
        elseif kind == 'heatZone' and e.kind == 'crackdown' and key and e.zone == key then m = m * k.heatMult
        elseif kind == 'witnessZone' and e.kind == 'crackdown' and key and e.zone == key then m = m * k.witnessMult
        elseif kind == 'heatGang' and e.kind == 'undercover' and e.gangId == key then m = m * k.heatMult
        elseif kind == 'contractReward' and e.kind == 'hotwork' then m = m * k.rewardMult
        end
    end
    return m
end

---Called by Activity.Record for every action with influence.
function Director.OnActivity(zone, gangId, influence)
    if not zone or not influence or influence <= 0 then return end
    activity[zone] = activity[zone] or {}
    table.insert(activity[zone], { at = now(), amount = influence })

    for _, e in pairs(events) do
        if e.kind == 'crew' and e.zone == zone and gangId then
            e.strength = e.strength - influence
            e.contributions[gangId] = (e.contributions[gangId] or 0) + influence
            if e.strength <= 0 then Director.End(e.id, 'resolved') end
        end
    end
end

local function recentActivity(zone, seconds)
    local total, cutoff = 0, now() - seconds
    local list = activity[zone] or {}
    for i = #list, 1, -1 do
        if list[i].at < cutoff then table.remove(list, i) else total = total + list[i].amount end
    end
    return total
end

-------------------------------------------------------------------------------
-- Announcements
-------------------------------------------------------------------------------

local function announce(key, ...)
    local msg = locale(key, ...)
    for gangId in pairs(Gangs.All()) do Gangs.NotifyGang(gangId, msg, 'inform') end
end

local function onlineGangMembers()
    local out = {}
    for gangId in pairs(Gangs.All()) do
        for _, m in ipairs(Gangs.GetMembers(gangId)) do
            local src = m.online and Bridge.GetSourceFromCitizenId(m.citizenid)
            if src then out[#out + 1] = src end
        end
    end
    return out
end

local function onlineGangCount()
    local n = 0
    for gangId in pairs(Gangs.All()) do if Gangs.HasOnlineMember(gangId) then n = n + 1 end end
    return n
end

-------------------------------------------------------------------------------
-- Starting events
-------------------------------------------------------------------------------

local function enterpriseTypes()
    local list = {}
    for key in pairs(Config.Enterprises and Config.Enterprises.types or {}) do list[#list + 1] = key end
    table.sort(list)
    return list
end

local function zoneKeys()
    local list = {}
    for key in pairs(Config.Zones) do list[#list + 1] = key end
    table.sort(list)
    return list
end

local function busy(kind, field, value)
    for _, e in pairs(events) do
        if e.kind == kind and (not field or e[field] == value) then return true end
    end
    return false
end

local starters = {}

function starters.shortage(e)
    local types = enterpriseTypes()
    if #types == 0 then return false end
    e.type = types[math.random(#types)]
    if busy('shortage', 'type', e.type) then return false end
    local t = Config.Enterprises.types[e.type]
    e.public = locale('news_shortage', t.supplies)
    return true
end

local function priceEvent(e, key)
    local types = enterpriseTypes()
    if #types == 0 then return false end
    e.type = types[math.random(#types)]
    if busy('boom', 'type', e.type) or busy('crash', 'type', e.type) then return false end
    e.public = locale(key, Config.Enterprises.types[e.type].product)
    return true
end
function starters.boom(e) return priceEvent(e, 'news_boom') end
function starters.crash(e) return priceEvent(e, 'news_crash') end

function starters.crackdown(e)
    local best, bestScore
    for _, zone in ipairs(zoneKeys()) do
        local score = recentActivity(zone, 7200)
        if not busy('crackdown', 'zone', zone) and (not bestScore or score > bestScore) then best, bestScore = zone, score end
    end
    if not best then return false end
    e.zone = best
    e.public = locale('news_crackdown', Zones.Label(best))
    return true
end

function starters.crew(e)
    -- The quietest area someone holds; failing that, any quiet area
    local best, bestScore, bestOwned
    for _, zone in ipairs(zoneKeys()) do
        if not busy('crew', 'zone', zone) then
            local owned = Influence.GetOwner(zone) ~= nil
            local score = recentActivity(zone, 7200)
            if not best or (owned and not bestOwned) or (owned == bestOwned and score < bestScore) then
                best, bestScore, bestOwned = zone, score, owned
            end
        end
    end
    if not best then return false end
    local k = cfg.kinds.crew
    e.zone, e.strength, e.startStrength, e.contributions, e.lastPressure = best, k.strength, k.strength, {}, now()
    e.public = locale('news_crew', Zones.Label(best))
    return true
end

function starters.drop(e)
    local pool = Config.Contracts.locations.general
    local spot = pool[math.random(#pool)]
    local k = cfg.kinds.drop
    e.plate = ('DRP%05d'):format(e.id % 100000)
    local veh, netId = JobVehicles.Spawn(k.vans[math.random(#k.vans)], spot, e.plate)
    if not veh then return false end
    e.vehicle, e.netId, e.spot = veh, netId, spot
    e.value = math.random(k.value[1], k.value[2])
    local zone = Zones.FromCoords(v3(spot))
    local where = zone and Zones.Label(zone) or spot.label
    e.public = locale('news_drop', where)
    for _, src in ipairs(onlineGangMembers()) do
        TriggerClientEvent('vinewood_gangs:client:directorDrop', src, e.netId, where, k.minutes * 60)
    end
    return true
end

function starters.undercover(e)
    local k = cfg.kinds.undercover
    local best
    for id, g in pairs(Gangs.All()) do
        if g.heat >= k.minHeat and not busy('undercover', 'gangId', id) and (not best or g.heat > Gangs.Get(best).heat) then best = id end
    end
    if not best then return false end
    e.gangId = best
    e.public = locale('news_undercover')
    return true
end

function starters.hotwork(e)
    if busy('hotwork') or not Config.Modules.contracts then return false end
    e.public = locale('news_hotwork')
    return true
end

---Starts an event of a given kind now. Returns the event, or nil if nothing suitable.
function Director.Trigger(kind)
    local k = cfg.kinds[kind]
    if not k or not starters[kind] then return nil end
    nextId = nextId + 1
    local e = { id = nextId, kind = kind, startedAt = now(), endsAt = now() + k.minutes * 60 }
    if not starters[kind](e) then return nil end
    events[e.id] = e
    lastStarted[kind] = now()
    if e.public then announce('news_prefix', e.public) end
    Logger.Log(0, 'director_event', ('%s started (%s)'):format(kind, e.zone or e.type or e.gangId or ''))
    return e
end

local function pickKind()
    local quiet = onlineGangCount() <= 1
    local pool, total = {}, 0
    for kind, k in pairs(cfg.kinds) do
        local cooled = not lastStarted[kind] or now() - lastStarted[kind] >= k.cooldown * 60
        if cooled then
            local w = k.weight * ((quiet and cfg.quietBoost[kind]) or 1.0)
            if w > 0 then
                pool[#pool + 1] = { kind = kind, w = w }
                total = total + w
            end
        end
    end
    if total <= 0 then return nil end
    local roll = math.random() * total
    for _, p in ipairs(pool) do
        roll = roll - p.w
        if roll <= 0 then return p.kind end
    end
    return pool[#pool].kind
end

-------------------------------------------------------------------------------
-- Ending events
-------------------------------------------------------------------------------

local enders = {}

function enders.crew(e, reason)
    local k = cfg.kinds.crew
    if reason == 'resolved' then
        local top, topAmount
        for gangId, amount in pairs(e.contributions) do
            if Gangs.Get(gangId) and (not topAmount or amount > topAmount) then top, topAmount = gangId, amount end
        end
        if top then
            Ledger.Transact(top, 'dirty', k.bounty, 'crew_bounty', { note = Zones.Label(e.zone) })
            Gangs.AddReputation(top, k.reputation)
            announce('news_crew_beaten', Gangs.Get(top).label, Zones.Label(e.zone))
        end
    else
        local owner = Influence.GetOwner(e.zone)
        if owner then Influence.Add(e.zone, owner, -k.lossOnFail / (Config.Zones[e.zone] and Config.Zones[e.zone].value or 1.0)) end
        if Rackets and Rackets.WipeOwedInZone then Rackets.WipeOwedInZone(e.zone) end
        announce('news_crew_won', Zones.Label(e.zone))
    end
end

function enders.drop(e, reason, winner)
    if e.vehicle and DoesEntityExist(e.vehicle) then DeleteEntity(e.vehicle) end
    if reason == 'claimed' and winner then
        announce('news_drop_claimed', Gangs.Get(winner).label)
    else
        announce('news_drop_gone')
    end
end

function enders.undercover(e)
    if Gangs.Get(e.gangId) then
        Intel.CreateLead({ gangId = e.gangId, source = 'surveillance', precision = 'exact' })
    end
end

function Director.End(id, reason, extra)
    local e = events[id]
    if not e then return false end
    events[id] = nil
    if enders[e.kind] then enders[e.kind](e, reason or 'expired', extra) end
    Logger.Log(0, 'director_event_end', ('%s ended (%s)'):format(e.kind, reason or 'expired'))
    return true
end

-------------------------------------------------------------------------------
-- Lost shipment: first gang to get the van to their safehouse wins
-------------------------------------------------------------------------------

function Director.DropUnload(src, plateNumber)
    local e
    for _, x in pairs(events) do
        if x.kind == 'drop' and x.plate and tonumber(x.plate:sub(4)) == tonumber(plateNumber) then e = x end
    end
    if not e or not DoesEntityExist(e.vehicle) then return false, 'tag_gone' end
    local gang, _, cid = Gangs.GetPlayerGang(src)
    if not gang then return false, 'not_in_gang' end
    local vpos = GetEntityCoords(e.vehicle)
    if #(GetEntityCoords(GetPlayerPed(src)) - vpos) > 8.0 then return false, 'too_far' end

    for _, h in ipairs(Safehouses.OwnedBy(gang.id)) do
        if #(vpos - v3(h.entrance)) <= 15.0 then
            local elapsed = math.max(1, now() - e.startedAt)
            if #(v3(e.spot) - v3(h.entrance)) / elapsed > Config.Contracts.maxSpeed then return false, 'too_fast' end
            Ledger.Transact(gang.id, 'dirty', e.value, 'lost_shipment', { citizenid = cid })
            Heat.Add(gang.id, cid, 3, Zones.FromCoords(vpos))
            Director.End(e.id, 'claimed', gang.id)
            return true, e.value
        end
    end
    return false, 'supply_wrong_place'
end

-------------------------------------------------------------------------------
-- Views
-------------------------------------------------------------------------------

function Director.PublicFeed()
    local out = {}
    for _, e in pairs(events) do
        local item = { kind = e.kind, text = e.public, minutesLeft = math.max(1, math.ceil((e.endsAt - now()) / 60)) }
        if e.kind == 'crew' then item.progress = math.max(0, math.floor(100 - (e.strength / e.startStrength) * 100)) end
        out[#out + 1] = item
    end
    table.sort(out, function(a, b) return a.minutesLeft < b.minutesLeft end)
    return out
end

function Director.AdminView()
    local out = {}
    for _, e in pairs(events) do
        local g = e.gangId and Gangs.Get(e.gangId)
        out[#out + 1] = {
            id = e.id, kind = e.kind, public = e.public, minutesLeft = math.max(0, math.ceil((e.endsAt - now()) / 60)),
            zone = e.zone and Zones.Label(e.zone) or nil, type = e.type, gang = g and g.label or nil,
            strength = e.strength and math.max(0, math.floor(e.strength)) or nil, value = e.value,
        }
    end
    table.sort(out, function(a, b) return a.id < b.id end)
    local kinds = {}
    for kind in pairs(cfg.kinds) do kinds[#kinds + 1] = kind end
    table.sort(kinds)
    return { events = out, kinds = kinds, nextIn = math.max(0, math.ceil((nextEventAt - now()) / 60)), enabled = Config.Modules.director }
end

-------------------------------------------------------------------------------
-- Loop
-------------------------------------------------------------------------------

local function schedule()
    local lo, hi = cfg.intervalMinutes[1], cfg.intervalMinutes[2]
    nextEventAt = now() + math.random(lo, hi) * 60
end

local function tick()
    local t = now()
    for id, e in pairs(events) do
        if t >= e.endsAt then
            Director.End(id, 'expired')
        elseif e.kind == 'crew' and t - e.lastPressure >= (cfg.kinds.crew.every or 10) * 60 then
            -- The crew squeezes everyone with influence in the area
            e.lastPressure = t
            for _, row in ipairs(Influence.GetZoneBreakdown(e.zone)) do
                Influence.Add(e.zone, row.gangId, -cfg.kinds.crew.pressure)
            end
        elseif e.kind == 'drop' and JobVehicles.Gone(e.vehicle) then
            Director.End(id, 'destroyed')
        end
    end

    if t >= nextEventAt then
        schedule()
        local count = 0
        for _ in pairs(events) do count = count + 1 end
        if count < cfg.maxActive and #GetPlayers() >= cfg.minPlayers then
            for _ = 1, 5 do
                local kind = pickKind()
                if not kind or Director.Trigger(kind) then break end
            end
        end
    end
end

function Director.Start()
    if not Config.Modules.director then return end
    schedule()
    CreateThread(function()
        while true do
            Wait(30000)
            tick()
        end
    end)
end

AddEventHandler('onResourceStop', function(res)
    if res ~= GetCurrentResourceName() then return end
    for _, e in pairs(events) do
        if e.vehicle and DoesEntityExist(e.vehicle) then DeleteEntity(e.vehicle) end
    end
end)
