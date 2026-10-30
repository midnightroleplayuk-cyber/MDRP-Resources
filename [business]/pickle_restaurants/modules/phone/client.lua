-- ─────────────────────────────────────────────────────────────────────────────
-- modules/phone (client) — companion app host glue + world-side features
--
-- Three jobs:
--   1. Register the "Pickle Eats" custom app with whichever phone the server runs
--      (points its iframe at our built nui/phone.html) and re-register when that
--      phone restarts.
--   2. Relay every phone NUI action (POSTed by the iframe to this resource) to the
--      matching server callback, and PUSH server events back into the iframe via the
--      phone's app-message export (a web iframe can't RegisterNetEvent).
--   3. The world side the web app can't do: the live driver GPS blip + the driver's
--      position ping loop, and kitchen backup alerts. (There used to be a third: the
--      private-booth teleport a reservation put you in. A reservation is an access grant
--      over real seats now — see the reservations note at the bottom.)
--
-- NOTHING here talks to a specific phone resource — that all lives in bridge/phone/*,
-- which defines the PhoneApp table (Register / Send / Notify / Number). A server with
-- no supported phone installed loads no bridge at all, so PhoneApp is nil and every
-- call site below no-ops.
-- ─────────────────────────────────────────────────────────────────────────────

-- Registering the app is the BRIDGE's job, not this module's — the phones disagree
-- about which side it even happens on (lb-phone: client, Quasar: server), so there's
-- nothing phone-agnostic left to do here.

-- Whether live server→app pushes work on the phone in play. Quasar publishes no
-- Lua→iframe emitter, so its bridge may answer false and the app polls instead.
RegisterNUICallback("phone:pushSupported", function(_, cb)
    cb({ supported = not (PhoneApp and PhoneApp.PushSupported) or PhoneApp.PushSupported() })
end)

-- Push a message into the app iframe. Phones forward the WHOLE table into the page as
-- a window `message`, so we flatten `action` into the payload — useNuiEvent matches on
-- `.action` and the React handlers read the sibling fields (d.rid, d.orders …).
-- fwd: retire the current delivery run's threads (the destination marker + the
-- position pings). Defined with the delivery section further down; called from the
-- completeOrder relay above it.
local EndDriveGen

local function ToApp(action, payload)
    if not PhoneApp then return end
    payload = payload or {}
    payload.action = action
    PhoneApp.Send(payload)
end

-- ─── NUI relays ───────────────────────────────────────────────────────────────
-- The iframe's fetchNui("phone:x") POSTs to https://pickle_restaurants/phone:x, so
-- a plain RegisterNUICallback here receives it. Each relay just forwards to the
-- server callback of the same-ish name and resolves the promise with the result.
local function relay(serverCb)
    return function(d, cb)
        cb(lib.callback.await(serverCb, false, d or {}) or {})
    end
end

-- Customer surfaces
RegisterNUICallback("phone:home", function(d, cb)
    d = d or {}
    local c = GetEntityCoords(PlayerPedId())
    d.coords = { x = c.x, y = c.y, z = c.z }   -- for distance sort + delivery address
    cb(lib.callback.await("pickle_restaurants:phone:home", false, d) or {})
end)
RegisterNUICallback("phone:menu",             relay("pickle_restaurants:phone:menu"))
RegisterNUICallback("phone:saveFavorite",     relay("pickle_restaurants:phone:saveFavorite"))
RegisterNUICallback("phone:deleteFavorite",   relay("pickle_restaurants:phone:deleteFavorite"))
RegisterNUICallback("phone:submitReview",     relay("pickle_restaurants:phone:submitReview"))
RegisterNUICallback("phone:reserve",          relay("pickle_restaurants:phone:reserve"))
RegisterNUICallback("phone:reserveAvailability", relay("pickle_restaurants:phone:reserveAvailability"))
RegisterNUICallback("phone:cancelReservation",relay("pickle_restaurants:phone:cancelReservation"))
RegisterNUICallback("phone:myReservations",   relay("pickle_restaurants:phone:myReservations"))
-- A reservation holds real seats, and those seats can be SHARED: the holder lists,
-- grants and revokes guests from the app (server-gated to the holder).
RegisterNUICallback("phone:reservationGuests", relay("pickle_restaurants:phone:reservationGuests"))
RegisterNUICallback("phone:grantGuest",       relay("pickle_restaurants:phone:grantGuest"))
RegisterNUICallback("phone:revokeGuest",      relay("pickle_restaurants:phone:revokeGuest"))
RegisterNUICallback("phone:leaderboard",      relay("pickle_restaurants:phone:leaderboard"))
-- One-shot SEED for the in-app delivery map (last known driver position).
-- The map is otherwise live-events-only, so re-opening a ticket mid-delivery drew
-- nothing until the next broadcast. Server-gated to the order's own customer.
RegisterNUICallback("phone:trackOrder",       relay("pickle_restaurants:phone:trackOrder"))

-- Placing an order: inject live coords (delivery drop / distance).
RegisterNUICallback("phone:placeOrder", function(d, cb)
    d = d or {}
    local c = GetEntityCoords(PlayerPedId())
    d.coords = { x = c.x, y = c.y, z = c.z }
    -- nil on phones that only expose the number server-side (Quasar) — the server
    -- falls back to PhoneAppNumber(src) in that case.
    if PhoneApp then d.phone = PhoneApp.Number() end
    cb(lib.callback.await("pickle_restaurants:phone:placeOrder", false, d) or {})
end)

-- Staff
local ClockedRid = nil
RegisterNUICallback("phone:shiftStatus", relay("pickle_restaurants:phone:shiftStatus"))
RegisterNUICallback("phone:clockIn", function(d, cb)
    local res = lib.callback.await("pickle_restaurants:phone:clockIn", false, d or {})
    if res and res.ok then ClockedRid = tonumber(d.id) end
    cb(res or {})
end)
RegisterNUICallback("phone:clockOut", function(d, cb)
    local res = lib.callback.await("pickle_restaurants:phone:clockOut", false, d or {})
    if res and res.ok then ClockedRid = nil end
    cb(res or {})
end)

-- PUNCH THE CLOCK WITHOUT A PHONE OR A PANEL. Every employee has to be able to start a
-- shift, but the register's own options are gated (the POS wants `sell`, the boss panel
-- wants a management perm) — so a cook with neither could only clock in through the phone
-- app, if their phone even hosts it. This is the register's third option
-- (modules/main/client.lua), open to anyone the server recognises as staff.
--
-- ONE toggle rather than two options, because the interaction's labels are built once
-- when the prop spawns and would go stale the moment someone punched in: read the live
-- status, do the other thing, and say which happened. The server is the authority on
-- whether this player works here at all.
function ToggleShiftClock(rid)
    rid = tonumber(rid); if not rid then return end
    local st = lib.callback.await("pickle_restaurants:phone:shiftStatus", false, { id = rid })
    if not (st and st.ok) then
        return ShowNotification((st and st.error) or _L("phone_not_employed"))
    end
    local ev = st.clockedIn and "pickle_restaurants:phone:clockOut" or "pickle_restaurants:phone:clockIn"
    local res = lib.callback.await(ev, false, { id = rid })
    if not (res and res.ok) then
        return ShowNotification((res and res.error) or _L("phone_not_employed"))
    end
    ClockedRid = st.clockedIn and nil or rid
    ShowNotification(_L(st.clockedIn and "shift_clocked_out" or "shift_clocked_in"))
end
RegisterNUICallback("phone:startDelivery", relay("pickle_restaurants:phone:startDelivery"))
RegisterNUICallback("phone:cancelDelivery", relay("pickle_restaurants:phone:cancelDelivery"))

-- Delivery chat (both sides use the same two callbacks; the server decides which side
-- you are and rejects anyone who is neither).
RegisterNUICallback("phone:chatHistory", relay("pickle_restaurants:phone:chatHistory"))
RegisterNUICallback("phone:chatSend",    relay("pickle_restaurants:phone:chatSend"))

-- Set Waypoint. NOT a plain relay: the server only hands back the coordinates (it
-- can't set a waypoint on our behalf), so this one resolves the callback and then
-- does the client-side work itself.
RegisterNUICallback("phone:setWaypoint", function(data, cb)
    local res = lib.callback.await("pickle_restaurants:phone:deliveryTarget", false, data)
    if not res or not res.ok then cb(res or { ok = false }); return end
    SetNewWaypoint(res.x + 0.0, res.y + 0.0)
    ShowNotification(_L("delivery_waypoint_set", tostring(res.ticket or "?")))
    cb({ ok = true })
end)

-- KDS complete/cancel reuse the existing sales callbacks (server perm-gated).
--
-- Completing is NOT a plain relay for one case: a delivery whose drop point is an
-- admin-placed door hands over in person first — the driver knocks, someone comes
-- out and takes the bag (modules/doorstep). The scene runs BEFORE the server call
-- and a scene that didn't happen (too far from the door, interrupted) leaves the
-- ticket open, so "delivered" can't be tapped from down the street.
-- Serving a ticket: the ONE path, shared by the app's "Delivered" button and the
-- door's own target option (ArmDoorstepTarget, modules/doorstep) — so a delivery served
-- without opening the phone behaves identically to one served from it.
function ServeDelivery(data)
    data = data or {}
    if RunDoorstepHandoff then
        local handed = RunDoorstepHandoff(tonumber(data.id), tonumber(data.orderId))
        -- nil = no door on this order, complete as normal. false = there was one and
        -- the hand-off didn't happen; doorstep already said why.
        if handed == false then return { ok = false } end
    end
    local res = lib.callback.await("pickle_restaurants:sales:completeOrder", false, data) or {}
    -- The run is over: retire this delivery's threads (the destination marker, the
    -- position pings and the door's target option). Completing is the ONE ending the
    -- server doesn't announce back to the driver — cancelling gets `phone:endDriving`,
    -- and accepting another run supersedes by generation — so without this the arrow
    -- would hang over a doorstep that has already been served.
    if res.ok then EndDriveGen() end
    return res
end

RegisterNUICallback("phone:completeOrder", function(data, cb)
    cb(ServeDelivery(data))
end)
RegisterNUICallback("phone:cancelOrder",   relay("pickle_restaurants:sales:cancelOrder"))
-- KDS ticket seed (public, display-safe + fulfil flags) — live updates ride the
-- sales:orders push forwarded to the app above.
-- NOT a plain relay: the seed has to carry `me` too, exactly like the broadcast below.
-- Without it a delivery already claimed by US reads as someone else's ("With <name>",
-- no Cancel) until the next SyncOrders push happens to arrive.
RegisterNUICallback("phone:tickets", function(data, cb)
    local res = lib.callback.await("pickle_restaurants:register:getPublic", false, data or {})
    res = res or {}
    res.me = GetPlayerServerId(PlayerId())
    cb(res)
end)

-- Owner tools reuse the existing management callbacks (all HasPerm-gated server-side).
RegisterNUICallback("phone:mgmtData",       relay("pickle_restaurants:management:getData"))
RegisterNUICallback("phone:saveMenuItem",   relay("pickle_restaurants:management:saveMenuItem"))
RegisterNUICallback("phone:deleteMenuItem", relay("pickle_restaurants:management:deleteMenuItem"))
-- Employment is a JOB now: hire takes { id, serverId, grade } (the framework's job +
-- grade is what's written — there is no employee row any more), fire/setGrade act on an
-- identifier at a grade, and per-EMPLOYEE commission is gone — commission is a property
-- of the RANK, edited with the rest of a rank through `management:setRank`. So there is
-- no `phone:setCommission` relay to keep: the callback behind it no longer exists.
RegisterNUICallback("phone:hire",           relay("pickle_restaurants:management:hire"))
RegisterNUICallback("phone:fire",           relay("pickle_restaurants:management:fire"))
RegisterNUICallback("phone:setGrade",       relay("pickle_restaurants:management:setGrade"))
RegisterNUICallback("phone:setRank",        relay("pickle_restaurants:management:setRank"))
-- Paying the staff: the tip pool goes out to whoever is on the roster, payroll pays
-- each rank's salary out of the balance. Both are perm-gated (`manage_payroll`).
RegisterNUICallback("phone:payTips",        relay("pickle_restaurants:management:payTips"))
RegisterNUICallback("phone:runPayroll",     relay("pickle_restaurants:management:runPayroll"))
RegisterNUICallback("phone:buyStock",       relay("pickle_restaurants:management:buyStock"))
-- Moving stock between the larder and your own pockets. Not a purchase, so these stay
-- available on the phone with supply runs on (where buying moves to a depot counter).
RegisterNUICallback("phone:depositStock",   relay("pickle_restaurants:management:depositStock"))
RegisterNUICallback("phone:withdrawStock",  relay("pickle_restaurants:management:withdrawStock"))
RegisterNUICallback("phone:deposit",        relay("pickle_restaurants:management:deposit"))
RegisterNUICallback("phone:withdraw",       relay("pickle_restaurants:management:withdraw"))
RegisterNUICallback("phone:analytics",      relay("pickle_restaurants:phone:analytics"))
RegisterNUICallback("phone:promos",         relay("pickle_restaurants:phone:promos"))
RegisterNUICallback("phone:savePromo",      relay("pickle_restaurants:phone:savePromo"))
RegisterNUICallback("phone:deletePromo",    relay("pickle_restaurants:phone:deletePromo"))

-- ─── live order feed → the app iframe ────────────────────────────────────────
-- The server broadcasts open tickets to everyone via sales:orders. Forward each to
-- the app; the React side filters by the rid(s) it currently cares about (a KDS
-- board, or a customer tracking their own ticket).
RegisterNetEvent("pickle_restaurants:sales:orders", function(rid, orders)
    -- `me` lets the Work screen tell OUR claimed delivery from someone else's: the
    -- ticket list is broadcast to every client, so the claim carries a server id and
    -- the app compares it against this. (The server re-checks by identifier anyway.)
    ToApp("orders", { rid = rid, orders = orders, me = GetPlayerServerId(PlayerId()) })

    -- Kitchen backup alert: while clocked in, warn once when the queue crosses the
    -- threshold (rising edge only, so it doesn't nag every 750ms refresh tick).
    if ClockedRid == rid then
        local n = #orders
        if n >= BACKUP_THRESHOLD and (LastQueue or 0) < BACKUP_THRESHOLD then
            ShowNotification(_L("phone_queue_backup", n))
            ToApp("backup", { rid = rid, count = n })
        end
        LastQueue = n
    end
end)

-- ─── delivery chat push ──────────────────────────────────────────────────────
-- One message, to both parties. The app appends it to whatever thread is open (and
-- flags it unread if that ticket's chat isn't on screen).
RegisterNetEvent("pickle_restaurants:phone:chat", function(d)
    ToApp("chat", d)
end)

-- ─── theme push ──────────────────────────────────────────────────────────────
-- The admin panel changed the ONE global phone theme — forward the new seed to the
-- app so an open phone reskins live (otherwise it lands on the next home refresh).
-- No pushTheme handler: the app skin is no longer broadcast. It rides the phone's own
-- bootstrap payload (`theme` in getData), so a phone reads the current skin when it opens
-- and an auto-saving admin panel doesn't send one message per player per keystroke.
-- See modules/admin/server.lua's setPhoneTheme.

-- ─── promotions push ─────────────────────────────────────────────────────────
RegisterNetEvent("pickle_restaurants:phone:pushPromo", function(p)
    ToApp("promo", p)
    if PhoneApp then PhoneApp.Notify(p.title, p.content) end
end)

-- ─────────────────────────────────────────────────────────────────────────────
-- DELIVERY — driver ping loop + customer GPS blip
-- ─────────────────────────────────────────────────────────────────────────────
local DRIVER_PING_MS = 3000

-- How far the driver must get from the drop-off before the 12m ARRIVAL check (which
-- ends the telemetry loop) is allowed to trigger. Comfortably above 12m so leaving
-- and returning can't chatter the two thresholds. TUNE IN-GAME.
local ARRIVE_ARM = 40.0

-- One generation per accepted delivery: a newly accepted run supersedes the previous
-- thread instead of leaving both pinging (the old loop just falls out on its next tick).
local DriveGen = 0
-- Every ending goes through here, so the door's hand-over option is retired in exactly
-- one place — a target left on a stranger's doorstep after the run is over would offer
-- an order that no longer exists.
EndDriveGen = function()
    DriveGen = DriveGen + 1
    if DisarmDoorstepTarget then DisarmDoorstepTarget() end
    -- …and take the MAP down with it. Accepting a run sets a waypoint on the drop
    -- point (beginDriving / phone:setWaypoint), and only the CANCEL path used to
    -- clear it — so a driver who actually delivered was left with the marker still
    -- on their minimap, routing to a doorstep that was already served. Every ending
    -- comes through here, which is the whole reason this function exists; a new run
    -- sets its own waypoint afterwards, so clearing here can never eat one.
    ClearGpsMultiRoute()
    SetWaypointOff()
end

-- ─── the on-screen destination marker ────────────────────────────────────────
-- A waypoint on the minimap gets a driver to the STREET; it doesn't get them to the
-- door, and "which of these six houses is it" is where deliveries actually get lost.
-- So once the drop-off is within NAV.dist, draw it in the world: a pointer floating
-- over the exact point with the label and the live distance under it.
--
-- Drawn only while it's ON SCREEN — GetScreenCoordFromWorldCoord clamps its output
-- for a point behind you, so drawing regardless would stick the arrow to a screen
-- edge and point at nothing.
-- TUNE IN-GAME.
local NAV = {
    dist       = 100.0, -- metres: start drawing the destination this close to it
    up         = 1.0,   -- metres above the drop point the marker floats
    far_wait   = 500,   -- ms between range checks while out of range (no per-frame cost)
    dict       = "basejumping",
    sprite     = "arrow_pointer",
    icon_w     = 0.015, icon_h = 0.025, icon_dy = 0.015, icon_scale = 1.0,
    text_scale = 0.25,
}
local navDict = false -- the sprite dict is requested once, not every frame

local function DrawDestination(coords, label, meters)
    local onScreen, sx, sy = GetScreenCoordFromWorldCoord(coords.x, coords.y, coords.z)
    if not onScreen then return end
    if not navDict then
        RequestStreamedTextureDict(NAV.dict, false)
        navDict = HasStreamedTextureDictLoaded(NAV.dict)
        if not navDict then return end
    end
    DrawSprite(NAV.dict, NAV.sprite, sx, sy - NAV.icon_dy,
               NAV.icon_w * NAV.icon_scale, NAV.icon_h * NAV.icon_scale, 180.0, 255, 255, 0, 255)
    SetTextCentre(true)
    SetTextScale(0.0, NAV.text_scale)
    SetTextEntry("STRING")
    AddTextComponentString(label .. "\n" .. meters .. "m")
    DrawText(sx, sy)
end

-- Follow one delivery's drop-off until its run ends (`gen` stops matching DriveGen).
-- `z` is resolved lazily and once: the persisted target carries no height (dest_x/
-- dest_y only), so a door delivery takes the door prop's own z — exact, and the
-- marker lands on the doorstep rather than at map level — and everything else
-- probes the ground the first time we're near enough for it to be loaded.
local function NavigateTo(gen, x, y, z, label)
    CreateThread(function()
        while gen == DriveGen do
            local c = GetEntityCoords(PlayerPedId())
            local away = #(vector2(c.x, c.y) - vector2(x, y))
            if away <= NAV.dist then
                if not z then
                    local found, gz = GetGroundZFor_3dCoord(x + 0.0, y + 0.0, c.z + 50.0, false)
                    if found then z = gz end
                end
                DrawDestination(vector3(x, y, (z or c.z) + NAV.up), label, math.ceil(away))
                Wait(0)
            else
                Wait(NAV.far_wait)
            end
        end
    end)
end

-- Driver side: begin pinging our position to the waiting customer's in-app map.
RegisterNetEvent("pickle_restaurants:phone:beginDriving", function(d)
    if not d or not d.orderId then return end
    local target = d.target
    local rid = d.rid
    -- No target (a ticket placed before dest_x/dest_y persisted, or a customer whose
    -- coords were never captured) = no waypoint and no arrival check. We do NOT invent
    -- a destination; the position pings still run, so the customer's map still works.
    local hasTarget = target ~= nil and target.x ~= nil
    if hasTarget then
        SetNewWaypoint(target.x + 0.0, target.y + 0.0)
        ShowNotification(_L("delivery_accepted"))
    else
    end
    DriveGen = DriveGen + 1
    local myGen = DriveGen
    -- Arm the door's own hand-over option for this run (nil when the drop is a plain
    -- coordinate). This is also where the door's point comes from below — it answers
    -- with the anchor, so there's no reason to ask the server for it a second time.
    local runDoor = ArmDoorstepTarget and ArmDoorstepTarget(rid, d.orderId) or nil
    -- The in-world destination marker for this run. A door delivery answers with the
    -- door prop's real height (the same point the hand-off scene plays at), so the
    -- pointer sits on the doorstep; anything else resolves its height off the ground.
    if hasTarget then
        local dz = tonumber(target.z)
        if not dz or dz == 0.0 then
            dz = (runDoor and runDoor.z) and (runDoor.z + 0.0) or nil
        end
        NavigateTo(myGen, target.x + 0.0, target.y + 0.0, dz, _L("delivery_nav_label"))
    end
    CreateThread(function()
        local since = GetGameTimer()
        -- The arrival check below ENDS this loop, so it must not be armed while the
        -- driver is still standing at the drop-off — which happens whenever the run is
        -- accepted at the destination, and ALWAYS when a player delivers to themself
        -- (driver ped == customer ped, distance 0). Unarmed, the loop fired one ping
        -- and died, so the customer's map only ever drew if it happened to be mounted
        -- for that single tick. Arm it only once the driver has genuinely left.
        local armed = false
        while myGen == DriveGen and GetGameTimer() - since < 20 * 60 * 1000 do -- give up after 20 min
            local c = GetEntityCoords(PlayerPedId())
            TriggerServerEvent("pickle_restaurants:phone:driverPing", {
                orderId = d.orderId, rid = rid, x = c.x, y = c.y })

            if hasTarget then
                local away = #(vector2(c.x, c.y) - vector2(target.x, target.y))
                if not armed then
                    -- ARRIVE_ARM > the 12m arrival radius, so leaving and coming back
                    -- can't chatter the two thresholds against each other.
                    if away > ARRIVE_ARM then
                        armed = true
                    end
                elseif away < 12.0 then
                    ShowNotification(_L("delivery_arrived"))
                    break
                end
            end
            Wait(DRIVER_PING_MS)
        end
    end)
end)

-- Customer side: a driver was assigned — start a blip we move on each ping.
local deliveryBlip = nil
RegisterNetEvent("pickle_restaurants:phone:driverAssigned", function(d)
    ShowNotification(_L("delivery_out_for_delivery"))
    ToApp("delivery", { orderId = d.orderId, state = "driving" })
end)
RegisterNetEvent("pickle_restaurants:phone:driverCoords", function(d)
    if not d or not d.x then return end
    if not deliveryBlip or not DoesBlipExist(deliveryBlip) then
        deliveryBlip = AddBlipForCoord(d.x + 0.0, d.y + 0.0, 0.0)
        SetBlipSprite(deliveryBlip, 477)     -- delivery/scooter-ish icon
        SetBlipColour(deliveryBlip, 5)       -- yellow
        SetBlipScale(deliveryBlip, 0.9)
        SetBlipAsShortRange(deliveryBlip, false)
        BeginTextCommandSetBlipName("STRING")
        AddTextComponentSubstringPlayerName(_L("delivery_blip"))
        EndTextCommandSetBlipName(deliveryBlip)
    else
        SetBlipCoords(deliveryBlip, d.x + 0.0, d.y + 0.0, 0.0)
    end
    -- …and into the app iframe, so the in-app Leaflet map moves the same driver
    -- marker the world blip does. The native blip stays exactly as it was.
    ToApp("driverCoords", { orderId = d.orderId, x = d.x + 0.0, y = d.y + 0.0 })
end)

-- The driver gave the run back (cancelled, or left the server). Clear the world blip
-- and tell the app to drop its marker — the ticket goes back to "preparing" until
-- someone else accepts it.
RegisterNetEvent("pickle_restaurants:phone:driverReleased", function(d)
    if deliveryBlip and DoesBlipExist(deliveryBlip) then RemoveBlip(deliveryBlip) end
    deliveryBlip = nil
    ShowNotification(_L("delivery_driver_dropped"))
    ToApp("driverGone", { orderId = d and d.orderId })
end)

-- Driver side: we cancelled our own run — stop the ping loop and clear our waypoint.
RegisterNetEvent("pickle_restaurants:phone:endDriving", function()
    EndDriveGen()   -- supersedes the running loop (it falls out on its next tick) and
                    -- takes the door's hand-over option back down with it
    ClearGpsMultiRoute()
    SetWaypointOff()
    ShowNotification(_L("delivery_cancelled_driver"))
end)

local function dropDeliveryBlip()
    if deliveryBlip and DoesBlipExist(deliveryBlip) then RemoveBlip(deliveryBlip) end
    deliveryBlip = nil
end

-- Drop the blip when the order is done (server pushes an updated open list without it,
-- but the customer's own tracking view tells us via this app message).
RegisterNUICallback("phone:endDeliveryBlip", function(_, cb)
    dropDeliveryBlip()
    cb({ ok = true })
end)

-- …and the SERVER says so too, because the app message above only arrives while the
-- tracking screen is OPEN. A customer who pocketed their phone to wait for the driver
-- — which is what everyone does — got the food and kept the driver blip forever, with
-- nothing left able to move or remove it. The order ending is server knowledge, so the
-- server is what ends the blip.
RegisterNetEvent("pickle_restaurants:phone:deliveryEnded", dropDeliveryBlip)

-- ─────────────────────────────────────────────────────────────────────────────
-- RESERVATIONS — nothing to do on the client any more.
--
-- Booking used to TELEPORT the party into a private dining booth inside its own routing
-- bucket, so this file owned a BOOTH anchor, the fade-out/fade-in and a "put me back
-- where I was" return point. All of it is gone: a reservation now HOLDS the
-- restaurant's own placed seat anchors in the shared world (modules/phone/server.lua),
-- so the world-side work is sitting down — which is modules/seating's job, through the
-- ordinary seat interaction. Reserving and cancelling are plain relays above.
-- ─────────────────────────────────────────────────────────────────────────────

-- Tunables (TUNE IN-GAME).
BACKUP_THRESHOLD = 6   -- open tickets that trip the "kitchen backing up" alert
