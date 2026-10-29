-- =============================================
--  modules/stovetop | client.lua
--  Stovetop-station features (more coming). Today: the two oven doors every
--  stovetop carries — pickle_stovetop_door_01 props (left = #1, right = #2)
--  positioned from the stove's own transform, so they follow however the
--  station was placed. Doors open/close on click from the cooking UI; their
--  state is server-authoritative and synced to every client.
-- =============================================

-- Door framing, all in the stove's LOCAL space (x = right, y = front, z = up).
-- `offset` places the LEFT door (#1); `offset2` places the RIGHT door (#2) —
-- each tuned independently.
-- closedRot/openRot are pitch,roll,yaw deltas added on top of the stove's
-- rotation — tune openRot for how far / which way the door swings.
local DOOR = {
    model     = "pickle_stovetop_door_01",
    offset    = vector3(-0.305, -0.38, 0.395),
    offset2    = vector3(0.31, -0.38, 0.395),
    closedRot = vector3(0.0, 0.0, 0.0),
    openRot   = vector3(80.0, 0.0, 0.0),
    tween_ms  = 320,
}

-- Baking slots inside each door's cavity, LOCAL to the stove (behind the door front
-- face at y = -0.38, so deeper/less-negative y; a hair lower than the door hinge).
-- TUNE IN-GAME. Cookie/cake carry their own tray, pizza sits bare — all seated here.
local OVEN = {
    slots = {
        [1] = { 
            vector3(-0.305, -0.16, 0.44),
            vector3(-0.305, -0.16, 0.64),
        },
        [2] = { 
            vector3(0.31, -0.16, 0.44),
            vector3(0.31, -0.16, 0.64),
        },
    },
    z_seat = 0.0, -- extra lift so trayed food rests on the cavity floor
}

local OvenDoors = {} -- [propId] = { stove = entity, doors = { [door] = { entity, open, token } } }
local hovered   = { propId = nil, door = nil } -- door the cursor is currently over

local function SafeDeleteEntity(ent)
    if not ent or not DoesEntityExist(ent) then return end
    SetEntityAsMissionEntity(ent, true, true)
    DeleteEntity(ent)
end

local function lerp(a, b, t) return a + (b - a) * t end

-- Each door has its own independently-tuned offset.
local function doorOffset(door)
    return (door == 2) and DOOR.offset2 or DOOR.offset
end

-- Place + orient a door at open fraction t (0 = closed, 1 = open).
local function applyDoorTransform(stove, ent, door, t)
    if not DoesEntityExist(stove) or not DoesEntityExist(ent) then return end
    local o = doorOffset(door)
    local pos = GetOffsetFromEntityInWorldCoords(stove, o.x, o.y, o.z)
    SetEntityCoordsNoOffset(ent, pos.x, pos.y, pos.z, false, false, false)
    local sr = GetEntityRotation(stove, 2)
    local c, op = DOOR.closedRot, DOOR.openRot
    SetEntityRotation(ent,
        sr.x + lerp(c.x, op.x, t),
        sr.y + lerp(c.y, op.y, t),
        sr.z + lerp(c.z, op.z, t), 2, true)
end

-- ─── oven baking slots (used by the cooking module) ─────────────────────────

-- How many baking slots each door cavity holds.
function OvenSlotCount() return #OVEN.slots[1] end

-- World position of an oven slot, or nil if the stove/slot isn't known.
function OvenSlotWorld(propId, door, slot)
    local rec = OvenDoors[propId]
    local o = rec and door and slot and OVEN.slots[door] and OVEN.slots[door][slot]
    if not rec or not o or not DoesEntityExist(rec.stove) then return nil end
    return GetOffsetFromEntityInWorldCoords(rec.stove, o.x, o.y, o.z + OVEN.z_seat)
end

-- Seat a food entity in an oven slot, aligned to the stove's heading.
function SeatOvenSlot(propId, door, slot, ent)
    local rec = OvenDoors[propId]
    local o = rec and OVEN.slots[door] and OVEN.slots[door][slot]
    if not rec or not o or not DoesEntityExist(rec.stove) or not (ent and DoesEntityExist(ent)) then return end
    local pos = GetOffsetFromEntityInWorldCoords(rec.stove, o.x, o.y, o.z + OVEN.z_seat)
    SetEntityCoordsNoOffset(ent, pos.x, pos.y, pos.z, false, false, false)
    local sr = GetEntityRotation(rec.stove, 2)
    SetEntityRotation(ent, sr.x, sr.y, sr.z, 2, true)
end

-- Seat an ordered stack of food entities (bottom-to-top) in an oven slot: each part
-- lifted by the summed height of the parts below it, all aligned to the stove heading.
-- Renders an uncooked assembled bake (e.g. a topped pizza) as its full build stack
-- rather than just the base prop.
-- `offsets` (optional, parallel to ents) spreads layers horizontally in the tray
-- plane instead of stacking them — a batch bake (the six-cookie tray) lays its
-- servings out as a grid ON the tray. Each {dx, dy} is tray-local metres, rotated to
-- the stove's heading so the grid faces the oven like everything else.
function SeatOvenSlotStack(propId, door, slot, ents, heights, baseDz, rolls, offsets)
    local rec = OvenDoors[propId]
    local o = rec and OVEN.slots[door] and OVEN.slots[door][slot]
    if not rec or not o or not DoesEntityExist(rec.stove) then return end
    -- Slot anchor in the world; the stack rises straight UP from here (world Z), NOT
    -- along the stove's local axes. A stove resting with any pitch/roll would otherwise
    -- tip the tower sideways and push its top layer (e.g. the pizza cheese) into the
    -- cavity wall, so it appears to vanish on release. Layers keep only the stove's
    -- heading so they stay flat but still face the oven — matching the drag preview.
    -- `baseDz` (optional) lifts the whole tower: a container base layer's mesh-bottom
    -- correction, so a cake tin rests ON the rack instead of sinking through it.
    local base = GetOffsetFromEntityInWorldCoords(rec.stove, o.x, o.y, o.z + OVEN.z_seat)
    local sr = GetEntityRotation(rec.stove, 2)
    local hr = math.rad(sr.z)
    local lift = baseDz or 0.0
    for i, ent in ipairs(ents or {}) do
        if ent and DoesEntityExist(ent) then
            local wx, wy = base.x, base.y
            local ofs = offsets and offsets[i]
            if ofs then -- spread this layer across the tray plane (rotated to heading)
                wx = wx + ofs.dx * math.cos(hr) - ofs.dy * math.sin(hr)
                wy = wy + ofs.dx * math.sin(hr) + ofs.dy * math.cos(hr)
            end
            SetEntityCoordsNoOffset(ent, wx, wy, base.z + lift, false, false, false)
            -- a patty face in the stack carries its own roll (the two-faced flip)
            SetEntityRotation(ent, 0.0, (rolls and rolls[i]) or 0.0, sr.z, 2, true)
        end
        lift = lift + ((heights and heights[i]) or 0.0)
    end
end

-- Is a given oven door currently open (this client's view of the tween state)?
function IsOvenDoorOpen(propId, door)
    local rec = OvenDoors[propId]
    return (rec and rec.doors[door] and rec.doors[door].open) == true
end

local function loadModel(model)
    local hash = (type(model) == "number") and model or GetHashKey(model)
    if not IsModelInCdimage(hash) then
        print(("[pickle_restaurants] ^1Oven door model '%s' is not in the game index.^7"):format(tostring(model)))
        return nil
    end
    RequestModel(hash)
    local started = GetGameTimer()
    while not HasModelLoaded(hash) do
        Wait(0)
        if GetGameTimer() - started > 10000 then
            print(("[pickle_restaurants] ^1Oven door model '%s' failed to load within 10s.^7"):format(tostring(model)))
            return nil
        end
    end
    return hash
end

local function createDoorEntity(stove, door, open)
    local hash = loadModel(DOOR.model)
    if not hash then return nil end
    local o = doorOffset(door)
    local pos = GetOffsetFromEntityInWorldCoords(stove, o.x, o.y, o.z)
    local ent = CreateObject(hash, pos.x, pos.y, pos.z, false, false, false)
    SetModelAsNoLongerNeeded(hash)
    if not ent or not DoesEntityExist(ent) then return nil end
    FreezeEntityPosition(ent, true)
    SetEntityCollision(ent, true, true)
    applyDoorTransform(stove, ent, door, open and 1.0 or 0.0)
    return ent
end

function DespawnOvenDoors(propId)
    local rec = OvenDoors[propId]
    if not rec then return end
    if hovered.propId == propId then hovered.propId, hovered.door = nil, nil end
    for _, d in pairs(rec.doors) do SafeDeleteEntity(d.entity) end
    OvenDoors[propId] = nil
end

function SpawnOvenDoors(prop, stove)
    if not prop or prop.prop_type ~= "stovetop" then return end
    if not stove or not DoesEntityExist(stove) then return end
    DespawnOvenDoors(prop.id)
    local states = (prop.metadata and prop.metadata.doors) or {}
    local doors = {}
    for door = 1, 2 do
        local open = states[door] == true
        local ent = createDoorEntity(stove, door, open)
        if ent then doors[door] = { entity = ent, open = open, token = 0 } end
    end
    OvenDoors[prop.id] = { stove = stove, doors = doors }
end

-- Hide/show a placed stovetop's doors along with the stove itself (the reposition
-- gizmo hides the live station while you drag its preview — its doors have to go
-- with it, or they hang in mid-air next to the ghost).
function SetOvenDoorsVisible(propId, visible)
    local rec = OvenDoors[propId]
    if not rec then return end
    for _, d in pairs(rec.doors) do
        if d.entity and DoesEntityExist(d.entity) then
            SetEntityVisible(d.entity, visible and true or false, false)
        end
    end
end

-- ─── placement preview ───────────────────────────────────────────────────────
--  The placement gizmo previews the stove WITH its doors, at exactly the offsets
--  the placed station uses, so what you aim is what you get. SpawnOvenDoors seats
--  a door once against a station that never moves again; the gizmo prop moves
--  every frame, so these track it in a loop until the placement ends.

local PreviewDoors = nil -- { stove = entity, doors = { [door] = entity } }

function DespawnPreviewOvenDoors()
    local rec = PreviewDoors
    PreviewDoors = nil
    if not rec then return end
    for _, ent in pairs(rec.doors) do SafeDeleteEntity(ent) end
end

function SpawnPreviewOvenDoors(stove)
    DespawnPreviewOvenDoors()
    if not stove or not DoesEntityExist(stove) then return end
    local doors = {}
    for door = 1, 2 do
        local ent = createDoorEntity(stove, door, false) -- previewed closed
        if ent then
            SetEntityCollision(ent, false, false) -- the gizmo prop is non-colliding too
            doors[door] = ent
        end
    end
    local rec = { stove = stove, doors = doors }
    PreviewDoors = rec
    CreateThread(function()
        while PreviewDoors == rec and DoesEntityExist(stove) do
            for door, ent in pairs(rec.doors) do
                applyDoorTransform(stove, ent, door, 0.0)
            end
            Wait(0)
        end
        if PreviewDoors == rec then DespawnPreviewOvenDoors() end
    end)
end

-- ─── cursor hover + click ────────────────────────────────────────────────────
--  The cooking session raycasts the NUI cursor into the world each frame; if it
--  lands on a door we outline it, and a click toggles whatever is hovered.

local function setDoorOutline(ent, on)
    if not ent or not DoesEntityExist(ent) then return end
    SetEntityDrawOutline(ent, on)
    if on then SetEntityDrawOutlineColor(255, 180, 40, 255) end
end

-- Which door (1/2) of this stovetop a raycast-hit entity is, if any.
function GetOvenDoorIndexByEntity(propId, entity)
    local rec = OvenDoors[propId]
    if not rec then return nil end
    for door, d in pairs(rec.doors) do
        if d.entity == entity then return door end
    end
    return nil
end

-- Outline the door under the cursor (door = nil clears the highlight).
function HoverOvenDoor(propId, door)
    if hovered.propId == propId and hovered.door == door then return end
    local prev = hovered.propId and OvenDoors[hovered.propId]
    if prev and hovered.door and prev.doors[hovered.door] then
        setDoorOutline(prev.doors[hovered.door].entity, false)
    end
    hovered.propId, hovered.door = propId, door
    local rec = propId and OvenDoors[propId]
    if rec and door and rec.doors[door] then
        setDoorOutline(rec.doors[door].entity, true)
    end
end

function GetHoveredOvenDoor(propId)
    if hovered.propId == propId then return hovered.door end
    return nil
end

-- Animate a single door to its new state; a per-door token cancels any tween
-- already in flight so rapid toggles don't fight each other.
local function tweenDoor(rec, door, open)
    local d = rec.doors[door]; if not d then return end
    d.open = open
    d.token = d.token + 1
    local token = d.token
    local from  = open and 0.0 or 1.0
    local to    = open and 1.0 or 0.0
    CreateThread(function()
        local started = GetGameTimer()
        while true do
            if rec.doors[door] == nil or d.token ~= token then return end
            local t = math.min((GetGameTimer() - started) / DOOR.tween_ms, 1.0)
            applyDoorTransform(rec.stove, d.entity, door, from + (to - from) * t)
            if t >= 1.0 then return end
            Wait(0)
        end
    end)
end

function SetOvenDoor(propId, door, open)
    local rec = OvenDoors[propId]; if not rec then return end
    if not rec.doors[door] then return end
    tweenDoor(rec, door, open)
end

-- Server broadcast: a door changed state for everyone.
RegisterNetEvent("pickle_restaurants:doors:set", function(propId, door, open)
    SetOvenDoor(propId, door, open)
end)

-- ─── the cook's pose at the cooktop (BBQ scenario) ───────────────────────────
--  A cooking session hides YOUR OWN ped (modules/camera) but everyone else in the
--  kitchen still sees you standing at the stove — and standing there stock-still is
--  what a player who isn't doing anything looks like. So the cook plays the BBQ
--  scenario for as long as they are working the COOKTOP: it is the one vanilla
--  scenario that is a person cooking over a hot surface.
--
--  IT BELONGS TO THE COOKTOP, NOT TO THE STATION. A stovetop is two parts — the
--  hot surface and the two oven doors below it — and the camera already switches
--  between them (SetStationView). Someone crouched at an open oven is not flipping
--  burgers, so the pose stops on a door view and comes back with the cooktop. A
--  VIRTUAL station never poses at all: the shell is somewhere else entirely and the
--  ped is left standing where it really is, so a BBQ mimed in the middle of a
--  street is exactly the "man miming at a door" that modules/doorstep fixed.
--
--  IT IS A SCENARIO, AND THAT IS SAFE HERE. modules/seating's warning (scenarios
--  were TRIED AND REVERTED) is about a scenario deciding where to PUT a ped — the
--  natives put players through the floor and the is-it-still-playing checks were
--  too unreliable to repair from. Nothing here asks it to position anything:
--  `TaskStartScenarioInPlace` leaves the ped exactly where it walked to, we never
--  poll whether it's still running, and there is no repair loop to get stuck in.
--
--  THE SCENARIO BRINGS ITS OWN PROPS AND DOES NOT ALWAYS TAKE THEM AWAY. The task
--  creates the cook's grill/utensils itself, and a session that ends any way other
--  than the exit animation finishing — ESC, a fire ejecting the cook
--  (ForceStopCooking), a resource restart — leaves them standing in the kitchen
--  with nothing tracking them, exactly like the orphaned props SpawnProp's spawn
--  token exists to prevent. So everything the task ADDED is deleted on the way out:
--  the object pool is snapshotted before the scenario starts, and only objects that
--  are absent from that snapshot can ever be deleted — a BBQ that was already part
--  of the map, and every food prop this resource spawns on the station, is in the
--  snapshot and can never be touched.
local POSE = {
    scenario = "PROP_HUMAN_BBQ",
    -- How far from the cook one of the task's props may land. TUNE IN-GAME.
    radius   = 3.0,
    -- The models the scenario is known to bring with it. Anything ATTACHED to the
    -- ped is claimed whatever its model (that's a held utensil, and nothing else
    -- attaches to a player ped here); this list is what lets a free-standing prop
    -- be told from the room it was set down in. TUNE IN-GAME — add a model if a
    -- build's scenario spawns one this doesn't name.
    models   = { "prop_bbq_1", "prop_bbq_2", "prop_bbq_3", "prop_bbq_4", "prop_bbq_5" },
    -- The exit animation is allowed to put its own props away first; the sweep runs
    -- again after it, since a cook who left mid-scene never gets that far.
    exit_ms  = 700,
    -- How long after the task starts to keep WATCHING for the props it brings, and
    -- how often to look. The scenario creates them during its enter animation, not
    -- on the frame the task is given, so a single snapshot at start sees nothing.
    -- TUNE IN-GAME.
    claim_ms   = 5000,
    claim_step = 250,
    -- How long ClearPedTasks gets to end the scenario POLITELY (it plays the outro to
    -- get there) before the ped is taken out of it outright, and how many times to
    -- insist. The cook has already left the station by then — the camera is back and
    -- the panel is shut — so a long outro just reads as the pose refusing to stop.
    -- TUNE IN-GAME.
    stop_ms    = 250,
    stop_tries = 6,
}

