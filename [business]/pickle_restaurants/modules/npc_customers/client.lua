-- =============================================
--  modules/npc_customers | client.lua
--  Renders the NPC customers the server schedules: spawns a frozen local ped a few
--  metres back from a restaurant's counter, walks it into its queue slot, re-slots it
--  as the line moves, and walks it away (happy or not) when it's served / gives up.
--
--  The server is authoritative — every event carries the counter transform + the
--  configured geometry, so this file owns NO settings and never guesses positions.
--  Adapted from the pickle_clubs bartender queue, trimmed to the
--  spawn/queue/walk-away mechanics. Uses core/client.lua's CreateNPC helper.
-- =============================================

-- OrderNPCs[rid][orderId] = { ped, queueIndex, isWalking, ticket }
local OrderNPCs = {}
local RENDER_DIST = 150.0 -- don't render a restaurant's NPCs from further than this

-- ─── geometry (matches modules/npc_customers/server.lua's intent) ─────────────

local function forwardVec(h)
    local r = math.rad(h)
    return vector3(math.sin(r), -math.cos(r), 0.0)
end
local function rightVec(h)
    local r = math.rad(h)
    return vector3(math.cos(r), math.sin(r), 0.0)
end
local function facing(h) return (h + 180.0) % 360.0 end

local function counterVec(counter)
    return vector3(counter.x + 0.0, counter.y + 0.0, counter.z + 0.0)
end

-- Where the NPC at `index` (0 = front) stands: `counter_offset` in front of the
-- counter, then stepped sideways by `queue_spacing` per place back in line.
local function slotPos(counter, geo, index)
    local c = counterVec(counter)
    local pos = c + (forwardVec(counter.heading or 0.0) * -(geo.counter_offset or 1.0))
    if index and index > 0 then
        pos = pos + (rightVec(counter.heading or 0.0) * ((geo.queue_spacing or 0.85) * index))
    end
    return pos
end

-- Where a new arrival appears before walking up. Prefer the restaurant's admin-placed
-- spawn point (a clear, reachable spot near the register) — it's the same for every
-- customer, and the queue geometry takes over once they reach their slot. Falls back
-- to the computed fallback point (further back along the queue line) when none is placed.
local function spawnPos(counter, geo, index, spawn)
    if spawn and spawn.x then
        return vector3(spawn.x + 0.0, spawn.y + 0.0, spawn.z + 0.0)
    end
    local slot = slotPos(counter, geo, index)
    return slot + (forwardVec(counter.heading or 0.0) * -(geo.spawn_distance or 6.0))
end

local function playerCoords()
    return GetEntityCoords(PlayerPedId())
end

-- ─── ped lifecycle ───────────────────────────────────────────────────────────

local function configurePed(ped)
    SetEntityInvincible(ped, true)
    SetBlockingOfNonTemporaryEvents(ped, true) -- don't flee / react to the world
    SetEntityAsMissionEntity(ped, true, true)  -- so DeleteEntity actually removes it
    SetPedCanRagdoll(ped, false)
end

-- Walk a ped to a world position, then settle it: face the counter and freeze.
local function walkToSlot(rid, orderId, ped, target, headingFace)
    local entry = OrderNPCs[rid] and OrderNPCs[rid][orderId]
    if not entry or not DoesEntityExist(ped) then return end
    FreezeEntityPosition(ped, false)
    entry.isWalking = true
    -- NavMesh (not straight-line) so the ped paths AROUND counters/props instead of
    -- shoving into them and stalling. BUT a freshly-spawned ped is often tasked before
    -- its navmesh tile has loaded — the task then silently no-ops and the ped just
    -- stands until the timeout below teleports it in (the "stands, then pops to the
    -- counter" bug). So we watch for real movement and, if it hasn't budged ~1s after
    -- tasking, fall back to a straight-line walk (the admin-placed spawn point is a
    -- clear spot near the register, so a straight line reaches the slot fine).
    -- Ask the streamer for the navmesh around BOTH ends of the walk first. Without
    -- this the tile is usually still missing on a fresh spawn, the task no-ops, and
    -- the customer stands still until the stall check below re-tasks it — the visible
    -- "spawns, pauses, then starts moving" beat.
    local from = GetEntityCoords(ped)
    AddNavmeshRequiredRegion(from.x, from.y)
    AddNavmeshRequiredRegion(target.x, target.y)
    TaskFollowNavMeshToCoord(ped, target.x, target.y, target.z, 1.0, 20000, 0.35, false, 0.0)
    CreateThread(function()
        local waited = 0
        local startPos = GetEntityCoords(ped)
        local usedFallback = false
        while DoesEntityExist(ped) and OrderNPCs[rid] and OrderNPCs[rid][orderId]
            and OrderNPCs[rid][orderId].isWalking do
            Wait(100)
            waited = waited + 100
            local pos = GetEntityCoords(ped)
            -- Still glued to the spawn a beat after tasking: NavMesh never found a path.
            -- Re-issue as a straight-line walk so the customer actually approaches.
            -- Checked at 300ms (a walking ped clears 0.15m well inside that), so the
            -- fallback is indistinguishable from having walked off immediately.
            if not usedFallback and waited >= 300 and #(pos - startPos) < 0.15 then
                usedFallback = true
                ClearPedTasks(ped)
                TaskGoStraightToCoord(ped, target.x, target.y, target.z, 1.0, 20000, headingFace, 0.35)
            end
            -- Arrival is checked HORIZONTALLY: the slot Z (counter height) can differ from
            -- where the ped actually stands, and a Z gap would otherwise stall the ped at
            -- the counter for the full timeout before snapping in. Settle either way.
            local dx, dy = pos.x - target.x, pos.y - target.y
            if math.sqrt(dx * dx + dy * dy) < 0.6 or waited >= 20000 then
                ClearPedTasks(ped)
                SetEntityCoordsNoOffset(ped, target.x, target.y, target.z, false, false, false)
                SetEntityHeading(ped, headingFace)
                FreezeEntityPosition(ped, true)
                if OrderNPCs[rid] and OrderNPCs[rid][orderId] then
                    OrderNPCs[rid][orderId].isWalking = false
                end
                break
            end
        end
    end)
end

-- Create the ped (optionally walking it in). `atSlot` seats it immediately with no
-- walk-in — used when re-rendering NPCs that were already queued before we arrived.
local function makeNpc(rid, orderId, model, counter, geo, index, ticket, spawn, atSlot)
    OrderNPCs[rid] = OrderNPCs[rid] or {}
    if OrderNPCs[rid][orderId] then return end -- already have this one
    if #(playerCoords() - counterVec(counter)) > RENDER_DIST then return end -- too far to bother

    local h = facing(counter.heading or 0.0)
    local start = atSlot and slotPos(counter, geo, index) or spawnPos(counter, geo, index, spawn)
    local ped = CreateNPC(GetHashKey(model), start.x, start.y, start.z, h, false, true)
    if not ped or ped == 0 or not DoesEntityExist(ped) then return end
    configurePed(ped)

    OrderNPCs[rid][orderId] = { ped = ped, queueIndex = index, isWalking = false, ticket = ticket, counter = counter }

    if atSlot then
        SetEntityHeading(ped, h)
        FreezeEntityPosition(ped, true)
    else
        walkToSlot(rid, orderId, ped, slotPos(counter, geo, index), h)
    end
end

-- Walk a ped clear of the queue, then delete it. `happy` drives the parting facial
-- expression: a served customer leaves smiling, an impatient one leaves scowling.
local function walkAwayAndDelete(ped, counter, happy)
    if not DoesEntityExist(ped) then return end
    -- a mood facial override reads on any human ped; cleared automatically when the
    -- ped is deleted below (the ped is transient — spawned per order, walked off, gone)
    SetFacialIdleAnimOverride(ped, happy and "mood_happy_1" or "mood_angry_1", 0)
    FreezeEntityPosition(ped, false)
    ClearPedTasks(ped)
    local away = GetEntityCoords(ped) + (rightVec(counter and counter.heading or 0.0) * 2.5)
    TaskGoStraightToCoord(ped, away.x, away.y, away.z, 1.0, 3000, 0.0, 0.0)
    SetTimeout(2600, function()
        if DoesEntityExist(ped) then
            SetEntityAsMissionEntity(ped, true, true)
            DeleteEntity(ped)
        end
    end)
end

local function deleteNpcNow(ped)
    if not DoesEntityExist(ped) then return end
    SetEntityAsMissionEntity(ped, true, true)
    DeleteEntity(ped)
end

local function clearRestaurant(rid, walkOff, counter)
    local peds = OrderNPCs[rid]
    if not peds then return end
    OrderNPCs[rid] = nil
    for _, entry in pairs(peds) do
        if walkOff then walkAwayAndDelete(entry.ped, counter, false)
        else deleteNpcNow(entry.ped) end
    end
end

-- ─── server events ───────────────────────────────────────────────────────────

RegisterNetEvent("pickle_restaurants:npc:spawn", function(d)
    if not d or not d.counter then return end
    makeNpc(d.rid, d.orderId, d.model, d.counter, d.geo or {}, d.queueIndex or 0, d.ticket, d.spawn, false)
end)

-- Re-slot NPCs after the line moved (someone joined / left).
RegisterNetEvent("pickle_restaurants:npc:queue", function(d)
    if not d or not d.counter or not d.queue then return end
    local peds = OrderNPCs[d.rid]
    if not peds then return end
    local h = facing(d.counter.heading or 0.0)
    for orderId, entry in pairs(peds) do
        local idx = d.queue[tostring(orderId)]
        if idx ~= nil and DoesEntityExist(entry.ped) and entry.queueIndex ~= idx then
            entry.queueIndex = idx
            walkToSlot(d.rid, orderId, entry.ped, slotPos(d.counter, d.geo or {}, idx), h)
        end
    end
end)

RegisterNetEvent("pickle_restaurants:npc:despawn", function(rid, orderId, happy)
    local peds = OrderNPCs[rid]
    if not peds or not peds[orderId] then return end
    local entry = peds[orderId]
    peds[orderId] = nil
    -- entry.counter gives the step-aside direction (the ped clears the queue sideways).
    walkAwayAndDelete(entry.ped, entry.counter, happy == true)
end)

-- Full-queue snapshot for a client that just booted / walked up.
RegisterNetEvent("pickle_restaurants:npc:state", function(list)
    for _, s in ipairs(list or {}) do
        if s.counter and #(playerCoords() - counterVec(s.counter)) <= RENDER_DIST then
            for _, e in ipairs(s.entries or {}) do
                makeNpc(s.rid, e.orderId, e.model, s.counter, s.geo or {}, e.queueIndex or 0, e.ticket, s.spawn, true)
            end
        end
    end
end)

local function requestState() TriggerServerEvent("pickle_restaurants:npc:requestState") end

-- Re-request whenever the world re-syncs (a counter may have moved / a restaurant
-- appeared). This is a SECOND handler for the sync event — main/client owns the props.
RegisterNetEvent("pickle_restaurants:sync", function() SetTimeout(500, requestState) end)

-- ─── distance cull + approach spawn ──────────────────────────────────────────
-- Free peds for restaurants we've walked away from (they return via npc:state), and
-- re-ask for state while near any counter so approaching a restaurant surfaces its
-- queue even if it filled before we got close.

CreateThread(function()
    local sinceRequest = 0
    while true do
        Wait(4000)
        local pc = playerCoords()
        local nearAny = false
        for id, r in pairs(Restaurants or {}) do
            if r.counter then
                local far = #(pc - counterVec(r.counter)) > RENDER_DIST
                if far and OrderNPCs[id] then
                    clearRestaurant(id, false, nil) -- silent delete; state re-adds on return
                elseif not far then
                    nearAny = true
                end
            end
        end
        sinceRequest = sinceRequest + 4000
        if nearAny and sinceRequest >= 8000 then
            sinceRequest = 0
            requestState()
        end
    end
end)

-- ─── boot / cleanup ──────────────────────────────────────────────────────────

CreateThread(function()
    Wait(2000) -- after main/client has requested the world sync
    requestState()
end)

AddEventHandler("onResourceStop", function(res)
    if res ~= GetCurrentResourceName() then return end
    for rid in pairs(OrderNPCs) do clearRestaurant(rid, false, nil) end
end)
