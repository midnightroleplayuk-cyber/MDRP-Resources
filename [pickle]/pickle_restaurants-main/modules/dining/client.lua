-- =============================================
--  modules/dining | client.lua
--  EAT-IN. A meal is the sit-down half of the takeaway bag: it can only be eaten
--  while SEATED at one of the restaurant's placed seat anchors, and using it lays
--  the real tray out on the table in front of you as an INTERACTIVE VIEW — the same
--  shape as the kiosk / register: a scripted camera frames it, the NUI takes the
--  cursor, and you click the food you want. The customer never leaves the seat: the
--  ped keeps its sit loop the whole time (nothing here touches its tasks).
--
--  The arrangement is rendered by the KITCHEN's own machinery (SpawnMealRender in
--  modules/cooking/client.lua), so a meal on a diner's table is pixel-identical to
--  the one the cook built — same props, same offsets, same stacking corrections.
--
--  Eating a pile removes exactly the metadata layers it was made of; when the last
--  one goes the meal item is gone from the inventory and the view closes itself.
-- =============================================

-- Where the meal lands and how it's framed. TUNE IN-GAME.
local DINE = {
    reach      = 0.62,  -- how far in front of the seated ped the tray is set down
    probe_up   = 0.75,  -- start the surface probe this far above the seat
    probe_down = 1.30,  -- and cast this far down looking for the table top
    fallback_z = 0.70,  -- table height above the seat anchor when no surface is found
    cam_back   = 0.55,  -- camera: metres behind the tray (toward the diner)
    cam_up     = 0.62,  -- camera: metres above it
    cam_fov    = 42.0,
    fade_ms    = 700,   -- camera ease in/out (deliberately unhurried: this plays
                        -- on every bite, and a quick cut reads as a glitch)
    hover_r    = 0.075, -- MINIMUM normalized-screen radius that counts as hovering a
                        -- pile (a bigger pile picks by its own projected size)
    hover_pad  = 0.012, -- slack added to a pile's projected radius
}

local render = nil   -- the live SpawnMealRender handle
local vessel = nil   -- { item, slot } of the meal being eaten
local labels = {}    -- [pileIndex] = { label, image, drink }
local cam    = nil
local hovered = nil
local open   = false
-- True for the length of a mouthful. The hover loop keeps running while the view is
-- open, so without this the cursor would carry on picking out (and outlining) food
-- mid-bite, leaving something highlighted under a camera that has flipped away and
-- letting a second click queue up against a tray that's already being changed.
local busy   = false
-- CLICK TO LOCK IN. The tooltip's buttons sit ABOVE the pile they belong to, so
-- moving the cursor onto one takes it out of that pile's hover radius — and any
-- scheme that keeps a HOVER alive across that gap (a grace period, the card
-- reporting its own pointer-enter) is guessing at intent: the cursor passes over
-- other food on the way, and whichever guess loses picks the wrong serving.
-- So selection is explicit. Hovering only NAMES a pile; clicking it locks the
-- selection, and only then does the tooltip offer the eat/drink buttons. While a
-- pile is locked the cursor is free to go anywhere — hover stops re-targeting
-- entirely. Clicking another pile moves the lock; clicking empty space drops it.
local locked = nil
-- What the cursor is actually over this frame, whether or not anything is locked —
-- the click reads this to decide what to lock onto.
local rawHover = nil
-- Where the current arrangement was laid out. Kept so a bite that changed nothing
-- on the table can re-frame the camera without re-running the whole layout.
local laidAt = nil

local function stopCam()
    if not cam then return end
    RenderScriptCams(false, true, DINE.fade_ms, true, true)
    DestroyCam(cam, false)
    cam = nil
end

-- Frame the tray from just over the diner's shoulder: close enough to read the
-- food, angled down like someone looking at their own plate.
local function startCam(x, y, z, yaw)
    local hr = math.rad(yaw)
    cam = CreateCamWithParams("DEFAULT_SCRIPTED_CAMERA",
        x - math.sin(hr) * -DINE.cam_back, y + math.cos(hr) * -DINE.cam_back, z + DINE.cam_up,
        0.0, 0.0, 0.0, DINE.cam_fov, false, 0)
    PointCamAtCoord(cam, x, y, z + 0.05)
    SetCamActive(cam, true)
    RenderScriptCams(true, true, DINE.fade_ms, true, true)
