Rackets = {}

local cfg = Config.Rackets
local byKey = {}
for _, b in ipairs(cfg.businesses) do byKey[b.key] = b end

local state = {}     -- state[key] = { gangId, owed, since, lastAccrual, lastCollected }
local cooldowns = {} -- cooldowns[key][gangId] = os.time() it ends

local function period() return cfg.collectMinutes * 60 end
local function zoneOf(b) return Zones.FromCoords(b.coords) end
local function near(src, b, range) return #(GetEntityCoords(GetPlayerPed(src)) - b.coords) <= (range or 5.0) end

local function save(key)
    local s = state[key]
    if not s then
        MySQL.prepare('DELETE FROM vg_rackets WHERE business = ?', { key })
        return
    end
    MySQL.prepare([[
        INSERT INTO vg_rackets (business, gang_id, owed, since, last_accrual, last_collected)
        VALUES (?, ?, ?, ?, ?, ?)
        ON DUPLICATE KEY UPDATE gang_id = VALUES(gang_id), owed = VALUES(owed), since = VALUES(since),
            last_accrual = VALUES(last_accrual), last_collected = VALUES(last_collected)
    ]], { key, s.gangId, s.owed, s.since, s.lastAccrual, s.lastCollected })
end

---Brings what a business owes up to date.
local function accrue(key)
    local s = state[key]
    if not s then return nil end
    local steps = math.floor((os.time() - s.lastAccrual) / period())
    if steps > 0 then
        local b = byKey[key]
        s.owed = math.min(b.income * cfg.maxOwedPeriods, s.owed + steps * b.income)
        s.lastAccrual = s.lastAccrual + steps * period()
        save(key)
    end
    return s
end

local function drop(key, reasonLocale)
    local s = state[key]
    if not s then return end
    state[key] = nil
    save(key)
    if reasonLocale and Gangs.Get(s.gangId) then
        Gangs.NotifyGang(s.gangId, locale(reasonLocale, byKey[key].label), 'error')
    end
end

---Chance the owner agrees, and a word for how it looks.
local function odds(gangId, b, intimidate)
    local o = cfg.odds
    local zone = zoneOf(b)
    local influence = zone and Influence.Get(zone, gangId) or 0
    local p = o.base + o.influence * math.min(1.0, influence / Config.Influence.captureThreshold)
    if zone and Influence.GetOwner(zone) == gangId then p = p + o.holdsArea end
    if intimidate then p = p + o.intimidate end
    local s = state[b.key]
    if s and s.gangId ~= gangId then p = p + o.rival end
    p = math.max(o.min, math.min(o.max, p))
    local word = p >= 0.6 and 'good' or (p >= 0.35 and 'fair' or 'slim')
    return p, word
end

---Why this gang can't approach the business right now, if anything.
local function blocker(gangId, b)
    if not Progression.Has(gangId, 'rackets') then return 'tier_locked' end
    local zone = zoneOf(b)
    if not zone then return 'racket_no_area' end
    local influence = Influence.Get(zone, gangId)
    if influence < cfg.minInfluence then return 'racket_low_influence' end
    local current = state[b.key]
    if current and current.gangId ~= gangId and Relations.IsProtected(gangId, current.gangId, zone) then
        return 'diplomacy_protected'
    end
    local cd = cooldowns[b.key] and cooldowns[b.key][gangId]
    if cd and cd > os.time() then return 'racket_cooldown' end
    local s = state[b.key]
    if s and s.gangId ~= gangId and cfg.takeoverNeedsLead and Influence.Get(zone, s.gangId) >= influence then
        return 'racket_rival_stronger'
    end
    return nil
end

local function policeReport(b, gangId, title, description, chance)
    if Bridge.Dispatch.Witness(chance, { title = title, code = 'EXTORTION', priority = 2, coords = b.coords, description = description }) then
        local zone = zoneOf(b)
        Intel.CreateLead({
            gangId = gangId, source = 'witness', zone = zone, precision = 'area',
            summary = ('Business owner at %s reports being pressured for protection money.'):format(b.label),
        })
    end
end

-------------------------------------------------------------------------------
-- Player actions
-------------------------------------------------------------------------------

local function actor(src, key)
    local gang, _, cid = Gangs.GetPlayerGang(src)
    if not gang then return nil, 'not_in_gang' end
    if not Gangs.HasPermission(cid, 'rackets') then return nil, 'no_permission' end
    local b = byKey[key]
    if not b then return nil, 'invalid' end
    if not near(src, b) then return nil, 'too_far' end
    return gang, cid, b
