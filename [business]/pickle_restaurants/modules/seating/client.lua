-- =============================================
--  modules/seating | client.lua
--  Player sitting on the invisible seat anchors (prop_type "seat") admins place.
--  A seat spawns NO world prop — the anchor is just a point + heading + STYLE, and
--  the player sits on the restaurant's own furniture there. main/client attaches
--  the "Sit" interaction on a seat prop and calls SitOnSeat here.
--
--  THE RULE: a player sits EXACTLY where the anchor is. Nothing gets a vote.
--
--    * We set the coords ourselves and freeze. A frozen ped is skipped by the
--      collision depenetration pass, which is what used to shove players up out of
--      an MLO chair's mesh — there is nothing to fight because physics never runs.
--    * The pose is a looping clip, played at those coords. The PLACEMENT GHOST
--      plays the same clip at the same point, so what an admin positions is
--      literally what a player gets — that is the whole value of a placed anchor.
--
--  NOT scenarios. `TaskStartScenarioAtPosition` was tried and reverted: it decides
--  for itself where to put the ped (players ended up through the floor), and the
--  natives that report whether a ped is in a scenario are unreliable enough that
--  the repair tick re-tasked it forever — an endless sit-down loop. Both problems
--  are the same problem: handing placement to something that places it elsewhere.
--
--  Styles (posture + height trim) live in Config.SeatStyles (core/shared.lua).
--
--  WHO may sit is not decided here. A seat held by an active reservation admits only
--  its holder and guests, and that is checked by `seating:sit` server-side — this file
--  only reacts to the refusal by offering to ask the holder (see below). The
--  "Reserved" interaction label main/client draws is a hint, never the gate.
-- =============================================

local SIT_CONTROL = 51 -- INPUT_CONTEXT (E) — what SITS you down (the interaction)
-- STANDING UP IS ESC, the same "step out" set modules/interactive treats as leaving a
-- panel (ESC / pause-alternate / backspace). One key for both means the seated player
-- never has to know which of two keys applies: ESC backs out of whatever they're in,
-- innermost first — the meal view, then the seat.
local STAND_KEYS  = { 322, 200, 202, 194 }
-- The pose can read as "not playing" for a frame or two after it starts, so the
-- loop doesn't police it until either it's confirmed playing or this expires.
local SETTLE_MS   = 3000
-- How often the loop may re-assert a pose that has genuinely dropped. Rate-limited
-- on purpose: re-tasking every frame is what turned a repair into a loop.
local REPAIR_MS   = 1000

-- ─── style helpers ───────────────────────────────────────────────────────────

-- The style table for a seat row (defaults for anchors placed before styles, or
-- naming a style a later version dropped — GetSeatStyle never returns nil).
local function styleFor(seat)
    return GetSeatStyle(seat and seat.metadata and seat.metadata.style)
end

-- Exposed for the placement gizmo, which previews a GHOST PED in the seated pose.
-- It MUST use these — ghost and sit sharing one clip and one offset is what makes
-- placement WYSIWYG. Both take an optional style id (nil = default).
function SeatPreviewAnim(styleId)
    local s = GetSeatStyle(styleId)
    return s.anim.dict, s.anim.clip
end

function SeatSitOffsetZ(styleId)
    return GetSeatStyle(styleId).dz or 0.0
end

-- ─── the pose ────────────────────────────────────────────────────────────────

local function loadAnimDict(dict)
    if HasAnimDictLoaded(dict) then return true end
    RequestAnimDict(dict)
    local t = GetGameTimer()
    while not HasAnimDictLoaded(dict) and GetGameTimer() - t < 2000 do Wait(0) end
    return HasAnimDictLoaded(dict)
end

-- flag 1 = looping, holds indefinitely.
local function playSit(ped, style)
    TaskPlayAnim(ped, style.anim.dict, style.anim.clip, 8.0, -8.0, -1, 1, 0.0, false, false, false)
end

local function isPlayingSit(ped, style)
    return IsEntityPlayingAnim(ped, style.anim.dict, style.anim.clip, 3)
end

-- ─── state ───────────────────────────────────────────────────────────────────

