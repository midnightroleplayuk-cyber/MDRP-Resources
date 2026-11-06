Drugs = {}

local cfg = Config.Drugs
local items = cfg.items -- what can be sold right now (staff edit this in /gangadmin > Street dealing)
local lastOffer = {}  -- lastOffer[src] = os.time() of their last offer
local perHour = {}    -- perHour[src] = { start, count }
local zoneSales = {}  -- zoneSales[zone] = { timestamps of sales in the last hour }
local turfNoticed = {} -- turfNoticed[zone .. ':' .. gangId] = when that gang was last told

local function now() return os.time() end

local function recentSales(zone)
    local list, cutoff = zoneSales[zone] or {}, now() - 3600
    for i = #list, 1, -1 do if list[i] < cutoff then table.remove(list, i) end end
    zoneSales[zone] = list
    return #list
end

---Why this player can't deal right now (nil if they can).
local function blocker(src)
    if not cfg.enabled then return 'invalid' end
    local gang, _, cid = Gangs.GetPlayerGang(src)
    if cfg.gangOnly then
        if not gang then return 'not_in_gang' end
        if not Gangs.HasPermission(cid, 'sell_drugs') then return 'no_permission' end
    end
    local zone = Zones.FromCoords(GetEntityCoords(GetPlayerPed(src)))
    if not zone and cfg.onlyInAreas then return 'drugs_no_area' end
    return nil, gang, cid, zone
end

---The most valuable drug the player is carrying, and how many.
local function bestHeld(src)
    local best, bestCount
    for _, d in ipairs(items) do
        local n = Bridge.GetItemCount(src, d.item)
        if n > 0 and (not best or d.price[2] > best.price[2]) then best, bestCount = d, n end
    end
    return best, bestCount
end

---For the client: can I deal here, and with what? (Used to show the prompt only when it makes sense.)
function Drugs.Status(src)
    local why = blocker(src)
    if why then return { canSell = false, reason = why } end
    local item, count = bestHeld(src)
    if not item then return { canSell = false, reason = 'drugs_none' } end
    return { canSell = true, label = item.label, count = count }
end

local function areaOdds(gang, zone)
    local owner = zone and Influence.GetOwner(zone)
    local own = gang and owner == gang.id
    local rival = gang and owner and owner ~= gang.id and not Relations.IsProtected(gang.id, owner, zone)
    return own, rival and owner or nil
end

function Drugs.Sell(src)
    local why, gang, cid, zone = blocker(src)
    if why then return false, why end

    local t = now()
    if lastOffer[src] and t - lastOffer[src] < cfg.cooldown then return false, 'drugs_slow_down' end
    local ph = perHour[src]
    if not ph or t - ph.start >= 3600 then ph = { start = t, count = 0 } perHour[src] = ph end
    if ph.count >= cfg.maxPerHour then return false, 'drugs_hour_cap' end
    lastOffer[src] = t

    local item, held = bestHeld(src)
    if not item then return false, 'drugs_none' end
    local qty = math.min(held, math.random(1, item.max))
    local pos = GetEntityCoords(GetPlayerPed(src))
    local own, rivalOwner = areaOdds(gang, zone)
    local busy = zone and recentSales(zone) or 0
    local saturated = math.min(1.0, busy / cfg.saturation) -- 0 = fresh corner, 1 = worked to death

    -- 1. The buyer is a copper
    if math.random() < cfg.undercover then
        Bridge.RemoveItem(src, item.item, qty)
        if gang then Heat.Add(gang.id, cid, cfg.undercoverHeat, zone) end
        Bridge.Dispatch.Alert({ title = 'Undercover officer: drug deal', code = 'POSS', priority = 1, coords = pos,
            description = ('Plain-clothes officer approached by a dealer selling %s.'):format(item.label) })
        if gang then
            Intel.CreateLead({ gangId = gang.id, citizenid = cid, source = 'surveillance', precision = 'exact', zone = zone, force = true,
                summary = ('An undercover officer was offered %s by a member of %s.'):format(item.label, gang.label) })
        end
        Logger.Log(src, 'drugs_undercover', ('%s caught by an undercover officer with %d %s'):format(cid or '?', qty, item.item))
        return true, { result = 'undercover', label = item.label, qty = qty }
    end

    -- 2. Do they want it?
    -- A worked-out corner halves the odds (and the price, below)
    local accept = (cfg.accept + (own and cfg.ownArea or 0) + (rivalOwner and cfg.rivalArea or 0)) * (1 - saturated * 0.5)
    if math.random() >= math.max(0.05, accept) then
        local snitched = math.random() < cfg.snitch and Bridge.Dispatch.Witness(1.0, {
            title = 'Drug dealing', code = 'POSS', priority = 2, coords = pos, approximate = true,
            description = 'Caller says someone just tried to sell them drugs in the street.' })
        return true, { result = snitched and 'snitched' or 'declined' }
    end

    -- 3. Sold
    if not Bridge.RemoveItem(src, item.item, qty) then return false, 'drugs_none' end
    local zoneValue = zone and Config.Zones[zone] and Config.Zones[zone].value or 1.0
    local market = item.enterprise and Director.Mult('price', item.enterprise) or 1.0
    local each = math.random(item.price[1], item.price[2]) * zoneValue * market * (1 - saturated * 0.5)
    local total = math.floor(each * qty)
    local cut = gang and math.floor(total * cfg.gangCut) or 0
    if total - cut > 0 then Bridge.AddMoney(src, cfg.moneyType, total - cut, 'street-dealing') end
    if cut > 0 then Ledger.Transact(gang.id, 'dirty', cut, 'street_dealing', { citizenid = cid, note = Zones.Label(zone) }) end

    ph.count = ph.count + 1
    if zone then table.insert(zoneSales[zone], t) end

    if gang then
        Activity.Record({ type = 'drug_sale', gangId = gang.id, citizenid = cid, zone = zone, coords = pos,
            multiplier = qty, targetGangId = rivalOwner, metadata = { item = item.item, qty = qty, paid = total } })
        -- Hex turf: the turf drug on your own hex builds control; dealing on a rival's costs them and reveals it
        if zone and Hex.Enabled() then Hexes.OnSale(zone, gang.id, item.item, qty) end
    end

    -- Someone might ring it in, more so on a rival's patch (and during a crackdown)
    Bridge.Dispatch.Witness(cfg.police + (rivalOwner and cfg.policeRival or 0), {
        title = 'Drug dealing', code = 'POSS', priority = 2, coords = pos, approximate = true,
        description = 'Caller reports a hand-to-hand drug deal on the street.' })

    -- The gang whose turf it is hears about it (now and then)
    if rivalOwner and zone then
        local key = zone .. ':' .. rivalOwner
        if not turfNoticed[key] or t - turfNoticed[key] >= cfg.turfNotice then
            turfNoticed[key] = t
            Gangs.NotifyGang(rivalOwner, locale('drugs_on_your_turf', Zones.Label(zone)), 'error')
        end
    end

    return true, { result = 'sold', label = item.label, qty = qty, paid = total - cut, area = zone and Zones.Label(zone) or nil }
