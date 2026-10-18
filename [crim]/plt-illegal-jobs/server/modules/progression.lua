local Inventory = require 'server.modules.inventory'
local Utils = require 'server.modules.utils'

Progression = {}

local function defaultsCrypto()
    local cfg = Config.Progression and Config.Progression.Crypto
    local bal = (cfg and cfg.defaultBalances) or { snc = 0, dnt = 0, xmr = 0 }
    return {
        snc = tonumber(bal.snc) or 0,
        dnt = tonumber(bal.dnt) or 0,
        xmr = tonumber(bal.xmr) or 0,
    }
end

local function cryptoEnabled()
    local cfg = Config.Progression and Config.Progression.Crypto
    return not cfg or cfg.enabled ~= false
end

--- Config.DirtyMoney or Config.CleanMoney, per Config.Progression.Crypto.fallbackCurrency,
--- used for job start costs/rewards when the SNC economy is disabled.
local function fallbackCurrencyConfig()
    local cfg = Config.Progression and Config.Progression.Crypto
    local which = (cfg and cfg.fallbackCurrency) or 'dirty'
    return which == 'clean' and Config.CleanMoney or Config.DirtyMoney
end

local function takeFallbackCurrency(source, amount)
    amount = math.floor(tonumber(amount) or 0)
    if amount <= 0 then return true end
    local currency = fallbackCurrencyConfig()
    if currency.isItem then
        if not Inventory.hasItem(source, currency.itemName, amount) then return false end
        return Inventory.removeItem(source, currency.itemName, amount)
    end
    local bal = server.getPlayerBalance and server.getPlayerBalance(source, currency.accountName) or 0
    if bal < amount then return false end
    server.playerRemoveMoney(source, currency.accountName, amount)
    return true
end

local function giveFallbackCurrency(source, amount)
    amount = math.floor(tonumber(amount) or 0)
    if amount <= 0 then return true end
    local currency = fallbackCurrencyConfig()
    if currency.isItem then
        return Inventory.giveItem(source, currency.itemName, amount)
    end
    server.playerAddMoney(source, currency.accountName, amount)
    return true
end

local function decodeJson(raw, fallback)
    if type(raw) == 'table' then return raw end
    if type(raw) ~= 'string' or raw == '' then return fallback end
    local ok, parsed = pcall(json.decode, raw)
    if ok and type(parsed) == 'table' then return parsed end
    return fallback
end

local function encodeJson(value)
    return json.encode(value or {})
end