local seatedSeat = nil -- the seat prop we're currently sitting on (nil = standing)
-- Something else is deliberately animating the seated ped (a mouthful at the
-- eat-in table). The repair below must not fight it: to the loop, "not playing the
-- sit clip" is indistinguishable from a broken pose, so it would re-task the sit
-- within REPAIR_MS and snap the eat/drink clip away mid-bite — which is what left a
-- diner's branded cup buried in their lap instead of raised to their mouth.
local poseHold = false

function IsSeated() return seatedSeat ~= nil end

-- Put the pose repair on hold (and take it off again) around a clip that is MEANT
-- to replace the sit for a moment. Global: modules/consume's ConsumeAnim brackets
-- every mouthful with it, seated or not.
function HoldSeatPose(on)
    poseHold = on and true or false
end

-- Put the seated ped straight back in its pose. Called the instant a borrowed clip
-- finishes (it ends on ClearPedTasks), so the diner doesn't sit bolt upright for up
-- to REPAIR_MS waiting for the loop to notice.
function ReassertSeatPose()
    local seat = seatedSeat
    if not seat then return end
    local ped, style = PlayerPedId(), styleFor(seat)
    if not HasAnimDictLoaded(style.anim.dict) then return end
    playSit(ped, style)
    FreezeEntityPosition(ped, true)
end

-- The seat row we're sitting on (nil = standing). modules/dining reads its
-- `metadata.tray` to lay the meal out on THIS seat's placed table spot.
function CurrentSeat() return seatedSeat end

local function helpText(msg)
    BeginTextCommandDisplayHelp("STRING")
    AddTextComponentSubstringPlayerName(msg)
    EndTextCommandDisplayHelp(0, false, true, -1)
end

-- ─── standing up ─────────────────────────────────────────────────────────────

