Safehouses = {}

local cfg = Config.Safehouses
local DAY = 86400
local houses = {}  -- houses[id] = { id, label, address, entrance, spawn, stash, exit, price, upkeep, gangId, paidUntil, upgrades, breachedUntil }
local inside = {}  -- inside[src] = safehouse id
local breaches = {} -- breaches[id] = { src, startedAt, warrantId }
local warned = {}  -- warned[id] = last arrears warning (os.time)

local function v3(p) return vector3(p.x, p.y, p.z) end
local function near(src, point, range) return #(GetEntityCoords(GetPlayerPed(src)) - v3(point)) <= (range or 3.0) end

-------------------------------------------------------------------------------
-- Shells: spawn, stash and exit are saved relative to the shell, and placed at the shared shell spot
-------------------------------------------------------------------------------

local function shellDef(model)
    for _, s in ipairs(cfg.shells or {}) do if s.model == model then return s end end
end

local function fromShell(offset)
    local o = cfg.shellOrigin
    return { x = o.x + offset.x, y = o.y + offset.y, z = o.z + offset.z, w = offset.w or 0.0 }
end

---Where a safehouse's inside points really are (shell safehouses are stored as offsets).
local function resolve(pts)
    if not pts.shell then return pts.spawn, pts.stash, pts.exit end
    return fromShell(pts.spawn), fromShell(pts.stash), fromShell(pts.exit)
end

-------------------------------------------------------------------------------
-- Storage and replication
-------------------------------------------------------------------------------

local function save(h)
    MySQL.prepare('UPDATE vg_safehouses SET gang_id = ?, paid_until = ?, upgrades = ?, breached_until = ? WHERE id = ?',
        { h.gangId, h.paidUntil, json.encode(h.upgrades), h.breachedUntil, h.id })
end

---MLO safehouses you walk into: are the doors locked right now? Locked unless the owners unlocked them,
---and always open while police have them breached. Nobody owns it: locked.
local function isLocked(h)
    if h.breachedUntil > os.time() then return false end
    if not h.gangId then return true end
    return h.upgrades.locked ~= false
end

---Entrances (and interior spawn points, used to rescue anyone who relogs inside) for every client.
---Walk-in MLO safehouses also share their doors, lock state and stash spot.
local function publish()
    local list, now = {}, os.time()
    for _, h in pairs(houses) do
        local g = h.gangId and Gangs.Get(h.gangId)
        list[#list + 1] = {
            id = h.id, label = h.label, entrance = h.entrance, spawn = h.spawn,
            gangId = h.gangId, owner = g and g.label or nil, breached = h.breachedUntil > now,
            walkin = h.walkin or nil, doors = h.walkin and h.doors or nil,
            locked = (h.walkin and isLocked(h)) == true, -- always true or false, never missing
            stash = h.walkin and h.stash or nil,
        }
    end
    GlobalState.vg_safehouses = list
end

-------------------------------------------------------------------------------
-- Stash (server-opened, so access is always checked here first)
-------------------------------------------------------------------------------

-- A new owner gets a fresh stash: the id includes the owning gang
local function stashId(h) return ('vg_safehouse_%d_%d'):format(h.id, h.gangId or 0) end

local function stashSize(h)
    local level = h.upgrades.stash or 0
    local u = level > 0 and cfg.upgrades.stash[level]
    if u then return u.slots, u.weight end
    return cfg.stash.slots, cfg.stash.weight
end

local function registerStash(h)
    if not h.gangId or GetResourceState('ox_inventory') ~= 'started' then return end
    local slots, weight = stashSize(h)
    exports.ox_inventory:RegisterStash(stashId(h), h.label, slots, weight, nil, nil, v3(h.stash))
end

local function openStash(src, h)
    local slots, weight = stashSize(h)
    if GetResourceState('ox_inventory') == 'started' then
        exports.ox_inventory:forceOpenInventory(src, 'stash', stashId(h))
        return true
    elseif GetResourceState('qb-inventory') == 'started' then
        exports['qb-inventory']:OpenInventory(src, stashId(h), { label = h.label, maxweight = weight, slots = slots })
        return true
    end
    return false, 'no_inventory'
