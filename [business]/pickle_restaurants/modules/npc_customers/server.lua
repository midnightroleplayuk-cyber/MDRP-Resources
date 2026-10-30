-- =============================================
--  modules/npc_customers | server.lua
--  AI customers that walk up to a restaurant's counter, queue, and place a REAL POS
--  ticket off the restaurant's priced menu. Staff cook the items from the shared
--  cooked-items pool and hit Complete at the register exactly as they would for a
--  player order — the NPC then pays into the restaurant balance (+ maybe a tip) and
--  walks away. An NPC that waits past its patience leaves unserved (no money moves).
--
--  The whole thing reuses modules/sales: an NPC order is an ordinary ticket whose
--  `customer_identifier` carries an "npc:" prefix (IsNpcOrder). OrderCache, CreateOrder,
--  GetOpenOrders, AnnotateOrders, PlanFulfillment, SyncOrders and the register/Tickets
--  widget all treat it like any other ticket. The completion/cancel BRANCH for NPCs
--  lives in modules/sales/server.lua and calls the globals exposed at the bottom here.
--
--  The server is authoritative over the queue (NpcState); clients (modules/npc_customers
--  /client.lua) render frozen local peds positioned from the counter transform + geometry
--  that rides in every broadcast.
-- =============================================

-- ─── config (validate on read) ───────────────────────────────────────────────
-- Mirror the drinks/finishes precedent: never trust the raw NUI-written setting.
-- NpcConfig() merges the stored map over safe code defaults and CLAMPS every number,
-- so a bad admin edit can throttle/disable the system but can never break the world.

