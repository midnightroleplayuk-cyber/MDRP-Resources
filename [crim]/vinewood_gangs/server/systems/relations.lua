Relations = {}

local cfg = Config.Diplomacy
local rel = {}        -- rel['a:b'] = { state, trust } (a < b)
local deals = {}      -- deals[id] = { id, a = proposer, b = target, type, status, terms, signedAt, expiresAt, proposedAt }
local brokenCount = {} -- brokenCount[gangId] = deals broken

local function pairKey(a, b)
    if a > b then a, b = b, a end
    return ('%d:%d'):format(a, b), a, b
end

-- Pairs are stored with the lower id first (see vg_relations CHECK constraint)
function Relations.Pair(a, b)
    if a < b then return a, b end
    return b, a
end

function Relations.Get(a, b)
    local k = pairKey(a, b)
    return rel[k] or { state = 'neutral', trust = 0 }
end

local function saveRel(a, b, r)
    local k, lo, hi = pairKey(a, b)
    rel[k] = r
    MySQL.prepare('INSERT INTO vg_relations (gang_a, gang_b, state, trust) VALUES (?, ?, ?, ?) ON DUPLICATE KEY UPDATE state = VALUES(state), trust = VALUES(trust)',
        { lo, hi, r.state, r.trust })
end

local function addTrust(a, b, amount)
    local r = Relations.Get(a, b)
    saveRel(a, b, { state = r.state, trust = math.max(-100, math.min(100, r.trust + amount)) })
end

local function saveDeal(d)
    MySQL.prepare([[
        UPDATE vg_agreements SET status = ?, signed_at = IF(? = 0, NULL, FROM_UNIXTIME(?)),
            expires_at = IF(? = 0, NULL, FROM_UNIXTIME(?)), broken_by = NULLIF(?, 0)
        WHERE id = ?
    ]], { d.status, d.signedAt or 0, d.signedAt or 0, d.expiresAt or 0, d.expiresAt or 0, d.brokenBy or 0, d.id })
end

