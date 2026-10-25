-- ---------------------------------------------------------------------------
-- Connect queue
-- ---------------------------------------------------------------------------
-- When the server is full, players who passed the access check wait here instead of being refused.
-- Order: reconnecting within Config.Queue.RejoinMinutes of leaving, then priority points (Discord roles set on the
-- panel), then whoever has waited longest.

local queue = {}   -- { src, license, priority, joinedAt, deferrals }
local loading = {} -- license -> time let in; holds the slot until they finish loading (playerJoining)
local leftAt = {}  -- license -> time they last left, for the rejoin grace
local LOADING_HOLD = 180 -- seconds a slot is held for someone still loading in

local function enabled() return Config.Queue and Config.Queue.Enabled end

local function hasGrace(license, now)
    local t = leftAt[license]
    return t ~= nil and now - t <= (Config.Queue.RejoinMinutes or 15) * 60
end

-- Rejoin grace first, then most points, then longest wait.
local function before(a, b, now)
    local ga, gb = hasGrace(a.license, now), hasGrace(b.license, now)
    if ga ~= gb then return ga end
    if a.priority ~= b.priority then return a.priority > b.priority end
    return a.joinedAt < b.joinedAt
end

local function freeSlots(now)
    local holding = 0
    for license, t in pairs(loading) do
        if now - t > LOADING_HOLD then loading[license] = nil else holding = holding + 1 end
    end
    return GetConvarInt('sv_maxclients', 48) - #GetPlayers() - holding
end

local function step()
    local now = os.time()
    -- Players who closed FiveM while waiting have no name any more.
    for i = #queue, 1, -1 do
        if not GetPlayerName(queue[i].src) then table.remove(queue, i) end
    end
    table.sort(queue, function(a, b) return before(a, b, now) end)

    local free = freeSlots(now)
    while free > 0 and #queue > 0 do
        local e = table.remove(queue, 1)
        loading[e.license] = now
        leftAt[e.license] = nil -- the rejoin grace is used up
        e.deferrals.done()
        free = free - 1
    end

    for i, e in ipairs(queue) do
        local why = hasGrace(e.license, now) and 'Reconnect priority: you are at the front.'
            or (e.priority > 0 and ('Priority: %d points.'):format(e.priority))
            or 'Subscribers skip ahead of the queue.'
        local waited = math.floor((now - e.joinedAt) / 60)
        e.deferrals.update(('Server full. You are %d of %d in the queue (waiting %d min). %s'):format(i, #queue, waited, why))
    end
end

-- Called from playerConnecting once the access check has passed.
function HelmQueueJoin(src, license, priority, deferrals)
    if not enabled() or not license then return deferrals.done() end
    for _, e in ipairs(queue) do
        if e.license == license then
            -- Reconnected from the queue screen: keep their place.
            e.src, e.deferrals, e.priority = src, deferrals, priority or 0
            return step()
        end
    end
    queue[#queue + 1] = { src = src, license = license, priority = priority or 0, joinedAt = os.time(), deferrals = deferrals }
    step()
end

function HelmQueueSize() return #queue end

AddEventHandler('playerJoining', function()
    local license = HelmLicense(source)
    if license then loading[license] = nil end
end)

AddEventHandler('playerDropped', function()
    local license = HelmLicense(source)
    if not license then return end
    loading[license] = nil
    leftAt[license] = os.time()
end)

CreateThread(function()
    while true do
        Wait(1000)
        if enabled() then
            step()
            -- Forget old leavers so the table doesn't grow forever.
            local now = os.time()
            for license in pairs(leftAt) do
                if not hasGrace(license, now) then leftAt[license] = nil end
            end
        end
    end
end)
