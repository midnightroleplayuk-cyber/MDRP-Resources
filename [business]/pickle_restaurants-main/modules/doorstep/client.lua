-- =============================================
--  modules/doorstep | client.lua
--  THE DOORSTEP HAND-OFF. An NPC delivery whose drop point is an admin-placed
--  delivery door doesn't complete with a button press at a coordinate: the driver
--  knocks, a resident answers the door, and the two are squared up on the step for
--  the hand-over of a real branded Restaurant Bag.
--
--  Run by the driver's client only, from the phone's "delivered" action — the
--  sequence happens BEFORE `sales:completeOrder`, and a cancelled/failed sequence
--  means the order is not completed. The server grants nothing here (see
--  doorstep/server.lua): it only says whether this order has a door and where.
--
--  THE SCENE IS NETWORKED. The resident and the bag used to be client-LOCAL, on the
--  reasoning that only the driver is party to the hand-off — but that made a delivery
--  look, to everyone else in the street, like a man miming at a door. They are real
--  networked entities now, so the resident answering and the branded bag changing hands
--  are part of the scene everybody sees.
--
--  What the local version was avoiding is real, though: a networked entity outlives the
--  client that spawned it, so a driver who crashes mid-scene would strand a ped on a
--  stranger's doorstep. Both ids are therefore reported to doorstep/server.lua the moment
--  they exist, and it deletes them if this client stops speaking for itself (drop, or a
--  deadline). Normal endings still clean up here, first.
-- =============================================

-- TUNE IN-GAME. Every dict/clip below is a shipped GTA one.
local DOOR = {
    -- how close the driver must already be to the door for the scene to start
    reach       = 6.0,
    -- knocking
    knock_dict  = "timetable@jimmy@doorknock@",
    knock_clip  = "knockdoor_idle",
    knock_ms    = 2200,
    -- Where the driver stands for the exchange: this far out from the door along its
    -- facing. They are PUT there (not walked) the moment the resident appears, so the
    -- two are always squared up at hand-shaking distance whatever angle the driver
    -- knocked from — pathing a ped onto a doorstep is what made this land at arm's
    -- length one time and inside a hedge the next.
    step_back   = 1.2,
    open_delay  = 250,   -- pause between the knock and the door opening
    -- beat after the phone is put away, before the knock — the put-away is an
    -- animation of its own and the knock has to start on an empty hand
    phone_ms    = 700,
    -- how far ABOVE the door anchor the "hand it over" target zone sits. The anchor is
    -- the doorway FLOOR, so a zone centred on it hides under the step, below where a
    -- player aims. Same reasoning as main's SEAT_TARGET_Z.
    target_z    = 1.0,
    settle_ms   = 400,   -- beat after both are in position, before the exchange
    leave_ms    = 1800,  -- how long the resident walks back inside before despawning
    -- the exchange. `mp_common` givetake1_a / _b is the two-sided hand-over pair
    -- every trade-an-item script uses: _a gives, _b receives.
    give_dict   = "mp_common",
    give_clip   = "givetake1_a",
    take_clip   = "givetake1_b",
    give_ms     = 2400,
    hand_over   = 0.55,  -- fraction through the exchange the bag changes hands
    -- The bag being handed over: OUR Restaurant Bag prop (BagModel), wearing the
    -- brand of the restaurant the delivery came FROM — pinned for the scene, since
    -- packaging otherwise wears whichever branded restaurant the player is nearest.
    bag_bone    = 57005, -- SKEL_R_Hand
    bag_off     = vector3(0.13, 0.03, -0.02),
    bag_rot     = vector3(-100.0, 0.0, 0.0),
    -- resident models, picked at random per delivery
    peds        = { "a_m_y_business_01", "a_f_y_business_02", "a_m_m_eastsa_01",
                    "a_f_m_soucent_01", "a_m_y_hipster_01", "a_f_y_hipster_02" },
}

local running = false
-- The scene's two NETWORKED entities, mirrored at module scope purely so
-- `onResourceStop` can delete them: a restart mid-scene is the one ending that reaches
-- neither cleanup path, and a networked entity nobody deletes stays on every screen.
local residentEnt, bagEnt = nil, nil

local function loadDict(dict)
    if HasAnimDictLoaded(dict) then return true end
    RequestAnimDict(dict)
    local t = GetGameTimer()
    while not HasAnimDictLoaded(dict) and GetGameTimer() - t < 3000 do Wait(0) end
    return HasAnimDictLoaded(dict)