end

-------------------------------------------------------------------------------
-- Moving people in and out
-------------------------------------------------------------------------------

local function putOutside(src, h)
    inside[src] = nil
    SetPlayerRoutingBucket(src, 0)
    TriggerClientEvent('vinewood_gangs:client:safehouseOut', src, h and h.entrance)
end

local function emptyHouse(id)
    for src, hid in pairs(inside) do
        if hid == id then putOutside(src, houses[id]) end
    end
end

local function isPolice(src)
    local job = Bridge.GetJob(src)
    return job and cfg.raid.jobs[job] and Bridge.GetJobGrade(src) >= cfg.raid.minGrade
end

---Members with access, or police while the door is breached.
local function mayUse(src, h)
    if not h.gangId then return false end
    if h.breachedUntil > os.time() and isPolice(src) then return true, 'police' end
    local gang, _, cid = Gangs.GetPlayerGang(src)
    if gang and gang.id == h.gangId and Gangs.HasPermission(cid, 'safehouse_access') then return true, 'member' end
    return false
end

function Safehouses.Enter(src, id)
    local h = houses[tonumber(id)]
    if not h then return false, 'invalid' end
    if h.walkin then return false, 'invalid' end -- you walk in through its doors
    if inside[src] then return false, 'invalid' end
    if not near(src, h.entrance, 4.0) then return false, 'too_far' end
    local ok = mayUse(src, h)
    if not ok then return false, 'safehouse_locked' end

    inside[src] = h.id
    SetPlayerRoutingBucket(src, cfg.bucketBase + h.id)
    local shell = h.shell and { model = h.shell, x = cfg.shellOrigin.x, y = cfg.shellOrigin.y, z = cfg.shellOrigin.z } or nil
    return { spawn = h.spawn, stash = h.stash, exit = h.exit, label = h.label, id = h.id, shell = shell }
end

function Safehouses.Leave(src)
    local id = inside[src]
    if not id then return false, 'invalid' end
    putOutside(src, houses[id])
    return true
end

function Safehouses.OpenStash(src, id)
    local h = houses[inside[src] or -1]
    -- A walk-in MLO safehouse: no instance, just stand at its stash
    if not h and id then
        local w = houses[tonumber(id)]
        if w and w.walkin then h = w end
    end
    if not h then return false, 'invalid' end
    if not near(src, h.stash, 3.0) then return false, 'too_far' end
    local ok, who = mayUse(src, h)
    if not ok then return false, 'safehouse_locked' end
    if who == 'police' then
        Logger.Log(src, 'safehouse_searched', ('police opened stash of safehouse %d (gang %d)'):format(h.id, h.gangId))
    end
    return openStash(src, h)
end

-------------------------------------------------------------------------------
-- Doors of walk-in MLO safehouses: members with access lock and unlock them all from any of them
-------------------------------------------------------------------------------

function Safehouses.ToggleDoors(src, id)
    local h = houses[tonumber(id)]
    if not h or not h.walkin then return false, 'invalid' end
    local close = near(src, h.entrance, 4.0)
    for _, d in ipairs(h.doors or {}) do if near(src, d, 3.5) then close = true break end end
    if not close then return false, 'too_far' end
    local ok, who = mayUse(src, h)
    if not ok or who ~= 'member' then return false, 'safehouse_locked' end
    if h.breachedUntil > os.time() then return false, 'safehouse_doors_breached' end
    h.upgrades.locked = not isLocked(h)
    save(h)
    publish()
    Logger.Log(src, h.upgrades.locked and 'safehouse_locked' or 'safehouse_unlocked', ('safehouse %d'):format(h.id))
    return true, h.upgrades.locked
end

