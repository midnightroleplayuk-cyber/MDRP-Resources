Progression = {}

local cfg = Config.Progression
local progress = {} -- progress[gangId] = { reached, stats = {}, buffer }
local lastTier = {} -- lastTier[gangId] = tier last time we looked (to spot changes)

local FEATURE_TIER = {}
for t, def in ipairs(cfg.tiers) do
    for _, feature in ipairs(def.unlocks) do FEATURE_TIER[feature] = t end
end

local function get(gangId)
    local p = progress[gangId]
    if not p then
        p = { reached = 1, stats = {}, buffer = 0 }
        progress[gangId] = p
        MySQL.prepare('INSERT IGNORE INTO vg_progress (gang_id, reached, stats) VALUES (?, 1, ?)', { gangId, json.encode({}) })
    end
    return p
end

local function save(gangId)
    local p = progress[gangId]
    MySQL.prepare('UPDATE vg_progress SET reached = ?, stats = ?, rep_buffer = ? WHERE gang_id = ?',
        { p.reached, json.encode(p.stats), p.buffer, gangId })
end

-------------------------------------------------------------------------------
-- Milestones
-------------------------------------------------------------------------------

local function areasHeld(gangId)
    local n = 0
    for zone in pairs(Config.Zones) do
        if Influence.GetOwner(zone) == gangId then n = n + 1 end
    end
    return n
end

local function value(gangId, kind)
    if kind == 'members' then return Gangs.MemberCount(gangId) end
    if kind == 'areas' then return areasHeld(gangId) end
    if kind == 'safehouses' then return Safehouses and #Safehouses.OwnedBy(gangId) or 0 end
    return math.floor(get(gangId).stats[kind] or 0)
end