end

local function loadModel(name)
    local hash = GetHashKey(name)
    RequestModel(hash)
    local t = GetGameTimer()
    while not HasModelLoaded(hash) and GetGameTimer() - t < 5000 do Wait(0) end
    return HasModelLoaded(hash) and hash or nil
end

-- Forward vector of a heading, flat. The door's heading points OUT of the doorway,
-- so +fwd is the street side and -fwd is indoors.
local function fwdOf(heading)
    local rad = math.rad(heading or 0.0)
    return -math.sin(rad), math.cos(rad)
end

local function playFor(ped, dict, clip, ms, flag)
    if not loadDict(dict) then return false end
    TaskPlayAnim(ped, dict, clip, 8.0, -8.0, ms or -1, flag or 0, 0.0, false, false, false)
    return true
end

-- Clean up a resident whatever happened — a delivery that fails mid-scene must not
-- leave a stranger standing in the street forever.
local function despawn(ped)
    if ped and DoesEntityExist(ped) then
        SetEntityAsMissionEntity(ped, true, true)
        DeleteEntity(ped)
    end
end

-- Hand the server the NET IDS of what this scene spawned, so it can delete them if we
-- stop being able to (see the header). Net id, not entity handle: a handle means nothing
-- on the other side. Silently skips anything that failed to spawn or isn't networked yet.
local function reportSceneEntities(...)
    local ids = {}
    for _, ent in ipairs({ ... }) do
        if ent and DoesEntityExist(ent) then
            local net = NetworkGetNetworkIdFromEntity(ent)
            if net and net ~= 0 then
                -- the scene is short and ours; keeping control of the entity is what
                -- makes the local cleanup below authoritative in the normal case
                SetNetworkIdCanMigrate(net, false)
                ids[#ids + 1] = net
            end
        end
    end
    if #ids > 0 then TriggerServerEvent("pickle_restaurants:doorstep:sceneEntities", ids) end
end

-- The bag being handed over: our own Restaurant Bag prop, wearing `rid`'s brand.
-- The pin is what makes it the DELIVERING restaurant's bag rather than whichever
-- branded restaurant the customer's house happens to sit next to, and it has to be
-- in place BEFORE the prop spawns so the replacement is bound to a live model.
local function spawnBag(rid, ped)
    local model = BagModel or "pickle_restaurant_bag_01"
    if rid and PinBrandRestaurant then PinBrandRestaurant(rid) end
    local hash = loadModel(model)
    if not hash then return nil end
    -- networked (2nd arg) so the bag is in the driver's hand on every screen, not just
    -- theirs; the server holds its net id as a dead-man's switch (see the header).
    local bag = CreateObject(hash, GetEntityCoords(ped), true, true, false)
    SetModelAsNoLongerNeeded(hash)
    if not (bag and DoesEntityExist(bag)) then return nil end
    if ReassertBrandFor then ReassertBrandFor(model) end -- the prop exists now: re-bind
    AttachEntityToEntity(bag, ped, GetPedBoneIndex(ped, DOOR.bag_bone),
                         DOOR.bag_off.x, DOOR.bag_off.y, DOOR.bag_off.z,
                         DOOR.bag_rot.x, DOOR.bag_rot.y, DOOR.bag_rot.z,
                         true, true, false, true, 1, true)
    return bag
end

-- Play the scene at `door` ({ x, y, z, heading }); `rid` is the restaurant the food
-- came from (brands the bag). Split out of the order path so the same sequence can
-- run with no order and no item behind it. Returns true when the resident took the
-- bag, false otherwise.
local function runDoorstepScene(door, rid)
    if running then return false end
    local ped = PlayerPedId()
    local at  = vector3(door.x, door.y, door.z)
    if #(GetEntityCoords(ped) - at) > DOOR.reach then
        ShowNotification(_L("door_too_far"))
        return false
    end

    running = true

    -- Put the phone away first. Served from the app, the phone is open and IN THE HAND
    -- as the knock starts, and its hold/put-away animation fights every clip below —
    -- so this runs whichever way the hand-off was triggered (the app's "Delivered"
    -- button or the door's own target option). No phone installed, or one with no close
    -- path, no-ops. `running` is already set, so the wait can't be re-entered.
    if PhoneApp and PhoneApp.Close then
        PhoneApp.Close()
        Wait(DOOR.phone_ms)
        ped = PlayerPedId()
    end

    local resident, bag
    local ok = pcall(function()
        local fx, fy = fwdOf(door.heading)
        local outward = door.heading or 0.0

        -- 1. knock. Face the door first so the clip reads as knocking ON it.
        TaskTurnPedToFaceCoord(ped, at.x, at.y, at.z, 800)
        Wait(800)
        playFor(ped, DOOR.knock_dict, DOOR.knock_clip, DOOR.knock_ms)
        Wait(DOOR.knock_ms)
        ClearPedTasks(ped)

        -- 2. the door opens and the resident is THERE, standing in the doorway on the
        --    placed point facing out. They don't walk out to it: the anchor is the
        --    doorway itself, so anywhere they could walk FROM is inside the house —
        --    through a wall the admin never placed a path around.
        Wait(DOOR.open_delay)
        local model = DOOR.peds[math.random(#DOOR.peds)]
        local hash  = loadModel(model)
        if not hash then error("model", 0) end
        -- networked + script-host, for the same reason as the bag: a resident only the
        -- driver can see is the whole bug this fixes.
        resident = CreatePed(4, hash, at.x, at.y, at.z, outward, true, true)
        residentEnt = resident
        SetModelAsNoLongerNeeded(hash)
        if not (resident and DoesEntityExist(resident)) then error("ped", 0) end
        SetEntityInvincible(resident, true)
        SetBlockingOfNonTemporaryEvents(resident, true) -- don't flee/react to traffic
        SetPedCanRagdoll(resident, false)
        FreezeEntityPosition(resident, true)            -- they stand their ground

        -- 3. put the driver on the mark: squarely in front of the resident, facing
        --    them, at hand-shaking distance. The exchange clips are a matched pair
        --    authored for two peds standing exactly like this, so the positions are
        --    set rather than walked to.
        SetEntityCoords(ped, at.x + fx * DOOR.step_back, at.y + fy * DOOR.step_back,
                        at.z, false, false, false, false)
        SetEntityHeading(ped, outward + 180.0)
        bag = spawnBag(rid, ped)
        bagEnt = bag
        -- Hand the server the dead-man's switch NOW, while both exist: if this client
        -- never gets to the cleanup below, that is what removes them for everyone else.
        reportSceneEntities(resident, bag)
        Wait(DOOR.settle_ms)

        -- 4. the exchange: two halves of one clip, started on the same frame so the
        --    hands actually meet, with the bag changing hands part-way through.
        loadDict(DOOR.give_dict)
        playFor(ped, DOOR.give_dict, DOOR.give_clip, DOOR.give_ms)
        playFor(resident, DOOR.give_dict, DOOR.take_clip, DOOR.give_ms)
        local swap = math.floor(DOOR.give_ms * DOOR.hand_over)
        Wait(swap)
        if bag and DoesEntityExist(bag) then
            AttachEntityToEntity(bag, resident, GetPedBoneIndex(resident, DOOR.bag_bone),
                                 DOOR.bag_off.x, DOOR.bag_off.y, DOOR.bag_off.z,
                                 DOOR.bag_rot.x, DOOR.bag_rot.y, DOOR.bag_rot.z,
                                 true, true, false, true, 1, true)
        end
        Wait(DOOR.give_ms - swap)
        ClearPedTasks(ped)
    end)

    -- 5. they take it inside regardless of how the scene ended — bag and all, so a
    --    failed hand-off doesn't leave one hanging off a stranger's wrist in the
    --    street. The pin goes with them: packaging is back on the nearest-restaurant
    --    rule the moment the scene is over.
    if resident and DoesEntityExist(resident) then
        local fx, fy = fwdOf(door.heading)
        FreezeEntityPosition(resident, false)
        TaskGoStraightToCoord(resident, at.x - fx * 1.5, at.y - fy * 1.5, at.z, 1.0, DOOR.leave_ms,
                              (door.heading or 0.0) + 180.0, 0.1)
        local body, carried = resident, bag
        CreateThread(function()
            Wait(DOOR.leave_ms)
            if carried and DoesEntityExist(carried) then
                DetachEntity(carried, false, false)
                DeleteEntity(carried)
            end
            despawn(body)
            residentEnt, bagEnt = nil, nil
            -- both gone: release the server's hold rather than leaving it to a deadline
            TriggerServerEvent("pickle_restaurants:doorstep:sceneDone")
        end)
    elseif bag and DoesEntityExist(bag) then
        DetachEntity(bag, false, false)
        DeleteEntity(bag)
        residentEnt, bagEnt = nil, nil
        TriggerServerEvent("pickle_restaurants:doorstep:sceneDone")
    end
    if UnpinBrandRestaurant then UnpinBrandRestaurant() end
    running = false
    if not ok then
        ClearPedTasks(PlayerPedId())
        ShowNotification(_L("door_handoff_failed"))
        return false
    end
    return true
end

-- Run the doorstep scene for an order.
--   nil   — this order has no door (a plain coordinate drop): complete normally
--   false — there IS a door but the scene didn't happen (too far, aborted): DON'T
--           complete; the caller shows why
--   true  — the resident took the bag: complete the order
function RunDoorstepHandoff(rid, orderId)
    if running then return false end
    local door = lib.callback.await("pickle_restaurants:doorstep:point", false,
                                    { rid = rid, orderId = orderId })
    if not (door and door.x) then return nil end -- not a doorstep delivery
    return runDoorstepScene(door, rid)
end

-- ─── the door's own target option ─────────────────────────────────────────────
-- Serving a delivery otherwise means opening the phone, finding the ticket and tapping
-- "Delivered" — with the phone on screen and in the ped's hand right as the hand-off
-- animation starts. So the door carries the action itself: while a run to a placed door
-- is in progress, THAT door has a "Hand the order over" option on it, and taking it
-- runs the same scene + completion the app's button does (`ServeDelivery`, modules/phone).
--
-- It is armed per RUN, never per placed prop. A delivery door is an invisible anchor at
-- a customer's house: a permanent option on every one of them would offer the whole
-- server a hand-off they hold no order for (which the server refuses anyway) and put a
-- target prompt on strangers' doorsteps. modules/phone arms this when a run is accepted
-- and disarms it when the run ends, however it ends.
local doorTarget, doorRun = nil, nil

function DisarmDoorstepTarget()
    if doorTarget then DeleteInteraction(doorTarget) end
    doorTarget, doorRun = nil, nil
end

-- Returns the door point (nil if this run's drop is a plain coordinate and there is
-- nothing to arm) so the caller can reuse it — modules/phone wants its z for the
-- on-screen destination marker rather than asking the server for it twice.
function ArmDoorstepTarget(rid, orderId)
    DisarmDoorstepTarget()
    rid, orderId = tonumber(rid), tonumber(orderId)
    if not (rid and orderId) then return nil end
    local door = lib.callback.await("pickle_restaurants:doorstep:point", false,
                                    { rid = rid, orderId = orderId })
    if not (door and door.x) then return nil end

    doorRun = { rid = rid, orderId = orderId }
    doorTarget = CreateInteraction({
        coords         = vector3(door.x, door.y, door.z + DOOR.target_z),
        label          = _L("door_hand_over"),
        icon           = "fa-solid fa-bag-shopping",
        radius         = 1.2,
        interactRadius = 2.5,
        distance       = 2.5,
    }, function()
        local run = doorRun
        if not run or running then return end
        -- No vessel PIN: the app's button passes the ticket's first packed meal/bag,
        -- but the door has no ticket on screen to read one off. The pin is only ever a
        -- hint — the server's planner claims the vessels the order needs by itself.
        if ServeDelivery then ServeDelivery({ id = run.rid, orderId = run.orderId }) end
    end)
    return door
end

-- A resource stop mid-scene must not strand the player in an animation.
AddEventHandler("onResourceStop", function(res)
    if res ~= GetCurrentResourceName() then return end
    if running then ClearPedTasks(PlayerPedId()) end
    -- A restart mid-scene is the one ending that reaches neither cleanup path above, and
    -- the entities are NETWORKED now — so everyone else would keep the resident and the
    -- bag. Delete what we still hold; the server's deadline covers whatever we don't.
    if bagEnt and DoesEntityExist(bagEnt) then
        DetachEntity(bagEnt, false, false)
        DeleteEntity(bagEnt)
    end
    if residentEnt and DoesEntityExist(residentEnt) then despawn(residentEnt) end
end)