function StandUp()
    local seat = seatedSeat
    if not seat then return end
    seatedSeat = nil
    local ped = PlayerPedId()
    FreezeEntityPosition(ped, false)
    SetPedCanRagdoll(ped, true)
    ClearPedTasks(ped) -- blends out of the pose, unlike ...Immediately
    -- Stand up AT THE SEAT'S EXIT POINT if it has one. Standing where you sat puts
    -- a booth or bar diner on top of the table — the anchor is on the furniture, so
    -- the place to leave from has to be its own point. No exit point (an open-floor
    -- chair that doesn't need one) = stand where you are, as before.
    local exit = seat.metadata and seat.metadata.exit
    if exit and exit.x and exit.y and exit.z then
        SetEntityCoords(ped, exit.x + 0.0, exit.y + 0.0, exit.z + 0.0, false, false, false, false)
        SetEntityHeading(ped, (exit.heading or 0.0) + 0.0)
    end
    EnableInteraction = true -- re-arm the interaction engine (sitting disabled it)
    TriggerServerEvent("pickle_restaurants:seating:stand", seat.id)
    -- anything that only makes sense while seated (the eat-in meal view) closes
    TriggerEvent("pickle_restaurants:seating:stood", seat.id)
end

-- ─── asking for a reserved seat ──────────────────────────────────────────────
-- A held anchor rejects everyone but its reservation's holder and guests. Rather than
-- leaving a stranger staring at a chair they can't use, we offer to ASK: the server
-- pages the holder (phone notification + the prompt below), and an accept makes us a
-- guest of that reservation and sits us down.
--
-- Both sides are ox_lib context menus, like the bag's contents menu — the request and
-- the answer are both "pick one of two things", and a context menu is the one dialog
-- this resource already uses for that.

-- The seat we asked for, so an accept can seat us on it without trusting the event's
-- id alone. Cleared on any answer.
local askedSeat = nil

local function offerSeatRequest(seat, why)
    askedSeat = seat
    lib.registerContext({
        id = "pickle_restaurants_seat_reserved",
        title = _L("seat_reserved_title"),
        options = {
            {
                title = _L("seat_ask_to_sit"),
                description = why or _L("seat_reserved"),
                icon = "hand",
                onSelect = function()
                    local res = lib.callback.await("pickle_restaurants:seating:requestSeat", false, { propId = seat.id })
                    if res and res.ok then
                        ShowNotification(_L("seat_request_sent"))
                    else
                        askedSeat = nil
                        ShowNotification((res and res.error) or _L("seat_reserved"))
                    end
                end,
            },
            {
                title = _L("seat_ask_never_mind"),
                icon = "xmark",
                onSelect = function() askedSeat = nil end,
            },
        },
    })
    lib.showContext("pickle_restaurants_seat_reserved")
end

-- HOLDER side: somebody wants a seat at our table. Answering is one event either way;
-- ignoring it is also an answer (the request expires server-side after `ttl`).
RegisterNetEvent("pickle_restaurants:seating:seatRequest", function(d)
    if type(d) ~= "table" or not d.id then return end
    local function answer(accept)
        TriggerServerEvent("pickle_restaurants:seating:answerSeat", { id = d.id, accept = accept })
    end
    lib.registerContext({
        id = "pickle_restaurants_seat_request",
        title = _L("seat_request_title"),
        options = {
            {
                title = _L("seat_request_accept"),
                description = _L("seat_request_body", d.name or "?", d.restaurant or "?"),
                icon = "check",
                onSelect = function() answer(true) end,
            },
            {
                title = _L("seat_request_decline"),
                icon = "xmark",
                onSelect = function() answer(false) end,
            },
        },
    })
    lib.showContext("pickle_restaurants_seat_request")
end)

-- ASKER side: the answer. On an accept we sit ourselves down — the point of asking was
-- to sit, and the seat is checked again by `seating:sit` anyway, so this is a normal sit
-- and not a second grant path. The prop row comes from the client's synced cache
-- (modules/main) so we act on the seat the SERVER named, with the one we asked about as
-- the fallback for a row that hasn't synced.
RegisterNetEvent("pickle_restaurants:seating:seatAnswer", function(d)
    local seat = askedSeat
    askedSeat = nil
    if type(d) ~= "table" or not d.ok then
        return ShowNotification((d and d.error) or _L("seat_request_declined"))
    end
    if GetClientProp and d.propId then seat = GetClientProp(tonumber(d.propId)) or seat end
    ShowNotification(_L("seat_request_accepted"))
    if seat and not IsSeated() then SitOnSeat(seat) end
end)

-- ─── sitting down ────────────────────────────────────────────────────────────

-- Sit on a placed seat anchor. Reserves it server-side first (so two players can't
-- share one anchor), then plants the ped on the anchor and poses it.
function SitOnSeat(seat)
    if not seat then return end
    if seatedSeat then return ShowNotification(_L("seat_already_sitting")) end
    local ped = PlayerPedId()
    if IsPedInAnyVehicle(ped, false) or IsEntityDead(ped) then return end

    local res = lib.callback.await("pickle_restaurants:seating:sit", false, { id = seat.id })
    if not (res and res.ok) then
        -- The seat belongs to somebody's reservation and we're not on it. That's not a
        -- dead end: the holder can be ASKED (see below), so offer it instead of a bare
        -- refusal. `reserved` is the server's flag — the interaction's "Reserved" label
        -- is only ever a hint off the synced map, so this is where we find out.
        if res and res.reserved then return offerSeatRequest(seat, res.error) end
        return ShowNotification((res and res.error) or _L("seat_taken"))
    end

    local style = styleFor(seat)
    local x, y  = seat.x + 0.0, seat.y + 0.0
    local z     = seat.z + (style.dz or 0.0)
    local h     = (seat.heading or 0.0) + 0.0

    seatedSeat = seat
    -- a hold left over from a mouthful that was interrupted by standing up must
    -- never carry into the next sit, or its pose would never be repaired at all
    poseHold = false
    EnableInteraction = false -- no other interactions (incl. re-sitting) while seated

    -- Stream the clip in BEFORE placing the ped: a dict that arrives late would
    -- leave the player frozen in a standing pose until the repair tick noticed.
    -- If a style's clip won't load at all, sit them in the DEFAULT style rather
    -- than freezing them upright — a wrong-looking sit beats a broken one.
    if not loadAnimDict(style.anim.dict) then
        local fb = GetSeatStyle(Config.DefaultSeatStyle)
        if fb.anim.dict ~= style.anim.dict and loadAnimDict(fb.anim.dict) then style = fb end
    end

    ClearPedTasksImmediately(ped)
    SetEntityCoords(ped, x, y, z, false, false, false, false)
    SetEntityHeading(ped, h)
    -- Ragdoll off with the freeze: a shove or a car clipping the furniture would
    -- otherwise break the pose and leave a frozen ped mid-flop.
    SetPedCanRagdoll(ped, false)
    FreezeEntityPosition(ped, true)
    playSit(ped, style)

    CreateThread(function()
        -- swallow the sit keypress so a held E can't do anything else on release
        while IsControlPressed(0, SIT_CONTROL) do Wait(0) end
        local settled, startT, nextRepair = false, GetGameTimer(), 0
        while seatedSeat == seat do
            if not settled and (isPlayingSit(ped, style) or GetGameTimer() - startT > SETTLE_MS) then
                settled = true
            end
            -- The freeze holds the POSITION; these hold the INPUT, so a held key
            -- can't walk the player off the seat the moment they stand.
            DisableControlAction(0, 30, true)  -- INPUT_MOVE_LR
            DisableControlAction(0, 31, true)  -- INPUT_MOVE_UD
            DisableControlAction(0, 21, true)  -- INPUT_SPRINT
            DisableControlAction(0, 22, true)  -- INPUT_JUMP
            DisableControlAction(0, 23, true)  -- INPUT_ENTER (vehicle)
            DisableControlAction(0, 36, true)  -- INPUT_DUCK

            -- WHAT ESC MEANS RIGHT NOW. A panel owns the key first — with the eat-in
            -- meal laid out, ESC puts the meal away and the NEXT press gets you up —
            -- so the prompt names whichever of the two the next press does, and this
            -- loop doesn't read the key at all while a view is up (modules/interactive
            -- is reading it for that view; both acting on one press would stand the
            -- diner up out of the meal they were only closing).
            local inView  = (IsMealViewOpen and IsMealViewOpen()) and true or false
            local mouthful = ((IsConsuming and IsConsuming()) or (IsMealBusy and IsMealBusy()))
                and true or false
            helpText(_L(inView and "seat_meal_prompt" or "seat_stand_prompt"))

            -- NOT MID-MOUTHFUL. Standing up tears the meal view down and puts the
            -- vessel away underneath a bite that the server is already committing —
            -- the food would be gone with nothing to show it, and the ped would be
            -- animating a mouthful in the middle of the room.
            local stand = false
            if NUIView == "none" and not mouthful then
                -- ESC would otherwise reach the frontend as well: disable the pause
                -- controls and read them back with the Disabled* variants, the same
                -- pattern (and the same frontend shove) modules/interactive uses.
                DisableControlAction(0, 199, true) -- INPUT_FRONTEND_PAUSE
                DisableControlAction(0, 200, true) -- INPUT_FRONTEND_PAUSE_ALTERNATE
                DisableControlAction(0, 322, true) -- ESC
                ForcePauseMenuClosed()
                for _, key in ipairs(STAND_KEYS) do
                    if IsDisabledControlJustReleased(0, key) then stand = true break end
                end
            end
            if stand or IsEntityDead(ped) then
                StandUp()
                -- Standing up ends this loop, and with it the disables above — so the
                -- rest of the same keypress would reach the frontend and open the
                -- pause menu on the way out of the chair (modules/interactive).
                if stand and GuardPauseKeys then GuardPauseKeys() end
                break
            end

            -- Something interrupted the pose (damage, another script's task) but
            -- we're still meant to be seated: re-assert it. Only once settled, and
            -- only every REPAIR_MS — re-tasking on every frame is a sit-down loop,
            -- not a repair.
            if settled and not poseHold and GetGameTimer() >= nextRepair and not isPlayingSit(ped, style) then
                nextRepair = GetGameTimer() + REPAIR_MS
                if HasAnimDictLoaded(style.anim.dict) then
                    playSit(ped, style)
                    FreezeEntityPosition(ped, true)
                end
            end
            Wait(0)
        end
    end)
end

-- If the seat we're on is deleted out from under us, stand up cleanly.
RegisterNetEvent("pickle_restaurants:propRemoved", function(propId)
    if seatedSeat and seatedSeat.id == tonumber(propId) then StandUp() end
end)

AddEventHandler("onResourceStop", function(res)
    if res ~= GetCurrentResourceName() then return end
    if seatedSeat then
        -- never leave a player frozen because the resource restarted mid-sit
        local ped = PlayerPedId()
        FreezeEntityPosition(ped, false)
        SetPedCanRagdoll(ped, true)
        ClearPedTasks(ped)
        EnableInteraction = true
        seatedSeat = nil
    end
end)
