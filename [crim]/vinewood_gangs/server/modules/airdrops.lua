-- Air drops: gang management call one in on the tablet; a plane drops a crate; whoever opens it gets the loot.
Airdrops = {}

local cfg = Config.Airdrops
local drops = {}       -- drops[id] = { id, gangId, x, y, cx, cy, arriveAt, landAt, state, lock, ... }
local gangNext = {}    -- gangNext[gangId] = os.time() the gang can call again
local lastDrop = 0
local nextId = 0

-- The loot table staff edit in game (falls back to config/airdrops.lua)
local lootTable, lootRolls = cfg.loot, cfg.rolls

local FALL_TIME = 40   -- seconds from the plane passing over to the crate landing (roughly, on every client)

local function now() return os.time() end

local function publicView(d)
    return { id = d.id, gangId = d.gangId, x = d.x, y = d.y, cx = d.cx, cy = d.cy, radius = cfg.radius,
        state = d.state, landsIn = math.max(0, d.landAt - now()), plane = cfg.plane, crate = cfg.crate }
end

---Can this player go for this drop? Staff drops can be for one gang, or gangs of a tier and up.
local function eligible(src, d)
    local who = d.who
    if not who or who.kind == 'all' then return true end
    local gang = Gangs.GetPlayerGang(src)
    if not gang then return false end
    if who.kind == 'gang' then return gang.id == who.gangId end
    if who.kind == 'tier' then return Progression.Tier(gang.id) >= (who.tier or 1) end
    return true
end