end

function Rackets.Info(src, key)
    local gang, cid, b = actor(src, key)
    if not gang then return nil, cid end
    local s = accrue(key)
    local zone = zoneOf(b)
    local protector = s and Gangs.Get(s.gangId)
    local mine = s and s.gangId == gang.id

    local info = {
        key = key, label = b.label, area = zone and Zones.Label(zone) or nil,
        mine = mine, protectedBy = (not mine and protector) and protector.label or nil,
        income = b.income, minutes = cfg.collectMinutes,
    }
    if mine then
        info.owed = s.owed
    else
        info.blocked = blocker(gang.id, b)
        if info.blocked == 'racket_cooldown' then
            info.cooldown = math.ceil((cooldowns[key][gang.id] - os.time()) / 60)
        end
        local _, word = odds(gang.id, b, false)
        info.odds = word
    end
    return info
end

function Rackets.Offer(src, key, intimidate)
    local gang, cid, b = actor(src, key)
    if not gang then return false, cid end
    local s = state[key]
    if s and s.gangId == gang.id then return false, 'racket_already_ours' end
    local blocked = blocker(gang.id, b)
    if blocked then return false, blocked end

    local zone = zoneOf(b)
    if intimidate then
        Activity.Record({ type = 'intimidation', gangId = gang.id, citizenid = cid, zone = zone, coords = b.coords, metadata = { business = key } })
    end

    local p = odds(gang.id, b, intimidate)
    if math.random() < p then
        local rival = s and s.gangId ~= gang.id and s.gangId or nil
        local now = os.time()
        state[key] = { gangId = gang.id, owed = 0, since = now, lastAccrual = now, lastCollected = now }
        save(key)

        if rival then
            Activity.Record({ type = 'racket_takeover', gangId = gang.id, citizenid = cid, zone = zone, coords = b.coords, targetGangId = rival,
                multiplier = Relations.HostileMultiplier(gang.id, rival), metadata = { business = key } })
            Gangs.NotifyGang(rival, locale('racket_taken_from_you', gang.label, b.label), 'error')
        else
            Activity.Record({ type = 'racket_agreed', gangId = gang.id, citizenid = cid, zone = zone, coords = b.coords, metadata = { business = key } })
        end
        Gangs.NotifyGang(gang.id, locale('racket_new_gang', b.label), 'success')
        Logger.Log(src, 'racket_agreed', ('%s got %s for gang %d%s'):format(cid, key, gang.id, rival and (' from ' .. rival) or ''))
        return true, rival and 'taken_over' or 'agreed'
    end

    cooldowns[key] = cooldowns[key] or {}
    cooldowns[key][gang.id] = os.time() + cfg.cooldownMinutes * 60
    Activity.Record({ type = 'racket_refused', gangId = gang.id, citizenid = cid, zone = zone, coords = b.coords, metadata = { business = key } })
    policeReport(b, gang.id, 'Extortion', 'Shop owner reports a group demanding protection money.',
        cfg.policeOnRefusal + (intimidate and cfg.policeIntimidate or 0))
    return true, 'refused'
end

function Rackets.Collect(src, key)
    local gang, cid, b = actor(src, key)
    if not gang then return false, cid end
    local s = accrue(key)
    if not s or s.gangId ~= gang.id then return false, 'racket_not_ours' end
    if s.owed <= 0 then return false, 'racket_nothing_owed' end

    local amount = s.owed
    local ok = Ledger.Transact(gang.id, 'dirty', amount, 'racket_payment', { citizenid = cid, refType = 'business', refId = key, note = b.label })
    if not ok then return false, 'failed' end

    s.owed, s.lastCollected = 0, os.time()
    save(key)
    Progression.Count(gang.id, 'racket_income', amount)
    Activity.Record({ type = 'racket_payment', gangId = gang.id, citizenid = cid, zone = zoneOf(b), coords = b.coords,
        multiplier = amount / b.income, metadata = { business = key, amount = amount } })
    policeReport(b, gang.id, 'Extortion (report)', 'Shop owner calls in after paying a gang for protection.', cfg.reportOnCollect)
    return true, amount
end

