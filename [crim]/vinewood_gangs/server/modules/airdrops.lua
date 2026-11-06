-- Air drops: gang management call one in on the tablet; a plane drops a crate; whoever opens it gets the loot.
Airdrops = {}

local cfg = Config.Airdrops
local drops = {}       -- drops[id] = { id, gangId, x, y, cx, cy, arriveAt, landAt, state, lock, ... }
local gangNext = {}    -- gangNext[gangId] = os.time() the gang can call again
local lastDrop = 0
local nextId = 0

local FALL_TIME = 40   -- seconds from the plane passing over to the crate landing (roughly, on every client)

local function now() return os.time() end

local function publicView(d)
    return { id = d.id, gangId = d.gangId, x = d.x, y = d.y, cx = d.cx, cy = d.cy, radius = cfg.radius,
        state = d.state, landsIn = math.max(0, d.landAt - now()), plane = cfg.plane, crate = cfg.crate }
end

---Who should see this drop's blip.
local function audience(d)
    if cfg.showTo == 'everyone' then return -1 end
    local out = {}
    if cfg.showTo == 'caller' then
        for _, m in ipairs(Gangs.OnlineMembers(d.gangId)) do out[#out + 1] = m.source end
    else -- 'gangs'
        for _, src in ipairs(GetPlayers()) do
            src = tonumber(src)
            if Gangs.GetPlayerGang(src) then out[#out + 1] = src end
        end
    end
    return out
end

local function broadcast(event, d)
    local to = audience(d)
    if to == -1 then TriggerClientEvent(event, -1, publicView(d)) return end
    for _, src in ipairs(to) do TriggerClientEvent(event, src, publicView(d)) end
end

local function activeCount()
    local n = 0
    for _, d in pairs(drops) do if d.state ~= 'gone' then n = n + 1 end end
    return n
end

local function remove(d, why)
    d.state = 'gone'
    drops[d.id] = nil
    TriggerClientEvent('vinewood_gangs:client:airdropGone', -1, d.id, why)
end

-------------------------------------------------------------------------------
-- Tablet
-------------------------------------------------------------------------------

function Airdrops.View(src)
    if not cfg.enabled then return nil, 'invalid' end
    local gang, _, cid = Gangs.GetPlayerGang(src)
    if not gang then return nil, 'not_in_gang' end
    local mine
    for _, d in pairs(drops) do if d.gangId == gang.id then mine = d end end
    local wait = math.max((gangNext[gang.id] or 0) - now(), lastDrop + cfg.globalGap * 60 - now())
    return {
        canCall = Gangs.HasPermission(cid, 'airdrops'), cost = cfg.cost, account = cfg.account,
        item = cfg.item and { item = cfg.item.item, label = Bridge.ItemLabel(cfg.item.item), count = cfg.item.count } or nil,
        balance = Ledger.GetBalance(gang.id, cfg.account), waitFor = math.max(0, wait),
        busy = activeCount() >= cfg.maxActive and not mine, cooldownMins = cfg.cooldown,
        active = mine and { state = mine.state, x = mine.x, y = mine.y, arrivesIn = math.max(0, mine.arriveAt - now()), landsIn = math.max(0, mine.landAt - now()) } or nil,
        bounds = cfg.bounds,
    }
end

function Airdrops.Request(src, x, y)
    if not cfg.enabled then return false, 'invalid' end
    local gang, _, cid = Gangs.GetPlayerGang(src)
    if not gang then return false, 'not_in_gang' end
    if not Gangs.HasPermission(cid, 'airdrops') then return false, 'no_permission' end
    x, y = tonumber(x), tonumber(y)
    local b = cfg.bounds
    if not x or not y or x < b.minX or x > b.maxX or y < b.minY or y > b.maxY then return false, 'airdrop_bad_spot' end
    for _, d in pairs(drops) do if d.gangId == gang.id then return false, 'airdrop_already' end end
    if activeCount() >= cfg.maxActive then return false, 'airdrop_sky_busy' end
    if (gangNext[gang.id] or 0) > now() then return false, 'airdrop_cooldown' end
    if lastDrop + cfg.globalGap * 60 > now() then return false, 'airdrop_sky_busy' end
    if cfg.item and not Bridge.HasItem(src, cfg.item.item, cfg.item.count or 1) then return false, 'heist_need_item', Bridge.ItemLabel(cfg.item.item) end

    if cfg.cost > 0 and not Ledger.Transact(gang.id, cfg.account, -cfg.cost, 'airdrop', { citizenid = cid }) then
        return false, 'insufficient_funds'
    end
    if cfg.item then Bridge.RemoveItem(src, cfg.item.item, cfg.item.count or 1) end

    nextId = nextId + 1
    local t = now()
    local delay = math.random(cfg.delay[1] * 60, cfg.delay[2] * 60)
    -- The search circle is centred near, not on, the crate
    local a, r = math.random() * math.pi * 2, math.random() * cfg.radius * 0.6
    local d = { id = nextId, gangId = gang.id, x = x, y = y, cx = x + math.cos(a) * r, cy = y + math.sin(a) * r,
        arriveAt = t + delay, landAt = t + delay + FALL_TIME, state = 'called', calledBy = cid }
    drops[d.id] = d
    gangNext[gang.id] = t + cfg.cooldown * 60
    lastDrop = t
    Gangs.NotifyGang(gang.id, locale('airdrop_called', math.ceil(delay / 60)), 'inform')
    Logger.Log(src, 'airdrop_called', ('%s called a drop for gang %d at %.0f, %.0f'):format(cid, gang.id, x, y))
    return true, { arrivesIn = delay }
end

-------------------------------------------------------------------------------
-- Opening the crate
-------------------------------------------------------------------------------

local function near2D(src, d, range)
    local p = GetEntityCoords(GetPlayerPed(src))
    return math.sqrt((p.x - d.x) ^ 2 + (p.y - d.y) ^ 2) <= range
end

function Airdrops.BeginOpen(src, id)
    local d = drops[tonumber(id)]
    if not d or d.state ~= 'landed' then return false, 'airdrop_not_here' end
    if not near2D(src, d, 4.0) then return false, 'too_far' end
    if d.lock and d.lock.src ~= src and GetGameTimer() - d.lock.at < (cfg.openTime + 5) * 1000 then return false, 'airdrop_someone_opening' end
    d.lock = { src = src, at = GetGameTimer() }
    return true, cfg.openTime
end

local function rollLoot()
    local total = 0
    for _, l in ipairs(cfg.loot) do total = total + (l.chance or 1) end
    local picks = {}
    for _ = 1, cfg.rolls do
        local r, acc = math.random() * total, 0
        for _, l in ipairs(cfg.loot) do
            acc = acc + (l.chance or 1)
            if r <= acc then picks[#picks + 1] = l break end
        end
    end
    return picks
end

function Airdrops.Open(src, id)
    local d = drops[tonumber(id)]
    if not d or d.state ~= 'landed' then return false, 'airdrop_not_here' end
    if not d.lock or d.lock.src ~= src then return false, 'invalid' end
    if (GetGameTimer() - d.lock.at) / 1000 < cfg.openTime * 0.85 then return false, 'invalid' end
    if not near2D(src, d, 5.0) then return false, 'too_far' end

    d.state = 'opened'
    local gang, _, cid = Gangs.GetPlayerGang(src)
    local got = {}
    for _, l in ipairs(rollLoot()) do
        local amount = math.random(l.min or 1, math.max(l.min or 1, l.max or l.min or 1))
        if l.money then
            if gang then Ledger.Transact(gang.id, 'dirty', amount, 'airdrop_loot', { citizenid = cid })
            else Bridge.AddMoney(src, 'cash', amount, 'airdrop') end
            got[#got + 1] = { money = amount }
        elseif Bridge.AddItem(src, l.item, amount) then
            got[#got + 1] = { item = Bridge.ItemLabel(l.item), count = amount }
        end
    end
    if d.gangId and gang and gang.id ~= d.gangId then
        Gangs.NotifyGang(d.gangId, locale('airdrop_stolen', gang.label), 'error')
    end
    Logger.Log(src, 'airdrop_opened', ('%s opened drop %d (called by %s)'):format(cid or GetPlayerName(src), d.id, d.gangId and ('gang ' .. d.gangId) or 'staff'))
    remove(d, 'opened')
    return true, got
end

---For players who join (or restart) while a drop is up.
function Airdrops.Active(src)
    local out = {}
    for _, d in pairs(drops) do
        if d.state == 'flying' or d.state == 'landed' then
            local to = audience(d)
            local sees = to == -1
            if not sees then for _, s in ipairs(to) do if s == src then sees = true end end end
            if sees then out[#out + 1] = publicView(d) end
        end
    end
    return out
end

-------------------------------------------------------------------------------
-- Timing
-------------------------------------------------------------------------------

local function tick()
    local t = now()
    for _, d in pairs(drops) do
        if d.state == 'called' and t >= d.arriveAt then
            d.state = 'flying'
            broadcast('vinewood_gangs:client:airdropIncoming', d)
        elseif d.state == 'flying' and t >= d.landAt then
            d.state = 'landed'
            d.landedAt = t
            broadcast('vinewood_gangs:client:airdropLanded', d)
            if cfg.alertPolice then
                Bridge.Dispatch.Alert({ title = 'Cargo dropped from aircraft', code = '10-66', priority = 2,
                    coords = vector3(d.cx, d.cy, 0.0), approximate = true,
                    description = 'Callers report a military plane dropping a crate by parachute.' })
            end
        elseif d.state == 'landed' and t - d.landedAt >= cfg.despawn * 60 then
            if d.gangId then Gangs.NotifyGang(d.gangId, locale('airdrop_expired'), 'inform') end
            remove(d, 'expired')
        end
    end
end

CreateThread(function()
    if not cfg.enabled then return end
    while true do
        Wait(2000)
        local ok, err = pcall(tick)
        if not ok then lib.print.error(('air drop tick: %s'):format(err)) end
    end
end)

-------------------------------------------------------------------------------
-- Staff
-------------------------------------------------------------------------------

function Airdrops.AdminList()
    local list = {}
    for _, d in pairs(drops) do
        local g = d.gangId and Gangs.Get(d.gangId)
        list[#list + 1] = { id = d.id, gang = g and g.label or (d.byStaff and 'Staff drop (for nobody)' or '?'), state = d.state, x = d.x, y = d.y,
            arrivesIn = math.max(0, d.arriveAt - now()) }
    end
    return list
end

---Staff call one in: where they're standing (or x, y), for a gang or nobody, arriving in a few minutes.
---No cost, cooldown or one-at-a-time limit.
function Airdrops.AdminCall(src, x, y, gangId, minutes)
    x, y = tonumber(x), tonumber(y)
    if not x or not y then
        local c = GetEntityCoords(GetPlayerPed(src))
        x, y = c.x, c.y
    end
    gangId = tonumber(gangId)
    if gangId and not Gangs.Get(gangId) then gangId = nil end
    local delay = math.floor(math.max(0, math.min(30, tonumber(minutes) or 1)) * 60)
    nextId = nextId + 1
    local t = now()
    local a, r = math.random() * math.pi * 2, math.random() * cfg.radius * 0.6
    local d = { id = nextId, gangId = gangId, x = x, y = y, cx = x + math.cos(a) * r, cy = y + math.sin(a) * r,
        arriveAt = t + delay, landAt = t + delay + FALL_TIME, state = 'called', byStaff = true }
    drops[d.id] = d
    if gangId then Gangs.NotifyGang(gangId, locale('airdrop_called', math.max(1, math.ceil(delay / 60))), 'inform') end
    Logger.Log(src, 'staff_airdrop_called', ('called a drop at %.0f, %.0f%s'):format(x, y, gangId and (' for gang ' .. gangId) or ''))
    return true
end

function Airdrops.AdminCancel(src, id)
    local d = drops[tonumber(id)]
    if not d then return false, 'invalid' end
    Logger.Log(src, 'staff_airdrop_cancelled', ('cancelled drop %d'):format(d.id))
    remove(d, 'cancelled')
    return true
end

-- For tests
Airdrops._drops = drops
Airdrops._tick = tick
