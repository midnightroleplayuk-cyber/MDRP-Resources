Enterprises = {}

local cfg = Config.Enterprises
local list = {}     -- list[id] = enterprise
local market = {}   -- market[type] = price multiplier
local recent = {}   -- recent[id] = { produced, sold, earned } since the last tick, for the tablet

local function save(e)
    MySQL.prepare('UPDATE vg_enterprises SET level = ?, staff = ?, supplies = ?, product = ?, distribute = ?, last_tick = ? WHERE id = ?',
        { e.level, e.staff, math.floor(e.supplies), math.floor(e.product), e.distribute and 1 or 0, e.lastTick, e.id })
end

local function typeOf(e) return cfg.types[e.type] end

-- Hourly market drift plus any director boom or crash
local function priceMult(kind) return (market[kind] or 1.0) * Director.Mult('price', kind) end

local function zoneOf(e)
    local h = Safehouses.Get(e.safehouseId)
    return h and Zones.FromCoords(vector3(h.entrance.x, h.entrance.y, h.entrance.z)) or nil
end

---Units per hour right now (before running out of supplies or space).
local function hourlyRate(e)
    local t = typeOf(e)
    local level = t.levels[e.level] or t.levels[1]
    return t.rate * level.rate * (1 + e.staff * cfg.staffBonus)
end

function Enterprises.Get(id) return list[tonumber(id)] end