end

-- Where this seat's meal goes. An admin-placed tray point (the third seat gizmo)
-- wins outright: a probe can only find whatever geometry happens to be under the
-- diner's reach, which is right for a plain table and wrong for a booth's fixed
-- table, a bar top, or a bench with no table at all. Falls back to the probe below
-- for every seat placed without one.
local function placedTrayPoint()
    local seat = CurrentSeat and CurrentSeat()
    local t = seat and seat.metadata and seat.metadata.tray
    if not (t and t.x and t.y and t.z) then return nil end
    return t.x + 0.0, t.y + 0.0, t.z + 0.0, (t.heading or 0.0) + 0.0
end

-- The surface in front of a seated diner: probe straight down from above the point
-- they'd reach to. A table/counter hit gives its exact top; with nothing under the
-- cursor (an outdoor bench) the meal rests at a sensible table height instead.
local function tablePoint(ped)
    local p = GetOffsetFromEntityInWorldCoords(ped, 0.0, DINE.reach, DINE.probe_up)
    -- SYNCHRONOUS probe: an async shape test only has a result a frame later, and
    -- the meal is laid out immediately on this one.
    local ray = StartExpensiveSynchronousShapeTestLosProbe(
        p.x, p.y, p.z, p.x, p.y, p.z - DINE.probe_down,
        1 | 16, ped, 7) -- world + objects, ignoring the diner
    local _, hit, pos = GetShapeTestResult(ray)
    if hit == 1 and pos then return pos.x, pos.y, pos.z end
    local base = GetEntityCoords(ped)
    return p.x, p.y, base.z + DINE.fallback_z
end

-- Is the eat-in view up, and is a mouthful in flight? Read by modules/seating: ESC
-- means "put the meal away" while the view is open and "stand up" once it isn't, and
-- it means NEITHER mid-bite.
function IsMealViewOpen() return open end
function IsMealBusy() return busy end

function CloseMealView()
    if not open then return end
    open = false
    hovered = nil
    locked, rawHover = nil, nil
    if render then OutlineMealPile(render, nil); DeleteMealRender(render); render = nil end
    stopCam()
    labels = {}
    vessel = nil
    CloseNUI()
end

-- ESC/Backspace leaves the meal on the table (it goes back in the inventory
-- intact). Handled by the shared per-frame reader in modules/interactive, which
-- also keeps the key from reaching the pause menu. Registered a frame late: the
-- module glob loads `dining` before `interactive`.
-- A MOUTHFUL IS NOT CANCELLABLE. The server has already committed the bite and the
-- ped is animating it; tearing the view down under it would put the vessel away with
-- the food gone and leave a diner eating thin air in the middle of the room. The
-- press is simply ignored — it's a moment long, and the view is handed straight back.
CreateThread(function()
    Wait(0)
    SetEscapeHandler("dining", function()
        if busy then return end
        CloseMealView()
    end)
end)