-- nil = not posed. `before` is the object pool as it stood the instant before the
-- task started: the only objects we may ever delete are the ones missing from it.
local posed = nil

local function poseModelSet()
    local set = {}
    for _, m in ipairs(POSE.models) do set[GetHashKey(m)] = true end
    return set
end

local function deletePoseProp(obj)
    if not DoesEntityExist(obj) then return end
    SetEntityAsMissionEntity(obj, true, true)
    DeleteEntity(obj)
end

-- CLAIM THE SCENARIO'S PROPS WHILE THEY ARE STILL IDENTIFIABLE, don't go looking for
-- them at the end. Two things stop being true by the time the cook leaves:
--
--   • the held utensil is only ATTACHED while the task owns the ped — clearing the
--     task drops it, and a loose spatula is no BBQ model, so the end-of-session test
--     recognised nothing and it stayed standing in the kitchen;
--   • a prop the outro or a force-clear has already begun putting away can be
--     anywhere, so a distance test against where the cook ended up misses it.
--
-- So a claim thread watches for the length of the enter animation (the props appear
-- DURING it, which is also why snapshotting once at start finds nothing) and records
-- HANDLES. The end of the session then deletes those handles outright, and the old
-- positional sweep stays as the fallback for anything that appeared later.
--
-- Claiming is also where COLLISION is turned off between the prop and the cook. The
-- task drops a solid BBQ into the space the player is standing in, and the collision
-- depenetration pass shoves them out of it — which is the walking-away-from-the-stove
-- after closing the panel. Only the pair is disabled, so the prop still collides with
-- the room for as long as it exists.
local function claimPoseProp(p, obj)
    if p.owned[obj] then return end
    p.owned[obj] = true
    if DoesEntityExist(p.ped) then SetEntityNoCollisionEntity(obj, p.ped, true) end