function Progression.normalizeProfile(profile)
    if not profile then return nil end

    profile.job_stats = decodeJson(profile.job_stats, {})
    if type(profile.job_stats) ~= 'table' then profile.job_stats = {} end

    local unlocks = decodeJson(profile.skill_unlocks, {})
    if type(unlocks) == 'table' and unlocks[1] == nil and next(unlocks) then
        -- already a set-like map; convert to list
        local list = {}
        for id, on in pairs(unlocks) do
            if on then list[#list + 1] = id end
        end
        unlocks = list
    elseif type(unlocks) ~= 'table' then
        unlocks = {}
    end
    profile.skill_unlocks = unlocks

    local crypto = decodeJson(profile.crypto_balances, nil) or defaultsCrypto()
    local base = defaultsCrypto()
    profile.crypto_balances = {
        snc = tonumber(crypto.snc) or base.snc,
        dnt = tonumber(crypto.dnt) or base.dnt,
        xmr = tonumber(crypto.xmr) or base.xmr,
    }

    local grantsClaimed = decodeJson(profile.skill_grants_claimed, {})
    if type(grantsClaimed) ~= 'table' then grantsClaimed = {} end
    profile.skill_grants_claimed = grantsClaimed

    profile.job_stats_json = encodeJson(profile.job_stats)
    profile.skill_unlocks_json = encodeJson(profile.skill_unlocks)
    profile.crypto_balances_json = encodeJson(profile.crypto_balances)
    profile.skill_grants_claimed_json = encodeJson(profile.skill_grants_claimed)
    return profile
end

function Progression.serializeProfile(profile)
    if not profile then return end
    profile.job_stats_json = encodeJson(profile.job_stats or {})
    profile.skill_unlocks_json = encodeJson(profile.skill_unlocks or {})
    profile.crypto_balances_json = encodeJson(profile.crypto_balances or defaultsCrypto())
    profile.skill_grants_claimed_json = encodeJson(profile.skill_grants_claimed or {})
end

function Progression.appIdForJob(jobName)
    local map = Config.Progression and Config.Progression.JobToApp
    return map and map[jobName] or nil
end

function Progression.getJobCrypto(jobName, jobData)
    local reward = jobData and jobData.reward or {}
    local central = Config.Progression and Config.Progression.Crypto and Config.Progression.Crypto.jobs
    local entry = (central and central[jobName]) or {}

    local cost = reward.cryptoCost or reward.CryptoCost or entry.cost or 0
    local rewardCfg = reward.cryptoReward or reward.CryptoReward or entry.reward

    local minR, maxR = 0, 0
    if type(rewardCfg) == 'number' then
        minR, maxR = rewardCfg, rewardCfg
    elseif type(rewardCfg) == 'table' then
        minR = tonumber(rewardCfg.min) or 0
        maxR = tonumber(rewardCfg.max) or minR
    end

    return math.max(0, math.floor(tonumber(cost) or 0)), math.max(0, minR), math.max(minR, maxR)
end

local function sumCompletions(jobStats, appIds)
    local total = 0
    for i = 1, #appIds do
        total = total + (tonumber(jobStats[appIds[i]]) or 0)
    end
    return total
end

local function hasAnyNode(unlockSet, nodeIds)
    if not nodeIds or #nodeIds == 0 then return true end
    for i = 1, #nodeIds do
        if unlockSet[nodeIds[i]] then return true end
    end
    return false
end

local function unlockSetFromList(list)
    local set = {}
    for i = 1, #(list or {}) do
        set[list[i]] = true
    end
    return set
end

function Progression.reconcileSkillUnlocks(profile)
    local jobs = profile.job_stats or {}
    local unlocked = unlockSetFromList(profile.skill_unlocks)
    local trees = Config.Progression and Config.Progression.SkillTrees or {}
    local changed = true

    while changed do
        changed = false
        for t = 1, #trees do
            local nodes = trees[t].nodes or {}
            for n = 1, #nodes do
                local node = nodes[n]
                if not unlocked[node.id] then
                    local prereqOk = true
                    for r = 1, #(node.requires or {}) do
                        if not unlocked[node.requires[r]] then
                            prereqOk = false
                            break
                        end
                    end
                    if prereqOk then
                        local tasksOk = true
                        for k = 1, #(node.tasks or {}) do
                            local task = node.tasks[k]
                            if (tonumber(jobs[task.job]) or 0) < (task.count or 0) then
                                tasksOk = false
                                break
                            end
                        end
                        if tasksOk then
                            unlocked[node.id] = true
                            changed = true
                        end
                    end
                end
            end
        end
    end

    local list = {}
    for id in pairs(unlocked) do
        list[#list + 1] = id
    end
    table.sort(list)
    profile.skill_unlocks = list
    return unlocked
end

local function findSkillNode(nodeId)
    local trees = Config.Progression and Config.Progression.SkillTrees or {}
    for t = 1, #trees do
        local nodes = trees[t].nodes or {}
        for n = 1, #nodes do
            if nodes[n].id == nodeId then return nodes[n] end
        end
    end
    return nil
end

--- Give item grants for newly-unlocked skill nodes and notify the player.
--- Only call this from a real completion event with a connected `source` —
--- reconcileSkillUnlocks itself runs from offline DB loads and admin/status
--- calls too, so it stays a pure calculation with no item side effects.
--- profile.skill_grants_claimed tracks payout separately from skill_unlocks
--- so a grant is never paid twice even if unlocks are recomputed.
function Progression.payoutSkillGrants(source, profile, nodeIds)
    if not source or not nodeIds or #nodeIds == 0 then return {} end
    profile.skill_grants_claimed = profile.skill_grants_claimed or {}
    local claimed = {}
    for i = 1, #profile.skill_grants_claimed do
        claimed[profile.skill_grants_claimed[i]] = true
    end

    local paidOut = {}
    for i = 1, #nodeIds do
        local nodeId = nodeIds[i]
        if not claimed[nodeId] then
            local node = findSkillNode(nodeId)
            if node and node.grants and #node.grants > 0 then
                for g = 1, #node.grants do
                    local grant = node.grants[g]
                    if grant.item then
                        Inventory.giveItem(source, grant.item, grant.count or 1)
                    end
                end
                Utils.server_notify(
                    source,
                    'Skill Unlocked',
                    'success',
                    ('%s — new gear delivered to your inventory'):format(nodeId)
                )
                paidOut[#paidOut + 1] = nodeId
            end
            claimed[nodeId] = true
        end
    end

    if #paidOut > 0 then
        local list = {}
        for id in pairs(claimed) do list[#list + 1] = id end
        table.sort(list)
        profile.skill_grants_claimed = list
    end
    return paidOut
end

function Progression.getUnlockedTier(profile)
    local tiers = Config.Progression and Config.Progression.Tiers or {}
    local jobStats = profile.job_stats or {}
    local unlockSet = unlockSetFromList(profile.skill_unlocks)
    local highest = 0

    for tier = 0, 4 do
        local def = tiers[tier]
        if not def then break end
        if tier == 0 then
            highest = 0
        else
            local req = def.require or {}
            local completions = sumCompletions(jobStats, req.fromApps or {})
            local minNeed = tonumber(req.minCompletions) or 0
            if completions >= minNeed and hasAnyNode(unlockSet, req.anyNodes) then
                highest = tier
            else
                break
            end
        end
    end
    return highest
end

function Progression.getUnlockedApps(profile)
    Progression.reconcileSkillUnlocks(profile)
    local unlockedTier = Progression.getUnlockedTier(profile)
    local apps = {}
    local always = Config.Progression and Config.Progression.AlwaysOpenApps or {}
    for id in pairs(always) do
        apps[id] = true
    end

    local tiers = Config.Progression and Config.Progression.Tiers or {}
    for tier = 0, unlockedTier do
        local def = tiers[tier]
        if def and def.apps then
            for i = 1, #def.apps do
                apps[def.apps[i]] = true
            end
        end
    end
    return apps, unlockedTier
end

function Progression.isAppUnlocked(profile, appId)
    if not appId then return true end
    local always = Config.Progression and Config.Progression.AlwaysOpenApps
    if always and always[appId] then return true end
    local apps = Progression.getUnlockedApps(profile)
    return apps[appId] == true
end

function Progression.clientPayload(profile)
    local apps, tier = Progression.getUnlockedApps(profile)
    return {
        jobStats = profile.job_stats or {},
        skillUnlocks = profile.skill_unlocks or {},
        cryptoBalances = profile.crypto_balances or defaultsCrypto(),
        unlockedApps = apps,
        unlockedTier = tier,
    }
end

function Progression.syncClient(source, profile)
    if not source or not profile then return end
    TriggerClientEvent(_e('client:progression:sync'), source, Progression.clientPayload(profile))
end

local function persist(profile, source)
    if source then profile.source = source end
    Progression.serializeProfile(profile)
    if profile.source then
        Profile.update(profile.source)
    end
end

function Progression.ensureBalance(profile, coinId)
    profile.crypto_balances = profile.crypto_balances or defaultsCrypto()
    local id = coinId or 'snc'
    profile.crypto_balances[id] = tonumber(profile.crypto_balances[id]) or 0
    return profile.crypto_balances[id]
end

function Progression.addCrypto(profile, coinId, amount)
    amount = tonumber(amount) or 0
    if amount == 0 then return Progression.ensureBalance(profile, coinId) end
    local bal = Progression.ensureBalance(profile, coinId)
    profile.crypto_balances[coinId] = math.max(0, bal + amount)
    return profile.crypto_balances[coinId]
end

function Progression.trySpendCrypto(profile, coinId, amount)
    amount = math.max(0, tonumber(amount) or 0)
    if amount <= 0 then return true end
    local bal = Progression.ensureBalance(profile, coinId)
    if bal < amount then return false end
    profile.crypto_balances[coinId] = bal - amount
    return true
end

function Progression.rollReward(minR, maxR)
    minR = math.floor(tonumber(minR) or 0)
    maxR = math.floor(tonumber(maxR) or minR)
    if maxR < minR then maxR = minR end
    if minR <= 0 and maxR <= 0 then return 0 end
    return math.random(minR, maxR)
end

function Progression.canStartJob(source, jobName, jobData)
    local profile = Profile.getBySource(source)
    if not profile then
        return false, 'Profile not ready'
    end
    Progression.normalizeProfile(profile)

    local appId = Progression.appIdForJob(jobName)
    if appId and not Progression.isAppUnlocked(profile, appId) then
        return false, 'App locked — grind lower-tier jobs and unlock skill nodes first'
    end

    local cost = select(1, Progression.getJobCrypto(jobName, jobData))
    if cost > 0 then
        if not cryptoEnabled() then
            local currency = fallbackCurrencyConfig()
            local have = currency.isItem
                and Inventory.getItemCountByName(source, currency.itemName)
                or (server.getPlayerBalance and server.getPlayerBalance(source, currency.accountName) or 0)
            if have < cost then
                return false, ('Not enough %s (need %s)'):format(currency.label or 'cash', cost)
            end
        else
            local bal = Progression.ensureBalance(profile, 'snc')
            if bal < cost then
                return false, ('Not enough SNC (need %s)'):format(cost)
            end
        end
    end
    return true
end

function Progression.chargeJobStart(source, jobName, jobData)
    local profile = Profile.getBySource(source)
    if not profile then return false, 'Profile not ready' end
    Progression.normalizeProfile(profile)
    local cost = select(1, Progression.getJobCrypto(jobName, jobData))

    if cost > 0 and not cryptoEnabled() then
        local currency = fallbackCurrencyConfig()
        if not takeFallbackCurrency(source, cost) then
            return false, ('Not enough %s (need %s)'):format(currency.label or 'cash', cost)
        end
        return true, cost
    end

    if cost > 0 and not Progression.trySpendCrypto(profile, 'snc', cost) then
        return false, ('Not enough SNC (need %s)'):format(cost)
    end
    if cost > 0 then
        persist(profile, source)
        Progression.syncClient(source, profile)
    end
    return true, cost
end

--- Undoes whatever chargeJobStart actually charged (SNC, or the fallback
--- currency when the SNC economy is disabled) — must mirror that function's
--- branch exactly or a refund pays back the wrong currency.
function Progression.refundCrypto(source, amount)
    amount = tonumber(amount) or 0
    if amount <= 0 then return end

    if not cryptoEnabled() then
        giveFallbackCurrency(source, amount)
        return
    end

    local profile = Profile.getBySource(source)
    if not profile then return end
    Progression.normalizeProfile(profile)
    Progression.addCrypto(profile, 'snc', amount)
    persist(profile, source)
    Progression.syncClient(source, profile)
end

function Progression.onJobFinished(source, jobName, jobData)
    local profile = Profile.getBySource(source)
    if not profile then return nil end
    Progression.normalizeProfile(profile)
    profile.source = source

    local appId = Progression.appIdForJob(jobName)
    if appId then
        profile.job_stats[appId] = (tonumber(profile.job_stats[appId]) or 0) + 1
    end

    local _, minR, maxR = Progression.getJobCrypto(jobName, jobData)
    local payout = Progression.rollReward(minR, maxR)
    if payout > 0 then
        if cryptoEnabled() then
            Progression.addCrypto(profile, 'snc', payout)
        else
            giveFallbackCurrency(source, payout)
        end
    end

    local before = unlockSetFromList(profile.skill_unlocks)
    Progression.reconcileSkillUnlocks(profile)
    local newly = {}
    for i = 1, #profile.skill_unlocks do
        local id = profile.skill_unlocks[i]
        if not before[id] then newly[#newly + 1] = id end
    end
    Progression.payoutSkillGrants(source, profile, newly)

    persist(profile, source)
    Progression.syncClient(source, profile)

    return {
        appId = appId,
        cryptoReward = payout,
        newlyUnlocked = newly,
        payload = Progression.clientPayload(profile),
    }
end

local function takeDirtyMoney(source, amount)
    amount = math.floor(tonumber(amount) or 0)
    if amount <= 0 then return true end
    if Config.DirtyMoney.isItem then
        if not Inventory.hasItem(source, Config.DirtyMoney.itemName, amount) then
            return false
        end
        return Inventory.removeItem(source, Config.DirtyMoney.itemName, amount)
    end
    local bal = server.getPlayerBalance and server.getPlayerBalance(source, Config.DirtyMoney.accountName) or 0
    if bal < amount then return false end
    server.playerRemoveMoney(source, Config.DirtyMoney.accountName, amount)
    return true
end

local function giveDirtyMoney(source, amount)
    amount = math.floor(tonumber(amount) or 0)
    if amount <= 0 then return true end
    if Config.DirtyMoney.isItem then
        return Inventory.giveItem(source, Config.DirtyMoney.itemName, amount)
    end
    server.playerAddMoney(source, Config.DirtyMoney.accountName, amount)
    return true
end

function Progression.deposit(source, sncAmount)
    sncAmount = math.floor(tonumber(sncAmount) or 0)
    if sncAmount <= 0 then return { ok = false, error = 'Invalid amount' } end

    local profile = Profile.getBySource(source)
    if not profile then return { ok = false, error = 'Profile not ready' } end
    Progression.normalizeProfile(profile)

    local rate = (Config.Progression.Crypto and Config.Progression.Crypto.dirtyMoneyPerSnc) or 100
    local dirtyCost = sncAmount * rate
    if not takeDirtyMoney(source, dirtyCost) then
        return { ok = false, error = 'Not enough dirty money' }
    end

    Progression.addCrypto(profile, 'snc', sncAmount)
    persist(profile, source)
    Progression.syncClient(source, profile)
    return { ok = true, balances = profile.crypto_balances, dirtySpent = dirtyCost }
end

function Progression.withdraw(source, sncAmount)
    sncAmount = math.floor(tonumber(sncAmount) or 0)
    if sncAmount <= 0 then return { ok = false, error = 'Invalid amount' } end

    local profile = Profile.getBySource(source)
    if not profile then return { ok = false, error = 'Profile not ready' } end
    Progression.normalizeProfile(profile)

    if not Progression.trySpendCrypto(profile, 'snc', sncAmount) then
        return { ok = false, error = 'Insufficient SNC' }
    end

    local rate = (Config.Progression.Crypto and Config.Progression.Crypto.dirtyMoneyPerSnc) or 100
    local dirtyOut = sncAmount * rate
    giveDirtyMoney(source, dirtyOut)
    persist(profile, source)
    Progression.syncClient(source, profile)
    return { ok = true, balances = profile.crypto_balances, dirtyReceived = dirtyOut }
end

function Progression.transfer(source, sncAmount, _address)
    sncAmount = math.floor(tonumber(sncAmount) or 0)
    if sncAmount <= 0 then return { ok = false, error = 'Invalid amount' } end

    local profile = Profile.getBySource(source)
    if not profile then return { ok = false, error = 'Profile not ready' } end
    Progression.normalizeProfile(profile)

    -- P2P wallet lookup not implemented; burn is blocked — require explicit peer later.
    return { ok = false, error = 'Peer transfers are disabled' }
end

-- Pending black-market pickups (van / ped delivery after purchase)
local pendingMarketPickups = {}

local function marketPickupCfg()
    local market = Config.Progression and Config.Progression.Market or {}
    return market.pickup or {}
end

local function cleanupMarketPickup(source, refund)
    local order = pendingMarketPickups[source]
    if not order then return end
    pendingMarketPickups[source] = nil

    if order.van and DoesEntityExist(order.van) then
        DeleteEntity(order.van)
    end
    if order.ped and DoesEntityExist(order.ped) then
        DeleteEntity(order.ped)
    end

    if refund and order.profile then
        -- Soft refund: restore crypto if pickup expired unclaimed
        local bal = order.profile.crypto_balances
        if bal and order.coinId and order.paid then
            bal[order.coinId] = (tonumber(bal[order.coinId]) or 0) + (tonumber(order.paid) or 0)
            persist(order.profile, source)
            Progression.syncClient(source, order.profile)
        end
    end

    TriggerClientEvent(_e('client:market:pickupClear'), source)
end

local function chooseMarketDeliveryMode(cfg)
    local mode = cfg.delivery_mode or 'random'
    if mode == 'random' then
        return (math.random(1, 2) == 1) and 'van' or 'ped'
    end
    if mode == 'van' or mode == 'ped' then return mode end
    return 'ped'
end

local function spawnMarketDelivery(source, coords, mode, cfg)
    local Utils = require 'server.modules.utils'
    local pedNetId, vanNetId = nil, nil
    local pedEnt, vanEnt = nil, nil

    if mode == 'van' then
        local model = cfg.van_model or 'rumpo'
        vanNetId, vanEnt = Utils.spawnVehicle({ model = model, coords = coords })
        if vanEnt and vanEnt ~= 0 and DoesEntityExist(vanEnt) then
            pcall(SetVehicleDoorsLocked, vanEnt, 2)
            pcall(FreezeEntityPosition, vanEnt, true)
        else
            mode = 'ped'
            vanNetId, vanEnt = nil, nil
        end
    end

    local function spawnContactPed(x, y, z, w)
        local model = cfg.ped_model or 'g_m_y_mexgoon_01'
        local ped = CreatePed(4, joaat(model), x, y, z, w or 0.0, true, true)
        if ped and ped ~= 0 and DoesEntityExist(ped) then
            pcall(FreezeEntityPosition, ped, true)
            pcall(SetEntityInvincible, ped, true)
            pcall(SetBlockingOfNonTemporaryEvents, ped, true)
            return ped, NetworkGetNetworkIdFromEntity(ped)
        end
        return nil, nil
    end

    if mode == 'ped' then
        pedEnt, pedNetId = spawnContactPed(coords.x, coords.y, coords.z, coords.w)
    elseif mode == 'van' and vanEnt and DoesEntityExist(vanEnt) then
        -- Contact standing beside the van
        local rad = math.rad((coords.w or 0.0) + 90.0)
        local px = coords.x + math.cos(rad) * 2.2
        local py = coords.y + math.sin(rad) * 2.2
        pedEnt, pedNetId = spawnContactPed(px, py, coords.z, coords.w)
    end

    if (not vanEnt or vanEnt == 0) and (not pedEnt or pedEnt == 0) then
        return { mode = mode, van = nil, ped = nil, vanNetId = nil, pedNetId = nil }
    end

    return {
        mode = mode,
        van = vanEnt,
        ped = pedEnt,
        vanNetId = vanNetId,
        pedNetId = pedNetId,
    }
end

function Progression.marketBuy(source, cart, coinId)
    coinId = coinId or 'snc'
    if type(cart) ~= 'table' then return { ok = false, error = 'Invalid cart' } end

    local profile = Profile.getBySource(source)
    if not profile then return { ok = false, error = 'Profile not ready' } end
    Progression.normalizeProfile(profile)

    if pendingMarketPickups[source] then
        return { ok = false, error = locale('market.already_pending') or 'You already have a pending pickup' }
    end

    local market = Config.Progression and Config.Progression.Market or {}
    local catalog = market.items or {}
    local coinUsd = (market.coinUsd and market.coinUsd[coinId]) or (market.sncUsd or 0.42)
    local sncUsd = market.sncUsd or 0.42
    local pickupCfg = marketPickupCfg()

    local lines = {}
    local subtotalSnc = 0
    for id, qty in pairs(cart) do
        qty = math.floor(tonumber(qty) or 0)
        if qty > 0 then
            local entry = catalog[id]
            if not entry then
                return { ok = false, error = ('Unknown item: %s'):format(id) }
            end
            subtotalSnc = subtotalSnc + (entry.price or 0) * qty
            lines[#lines + 1] = { id = id, qty = qty, itemName = entry.itemName, price = entry.price }
        end
    end

    if #lines == 0 then return { ok = false, error = 'Cart is empty' } end

    local locations = pickupCfg.locations
    if type(locations) ~= 'table' or #locations == 0 then
        return { ok = false, error = 'No pickup locations configured' }
    end

    local payAmount
    if coinId == 'snc' then
        payAmount = subtotalSnc
    else
        payAmount = (subtotalSnc * sncUsd) / coinUsd
    end
    payAmount = math.ceil(payAmount * 10000) / 10000

    if not Progression.trySpendCrypto(profile, coinId, payAmount) then
        return { ok = false, error = 'Insufficient balance' }
    end

    local coords = locations[math.random(1, #locations)]
    local mode = chooseMarketDeliveryMode(pickupCfg)
    local spawned = spawnMarketDelivery(source, coords, mode, pickupCfg)

    if (not spawned.van or spawned.van == 0) and (not spawned.ped or spawned.ped == 0) then
        -- Spawn failed — refund crypto and abort
        local bal = profile.crypto_balances
        bal[coinId] = (tonumber(bal[coinId]) or 0) + payAmount
        persist(profile, source)
        Progression.syncClient(source, profile)
        return { ok = false, error = 'Delivery contact unavailable — try again' }
    end

    local expireMs = pickupCfg.expire_ms or (15 * 60 * 1000)
    pendingMarketPickups[source] = {
        lines = lines,
        coords = coords,
        mode = spawned.mode,
        van = spawned.van,
        ped = spawned.ped,
        vanNetId = spawned.vanNetId,
        pedNetId = spawned.pedNetId,
        coinId = coinId,
        paid = payAmount,
        profile = profile,
        expiresAt = GetGameTimer() + expireMs,
    }

    persist(profile, source)
    Progression.syncClient(source, profile)

    TriggerClientEvent(_e('client:market:pickupReady'), source, {
        coords = { x = coords.x, y = coords.y, z = coords.z, w = coords.w or 0.0 },
        mode = spawned.mode,
        vanNetId = spawned.vanNetId,
        pedNetId = spawned.pedNetId,
        blip = pickupCfg.blip,
        expireMs = expireMs,
    })

    SetTimeout(expireMs, function()
        local order = pendingMarketPickups[source]
        if not order then return end
        local paid = order.paid
        local coinId = order.coinId
        cleanupMarketPickup(source, false)
        local profile = Profile.getBySource(source)
        if profile and coinId and paid then
            Progression.normalizeProfile(profile)
            local bal = profile.crypto_balances
            bal[coinId] = (tonumber(bal[coinId]) or 0) + paid
            persist(profile, source)
            Progression.syncClient(source, profile)
        end
        TriggerClientEvent(_e('client:notify'), source, locale('market.expired') or 'Black market pickup expired.', 'error')
    end)

    return {
        ok = true,
        balances = profile.crypto_balances,
        paid = payAmount,
        coinId = coinId,
        lines = lines,
        pickup = true,
        coords = { x = coords.x, y = coords.y, z = coords.z, w = coords.w or 0.0 },
        mode = spawned.mode,
    }
end

function Progression.marketClaim(source)
    local order = pendingMarketPickups[source]
    if not order then
        return { ok = false, error = locale('market.no_order') or 'No pending order' }
    end

    if order.expiresAt and GetGameTimer() > order.expiresAt then
        cleanupMarketPickup(source, true)
        return { ok = false, error = locale('market.expired') or 'Pickup expired' }
    end

    local Utils = require 'server.modules.utils'
    if order.coords and not Utils.isPlayerNearCoords(source, order.coords, 8.0) then
        return { ok = false, error = 'Too far from pickup' }
    end

    local lines = order.lines or {}
    local failed = {}
    local delivered = {}
    for i = 1, #lines do
        if Inventory.giveItem(source, lines[i].itemName, lines[i].qty) then
            delivered[#delivered + 1] = lines[i]
        else
            failed[#failed + 1] = lines[i]
        end
    end

    -- Inventory couldn't take one or more items (e.g. full/over-weight) —
    -- keep the order pending instead of silently reporting success, so the
    -- player can free up space and claim again rather than losing the item
    -- they already paid for.
    if #failed > 0 then
        order.lines = failed
        return {
            ok = false,
            error = locale('market.claim_inventory_full') or 'Inventory too full to collect — free up space and try again',
            delivered = delivered,
            failed = failed,
        }
    end

    -- Bootlegging / other listeners expecting { itemName, count }
    local receipt = {}
    for i = 1, #lines do
        receipt[#receipt + 1] = {
            itemName = lines[i].itemName,
            count = lines[i].qty,
            id = lines[i].id,
        }
    end
    TriggerClientEvent(_e('client:market:onCustomerReceivedOrder'), source, receipt)

    pendingMarketPickups[source] = nil
    if order.van and DoesEntityExist(order.van) then DeleteEntity(order.van) end
    if order.ped and DoesEntityExist(order.ped) then DeleteEntity(order.ped) end

    TriggerClientEvent(_e('client:market:pickupClear'), source)

    return { ok = true, lines = lines }
end

AddEventHandler('playerDropped', function()
    local src = source
    if pendingMarketPickups[src] then
        cleanupMarketPickup(src, true)
    end
end)

-- ─────────────────────────────────────────────────────────────────────────────
-- Admin helpers (job completions / skills / tier / crypto)
-- ─────────────────────────────────────────────────────────────────────────────

local function resolveAppId(raw)
    if not raw or raw == '' then return nil end
    raw = tostring(raw):lower():gsub('%s+', '')
    if Progression.appIdForJob(raw) then
        return Progression.appIdForJob(raw)
    end
    local map = Config.Progression and Config.Progression.JobToApp or {}
    for _, appId in pairs(map) do
        if appId == raw then return appId end
    end
    local always = Config.Progression and Config.Progression.AlwaysOpenApps or {}
    if always[raw] then return raw end
    local tiers = Config.Progression and Config.Progression.Tiers or {}
    for _, def in pairs(tiers) do
        for i = 1, #(def.apps or {}) do
            if def.apps[i] == raw then return raw end
        end
    end
    return nil
end

local function knownSkillNode(nodeId)
    local trees = Config.Progression and Config.Progression.SkillTrees or {}
    for t = 1, #trees do
        for n = 1, #(trees[t].nodes or {}) do
            if trees[t].nodes[n].id == nodeId then return true end
        end
    end
    return false
end

function Progression.adminSetJobCount(source, appOrJob, count)
    count = math.floor(tonumber(count) or -1)
    if count < 0 then return false, 'Count must be 0 or greater' end
    local appId = resolveAppId(appOrJob)
    if not appId then return false, ('Unknown job/app: %s'):format(tostring(appOrJob)) end

    local profile = Profile.getBySource(source)
    if not profile then return false, 'Profile not ready' end
    Progression.normalizeProfile(profile)
    profile.job_stats[appId] = count
    Progression.reconcileSkillUnlocks(profile)
    persist(profile, source)
    Progression.syncClient(source, profile)
    return true, {
        appId = appId,
        count = count,
        unlockedTier = Progression.getUnlockedTier(profile),
        skillUnlocks = profile.skill_unlocks,
    }
end

function Progression.adminAddJobCount(source, appOrJob, amount)
    amount = math.floor(tonumber(amount) or 0)
    if amount == 0 then return false, 'Amount cannot be 0' end
    local appId = resolveAppId(appOrJob)
    if not appId then return false, ('Unknown job/app: %s'):format(tostring(appOrJob)) end

    local profile = Profile.getBySource(source)
    if not profile then return false, 'Profile not ready' end
    Progression.normalizeProfile(profile)
    local nextCount = math.max(0, (tonumber(profile.job_stats[appId]) or 0) + amount)
    profile.job_stats[appId] = nextCount
    Progression.reconcileSkillUnlocks(profile)
    persist(profile, source)
    Progression.syncClient(source, profile)
    return true, {
        appId = appId,
        count = nextCount,
        unlockedTier = Progression.getUnlockedTier(profile),
        skillUnlocks = profile.skill_unlocks,
    }
end

function Progression.adminUnlockNode(source, nodeId)
    nodeId = tostring(nodeId or '')
    if nodeId == '' then return false, 'Missing skill node id' end
    if not knownSkillNode(nodeId) then
        return false, ('Unknown skill node: %s'):format(nodeId)
    end

    local profile = Profile.getBySource(source)
    if not profile then return false, 'Profile not ready' end
    Progression.normalizeProfile(profile)

    local set = unlockSetFromList(profile.skill_unlocks)
    if set[nodeId] then
        return true, {
            nodeId = nodeId,
            already = true,
            unlockedTier = Progression.getUnlockedTier(profile),
        }
    end
    set[nodeId] = true
    local list = {}
    for id in pairs(set) do list[#list + 1] = id end
    table.sort(list)
    profile.skill_unlocks = list
    Progression.reconcileSkillUnlocks(profile)
    persist(profile, source)
    Progression.syncClient(source, profile)
    return true, {
        nodeId = nodeId,
        already = false,
        unlockedTier = Progression.getUnlockedTier(profile),
        skillUnlocks = profile.skill_unlocks,
    }
end

--- Grant completions + required nodes so the player reaches `tier` (0-4).
function Progression.adminSetTier(source, tier)
    tier = math.floor(tonumber(tier) or -1)
    if tier < 0 or tier > 4 then return false, 'Tier must be between 0 and 4' end

    local profile = Profile.getBySource(source)
    if not profile then return false, 'Profile not ready' end
    Progression.normalizeProfile(profile)

    local tiers = Config.Progression and Config.Progression.Tiers or {}
    for t = 1, tier do
        local def = tiers[t]
        if def and def.require then
            local req = def.require
            local fromApps = req.fromApps or {}
            local minNeed = tonumber(req.minCompletions) or 0
            if #fromApps > 0 and minNeed > 0 then
                local perApp = math.ceil(minNeed / #fromApps)
                for i = 1, #fromApps do
                    local appId = fromApps[i]
                    local cur = tonumber(profile.job_stats[appId]) or 0
                    if cur < perApp then
                        profile.job_stats[appId] = perApp
                    end
                end
                -- Ensure sum is enough even with uneven rounding
                local sum = sumCompletions(profile.job_stats, fromApps)
                if sum < minNeed then
                    local first = fromApps[1]
                    profile.job_stats[first] = (tonumber(profile.job_stats[first]) or 0) + (minNeed - sum)
                end
            end
            local nodes = req.anyNodes or {}
            if #nodes > 0 then
                local set = unlockSetFromList(profile.skill_unlocks)
                if not hasAnyNode(set, nodes) then
                    set[nodes[1]] = true
                    local list = {}
                    for id in pairs(set) do list[#list + 1] = id end
                    table.sort(list)
                    profile.skill_unlocks = list
                end
            end
        end
    end

    Progression.reconcileSkillUnlocks(profile)
    persist(profile, source)
    Progression.syncClient(source, profile)

    local unlocked = Progression.getUnlockedTier(profile)
    return true, {
        requested = tier,
        unlockedTier = unlocked,
        jobStats = profile.job_stats,
        skillUnlocks = profile.skill_unlocks,
    }
end

function Progression.adminSetCrypto(source, coinId, amount)
    coinId = tostring(coinId or 'snc'):lower()
    if coinId ~= 'snc' and coinId ~= 'dnt' and coinId ~= 'xmr' then
        return false, 'Coin must be snc, dnt, or xmr'
    end
    amount = math.floor(tonumber(amount) or -1)
    if amount < 0 then return false, 'Amount must be 0 or greater' end

    local profile = Profile.getBySource(source)
    if not profile then return false, 'Profile not ready' end
    Progression.normalizeProfile(profile)
    Progression.ensureBalance(profile, coinId)
    profile.crypto_balances[coinId] = amount
    persist(profile, source)
    Progression.syncClient(source, profile)
    return true, profile.crypto_balances
end

function Progression.adminAddCrypto(source, coinId, amount)
    coinId = tostring(coinId or 'snc'):lower()
    if coinId ~= 'snc' and coinId ~= 'dnt' and coinId ~= 'xmr' then
        return false, 'Coin must be snc, dnt, or xmr'
    end
    amount = math.floor(tonumber(amount) or 0)
    if amount == 0 then return false, 'Amount cannot be 0' end

    local profile = Profile.getBySource(source)
    if not profile then return false, 'Profile not ready' end
    Progression.normalizeProfile(profile)
    Progression.addCrypto(profile, coinId, amount)
    persist(profile, source)
    Progression.syncClient(source, profile)
    return true, profile.crypto_balances
end

function Progression.adminReset(source)
    local profile = Profile.getBySource(source)
    if not profile then return false, 'Profile not ready' end
    Progression.normalizeProfile(profile)
    profile.job_stats = {}
    profile.skill_unlocks = {}
    profile.crypto_balances = defaultsCrypto()
    profile.skill_grants_claimed = {}
    persist(profile, source)
    Progression.syncClient(source, profile)
    return true, Progression.clientPayload(profile)
end

function Progression.adminStatus(source)
    local profile = Profile.getBySource(source)
    if not profile then return false, 'Profile not ready' end
    Progression.normalizeProfile(profile)
    Progression.reconcileSkillUnlocks(profile)
    local apps, tier = Progression.getUnlockedApps(profile)
    local tierDef = Config.Progression and Config.Progression.Tiers and Config.Progression.Tiers[tier]
    return true, {
        unlockedTier = tier,
        tierLabel = tierDef and tierDef.label or tostring(tier),
        jobStats = profile.job_stats or {},
        skillUnlocks = profile.skill_unlocks or {},
        cryptoBalances = profile.crypto_balances or defaultsCrypto(),
        unlockedApps = apps,
        level = profile.level,
        exp = profile.exp,
    }
end

return Progression
