-- Air drops: gang management call one in on the tablet; a plane drops a crate; whoever opens it gets the loot.
Airdrops = {}

local cfg = Config.Airdrops
local drops = {}       -- drops[id] = { id, gangId, x, y, cx, cy, arriveAt, landAt, state, lock, ... }
local gangNext = {}    -- gangNext[gangId] = os.time() the gang can call again
local lastDrop = 0
local nextId = 0

-- The loot table staff edit in game (falls back to config/airdrops.lua)
-- Named loot tables staff edit in game (the first is the default). Starts as the one in config/airdrops.lua.
local lootTables, nextTableId = nil, 1
local function configTables() return { { id = 1, name = 'Standard', rolls = cfg.rolls, loot = cfg.loot } } end
lootTables = configTables()
nextTableId = 2

---The table to use: the one asked for, or the default (the first).
local function tableFor(id)
    id = tonumber(id)
    if id then for _, t in ipairs(lootTables) do if t.id == id then return t end end end
    return lootTables[1]
end

-- Seconds from the plane appearing to the crate being on the ground: the plane flies 1500 m to the drop point,
-- then the crate falls from the plane's height. Worked out from config so the server and what players see agree.
local FALL_TIME = math.ceil(1500.0 / math.max(10.0, cfg.plane.speed) + cfg.plane.height / math.max(1.0, cfg.crate.fallSpeed) + 3)
local broadcastOpening -- defined below   -- seconds from the plane passing over to the crate landing (roughly, on every client)

local function now() return os.time() end

local function publicView(d)
    return { id = d.id, gangId = d.gangId, x = d.x, y = d.y, cx = d.cx, cy = d.cy, radius = cfg.radius,
        state = d.state, landsIn = math.max(0, d.landAt - now()), plane = cfg.plane, crate = cfg.crate, watching = nil }
end

---Can this player go for this drop? Staff drops can be for one gang, or gangs of a tier and up.
local function eligible(src, d)
    local who = d.who
    -- Open to everyone (a staff drop for everyone, or a gang-called drop with showTo = 'everyone')
    if (who and who.kind == 'everyone') or (not who and cfg.showTo == 'everyone') then return true end
    -- Otherwise it's for gangs only ("all gangs" means every gang member, not every player)
    local gang = Gangs.GetPlayerGang(src)
    if not gang then return false end
    if not who or who.kind == 'all' then return true end
    if who.kind == 'gang' then return gang.id == who.gangId end
    if who.kind == 'tier' then return Progression.Tier(gang.id) >= (who.tier or 1) end
    return true
end

