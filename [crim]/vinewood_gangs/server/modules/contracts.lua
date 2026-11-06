Contracts = {}

local cfg = Config.Contracts
local offers = {}   -- offers[gangId][id] = offer
local active = {}   -- active[id] = running contract state
local byGang = {}   -- byGang[gangId] = active contract id
local trust = {}    -- trust[gangId][contactKey] = number

local contactsByKey = {}
local function indexContacts()
    contactsByKey = {}
    for _, c in ipairs(cfg.contacts) do contactsByKey[c.key] = c end
end
indexContacts()

-------------------------------------------------------------------------------
-- Settings staff can change in game (/gangadmin > Contracts > Job types & board).
-- config/contracts.lua is the starting point; saved changes are applied on top of it.
-------------------------------------------------------------------------------

local BOARD = { 'offersPerGang', 'offerMinutes', 'refreshMinutes', 'minRouteDistance', 'policeAlertChance' }
local TEMPLATE_FIELDS = { 'title', 'reward', 'account', 'timeLimit', 'vehicles', 'peds', 'payChance', 'fightChance' }

local function copy(v)
    if type(v) ~= 'table' then return v end
    local out = {}
    for k, x in pairs(v) do out[k] = copy(x) end
    return out
end

local function snapshot()
    local s = { difficulty = copy(cfg.difficulty), tiers = copy(cfg.tiers), contacts = copy(cfg.contacts), templates = {} }
    for _, k in ipairs(BOARD) do s[k] = cfg[k] end
    for key, t in pairs(cfg.templates) do
        s.templates[key] = {}
        for _, f in ipairs(TEMPLATE_FIELDS) do s.templates[key][f] = copy(t[f]) end
    end
    return s
end
local DEFAULTS = snapshot()

local function applySettings(s)
    for _, k in ipairs(BOARD) do cfg[k] = s[k] end
    cfg.difficulty, cfg.tiers, cfg.contacts = s.difficulty, s.tiers, s.contacts
    for key, t in pairs(s.templates) do
        local cur = cfg.templates[key]
        if cur then for _, f in ipairs(TEMPLATE_FIELDS) do if t[f] ~= nil then cur[f] = t[f] end end end
    end
    indexContacts()
end

local function text(v, max) return tostring(v or ''):gsub('[<>]', ''):match('^%s*(.-)%s*$'):sub(1, max) end
local function num(v, lo, hi, d) v = tonumber(v) return v and math.max(lo, math.min(hi, v)) or d end

