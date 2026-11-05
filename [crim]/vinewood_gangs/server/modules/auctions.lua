Auctions = {}

local cfg = Config.Auctions
local lots = {}        -- lots[id] = { id, lot, status, endsAt, topGang, topBid, bids, drop, dropUntil }
local recent = {}      -- last few results, for the tablet
local nextAuctionAt = 0
local tipped = {}      -- tipped[lotId][gangId] = true (they know where the drop is)

local function now() return os.time() end
local function v3(p) return vector3(p.x, p.y, p.z) end

local function save(l)
    MySQL.prepare('UPDATE vg_auctions SET status = ?, ends_at = ?, top_gang = ?, top_bid = ?, bids = ?, drop_point = ?, drop_until = ? WHERE id = ?',
        { l.status, l.endsAt, l.topGang, l.topBid, l.bids, l.drop and json.encode(l.drop) or nil, l.dropUntil or 0, l.id })
end

local function announce(key, ...)
    local msg = locale(key, ...)
    for gangId in pairs(Gangs.All()) do Gangs.NotifyGang(gangId, msg, 'inform') end
end

local function reserve(l) return l.lot.reserve end
local function minBid(l)
    if l.topBid <= 0 then return reserve(l) end
    return l.topBid + math.max(500, math.floor(l.topBid * cfg.increment))
end
local function buyNow(l) return math.floor(reserve(l) * cfg.buyNowMultiplier / 100 + 0.5) * 100 end

-------------------------------------------------------------------------------
-- Generating lots
-------------------------------------------------------------------------------

local function rand(range) return math.random(range[1], range[2]) end
local function round100(n) return math.floor(n / 100 + 0.5) * 100 end

local makers = {}