end

local function watchScenarioProps(p)
    CreateThread(function()
        local models = poseModelSet()
        local waited = 0
        while posed == p and waited < POSE.claim_ms do
            local here = DoesEntityExist(p.ped) and GetEntityCoords(p.ped) or nil
            for _, obj in ipairs(GetGamePool("CObject")) do
                if not p.before[obj] and not p.owned[obj] and DoesEntityExist(obj) then
                    if GetEntityAttachedTo(obj) == p.ped
                        or (models[GetEntityModel(obj)] and here
                            and #(GetEntityCoords(obj) - here) <= POSE.radius) then
                        claimPoseProp(p, obj)
                    end
                end
            end
            Wait(POSE.claim_step)
            waited = waited + POSE.claim_step
        end
    end)
end

-- Delete what the scenario ADDED and nothing else: the handles claimed above, plus a
-- positional pass for anything that appeared after the claim window. Called twice
-- (immediately and after the exit animation) against the same session — deleting an
-- already-deleted entity is a no-op, so the two racing is harmless.
local function sweepScenarioProps(p, ped)
    if not p or not p.before then return end
    for obj in pairs(p.owned) do deletePoseProp(obj) end
    local models = poseModelSet()
    local here = DoesEntityExist(ped) and GetEntityCoords(ped) or nil
    for _, obj in ipairs(GetGamePool("CObject")) do
        if not p.before[obj] and DoesEntityExist(obj) then
            local attached = GetEntityAttachedTo(obj) == ped
            local mine = attached
                or (models[GetEntityModel(obj)] and here
                    and #(GetEntityCoords(obj) - here) <= POSE.radius)
            if mine then deletePoseProp(obj) end
        end
    end
end

-- Start (or keep) the cook's pose. Idempotent: the view can be switched back to the
-- cooktop repeatedly without restarting the scenario under the ped.
function StartStovetopPose()
    if posed then return end
    local ped = PlayerPedId()
    if not DoesEntityExist(ped) or IsPedInAnyVehicle(ped, false) then return end
    local before = {}
    for _, obj in ipairs(GetGamePool("CObject")) do before[obj] = true end
    posed = { ped = ped, before = before, owned = {} }
    TaskStartScenarioInPlace(ped, POSE.scenario, 0, true)
    watchScenarioProps(posed)
end

-- Stop it and take the scenario's props with it. Safe to call when nothing is posed
-- (every close path does, so no caller has to know whether this station had one).
-- ASKING A SCENARIO TO STOP IS NOT STOPPING IT. `ClearPedTasks` only requests the end
-- of PROP_HUMAN_BBQ, and the ped gets there by playing the scenario's own outro — that
-- is the second or so of grilling that carries on after the panel has closed. Worse, a
-- request that lands while the ENTER animation is still playing is swallowed outright,
-- and the cook is left grilling indefinitely: the same call, ignored, which is why this
-- only bites "sometimes".
--
-- So it ESCALATES: ask politely once, then take the ped out of it. Unlike
-- modules/seating's repair loop — the reason the unreliable scenario natives are
-- distrusted around here — this loop only ever CLEARS, never re-TASKS, so the worst a
-- misreported state costs is one redundant call. It is bounded, and it stands down the
-- moment the cook is posed again (switching back to the cooktop from an oven door),
-- so it can never fight a fresh pose.
function StopStovetopPose()
    local p = posed
    if not p then return end
    posed = nil
    local ped = p.ped
    if DoesEntityExist(ped) then ClearPedTasks(ped) end
    sweepScenarioProps(p, ped)
    CreateThread(function()
        local reposed = false
        for _ = 1, POSE.stop_tries do
            Wait(POSE.stop_ms)
            if posed then reposed = true break end -- re-posed; that session owns the ped now
            if not DoesEntityExist(ped) then break end
            if not (IsPedUsingAnyScenario(ped) or IsPedActiveInScenario(ped)) then break end
            ClearPedTasksImmediately(ped)
        end
        -- the outro (or the force-clear) has had its chance to put the scenario's own
        -- props away; anything it left standing is ours to remove
        Wait(POSE.exit_ms)
        -- THE CLAIMED HANDLES ARE DELETED EVEN IF THE COOK IS BACK AT THE COOKTOP:
        -- they belong to the scenario that has already ended, so a re-pose has no
        -- claim on them — and leaving them would strand them permanently, since the
        -- new session's snapshot now counts them as part of the room. Only the
        -- positional sweep stands down, because that one can't tell the sessions apart.
        for obj in pairs(p.owned) do deletePoseProp(obj) end
        if not posed and not reposed then sweepScenarioProps(p, ped) end
    end)
end

AddEventHandler("onResourceStop", function(res)
    if res ~= GetCurrentResourceName() then return end
    for propId in pairs(OvenDoors) do DespawnOvenDoors(propId) end
    -- A restart is the one ending the session's own paths never reach: without this
    -- the cook keeps the pose (and the scenario's props keep standing there) with
    -- nothing left able to clear either.
    local p = posed
    if p then
        posed = nil
        if DoesEntityExist(p.ped) then ClearPedTasks(p.ped) end
        sweepScenarioProps(p, p.ped)
    end
end)