---Checks and tidies settings from the staff panel. Returns settings, or nil and a reason.
local function cleanSettings(input)
    if type(input) ~= 'table' then return nil, 'invalid' end
    local s = { templates = {} }
    s.offersPerGang = math.floor(num(input.offersPerGang, 1, 10, DEFAULTS.offersPerGang))
    s.offerMinutes = math.floor(num(input.offerMinutes, 5, 600, DEFAULTS.offerMinutes))
    s.refreshMinutes = math.floor(num(input.refreshMinutes, 1, 60, DEFAULTS.refreshMinutes))
    s.minRouteDistance = num(input.minRouteDistance, 100, 5000, DEFAULTS.minRouteDistance)
    s.policeAlertChance = num(input.policeAlertChance, 0, 1, DEFAULTS.policeAlertChance)

    if type(input.difficulty) ~= 'table' or #input.difficulty ~= #DEFAULTS.difficulty then return nil, 'invalid' end
    s.difficulty = {}
    for i, d in ipairs(input.difficulty) do
        local label = text(d.label, 24)
        s.difficulty[i] = {
            label = #label > 0 and label or DEFAULTS.difficulty[i].label,
            reward = num(d.reward, 0.1, 10, 1), trust = math.floor(num(d.trust, 0, 100, 5)),
            reputation = math.floor(num(d.reputation, 0, 100, 2)), failTrust = -math.abs(math.floor(num(d.failTrust, -100, 100, -3))),
        }
    end

    if type(input.tiers) ~= 'table' then return nil, 'invalid' end
    s.tiers = {}
    local last = 0
    for i = 1, #DEFAULTS.tiers do
        local v = i == 1 and 0 or math.floor(num(input.tiers[i], 0, 100000, DEFAULTS.tiers[i]))
        if v < last then return nil, 'contracts_tiers_order' end
        s.tiers[i], last = v, v
    end

    for key in pairs(DEFAULTS.templates) do
        local t = type(input.templates) == 'table' and input.templates[key] or {}
        local d = DEFAULTS.templates[key]
        local title = text(t.title, 40)
        local out = {
            title = #title >= 2 and title or d.title,
            reward = math.floor(num(t.reward, 0, 10000000, d.reward)),
            account = t.account == 'clean' and 'clean' or 'dirty',
            timeLimit = math.floor(num(t.timeLimit, 180, 7200, d.timeLimit)),
        }
        local function models(list, fallback)
            local m = {}
            for _, name in ipairs(type(list) == 'table' and list or {}) do
                name = text(name, 32):lower()
                if name:match('^[%w_]+$') then m[#m + 1] = name end
            end
            return #m > 0 and m or fallback
        end
        if d.vehicles then out.vehicles = models(t.vehicles, d.vehicles) end
        if d.peds then out.peds = models(t.peds, d.peds) end
        if d.payChance then out.payChance = num(t.payChance, 0, 1, d.payChance) end
        if d.fightChance then out.fightChance = num(t.fightChance, 0, 1, d.fightChance) end
        s.templates[key] = out
    end

    s.contacts = {}
    local used = {}
    for _, c in ipairs(type(input.contacts) == 'table' and input.contacts or {}) do
        if #s.contacts >= 20 then break end
        local label = text(c.label, 32)
        if #label >= 2 then
            local key = text(c.key, 32)
            if key == '' or not key:match('^[%w_]+$') then
                key = label:lower():gsub('[^%w]+', '_'):gsub('^_+', ''):gsub('_+$', ''):sub(1, 24)
            end
            local base, n = key, 1
            while used[key] do n = n + 1 key = base .. '_' .. n end
            used[key] = true
            local templates = {}
            for _, t in ipairs(type(c.templates) == 'table' and c.templates or {}) do
                if cfg.templates[t] then templates[#templates + 1] = t end
            end
            if #templates == 0 then return nil, 'contracts_contact_no_jobs' end
            s.contacts[#s.contacts + 1] = { key = key, label = label, templates = templates }
        end
    end
    if #s.contacts == 0 then return nil, 'contracts_need_contact' end
    return s
end

function Contracts.AdminSettings()
    local s = snapshot()
    s.templateKeys = {}
    for key in pairs(cfg.templates) do s.templateKeys[#s.templateKeys + 1] = key end
    table.sort(s.templateKeys)
    return s
end

function Contracts.AdminSaveSettings(src, input)
    local s, err = cleanSettings(input)
    if not s then return false, err end
    applySettings(s)
    MySQL.insert.await("INSERT INTO vg_settings (`key`, value, updated_by) VALUES ('contracts_config', ?, ?) ON DUPLICATE KEY UPDATE value = VALUES(value), updated_by = VALUES(updated_by)",
        { json.encode(s), Bridge.GetCitizenId(src) or 'console' })
    Logger.Log(src, 'staff_contract_settings', 'changed contract job types and board settings')
    return true, Contracts.AdminSettings()
end

function Contracts.AdminResetSettings(src)
    applySettings(copy(DEFAULTS))
    MySQL.update.await("DELETE FROM vg_settings WHERE `key` = 'contracts_config'")
    Logger.Log(src, 'staff_contract_settings_reset', 'reset contract settings to config/contracts.lua')
    return true, Contracts.AdminSettings()
end

local function loadSettings()
    local raw = MySQL.scalar.await("SELECT value FROM vg_settings WHERE `key` = 'contracts_config'")
    if not raw then return end
    local ok, saved = pcall(json.decode, raw)
    local s = ok and cleanSettings(saved)
    if s then applySettings(s) end
end

local function pick(list) return list[math.random(#list)] end
local function titleOf(c) return (c.data and c.data.title) or cfg.templates[c.template].title end
local function minutesOf(o) return (o.data and o.data.timeLimit) or cfg.templates[o.template].timeLimit end
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

local function storeOffer(gangId, key, contactKey, difficulty, reward, account, data, minutes)
    local id = MySQL.insert.await([[
        INSERT INTO vg_contracts (template, gang_id, issued_by, difficulty, reward, reward_account, data, expires_at)
        VALUES (?, ?, ?, ?, ?, ?, ?, DATE_ADD(NOW(), INTERVAL ? MINUTE))
    ]], { key, gangId, contactKey, difficulty, reward, account, json.encode(data), minutes or cfg.offerMinutes })
    if not id then return nil end
    offers[gangId] = offers[gangId] or {}
    offers[gangId][id] = {
        id = id, template = key, contact = contactKey, difficulty = difficulty,
        reward = reward, account = account, data = data, expiresAt = os.time() + (minutes or cfg.offerMinutes) * 60,
    }
    return offers[gangId][id]
end

---Is this custom contract already on the gang's board (or being run by them)?
function Contracts.HasCustom(gangId, jobId)
    for _, o in pairs(offers[gangId] or {}) do if o.data.custom == jobId then return true end end
    local id = byGang[gangId]
    return id and active[id] and active[id].data.custom == jobId or false
end

---Puts one of staff's custom contracts on a gang's board. Fixed spots are used; random ones come from the spot lists.
function Contracts.OfferCustom(gangId, job, minutes)
    local gen = generators[job.type]
    local t = cfg.templates[job.type]
    if not gen or not t then return nil end
    local data = gen(t)
    if not data then return nil end
    if job.pickup then data.pickup = job.pickup end
    if job.drop then data.drop = job.drop end
    if job.spot then data.spot = job.spot end
    if job.model and job.model ~= '' then data.model = job.model end
    data.title = job.title
    data.description = job.description ~= '' and job.description or nil
    if not data.description then
        if job.type == 'collect' then data.description = ('Someone in %s owes money. Make him pay.'):format(areaLabel(data.spot))
        elseif job.type == 'transport' then data.description = ('Take a car from %s and get it to %s without too much damage.'):format(areaLabel(data.pickup), areaLabel(data.drop))
        else data.description = ('Pick up a package in %s and drop it in %s.'):format(areaLabel(data.pickup), areaLabel(data.drop)) end
    end
    data.contactLabel, data.timeLimit = job.contact, job.timeLimit * 60
    data.rewardItems, data.rewardRep, data.custom = job.items, job.reputation, job.id
    return storeOffer(gangId, job.type, 'custom', job.difficulty, job.money, job.account, data, minutes)
end

local function generateOffer(gangId)
    -- Now and then, one of staff's custom contracts instead
    local job = CustomContracts and CustomContracts.PickFor(gangId)
    if job and Contracts.OfferCustom(gangId, job) then return end

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

Contracts._refresh = function() refreshBoards() end -- for tests

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

    if reward > 0 then Ledger.Transact(c.gangId, c.account, reward, 'contract_reward', {
        citizenid = c.cid, refType = 'contract', refId = c.id, note = titleOf(c),
    })
    end
    local runner = Bridge.GetSourceFromCitizenId(c.cid)
    for _, it in ipairs(c.data.rewardItems or {}) do
        if runner then Bridge.AddItem(runner, it.item, it.count) end
    end
    if (c.data.rewardRep or 0) > 0 then Gangs.AddReputation(c.gangId, c.data.rewardRep) end
    if c.data.custom and CustomContracts then CustomContracts.Completed(c.data.custom) end
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
    return { id = c.id, title = titleOf(c), coords = src and GetEntityCoords(GetPlayerPed(src)) or nil }
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
        local extras = {}
        for _, it in ipairs(o.data.rewardItems or {}) do extras[#extras + 1] = ('%d x %s'):format(it.count, it.label or Bridge.ItemLabel(it.item)) end
        if (o.data.rewardRep or 0) > 0 then extras[#extras + 1] = ('+%d reputation'):format(o.data.rewardRep) end
        list[#list + 1] = {
            id = o.id, title = o.data.title or cfg.templates[o.template].title, description = o.data.description,
            contact = o.data.contactLabel or (contactsByKey[o.contact] and contactsByKey[o.contact].label) or o.contact,
            difficulty = cfg.difficulty[o.difficulty].label, level = o.difficulty,
            reward = o.reward, account = o.account, extras = #extras > 0 and extras or nil, special = o.data.custom ~= nil,
            minutes = math.floor(minutesOf(o) / 60), expiresIn = math.max(0, o.expiresAt - os.time()),
        }
    end
    table.sort(list, function(a, b) return a.reward > b.reward end)

    local current
    local id = byGang[gang.id]
    if id and active[id] then
        local c = active[id]
        local runner = Gangs.GetMembership(c.cid)
        current = {
            id = c.id, template = c.template, stage = c.stage, title = titleOf(c),
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
        deadline = os.time() + minutesOf(o),
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
    Gangs.NotifyGang(gang.id, locale('contract_started_gang', Bridge.GetCharName(src), titleOf(c)), 'inform')
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
    loadSettings()
    -- Anything mid-run when the resource stopped can't be resumed
    MySQL.update.await("UPDATE vg_contracts SET status = 'failed' WHERE status = 'accepted'")
    MySQL.update.await("UPDATE vg_contracts SET status = 'expired' WHERE status = 'available' AND expires_at < NOW()")

    offers, trust = {}, {}
    for _, r in ipairs(MySQL.query.await([[
        SELECT id, template, gang_id, issued_by, difficulty, reward, reward_account, data, UNIX_TIMESTAMP(expires_at) AS exp
        FROM vg_contracts WHERE status = 'available' AND gang_id IS NOT NULL
    ]])) do
        local ok, data = pcall(json.decode, r.data)
        if ok and data and Gangs.Get(r.gang_id) and cfg.templates[r.template] and (contactsByKey[r.issued_by] or (data and data.custom)) then
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