---Who should see this drop's blip.
local function audience(d)
    if d.who and d.who.kind ~= 'all' then
        local out = {}
        for _, src in ipairs(GetPlayers()) do
            src = tonumber(src)
            if eligible(src, d) then out[#out + 1] = src end
        end
        return out
    end
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
    if not cfg.enabled or not cfg.playersCanCall then return nil, 'airdrop_staff_only' end
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
    if not cfg.enabled or not cfg.playersCanCall then return false, 'airdrop_staff_only' end
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
    if not eligible(src, d) then return false, 'airdrop_not_for_you' end
    if not near2D(src, d, 4.0) then return false, 'too_far' end
    if d.lock and d.lock.src ~= src and GetGameTimer() - d.lock.at < (cfg.openTime + 5) * 1000 then return false, 'airdrop_someone_opening' end
    d.lock = { src = src, at = GetGameTimer() }
    return true, cfg.openTime
end

local function rollLoot()
    local total = 0
    for _, l in ipairs(lootTable) do total = total + (l.chance or 1) end
    local picks = {}
    for _ = 1, lootRolls do
        local r, acc = math.random() * total, 0
        for _, l in ipairs(lootTable) do
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
    for _, l in ipairs(d.contents or rollLoot()) do
        local amount = d.contents and l.count or math.random(l.min or 1, math.max(l.min or 1, l.max or l.min or 1))
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
        local tierLabel = d.who and d.who.kind == 'tier' and Config.Progression.tiers[d.who.tier] and Config.Progression.tiers[d.who.tier].label
        list[#list + 1] = { id = d.id, gang = g and g.label or (tierLabel and ('Staff drop: ' .. tierLabel .. ' and up')) or (d.byStaff and 'Staff drop: all gangs' or '?'), state = d.state, x = d.x, y = d.y,
            arrivesIn = math.max(0, d.arriveAt - now()) }
    end
    return list
end

-------------------------------------------------------------------------------
-- Loot staff choose
-------------------------------------------------------------------------------

local function cleanEntry(e, exact)
    if type(e) ~= 'table' then return nil end
    local lo = math.floor(math.max(1, math.min(100000000, tonumber(exact and e.count or e.min) or 1)))
    local out = exact and { count = lo } or { min = lo, max = math.floor(math.max(lo, math.min(100000000, tonumber(e.max) or lo))),
        chance = math.max(1, math.min(1000, math.floor(tonumber(e.chance) or 1))) }
    if e.money then
        out.money = true
    else
        if not e.item or not Bridge.ItemExists(e.item) then return nil, 'item_not_found' end
        out.item = tostring(e.item)
        if exact then out.count = math.min(out.count, 1000) else out.max = math.min(out.max, 1000) out.min = math.min(out.min, out.max) end
    end
    return out
end

function Airdrops.AdminLoot()
    local list = {}
    for i, l in ipairs(lootTable) do
        list[i] = { money = l.money == true, item = l.item, label = l.item and Bridge.ItemLabel(l.item) or nil, min = l.min, max = l.max, chance = l.chance }
    end
    return { rolls = lootRolls, loot = list, fromConfig = lootTable == cfg.loot }
end

function Airdrops.AdminSaveLoot(src, input)
    if type(input) ~= 'table' or type(input.loot) ~= 'table' or #input.loot == 0 or #input.loot > 40 then return false, 'airdrop_need_loot' end
    local list = {}
    for _, e in ipairs(input.loot) do
        local clean, err = cleanEntry(e, false)
        if not clean then return false, err or 'invalid' end
        list[#list + 1] = clean
    end
    lootTable, lootRolls = list, math.max(1, math.min(20, math.floor(tonumber(input.rolls) or cfg.rolls)))
    MySQL.insert.await("INSERT INTO vg_settings (`key`, value, updated_by) VALUES ('airdrop_loot', ?, ?) ON DUPLICATE KEY UPDATE value = VALUES(value), updated_by = VALUES(updated_by)",
        { json.encode({ rolls = lootRolls, loot = lootTable }), Bridge.GetCitizenId(src) or 'console' })
    Logger.Log(src, 'staff_airdrop_loot', ('saved the air drop loot table (%d entries, %d picks)'):format(#list, lootRolls))
    return true, Airdrops.AdminLoot()
end

function Airdrops.AdminResetLoot(src)
    lootTable, lootRolls = cfg.loot, cfg.rolls
    MySQL.update.await("DELETE FROM vg_settings WHERE `key` = 'airdrop_loot'")
    return true, Airdrops.AdminLoot()
end

function Airdrops.LoadLoot()
    local raw = MySQL.scalar.await("SELECT value FROM vg_settings WHERE `key` = 'airdrop_loot'")
    local ok, saved = pcall(json.decode, raw or '')
    if ok and type(saved) == 'table' and type(saved.loot) == 'table' and #saved.loot > 0 then
        lootTable, lootRolls = saved.loot, saved.rolls or cfg.rolls
    end
end

---Staff call one in: where they're standing (or x, y), for a gang or nobody, arriving in a few minutes.
---contents = an exact list to put in the crate ({ item, count } or { money = true, count }), or nil for the usual loot.
---No cost, cooldown or one-at-a-time limit.
function Airdrops.AdminCall(src, opts)
    opts = type(opts) == 'table' and opts or {}
    local x, y, minutes, contents = tonumber(opts.x), tonumber(opts.y), opts.minutes, opts.contents
    -- Who can get it: all gangs, gangs of a tier and up, or one gang
    local w = type(opts.who) == 'table' and opts.who or {}
    local who = { kind = 'all' }
    local gangId
    if w.kind == 'gang' and tonumber(w.gangId) and Gangs.Get(tonumber(w.gangId)) then
        who = { kind = 'gang', gangId = tonumber(w.gangId) }
        gangId = who.gangId
    elseif w.kind == 'tier' then
        who = { kind = 'tier', tier = math.max(1, math.min(#Config.Progression.tiers, math.floor(tonumber(w.tier) or 1))) }
    end
    if not x or not y then
        local c = GetEntityCoords(GetPlayerPed(src))
        x, y = c.x, c.y
    end
    local delay = math.floor(math.max(0, math.min(30, tonumber(minutes) or 1)) * 60)
    local exact
    if type(contents) == 'table' and #contents > 0 then
        exact = {}
        for _, e in ipairs(contents) do
            if #exact >= 20 then break end
            local clean, err = cleanEntry(e, true)
            if not clean then return false, err or 'invalid' end
            exact[#exact + 1] = clean
        end
    end
    nextId = nextId + 1
    local t = now()
    local a, r = math.random() * math.pi * 2, math.random() * cfg.radius * 0.6
    local d = { id = nextId, gangId = gangId, x = x, y = y, cx = x + math.cos(a) * r, cy = y + math.sin(a) * r,
        arriveAt = t + delay, landAt = t + delay + FALL_TIME, state = 'called', byStaff = true, contents = exact, who = who }
    drops[d.id] = d
    -- Tell the gangs it's for (an "all gangs" drop is found by its plane and search circle, like any other)
    local mins = math.max(1, math.ceil(delay / 60))
    if who.kind == 'gang' then
        Gangs.NotifyGang(gangId, locale('airdrop_called', mins), 'inform')
    elseif who.kind == 'tier' then
        for id in pairs(Gangs.All()) do
            if Progression.Tier(id) >= who.tier then Gangs.NotifyGang(id, locale('airdrop_called', mins), 'inform') end
        end
    end
    Logger.Log(src, 'staff_airdrop_called', ('called a drop at %.0f, %.0f for %s'):format(x, y,
        who.kind == 'gang' and ('gang ' .. who.gangId) or (who.kind == 'tier' and ('tier ' .. who.tier .. '+') or 'all gangs')))
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