local function requirements(gangId, t)
    local def = cfg.tiers[t]
    local g = Gangs.Get(gangId)
    local list = { { type = 'reputation', have = g and g.reputation or 0, need = def.reputation } }
    for _, m in ipairs(def.milestones) do
        list[#list + 1] = { type = m.type, have = value(gangId, m.type), need = m.need }
    end
    for _, r in ipairs(list) do r.done = r.have >= r.need end
    return list
end

local function allDone(list)
    for _, r in ipairs(list) do if not r.done then return false end end
    return true
end

-------------------------------------------------------------------------------
-- Tier
-------------------------------------------------------------------------------

---Current tier: the highest tier reached whose reputation the gang still holds onto.
function Progression.Tier(gangId)
    if not cfg.enabled then return #cfg.tiers end
    local g = Gangs.Get(gangId)
    if not g then return 1 end
    local p = get(gangId)
    local tier = 1
    for t = 2, math.min(p.reached, #cfg.tiers) do
        if g.reputation >= math.floor(cfg.tiers[t].reputation * cfg.keepShare) then tier = t else break end
    end
    return tier
end

function Progression.Has(gangId, feature)
    if not cfg.enabled then return true end
    local need = FEATURE_TIER[feature]
    return not need or Progression.Tier(gangId) >= need
end

function Progression.TierFor(feature) return FEATURE_TIER[feature] end

function Progression.Unlocks(gangId)
    local out = {}
    local tier = Progression.Tier(gangId)
    for feature, t in pairs(FEATURE_TIER) do out[feature] = tier >= t end
    return out
end

---Highest contract difficulty this gang may be offered.
function Progression.ContractCap(gangId)
    local cap = 1
    if Progression.Has(gangId, 'contracts_medium') then cap = 2 end
    if Progression.Has(gangId, 'contracts_high') then cap = 3 end
    return cap
end

---Promotes when the next tier's requirements are all met; reports tier changes either way.
function Progression.Check(gangId)
    if not cfg.enabled or not Gangs.Get(gangId) then return end
    local p = get(gangId)
    local promoted = false
    while p.reached < #cfg.tiers and allDone(requirements(gangId, p.reached + 1)) do
        p.reached = p.reached + 1
        promoted = true
    end
    if promoted then save(gangId) end

    local tier = Progression.Tier(gangId)
    local before = lastTier[gangId] or tier
    lastTier[gangId] = tier
    if tier ~= before then
        local g = Gangs.Get(gangId)
        local label = cfg.tiers[tier].label
        if tier > before then
            Gangs.NotifyGang(gangId, locale('tier_up', label), 'success')
            for other in pairs(Gangs.All()) do
                if other ~= gangId then Gangs.NotifyGang(other, locale('tier_up_announce', g.label, label), 'inform') end
            end
        else
            Gangs.NotifyGang(gangId, locale('tier_down', label), 'error')
        end
        Gangs.SyncGang(gangId)
        Logger.Log(0, 'gang_tier', ('gang %d is now tier %d (%s)'):format(gangId, tier, label))
    end
end

-------------------------------------------------------------------------------
-- Earning
-------------------------------------------------------------------------------

---Fractional reputation builds up until it's worth a whole point.
function Progression.AddRep(gangId, amount)
    if not Gangs.Get(gangId) or amount == 0 then return end
    local p = get(gangId)
    p.buffer = p.buffer + amount
    local whole = p.buffer >= 0 and math.floor(p.buffer) or math.ceil(p.buffer)
    if whole ~= 0 then
        p.buffer = p.buffer - whole
        Gangs.AddReputation(gangId, whole) -- calls Progression.Check
    end
    save(gangId)
end

function Progression.Count(gangId, kind, amount)
    if not Gangs.Get(gangId) then return end
    local p = get(gangId)
    p.stats[kind] = (p.stats[kind] or 0) + (amount or 1)
    save(gangId)
    Progression.Check(gangId)
end

local COUNTED = { contract_complete = 'contracts', graffiti_tag = 'tags' }

---Called from Activity.Record for every criminal action.
function Progression.OnActivity(kind, gangId, multiplier, targetGangId)
    if COUNTED[kind] then Progression.Count(gangId, COUNTED[kind], 1) end
    local r = cfg.reputation[kind]
    if not r then return end
    if r.gain then Progression.AddRep(gangId, r.gain * (multiplier or 1)) end
    if r.victim and targetGangId then Progression.AddRep(targetGangId, r.victim) end
end

-------------------------------------------------------------------------------
-- Views
-------------------------------------------------------------------------------

function Progression.View(gangId)
    if not cfg.enabled then return nil end
    local tier = Progression.Tier(gangId)
    local p = get(gangId)
    local g = Gangs.Get(gangId)
    local view = {
        tier = tier, label = cfg.tiers[tier].label, max = #cfg.tiers, reputation = g and g.reputation or 0,
        slipping = p.reached > tier, -- they reached higher but lost the reputation to keep it
    }
    if p.reached > tier then
        view.regain = { label = cfg.tiers[p.reached].label, need = math.floor(cfg.tiers[p.reached].reputation * cfg.keepShare) }
    end
    local nextT = math.max(tier, p.reached) + 1
    if nextT <= #cfg.tiers then
        view.next = { tier = nextT, label = cfg.tiers[nextT].label, requirements = requirements(gangId, nextT), unlocks = cfg.tiers[nextT].unlocks }
    end
    return view
end

function Progression.AdminSetTier(src, gangId, tier)
    gangId, tier = tonumber(gangId), tonumber(tier)
    local g = gangId and Gangs.Get(gangId)
    if not g or not tier or not cfg.tiers[tier] then return false, 'invalid' end
    local p = get(gangId)
    p.reached = tier
    save(gangId)
    local need = cfg.tiers[tier].reputation
    if g.reputation < need then Gangs.AddReputation(gangId, need - g.reputation) end
    Progression.Check(gangId)
    Gangs.SyncGang(gangId)
    Logger.Log(src, 'staff_set_tier', ('gang %d set to tier %d'):format(gangId, tier))
    return true
end

-------------------------------------------------------------------------------
-- Lifecycle
-------------------------------------------------------------------------------

function Progression.Load()
    progress = {}
    for _, r in ipairs(MySQL.query.await('SELECT gang_id, reached, stats, rep_buffer FROM vg_progress')) do
        local ok, stats = pcall(json.decode, r.stats or '{}')
        progress[r.gang_id] = { reached = math.max(1, math.min(r.reached, #cfg.tiers)), stats = (ok and type(stats) == 'table') and stats or {}, buffer = tonumber(r.rep_buffer) or 0 }
    end
    for gangId in pairs(Gangs.All()) do lastTier[gangId] = Progression.Tier(gangId) end
end

function Progression.Start()
    if not cfg.enabled then return end
    -- Holding areas: every hour each gang earns area-hours and reputation for what it holds
    CreateThread(function()
        while true do
            Wait(3600000)
            for gangId in pairs(Gangs.All()) do
                local held = areasHeld(gangId)
                if held > 0 then
                    Progression.Count(gangId, 'area_hours', held)
                    Progression.AddRep(gangId, cfg.areaHourReputation * held)
                end
            end
        end
    end)
    -- Current-state milestones (members, areas, safehouses) can be met at any time
    CreateThread(function()
        while true do
            Wait(120000)
            for gangId in pairs(Gangs.All()) do Progression.Check(gangId) end
        end
    end)
end
