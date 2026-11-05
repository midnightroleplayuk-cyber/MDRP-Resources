Contracts = {}

local cfg = Config.Contracts
local offers = {}   -- offers[gangId][id] = offer
local active = {}   -- active[id] = running contract state
local byGang = {}   -- byGang[gangId] = active contract id
local trust = {}    -- trust[gangId][contactKey] = number

local contactsByKey = {}
for _, c in ipairs(cfg.contacts) do contactsByKey[c.key] = c end

local function pick(list) return list[math.random(#list)] end
local function v3(t) return vector3(t.x, t.y, t.z) end
local function playerPos(src) return GetEntityCoords(GetPlayerPed(src)) end
local function near(src, point, range) return #(playerPos(src) - v3(point)) <= range end

local function areaLabel(loc)
    local zone = Zones.FromCoords(v3(loc))
    return zone and Zones.Label(zone) or loc.label
end

-------------------------------------------------------------------------------
-- Trust
-------------------------------------------------------------------------------

function Contracts.GetTrust(gangId, contact)
    return trust[gangId] and trust[gangId][contact] or 0
end

function Contracts.Tier(gangId, contact)
    local t, tier = Contracts.GetTrust(gangId, contact), 1
    for level, needed in pairs(cfg.tiers) do
        if t >= needed and level > tier then tier = level end
    end
    return tier
end

local function addTrust(gangId, contact, amount)
    trust[gangId] = trust[gangId] or {}
    local value = math.max(0, (trust[gangId][contact] or 0) + amount)
    trust[gangId][contact] = value
    MySQL.prepare([[
        INSERT INTO vg_contacts (gang_id, contact, trust, tier, last_job_at) VALUES (?, ?, ?, ?, NOW())
        ON DUPLICATE KEY UPDATE trust = VALUES(trust), tier = VALUES(tier), last_job_at = NOW()
    ]], { gangId, contact, value, Contracts.Tier(gangId, contact) })
end

-------------------------------------------------------------------------------
-- Generating offers
-------------------------------------------------------------------------------

local function routePair(pool)
    for _ = 1, 20 do
        local a, b = pick(pool), pick(pool)
        if a ~= b and #(v3(a) - v3(b)) >= cfg.minRouteDistance then return a, b end
    end
    return nil
end

local generators = {
    courier = function()
        local from, to = routePair(cfg.locations.general)
        if not from then return nil end
        return { pickup = from, drop = to }, ('Pick up a package in %s and drop it in %s.'):format(areaLabel(from), areaLabel(to))
    end,
    transport = function(t)
        local spot = pick(cfg.locations.vehicles)
        local drop
        for _ = 1, 20 do
            local d = pick(cfg.locations.general)
            if #(v3(d) - v3(spot)) >= cfg.minRouteDistance then drop = d break end
        end
        if not drop then return nil end
        return { pickup = spot, drop = drop, model = pick(t.vehicles) },
            ('Take a car from %s and get it to %s without too much damage.'):format(areaLabel(spot), areaLabel(drop))
    end,
    collect = function(t)
        local spot = pick(cfg.locations.debtors)
        return { spot = spot, model = pick(t.peds) },
            ('Someone in %s owes money. Make him pay.'):format(areaLabel(spot))
    end,
}

local function generateOffer(gangId)
    local contact = pick(cfg.contacts)
    local key = pick(contact.templates)
    local t, gen = cfg.templates[key], generators[key]
    if not t or not gen then return end

    local data, description = gen(t)
    if not data then return end

    local difficulty = math.random(1, math.min(Contracts.Tier(gangId, contact.key), Progression.ContractCap(gangId)))
    local reward = t.reward * cfg.difficulty[difficulty].reward * (0.85 + math.random() * 0.3)
    reward = math.floor(reward / 50 + 0.5) * 50
    data.description = description

    local id = MySQL.insert.await([[
        INSERT INTO vg_contracts (template, gang_id, issued_by, difficulty, reward, reward_account, data, expires_at)
        VALUES (?, ?, ?, ?, ?, ?, ?, DATE_ADD(NOW(), INTERVAL ? MINUTE))
    ]], { key, gangId, contact.key, difficulty, reward, t.account, json.encode(data), cfg.offerMinutes })
    if not id then return end

    offers[gangId] = offers[gangId] or {}
    offers[gangId][id] = {
        id = id, template = key, contact = contact.key, difficulty = difficulty,
        reward = reward, account = t.account, data = data, expiresAt = os.time() + cfg.offerMinutes * 60,
    }
end

local function refreshBoards()
    local now = os.time()
    for gangId, list in pairs(offers) do
        if not Gangs.Get(gangId) then
            offers[gangId] = nil
        else
            for id, o in pairs(list) do
                if o.expiresAt <= now then
                    list[id] = nil
                    MySQL.update("UPDATE vg_contracts SET status = 'expired' WHERE id = ?", { id })
                end
            end
        end
    end

    for gangId in pairs(Gangs.All()) do
        if Gangs.HasOnlineMember(gangId) then
            local count = 0
            for _ in pairs(offers[gangId] or {}) do count = count + 1 end
            for _ = count + 1, cfg.offersPerGang do generateOffer(gangId) end
        end
    end
end

-------------------------------------------------------------------------------
-- Running contracts
-------------------------------------------------------------------------------

local FIRST_STAGE = { courier = 'pickup', transport = 'steal', collect = 'find' }

---What the runner's client needs. Never includes the reward maths.
local function clientView(c)
    return {
        id = c.id, template = c.template, stage = c.stage,
        secondsLeft = math.max(0, c.deadline - os.time()),
        data = {
            pickup = c.data.pickup, drop = c.data.drop, spot = c.data.spot,
            model = c.data.model, netId = c.netId, plate = c.plate,
        },
    }
end

local function setStage(c, stage, extra)
    c.stage, c.stageAt = stage, os.time()
    local src = Bridge.GetSourceFromCitizenId(c.cid)
    if src then TriggerClientEvent('vinewood_gangs:client:contractStage', src, stage, extra) end
end

local function cleanup(c)
    if c.vehicle and DoesEntityExist(c.vehicle) then DeleteEntity(c.vehicle) end
    active[c.id] = nil
    byGang[c.gangId] = nil
end

local function finish(c, result, payout)
    local src = Bridge.GetSourceFromCitizenId(c.cid)
    if src then TriggerClientEvent('vinewood_gangs:client:contractEnd', src, result, payout) end
end

local function complete(c, factor, endPoint)
    local reward = math.floor(c.reward * (factor or 1.0) * Director.Mult('contractReward'))
    local diff = cfg.difficulty[c.difficulty]
    cleanup(c)

    Ledger.Transact(c.gangId, c.account, reward, 'contract_reward', {
        citizenid = c.cid, refType = 'contract', refId = c.id, note = cfg.templates[c.template].title,
    })
    Activity.Record({ type = 'contract_complete', gangId = c.gangId, citizenid = c.cid, coords = endPoint and v3(endPoint) or nil, metadata = { contract = c.id } })
    addTrust(c.gangId, c.contact, diff.trust)
    Gangs.AddReputation(c.gangId, diff.reputation)
    MySQL.update("UPDATE vg_contracts SET status = 'completed', completed_at = NOW() WHERE id = ?", { c.id })

    finish(c, 'completed', reward)
    local m = Gangs.GetMembership(c.cid)
    Gangs.NotifyGang(c.gangId, locale('contract_done_gang', m and m.name or 'Someone', Utils.FormatMoney(reward)), 'success')
    Logger.Log(Bridge.GetSourceFromCitizenId(c.cid) or 0, 'contract_completed', ('contract %d for gang %d paid %d'):format(c.id, c.gangId, reward))
end

local function fail(c, reason)
    cleanup(c)
    addTrust(c.gangId, c.contact, cfg.difficulty[c.difficulty].failTrust)
    if Gangs.Get(c.gangId) then
        local at = c.data.pickup or c.data.spot
        Activity.Record({ type = 'contract_failed', gangId = c.gangId, citizenid = c.cid, coords = at and v3(at) or nil, metadata = { contract = c.id, reason = reason } })
        Gangs.NotifyGang(c.gangId, locale('contract_failed_gang', locale('fail_' .. reason)), 'error')
    end
    MySQL.update("UPDATE vg_contracts SET status = 'failed', completed_at = NOW() WHERE id = ?", { c.id })
    finish(c, 'failed', reason)
end

-- Rejects deliveries that would need an impossible average speed
local function plausibleTrip(c, from, to)
    local seconds = os.time() - c.stageAt
    return #(v3(from) - v3(to)) / math.max(seconds, 1) <= cfg.maxSpeed
end

local function spawnVehicle(c)
    c.plate = ('VG%06d'):format(c.id % 1000000)
    local veh, netId = JobVehicles.Spawn(c.data.model, c.data.pickup, c.plate)
    if not veh then return false end
    c.vehicle, c.netId = veh, netId
    return true
end

-- Stage handlers: handlers[template][stage][action](contract, src) -> ok, err
local handlers = {
    courier = {
        pickup = {
            pickup = function(c, src)
                if not near(src, c.data.pickup, 6.0) then return false, 'too_far' end
                setStage(c, 'deliver')
                return true
            end,
        },
        deliver = {
            deliver = function(c, src)
                if not near(src, c.data.drop, 6.0) then return false, 'too_far' end
                if not plausibleTrip(c, c.data.pickup, c.data.drop) then return false, 'too_fast' end
                complete(c, 1.0, c.data.drop)
                return true
            end,
        },
    },
    transport = {
        steal = {
            entered = function(c, src)
                if GetVehiclePedIsIn(GetPlayerPed(src), false) ~= c.vehicle then return false, 'not_in_vehicle_job' end
                setStage(c, 'deliver')
                return true
            end,
        },
        deliver = {
            handover = function(c, src)
                if not DoesEntityExist(c.vehicle) then return false, 'vehicle_lost' end
                if #(GetEntityCoords(c.vehicle) - v3(c.data.drop)) > 10.0 or not near(src, c.data.drop, 12.0) then return false, 'too_far' end
                if not plausibleTrip(c, c.data.pickup, c.data.drop) then return false, 'too_fast' end
                complete(c, math.max(0.4, JobVehicles.Condition(c.vehicle)), c.data.drop)
                return true
            end,
        },
    },
    collect = {
        find = {
            intimidate = function(c, src)
                if not near(src, c.data.spot, 30.0) then return false, 'too_far' end
                local t = cfg.templates.collect
                Activity.Record({ type = 'intimidation', gangId = c.gangId, citizenid = c.cid, coords = v3(c.data.spot) })
                local payChance = t.payChance - (c.difficulty - 1) * 0.1
                if math.random() < payChance then
                    complete(c, 1.0, c.data.spot)
                    return true, 'paid'
                end
                local outcome = math.random() < t.fightChance and 'fight' or 'flee'
                setStage(c, outcome == 'fight' and 'fight' or 'chase', outcome)
                if outcome == 'fight' then
                    Bridge.Dispatch.Witness(Config.Witnesses.assault, {
                        preset = 'fight', title = 'Assault in progress', priority = 1, coords = v3(c.data.spot),
                        description = 'Caller reports two men fighting, one armed with a bat.',
                    })
                end
                return true, outcome
            end,
        },
        chase = {
            caught = function(c, src)
                if os.time() - c.stageAt < 3 or not near(src, c.data.spot, 400.0) then return false, 'invalid' end
                complete(c, 1.0, c.data.spot)
                return true, 'paid'
            end,
        },
        fight = {
            subdued = function(c, src)
                if os.time() - c.stageAt < 3 or not near(src, c.data.spot, 200.0) then return false, 'invalid' end
                Activity.Record({ type = 'intimidation', gangId = c.gangId, citizenid = c.cid, coords = v3(c.data.spot), multiplier = 2.0 })
                complete(c, 0.8, c.data.spot)
                return true, 'paid'
            end,
        },
    },
}

-------------------------------------------------------------------------------
-- Public API (tablet + runner client)
-------------------------------------------------------------------------------

---The contract a gang is running right now, with where the runner is (for informant tips).
function Contracts.ActiveFor(gangId)
    local id = byGang[gangId]
    local c = id and active[id]
    if not c then return nil end
    local src = Bridge.GetSourceFromCitizenId(c.cid)
    return { id = c.id, title = cfg.templates[c.template].title, coords = src and GetEntityCoords(GetPlayerPed(src)) or nil }
end

---Adds a prize job straight to a gang's board (auction lot). Highest risk, multiplied reward.
function Contracts.InjectOffer(gangId, multiplier)
    for _ = 1, 10 do
        local existing = {}
        for id in pairs(offers[gangId] or {}) do existing[id] = true end
        generateOffer(gangId)
        for id, o in pairs(offers[gangId] or {}) do
            if not existing[id] then
                o.difficulty = #cfg.difficulty
                o.reward = math.floor(o.reward * multiplier / 50 + 0.5) * 50
                o.expiresAt = os.time() + 3 * 3600
                MySQL.update('UPDATE vg_contracts SET difficulty = ?, reward = ?, expires_at = DATE_ADD(NOW(), INTERVAL 3 HOUR) WHERE id = ?', { o.difficulty, o.reward, o.id })
                return true
            end
        end
    end
    return false
end

function Contracts.Board(src)
    local gang, _, cid = Gangs.GetPlayerGang(src)
    if not gang then return nil, 'not_in_gang' end

    local list = {}
    for _, o in pairs(offers[gang.id] or {}) do
        local t = cfg.templates[o.template]
        list[#list + 1] = {
            id = o.id, title = t.title, description = o.data.description,
            contact = contactsByKey[o.contact] and contactsByKey[o.contact].label or o.contact,
            difficulty = cfg.difficulty[o.difficulty].label, level = o.difficulty,
            reward = o.reward, account = o.account,
            minutes = math.floor(t.timeLimit / 60), expiresIn = math.max(0, o.expiresAt - os.time()),
        }
    end
    table.sort(list, function(a, b) return a.reward > b.reward end)

    local current
    local id = byGang[gang.id]
    if id and active[id] then
        local c = active[id]
        local runner = Gangs.GetMembership(c.cid)
        current = {
            id = c.id, template = c.template, stage = c.stage, title = cfg.templates[c.template].title,
            description = c.data.description, runner = runner and runner.name or 'A member',
            isRunner = c.cid == cid, secondsLeft = math.max(0, c.deadline - os.time()), reward = c.reward,
        }
    end

    local contacts = {}
    for _, contact in ipairs(cfg.contacts) do
        local tier = Contracts.Tier(gang.id, contact.key)
        contacts[#contacts + 1] = {
            label = contact.label, trust = Contracts.GetTrust(gang.id, contact.key), tier = tier,
            nextAt = cfg.tiers[tier + 1], maxTier = #cfg.tiers,
        }
    end

    return {
        offers = list, active = current, contacts = contacts,
        canAccept = Gangs.HasPermission(cid, 'contracts_accept'),
    }
end

function Contracts.Accept(src, offerId)
    local gang, _, cid = Gangs.GetPlayerGang(src)
    if not gang then return false, 'not_in_gang' end
    if not Gangs.HasPermission(cid, 'contracts_accept') then return false, 'no_permission' end
    if byGang[gang.id] then return false, 'contract_active' end
    for _, c in pairs(active) do
        if c.cid == cid then return false, 'contract_active' end
    end

    offerId = tonumber(offerId)
    local o = offers[gang.id] and offers[gang.id][offerId]
    if not o or o.expiresAt <= os.time() then return false, 'offer_gone' end
    if o.difficulty > Progression.ContractCap(gang.id) then return false, 'tier_locked' end
    offers[gang.id][offerId] = nil

    local c = {
        id = o.id, gangId = gang.id, cid = cid, src = src, template = o.template, contact = o.contact,
        difficulty = o.difficulty, reward = o.reward, account = o.account, data = o.data,
        stage = FIRST_STAGE[o.template], stageAt = os.time(),
        deadline = os.time() + cfg.templates[o.template].timeLimit,
    }

    if c.template == 'transport' and not spawnVehicle(c) then
        offers[gang.id][offerId] = o
        return false, 'failed'
    end

    active[c.id], byGang[gang.id] = c, c.id
    MySQL.update("UPDATE vg_contracts SET status = 'accepted', accepted_by = ?, accepted_at = NOW() WHERE id = ?", { cid, c.id })

    if c.template == 'transport' then
        Bridge.Dispatch.Witness(cfg.policeAlertChance, {
            preset = 'vehicle_theft', title = 'Vehicle theft', code = 'TWOC', priority = 2,
            coords = v3(c.data.pickup), description = ('Caller reports a %s being taken from %s.'):format(c.data.model, c.data.pickup.label),
        })
    end

    TriggerClientEvent('vinewood_gangs:client:contractStart', src, clientView(c))
    Gangs.NotifyGang(gang.id, locale('contract_started_gang', Bridge.GetCharName(src), cfg.templates[c.template].title), 'inform')
    return true
end

function Contracts.Abandon(src)
    local gang, _, cid = Gangs.GetPlayerGang(src)
    if not gang then return false, 'not_in_gang' end
    local c = byGang[gang.id] and active[byGang[gang.id]]
    if not c then return false, 'no_contract' end
    if c.cid ~= cid and not Gangs.HasPermission(cid, 'contracts_accept') then return false, 'no_permission' end
    fail(c, 'abandoned')
    return true
end

function Contracts.Action(src, contractId, actionName)
    local c = active[tonumber(contractId)]
    local cid = Bridge.GetCitizenId(src)
    if not c or c.cid ~= cid then return false, 'no_contract' end
    if os.time() > c.deadline then
        fail(c, 'out_of_time')
        return false, 'contract_expired'
    end
    local stage = handlers[c.template] and handlers[c.template][c.stage]
    local fn = stage and stage[actionName]
    if not fn then return false, 'invalid' end
    return fn(c, src)
end

---Lets a runner who relogged or restarted their client pick the job back up.
function Contracts.Resume(src)
    local cid = Bridge.GetCitizenId(src)
    for _, c in pairs(active) do
        if c.cid == cid then
            c.src = src
            return clientView(c)
        end
    end
    return nil
end

function Contracts.GiveKeys(src, netId)
    local cid = Bridge.GetCitizenId(src)
    for _, c in pairs(active) do
        if c.cid == cid and c.netId == netId and DoesEntityExist(c.vehicle) and GetResourceState('qbx_vehiclekeys') == 'started' then
            exports.qbx_vehiclekeys:GiveKeys(src, c.vehicle, true)
        end
    end
end

-------------------------------------------------------------------------------
-- Lifecycle
-------------------------------------------------------------------------------

function Contracts.Load()
    -- Anything mid-run when the resource stopped can't be resumed
    MySQL.update.await("UPDATE vg_contracts SET status = 'failed' WHERE status = 'accepted'")
    MySQL.update.await("UPDATE vg_contracts SET status = 'expired' WHERE status = 'available' AND expires_at < NOW()")

    offers, trust = {}, {}
    for _, r in ipairs(MySQL.query.await([[
        SELECT id, template, gang_id, issued_by, difficulty, reward, reward_account, data, UNIX_TIMESTAMP(expires_at) AS exp
        FROM vg_contracts WHERE status = 'available' AND gang_id IS NOT NULL
    ]])) do
        local ok, data = pcall(json.decode, r.data)
        if ok and data and Gangs.Get(r.gang_id) and cfg.templates[r.template] and contactsByKey[r.issued_by] then
            offers[r.gang_id] = offers[r.gang_id] or {}
            offers[r.gang_id][r.id] = {
                id = r.id, template = r.template, contact = r.issued_by, difficulty = math.min(r.difficulty, #cfg.difficulty),
                reward = r.reward, account = r.reward_account, data = data, expiresAt = r.exp,
            }
        end
    end

    for _, r in ipairs(MySQL.query.await('SELECT gang_id, contact, trust FROM vg_contacts')) do
        trust[r.gang_id] = trust[r.gang_id] or {}
        trust[r.gang_id][r.contact] = r.trust
    end
end

function Contracts.Start()
    if not Config.Modules.contracts then return end
    CreateThread(function()
        Wait(5000)
        while true do
            refreshBoards()
            Wait(cfg.refreshMinutes * 60000)
        end
    end)

    -- Deadlines and lost vehicles
    CreateThread(function()
        while true do
            Wait(5000)
            local now = os.time()
            for _, c in pairs(active) do
                if now > c.deadline then
                    fail(c, 'out_of_time')
                elseif c.vehicle and JobVehicles.Gone(c.vehicle) then
                    c.vehicle = nil
                    fail(c, 'vehicle_lost')
                end
            end
        end
    end)
end

-- Runner leaving fails the job (after a short grace period for crashes)
AddEventHandler('playerDropped', function()
    local src = source
    for _, c in pairs(active) do
        if c.src == src then
            local cid = c.cid
            SetTimeout(120000, function()
                if active[c.id] and not Bridge.GetSourceFromCitizenId(cid) then fail(c, 'runner_left') end
            end)
        end
    end
end)

AddEventHandler('vinewood_gangs:server:gangDisbanded', function(gangId)
    local id = byGang[gangId]
    if id and active[id] then cleanup(active[id]) end
    offers[gangId], trust[gangId] = nil, nil
end)

AddEventHandler('onResourceStop', function(res)
    if res ~= GetCurrentResourceName() then return end
    for _, c in pairs(active) do
        if c.vehicle and DoesEntityExist(c.vehicle) then DeleteEntity(c.vehicle) end
    end
end)