local CFG_DEFAULTS = {
    enabled          = true,
    require_staff    = true,
    staff_radius     = 30.0,
    spawn_interval   = 45,
    max_queue        = 4,
    patience_seconds = 300,
    min_items        = 1,
    max_items        = 2,
    tip_chance       = 25,
    tip_max_percent  = 15,
    -- WHAT AN NPC IS WILLING TO PAY. An NPC agrees to whatever is on the menu, so
    -- without a ceiling the menu price IS a money printer: put a burger at $999,999,
    -- cook one $3 burger, serve the ped, and the restaurant banks a million dollars
    -- from thin air. A player customer chooses to pay a gouging price; an NPC can't
    -- choose, so the ceiling stands in for that judgement.
    --
    -- Fair value is the sellable's RECOMMENDED price — what its ingredients cost the
    -- restaurant, marked up by `profit_margin` (`MarkupPrice`/`e.defaultPrice`) — so
    -- this tracks the server's own economy instead of being a second, drifting
    -- opinion about what food is worth. An NPC simply won't ORDER something priced
    -- past its limit (it isn't served at a discount): overprice the menu and you lose
    -- NPC trade, which is the pressure that keeps prices honest.
    max_markup       = 100,  -- percent ABOVE the recommended price an NPC will pay
    -- Fallback for a sellable with NO cost basis (nothing in `ingredient_costs`
    -- traces to it, so its recommended price is $0 and a percentage of it bounds
    -- nothing). Those are a config gap, not a licence to charge anything, so they
    -- get a flat cash ceiling rather than being trusted or refused outright.
    unpriced_max     = 100,
    counter_offset   = 1.0,
    queue_spacing    = 0.85,
    spawn_distance   = 6.0,
    -- NPC PHONE DELIVERIES. A separate stream from the counter queue: no ped, no
    -- counter, just a delivery ticket that appears in the app's kitchen queue for a
    -- driver to claim and run. Gated on someone being CLOCKED IN (not nearby) —
    -- delivery demand should arrive because the restaurant is staffed, not because
    -- somebody happens to be standing at the till.
    delivery_enabled   = true,
    delivery_interval  = 180,   -- seconds between generated deliveries, per restaurant
    max_deliveries     = 2,     -- concurrent unserved NPC deliveries per restaurant
    delivery_min_dist  = 120.0, -- how far the drop point sits from the counter
    delivery_max_dist  = 600.0,
    delivery_patience  = 1200,  -- an NPC delivery waits far longer than a counter queue
    delivery_radius    = 8.0,   -- how close the driver must get to hand it over
    models = { "a_m_y_business_01", "a_f_y_business_02", "a_m_m_business_01",
               "a_f_y_hipster_02", "a_m_y_hipster_01", "a_f_m_business_02" },
}

local function num(v, default, lo, hi)
    v = tonumber(v)
    if v == nil then v = default end
    if lo and v < lo then v = lo end
    if hi and v > hi then v = hi end
    return v
end

function NpcConfig()
    local raw = GetSetting("npc_customers", {})
    if type(raw) ~= "table" then raw = {} end
    local models = {}
    if type(raw.models) == "table" then
        for _, m in ipairs(raw.models) do
            if type(m) == "string" and m ~= "" then models[#models + 1] = m end
        end
    end
    if #models == 0 then models = CFG_DEFAULTS.models end
    local minI = num(raw.min_items, CFG_DEFAULTS.min_items, 1, 5)
    local maxI = num(raw.max_items, CFG_DEFAULTS.max_items, 1, 5)
    if maxI < minI then maxI = minI end
    local minD = num(raw.delivery_min_dist, CFG_DEFAULTS.delivery_min_dist, 20.0, 3000.0)
    local maxD = num(raw.delivery_max_dist, CFG_DEFAULTS.delivery_max_dist, 20.0, 3000.0)
    if maxD < minD then maxD = minD end
    return {
        enabled          = (raw.enabled ~= false),
        require_staff    = (raw.require_staff ~= false),
        staff_radius     = num(raw.staff_radius, CFG_DEFAULTS.staff_radius, 3.0, 200.0),
        spawn_interval   = num(raw.spawn_interval, CFG_DEFAULTS.spawn_interval, 5, 3600),
        max_queue        = math.floor(num(raw.max_queue, CFG_DEFAULTS.max_queue, 1, 12)),
        patience_seconds = num(raw.patience_seconds, CFG_DEFAULTS.patience_seconds, 15, 3600),
        min_items        = math.floor(minI),
        max_items        = math.floor(maxI),
        tip_chance       = num(raw.tip_chance, CFG_DEFAULTS.tip_chance, 0, 100),
        tip_max_percent  = num(raw.tip_max_percent, CFG_DEFAULTS.tip_max_percent, 0, 100),
        max_markup       = num(raw.max_markup, CFG_DEFAULTS.max_markup, 0, 100000),
        unpriced_max     = num(raw.unpriced_max, CFG_DEFAULTS.unpriced_max, 0, 10000000),
        counter_offset   = num(raw.counter_offset, CFG_DEFAULTS.counter_offset, 0.0, 5.0),
        queue_spacing    = num(raw.queue_spacing, CFG_DEFAULTS.queue_spacing, 0.3, 3.0),
        spawn_distance   = num(raw.spawn_distance, CFG_DEFAULTS.spawn_distance, 1.0, 30.0),
        models           = models,
        delivery_enabled  = (raw.delivery_enabled ~= false),
        delivery_interval = num(raw.delivery_interval, CFG_DEFAULTS.delivery_interval, 15, 7200),
        max_deliveries    = math.floor(num(raw.max_deliveries, CFG_DEFAULTS.max_deliveries, 1, 10)),
        delivery_min_dist = minD,
        delivery_max_dist = maxD,
        delivery_patience = num(raw.delivery_patience, CFG_DEFAULTS.delivery_patience, 60, 7200),
        delivery_radius   = num(raw.delivery_radius, CFG_DEFAULTS.delivery_radius, 2.0, 50.0),
    }
end

-- How close a driver must be to the drop point to hand an NPC delivery over.
function NpcDeliveryRadius() return NpcConfig().delivery_radius end

-- Just the client-facing geometry knobs, folded into every broadcast so the client
-- lays the queue out exactly as configured without its own copy of the settings.
local function geometry(cfg)
    return { counter_offset = cfg.counter_offset,
             queue_spacing  = cfg.queue_spacing,
             spawn_distance  = cfg.spawn_distance }
end

-- ─── runtime state ───────────────────────────────────────────────────────────

-- NpcState[rid] = { queue = { { orderId, model, expiresAt }, ... }, lastSpawn = os.time() }
local NpcState = {}
local NpcSeq   = 0 -- monotonic id for the "npc:<n>" customer identifier

local FIRST_NAMES = {
    "Alex", "Sam", "Jordan", "Casey", "Riley", "Morgan", "Taylor", "Jamie", "Drew",
    "Quinn", "Avery", "Reese", "Skyler", "Devon", "Harper", "Rowan", "Emerson", "Micah",
}
local LAST_NAMES = {
    "Reed", "Cole", "Vance", "Boyle", "Frost", "Nash", "Ellis", "Dorset", "Kline",
    "Marsh", "Pike", "Rhodes", "Sable", "Tarrow", "Voss", "Wynn", "Ashby", "Barlow",
}
local function randomName()
    return FIRST_NAMES[math.random(#FIRST_NAMES)] .. " " .. LAST_NAMES[math.random(#LAST_NAMES)]
end

-- The admin-placed spawn point for this restaurant (metadata.npc_spawn), or nil.
-- When set, clients start a new customer's walk-in HERE; when nil they fall back to
-- the computed fallback point (spawn_distance back along the queue line).
local function spawnPoint(r)
    return r and r.metadata and r.metadata.npc_spawn or nil
end

-- Which counter the NPC queue forms at. A restaurant can place SEVERAL counters, and
-- `r.counter` (the lowest-id one) is the primary anchor everything else pins to —
-- but the queue is a walk-in, so it belongs at the register NEAREST the admin-placed
-- spawn point, not at whichever register happened to be placed first. Without a
-- spawn point there is nothing to measure against, so the primary anchor stands.
-- Returned in the same shape as `r.counter` (x/y/z/heading), since every payload,
-- client render and geometry helper reads it that way.
local function npcCounter(r)
    if not r then return nil end
    local sp = spawnPoint(r)
    if not sp then return r.counter end
    local best, bestDist
    local from = vector3(sp.x + 0.0, sp.y + 0.0, sp.z + 0.0)
    for _, p in pairs(PropCache) do
        if p.restaurant_id == r.id and p.prop_type == "counter" then
            local d = #(from - vector3(p.x + 0.0, p.y + 0.0, p.z + 0.0))
            if not bestDist or d < bestDist then best, bestDist = p, d end
        end
    end
    if not best then return r.counter end
    return { x = best.x + 0.0, y = best.y + 0.0, z = best.z + 0.0,
             heading = (best.heading or 0.0) + 0.0 }
end

local function counterVec(r)
    local c = npcCounter(r)
    if not c then return nil end
    return vector3(c.x + 0.0, c.y + 0.0, c.z + 0.0)
end

-- ─── presence gating ─────────────────────────────────────────────────────────
-- Returns anyoneNear (a player is within `radius` of the counter — worth rendering
-- for at all) and staffNear (that player can work this restaurant).

local function scanCounter(rid, coords, radius)
    local anyoneNear, staffNear = false, false
    for _, p in ipairs(GetPlayers()) do
        p = tonumber(p)
        local ped = GetPlayerPed(p)
        if ped and ped ~= 0 then
            if #(GetEntityCoords(ped) - coords) <= radius then
                anyoneNear = true
                -- CLOCKED IN, not merely employed-and-standing-here: an off-shift cook
                -- passing through shouldn't summon customers nobody agreed to serve.
                -- Guarded so NPCs still work if modules/phone (which owns shifts) is
                -- ever absent — then it degrades to the old presence-only rule.
                local onShift = (IsClockedIn == nil) or IsClockedIn(rid, p)
                if onShift and (HasPerm(rid, p, "sell") or HasPerm(rid, p, "cook")) then
                    staffNear = true
                    break
                end
            end
        end
    end
    return anyoneNear, staffNear
end

-- ─── queue helpers ───────────────────────────────────────────────────────────

local function queueIndexOf(st, orderId)
    for i, e in ipairs(st.queue) do
        if e.orderId == orderId then return i - 1 end -- 0-based, front = 0
    end
    return nil
end

-- Broadcast the current queue-index map so every client walks its NPCs to the right
-- slots after someone joins/leaves.
local function broadcastQueue(rid, r, cfg)
    local st = NpcState[rid]
    if not st then return end
    local map = {}
    for i, e in ipairs(st.queue) do map[tostring(e.orderId)] = i - 1 end
    -- Scoped to the restaurant. An NPC's ped is a client-LOCAL entity that the client
    -- refuses to render past RENDER_DIST (150m) anyway, so every send beyond that was
    -- paid for and thrown away. Safe because approach is already a hydration edge: the
    -- client re-asks for a full queue snapshot (npc:requestState) every 8s while near
    -- any counter, and on every world sync — so a walk-up sees the queue whether or not
    -- it caught the incremental events.
    SendTo(PlayersNearRestaurant(rid, ScopeRadius.NPC), "pickle_restaurants:npc:queue", {
        rid = rid, counter = npcCounter(r), geo = geometry(cfg), queue = map,
    })
end

-- Remove an order from the queue and tell clients to walk the NPC away (happy or not),
-- then re-slot the rest. Does NOT touch the order lifecycle — the caller owns that.
function NpcDropOrder(rid, orderId, happy)
    local st = NpcState[rid]
    if not st then return end
    -- A DELIVERY has no ped and no queue slot — it lives in its own list. Handled here
    -- rather than in a second hook so modules/sales' completion branch stays one call.
    for i, e in ipairs(st.deliveries or {}) do
        if e.orderId == orderId then
            table.remove(st.deliveries, i)
            return              -- nothing to despawn, nothing to re-slot
        end
    end
    local removed = false
    for i, e in ipairs(st.queue) do
        if e.orderId == orderId then table.remove(st.queue, i); removed = true; break end
    end
    if not removed then return end
    SendTo(PlayersNearRestaurant(rid, ScopeRadius.NPC), "pickle_restaurants:npc:despawn", rid, orderId, happy == true)
    local r = GetRestaurant(rid)
    if r then broadcastQueue(rid, r, NpcConfig()) end
end

-- An NPC gives up waiting: cancel its ticket (no refund — NPCs pay on serve) and leave.
local function abandonNpcOrder(rid, orderId)
    local o = OrderCache[rid] and OrderCache[rid][orderId]
    if o and o.status == "open" then CloseOrder(rid, orderId, "cancelled") end
    NpcDropOrder(rid, orderId, false)
    if SyncOrders then SyncOrders(rid) end
end

-- ─── spawning ────────────────────────────────────────────────────────────────

-- Build one POS line from a priced-catalog entry, in the exact shape sales:createOrder
-- produces, so PlanFulfillment / completeOrder read an NPC line identically to a player's.
local function lineFromEntry(e, qty)
    local variant, mods = e.variant, nil
    -- Drinks are ONE sellable with the flavor as a single-choice modifier; an NPC
    -- picks a random flavor so its ticket pins one (kitchen matching + a chip on the
    -- receipt), mirroring what resolveLineModifiers records for a player's order.
    if e.kind == "drink" and type(e.modifiers) == "table" and #e.modifiers > 0 then
        local m = e.modifiers[math.random(#e.modifiers)]
        variant = m.variant or e.variant
        local label = m.group and (tostring(m.group) .. ": " .. tostring(m.label)) or m.label
        mods = { { id = m.id, label = label, price = 0, added = true, image = m.image, color = m.color } }
    end
    return {
        item    = e.item,
        variant = variant,
        label   = e.label,
        image   = e.image or GetItemImage(e.item),
        price   = e.price,
        qty     = qty or 1,
        kind    = e.kind,
        mods    = mods,
    }
end

-- The orderable menu an NPC will actually SHOP FROM: the priced catalog minus
-- everything priced past what a walk-in is willing to pay (see `max_markup`).
--
-- THIS IS THE ONE DOOR into an NPC ticket. Both spawn paths (counter queue and phone
-- delivery) come through here, so there is a single place the ceiling is applied and
-- no second copy to forget — an NPC ticket's total is banked verbatim on serve, so a
-- line that gets past this point is money the restaurant has already earned.
--
-- Rejecting rather than discounting is deliberate: the ped pays the ticket it agreed
-- to, and a gouged menu simply stops drawing NPC custom. An entry with no cost basis
-- (`defaultPrice` 0 — nothing in `ingredient_costs` reaches it) falls to the flat
-- `unpriced_max`, since a percentage of nothing is no limit at all.
local function npcShoppingCatalog(rid, cfg)
    local catalog = BuildPricedCatalog(rid, true)
    if not catalog or #catalog == 0 then return nil end
    local out = {}
    for _, e in ipairs(catalog) do
        local fair = tonumber(e.defaultPrice) or 0
        local cap = (fair > 0) and RoundMoney(fair * (1 + cfg.max_markup / 100)) or cfg.unpriced_max
        if (tonumber(e.price) or 0) <= cap then out[#out + 1] = e end
    end
    if #out == 0 then return nil end
    return out
end

local function spawnNpcCustomer(rid, r, cfg)
    -- Nothing an NPC will buy (no menu, or every item priced out) → no customer.
    local catalog = npcShoppingCatalog(rid, cfg)
    if not catalog then return end

    local count = math.random(cfg.min_items, cfg.max_items)
    local lines, total = {}, 0
    for _ = 1, count do
        local e = catalog[math.random(#catalog)]
        local qty = 1
        lines[#lines + 1] = lineFromEntry(e, qty)
        total = total + e.price * qty
    end
    if #lines == 0 then return end
    total = RoundMoney(total)

    NpcSeq = NpcSeq + 1
    local order = CreateOrder(rid, {
        customer_identifier = "npc:" .. NpcSeq,
        customer_name       = randomName(),
        cashier_identifier  = "",
        lines               = lines,
        total               = total,
    })
    if not order or not order.id then return end

    local st = NpcState[rid]
    local model = cfg.models[math.random(#cfg.models)]
    st.queue[#st.queue + 1] = {
        orderId   = order.id,
        model     = model,
        expiresAt = os.time() + cfg.patience_seconds,
        patience  = cfg.patience_seconds, -- the full window, for the ticket UI's radial
    }
    st.lastSpawn = os.time()

    -- Ticket appears in every open register / Tickets widget.
    if SyncOrders then SyncOrders(rid) end
    -- Spawn the ped on all clients (each renders a local, distance-gated copy).
    SendTo(PlayersNearRestaurant(rid, ScopeRadius.NPC), "pickle_restaurants:npc:spawn", {
        rid        = rid,
        orderId    = order.id,
        model      = model,
        counter    = npcCounter(r),
        spawn      = spawnPoint(r),
        geo        = geometry(cfg),
        queueIndex = #st.queue - 1,
        ticket     = order.ticket,
    })
end

-- ─── NPC phone deliveries ────────────────────────────────────────────────────
-- A delivery order from an AI customer somewhere in the city. There is NO ped and no
-- counter involvement: the ticket simply appears in the app's kitchen queue, a driver
-- claims it exactly like a player's delivery, drives to the drop point and serves it.
-- Everything downstream (claim, waypoint, route, blip, the Work UI) is the existing
-- player-delivery machinery — the only NPC-specific part is completion, which checks
-- the driver reached the point instead of checking a customer is standing there.

-- A drop point on a random bearing from the counter. Deliberately NOT road-snapped:
-- that needs a client-side native, and the delivery only ever cares about horizontal
-- distance (waypoint, blip and the hand-off check are all XY), so a raw offset is both
-- sufficient and server-resolvable.
local function deliveryPoint(coords, cfg)
    local ang = math.random() * math.pi * 2
    local dist = cfg.delivery_min_dist + math.random() * (cfg.delivery_max_dist - cfg.delivery_min_dist)
    return coords.x + math.cos(ang) * dist, coords.y + math.sin(ang) * dist, dist
end

-- The admin-placed DELIVERY DOORS for a restaurant (prop_type "delivery_door").
-- When a restaurant has any, an NPC delivery goes to a real doorstep instead of a
-- bare coordinate in a field — which is what lets the driver knock and have someone
-- answer (modules/doorstep). No doors placed = the random-bearing point above, so
-- an install that never places one behaves exactly as it did before.
local function deliveryDoors(rid)
    local out = {}
    for _, p in pairs(PropCache) do
        if p.restaurant_id == rid and p.prop_type == "delivery_door" then out[#out + 1] = p end
    end
    return out
end

-- Pick a door, preferring one that isn't already the target of an open delivery so
-- two drivers aren't sent to the same doorstep at once. Falls back to any door when
-- they're all busy rather than refusing to generate the order.
local function pickDeliveryDoor(rid)
    local doors = deliveryDoors(rid)
    if #doors == 0 then return nil end
    local taken = {}
    for orderId, t in pairs(DeliveryTargets or {}) do
        if t.door then taken[t.door] = true end
    end
    local free = {}
    for _, d in ipairs(doors) do
        if not taken[d.id] then free[#free + 1] = d end
    end
    local pool = (#free > 0) and free or doors
    return pool[math.random(#pool)]
end

local function spawnNpcDelivery(rid, r, cfg, coords)
    local catalog = npcShoppingCatalog(rid, cfg)
    if not catalog then return end

    local count = math.random(cfg.min_items, cfg.max_items)
    local lines, total = {}, 0
    for _ = 1, count do
        local e = catalog[math.random(#catalog)]
        lines[#lines + 1] = lineFromEntry(e, 1)
        total = total + e.price
    end
    if #lines == 0 then return end
    total = RoundMoney(total)

    NpcSeq = NpcSeq + 1
    local order = CreateOrder(rid, {
        customer_identifier = "npc:" .. NpcSeq,
        customer_name       = randomName(),
        cashier_identifier  = "",
        lines               = lines,
        total               = total,
    })
    if not order or not order.id then return end

    local door = pickDeliveryDoor(rid)
    local dx, dy, dz, dist, doorId, doorHeading
    if door then
        dx, dy, dz = door.x, door.y, door.z
        doorId, doorHeading = door.id, door.heading or 0.0
        dist = math.sqrt((dx - coords.x) ^ 2 + (dy - coords.y) ^ 2)
    else
        dx, dy, dist = deliveryPoint(coords, cfg)
        dz = 0.0
    end
    -- Carry the phone fields on the cache row so GetOpenOrders projects them (the same
    -- thing modules/sales' placeOrder does for a player's app order).
    order.order_type = "delivery"
    order.address    = _L("npc_delivery_address", math.floor(dist))
    order.dest_x, order.dest_y = dx, dy
    -- `door` is what turns arrival into a doorstep hand-off rather than a button
    -- press at a coordinate: modules/doorstep reads it off the delivery target.
    DeliveryTargets[order.id] = { x = dx, y = dy, z = dz or 0.0, door = doorId, heading = doorHeading }

    -- Persisted so a restart mid-run doesn't resurrect the ticket as a pickup with no
    -- drop point (core reloads orders; RehydrateDeliveryTargets restores the target).
    MySQL.update("UPDATE `pickle_restaurant_orders` SET order_type = 'delivery', address = ?, dest_x = ?, dest_y = ? WHERE id = ?",
        { order.address, dx, dy, order.id })

    local st = NpcState[rid]
    st.deliveries[#st.deliveries + 1] = {
        orderId   = order.id,
        expiresAt = os.time() + cfg.delivery_patience,
        patience  = cfg.delivery_patience,
    }
    st.lastDelivery = os.time()
    if SyncOrders then SyncOrders(rid) end
end

-- ─── scheduler ───────────────────────────────────────────────────────────────
-- One thread drives every restaurant: it expires impatient NPCs, then spawns new
-- ones where the gates allow. Cheap — the heavy BuildPricedCatalog runs only on an
-- actual spawn (throttled by spawn_interval + max_queue).

CreateThread(function()
    -- Wait for the DB caches (restaurants, next-ticket numbers) before creating any
    -- order — the same gate admin/core use.
    while not RestaurantsReady do Wait(200) end
    while true do
        Wait(3000)
        local cfg = NpcConfig()
        local now = os.time()
        for rid, r in pairs(RestaurantCache) do
            local coords = counterVec(r)
            local st = NpcState[rid]

            -- No counter (or system off): drop any lingering NPCs for this restaurant.
            if not coords or not cfg.enabled then
                if st and #st.queue > 0 then
                    for i = #st.queue, 1, -1 do abandonNpcOrder(rid, st.queue[i].orderId) end
                end
            else
                st = st or { queue = {}, lastSpawn = 0 }
                st.deliveries = st.deliveries or {}
                NpcState[rid] = st

                -- Expire the impatient (walk away unserved; ticket cancelled).
                for i = #st.queue, 1, -1 do
                    local e = st.queue[i]
                    local o = OrderCache[rid] and OrderCache[rid][e.orderId]
                    if not o or o.status ~= "open" or now >= e.expiresAt then
                        abandonNpcOrder(rid, e.orderId)
                    end
                end
                -- Same for deliveries nobody ever ran. A cancelled delivery frees its
                -- slot, so a restaurant that ignores them doesn't wedge at the cap.
                for i = #st.deliveries, 1, -1 do
                    local e = st.deliveries[i]
                    local o = OrderCache[rid] and OrderCache[rid][e.orderId]
                    if not o or o.status ~= "open" or now >= e.expiresAt then
                        abandonNpcOrder(rid, e.orderId)
                    end
                end

                -- Spawn gating: presence, queue capacity, and the spawn interval.
                if #st.queue < cfg.max_queue and (now - (st.lastSpawn or 0)) >= cfg.spawn_interval then
                    local anyoneNear, staffNear = scanCounter(rid, coords, cfg.staff_radius)
                    local ok = anyoneNear and (not cfg.require_staff or staffNear)
                    if ok then spawnNpcCustomer(rid, r, cfg) end
                end

                -- Deliveries gate on SHIFTS, not proximity: an order placed through an
                -- app doesn't care where the staff are standing, only that the place is
                -- actually open for business. (AnyoneClockedIn is a modules/phone
                -- global — guarded so NPCs degrade rather than break without it.)
                if cfg.delivery_enabled
                    and #st.deliveries < cfg.max_deliveries
                    and (now - (st.lastDelivery or 0)) >= cfg.delivery_interval
                    and AnyoneClockedIn and AnyoneClockedIn(rid)
                then
                    spawnNpcDelivery(rid, r, cfg, coords)
                end
            end
        end
    end
end)

-- ─── late-joiner / approacher resync ─────────────────────────────────────────
-- A client that just booted or walked up asks for the current queues so it can render
-- NPCs that spawned before it arrived. We reply only to that source.

RegisterNetEvent("pickle_restaurants:npc:requestState", function()
    local src = source
    local cfg = NpcConfig()
    local out = {}
    for rid, st in pairs(NpcState) do
        local r = GetRestaurant(rid)
        if r and npcCounter(r) and #st.queue > 0 then
            local entries = {}
            for i, e in ipairs(st.queue) do
                local o = OrderCache[rid] and OrderCache[rid][e.orderId]
                entries[#entries + 1] = {
                    orderId    = e.orderId,
                    model      = e.model,
                    queueIndex = i - 1,
                    ticket     = o and o.ticket or nil,
                }
            end
            out[#out + 1] = { rid = rid, counter = npcCounter(r), spawn = spawnPoint(r), geo = geometry(cfg), entries = entries }
        end
    end
    TriggerClientEvent("pickle_restaurants:npc:state", src, out)
end)

-- ─── globals for modules/sales (NPC completion branch) ───────────────────────

-- An order placed by an NPC customer (its ticket carries the "npc:" identifier).
function IsNpcOrder(o)
    return o and type(o.customer_identifier) == "string" and o.customer_identifier:sub(1, 4) == "npc:"
end

-- Is this NPC still waiting at the counter (not already served / walked off)?
function NpcOrderPresent(rid, orderId)
    local st = NpcState[rid]
    if not st then return false end
    return queueIndexOf(st, orderId) ~= nil
end

-- Remaining patience for an NPC's ticket, for the ticket UI's live countdown +
-- radial indicator: returns (secondsLeft, patienceWindow) — seconds left clamped
-- to >= 0, and the full patience window that is the radial's denominator. Returns
-- nil when this order isn't a currently-waiting NPC (a player ticket, or an NPC
-- that already walked). The client ticks the value down locally between broadcasts.
function NpcOrderTimer(rid, orderId)
    local st = NpcState[rid]
    if not st then return nil end
    -- Both streams carry a patience window: the counter queue and the delivery list.
    -- A driver needs the countdown as much as a cashier does — more, since they have to
    -- drive it — so deliveries are searched too.
    for _, list in ipairs({ st.queue, st.deliveries or {} }) do
        for _, e in ipairs(list) do
            if e.orderId == orderId then
                local left = e.expiresAt - os.time()
                if left < 0 then left = 0 end
                return left, (e.patience or left)
            end
        end
    end
    return nil
end

-- A configured tip on a served order: 0 unless the roll hits, then 0..tip_max_percent%.
function NpcRollTip(total)
    local cfg = NpcConfig()
    if cfg.tip_chance <= 0 or cfg.tip_max_percent <= 0 then return 0 end
    if math.random(100) > cfg.tip_chance then return 0 end
    local pct = math.random(0, math.floor(cfg.tip_max_percent))
    return RoundMoney((tonumber(total) or 0) * pct / 100)
end
