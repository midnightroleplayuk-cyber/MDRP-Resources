-- Tablet callbacks. Every callback re-checks membership and permissions server-side.
-- Reads return data (or nil); actions return (ok, errCode).

local READ_MS, ACTION_MS = 250, 1000

local function read(name, fn)
    lib.callback.register('vinewood_gangs:server:' .. name, function(src, ...)
        if not Security.Throttle(src, name, READ_MS) then return nil, 'slow_down' end
        return fn(src, ...)
    end)
end

local function action(name, fn, ms)
    lib.callback.register('vinewood_gangs:server:' .. name, function(src, ...)
        if not Security.Throttle(src, name, ms or ACTION_MS) then return false, 'slow_down' end
        return fn(src, ...)
    end)
end

-- The client asks for its own gang on start-up, on character load and before opening the tablet,
-- so it never relies on having caught a push.
lib.callback.register('vinewood_gangs:server:myGang', function(src)
    return Gangs.ClientData(src)
end)

read('getOverview', function(src)
    local gang, membership, cid = Gangs.GetPlayerGang(src)
    if not gang then return { inGang = false } end

    local territory = {}
    for zone in pairs(Config.Zones) do
        if Influence.GetOwner(zone) == gang.id then territory[#territory + 1] = Zones.Label(zone) end
    end
    table.sort(territory)

    local online = 0
    local members = Gangs.GetMembers(gang.id)
    for _, m in ipairs(members) do if m.online then online = online + 1 end end

    return {
        inGang = true,
        gang = { id = gang.id, label = gang.label, colour = gang.colour, reputation = gang.reputation },
        rank = Gangs.RankLabel(gang.id, membership.grade),
        memberCount = #members,
        onlineCount = online,
        maxMembers = Config.Gangs.maxMembers,
        territory = territory,
        news = Director.PublicFeed(),
        progress = Progression.View(gang.id),
        treasury = Gangs.HasPermission(cid, 'treasury_view') and {
            clean = Ledger.GetBalance(gang.id, 'clean'),
            dirty = Ledger.GetBalance(gang.id, 'dirty'),
        } or nil,
    }
end)

read('getMembers', function(src)
    local gang, membership, cid = Gangs.GetPlayerGang(src)
    if not gang then return nil, 'not_in_gang' end
    local members = Gangs.GetMembers(gang.id)
    for _, m in ipairs(members) do m.me = m.citizenid == cid end
    return {
        members = members,
        ranks = Gangs.GetRanks(gang.id),
        myGrade = membership.grade,
        topGrade = Gangs.TopGrade(gang.id),
        maxMembers = Config.Gangs.maxMembers,
    }
end)

read('getTerritory', function(src)
    local gang = Gangs.GetPlayerGang(src)
    if not gang then return nil, 'not_in_gang' end
    local zones = {}
    for key in pairs(Config.Zones) do
        local ownerId = Influence.GetOwner(key)
        local owner = ownerId and Gangs.Get(ownerId)
        local breakdown
        if Config.Territory.showAllInfluence then
            breakdown = {}
            for _, row in ipairs(Influence.GetZoneBreakdown(key)) do
                local g = Gangs.Get(row.gangId)
                if g then
                    breakdown[#breakdown + 1] = { label = g.label, colour = g.colour, influence = row.influence, mine = g.id == gang.id }
                end
            end
        end
        zones[#zones + 1] = {
            key = key,
            label = Zones.Label(key),
            owner = owner and { label = owner.label, colour = owner.colour, mine = ownerId == gang.id } or nil,
            influence = Utils.Round(Influence.Get(key, gang.id), 1),
            breakdown = breakdown, -- every gang with influence here, highest first (nil when hidden by config)
        }
    end
    table.sort(zones, function(a, b) return a.label < b.label end)
    return {
        zones = zones,
        captureThreshold = Config.Influence.captureThreshold,
        holdThreshold = Config.Influence.holdThreshold,
        margin = Config.Influence.ownershipMargin,
    }
end)

read('getTreasury', function(src)
    local gang, _, cid = Gangs.GetPlayerGang(src)
    if not gang then return nil, 'not_in_gang' end
    local canView = Gangs.HasPermission(cid, 'treasury_view')
    return {
        canView = canView,
        canDeposit = Gangs.HasPermission(cid, 'treasury_deposit'),
        canWithdraw = Gangs.HasPermission(cid, 'treasury_withdraw'),
        cash = Bridge.GetMoney(src, 'cash'),
        balances = canView and {
            clean = Ledger.GetBalance(gang.id, 'clean'),
            dirty = Ledger.GetBalance(gang.id, 'dirty'),
        } or nil,
        history = canView and Ledger.History(gang.id, 25) or nil,
    }
end)

read('getNearby', function(src)
    local gang, _, cid = Gangs.GetPlayerGang(src)
    if not gang then return nil, 'not_in_gang' end
    if not Gangs.HasPermission(cid, 'manage_members') then return nil, 'no_permission' end
    return Gangs.GetNearbyInvitable(src)
end)

action('createGang', function(src, name, label, colour) return Gangs.Create(src, name, label, colour) end, 5000)
action('invite', function(src, target) return Gangs.Invite(src, target) end, 2000)
action('respondInvite', function(src, accept) return Gangs.RespondInvite(src, accept == true) end)
action('kick', function(src, cid) return Gangs.Kick(src, tostring(cid)) end)
action('setGrade', function(src, cid, grade) return Gangs.SetGrade(src, tostring(cid), grade) end, 500)
action('transfer', function(src, cid) return Gangs.TransferLeadership(src, tostring(cid)) end, 5000)
action('editRank', function(src, grade, label, perms) return Gangs.EditRank(src, grade, label, perms) end, 500)
action('updateDetails', function(src, label, colour) return Gangs.UpdateDetails(src, label, colour) end, 3000)
action('leave', function(src) return Gangs.Leave(src) end, 5000)
action('disband', function(src) return Gangs.PlayerDisband(src) end, 5000)
action('deposit', function(src, amount) return Ledger.Deposit(src, amount) end)
action('withdraw', function(src, amount) return Ledger.Withdraw(src, amount) end)

-- Graffiti --------------------------------------------------------------------

read('getTags', function(src) return Graffiti.GetGangOverview(src) end)
action('submitDesign', function(src, name, spec) return Graffiti.SubmitDesign(src, name, spec) end, 3000)
action('deleteDesign', function(src, id) return Graffiti.DeleteDesign(src, id) end)
action('removeOwnTag', function(src, id) return Graffiti.RemoveOwn(src, id) end, 1000)

-- Called directly by client/graffiti.lua (not through the NUI)
action('graffitiCanPlace', function(src, designId, p) return Graffiti.CanPlace(src, designId, p) end, 500)
action('graffitiPlace', function(src, designId, p) return Graffiti.Place(src, designId, p) end, 2000)
action('graffitiCross', function(src, id) return Graffiti.Cross(src, id) end, 2000)
action('graffitiClean', function(src, id) return Graffiti.Clean(src, id) end, 2000)
lib.callback.register('vinewood_gangs:server:graffitiSnapshot', function() return Graffiti.Snapshot() end)

-- Logos and contracts -------------------------------------------------------

action('setLogo', function(src, url) return Gangs.SetLogo(src, url) end, 3000)

read('getContracts', function(src) return Contracts.Board(src) end)
action('acceptContract', function(src, id) return Contracts.Accept(src, id) end, 2000)
action('abandonContract', function(src) return Contracts.Abandon(src) end, 2000)

-- Called by client/contracts.lua
action('contractAction', function(src, id, name) return Contracts.Action(src, id, name) end, 750)
lib.callback.register('vinewood_gangs:server:contractResume', function(src) return Contracts.Resume(src) end)
RegisterNetEvent('vinewood_gangs:server:contractKeys', function(netId) Contracts.GiveKeys(source, netId) end)

-- Rackets -------------------------------------------------------------------

read('getRackets', function(src) return Rackets.GangView(src) end)
action('dropRacket', function(src, key) return Rackets.Drop(src, tostring(key)) end, 2000)

-- Called by client/rackets.lua at the business
read('racketInfo', function(src, key) return Rackets.Info(src, tostring(key)) end)
action('racketOffer', function(src, key, intimidate) return Rackets.Offer(src, tostring(key), intimidate == true) end, 3000)
action('racketCollect', function(src, key) return Rackets.Collect(src, tostring(key)) end, 3000)

-- Safehouses ----------------------------------------------------------------

read('getSafehouses', function(src) return Safehouses.GangView(src) end)
action('buySafehouse', function(src, id) return Safehouses.Buy(src, id) end, 3000)
action('sellSafehouse', function(src, id) return Safehouses.Sell(src, id) end, 3000)
action('upgradeSafehouse', function(src, id, kind) return Safehouses.Upgrade(src, id, tostring(kind)) end, 1500)

-- Called by client/safehouses.lua
action('safehouseEnter', function(src, id) return Safehouses.Enter(src, id) end, 1500)
action('safehouseLeave', function(src) return Safehouses.Leave(src) end, 1500)
action('safehouseStash', function(src) return Safehouses.OpenStash(src) end, 1000)
action('safehouseRaidStart', function(src, id) return Safehouses.RaidStart(src, id) end, 3000)
action('safehouseRaidFinish', function(src, id) return Safehouses.RaidFinish(src, id) end, 1000)

-- Laundering ----------------------------------------------------------------

read('getLaundering', function(src) return Laundering.View(src) end)
action('launder', function(src, method, amount) return Laundering.Start(src, tostring(method), amount) end, 2000)

-- Heists -------------------------------------------------------------------

read('getHeists', function(src) return Heists.View(src) end)
action('heistStart', function(src, id) return Heists.Start(src, id) end, 3000)
action('heistAbandon', function(src) return Heists.Abandon(src) end, 3000)
lib.callback.register('vinewood_gangs:server:heistStart', function(src, id) return Heists.Start(src, id) end)
lib.callback.register('vinewood_gangs:server:heistBegin', function(src, runId, i) return Heists.BeginStep(src, runId, i) end)
lib.callback.register('vinewood_gangs:server:heistFinish', function(src, runId, i, ok) return Heists.FinishStep(src, runId, i, ok == true) end)

-- Street dealing (client/drugs.lua) ----------------------------------------

read('drugStatus', function(src) return Drugs.Status(src) end)
lib.callback.register('vinewood_gangs:server:drugSell', function(src) return Drugs.Sell(src) end) -- has its own cooldown

-- Shop ----------------------------------------------------------------------

read('getShop', function(src) return Shop.View(src) end)
action('shopBuy', function(src, item, amount) return Shop.Buy(src, item, amount) end, 1500)

-- Black market ---------------------------------------------------------------

read('getAuctions', function(src) return Auctions.View(src) end)
action('auctionBid', function(src, id, amount) return Auctions.Bid(src, id, amount, false) end, 1000)
action('auctionBuyNow', function(src, id) return Auctions.Bid(src, id, nil, true) end, 2000)
action('auctionPickup', function(src, id) return Auctions.Pickup(src, id) end, 2000) -- client/auctions.lua

-- Informants ----------------------------------------------------------------

-- Burner phone (client/informants.lua)
read('informantMenu', function(src) return Informants.Menu(src) end)
action('informantRegister', function(src) return Informants.Register(src) end, 3000)
action('informantTip', function(src, key) return Informants.Tip(src, tostring(key)) end, 3000)

-- Tablet: leaders looking into leaks
read('getLeaks', function(src) return Informants.Leaks(src) end)
action('investigateLeak', function(src, id) return Informants.Investigate(src, id) end, 3000)

-- Director ------------------------------------------------------------------

action('directorUnload', function(src, plate) return Director.DropUnload(src, plate) end, 1500)

-- Diplomacy -----------------------------------------------------------------

read('getDiplomacy', function(src) return Relations.View(src) end)
action('proposeDeal', function(src, target, kind, terms) return Relations.Propose(src, target, tostring(kind), terms) end, 3000)
action('respondDeal', function(src, id, accept) return Relations.Respond(src, id, accept == true) end, 1500)
action('withdrawDeal', function(src, id) return Relations.Withdraw(src, id) end, 1500)
action('breakDeal', function(src, id) return Relations.Break(src, id) end, 3000)
action('declareRelation', function(src, target, state) return Relations.Declare(src, target, tostring(state)) end, 3000)

-- Enterprises and supply ----------------------------------------------------

read('getEnterprises', function(src) return Enterprises.GangView(src) end)
action('setupEnterprise', function(src, safehouseId, kind) return Enterprises.Setup(src, safehouseId, tostring(kind)) end, 3000)
action('upgradeEnterprise', function(src, id) return Enterprises.Upgrade(src, id) end, 1500)
action('setStaff', function(src, id, count) return Enterprises.SetStaff(src, id, count) end, 500)
action('setDistribution', function(src, id, on) return Enterprises.SetDistribution(src, id, on == true) end, 500)
action('sellWholesale', function(src, id, amount) return Enterprises.SellWholesale(src, id, amount) end, 1500)
action('bagUpStock', function(src, id, amount) return Enterprises.BagUp(src, id, amount) end, 1500)
action('closeEnterprise', function(src, id) return Enterprises.Close(src, id) end, 3000)
action('orderSupplies', function(src, id, amount, method) return Supply.Order(src, id, amount, tostring(method)) end, 1500)
action('startSupplyRun', function(src, id) return Supply.StartRun(src, id) end, 3000)

-- Called by client/supply.lua
action('supplyUnload', function(src, id) return Supply.Unload(src, id) end, 1500)