-- When a raid's open time runs out, the doors lock again (everyone's game is told)
CreateThread(function()
    local wasOpen = {}
    while true do
        Wait(15000)
        local t, changed = os.time(), false
        for id, h in pairs(houses) do
            local open = h.breachedUntil > t
            if wasOpen[id] and not open then changed = true end
            wasOpen[id] = open
        end
        if changed then publish() end
    end
end)

-------------------------------------------------------------------------------
-- Raids
-------------------------------------------------------------------------------

local function mdtRunning()
    local res = Config.Integrations.mdt
    return res and GetResourceState(res) == 'started'
end

---An active search warrant on the MDT whose address matches the safehouse.
local function findWarrant(h)
    if not mdtRunning() then return nil end
    local placeholders = {}
    for i = 1, #cfg.raid.warrantTypes do placeholders[i] = '?' end
    local params = {}
    for _, t in ipairs(cfg.raid.warrantTypes) do params[#params + 1] = t end
    params[#params + 1] = '%' .. h.address:lower() .. '%'
    params[#params + 1] = '%' .. h.label:lower() .. '%'
    local ok, row = pcall(MySQL.single.await, ([[
        SELECT id FROM vw_mdt_warrants
        WHERE status = 'active' AND type IN (%s) AND (LOWER(address) LIKE ? OR LOWER(address) LIKE ?)
        ORDER BY created_at DESC LIMIT 1
    ]]):format(table.concat(placeholders, ',')), params)
    return ok and row and row.id or nil
end

function Safehouses.RaidStart(src, id)
    local h = houses[tonumber(id)]
    if not h or not h.gangId then return false, 'safehouse_empty' end
    if not isPolice(src) then return false, 'no_permission' end
    if not near(src, h.entrance, 4.0) then return false, 'too_far' end
    if h.breachedUntil > os.time() then return false, 'safehouse_already_open' end

    local warrantId
    if cfg.raid.needWarrant then
        if mdtRunning() then
            warrantId = findWarrant(h)
            if not warrantId then return false, 'safehouse_no_warrant' end
        elseif Bridge.GetJobGrade(src) < cfg.raid.noMdtGrade then
            return false, 'safehouse_need_rank'
        end
    end

    local time = cfg.raid.breachTime * ((h.upgrades.door and cfg.upgrades.door.breachMultiplier) or 1.0)
    breaches[h.id] = { src = src, startedAt = GetGameTimer(), time = time, warrantId = warrantId }
    if h.upgrades.cctv then
        Gangs.NotifyGang(h.gangId, locale('safehouse_cctv_warning', h.label), 'error')
    end
    return math.floor(time)
end

function Safehouses.RaidFinish(src, id)
    local h = houses[tonumber(id)]
    local b = h and breaches[h.id]
    if not b or b.src ~= src then return false, 'invalid' end
    breaches[h.id] = nil
    if GetGameTimer() - b.startedAt < b.time * 0.9 then return false, 'invalid' end
    if not near(src, h.entrance, 4.0) then return false, 'too_far' end

    h.breachedUntil = os.time() + cfg.raid.openMinutes * 60
    do
        local g = h.gangId and Gangs.Get(h.gangId)
        Logger.Log(src, 'safehouse_breached', ('Police breached %s (%s)%s'):format(h.label, h.address or '?', g and (', held by ' .. g.label) or ''))
    end
    save(h)
    publish()

    local zone = Zones.FromCoords(v3(h.entrance))
    Activity.Record({ type = 'police_raid', gangId = h.gangId, zone = zone, coords = v3(h.entrance), metadata = { safehouse = h.id } })
    TriggerEvent('vinewood_gangs:server:safehouseRaided', h.id, h.gangId)
    Gangs.NotifyGang(h.gangId, locale('safehouse_raided', h.label), 'error')

    if b.warrantId and cfg.raid.closeWarrant then
        pcall(MySQL.update.await, "UPDATE vw_mdt_warrants SET status = 'executed', closed_by = ?, closed_at = ? WHERE id = ?",
            { Bridge.GetCharName(src), os.time(), b.warrantId })
    end
    Logger.Log(src, 'safehouse_raid', ('safehouse %d (gang %d) breached'):format(h.id, h.gangId))
    return true
end

-------------------------------------------------------------------------------
-- Buying, selling, upgrades (boss only)
-------------------------------------------------------------------------------

local function boss(src)
    local gang, m = Gangs.GetPlayerGang(src)
    if not gang then return nil, 'not_in_gang' end
    if m.grade ~= Gangs.TopGrade(gang.id) then return nil, 'boss_only' end
    return gang
end

local function owned(gangId)
    local n = 0
    for _, h in pairs(houses) do if h.gangId == gangId then n = n + 1 end end
    return n
end

function Safehouses.Buy(src, id)
    local gang, err = boss(src)
    if not gang then return false, err end
    local h = houses[tonumber(id)]
    if not h then return false, 'invalid' end
    if h.gangId then return false, 'safehouse_taken' end
    if owned(gang.id) >= cfg.maxPerGang then return false, 'safehouse_limit' end
    if not Progression.Has(gang.id, 'safehouses') then return false, 'tier_locked' end
    if owned(gang.id) >= 1 and not Progression.Has(gang.id, 'second_safehouse') then return false, 'tier_locked' end

    local ok, res = Ledger.Transact(gang.id, 'clean', -h.price, 'safehouse_purchase', { citizenid = Bridge.GetCitizenId(src), refType = 'safehouse', refId = h.id, note = h.label })
    if not ok then return false, res end

    h.gangId, h.paidUntil, h.upgrades, h.breachedUntil = gang.id, os.time() + DAY, { spent = h.price }, 0
    save(h)
    registerStash(h)
    publish()
    Gangs.NotifyGang(gang.id, locale('safehouse_bought', h.label), 'success')
    return true
end

function Safehouses.Sell(src, id)
    local gang, err = boss(src)
    if not gang then return false, err end
    local h = houses[tonumber(id)]
    if not h or h.gangId ~= gang.id then return false, 'invalid' end

    local refund = math.floor((h.upgrades.spent or h.price) * cfg.sellRefund)
    emptyHouse(h.id)
    h.gangId, h.paidUntil, h.upgrades, h.breachedUntil = nil, 0, {}, 0
    TriggerEvent('vinewood_gangs:server:safehouseLost', h.id)
    save(h)
    publish()
    if refund > 0 then Ledger.Transact(gang.id, 'clean', refund, 'safehouse_sale', { refType = 'safehouse', refId = h.id, note = h.label }) end
    Gangs.NotifyGang(gang.id, locale('safehouse_sold', h.label, Utils.FormatMoney(refund)), 'inform')
    return true
end

function Safehouses.Upgrade(src, id, kind)
    local gang, err = boss(src)
    if not gang then return false, err end
    local h = houses[tonumber(id)]
    if not h or h.gangId ~= gang.id then return false, 'invalid' end

    local price
    if kind == 'stash' then
        local nextLevel = cfg.upgrades.stash[(h.upgrades.stash or 0) + 1]
        if not nextLevel then return false, 'safehouse_maxed' end
        price = nextLevel.price
    elseif kind == 'cctv' or kind == 'door' then
        if h.upgrades[kind] then return false, 'safehouse_maxed' end
        price = cfg.upgrades[kind].price
    else
        return false, 'invalid'
    end

    local ok, res = Ledger.Transact(gang.id, 'clean', -price, 'safehouse_upgrade', { citizenid = Bridge.GetCitizenId(src), refType = 'safehouse', refId = h.id, note = kind })
    if not ok then return false, res end

    if kind == 'stash' then h.upgrades.stash = (h.upgrades.stash or 0) + 1 else h.upgrades[kind] = true end
    h.upgrades.spent = (h.upgrades.spent or h.price) + price
    save(h)
    registerStash(h)
    return true
end

-------------------------------------------------------------------------------
-- Views
-------------------------------------------------------------------------------

local function upgradeView(h)
    local level = h.upgrades.stash or 0
    local nextStash = cfg.upgrades.stash[level + 1]
    local slots = stashSize(h)
    return {
        stash = { level = level, slots = slots, nextPrice = nextStash and nextStash.price or nil, nextSlots = nextStash and nextStash.slots or nil },
        cctv = { owned = h.upgrades.cctv == true, price = cfg.upgrades.cctv.price },
        door = { owned = h.upgrades.door == true, price = cfg.upgrades.door.price },
    }
end

function Safehouses.GangView(src)
    local gang, m = Gangs.GetPlayerGang(src)
    if not gang then return nil, 'not_in_gang' end
    local now = os.time()
    local mine, available = {}, {}
    for _, h in pairs(houses) do
        local zone = Zones.FromCoords(v3(h.entrance))
        local base = { id = h.id, label = h.label, address = h.address, area = zone and Zones.Label(zone) or nil,
            price = h.price, upkeep = h.upkeep, x = h.entrance.x, y = h.entrance.y }
        if h.gangId == gang.id then
            base.paidFor = h.paidUntil - now
            base.breached = h.breachedUntil > now
            base.upgrades = upgradeView(h)
            base.refund = math.floor((h.upgrades.spent or h.price) * cfg.sellRefund)
            mine[#mine + 1] = base
        elseif not h.gangId then
            available[#available + 1] = base
        end
    end
    table.sort(available, function(a, b) return a.price < b.price end)
    return {
        mine = mine, available = available, isBoss = m.grade == Gangs.TopGrade(gang.id),
        max = cfg.maxPerGang, graceDays = cfg.graceDays,
    }
end

---Used by intelligence leads: an address the police could learn about.
function Safehouses.AddressFor(gangId)
    local list = {}
    for _, h in pairs(houses) do if h.gangId == gangId then list[#list + 1] = h.address end end
    return #list > 0 and list[math.random(#list)] or nil
end

-------------------------------------------------------------------------------
-- Staff
-------------------------------------------------------------------------------

local function validPoint(p)
    return type(p) == 'table' and tonumber(p.x) and tonumber(p.y) and tonumber(p.z)
        and { x = tonumber(p.x), y = tonumber(p.y), z = tonumber(p.z), w = tonumber(p.w) or 0.0 }
end

function Safehouses.AdminCreate(src, data)
    if type(data) ~= 'table' then return false, 'invalid' end
    local label = tostring(data.label or ''):gsub('[<>]', ''):match('^%s*(.-)%s*$'):sub(1, 64)
    local address = tostring(data.address or ''):gsub('[<>]', ''):match('^%s*(.-)%s*$'):sub(1, 128)
    if #label < 2 or #address < 3 then return false, 'invalid_label' end
    local points = {}
    local walkin = data.mode == 'walkin' and not data.shell
    for _, k in ipairs(walkin and { 'entrance', 'stash' } or { 'entrance', 'spawn', 'stash', 'exit' }) do
        points[k] = validPoint(data[k])
        if not points[k] then return false, 'invalid' end
    end
    if walkin then
        -- The MLO's doors: their model and where they are, so every player's game can lock them
        points.mode, points.doors = 'walkin', {}
        for _, d in ipairs(type(data.doors) == 'table' and data.doors or {}) do
            local model, x, y, z = tonumber(d.model), tonumber(d.x), tonumber(d.y), tonumber(d.z)
            if model and x and y and z and #points.doors < 16 then points.doors[#points.doors + 1] = { model = model, x = x, y = y, z = z } end
        end
        if #points.doors == 0 then return false, 'safehouse_need_door' end
    end
    if data.shell then
        if not shellDef(data.shell) then return false, 'safehouse_bad_shell' end
        points.shell = data.shell
        -- Inside points are offsets from the shell, and must actually be inside it
        for _, k in ipairs({ 'spawn', 'stash', 'exit' }) do
            local p = points[k]
            if math.abs(p.x) > 60 or math.abs(p.y) > 60 or math.abs(p.z) > 30 then return false, 'safehouse_bad_shell' end
        end
    end
    local price = math.max(0, math.floor(tonumber(data.price) or 0))
    local upkeep = math.max(0, math.floor(tonumber(data.upkeep) or 0))

    local id = MySQL.insert.await('INSERT INTO vg_safehouses (label, address, points, price, upkeep, created_by) VALUES (?, ?, ?, ?, ?, ?)',
        { label, address, json.encode(points), price, upkeep, Bridge.GetCitizenId(src) or 'console' })
    if not id then return false, 'db_error' end
    houses[id] = { id = id, label = label, address = address, price = price, upkeep = upkeep, gangId = nil, paidUntil = 0,
        upgrades = {}, breachedUntil = 0, entrance = points.entrance, shell = points.shell,
        walkin = points.mode == 'walkin', doors = points.doors }
    houses[id].spawn, houses[id].stash, houses[id].exit = resolve(points)
    publish()
    Logger.Log(src, 'staff_safehouse_created', ('safehouse %d %s'):format(id, label))
    return true, id
end

---Puts staff inside a private copy of a shell so they can mark the spawn, stash and exit.
function Safehouses.AdminShellPreview(src, model)
    local s = shellDef(model)
    if not s then return false, 'safehouse_bad_shell' end
    SetPlayerRoutingBucket(src, cfg.bucketBase + 50000 + src)
    return { model = s.model, origin = cfg.shellOrigin, start = s.start or { x = 0.0, y = 0.0, z = 1.0 } }
end

function Safehouses.AdminShellPreviewEnd(src)
    if not inside[src] then SetPlayerRoutingBucket(src, 0) end
    return true
end

function Safehouses.Shells()
    local list = {}
    for _, s in ipairs(cfg.shells or {}) do list[#list + 1] = { model = s.model, label = s.label } end
    return list
end

function Safehouses.AdminList()
    local list, now = {}, os.time()
    for _, h in pairs(houses) do
        local g = h.gangId and Gangs.Get(h.gangId)
        list[#list + 1] = { id = h.id, label = h.label, address = h.address, price = h.price, upkeep = h.upkeep,
            gang = g and g.label or nil, colour = g and g.colour or nil, paidFor = h.gangId and (h.paidUntil - now) or nil,
            breached = h.breachedUntil > now, shell = h.shell and ((shellDef(h.shell) or {}).label or h.shell) or nil }
    end
    table.sort(list, function(a, b) return a.id < b.id end)
    return list
end

function Safehouses.AdminEvict(src, id)
    local h = houses[tonumber(id)]
    if not h or not h.gangId then return false, 'safehouse_empty' end
    local gangId = h.gangId
    emptyHouse(h.id)
    h.gangId, h.paidUntil, h.upgrades, h.breachedUntil = nil, 0, {}, 0
    TriggerEvent('vinewood_gangs:server:safehouseLost', h.id)
    save(h)
    publish()
    Gangs.NotifyGang(gangId, locale('safehouse_evicted', h.label), 'error')
    Logger.Log(src, 'staff_safehouse_evict', ('safehouse %d evicted gang %d'):format(h.id, gangId))
    return true
end

function Safehouses.AdminDelete(src, id)
    local h = houses[tonumber(id)]
    if not h then return false, 'invalid' end
    emptyHouse(h.id)
    if h.gangId then Gangs.NotifyGang(h.gangId, locale('safehouse_evicted', h.label), 'error') end
    TriggerEvent('vinewood_gangs:server:safehouseLost', h.id)
    houses[h.id] = nil
    MySQL.update.await('DELETE FROM vg_safehouses WHERE id = ?', { h.id })
    publish()
    Logger.Log(src, 'staff_safehouse_deleted', ('safehouse %d deleted'):format(h.id))
    return true
end

function Safehouses.Get(id) return houses[tonumber(id)] end

---Safehouses owned by a gang.
function Safehouses.OwnedBy(gangId)
    local list = {}
    for _, h in pairs(houses) do if h.gangId == gangId then list[#list + 1] = h end end
    table.sort(list, function(a, b) return a.id < b.id end)
    return list
end

function Safehouses.Entrance(id)
    local h = houses[tonumber(id)]
    return h and h.entrance
end

-------------------------------------------------------------------------------
-- Lifecycle
-------------------------------------------------------------------------------

function Safehouses.Load()
    houses = {}
    for _, r in ipairs(MySQL.query.await('SELECT id, label, address, points, price, upkeep, gang_id, paid_until, upgrades, breached_until FROM vg_safehouses')) do
        local ok, pts = pcall(json.decode, r.points)
        local okU, ups = pcall(json.decode, r.upgrades or '{}')
        local walkin = ok and pts and pts.mode == 'walkin'
        if ok and pts and pts.entrance and pts.stash and (walkin or (pts.spawn and pts.exit)) then
            local h = {
                id = r.id, label = r.label, address = r.address, price = r.price, upkeep = r.upkeep,
                gangId = (r.gang_id and Gangs.Get(r.gang_id)) and r.gang_id or nil,
                paidUntil = r.paid_until, upgrades = (okU and type(ups) == 'table') and ups or {},
                breachedUntil = r.breached_until,
                entrance = pts.entrance, shell = pts.shell,
                walkin = walkin or nil, doors = walkin and pts.doors or nil,
            }
            h.spawn, h.stash, h.exit = resolve(pts)
            houses[h.id] = h
            registerStash(h)
        end
    end
    publish()
end

---Daily upkeep from the clean treasury; repossession after the grace period.
local function upkeepTick()
    local now = os.time()
    for _, h in pairs(houses) do
        if h.gangId and now >= h.paidUntil then
            local overdue = now - h.paidUntil
            if h.upkeep == 0 or Ledger.Transact(h.gangId, 'clean', -h.upkeep, 'safehouse_upkeep', { refType = 'safehouse', refId = h.id, note = h.label }) then
                h.paidUntil = h.paidUntil + DAY
                save(h)
            elseif overdue > cfg.graceDays * DAY then
                local gangId = h.gangId
                emptyHouse(h.id)
                h.gangId, h.paidUntil, h.upgrades, h.breachedUntil = nil, 0, {}, 0
    TriggerEvent('vinewood_gangs:server:safehouseLost', h.id)
                save(h)
                publish()
                Gangs.NotifyGang(gangId, locale('safehouse_repossessed', h.label), 'error')
            elseif not warned[h.id] or now - warned[h.id] > DAY / 2 then
                warned[h.id] = now
                Gangs.NotifyGang(h.gangId, locale('safehouse_arrears', h.label, Utils.FormatMoney(h.upkeep)), 'error')
            end
        end
        if h.breachedUntil > 0 and h.breachedUntil <= now then
            h.breachedUntil = 0
            save(h)
            publish()
        end
    end
end

function Safehouses.Start()
    if not Config.Modules.safehouses then return end
    CreateThread(function()
        while true do
            upkeepTick()
            Wait(60000)
        end
    end)
end

AddEventHandler('playerDropped', function()
    inside[source] = nil
end)

AddEventHandler('vinewood_gangs:server:gangDisbanded', function(gangId)
    for _, h in pairs(houses) do
        if h.gangId == gangId then
            emptyHouse(h.id)
            h.gangId, h.paidUntil, h.upgrades, h.breachedUntil = nil, 0, {}, 0
    TriggerEvent('vinewood_gangs:server:safehouseLost', h.id)
            save(h)
        end
    end
    publish()
end)

AddEventHandler('onResourceStop', function(res)
    if res ~= GetCurrentResourceName() then return end
    for src in pairs(inside) do SetPlayerRoutingBucket(src, 0) end
end)