function Rackets.Drop(src, key)
    local gang, _, cid = Gangs.GetPlayerGang(src)
    if not gang then return false, 'not_in_gang' end
    if not Gangs.HasPermission(cid, 'rackets') then return false, 'no_permission' end
    local s = state[key]
    if not s or s.gangId ~= gang.id then return false, 'racket_not_ours' end
    drop(key)
    return true
end

---For the tablet: what the gang protects and where else it could try.
function Rackets.GangView(src)
    local gang, _, cid = Gangs.GetPlayerGang(src)
    if not gang then return nil, 'not_in_gang' end

    local mine, prospects = {}, {}
    local now = os.time()
    for _, b in ipairs(cfg.businesses) do
        local s = accrue(b.key)
        local zone = zoneOf(b)
        local entry = { key = b.key, label = b.label, area = zone and Zones.Label(zone) or nil, income = b.income, x = b.coords.x, y = b.coords.y }
        if s and s.gangId == gang.id then
            entry.owed = s.owed
            entry.full = s.owed >= b.income * cfg.maxOwedPeriods
            entry.lastCollected = now - s.lastCollected
            entry.lapsesIn = math.max(0, cfg.lapsePeriods * period() - (now - s.lastCollected))
            mine[#mine + 1] = entry
        elseif zone and Influence.Get(zone, gang.id) >= cfg.minInfluence then
            local protector = s and Gangs.Get(s.gangId)
            entry.protectedBy = protector and protector.label or nil
            local _, word = odds(gang.id, b, false)
            entry.odds = word
            entry.blocked = blocker(gang.id, b)
            prospects[#prospects + 1] = entry
        end
    end
    table.sort(mine, function(a, b) return a.owed > b.owed end)

    return {
        mine = mine, prospects = prospects,
        canWork = Gangs.HasPermission(cid, 'rackets'),
        minutes = cfg.collectMinutes, maxPeriods = cfg.maxOwedPeriods, minInfluence = cfg.minInfluence,
    }
end

-------------------------------------------------------------------------------
-- Staff
-------------------------------------------------------------------------------

---An outside crew took its cut: everything owed in the area is gone.
function Rackets.WipeOwedInZone(zone)
    for key, s in pairs(state) do
        if zoneOf(byKey[key]) == zone and s.owed > 0 then
            s.owed = 0
            s.lastAccrual = os.time()
            save(key)
        end
    end
end

function Rackets.ProtectedBy(gangId)
    local out = {}
    for key, s in pairs(state) do
        if s.gangId == gangId then out[#out + 1] = byKey[key].label end
    end
    table.sort(out)
    return out
end

function Rackets.AdminList()
    local list = {}
    for _, b in ipairs(cfg.businesses) do
        local s = accrue(b.key)
        local g = s and Gangs.Get(s.gangId)
        local zone = zoneOf(b)
        list[#list + 1] = {
            key = b.key, label = b.label, area = zone and Zones.Label(zone) or nil, income = b.income, added = b.added == true,
            gang = g and g.label or nil, colour = g and g.colour or nil, owed = s and s.owed or 0,
            since = s and (os.time() - s.since) or nil,
        }
    end
    return list
end

function Rackets.AdminRelease(key, actorSrc)
    if not state[key] then return false, 'racket_not_protected' end
    drop(key, 'racket_released_staff')
    Logger.Log(actorSrc or 0, 'staff_racket_release', ('%s released'):format(key))
    return true
end

-------------------------------------------------------------------------------
-- Lifecycle
-------------------------------------------------------------------------------

-------------------------------------------------------------------------------
-- Shops added in game
-------------------------------------------------------------------------------

---Every client gets the full shop list (built-in plus added) for the "talk business" prompts.
local function publishShops()
    local list = {}
    for _, b in ipairs(cfg.businesses) do
        list[#list + 1] = { key = b.key, label = b.label, x = b.coords.x, y = b.coords.y, z = b.coords.z }
    end
    GlobalState.vg_racket_shops = list
end

local function loadAddedShops()
    for i = #cfg.businesses, 1, -1 do
        if cfg.businesses[i].added then
            byKey[cfg.businesses[i].key] = nil
            table.remove(cfg.businesses, i)
        end
    end
    for _, r in ipairs(MySQL.query.await('SELECT shop, label, income, x, y, z FROM vg_racket_shops')) do
        if not byKey[r.shop] then
            local b = { key = r.shop, label = r.label, income = r.income, added = true,
                coords = vector3(tonumber(r.x), tonumber(r.y), tonumber(r.z)) }
            table.insert(cfg.businesses, b)
            byKey[b.key] = b
        end
    end
end

---Adds a shop at the counter the staff member is standing at.
function Rackets.AdminAddShop(src, label, income)
    label = tostring(label or ''):gsub('[<>]', ''):match('^%s*(.-)%s*$'):sub(1, 64)
    if #label < 2 then return false, 'invalid_label' end
    income = math.floor(tonumber(income) or 0)
    if income < 50 or income > 5000 then return false, 'racket_bad_rate' end

    local c = GetEntityCoords(GetPlayerPed(src))
    for _, b in ipairs(cfg.businesses) do
        if #(b.coords - c) < 3.0 then return false, 'racket_shop_too_close' end
    end

    local base = 'shop_' .. label:lower():gsub('[^%w]+', '_'):gsub('^_+', ''):gsub('_+$', ''):sub(1, 36)
    local key, n = base, 1
    while byKey[key] do
        n = n + 1
        key = ('%s_%d'):format(base, n)
    end

    local pos = vector3(math.floor(c.x * 100 + 0.5) / 100, math.floor(c.y * 100 + 0.5) / 100, math.floor(c.z * 100 + 0.5) / 100)
    local ok = MySQL.insert.await('INSERT INTO vg_racket_shops (shop, label, income, x, y, z, created_by) VALUES (?, ?, ?, ?, ?, ?, ?)',
        { key, label, income, pos.x, pos.y, pos.z, Bridge.GetCitizenId(src) or 'console' })
    if not ok then return false, 'db_error' end

    local b = { key = key, label = label, income = income, coords = pos, added = true }
    table.insert(cfg.businesses, b)
    byKey[key] = b
    publishShops()
    Logger.Log(src, 'staff_racket_shop', ('added shop %s (%s) at %.1f, %.1f'):format(key, label, pos.x, pos.y))
    local zone = zoneOf(b)
    return true, zone and Zones.Label(zone) or false
end

---Removes a shop added in game (and any protection on it).
function Rackets.AdminDeleteShop(src, key)
    local b = byKey[tostring(key)]
    if not b or not b.added then return false, 'invalid' end
    if state[b.key] then drop(b.key, 'racket_released_staff') end
    for i, x in ipairs(cfg.businesses) do
        if x.key == b.key then table.remove(cfg.businesses, i) break end
    end
    byKey[b.key] = nil
    MySQL.update.await('DELETE FROM vg_racket_shops WHERE shop = ?', { b.key })
    publishShops()
    Logger.Log(src, 'staff_racket_shop_deleted', ('deleted shop %s'):format(b.key))
    return true
end

function Rackets.ShopCoords(key)
    local b = byKey[tostring(key)]
    if not b then return nil end
    return { x = b.coords.x, y = b.coords.y, z = b.coords.z, w = 0.0 }
end

function Rackets.Load()
    loadAddedShops()
    publishShops()
    state = {}
    for _, r in ipairs(MySQL.query.await('SELECT business, gang_id, owed, since, last_accrual, last_collected FROM vg_rackets WHERE gang_id IS NOT NULL')) do
        if byKey[r.business] and Gangs.Get(r.gang_id) then
            state[r.business] = { gangId = r.gang_id, owed = r.owed, since = r.since, lastAccrual = r.last_accrual, lastCollected = r.last_collected }
        end
    end
end

---Businesses stop paying when nobody collects or the gang loses its grip on the area.
local function review()
    local now = os.time()
    for key in pairs(state) do
        local s = accrue(key)
        local b = byKey[key]
        local zone = zoneOf(b)
        if not Gangs.Get(s.gangId) then
            drop(key)
        elseif now - s.lastCollected > cfg.lapsePeriods * period() then
            drop(key, 'racket_lapsed')
        elseif not zone or Influence.Get(zone, s.gangId) < cfg.dropBelow then
            drop(key, 'racket_lost_grip')
        end
    end
end

function Rackets.Start()
    if not Config.Modules.rackets then return end
    CreateThread(function()
        while true do
            Wait(5 * 60000)
            review()
        end
    end)
end

AddEventHandler('vinewood_gangs:server:gangDisbanded', function(gangId)
    for key, s in pairs(state) do
        if s.gangId == gangId then drop(key) end
    end
end)