end

-------------------------------------------------------------------------------
-- Sellable list, edited in game
-------------------------------------------------------------------------------

function Drugs.Items() return items end

local function cleanList(list)
    if type(list) ~= 'table' or #list > 30 then return nil, 'invalid' end
    local out, seen = {}, {}
    local businessTypes = Config.Enterprises and Config.Enterprises.types or {}
    for _, d in ipairs(list) do
        if type(d) ~= 'table' then return nil, 'invalid' end
        local item = tostring(d.item or '')
        if not Bridge.ItemExists(item) then return nil, 'item_not_found' end
        if seen[item] then return nil, 'drugs_duplicate' end
        seen[item] = true
        local lo = math.max(1, math.floor(tonumber(d.min) or tonumber(d.price and d.price[1]) or 50))
        local hi = math.max(lo, math.floor(tonumber(d.max) or tonumber(d.price and d.price[2]) or lo))
        local label = tostring(d.label or ''):gsub('[<>]', ''):match('^%s*(.-)%s*$'):sub(1, 32)
        out[#out + 1] = {
            item = item, label = #label > 0 and label or Bridge.ItemLabel(item):lower(),
            price = { math.min(lo, 1000000), math.min(hi, 1000000) },
            max = math.max(1, math.min(20, math.floor(tonumber(d.maxPer or d.max_per or d.maxQty) or 1))),
            enterprise = (d.enterprise and businessTypes[d.enterprise]) and d.enterprise or nil,
        }
    end
    return out
end

function Drugs.Load()
    local raw = MySQL.scalar.await("SELECT value FROM vg_settings WHERE `key` = 'drug_items'")
    if raw then
        local ok, list = pcall(json.decode, raw)
        if ok and type(list) == 'table' then items = list return end
    end
    items = cfg.items
end

function Drugs.AdminGet()
    local list = {}
    for i, d in ipairs(items) do
        list[i] = { item = d.item, label = d.label, min = d.price[1], max = d.price[2], maxPer = d.max, enterprise = d.enterprise,
            itemLabel = Bridge.ItemLabel(d.item) }
    end
    local businesses = {}
    for key, t in pairs(Config.Enterprises and Config.Enterprises.types or {}) do businesses[#businesses + 1] = { key = key, label = t.label } end
    table.sort(businesses, function(a, b) return a.label < b.label end)
    return { items = list, businesses = businesses, fromConfig = items == cfg.items }
end

function Drugs.AdminSave(src, list)
    local clean, err = cleanList(list)
    if not clean then return false, err end
    MySQL.insert.await("INSERT INTO vg_settings (`key`, value, updated_by) VALUES ('drug_items', ?, ?) ON DUPLICATE KEY UPDATE value = VALUES(value), updated_by = VALUES(updated_by)",
        { json.encode(clean), Bridge.GetCitizenId(src) or 'console' })
    items = clean
    Logger.Log(src, 'staff_drug_items', ('saved %d sellable drugs'):format(#clean))
    return true, Drugs.AdminGet()
end

function Drugs.AdminReset(src)
    MySQL.update.await("DELETE FROM vg_settings WHERE `key` = 'drug_items'")
    items = cfg.items
    Logger.Log(src, 'staff_drug_items_reset', 'reset sellable drugs to config/drugs.lua')
    return true, Drugs.AdminGet()
end

AddEventHandler('playerDropped', function()
    lastOffer[source], perHour[source] = nil, nil
end)