---Active deals between two gangs.
function Relations.Active(a, b)
    local out = {}
    for _, d in pairs(deals) do
        if d.status == 'active' and ((d.a == a and d.b == b) or (d.a == b and d.b == a)) then out[#out + 1] = d end
    end
    return out
end

---True when a deal stops `actor` acting against `target` (optionally in a given area).
function Relations.IsProtected(actor, target, zone)
    if not actor or not target or actor == target then return false end
    for _, d in ipairs(Relations.Active(actor, target)) do
        if d.type == 'alliance' or d.type == 'ceasefire' then return true end
        if d.type == 'neutral_zone' and zone and d.terms.zone == zone then return true end
    end
    return false
end

function Relations.SupplyDiscount(gangId)
    local total = 0
    for _, d in pairs(deals) do
        if d.status == 'active' and d.type == 'trade' and (d.a == gangId or d.b == gangId) then
            total = total + (cfg.types.trade.supplyDiscount or 0)
        end
    end
    return math.min(cfg.maxSupplyDiscount, total)
end

function Relations.HostileMultiplier(actor, target)
    if actor and target and Relations.Get(actor, target).state == 'rival' then return cfg.rivalBonus end
    return 1.0
end

-------------------------------------------------------------------------------
-- Actions
-------------------------------------------------------------------------------

local function diplomat(src)
    local gang, _, cid = Gangs.GetPlayerGang(src)
    if not gang then return nil, 'not_in_gang' end
    if not Gangs.HasPermission(cid, 'diplomacy') then return nil, 'no_permission' end
    return gang, cid
end

local function dealLabel(d) return cfg.types[d.type] and cfg.types[d.type].label or d.type end

function Relations.Propose(src, targetId, kind, terms)
    local gang, cid = diplomat(src)
    if not gang then return false, cid end
    targetId = tonumber(targetId)
    local target = targetId and Gangs.Get(targetId)
    local t = cfg.types[kind]
    if not target or target.id == gang.id or not t or type(terms) ~= 'table' then return false, 'invalid' end
    if not Progression.Has(gang.id, 'diplomacy') then return false, 'tier_locked' end
    if not Progression.Has(target.id, 'diplomacy') then return false, 'tier_locked_them' end

    local hours = math.floor(tonumber(terms.hours) or -1)
    local allowed = false
    for _, h in ipairs(t.hours) do if h == hours then allowed = true end end
    if not allowed then return false, 'invalid' end

    local zone
    if kind == 'neutral_zone' then
        zone = tostring(terms.zone or '')
        if not Config.Zones[zone] then return false, 'zone_not_found' end
    end

    local payment = math.floor(tonumber(terms.payment) or 0)
    local payer = terms.payer == 'target' and 'target' or 'proposer'
    if payment < 0 or payment > cfg.maxPayment then return false, 'invalid_amount' end

    for _, d in pairs(deals) do
        local samePair = (d.a == gang.id and d.b == target.id) or (d.a == target.id and d.b == gang.id)
        if samePair and d.type == kind and (d.status == 'active' or d.status == 'proposed') and (kind ~= 'neutral_zone' or d.terms.zone == zone) then
            return false, 'deal_exists'
        end
    end

    local message = tostring(terms.message or ''):gsub('[<>]', ''):sub(1, cfg.messageLength)
    local clean = { hours = hours, zone = zone, payment = payment, payer = payer, message = message }
    local now = os.time()
    local id = MySQL.insert.await('INSERT INTO vg_agreements (gang_a, gang_b, type, terms, proposed_by) VALUES (?, ?, ?, ?, ?)',
        { gang.id, target.id, kind, json.encode(clean), cid })
    if not id then return false, 'db_error' end
    deals[id] = { id = id, a = gang.id, b = target.id, type = kind, status = 'proposed', terms = clean, proposedAt = now }

    Gangs.NotifyGang(target.id, locale('deal_received', gang.label, t.label), 'inform')
    Logger.Log(src, 'deal_proposed', ('%s proposed %s from gang %d to %d'):format(cid, kind, gang.id, target.id))
    return true
end

function Relations.Respond(src, id, accept)
    local gang, cid = diplomat(src)
    if not gang then return false, cid end
    local d = deals[tonumber(id)]
    if not d or d.status ~= 'proposed' or d.b ~= gang.id then return false, 'invalid' end
    local proposer = Gangs.Get(d.a)
    if not proposer then return false, 'gang_missing' end

    if not accept then
        d.status = 'rejected'
        saveDeal(d)
        deals[d.id] = nil
        Gangs.NotifyGang(d.a, locale('deal_rejected', gang.label, dealLabel(d)), 'error')
        return true
    end

    -- One-off payment changes hands on signing
    if d.terms.payment > 0 then
        local from, to = d.a, d.b
        if d.terms.payer == 'target' then from, to = d.b, d.a end
        local ok = Ledger.Transact(from, 'clean', -d.terms.payment, 'deal_payment', { refType = 'agreement', refId = d.id })
        if not ok then return false, from == gang.id and 'insufficient_funds' or 'deal_they_cant_pay' end
        Ledger.Transact(to, 'clean', d.terms.payment, 'deal_payment', { refType = 'agreement', refId = d.id })
    end

    local now = os.time()
    d.status, d.signedAt = 'active', now
    d.expiresAt = d.terms.hours > 0 and (now + d.terms.hours * 3600) or 0
    saveDeal(d)
    addTrust(d.a, d.b, cfg.signTrust)
    Gangs.NotifyGang(d.a, locale('deal_signed', gang.label, dealLabel(d)), 'success')
    Gangs.NotifyGang(d.b, locale('deal_signed', proposer.label, dealLabel(d)), 'success')
    Logger.Log(src, 'deal_signed', ('%s signed deal %d'):format(cid, d.id))
    return true
end

function Relations.Withdraw(src, id)
    local gang, cid = diplomat(src)
    if not gang then return false, cid end
    local d = deals[tonumber(id)]
    if not d or d.status ~= 'proposed' or d.a ~= gang.id then return false, 'invalid' end
    d.status = 'cancelled'
    saveDeal(d)
    deals[d.id] = nil
    return true
end

local function announce(message)
    for gangId in pairs(Gangs.All()) do Gangs.NotifyGang(gangId, message, 'inform') end
end

function Relations.Break(src, id)
    local gang, cid = diplomat(src)
    if not gang then return false, cid end
    local d = deals[tonumber(id)]
    if not d or d.status ~= 'active' or (d.a ~= gang.id and d.b ~= gang.id) then return false, 'invalid' end
    local other = d.a == gang.id and d.b or d.a
    local otherGang = Gangs.Get(other)

    d.status, d.brokenBy = 'broken', gang.id
    saveDeal(d)
    deals[d.id] = nil
    brokenCount[gang.id] = (brokenCount[gang.id] or 0) + 1

    addTrust(gang.id, other, cfg.breakTrust)
    for _, x in pairs(deals) do
        if x.status == 'active' and (x.a == gang.id or x.b == gang.id) then
            addTrust(x.a, x.b, cfg.othersTrust)
        end
    end
    Gangs.AddReputation(gang.id, -cfg.breakReputation)

    if otherGang then Gangs.NotifyGang(other, locale('deal_broken_on_you', gang.label, dealLabel(d)), 'error') end
    if cfg.announceBreaks and otherGang then
        announce(locale('deal_broken_announce', gang.label, dealLabel(d), otherGang.label))
    end
    Logger.Log(src, 'deal_broken', ('%s broke deal %d (gang %d vs %d)'):format(cid, d.id, gang.id, other))
    return true
end

---Declare another gang a rival, or drop the rivalry.
function Relations.Declare(src, targetId, state)
    local gang, cid = diplomat(src)
    if not gang then return false, cid end
    targetId = tonumber(targetId)
    local target = targetId and Gangs.Get(targetId)
    if not target or target.id == gang.id or (state ~= 'rival' and state ~= 'neutral') then return false, 'invalid' end
    if not Progression.Has(gang.id, 'diplomacy') then return false, 'tier_locked' end
    if state == 'rival' and #Relations.Active(gang.id, target.id) > 0 then return false, 'deal_active_first' end

    local r = Relations.Get(gang.id, target.id)
    saveRel(gang.id, target.id, { state = state, trust = r.trust })
    Gangs.NotifyGang(target.id, locale(state == 'rival' and 'rival_declared' or 'rival_dropped', gang.label), state == 'rival' and 'error' or 'inform')
    return true
end

-------------------------------------------------------------------------------
-- Views
-------------------------------------------------------------------------------

local function dealView(d, gangId, now)
    local other = d.a == gangId and d.b or d.a
    local g = Gangs.Get(other)
    return {
        id = d.id, type = d.type, label = dealLabel(d), status = d.status,
        mine = d.a == gangId, other = g and g.label or '?', otherId = other,
        hours = d.terms.hours, zone = d.terms.zone and Zones.Label(d.terms.zone) or nil,
        payment = d.terms.payment, theyPay = (d.terms.payer == 'target') == (d.a == gangId),
        message = d.terms.message ~= '' and d.terms.message or nil,
        secondsLeft = d.status == 'active' and d.expiresAt > 0 and (d.expiresAt - now)
            or (d.status == 'proposed' and (d.proposedAt + cfg.proposalHours * 3600 - now)) or nil,
    }
end

function Relations.View(src)
    local gang, _, cid = Gangs.GetPlayerGang(src)
    if not gang then return nil, 'not_in_gang' end
    local now = os.time()

    local gangs = {}
    for id, g in pairs(Gangs.All()) do
        if id ~= gang.id then
            local r = Relations.Get(gang.id, id)
            local active = {}
            for _, d in ipairs(Relations.Active(gang.id, id)) do active[#active + 1] = dealView(d, gang.id, now) end
            gangs[#gangs + 1] = {
                id = id, label = g.label, colour = g.colour, logo = Gangs.ApprovedLogo(id),
                state = r.state, trust = r.trust, broken = brokenCount[id] or 0, reputation = g.reputation,
                deals = active,
            }
        end
    end
    table.sort(gangs, function(a, b) return a.label:lower() < b.label:lower() end)

    local incoming, outgoing = {}, {}
    for _, d in pairs(deals) do
        if d.status == 'proposed' then
            if d.b == gang.id then incoming[#incoming + 1] = dealView(d, gang.id, now) end
            if d.a == gang.id then outgoing[#outgoing + 1] = dealView(d, gang.id, now) end
        end
    end

    local types = {}
    for key, t in pairs(cfg.types) do types[#types + 1] = { key = key, label = t.label, hours = t.hours } end
    table.sort(types, function(a, b) return a.label < b.label end)
    local zones = {}
    for key, z in pairs(Config.Zones) do zones[#zones + 1] = { key = key, label = z.label } end
    table.sort(zones, function(a, b) return a.label < b.label end)

    return {
        gangs = gangs, incoming = incoming, outgoing = outgoing,
        canDeal = Gangs.HasPermission(cid, 'diplomacy'),
        myBroken = brokenCount[gang.id] or 0,
        types = types, zones = zones, maxPayment = cfg.maxPayment, messageLength = cfg.messageLength,
        discount = Relations.SupplyDiscount(gang.id), rivalBonus = cfg.rivalBonus,
    }
end

function Relations.AdminList()
    local out, now = {}, os.time()
    for _, d in pairs(deals) do
        local a, b = Gangs.Get(d.a), Gangs.Get(d.b)
        out[#out + 1] = {
            id = d.id, label = dealLabel(d), status = d.status,
            a = a and a.label or '?', aColour = a and a.colour, b = b and b.label or '?', bColour = b and b.colour,
            zone = d.terms.zone and Zones.Label(d.terms.zone) or nil, payment = d.terms.payment,
            secondsLeft = d.status == 'active' and d.expiresAt > 0 and (d.expiresAt - now) or nil,
        }
    end
    table.sort(out, function(x, y) return x.id > y.id end)
    return out
end

function Relations.AdminCancel(src, id)
    local d = deals[tonumber(id)]
    if not d then return false, 'invalid' end
    d.status = 'cancelled'
    saveDeal(d)
    deals[d.id] = nil
    Gangs.NotifyGang(d.a, locale('deal_cancelled_staff', dealLabel(d)), 'error')
    Gangs.NotifyGang(d.b, locale('deal_cancelled_staff', dealLabel(d)), 'error')
    Logger.Log(src, 'staff_deal_cancelled', ('deal %d cancelled'):format(d.id))
    return true
end

-------------------------------------------------------------------------------
-- Lifecycle
-------------------------------------------------------------------------------

function Relations.Load()
    rel, deals, brokenCount = {}, {}, {}
    for _, r in ipairs(MySQL.query.await('SELECT gang_a, gang_b, state, trust FROM vg_relations')) do
        rel[pairKey(r.gang_a, r.gang_b)] = { state = r.state, trust = r.trust }
    end
    for _, r in ipairs(MySQL.query.await([[
        SELECT id, gang_a, gang_b, type, terms, status, UNIX_TIMESTAMP(created_at) AS proposed,
            UNIX_TIMESTAMP(signed_at) AS signed, UNIX_TIMESTAMP(expires_at) AS expires
        FROM vg_agreements WHERE status IN ('proposed', 'active')
    ]])) do
        local ok, terms = pcall(json.decode, r.terms or '{}')
        if ok and terms and cfg.types[r.type] and Gangs.Get(r.gang_a) and Gangs.Get(r.gang_b) then
            terms.payment = tonumber(terms.payment) or 0
            terms.hours = tonumber(terms.hours) or 0
            terms.message = terms.message or ''
            deals[r.id] = { id = r.id, a = r.gang_a, b = r.gang_b, type = r.type, status = r.status, terms = terms,
                proposedAt = r.proposed or os.time(), signedAt = r.signed, expiresAt = r.expires or 0 }
        end
    end
    for _, r in ipairs(MySQL.query.await("SELECT broken_by, COUNT(*) AS n FROM vg_agreements WHERE status = 'broken' AND broken_by IS NOT NULL GROUP BY broken_by")) do
        brokenCount[r.broken_by] = r.n
    end
end

local function tick()
    local now = os.time()
    for _, d in pairs(deals) do
        if d.status == 'proposed' and now > d.proposedAt + cfg.proposalHours * 3600 then
            d.status = 'expired'
            saveDeal(d)
            deals[d.id] = nil
        elseif d.status == 'active' and d.expiresAt > 0 and now >= d.expiresAt then
            d.status = 'expired'
            saveDeal(d)
            deals[d.id] = nil
            addTrust(d.a, d.b, cfg.honourTrust)
            Gangs.NotifyGang(d.a, locale('deal_ended', dealLabel(d)), 'inform')
            Gangs.NotifyGang(d.b, locale('deal_ended', dealLabel(d)), 'inform')
        end
    end
end

function Relations.Start()
    if not Config.Modules.diplomacy then return end
    CreateThread(function()
        while true do
            tick()
            Wait(60000)
        end
    end)
end

AddEventHandler('vinewood_gangs:server:gangDisbanded', function(gangId)
    for id, d in pairs(deals) do
        if d.a == gangId or d.b == gangId then
            d.status = 'cancelled'
            saveDeal(d)
            deals[id] = nil
        end
    end
end)
