--[[
  Per-player mission offer queue for jobs that generate one contract at a time.
  Offers are rolled from the job config vehicle pool and carry a cooldown between rolls.
]]

local MissionQueue = {}

---@type table<string, table<string, { offer: table|nil, cooldownUntil: number }>>
local state = {}

local function now()
    return os.time()
end

-- Keyed by the player's stable identifier (citizenid/license), not `source` —
-- source is a per-connection id that changes on relog, which previously let
-- players wipe their mission cooldown just by reconnecting.
local function playerKey(source)
    return server.getPlayerIdentifier(source) or tonumber(source)
end

local function playerBucket(source, jobKey)
    local key = playerKey(source)
    if not key or not jobKey then return nil end
    state[key] = state[key] or {}
    state[key][jobKey] = state[key][jobKey] or { offer = nil, cooldownUntil = 0 }
    return state[key][jobKey]
end

local function randomPlate()
    local chars = 'ABCDEFGHJKLMNPRSTUVWXYZ0123456789'
    local out = {}
    for i = 1, 6 do
        local idx = math.random(#chars)
        out[i] = chars:sub(idx, idx)
    end
    return table.concat(out)
end

local function pickFrom(list)
    if not list or #list == 0 then return nil end
    return list[math.random(#list)]
end

---Build a fresh offer from job config.game.queue / vehicle_models
---@param jobKey string
---@param jobConfig table
---@return table|nil
function MissionQueue.rollOffer(jobKey, jobConfig)
    local game = jobConfig and jobConfig.game or {}
    local queue = game.queue or {}
    local pool = queue.vehicle_pool or game.vehicle_models or { 'blista' }
    local model = pickFrom(pool)
    if not model then return nil end

    local payoutMin = queue.payout_min or (jobConfig.reward and jobConfig.reward.money) or 4000
    local payoutMax = queue.payout_max or payoutMin
    if payoutMax < payoutMin then payoutMax = payoutMin end
    local payout = math.random(payoutMin, payoutMax)

    local classes = queue.classes or { 'D', 'C', 'B', 'A' }
    local class = pickFrom(classes) or 'C'
    local areas = queue.area_labels or { 'Los Santos', 'South LS', 'Vinewood', 'Del Perro' }

    return {
        id = ('%s-%s-%s'):format(jobKey, model, tostring(math.random(1000, 9999))),
        jobKey = jobKey,
        vehicleModel = model,
        vehicle = model:gsub('^%l', string.upper),
        spawn = model,
        plate = randomPlate(),
        class = class,
        area = pickFrom(areas) or 'Los Santos',
        zone = pickFrom(areas) or 'Los Santos',
        type = model:gsub('^%l', string.upper),
        qty = ('Class %s'):format(class),
        payout = payout,
        heat = (class == 'A' or class == 'S') and 'high' or (class == 'B' and 'mid' or 'low'),
        timeLeft = queue.offer_ttl_minutes or 15,
        tracker = math.random() < (queue.tracker_chance or 0.35),
        createdAt = now(),
        expiresAt = now() + ((queue.offer_ttl_seconds or 900)),
    }
end

---@param source number
---@param jobKey string
---@param jobConfig table
---@return table { ok, offer?, cooldownLeft?, error? }
function MissionQueue.getOrCreateOffer(source, jobKey, jobConfig)
    local bucket = playerBucket(source, jobKey)
    if not bucket then return { ok = false, error = 'invalid' } end

    local t = now()
    if bucket.offer and bucket.offer.expiresAt and bucket.offer.expiresAt > t then
        return { ok = true, offer = bucket.offer, cooldownLeft = 0 }
    end

    if bucket.cooldownUntil > t then
        return {
            ok = false,
            cooldownLeft = bucket.cooldownUntil - t,
            error = 'cooldown',
            offer = nil,
        }
    end

    local offer = MissionQueue.rollOffer(jobKey, jobConfig)
    if not offer then return { ok = false, error = 'no_pool' } end
    bucket.offer = offer
    return { ok = true, offer = offer, cooldownLeft = 0 }
end

---Force a new offer (skip / refresh). Blocked while mission cooldown is active.
---@param source number
---@param jobKey string
---@param jobConfig table
---@return table
function MissionQueue.requestNext(source, jobKey, jobConfig)
    local bucket = playerBucket(source, jobKey)
    if not bucket then return { ok = false, error = 'invalid' } end

    local t = now()
    if bucket.cooldownUntil > t then
        return {
            ok = false,
            cooldownLeft = bucket.cooldownUntil - t,
            error = 'cooldown',
        }
    end

    local offer = MissionQueue.rollOffer(jobKey, jobConfig)
    if not offer then return { ok = false, error = 'no_pool' } end
    bucket.offer = offer
    return { ok = true, offer = offer, cooldownLeft = 0 }
end

---@param source number
---@param jobKey string
---@param offerId string|nil
---@return table|nil consumed offer
function MissionQueue.consumeOffer(source, jobKey, offerId)
    local bucket = playerBucket(source, jobKey)
    if not bucket or not bucket.offer then return nil end
    if offerId and bucket.offer.id ~= offerId then return nil end
    local offer = bucket.offer
    bucket.offer = nil
    return offer
end

---@param source number
---@param jobKey string
---@param jobConfig table
---@param seconds number|nil
function MissionQueue.applyMissionCooldown(source, jobKey, jobConfig, seconds)
    local bucket = playerBucket(source, jobKey)
    if not bucket then return end
    local queue = (jobConfig and jobConfig.game and jobConfig.game.queue) or {}
    local cd = seconds or queue.mission_cooldown_seconds or 180
    bucket.cooldownUntil = now() + cd
    bucket.offer = nil
end

---@param source number
---@param jobKey string
---@return number seconds left
function MissionQueue.getCooldownLeft(source, jobKey)
    local bucket = playerBucket(source, jobKey)
    if not bucket then return 0 end
    local left = bucket.cooldownUntil - now()
    return left > 0 and left or 0
end

return MissionQueue