-- Eat the hovered pile: the server drops exactly its layers and tells us what it
-- was, the ped eats it (the sit pose resumes afterwards), and the view either
-- re-renders what's left or closes on the last mouthful.
-- `whole` finishes the serving instead of taking a single bite/sip.
local function eatPile(idx, whole)
    if not (open and render and vessel) or busy then return end
    local indices = MealRenderPileIndices(render, idx)
    if not indices or #indices == 0 then return end
    local pile = labels[idx] or {}
    -- Drop the selection for the whole mouthful: nothing outlined, no tooltip, and
    -- the hover loop parked (it can't target while `busy`). What you're eating has
    -- left the table — there is nothing correct for the cursor to be pointing at.
    -- The LOCK goes with it, not just the outline: a lock survives the cursor
    -- leaving the food, so leaving it set means the card and the outline snap
    -- straight back onto a pile that is currently in the diner's hand the moment
    -- the loop unparks — a visible hitch across the camera hand-off. The clear must
    -- happen BEFORE the eat callback awaits, since that await is the whole
    -- transition. Re-locking is the player's to do when the view comes back.
    busy = true
    hovered = nil
    locked, rawHover = nil, nil
    OutlineMealPile(render, nil)
    SendNUIMessage({ action = "diningHover", index = nil })
    local res = lib.callback.await("pickle_restaurants:consume:eat", false,
        { item = vessel.item, slot = vessel.slot, indices = indices, whole = whole or nil })
    if not (res and res.ok) then
        busy = false
        if res and res.error then ShowNotification(res.error) end
        return
    end
    -- Hand the view back to the GAMEPLAY camera for the mouthful. The tray camera
    -- is framed down at the table, so eating under it is a shot of food with the
    -- diner out of frame — the one moment you actually want to see yourself. The
    -- ease is the same fade the view opened with, so it reads as looking up from
    -- your plate rather than a cut. RefreshMealView re-frames afterwards (it only
    -- starts a camera when there isn't one, and stopCam cleared it).
    stopCam()
    -- The serving is IN THE DINER'S HAND for the length of the clip — the branded cup,
    -- the burger, the box — so the copy of it standing on the tray comes off the table
    -- for exactly that long, or the same drink is visibly in two places at once.
    -- Hidden, never deleted: the props stay laid out (and keep their pooled box-quad
    -- textures), so putting a part-eaten serving back down can't flash.
    if render then SetMealPileVisible(render, idx, false) end
    ConsumeAnim(res.drink, res.label or pile.label, res.anim, res.props)
    local name = res.label or pile.label
    local remaining = res.bites and res.bites.left or 0
    if res.play then
        ShowNotification(_L("consume_played", name))
    elseif remaining > 0 then
        ShowNotification(_L(res.drink and "consume_sipped_left" or "consume_bit_left", name, remaining))
    else
        ShowNotification(_L(res.drink and "consume_drank" or "consume_ate", name))
    end
    if res.emptied or #(res.contents or {}) == 0 then
        busy = false
        return CloseMealView()
    end
    if res.finished then
        -- a serving actually left the table: indices shift as layers are removed,
        -- so the arrangement is rebuilt from the server's fresh view of the slot
        RefreshMealView()
    else
        -- MID-SERVING: nothing left the table, so nothing is re-laid. Rebuilding
        -- here tore down every prop and respawned it — and a takeout box's picture
        -- is a pooled DUI texture, so dropping the last reference to it freed the
        -- texture and re-created it: the flash. Only the count changed, so only the
        -- count is updated, and the camera is re-framed on the layout still standing.
        -- what's left of it goes back on the tray, in the same place, untouched
        if render then SetMealPileVisible(render, idx, true) end
        if labels[idx] then labels[idx].bitesLeft = res.bites and res.bites.left or nil end
        if not cam and laidAt then startCam(laidAt.x, laidAt.y, laidAt.z, laidAt.yaw) end
    end
    busy = false -- the cursor may target again
end

-- (Re)build the laid-out meal from the slot's CURRENT metadata.
function RefreshMealView()
    if not (open and vessel) then return end
    -- The arrangement is about to be rebuilt from scratch, so pile indices stop
    -- meaning what they meant: drop any locked selection rather than let the card
    -- point at whatever food happens to land on that index next.
    locked, rawHover = nil, nil
    local res = lib.callback.await("pickle_restaurants:consume:mealSpecs", false,
        { item = vessel.item, slot = vessel.slot })
    if not (res and res.ok and res.parts and #res.parts > 0) then return CloseMealView() end
    if render then DeleteMealRender(render); render = nil end
    local ped = PlayerPedId()
    local x, y, z, yaw = placedTrayPoint()
    if not x then
        x, y, z = tablePoint(ped)
        yaw = GetEntityHeading(ped)
    end
    -- The render yaw is the DINER'S OWN HEADING, handed straight through. That is the
    -- same convention the prep table uses: props there are laid out at the station's
    -- heading, and a station's heading runs the way the cook faces — so tray-local
    -- (dx, dy) is literally the cook's screen frame (dx = right, dy = away). Handing
    -- the diner's heading through reproduces that frame for them, so a nugget the cook
    -- put at the far left is at the diner's far left too, and every prop presents the
    -- same face it did in the kitchen.
    --
    -- This was briefly turned 180° on the theory that a station faces the cook rather
    -- than with them. It doesn't: that flip put a freshly arranged meal exactly back to
    -- front (top-left nugget serving up bottom-right). The ACTUAL bug behind "the tray
    -- is the opposite way round" was that pile offsets were recorded in world axes — see
    -- TrayOffsetWorld — not the facing.
    --
    -- `yaw` also drives the camera (cam_back steps BACKWARD along it to sit on the
    -- diner's side), which is the other reason it must stay the diner's heading.
    render = SpawnMealRender(res.parts, res.box and "box" or "tray", x, y, z, yaw)
    laidAt = { x = x, y = y, z = z, yaw = yaw }
    -- one label per PILE, taken from the pile's bottom layer (the thing it is)
    labels = {}
    for i, pile in ipairs(render.piles or {}) do
        local first = pile.parts[1]
        for _, spec in ipairs(res.parts) do
            if first and spec.id == first.id then
                -- tipImage/tipCrop, not `image`: a takeout part's `image` is the
                -- picture painted INSIDE the box, which is not what a card shows.
                labels[i] = { label = spec.label, image = spec.tipImage or spec.image,
                              crop = spec.tipCrop, drink = spec.drink, play = spec.play,
                              bitesLeft = spec.bitesLeft }
                break
            end
        end
    end
    if not cam then startCam(x, y, z, yaw) end
end

-- Open the eat-in view. Called from modules/consume once the server has confirmed
-- the player is holding a meal (and this client has confirmed they're seated).
function OpenMealView(v, _contents)
    if open or IsCookingOpen and IsCookingOpen() then return end
    vessel = { item = v.item, slot = v.slot }
    open = true
    -- Re-pick the branding NOW rather than waiting up to a tick for the driver:
    -- packaging is painted for the restaurant you are NEAREST, not the one the meal
    -- came from, so a meal carried across town is eaten out of the local
    -- restaurant's boxes and cups — and it should be right on the first frame the
    -- tray appears, not a second into the shot.
    if RefreshBrands then RefreshBrands() end
    -- Skin the view to the restaurant whose seat this is. Every other
    -- restaurant-scoped panel carries its `theme` in the open payload and App.tsx
    -- applies it; without one, the diner's tooltip sat on the default kit while the
    -- room around it was branded.
    local seat = CurrentSeat and CurrentSeat()
    local rest = seat and Restaurants and Restaurants[seat.restaurant_id]
    OpenNUI("dining", { theme = rest and rest.theme or nil })
    RefreshMealView()
    if not open then return end -- RefreshMealView bailed (nothing readable in the slot)

    -- hover loop: project each pile, pick the one nearest the cursor, and feed the
    -- NUI its label/image for the tooltip (the same hover language the kitchen uses)
    CreateThread(function()
        while open do
            -- Mid-mouthful the cursor targets NOTHING: the food is in the diner's
            -- hand, not on the table, and the camera is off the tray entirely.
            -- Clearing here (rather than only at the start of the bite) also stops a
            -- stale outline reappearing on whatever the cursor happens to sit over.
            if busy then
                if hovered then
                    hovered = nil
                    OutlineMealPile(render, nil)
                    SendNUIMessage({ action = "diningHover", index = nil })
                end
                Wait(50)
                goto continue
            end
            -- a lock that outlived its pile (the arrangement was rebuilt) is dropped
            if locked and not (render and render.piles and render.piles[locked]) then locked = nil end
            local cx, cy = GetNuiCursorPosition()
            local sw, sh = GetActiveScreenResolution()
            local cnx = (sw > 0) and (cx / sw) or 0.0
            local cny = (sh > 0) and (cy / sh) or 0.0
            local near, nearD, tipX, tipY
            local tips = {} -- [pileIndex] = { x, y } tooltip anchor, projected this frame
            for i in ipairs((render and render.piles) or {}) do
                -- Pick by the pile's CENTRE and its own projected size, not by its
                -- top: a capped drink is mostly cup under a thin lid, and hovering
                -- from the top of the stack put the target on the lid with the cup
                -- reading as pass-through. The TOOLTIP still hangs off the top
                -- anchor, so the card never covers the food it describes.
                local px, py, pz = MealRenderPileAnchor(render, i)
                local z0, hgt, rad = MealRenderPileSpan(render, i)
                if px and z0 then
                    local cz = z0 + hgt * 0.5
                    local on, sx, sy = GetScreenCoordFromWorldCoord(px, py, cz)
                    if on then
                        -- project one "radius" above the centre to get a screen radius
                        local R = DINE.hover_r
                        local on2, sx2, sy2 = GetScreenCoordFromWorldCoord(px, py, cz + math.max(rad, hgt * 0.5))
                        if on2 then
                            local rx, ry = sx2 - sx, sy2 - sy
                            R = math.max(math.sqrt(rx * rx + ry * ry) + DINE.hover_pad, DINE.hover_r)
                        end
                        -- tooltip anchor: the pile's TOP (fall back to the centre if
                        -- the top happens to project off screen). Recorded for EVERY
                        -- pile, so a locked card keeps tracking its own food while the
                        -- cursor is somewhere else entirely.
                        local onT, tx, ty = GetScreenCoordFromWorldCoord(px, py, pz)
                        tips[i] = { x = (onT and tx or sx), y = (onT and ty or sy) }
                        local dx, dy = sx - cnx, sy - cny
                        local d2 = dx * dx + dy * dy
                        if d2 <= R * R and (not nearD or d2 < nearD) then near, nearD = i, d2 end
                    end
                end
            end
            -- What the cursor is over is only a candidate; the LOCK decides what the
            -- card describes (and it never moves on its own).
            rawHover = near
            local shown = locked or near
            local tip = shown and tips[shown] or nil
            tipX, tipY = tip and tip.x or 0.5, tip and tip.y or 0.5
            if shown ~= hovered then
                hovered = shown
                OutlineMealPile(render, shown)
            end
            local l = shown and labels[shown] or nil
            SendNUIMessage({ action = "diningHover", index = shown,
                             x = tipX, y = tipY, label = l and l.label, image = l and l.image,
                             crop = l and l.crop,
                             -- the buttons only exist on a LOCKED card: a hovered one
                             -- names the food and says to click it
                             locked = (locked ~= nil) or nil,
                             drink = l and l.drink, play = l and l.play,
                             bitesLeft = l and l.bitesLeft })
            Wait(50)
            ::continue::
        end
    end)
end

-- A click on the WORLD (the view's click-through surface, never the card) locks the
-- selection onto whatever the cursor is over — the NUI can't put a DOM target on a
-- world prop, so the hover loop's own pick decides, exactly like the kitchen's
-- worldClick. Clicking a different pile moves the lock straight over; clicking
-- nothing drops it, which is how you change your mind without eating anything.
RegisterNUICallback("dining:click", function(_, cb)
    if not busy then locked = rawHover end
    cb({ ok = true })
end)

-- The locked pile's buttons. They act on the LOCK, never on what the cursor happens
-- to be over — the whole point of locking is that the cursor has left the food to
-- reach these.
RegisterNUICallback("dining:bite", function(_, cb)
    if locked then eatPile(locked, false) end
    cb({ ok = true })
end)

-- "Finish it": the same locked pile, consumed in one go.
RegisterNUICallback("dining:finish", function(_, cb)
    if locked then eatPile(locked, true) end
    cb({ ok = true })
end)

-- The page's own ESC handler lands here. Same rule as the Lua reader above: never
-- mid-mouthful.
RegisterNUICallback("dining:close", function(_, cb)
    if not busy then CloseMealView() end
    cb({ ok = true })
end)

-- ─── what the ROOM sees (modules/mirror) ─────────────────────────────────────
-- A meal laid out on a table is the most public thing a customer does with one, and
-- it was rendered only for the diner: to everyone else they sat at an empty table
-- miming a burger — the same gap the prep table had. So the diner publishes their own
-- render (the kitchen's row builder walks the handle) against the SEAT ANCHOR they
-- are sitting on, and modules/mirror relays it to everyone near that seat, who spawn
-- ordinary local props from it.
--
-- The seat is the key for two reasons: the server already knows who is sitting there
-- (SeatOccupancy — one authority, exactly like a station's claim), and it is a placed
-- prop, so the audience and the walk-into-range hydration are the ones every other
-- world render already uses. A meal eaten off a seat we can't name (no anchor) simply
-- isn't published — there would be nothing to scope it to.
function MealMirrorSnapshot()
    if not (open and render) then return nil end
    local seat = CurrentSeat and CurrentSeat()
    if not (seat and seat.id) then return nil end
    return seat.id, MealMirrorRows and MealMirrorRows(render) or {}
end

-- Standing up (or being pulled out of the seat) puts the meal away.
AddEventHandler("pickle_restaurants:seating:stood", function() CloseMealView() end)

AddEventHandler("onResourceStop", function(res)
    if res ~= GetCurrentResourceName() then return end
    if render then DeleteMealRender(render) end
    stopCam()
end)
