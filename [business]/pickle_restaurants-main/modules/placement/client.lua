-- =============================================
--  modules/placement | client.lua
--  Drives the gizmo (modules/gizmo) to place the four station props and the
--  counter point, then persists them through the server.
-- =============================================

PLACEABLE_MODELS = {
    soda_machine = "pickle_soda_fountain_01",
    fryer        = "pickle_fryer_01",
    stovetop     = "pickle_stovetop_01",
    kitchen_prep = "pickle_kitchen_prep_01",
    -- The kiosk is a customer-facing SELF-ORDER terminal, not a cooking station:
    -- its interaction opens the order NUI (modules/sales OpenKiosk), and the order
    -- becomes an ordinary kitchen ticket a worker fulfils. Physical-only (no virtual
    -- point — it must be a reachable world prop), so it is NOT in VIRTUAL_TARGETS.
    -- Two body styles: the WALL-mounted terminal (_01, pushed off the wall so it
    -- doesn't bury into it) and a free-standing GROUND kiosk (_02) that sits on the
    -- floor like any other prop. Both are `kiosk`-family props everywhere downstream.
    kiosk        = "pickle_kiosk_large_01",
    kiosk_ground = "pickle_kiosk_large_02",
    -- Customer-facing INFO SCREENS: non-interactable wall props whose branded screen
    -- texture is replaced at runtime by a DUI (modules/screens). The menu board slideshows
    -- what the restaurant sells; the orders board shows tickets in progress, latest first.
    menu_screen   = "pickle_screen_menu_01",
    orders_screen = "pickle_screen_orders_01",
}

-- Wall-mounted props sit flush against the wall the admin aims at, so their origin
-- lands ON the wall face and half the body buries into it. These get pushed back off
-- the wall (toward the placer) by ~half their depth in the gizmo. Ground props place
-- normally (origin on the floor).
local WALL_MOUNTED = { kiosk = true, menu_screen = true, orders_screen = true }

-- Half the model's front-to-back depth (its local Y extent) — how far to nudge a
-- wall-mounted prop off the wall so its BACK rests against it instead of its centre.
local function WallMountDepth(model)
    local hash = GetHashKey(model)
    RequestModel(hash)
    local t = GetGameTimer()
    while not HasModelLoaded(hash) and GetGameTimer() - t < 1000 do Wait(0) end
    local mn, mx = GetModelDimensions(hash)
    if mn and mx then return math.max((mx.y - mn.y) * 0.5, 0.1) end
    return 0.35 -- fallback depth (m) if the model's bounds aren't ready
end

function StartPropPlacement(restaurantId, propType)
    local model = PLACEABLE_MODELS[propType]
    if not model then return ShowNotification(_L("place_unknown_station")) end
    Wait(250) -- let the NUI fully release focus before the gizmo takes input
    local opts = { model = GetHashKey(model), enableCancel = true, deleteEntity = true }
    if WALL_MOUNTED[propType] then opts.wallOffset = WallMountDepth(model) end
    -- The stovetop's oven doors are separate props seated off the stove's transform
    -- (modules/stovetop): preview them on the gizmo prop at the SAME offsets so what
    -- you aim is exactly what gets spawned.
    if propType == "stovetop" and SpawnPreviewOvenDoors then
        opts.onSpawn   = SpawnPreviewOvenDoors
        opts.onDespawn = DespawnPreviewOvenDoors
    end
    local result = StartGizmoEditor(opts)
    if not result or not result.position then return end
    local res = lib.callback.await("pickle_restaurants:placement:saveProp", false, {
        restaurant_id = restaurantId,
        prop_type     = propType,
        model         = model,
        x = result.position.x, y = result.position.y, z = result.position.z,
        heading = (result.rotation and result.rotation.z) or 0.0,
    })
    if res and res.ok then
        ShowNotification(_L("place_station_placed"))
    else
        ShowNotification((res and res.error) or _L("place_station_fail"))
    end
end

-- The ghost ped shown while positioning a seat anchor, so the admin can see where
-- (and which way) a player will be seated. Reuses one of the NPC-customer models.
local SEAT_PREVIEW_PED = "a_m_y_business_01"

-- Which KIND of seat this anchor is (Config.SeatStyles) — asked BEFORE the gizmo
-- opens, because the answer changes the ghost's pose and height, and the whole point
-- of the ghost is that you position what you'll actually get. Returns nil if the
-- admin cancels the dialog, which cancels the placement.
local function PickSeatStyle(current)
    local options = {}
    for i, s in ipairs(Config.SeatStyles) do
        options[i] = { value = s.id, label = _L(s.label) }
    end
    local input = lib.inputDialog(_L("place_seat_style_title"), {
        {
            type        = "select",
            label       = _L("place_seat_style_label"),
            description = _L("place_seat_style_hint"),
            options     = options,
            default     = current or Config.DefaultSeatStyle,
            required    = true,
        },
    })
    return input and input[1] or nil
end

-- WHICH PARTS of an existing seat this edit touches. A seat is four separate
-- answers (style, the seat point, the stand-up point, the tray patch), and
-- editing one used to mean re-confirming all four gizmos in a row — three of them
-- just to get back what was already there. So an edit ASKS first and only runs the
-- passes that were ticked; everything unticked is carried through untouched.
-- Returns nil if the dialog is cancelled (the whole edit is off).
-- NOTE: this makes cancelling a pass mean "clear that point" ONLY for a point you
-- chose to edit — which is still the one way to take an exit/tray point back off.
local function PickSeatEditParts(prop)
    local meta = prop.metadata or {}
    -- Whether each OPTIONAL point exists rides in its label: a checkbox row can't
    -- carry a description, and "not set" is exactly what you need to know before
    -- deciding to tick it (ticking then cancelling the gizmo is how one is removed).
    local function state(v) return v and _L("place_seat_edit_has") or _L("place_seat_edit_none") end
    local input = lib.inputDialog(_L("place_seat_edit_title"), {
        { type = "checkbox", label = _L("place_seat_edit_style") },
        { type = "checkbox", label = _L("place_seat_edit_point") },
        { type = "checkbox", label = _L("place_seat_edit_exit", state(meta.exit)) },
        { type = "checkbox", label = _L("place_seat_edit_tray", state(meta.tray)) },
    })
    if not input then return nil end
    local parts = { style = input[1] == true, point = input[2] == true,
                    exit = input[3] == true, tray = input[4] == true }
    if not (parts.style or parts.point or parts.exit or parts.tray) then
        ShowNotification(_L("place_seat_edit_nothing"))
        return nil
    end
    return parts
end

-- Where a player is put down when they STAND UP from this seat — a second anchor,
-- placed right after the seat itself with a STANDING ghost. Without one a diner
-- stands up exactly where they were sitting, which on a booth or a bar means
-- popping out on top of the table.
--
-- Optional by design: cancelling this gizmo saves the seat with no exit point and
-- the old stand-in-place behaviour, so a plain chair in open floor doesn't have to
-- have one. Seeded a step in FRONT of the seat (its heading), which is the right
-- answer often enough to just accept.
local SEAT_EXIT_STEP = 0.8 -- metres in front of the seat the exit ghost starts at

-- `at` is where the ghost STARTS, already resolved by the caller — an existing exit
-- point re-opens exactly on itself (so re-confirming an edit can't creep it forward
-- 0.8m every time), a new one starts a step in front of the seat.
local function PickSeatExit(at, heading)
    ShowNotification(_L("place_seat_exit_hint"))
    Wait(250)
    local result = StartGizmoEditor({
        isPed        = true,
        model        = SEAT_PREVIEW_PED,
        coords       = at,
        rotation     = vector3(0.0, 0.0, heading or 0.0),
        enableCancel = true,
        deleteEntity = true,
    })
    if not result or not result.position then return nil end
    return {
        x = result.position.x, y = result.position.y, z = result.position.z,
        heading = (result.rotation and result.rotation.z) or 0.0,
    }
end

-- A step in front of a seat facing `heading` — the default place to stand up.
local function SeatExitSeed(x, y, z, heading)
    local rad = math.rad(heading or 0.0)
    return vector3(x - math.sin(rad) * SEAT_EXIT_STEP, y + math.cos(rad) * SEAT_EXIT_STEP, z)
end

-- Where this seat's MEAL TRAY is laid out — the patch of table in front of the
-- diner. Optional, like the exit point: without one, dining probes downward for a
-- surface in front of the ped, which is right for a plain table and wrong wherever
-- the geometry lies (a booth's fixed table, a bar top, a bench with no table at
-- all). The ghost is the real serving tray, so the admin positions the actual
-- object and sees exactly where the food will sit.
local SEAT_TRAY_MODEL = "pickle_tray_01"
local SEAT_TRAY_FWD   = 0.55 -- metres in front of the seat the tray ghost starts at
local SEAT_TRAY_UP    = 0.70 -- and how far above it (a typical table height)

local function PickSeatTray(at, heading)
    ShowNotification(_L("place_seat_tray_hint"))
    Wait(250)
    local result = StartGizmoEditor({
        model        = GetHashKey(SEAT_TRAY_MODEL),
        coords       = at,
        rotation     = vector3(0.0, 0.0, heading or 0.0),
        enableCancel = true,
        deleteEntity = true,
    })
    if not result or not result.position then return nil end
    return {
        x = result.position.x, y = result.position.y, z = result.position.z,
        heading = (result.rotation and result.rotation.z) or 0.0,
    }
end

local function SeatTraySeed(x, y, z, heading)
    local rad = math.rad(heading or 0.0)
    return vector3(x - math.sin(rad) * SEAT_TRAY_FWD,
                   y + math.cos(rad) * SEAT_TRAY_FWD, z + SEAT_TRAY_UP)
end

-- Place an invisible seat anchor: the gizmo shows a ghost person; we persist the
-- point + facing + style, then a second point for where they stand up. No
-- model/prop is spawned at runtime — players sit on the restaurant's existing
-- furniture here.
function StartSeatPlacement(restaurantId)
    Wait(250)
    local style = PickSeatStyle()
    if not style then return end
    -- Preview the ghost ped in the CHOSEN style's seated pose at exactly where they'll
    -- sit: the gizmo plays that style's looping clip and drops the ped by its height
    -- trim, while the SAVED anchor stays the point the seating code expects
    -- (result.position adds the offset back). WYSIWYG placement.
    local sitDict, sitAnim = SeatPreviewAnim(style)
    local result = StartGizmoEditor({
        isPed        = true,
        model        = SEAT_PREVIEW_PED,
        anim         = { dict = sitDict, name = sitAnim },
        coordsOffset = vector3(0.0, 0.0, -SeatSitOffsetZ(style)),
        enableCancel = true,
        deleteEntity = true,
    })
    if not result or not result.position then return end
    local heading = (result.rotation and result.rotation.z) or 0.0
    local exit = PickSeatExit(
        SeatExitSeed(result.position.x, result.position.y, result.position.z, heading), heading)
    local tray = PickSeatTray(
        SeatTraySeed(result.position.x, result.position.y, result.position.z, heading), heading)
    local res = lib.callback.await("pickle_restaurants:placement:saveSeat", false, {
        restaurant_id = restaurantId,
        style         = style,
        exit          = exit,
        tray          = tray,
        x = result.position.x, y = result.position.y, z = result.position.z,
        heading = heading,
    })
    if res and res.ok then
        ShowNotification(_L("place_seat_placed"))
    else
        ShowNotification((res and res.error) or _L("place_seat_fail"))
    end
end

-- Place a DELIVERY DOOR: the doorstep an NPC delivery order sends a driver to. The
-- ghost stands where the resident will when they answer, FACING OUT of the doorway
-- — that facing is what the knock/hand-off sequence uses to know which way "out of
-- the house" is, so aim it down the path, not at the door.
--
-- `facePlacer`: the ghost looks BACK at you the whole time you're aiming, not away
-- (the gizmo re-derives its heading from the camera every frame). You place one of
-- these standing where the driver stands — on the path, looking at the house — so
-- facing you IS facing out of the doorway, and no door needs the 180° spin any more.
function StartDeliveryDoorPlacement(restaurantId)
    Wait(250)
    ShowNotification(_L("place_door_hint"))
    local result = StartGizmoEditor({
        isPed        = true,
        model        = SEAT_PREVIEW_PED,
        facePlacer   = true,
        enableCancel = true,
        deleteEntity = true,
    })
    if not result or not result.position then return end
    local res = lib.callback.await("pickle_restaurants:placement:saveDeliveryDoor", false, {
        restaurant_id = restaurantId,
        x = result.position.x, y = result.position.y, z = result.position.z,
        heading = (result.rotation and result.rotation.z) or 0.0,
    })
    if res and res.ok then
        ShowNotification(_L("place_door_placed"))
    else
        ShowNotification((res and res.error) or _L("place_door_fail"))
    end
end

-- Place the per-restaurant NPC customer spawn point: where AI customers appear
-- before walking up to the counter to queue. A standing ghost ped previews exactly
-- where (and facing which way) a customer will materialise, so admins put it on a
-- clear, reachable spot near the register — the old behaviour spawned them a fixed
-- distance back along the queue line, which often landed inside props and stuck them.
-- Only the point + heading are saved (no runtime prop).
function StartNpcSpawnPlacement(restaurantId)
    Wait(250)
    local result = StartGizmoEditor({
        isPed        = true,
        model        = SEAT_PREVIEW_PED,
        enableCancel = true,
        deleteEntity = true,
    })
    if not result or not result.position then return end
    local res = lib.callback.await("pickle_restaurants:placement:saveNpcSpawn", false, {
        restaurant_id = restaurantId,
        x = result.position.x, y = result.position.y, z = result.position.z,
        heading = (result.rotation and result.rotation.z) or 0.0,
    })
    if res and res.ok then
        ShowNotification(_L("place_npc_spawn_set"))
    else
        ShowNotification((res and res.error) or _L("place_npc_spawn_fail"))
    end
end

-- The small marker prop used to position an INVISIBLE, interaction-only anchor: a
-- virtual point (the station spawns in the kitchen shell at runtime) and a supply
-- depot's order counter (nothing spawns there at all). Previewing a prop the world
-- will never have just buries the spot, so a tennis ball marks the exact anchor
-- without hiding what is under it.
local VIRTUAL_PLACE_MODEL = "prop_tennis_ball"

-- Place an invisible virtual point anchor: the gizmo previews a small ball at the
-- anchor (NOT the whole station), and only the point + heading are saved — at
-- runtime the anchor is interaction-only, and the station itself spawns inside the
-- restaurant's kitchen shell when the point is used.
function StartVirtualPointPlacement(restaurantId, target)
    local model = PLACEABLE_MODELS[target]
    if not model then return ShowNotification(_L("place_unknown_station")) end
    Wait(250)
    local result = StartGizmoEditor({ model = GetHashKey(VIRTUAL_PLACE_MODEL), enableCancel = true, deleteEntity = true })
    if not result or not result.position then return end
    local res = lib.callback.await("pickle_restaurants:placement:saveVirtualPoint", false, {
        restaurant_id = restaurantId,
        target        = target,
        x = result.position.x, y = result.position.y, z = result.position.z,
        heading = (result.rotation and result.rotation.z) or 0.0,
    })
    if res and res.ok then
        ShowNotification(_L("place_virtual_placed"))
    else
        ShowNotification((res and res.error) or _L("place_virtual_fail"))
    end
end

-- ─── kitchen shell placement ─────────────────────────────────────────────────
-- The shell's XY is pinned to the restaurant's counter (its blip/center anchor);
-- this view only chooses HEIGHT + facing, so it's a dedicated loop with its own
-- scripted camera rather than the raycast gizmo: scroll moves the shell up/down,
-- arrows rotate it, and the camera tracks the shell so the admin always sees
-- where it sits relative to the restaurant below. The shell model + loader are
-- shared with modules/virtual so the preview and the session build can't drift.
local SHELL_CAM     = { back = -18.0, up = 8.0, fov = 50.0, lookUp = 2.0 } -- framing offsets. TUNE IN-GAME.
local SHELL_Z_STEP  = 2.5 -- meters per scroll notch (x4 with SHIFT)
-- Where an UNPLACED shell starts: 20m over the counter. Seated at the counter's own
-- height it opens up inside whatever building the restaurant is in, and the camera —
-- which sits 18m back — is then looking at the shell through that building's exterior
-- walls, so the admin can't see the thing they're positioning. Starting above the
-- roofline puts it in clear air on the first frame; scroll brings it back down.
local SHELL_DEFAULT_UP = 20.0 -- TUNE IN-GAME.

function StartShellPlacement(restaurantId)
    local rest = GetRestaurantById(restaurantId)
    -- No register placed yet? The shell anchors to the counter, so there is nothing
    -- to position it against. This used to be a greyed-out button; instead, run the
    -- counter placement first and carry straight on into the shell once it lands.
    if rest and not rest.counter then
        ShowNotification(_L("place_shell_counter_first"))
        if not StartCounterPlacement(restaurantId) then return end
        -- the counter is saved server-side; wait for the sync that carries it back
        local t = GetGameTimer()
        repeat
            Wait(50)
            rest = GetRestaurantById(restaurantId)
        until (rest and rest.counter) or GetGameTimer() - t > 5000
    end
    if not rest or not rest.counter then return ShowNotification(_L("place_shell_needs_counter")) end
    Wait(250) -- let the NUI fully release focus before the loop takes input
    -- Carry the launching panel's theme onto this loop's control-hint overlay
    -- (the panel closed for placement, resetting the NUI to the default kit).
    if ReassertNUITheme then ReassertNUITheme() end

    local hash = LoadModelTimeout(VirtualShellModel())
    if not hash then return ShowNotification(_L("virtual_shell_missing")) end

    local c = rest.counter
    local z = (rest.shell and rest.shell.z) or (c.z + SHELL_DEFAULT_UP)
    local heading = (rest.shell and rest.shell.heading) or 0.0
    local shell = CreateObject(hash, c.x, c.y, z, false, false, false)
    SetModelAsNoLongerNeeded(hash)
    if not shell or not DoesEntityExist(shell) then return end
    FreezeEntityPosition(shell, true)
    SetEntityCollision(shell, false, false)
    SetEntityLodDist(shell, 0xFFFF) -- it's viewed from 18m back, high over the counter

    -- The shell sits well above the counter, and the camera goes with it — out of
    -- the bubble streamed around the PED. Without pinning the focus there the first
    -- frames render an unstreamed void (the shell itself unlit / not yet drawn), and
    -- it only came right once a scroll happened to move it back into loaded space.
    -- Same treatment modules/virtual gives the session build, minus the fade.
    SetFocusPosAndVel(c.x, c.y, z, 0.0, 0.0, 0.0)
    RequestCollisionAtCoord(c.x, c.y, z)
    NewLoadSceneStartSphere(c.x, c.y, z, 60.0, 0)
    local t0 = GetGameTimer()
    while not IsNewLoadSceneLoaded() and GetGameTimer() - t0 < 1500 do Wait(0) end
    NewLoadSceneStop()

    local cam = CreateCamWithParams("DEFAULT_SCRIPTED_CAMERA",
        c.x, c.y - SHELL_CAM.back, z + SHELL_CAM.up, 0.0, 0.0, 0.0, SHELL_CAM.fov, false, 2)
    SetCamActive(cam, true)
    RenderScriptCams(true, true, 650, true, true)
    -- the camera is detached from the ped: park the player and take ALL gameplay
    -- controls (scroll doubles as weapon-cycle, LMB fires) — inputs are read
    -- through the Disabled variants below
    local ped = PlayerPedId()
    FreezeEntityPosition(ped, true)

    local saved = false
    local dirty = true -- (re)seat the shell + camera only when z/heading change
    -- ...EXCEPT for the first second, where it re-seats every frame. The shell is
    -- created 20m up, outside the bubble streamed around the ped, and a fresh object
    -- out there doesn't render (or renders unlit) until something MOVES it once the
    -- streamer has caught up — which is why the view only came right after the first
    -- scroll notch. A single seat on frame 1 lands before the object/camera exist
    -- properly, so it can't be that something: this window replays the exact scroll
    -- path (the `dirty` block below) across the camera's 650ms ease-in instead.
    local settleUntil = GetGameTimer() + 1000 -- TUNE IN-GAME
    while true do
        DisableAllControlActions(0)
        local speedMode = IsDisabledControlPressed(0, 21) and 4 or 1

        -- scroll = height, arrows = facing
        if IsDisabledControlJustPressed(0, 15) then z = z + SHELL_Z_STEP * speedMode dirty = true end
        if IsDisabledControlJustPressed(0, 14) then z = z - SHELL_Z_STEP * speedMode dirty = true end
        if IsDisabledControlPressed(0, 174) then heading = (heading - 1.0 * speedMode) % 360.0 dirty = true end
        if IsDisabledControlPressed(0, 175) then heading = (heading + 1.0 * speedMode) % 360.0 dirty = true end
        if dirty or GetGameTimer() < settleUntil then
            -- a scroll notch's own work: move it, re-aim the camera, move the focus
            SetEntityCoordsNoOffset(shell, c.x, c.y, z, false, false, false)
            SetEntityHeading(shell, heading)
            -- track the shell from behind its facing so rotation reads naturally
            local camPos = GetOffsetFromEntityInWorldCoords(shell, 0.0, SHELL_CAM.back, SHELL_CAM.up)
            SetCamCoord(cam, camPos.x, camPos.y, camPos.z)
            PointCamAtCoord(cam, c.x, c.y, z + SHELL_CAM.lookUp)
            -- keep the streamed bubble on the shell as it moves, not on the parked ped
            SetFocusPosAndVel(c.x, c.y, z, 0.0, 0.0, 0.0)
            dirty = false
        end

        -- ground reference: ring at the counter + a plumb line up to the shell
        DrawMarker(1, c.x, c.y, c.z - 0.98, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0,
            3.0, 3.0, 2.0, 255, 255, 255, 90, false, false, 2, false, nil, nil, false)
        DrawLine(c.x, c.y, c.z, c.x, c.y, z, 255, 255, 255, 160)

        ShowInteractText(
            '[SCROLL]     - ' .. _L("place_shell_height", z - c.z) .. '  \n' ..
            '[< / >]     - ' .. _L("place_shell_rotate") .. '  \n' ..
            '[E]     - ' .. _L("objects_save") .. '  \n' ..
            '[ESC / BACKSPACE]     - ' .. _L("objects_cancel")
        )

        -- pause-menu suppression (same working pattern as the gizmo loop)
        ForcePauseMenuClosed()
        if IsDisabledControlJustPressed(0, 202)
            or IsDisabledControlJustReleased(0, 199)
            or IsDisabledControlJustReleased(0, 200)
            or IsDisabledControlJustReleased(0, 322) then
            -- same as the gizmo: the loop holding the key off the frontend is the
            -- loop this press ends (modules/interactive's GuardPauseKeys)
            if GuardPauseKeys then GuardPauseKeys() end
            break
        end
        if IsDisabledControlJustPressed(0, 51) then saved = true break end
        Wait(0)
    end

    ClearFocus() -- hand streaming back to the ped
    FreezeEntityPosition(ped, false)
    RenderScriptCams(false, true, 650, true, true)
    CreateThread(function()
        Wait(700) -- let the ease back finish before the cam handle dies
        if cam then DestroyCam(cam, false) end
    end)
    SetEntityAsMissionEntity(shell, true, true)
    DeleteEntity(shell)

    if not saved then return end
    local res = lib.callback.await("pickle_restaurants:placement:saveShell", false, {
        restaurant_id = restaurantId, z = z, heading = heading,
    })
    if res and res.ok then
        ShowNotification(_L("place_shell_saved"))
    else
        ShowNotification((res and res.error) or _L("place_shell_fail"))
    end
end

-- A VIRTUAL register is an invisible register anchor (prop_type "virtual_register"):
-- nothing spawns in the world, so — like a virtual point — the gizmo previews a small
-- ball at the exact anchor, and only the point + heading are saved. Using it opens the
-- ordinary fullscreen NUI register (modules/main), not the counter's in-world DUI.
function StartVirtualRegisterPlacement(restaurantId)
    Wait(250)
    local result = StartGizmoEditor({ model = GetHashKey(VIRTUAL_PLACE_MODEL), enableCancel = true, deleteEntity = true })
    if not result or not result.position then return end
    local res = lib.callback.await("pickle_restaurants:placement:saveVirtualRegister", false, {
        restaurant_id = restaurantId,
        x = result.position.x, y = result.position.y, z = result.position.z,
        heading = (result.rotation and result.rotation.z) or 0.0,
    })
    if res and res.ok then
        ShowNotification(_L("place_virtual_register_placed"))
    else
        ShowNotification((res and res.error) or _L("place_virtual_register_fail"))
    end
end

-- A counter is the register anchor: what you aim with the gizmo is the register model
-- itself (modules/main spawns exactly this at the point), so the preview IS the result.
-- Placing is additive: a restaurant can have several registers (modules/main gives each
-- one its interaction; the lowest-id counter is the primary blip/shell/NPC anchor).
-- Returns whether a counter was actually saved, so a caller that needs one to exist
-- (the shell) can chain onto it and bail cleanly on a cancel.
function StartCounterPlacement(restaurantId)
    Wait(250)
    local result = StartGizmoEditor({ model = CounterModel(), enableCancel = true, deleteEntity = true })
    if not result or not result.position then return false end
    local res = lib.callback.await("pickle_restaurants:placement:saveCounter", false, {
        restaurant_id = restaurantId,
        x = result.position.x, y = result.position.y, z = result.position.z,
        heading = (result.rotation and result.rotation.z) or 0.0,
    })
    if res and res.ok then
        ShowNotification(_L("place_counter_set"))
        return true
    end
    ShowNotification((res and res.error) or _L("place_counter_fail"))
    return false
end

-- Reposition an already-placed prop. Re-runs the gizmo SEEDED at the prop's current
-- transform (starts exactly where it sits) with the same preview its original
-- placement used — physical station, counter till, seated ghost ped, or virtual
-- point ball — then persists the new transform via updateProp.
function StartPropReposition(propId)
    local prop = GetClientProp and GetClientProp(tonumber(propId))
    if not prop then return ShowNotification(_L("place_unknown_station")) end
    Wait(250)

    -- Hide the prop's CURRENT world entity so it doesn't sit as a ghost duplicate
    -- next to the gizmo preview while you drag. On save, the re-sync deletes + respawns
    -- it at the new spot; on cancel / failure we restore its visibility below.
    local liveEnt = GetStationEntity and GetStationEntity(tonumber(propId))
    if liveEnt and DoesEntityExist(liveEnt) then SetEntityVisible(liveEnt, false, false) end
    -- a stovetop's oven doors are separate entities — hide/restore them with it
    if SetOvenDoorsVisible then SetOvenDoorsVisible(tonumber(propId), false) end
    local function restoreLive()
        if liveEnt and DoesEntityExist(liveEnt) then SetEntityVisible(liveEnt, true, false) end
        if SetOvenDoorsVisible then SetOvenDoorsVisible(tonumber(propId), true) end
    end

    local seed = {
        coords       = vector3(prop.x + 0.0, prop.y + 0.0, prop.z + 0.0),
        rotation     = vector3(0.0, 0.0, (prop.heading or 0.0) + 0.0),
        enableCancel = true,
        deleteEntity = true,
    }
    local ptype = prop.prop_type
    local seatStyle -- carried to updateProp below (seats only)
    local parts     -- which parts of a seat this edit touches (seats only)
    if ptype == "seat" then
        -- Ask what's being edited FIRST — a seat is four answers and this edit only
        -- runs the ones ticked (the rest are re-submitted exactly as they are).
        parts = PickSeatEditParts(prop)
        if not parts then restoreLive(); return end
        -- The style decides the ghost's pose, so it's still asked before the gizmo —
        -- but only when it's part of the edit. Untouched keeps the stored one, which
        -- is also what the seat-point ghost previews.
        seatStyle = (prop.metadata and prop.metadata.style) or Config.DefaultSeatStyle
        if parts.style then
            seatStyle = PickSeatStyle(seatStyle)
            if not seatStyle then restoreLive(); return end
        end
        local sitDict, sitAnim = SeatPreviewAnim(seatStyle)
        seed.isPed        = true
        seed.model        = SEAT_PREVIEW_PED
        seed.anim         = { dict = sitDict, name = sitAnim }
        seed.coordsOffset = vector3(0.0, 0.0, -SeatSitOffsetZ(seatStyle))
        seed.coords       = vector3(prop.x + 0.0, prop.y + 0.0, prop.z - SeatSitOffsetZ(seatStyle))
    elseif ptype == "counter" then
        seed.model = GetHashKey(CounterModel())
    elseif ptype == "virtual_point" or ptype == "virtual_register" then
        seed.model = GetHashKey(VIRTUAL_PLACE_MODEL)
    else
        local model = PLACEABLE_MODELS[ptype]
        if not model then restoreLive(); return ShowNotification(_L("place_unknown_station")) end
        seed.model = GetHashKey(model)
        if WALL_MOUNTED[ptype] then seed.wallOffset = WallMountDepth(model) end
        if ptype == "stovetop" and SpawnPreviewOvenDoors then
            seed.onSpawn   = SpawnPreviewOvenDoors
            seed.onDespawn = DespawnPreviewOvenDoors
        end
    end

    -- A seat edit that doesn't touch the seat POINT skips the gizmo entirely and
    -- keeps the stored transform — editing the style or the tray patch shouldn't
    -- make you re-place the diner.
    local result
    if parts and not parts.point then
        result = { position = vector3(prop.x + 0.0, prop.y + 0.0, prop.z + 0.0),
                   rotation = vector3(0.0, 0.0, (prop.heading or 0.0) + 0.0) }
    else
        result = StartGizmoEditor(seed)
    end
    if not result or not result.position then restoreLive(); return end -- cancelled: put it back
    local heading = (result.rotation and result.rotation.z) or 0.0
    -- Re-place the stand-up point with the seat. Its ghost starts on the seat's
    -- CURRENT exit if it has one, so an edit that only nudged the seat can be
    -- confirmed straight through without re-aiming it.
    local seatExit, seatTray
    if ptype == "seat" then
        local cur = prop.metadata and prop.metadata.exit
        if parts.exit then
            seatExit = PickSeatExit(
                cur and vector3(cur.x + 0.0, cur.y + 0.0, cur.z + 0.0)
                     or SeatExitSeed(result.position.x, result.position.y, result.position.z, heading),
                (cur and cur.heading) or heading)
        else
            seatExit = cur -- not part of this edit: re-submit it unchanged
        end
        local curT = prop.metadata and prop.metadata.tray
        if parts.tray then
            seatTray = PickSeatTray(
                curT and vector3(curT.x + 0.0, curT.y + 0.0, curT.z + 0.0)
                      or SeatTraySeed(result.position.x, result.position.y, result.position.z, heading),
                (curT and curT.heading) or heading)
        else
            seatTray = curT
        end
    end
    local res = lib.callback.await("pickle_restaurants:placement:updateProp", false, {
        id = propId,
        style = seatStyle, -- nil for everything that isn't a seat; ignored server-side
        exit  = seatExit,
        tray  = seatTray,
        x = result.position.x, y = result.position.y, z = result.position.z,
        heading = heading,
    })
    if res and res.ok then
        ShowNotification(_L("place_prop_moved"))
        -- leave the old (hidden) entity — the re-sync deletes + respawns it at the new spot
    else
        restoreLive() -- save failed: unhide the original so it isn't lost
        ShowNotification((res and res.error) or _L("place_station_fail"))
    end
end

-- ─── supplier depots (modules/supply) ────────────────────────────────────────
-- Placed the way a SEAT is: one button in the panel, the questions asked in-game, then
-- the gizmo. Nothing is written until every pass is answered, so a cancel leaves no
-- half-made depot behind in the list.
--
-- A bay is TWO points, so it is two passes: the PACKAGE point (where the pallet of
-- boxes stands, previewed with the box prop itself so the pile lands where it looked
-- like it would) and the TRAILER point (previewed with the real trailer, so an admin
-- can see it fits). Neither has a fallback, unlike a seat's optional extras: a bay
-- without both is not a bay.
--
-- `depotId` nil = this is a NEW depot, so it asks for a name first and the save creates
-- the depot and its first bay together.
--
-- Both previews are LIFTED by `coordsOffset`, which the gizmo adds back out of
-- `result.position` (the seat pattern): the saved point is the GROUND, but the gizmo
-- seats a model by its ORIGIN, and a vehicle's origin is mid-chassis. Without the lift
-- the trailer preview is buried to its axles, and an admin lines the bay up against a
-- picture the real spawn will never match.
-- ─── the trailer's LOADING SPOT ──────────────────────────────────────────────
-- The third pass of a bay, and the reason it exists: the trailer point is the vehicle's
-- ORIGIN, roughly its centre, so anything derived from it (the target zone, the map
-- marker) landed halfway down a 12m box. Measuring the model's rear face was a guess
-- that only held for one trailer. So the admin PLACES the spot instead, and what they
-- see is what the loader gets.
--
-- The camera sits to the SIDE, never in front: from the front a trailer is a flat wall
-- and the marker's position along its length is exactly the thing you cannot judge. From
-- the side the whole rig is in frame and the beam reads against it at a glance.
local LOADPICK = {
    side_dist = 17.0,   -- how far out to the side the camera sits (m)
    side_up   = 5.0,    -- and how high
    look_up   = 1.2,    -- height on the trailer the camera aims at
    step      = 0.25,   -- metres per scroll notch (x4 with SHIFT)
    range     = 14.0,   -- how far fore/aft of the trailer point the spot may go
    beam      = 30.0,   -- height of the sky beam (m)
}

-- Returns { x, y, z, heading } or nil if cancelled. `heading` is the TRAILER's, so the
-- stored spot carries the facing of the thing it belongs to.
function PickTrailerLoadPoint(t, trailerModel)
    local hash = GetHashKey(trailerModel or "trailers")
    if not IsModelInCdimage(hash) then return nil end
    RequestModel(hash)
    local t0 = GetGameTimer()
    while not HasModelLoaded(hash) and GetGameTimer() - t0 < 10000 do Wait(0) end
    if not HasModelLoaded(hash) then return nil end

    local rad   = math.rad(t.heading or 0.0)
    local fwd   = vector3(-math.sin(rad), math.cos(rad), 0.0)
    local right = vector3(math.cos(rad), math.sin(rad), 0.0)
    local centre = vector3(t.x + 0.0, t.y + 0.0, t.z + 0.0)

    -- The preview trailer, exactly where the real one will park.
    local prop = CreateObject(hash, centre.x, centre.y, centre.z, false, false, false)
    SetEntityHeading(prop, t.heading or 0.0)
    FreezeEntityPosition(prop, true)
    SetEntityCollision(prop, false, false)
    SetModelAsNoLongerNeeded(hash)

    -- Start the marker at the REAR, which is the answer nine times out of ten: the
    -- scroll is then a nudge rather than a hunt.
    local mn = GetModelDimensions(hash)
    local offset = -math.abs(mn.y or 6.0) - 1.4
    if offset < -LOADPICK.range then offset = -LOADPICK.range end

    -- SIDE-ON, and on the side the placer is already standing: swinging the camera
    -- through the trailer to the far side would flip left and right under them.
    local me = GetEntityCoords(PlayerPedId())
    local toMe = me - centre
    local side = ((toMe.x * right.x + toMe.y * right.y) >= 0.0) and 1.0 or -1.0
    local camPos = centre + right * (LOADPICK.side_dist * side) + vector3(0.0, 0.0, LOADPICK.side_up)
    local cam = CreateCam("DEFAULT_SCRIPTED_CAMERA", true)
    SetCamCoord(cam, camPos.x, camPos.y, camPos.z)
    PointCamAtCoord(cam, centre.x, centre.y, centre.z + LOADPICK.look_up)
    SetCamActive(cam, true)
    RenderScriptCams(true, true, 500, true, true)
    -- The camera is detached from the ped, so PARK the player and take every gameplay
    -- control: scroll doubles as weapon-cycle and LMB fires. Inputs below are read
    -- through the Disabled variants, exactly like the shell-height pass above.
    local ped = PlayerPedId()
    FreezeEntityPosition(ped, true)

    local result = nil
    while true do
        DisableAllControlActions(0)
        local speed = IsDisabledControlPressed(0, 21) and 4.0 or 1.0
        if IsDisabledControlJustPressed(0, 15) then
            offset = math.min(LOADPICK.range, offset + LOADPICK.step * speed)
        elseif IsDisabledControlJustPressed(0, 14) then
            offset = math.max(-LOADPICK.range, offset - LOADPICK.step * speed)
        end

        local p = centre + fwd * offset
        -- A BEAM TO THE SKY, not a disc on the floor: the camera is side-on and a
        -- ground marker foreshortens to a sliver from there. A tall thin cylinder reads
        -- as a position against the trailer from any angle.
        DrawMarker(1, p.x, p.y, p.z - 0.9, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0,
                   0.35, 0.35, LOADPICK.beam, 90, 200, 255, 90, false, false, 2, false, nil, nil, false)
        DrawMarker(25, p.x, p.y, p.z + 0.05, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0,
                   1.2, 1.2, 1.2, 90, 200, 255, 200, false, false, 2, false, nil, nil, false)

        ShowInteractText(
            '[SCROLL]     - ' .. _L("place_supply_load_scroll") .. '  \n' ..
            '[E]     - ' .. _L("objects_save") .. '  \n' ..
            '[ESC / BACKSPACE]     - ' .. _L("objects_cancel")
        )

        -- Pause suppression + the exit guard, same as the gizmo loop: this loop is what
        -- keeps ESC off the frontend, and it ends on the press, so the rest of that
        -- press would open the pause menu behind us.
        ForcePauseMenuClosed()
        if IsDisabledControlJustPressed(0, 202)
            or IsDisabledControlJustReleased(0, 199)
            or IsDisabledControlJustReleased(0, 200)
            or IsDisabledControlJustReleased(0, 322) then
            if GuardPauseKeys then GuardPauseKeys() end
            break
        end
        if IsDisabledControlJustPressed(0, 51) then
            result = { x = p.x, y = p.y, z = p.z, heading = t.heading or 0.0 }
            break
        end
        Wait(0)
    end

    FreezeEntityPosition(ped, false)
    RenderScriptCams(false, true, 500, true, true)
    -- Let the ease-back finish before the handle dies, or the last frames cut hard.
    CreateThread(function()
        Wait(550)
        if cam then DestroyCam(cam, false) end
    end)
    if DoesEntityExist(prop) then DeleteEntity(prop) end
    return result
end

-- The counter is an INVISIBLE anchor (only an interaction is created there), so it
-- previews with VIRTUAL_PLACE_MODEL like a virtual point, never a till.

-- Move an existing depot's shop counter on its own, without re-placing its bays.
function StartSupplyShopPlacement(depotId)
    Wait(250)
    ShowNotification(_L("place_supply_shop_hint"))
    local sh = StartGizmoEditor({
        model        = GetHashKey(VIRTUAL_PLACE_MODEL),
        enableCancel = true,
        deleteEntity = true,
    })
    if not sh or not sh.position then return ShowNotification(_L("place_supply_cancelled")) end
    local res = lib.callback.await("pickle_restaurants:supply:saveShop", false, {
        depot = depotId,
        shop = { x = sh.position.x, y = sh.position.y, z = sh.position.z,
                 heading = (sh.rotation and sh.rotation.z) or 0.0 },
    })
    if res and res.ok then
        ShowNotification(_L("place_supply_shop_placed"))
    else
        ShowNotification((res and res.error) or _L("place_supply_fail"))
    end
end

local function GroundLift(model)
    local hash = (type(model) == "number") and model or GetHashKey(model)
    if not IsModelInCdimage(hash) then return 0.0 end
    RequestModel(hash)
    local t = GetGameTimer()
    while not HasModelLoaded(hash) and GetGameTimer() - t < 10000 do Wait(0) end
    if not HasModelLoaded(hash) then return 0.0 end
    local mn = GetModelDimensions(hash)
    -- Distance from the origin down to the lowest point of the model. Never negative:
    -- a model already authored origin-at-base needs no lift at all.
    return math.max(0.0, -(mn.z or 0.0))
end

function StartSupplyZonePlacement(depotId, zoneId, boxModel, trailerModel)
    Wait(250)
    local label
    if not depotId then
        local input = lib.inputDialog(_L("place_supply_depot_title"), {
            { type = "input", label = _L("place_supply_depot_label"),
              description = _L("place_supply_depot_hint"), required = true, max = 40 },
        })
        label = input and input[1]
        if not label or label == "" then return end
    end

    -- A NEW depot places its SHOP COUNTER first: with runs on that is where every
    -- order is placed, so a depot without one is a warehouse nobody can buy from.
    local shop
    if not depotId then
        Wait(250)
        ShowNotification(_L("place_supply_shop_hint"))
        local sh = StartGizmoEditor({
            model        = GetHashKey(VIRTUAL_PLACE_MODEL),
            enableCancel = true,
            deleteEntity = true,
        })
        if not sh or not sh.position then return ShowNotification(_L("place_supply_cancelled")) end
        shop = { x = sh.position.x, y = sh.position.y, z = sh.position.z,
                 heading = (sh.rotation and sh.rotation.z) or 0.0 }
    end

    Wait(250)
    ShowNotification(_L("place_supply_package_hint"))
    local boxHash = GetHashKey(boxModel or "hei_prop_heist_box")
    local pkg = StartGizmoEditor({
        model        = boxHash,
        coordsOffset = vector3(0.0, 0.0, GroundLift(boxHash)),
        enableCancel = true,
        deleteEntity = true,
    })
    if not pkg or not pkg.position then return ShowNotification(_L("place_supply_cancelled")) end

    Wait(250)
    ShowNotification(_L("place_supply_trailer_hint"))
    trailerModel = trailerModel or "trailers"
    local trailerHash = GetHashKey(trailerModel)
    local trl = StartGizmoEditor({
        model        = trailerHash,
        coordsOffset = vector3(0.0, 0.0, GroundLift(trailerHash)),
        enableCancel = true,
        deleteEntity = true,
    })
    if not trl or not trl.position then return ShowNotification(_L("place_supply_cancelled")) end

    -- The LOADING SPOT, placed against the trailer that was just parked. Cancelling this
    -- pass abandons the bay like the other two: a bay whose loading spot fell back to the
    -- trailer's centre is the exact bug this pass exists to remove.
    local trailerPoint = { x = trl.position.x, y = trl.position.y, z = trl.position.z,
                           heading = (trl.rotation and trl.rotation.z) or 0.0 }
    Wait(250)
    ShowNotification(_L("place_supply_load_hint"))
    local load = PickTrailerLoadPoint(trailerPoint, trailerModel)
    if not load then return ShowNotification(_L("place_supply_cancelled")) end

    local res = lib.callback.await("pickle_restaurants:supply:saveZone", false, {
        depot = depotId, zone = zoneId, label = label, shop = shop, load = load,
        package = { x = pkg.position.x, y = pkg.position.y, z = pkg.position.z,
                    heading = (pkg.rotation and pkg.rotation.z) or 0.0 },
        trailer = trailerPoint,
    })
    if res and res.ok then
        ShowNotification(_L("place_supply_placed"))
    else
        ShowNotification((res and res.error) or _L("place_supply_fail"))
    end
end