function Enterprises.ForGang(gangId)
    local out = {}
    for _, e in pairs(list) do if e.gangId == gangId then out[#out + 1] = e end end
    table.sort(out, function(a, b) return a.id < b.id end)
    return out
end

function Enterprises.AddSupplies(e, amount)
    local t = typeOf(e)
    local before = e.supplies
    e.supplies = math.min(t.maxSupplies, e.supplies + amount)
    save(e)
    return e.supplies - before
end

-------------------------------------------------------------------------------
-- Production, wages and street sales
-------------------------------------------------------------------------------

local function ownedAreas(gangId)
    local zones = {}
    for zone in pairs(Config.Zones) do
        if Influence.GetOwner(zone) == gangId then zones[#zones + 1] = zone end
    end
    return zones
end

local function tickOne(e, now)
    local t = typeOf(e)
    local hours = math.max(0, (now - e.lastTick) / 3600)
    e.lastTick = now
    if hours <= 0 or not Gangs.Get(e.gangId) then return end
    local stats = { produced = 0, sold = 0, earned = 0, wages = 0 }

    -- Wages first: unpaid staff walk out
    if e.staff > 0 then
        local wages = math.floor(e.staff * t.staffWage * hours)
        if wages > 0 then
            if Ledger.Transact(e.gangId, 'dirty', -wages, 'enterprise_wages', { refType = 'enterprise', refId = e.id, note = t.label }) then
                stats.wages = wages
            else
                e.staff = 0
                Gangs.NotifyGang(e.gangId, locale('enterprise_staff_quit', t.label), 'error')
            end
        end
    end

    -- Production
    local capacity = hourlyRate(e) * hours
    local bySupplies = e.supplies / t.suppliesPerUnit
    local bySpace = t.maxProduct - e.product
    local units = math.max(0, math.min(capacity, bySupplies, bySpace))
    if units > 0 then
        e.supplies = e.supplies - units * t.suppliesPerUnit
        e.product = e.product + units
        stats.produced = units
        Heat.Add(e.gangId, nil, units * t.heatPerUnit, zoneOf(e))
    end

    -- Street distribution across the areas the gang holds
    if e.distribute and t.street and e.product >= 1 then
        local areas = ownedAreas(e.gangId)
        if #areas > 0 then
            local perArea = math.min(cfg.streetPerArea * hours, e.product / #areas)
            for _, zone in ipairs(areas) do
                local sold = math.floor(perArea)
                if sold > 0 then
                    e.product = e.product - sold
                    local value = math.floor(sold * t.street * priceMult(e.type))
                    Ledger.Transact(e.gangId, 'dirty', value, 'street_sales', { refType = 'enterprise', refId = e.id, note = Zones.Label(zone) })
                    Progression.Count(e.gangId, 'enterprise_income', value)
                    Activity.Record({ type = 'drug_sale', gangId = e.gangId, zone = zone, multiplier = sold / 10, metadata = { enterprise = e.id, units = sold } })
                    stats.sold = stats.sold + sold
                    stats.earned = stats.earned + value
                end
            end
        end
    end

    recent[e.id] = stats
    save(e)
end

local function tickAll()
    local now = os.time()
    for _, e in pairs(list) do tickOne(e, now) end
end

local function moveMarket()
    for key in pairs(cfg.types) do
        local swing = cfg.marketSwing
        -- Drift towards normal, with a random nudge
        local current = market[key] or 1.0
        local nudge = (math.random() * 2 - 1) * swing * 0.6
        market[key] = math.max(1 - swing, math.min(1 + swing, current + (1.0 - current) * 0.3 + nudge))
    end
end

-------------------------------------------------------------------------------
-- Managing (enterprise_manage permission; set-up and equipment come from the clean treasury)
-------------------------------------------------------------------------------

local function manager(src)
    local gang, _, cid = Gangs.GetPlayerGang(src)
    if not gang then return nil, 'not_in_gang' end
    if not Gangs.HasPermission(cid, 'enterprise_manage') then return nil, 'no_permission' end
    return gang, cid
end

local function ownEnterprise(src, id)
    local gang, cid = manager(src)
    if not gang then return nil, cid end
    local e = list[tonumber(id)]
    if not e or e.gangId ~= gang.id then return nil, 'invalid' end
    tickOne(e, os.time()) -- bring it up to date before changing anything
    return e, gang, cid
end

function Enterprises.Setup(src, safehouseId, kind)
    local gang, cid = manager(src)
    if not gang then return false, cid end
    local t = cfg.types[kind]
    local h = Safehouses.Get(safehouseId)
    if not t or not h or h.gangId ~= gang.id then return false, 'invalid' end
    if not Progression.Has(gang.id, 'enterprises') then return false, 'tier_locked' end
    for _, e in pairs(list) do
        if e.safehouseId == h.id then return false, 'enterprise_exists' end
    end

    local ok, res = Ledger.Transact(gang.id, 'clean', -t.setup, 'enterprise_setup', { citizenid = cid, refType = 'safehouse', refId = h.id, note = t.label })
    if not ok then return false, res end

    local now = os.time()
    local id = MySQL.insert.await('INSERT INTO vg_enterprises (gang_id, safehouse_id, type, last_tick) VALUES (?, ?, ?, ?)', { gang.id, h.id, kind, now })
    if not id then
        Ledger.Transact(gang.id, 'clean', t.setup, 'enterprise_setup_refund', { refType = 'safehouse', refId = h.id })
        return false, 'db_error'
    end
    list[id] = { id = id, gangId = gang.id, safehouseId = h.id, type = kind, level = 1, staff = 0, supplies = 0, product = 0, distribute = false, lastTick = now }
    Gangs.NotifyGang(gang.id, locale('enterprise_set_up', t.label, h.label), 'success')
    Logger.Log(src, 'enterprise_setup', ('%s set up %s in safehouse %d'):format(cid, kind, h.id))
    return true
end

function Enterprises.Upgrade(src, id)
    local e, gang, cid = ownEnterprise(src, id)
    if not e then return false, gang end
    local t = typeOf(e)
    local nextLevel = t.levels[e.level + 1]
    if not nextLevel then return false, 'safehouse_maxed' end
    local ok, res = Ledger.Transact(gang.id, 'clean', -nextLevel.price, 'enterprise_upgrade', { citizenid = cid, refType = 'enterprise', refId = e.id, note = t.label })
    if not ok then return false, res end
    e.level = e.level + 1
    save(e)
    return true
end

function Enterprises.SetStaff(src, id, count)
    local e, gang = ownEnterprise(src, id)
    if not e then return false, gang end
    count = math.floor(tonumber(count) or -1)
    if count < 0 or count > cfg.maxStaff then return false, 'invalid' end
    e.staff = count
    save(e)
    return true
end

function Enterprises.SetDistribution(src, id, on)
    local e, gang = ownEnterprise(src, id)
    if not e then return false, gang end
    if on and not typeOf(e).street then return false, 'enterprise_no_street' end
    e.distribute = on == true
    save(e)
    return true
end

function Enterprises.SellWholesale(src, id, amount)
    local e, gang, cid = ownEnterprise(src, id)
    if not e then return false, gang end
    local t = typeOf(e)
    amount = math.floor(tonumber(amount) or 0)
    if amount <= 0 then return false, 'invalid_amount' end
    if amount > math.floor(e.product) then return false, 'enterprise_not_enough' end

    local value = math.floor(amount * t.wholesale * priceMult(e.type))
    e.product = e.product - amount
    save(e)
    Ledger.Transact(gang.id, 'dirty', value, 'wholesale', { citizenid = cid, refType = 'enterprise', refId = e.id, note = ('%d %s'):format(amount, t.product) })
    Progression.Count(gang.id, 'enterprise_income', value)
    -- Moving weight attracts attention
    Heat.Add(gang.id, cid, amount * t.heatPerUnit * 0.5, zoneOf(e))
    return true, value
end

---Which dealing item a business's stock bags up into (config/drugs.lua), if any.
local function dealItem(e)
    if not Config.Drugs or not Config.Drugs.enabled then return nil end
    for _, d in ipairs(Config.Drugs.items) do
        if d.enterprise == e.type then return d end
    end
end

---Takes stock out of the business as items in the player's own inventory, for street dealing.
function Enterprises.BagUp(src, id, amount)
    local e, gang, cid = ownEnterprise(src, id)
    if not e then return false, gang end
    local d = dealItem(e)
    if not d then return false, 'enterprise_no_bagging' end
    amount = math.floor(tonumber(amount) or 0)
    if amount < 1 or amount > 50 then return false, 'invalid_amount' end
    if amount > math.floor(e.product) then return false, 'enterprise_not_enough' end
    if not Bridge.AddItem(src, d.item, amount) then return false, 'auction_cant_carry' end
    e.product = e.product - amount
    save(e)
    Logger.Log(src, 'enterprise_bag_up', ('%s bagged up %d %s from enterprise %d'):format(cid, amount, d.item, e.id))
    return true, amount
end

function Enterprises.Close(src, id)
    local e, gang, cid = ownEnterprise(src, id)
    if not e then return false, gang end
    list[e.id] = nil
    recent[e.id] = nil
    MySQL.update.await('DELETE FROM vg_enterprises WHERE id = ?', { e.id })
    TriggerEvent('vinewood_gangs:server:enterpriseClosed', e.id)
    Logger.Log(src, 'enterprise_closed', ('%s closed enterprise %d'):format(cid, e.id))
    return true
end

-------------------------------------------------------------------------------
-- Tablet view
-------------------------------------------------------------------------------

local function marketWord(m)
    if m >= 1.07 then return 'high' end
    if m <= 0.93 then return 'low' end
    return 'normal'
end

function Enterprises.View(e)
    local t = typeOf(e)
    local h = Safehouses.Get(e.safehouseId)
    local nextLevel = t.levels[e.level + 1]
    local m = priceMult(e.type)
    local stats = recent[e.id] or {}
    return {
        id = e.id, type = e.type, label = t.label, product = t.product, suppliesName = t.supplies,
        safehouse = h and h.label or '?',
        level = e.level, maxLevel = #t.levels, nextPrice = nextLevel and nextLevel.price or nil,
        staff = e.staff, maxStaff = cfg.maxStaff, staffWage = t.staffWage,
        supplies = math.floor(e.supplies), maxSupplies = t.maxSupplies,
        stock = math.floor(e.product), maxProduct = t.maxProduct,
        rate = math.floor(hourlyRate(e) + 0.5), suppliesPerUnit = t.suppliesPerUnit,
        wholesale = math.floor(t.wholesale * m), street = t.street and math.floor(t.street * m) or nil,
        market = marketWord(m), distribute = e.distribute,
        lastSold = stats.sold and math.floor(stats.sold) or 0, lastEarned = stats.earned or 0,
        supplyCost = t.supplyCost,
        bagItem = dealItem(e) and dealItem(e).label or nil,
    }
end

function Enterprises.GangView(src)
    local gang, _, cid = Gangs.GetPlayerGang(src)
    if not gang then return nil, 'not_in_gang' end
    local now = os.time()
    local mine = {}
    for _, e in pairs(list) do
        if e.gangId == gang.id then
            tickOne(e, now)
            mine[#mine + 1] = Enterprises.View(e)
        end
    end
    table.sort(mine, function(a, b) return a.id < b.id end)

    local free = {}
    for _, h in ipairs(Safehouses.OwnedBy(gang.id)) do
        local used = false
        for _, e in pairs(list) do if e.safehouseId == h.id then used = true break end end
        if not used then free[#free + 1] = { id = h.id, label = h.label } end
    end

    local types = {}
    for key, t in pairs(cfg.types) do
        types[#types + 1] = { key = key, label = t.label, setup = t.setup, product = t.product, street = t.street ~= nil, rate = t.rate }
    end
    table.sort(types, function(a, b) return a.setup < b.setup end)

    return {
        enterprises = mine, freeSafehouses = free, types = types,
        canManage = Gangs.HasPermission(cid, 'enterprise_manage'),
        areasHeld = #ownedAreas(gang.id), streetPerArea = cfg.streetPerArea,
        shipments = Supply and Supply.GangShipments(gang.id) or {},
        supply = { markup = Config.Supply.deliveryMarkup, minutes = Config.Supply.deliveryMinutes, seizure = Config.Supply.seizureChance },
    }
end

function Enterprises.AdminList()
    local out = {}
    for _, e in pairs(list) do
        local g = Gangs.Get(e.gangId)
        local v = Enterprises.View(e)
        v.gang, v.colour = g and g.label or '?', g and g.colour
        out[#out + 1] = v
    end
    table.sort(out, function(a, b) return a.id < b.id end)
    return out
end

function Enterprises.AdminClose(src, id)
    local e = list[tonumber(id)]
    if not e then return false, 'invalid' end
    list[e.id] = nil
    MySQL.update.await('DELETE FROM vg_enterprises WHERE id = ?', { e.id })
    TriggerEvent('vinewood_gangs:server:enterpriseClosed', e.id)
    Gangs.NotifyGang(e.gangId, locale('enterprise_closed_staff', typeOf(e).label), 'error')
    Logger.Log(src, 'staff_enterprise_closed', ('enterprise %d closed'):format(e.id))
    return true
end

-------------------------------------------------------------------------------
-- Lifecycle and hooks
-------------------------------------------------------------------------------

function Enterprises.Load()
    list = {}
    for _, r in ipairs(MySQL.query.await('SELECT id, gang_id, safehouse_id, type, level, staff, supplies, product, distribute, last_tick FROM vg_enterprises')) do
        local h = Safehouses.Get(r.safehouse_id)
        if cfg.types[r.type] and h and h.gangId == r.gang_id then
            list[r.id] = {
                id = r.id, gangId = r.gang_id, safehouseId = r.safehouse_id, type = r.type,
                level = math.min(r.level, #cfg.types[r.type].levels), staff = math.min(r.staff, cfg.maxStaff),
                supplies = r.supplies, product = r.product, distribute = r.distribute == 1 or r.distribute == true,
                lastTick = r.last_tick > 0 and r.last_tick or os.time(),
            }
        end
    end
    for key in pairs(cfg.types) do market[key] = 1.0 end
end

function Enterprises.Start()
    if not Config.Modules.enterprises then return end
    CreateThread(function()
        while true do
            Wait(cfg.tickMinutes * 60000)
            tickAll()
        end
    end)
    CreateThread(function()
        while true do
            moveMarket()
            Wait(cfg.marketMinutes * 60000)
        end
    end)
end

-- The safehouse went: so does whatever was running in it
AddEventHandler('vinewood_gangs:server:safehouseLost', function(safehouseId)
    for id, e in pairs(list) do
        if e.safehouseId == safehouseId then
            list[id] = nil
            MySQL.update('DELETE FROM vg_enterprises WHERE id = ?', { id })
            TriggerEvent('vinewood_gangs:server:enterpriseClosed', id)
            if Gangs.Get(e.gangId) then Gangs.NotifyGang(e.gangId, locale('enterprise_lost', typeOf(e).label), 'error') end
        end
    end
end)

-- Police raid the safehouse: stock is seized
AddEventHandler('vinewood_gangs:server:safehouseRaided', function(safehouseId, gangId)
    for _, e in pairs(list) do
        if e.safehouseId == safehouseId then
            tickOne(e, os.time())
            local product = math.floor(e.product * cfg.raidSeizure.product)
            local supplies = math.floor(e.supplies * cfg.raidSeizure.supplies)
            e.product, e.supplies, e.staff = e.product - product, e.supplies - supplies, 0
            save(e)
            Gangs.NotifyGang(gangId, locale('enterprise_seized', product, typeOf(e).product), 'error')
            Logger.Log(0, 'enterprise_seized', ('enterprise %d: %d product, %d supplies seized'):format(e.id, product, supplies))
        end
    end
end)