function makers.supplies()
    local types = {}
    for key in pairs(Config.Enterprises.types) do types[#types + 1] = key end
    if #types == 0 then return nil end
    table.sort(types)
    local key = types[math.random(#types)]
    local t = Config.Enterprises.types[key]
    local amount = rand(cfg.lots.supplies.amount)
    return { kind = 'supplies', type = key, amount = amount,
        title = locale('lot_supplies', amount, t.supplies), detail = locale('lot_supplies_detail', t.label),
        reserve = round100(amount * t.supplyCost * cfg.lots.supplies.reservePerUnit) }
end

function makers.contract()
    return { kind = 'contract', title = locale('lot_contract'),
        detail = locale('lot_contract_detail', cfg.lots.contract.rewardMultiplier), reserve = round100(rand(cfg.lots.contract.reserve)) }
end

function makers.copper()
    return { kind = 'copper', heat = cfg.lots.copper.heat, title = locale('lot_copper'),
        detail = locale('lot_copper_detail'), reserve = round100(rand(cfg.lots.copper.reserve)) }
end

function makers.connections()
    local zones = {}
    for key in pairs(Config.Zones) do zones[#zones + 1] = key end
    if #zones == 0 then return nil end
    table.sort(zones)
    local zone = zones[math.random(#zones)]
    return { kind = 'connections', zone = zone, influence = cfg.lots.connections.influence,
        title = locale('lot_connections', Zones.Label(zone)), detail = locale('lot_connections_detail', cfg.lots.connections.influence),
        reserve = round100(rand(cfg.lots.connections.reserve)) }
end

function makers.items()
    if #cfg.items == 0 then return nil end
    local it = cfg.items[math.random(#cfg.items)]
    return { kind = 'items', item = it.item, count = it.count or 1,
        title = (it.count or 1) > 1 and ('%dx %s'):format(it.count, it.label) or it.label,
        detail = locale('lot_items_detail'), reserve = round100(it.reserve or 10000) }
end

local function pickLot()
    local pool, total = {}, 0
    for kind, l in pairs(cfg.lots) do
        if makers[kind] and l.weight > 0 and (kind ~= 'items' or #cfg.items > 0)
            and (kind ~= 'supplies' or Config.Modules.enterprises)
            and (kind ~= 'contract' or Config.Modules.contracts) then
            pool[#pool + 1] = { kind = kind, w = l.weight }
            total = total + l.weight
        end
    end
    local roll = math.random() * total
    for _, p in ipairs(pool) do
        roll = roll - p.w
        if roll <= 0 then return makers[p.kind]() end
    end
end

function Auctions.Open()
    local count = rand(cfg.lotsPerAuction)
    local opened = 0
    local endsAt = now() + cfg.biddingMinutes * 60
    for _ = 1, count * 3 do
        if opened >= count then break end
        local lot = pickLot()
        if lot then
            local id = MySQL.insert.await('INSERT INTO vg_auctions (lot, ends_at) VALUES (?, ?)', { json.encode(lot), endsAt })
            if id then
                lots[id] = { id = id, lot = lot, status = 'open', endsAt = endsAt, topGang = nil, topBid = 0, bids = 0 }
                opened = opened + 1
            end
        end
    end
    if opened > 0 then announce('auction_open', opened, cfg.biddingMinutes) end
    return opened
end

-------------------------------------------------------------------------------
-- Bidding (dirty money held in escrow)
-------------------------------------------------------------------------------

---Can this gang make use of the lot? (Supplies need a matching business.)
local function eligible(gangId, l)
    if l.lot.kind ~= 'supplies' then return true end
    for _, e in ipairs(Enterprises.ForGang(gangId)) do
        if e.type == l.lot.type then return true end
    end
    return false
end

local function refundTop(l, reasonKey)
    if l.topGang and l.topBid > 0 and Gangs.Get(l.topGang) then
        Ledger.Transact(l.topGang, 'dirty', l.topBid, 'auction_refund', { refType = 'auction', refId = l.id })
        if reasonKey then Gangs.NotifyGang(l.topGang, locale(reasonKey, l.lot.title, Utils.FormatMoney(l.topBid)), 'inform') end
    end
end

local deliver -- forward declaration

function Auctions.Bid(src, id, amount, isBuyNow)
    local gang, _, cid = Gangs.GetPlayerGang(src)
    if not gang then return false, 'not_in_gang' end
    if not Gangs.HasPermission(cid, cfg.bidPermission) then return false, 'no_permission' end
    local l = lots[tonumber(id)]
    if not l or l.status ~= 'open' or now() >= l.endsAt then return false, 'auction_closed' end
    if not eligible(gang.id, l) then return false, 'auction_not_eligible' end
    if not Progression.Has(gang.id, 'auctions') then return false, 'tier_locked' end

    amount = isBuyNow and buyNow(l) or math.floor(tonumber(amount) or 0)
    if l.topGang == gang.id and not isBuyNow then return false, 'auction_already_top' end
    if amount < minBid(l) then return false, 'auction_too_low' end

    local ok = Ledger.Transact(gang.id, 'dirty', -amount, 'auction_bid', { citizenid = cid, refType = 'auction', refId = l.id, note = l.lot.title })
    if not ok then return false, 'insufficient_funds' end

    refundTop(l, l.topGang ~= gang.id and 'auction_outbid' or nil)
    l.topGang, l.topBid, l.bids = gang.id, amount, l.bids + 1
    if isBuyNow then
        l.endsAt = now()
    elseif l.endsAt - now() < cfg.antiSnipe then
        l.endsAt = now() + cfg.antiSnipe
    end
    save(l)
    Logger.Log(src, 'auction_bid', ('%s bid %d on lot %d for gang %d%s'):format(cid, amount, l.id, gang.id, isBuyNow and ' (buy now)' or ''))
    if isBuyNow then deliver(l) end
    return true
end

-------------------------------------------------------------------------------
-- Settling and delivery
-------------------------------------------------------------------------------

local function pushRecent(l, sold)
    table.insert(recent, 1, { title = l.lot.title, sold = sold, price = sold and l.topBid or nil, at = now() })
    while #recent > 6 do table.remove(recent) end
end

local function onlineMembers(gangId)
    local out = {}
    for _, m in ipairs(Gangs.GetMembers(gangId)) do
        local src = m.online and Bridge.GetSourceFromCitizenId(m.citizenid)
        if src then out[#out + 1] = src end
    end
    return out
end

local function sendDrop(l, gangId)
    for _, src in ipairs(onlineMembers(gangId)) do
        TriggerClientEvent('vinewood_gangs:client:auctionDrop', src, l.id, l.drop, l.lot.title, math.max(0, l.dropUntil - now()))
    end
end

deliver = function(l)
    local gangId = l.topGang
    local gang = gangId and Gangs.Get(gangId)
    if not gang then
        l.status = 'unsold'
        save(l)
        pushRecent(l, false)
        return
    end

    local lot = l.lot
    if lot.kind == 'supplies' then
        local target
        for _, e in ipairs(Enterprises.ForGang(gangId)) do if e.type == lot.type then target = e break end end
        if not target or not Supply.CreateFree(gangId, target.id, lot.amount) then
            -- Business went in the meantime: half back
            Ledger.Transact(gangId, 'dirty', math.floor(l.topBid * 0.5), 'auction_refund', { refType = 'auction', refId = l.id })
            l.status = 'lost'
        else
            l.status = 'sold'
        end
        Gangs.NotifyGang(gangId, locale(target and 'auction_won_supplies' or 'auction_won_nowhere', lot.title), target and 'success' or 'error')
    elseif lot.kind == 'contract' then
        Contracts.InjectOffer(gangId, cfg.lots.contract.rewardMultiplier)
        l.status = 'sold'
        Gangs.NotifyGang(gangId, locale('auction_won_contract'), 'success')
    elseif lot.kind == 'copper' then
        Heat.Add(gangId, nil, -lot.heat)
        l.status = 'sold'
        Gangs.NotifyGang(gangId, locale('auction_won_copper'), 'success')
    elseif lot.kind == 'connections' then
        if Config.Zones[lot.zone] then Influence.Add(lot.zone, gangId, lot.influence / (Config.Zones[lot.zone].value or 1.0)) end
        l.status = 'sold'
        Gangs.NotifyGang(gangId, locale('auction_won_connections', Zones.Label(lot.zone)), 'success')
    elseif lot.kind == 'items' then
        local pool = Config.Contracts.locations.general
        l.drop = pool[math.random(#pool)]
        l.dropUntil = now() + cfg.dropMinutes * 60
        l.status = 'awaiting_pickup'
        tipped[l.id] = { [gangId] = true }
        Gangs.NotifyGang(gangId, locale('auction_won_items', lot.title, l.drop.label), 'success')
        sendDrop(l, gangId)
        -- Word gets around, after a head start
        SetTimeout(cfg.headStart * 1000, function()
            if l.status ~= 'awaiting_pickup' then return end
            for otherId in pairs(Gangs.All()) do
                if otherId ~= gangId and Gangs.HasOnlineMember(otherId) and not Relations.IsProtected(otherId, gangId)
                    and math.random() < cfg.tipChance then
                    tipped[l.id][otherId] = true
                    Gangs.NotifyGang(otherId, locale('auction_drop_tip', l.drop.label), 'inform')
                    sendDrop(l, otherId)
                end
            end
        end)
    end
    save(l)
    pushRecent(l, true)
    Logger.Log(0, 'auction_settled', ('lot %d (%s) to gang %d for %d'):format(l.id, lot.kind, gangId, l.topBid))
end

---Whoever reaches the dead drop first and knows about it takes the contraband.
function Auctions.Pickup(src, id)
    local l = lots[tonumber(id)]
    if not l or l.status ~= 'awaiting_pickup' then return false, 'auction_drop_gone' end
    local gang, _, cid = Gangs.GetPlayerGang(src)
    if not gang then return false, 'not_in_gang' end
    if not (tipped[l.id] and tipped[l.id][gang.id]) then return false, 'auction_drop_gone' end
    if #(GetEntityCoords(GetPlayerPed(src)) - v3(l.drop)) > 4.0 then return false, 'too_far' end

    if not Bridge.AddItem(src, l.lot.item, l.lot.count) then return false, 'auction_cant_carry' end
    l.status = 'collected'
    save(l)
    Heat.Add(gang.id, cid, 3, Zones.FromCoords(v3(l.drop)))
    if gang.id ~= l.topGang and Gangs.Get(l.topGang) then
        Gangs.NotifyGang(l.topGang, locale('auction_drop_stolen', l.lot.title), 'error')
        Logger.Log(src, 'auction_drop_intercepted', ('lot %d taken by gang %d from gang %d'):format(l.id, gang.id, l.topGang))
    end
    for gid in pairs(tipped[l.id] or {}) do
        for _, s in ipairs(onlineMembers(gid)) do TriggerClientEvent('vinewood_gangs:client:auctionDropGone', s, l.id) end
    end
    return true, l.lot.title
end

-------------------------------------------------------------------------------
-- Views
-------------------------------------------------------------------------------

function Auctions.View(src)
    local gang, _, cid = Gangs.GetPlayerGang(src)
    if not gang then return nil, 'not_in_gang' end
    local open, drops = {}, {}
    for _, l in pairs(lots) do
        if l.status == 'open' then
            open[#open + 1] = {
                id = l.id, title = l.lot.title, detail = l.lot.detail, kind = l.lot.kind,
                secondsLeft = math.max(0, l.endsAt - now()), topBid = l.topBid, bids = l.bids,
                leading = l.topGang == gang.id, minBid = minBid(l), buyNow = buyNow(l), reserve = reserve(l),
                eligible = eligible(gang.id, l),
            }
        elseif l.status == 'awaiting_pickup' and tipped[l.id] and tipped[l.id][gang.id] then
            drops[#drops + 1] = { id = l.id, title = l.lot.title, place = l.drop.label, x = l.drop.x, y = l.drop.y,
                secondsLeft = math.max(0, l.dropUntil - now()), ours = l.topGang == gang.id }
        end
    end
    table.sort(open, function(a, b) return a.id < b.id end)
    return {
        open = open, drops = drops, recent = recent,
        canBid = Gangs.HasPermission(cid, cfg.bidPermission),
        nextIn = #open == 0 and math.max(0, math.ceil((nextAuctionAt - now()) / 60)) or nil,
    }
end

function Auctions.AdminList()
    local out = {}
    for _, l in pairs(lots) do
        if l.status == 'open' or l.status == 'awaiting_pickup' then
            local g = l.topGang and Gangs.Get(l.topGang)
            out[#out + 1] = { id = l.id, title = l.lot.title, status = l.status, topBid = l.topBid, bids = l.bids,
                gang = g and g.label or nil, colour = g and g.colour or nil,
                secondsLeft = math.max(0, (l.status == 'open' and l.endsAt or l.dropUntil) - now()),
                place = l.drop and l.drop.label or nil }
        end
    end
    table.sort(out, function(a, b) return a.id < b.id end)
    return { lots = out, nextIn = math.max(0, math.ceil((nextAuctionAt - now()) / 60)), hasItems = #cfg.items > 0 }
end

function Auctions.AdminCancel(src, id)
    local l = lots[tonumber(id)]
    if not l or (l.status ~= 'open' and l.status ~= 'awaiting_pickup') then return false, 'invalid' end
    if l.status == 'open' then refundTop(l, 'auction_cancelled') end
    l.status = 'cancelled'
    save(l)
    lots[l.id] = nil
    Logger.Log(src, 'staff_auction_cancel', ('lot %d cancelled'):format(l.id))
    return true
end

-------------------------------------------------------------------------------
-- Lifecycle
-------------------------------------------------------------------------------

local function schedule()
    nextAuctionAt = now() + rand(cfg.intervalMinutes) * 60
end

local function tick()
    local t = now()
    local anyOpen = false
    for id, l in pairs(lots) do
        if l.status == 'open' then
            if t >= l.endsAt then
                if l.topGang then deliver(l) else
                    l.status = 'unsold'
                    save(l)
                    pushRecent(l, false)
                end
            else
                anyOpen = true
            end
        elseif l.status == 'awaiting_pickup' and t >= l.dropUntil then
            l.status = 'lost'
            save(l)
            if Gangs.Get(l.topGang) then
                local refund = math.floor(l.topBid * cfg.unclaimedRefund)
                Ledger.Transact(l.topGang, 'dirty', refund, 'auction_refund', { refType = 'auction', refId = l.id })
                Gangs.NotifyGang(l.topGang, locale('auction_drop_expired', Utils.FormatMoney(refund)), 'error')
            end
        end
        if l.status ~= 'open' and l.status ~= 'awaiting_pickup' then lots[id] = nil end
    end

    if not anyOpen and t >= nextAuctionAt then
        schedule()
        if #GetPlayers() >= cfg.minPlayers then Auctions.Open() end
    end
end

function Auctions.Load()
    lots = {}
    for _, r in ipairs(MySQL.query.await("SELECT id, lot, status, ends_at, top_gang, top_bid, bids, drop_point, drop_until FROM vg_auctions WHERE status IN ('open','awaiting_pickup')")) do
        local ok, lot = pcall(json.decode, r.lot)
        local okD, drop = pcall(json.decode, r.drop_point or 'null')
        if ok and lot then
            lots[r.id] = { id = r.id, lot = lot, status = r.status, endsAt = r.ends_at, topGang = r.top_gang, topBid = r.top_bid,
                bids = r.bids, drop = okD and drop or nil, dropUntil = r.drop_until }
            if r.status == 'awaiting_pickup' then tipped[r.id] = { [r.top_gang] = true } end
        end
    end
end

function Auctions.Start()
    if not Config.Modules.auctions then return end
    schedule()
    CreateThread(function()
        while true do
            Wait(15000)
            tick()
        end
    end)
end

-- Members of a winning gang who log in later still need the drop on their map
function Auctions.SyncPlayer(src)
    local gang = Gangs.GetPlayerGang(src)
    if not gang then return end
    for _, l in pairs(lots) do
        if l.status == 'awaiting_pickup' and tipped[l.id] and tipped[l.id][gang.id] then
            TriggerClientEvent('vinewood_gangs:client:auctionDrop', src, l.id, l.drop, l.lot.title, math.max(0, l.dropUntil - now()))
        end
    end
end

AddEventHandler('vinewood_gangs:server:gangDisbanded', function(gangId)
    for _, l in pairs(lots) do
        if l.status == 'open' and l.topGang == gangId then
            l.topGang, l.topBid = nil, 0
            save(l)
        end
    end
end)