---Who should see this drop's blip.
local function audience(d)
    if d.who and d.who.kind == 'everyone' then return -1 end
    if d.who then -- staff drops: all gangs, a tier and up, or one gang (gang members only, every time)
        local out = {}
        for _, src in ipairs(GetPlayers()) do
            src = tonumber(src)
            -- ...plus the staff member who called it, so they can watch it come in
            if eligible(src, d) or src == d.staffSrc then out[#out + 1] = src end
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
    for _, src in ipairs(to) do
        local view = publicView(d)
        -- The staff member watching their own drop (not one it's meant for) sees it without the messages
        if src == d.staffSrc and d.who and d.who.kind ~= 'everyone' and not eligible(src, d) then view.watching = true end
        TriggerClientEvent(event, src, view)
    end
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

---Everyone who can see the drop is told someone's breaking into it (or that they've stopped).
broadcastOpening = function(d, seconds)
    local to = audience(d)
    if to == -1 then TriggerClientEvent('vinewood_gangs:client:airdropOpening', -1, d.id, seconds) return end
    for _, s in ipairs(to) do TriggerClientEvent('vinewood_gangs:client:airdropOpening', s, d.id, seconds) end
end

---The opener stopped: got hurt, knocked down, killed, moved away or gave up. The crate's free again.
function Airdrops.StopOpen(src, id)
    local d = drops[tonumber(id)]
    if d and d.lock and d.lock.src == src then
        d.lock = nil
        broadcastOpening(d, nil)
    end
    return true
end

function Airdrops.BeginOpen(src, id)
    local d = drops[tonumber(id)]
    if not d or d.state ~= 'landed' then return false, 'airdrop_not_here' end
    if not eligible(src, d) then return false, 'airdrop_not_for_you' end
    if not near2D(src, d, 4.0) then return false, 'too_far' end
    if d.lock and d.lock.src ~= src and GetGameTimer() - d.lock.at < (cfg.openTime + 5) * 1000 then return false, 'airdrop_someone_opening' end
    if GetEntityHealth(GetPlayerPed(src)) <= 0 then return false, 'invalid' end
    d.lock = { src = src, at = GetGameTimer() }
    broadcastOpening(d, cfg.openTime)
    return true, cfg.openTime
end

local function rollLoot(tableId)
    local t = tableFor(tableId)
    local total = 0
    for _, l in ipairs(t.loot) do total = total + (l.chance or 1) end
    local picks = {}
    for _ = 1, t.rolls do
        local r, acc = math.random() * total, 0
        for _, l in ipairs(t.loot) do
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
    -- The whole time has to pass, and they have to still be standing there alive
    if (GetGameTimer() - d.lock.at) / 1000 < cfg.openTime * 0.97 then return false, 'invalid' end
    if GetEntityHealth(GetPlayerPed(src)) <= 0 then d.lock = nil broadcastOpening(d, nil) return false, 'airdrop_interrupted' end
    if not near2D(src, d, 5.0) then d.lock = nil broadcastOpening(d, nil) return false, 'too_far' end

    d.state = 'opened'
    local gang, _, cid = Gangs.GetPlayerGang(src)
    local got = {}
    for _, l in ipairs(d.contents or rollLoot(d.lootTable)) do
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
                Bridge.Dispatch.Alert({ title = 'Package dropped from aircraft', code = '10-66', priority = 2,
                    coords = vector3(d.cx, d.cy, 0.0), approximate = true,
                    description = 'Callers report a light aircraft flying low and dropping a package by parachute.' })
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
        local forWho = d.who and d.who.kind == 'everyone' and 'Staff drop: everyone'
            or (tierLabel and ('Staff drop: ' .. tierLabel .. ' and up')) or (d.byStaff and 'Staff drop: all gangs') or '?'
        list[#list + 1] = { id = d.id, gang = g and g.label or forWho, state = d.state, x = d.x, y = d.y,
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
    local tables = {}
    for _, t in ipairs(lootTables) do
        local list = {}
        for i, l in ipairs(t.loot) do
            list[i] = { money = l.money == true, item = l.item, label = l.item and Bridge.ItemLabel(l.item) or nil, min = l.min, max = l.max, chance = l.chance }
        end
        tables[#tables + 1] = { id = t.id, name = t.name, rolls = t.rolls, loot = list }
    end
    return { tables = tables, fromConfig = lootTables[1].loot == cfg.loot and #lootTables == 1 }
end

---The loot tables, for the drop and schedule menus: { id, name }.
function Airdrops.LootTableNames()
    local out = {}
    for _, t in ipairs(lootTables) do out[#out + 1] = { id = t.id, name = t.name } end
    return out
end

local function storeTables(src)
    MySQL.insert.await("INSERT INTO vg_settings (`key`, value, updated_by) VALUES ('airdrop_loot', ?, ?) ON DUPLICATE KEY UPDATE value = VALUES(value), updated_by = VALUES(updated_by)",
        { json.encode({ tables = lootTables, nextId = nextTableId }), src and Bridge.GetCitizenId(src) or 'console' })
end

---Saves every loot table at once. input.tables = { { id?, name, rolls, loot = { ... } } } (the first is the default).
function Airdrops.AdminSaveLoot(src, input)
    if type(input) ~= 'table' or type(input.tables) ~= 'table' or #input.tables == 0 then return false, 'airdrop_need_loot' end
    if #input.tables > 20 then return false, 'invalid' end
    local tables, usedIds = {}, {}
    for _, t in ipairs(input.tables) do
        if type(t) ~= 'table' or type(t.loot) ~= 'table' or #t.loot == 0 or #t.loot > 40 then return false, 'airdrop_need_loot' end
        local list = {}
        for _, e in ipairs(t.loot) do
            local clean, err = cleanEntry(e, false)
            if not clean then return false, err or 'invalid' end
            list[#list + 1] = clean
        end
        local name = tostring(t.name or ''):gsub('[<>]', ''):match('^%s*(.-)%s*$'):sub(1, 32)
        local id = tonumber(t.id)
        if not id or usedIds[id] then id = nextTableId nextTableId = nextTableId + 1 end
        usedIds[id] = true
        if id >= nextTableId then nextTableId = id + 1 end
        tables[#tables + 1] = { id = id, name = #name > 0 and name or ('Loot table ' .. id), rolls = math.max(1, math.min(20, math.floor(tonumber(t.rolls) or cfg.rolls))), loot = list }
    end
    lootTables = tables
    storeTables(src)
    Logger.Log(src, 'staff_airdrop_loot', ('saved %d air drop loot tables'):format(#tables))
    return true, Airdrops.AdminLoot()
end

function Airdrops.AdminResetLoot(src)
    lootTables, nextTableId = configTables(), 2
    MySQL.update.await("DELETE FROM vg_settings WHERE `key` = 'airdrop_loot'")
    return true, Airdrops.AdminLoot()
end

function Airdrops.LoadLoot()
    local raw = MySQL.scalar.await("SELECT value FROM vg_settings WHERE `key` = 'airdrop_loot'")
    local ok, saved = pcall(json.decode, raw or '')
    if not ok or type(saved) ~= 'table' then return end
    if type(saved.tables) == 'table' and #saved.tables > 0 then
        lootTables, nextTableId = saved.tables, saved.nextId or (#saved.tables + 1)
    elseif type(saved.loot) == 'table' and #saved.loot > 0 then
        -- Saved before there were several tables: that one becomes "Standard"
        lootTables, nextTableId = { { id = 1, name = 'Standard', rolls = saved.rolls or cfg.rolls, loot = saved.loot } }, 2
    end
end

---Staff call one in: where they're standing (or x, y), for a gang or nobody, arriving in a few minutes.
---contents = an exact list to put in the crate ({ item, count } or { money = true, count }), or nil for the usual loot.
---No cost, cooldown or one-at-a-time limit.
function Airdrops.AdminCall(src, opts)
    opts = type(opts) == 'table' and opts or {}
    local x, y, minutes, contents = tonumber(opts.x), tonumber(opts.y), opts.minutes, opts.contents
    local lootTableId = tonumber(opts.lootTable)
    -- Who can get it: all gangs, gangs of a tier and up, or one gang
    local w = type(opts.who) == 'table' and opts.who or {}
    local who = { kind = 'all' }
    local gangId
    if w.kind == 'gang' and tonumber(w.gangId) and Gangs.Get(tonumber(w.gangId)) then
        who = { kind = 'gang', gangId = tonumber(w.gangId) }
        gangId = who.gangId
    elseif w.kind == 'tier' then
        who = { kind = 'tier', tier = math.max(1, math.min(#Config.Progression.tiers, math.floor(tonumber(w.tier) or 1))) }
    elseif w.kind == 'everyone' then
        who = { kind = 'everyone' }
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
        arriveAt = t + delay, landAt = t + delay + FALL_TIME, state = 'called', byStaff = true, contents = exact, who = who, staffSrc = src,
        lootTable = (not exact and lootTableId) and tableFor(lootTableId).id or nil }
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
        who.kind == 'gang' and ('gang ' .. who.gangId) or (who.kind == 'tier' and ('tier ' .. who.tier .. '+'))
            or (who.kind == 'everyone' and 'everyone') or 'all gangs'))
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

AddEventHandler('playerDropped', function()
    local src = source
    for _, d in pairs(drops) do
        if d.lock and d.lock.src == src then d.lock = nil broadcastOpening(d, nil) end
    end
end)

-------------------------------------------------------------------------------
-- Scheduled drops (/gangadmin > Street events > Scheduled air drops)
-------------------------------------------------------------------------------

local schedules, nextScheduleId = {}, 1
local LATE_LIMIT = 600 -- a drop that's more than 10 minutes overdue (the server was down) is skipped, not fired late

local function saveSchedules(src)
    MySQL.insert.await("INSERT INTO vg_settings (`key`, value, updated_by) VALUES ('airdrop_schedules', ?, ?) ON DUPLICATE KEY UPDATE value = VALUES(value), updated_by = VALUES(updated_by)",
        { json.encode({ nextId = nextScheduleId, list = schedules }), src and Bridge.GetCitizenId(src) or 'server' })
end

---When a schedule next fires (server time), or nil if it won't again.
local function nextRunAt(s, t)
    t = t or now()
    local since = s.lastRun or s.createdAt or t
    if s.kind == 'once' then
        return (not s.lastRun) and s.at or nil
    elseif s.kind == 'every' then
        return since + s.minutes * 60
    elseif s.kind == 'daily' then
        local best
        for day = 0, 1 do
            local base = os.date('*t', since + day * 86400)
            for _, hm in ipairs(s.times) do
                local h, m = hm:match('^(%d+):(%d+)$')
                local at = os.time({ year = base.year, month = base.month, day = base.day, hour = tonumber(h), min = tonumber(m), sec = 0 })
                if at > since and (not best or at < best) then best = at end
            end
        end
        return best
    end
end

local function fire(s)
    if #GetPlayers() < (s.minPlayers or 0) then return false, 'not enough players' end
    local spot = s.spots[math.random(#s.spots)]
    local ok, err = Airdrops.AdminCall(nil, { x = spot.x, y = spot.y, minutes = s.delay, contents = s.contents, who = s.who, lootTable = s.lootTable })
    Logger.Log(nil, 'airdrop_scheduled', ('schedule "%s" %s at %.0f, %.0f%s'):format(s.name, ok and 'called a drop' or 'failed', spot.x, spot.y, ok and '' or (': ' .. tostring(err))))
    return ok, err
end

local function scheduleTick()
    local t, changed = now(), false
    for _, s in ipairs(schedules) do
        if s.enabled then
            local at = nextRunAt(s, t)
            if at and t >= at then
                s.lastRun = t
                changed = true
                if t - at <= LATE_LIMIT then fire(s) end
                if s.kind == 'once' then s.enabled = false end
            end
        end
    end
    if changed then saveSchedules() end
end
Airdrops._scheduleTick = scheduleTick -- for tests

function Airdrops.LoadSchedules()
    local raw = MySQL.scalar.await("SELECT value FROM vg_settings WHERE `key` = 'airdrop_schedules'")
    local ok, data = pcall(json.decode, raw or '')
    if ok and type(data) == 'table' then schedules, nextScheduleId = data.list or {}, data.nextId or 1 end
    CreateThread(function()
        while true do
            Wait(30000)
            local okT, err = pcall(scheduleTick)
            if not okT then lib.print.error(('air drop schedules: %s'):format(err)) end
        end
    end)
end

local function cleanSchedule(input)
    if type(input) ~= 'table' then return nil, 'invalid' end
    local name = tostring(input.name or ''):gsub('[<>]', ''):match('^%s*(.-)%s*$'):sub(1, 40)
    if #name < 2 then return nil, 'invalid_label' end
    local s = { name = name, enabled = input.enabled ~= false, kind = input.kind }
    if s.kind == 'every' then
        s.minutes = math.floor(math.max(15, math.min(10080, tonumber(input.minutes) or 180)))
    elseif s.kind == 'daily' then
        s.times = {}
        for _, hm in ipairs(type(input.times) == 'table' and input.times or {}) do
            local h, m = tostring(hm):match('^(%d%d?):(%d%d)$')
            h, m = tonumber(h), tonumber(m)
            if h and m and h < 24 and m < 60 and #s.times < 12 then s.times[#s.times + 1] = ('%02d:%02d'):format(h, m) end
        end
        if #s.times == 0 then return nil, 'airdrop_need_time' end
        table.sort(s.times)
    elseif s.kind == 'once' then
        s.at = math.floor(tonumber(input.at) or 0)
        if s.at < now() - 60 then return nil, 'airdrop_time_passed' end
    else
        return nil, 'invalid'
    end
    s.spots = {}
    for _, p in ipairs(type(input.spots) == 'table' and input.spots or {}) do
        local x, y, z = tonumber(p.x), tonumber(p.y), tonumber(p.z)
        if x and y and math.abs(x) < 6000 and y > -5000 and y < 9000 and #s.spots < 20 then s.spots[#s.spots + 1] = { x = x, y = y, z = z or 0 } end
    end
    if #s.spots == 0 then return nil, 'airdrop_need_spot' end
    local w = type(input.who) == 'table' and input.who or {}
    if w.kind == 'gang' and tonumber(w.gangId) and Gangs.Get(tonumber(w.gangId)) then s.who = { kind = 'gang', gangId = tonumber(w.gangId) }
    elseif w.kind == 'tier' then s.who = { kind = 'tier', tier = math.max(1, math.min(#Config.Progression.tiers, math.floor(tonumber(w.tier) or 1))) }
    elseif w.kind == 'everyone' then s.who = { kind = 'everyone' }
    else s.who = { kind = 'all' } end
    s.delay = math.floor(math.max(0, math.min(30, tonumber(input.delay) or 2)))
    s.lootTable = tonumber(input.lootTable) -- which loot table (nil = the default)
    s.minPlayers = math.floor(math.max(0, math.min(200, tonumber(input.minPlayers) or 0)))
    if type(input.contents) == 'table' and #input.contents > 0 then
        s.contents = {}
        for _, e in ipairs(input.contents) do
            if #s.contents >= 20 then break end
            local clean, err = cleanEntry(e, true)
            if not clean then return nil, err or 'invalid' end
            s.contents[#s.contents + 1] = clean
        end
    end
    return s
end

function Airdrops.AdminSchedules()
    local t = now()
    local list = {}
    for _, s in ipairs(schedules) do
        local copy = {}
        for k, v in pairs(s) do copy[k] = v end
        local at = s.enabled and nextRunAt(s, t) or nil
        copy.nextIn = at and math.max(0, at - t) or nil
        for _, it in ipairs(copy.contents or {}) do if it.item then it.label = Bridge.ItemLabel(it.item) end end
        local g = s.who and s.who.kind == 'gang' and Gangs.Get(s.who.gangId)
        copy.gangLabel = g and g.label or nil
        list[#list + 1] = copy
    end
    return { schedules = list, serverTime = os.date('%H:%M', t), serverNow = t, lootTables = Airdrops.LootTableNames() }
end

function Airdrops.AdminSaveSchedule(src, input)
    local s, err = cleanSchedule(input)
    if not s then return false, err end
    local id = tonumber(type(input) == 'table' and input.id)
    for i, old in ipairs(schedules) do
        if old.id == id then
            s.id, s.createdAt = old.id, old.createdAt
            -- Changing when it runs starts the clock again from now (so it doesn't fire straight away)
            s.lastRun = (old.kind == s.kind and old.lastRun) or now()
            if s.kind == 'once' then s.lastRun = nil end
            schedules[i] = s
            saveSchedules(src)
            Logger.Log(src, 'staff_airdrop_schedule', ('updated air drop schedule "%s"'):format(s.name))
            return true
        end
    end
    s.id, s.createdAt = nextScheduleId, now()
    nextScheduleId = nextScheduleId + 1
    schedules[#schedules + 1] = s
    saveSchedules(src)
    Logger.Log(src, 'staff_airdrop_schedule', ('created air drop schedule "%s"'):format(s.name))
    return true
end

function Airdrops.AdminDeleteSchedule(src, id)
    id = tonumber(id)
    for i, s in ipairs(schedules) do
        if s.id == id then
            table.remove(schedules, i)
            saveSchedules(src)
            Logger.Log(src, 'staff_airdrop_schedule', ('deleted air drop schedule "%s"'):format(s.name))
            return true
        end
    end
    return false, 'invalid'
end

function Airdrops.AdminToggleSchedule(src, id, on)
    id = tonumber(id)
    for _, s in ipairs(schedules) do
        if s.id == id then
            s.enabled = on == true
            -- Switching back on starts counting from now, so it doesn't fire for time it was off
            if s.enabled and s.kind ~= 'once' then s.lastRun = now() end
            saveSchedules(src)
            return true
        end
    end
    return false, 'invalid'
end
