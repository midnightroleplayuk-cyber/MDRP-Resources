-- =============================================
--  modules/supply | server.lua
--  SUPPLY RUNS — buying stock becomes cargo you have to go and fetch.
--
--  Switched OFF (the default) this module does nothing at all: `management:buyStock`
--  credits the larder on the spot exactly as it always did. Switched on, a purchase
--  becomes a PENDING ORDER, and the ingredients only reach the larder when somebody
--  drives to a supplier DEPOT and loads the boxes onto a haulage trailer.
--
--  The shape, and why:
--    • DEPOTS ARE SERVER-WIDE. A supplier serves every restaurant, which is what makes
--      the run a commute rather than a walk out the back door. They are placed with the
--      gizmo from the admin panel and live in the `supply_runs` SETTING, like every
--      other piece of authored config in this resource (there is no config.lua).
--    • A depot holds LOADING ZONES, and a zone is CLAIMED BY ONE PLAYER. Two crews
--      sharing a package point would each be taking boxes off the other's pile, and the
--      pile is the whole read-out of how much work is left.
--    • THE PILE IS SERVER STATE, the boxes are local props. Same rule as modules/mirror:
--      the authority is the run (boxes taken / loaded), the audience is
--      `PlayersNearPoint` of that zone, and a client walking into range HYDRATES with
--      `supply:state` rather than replaying events it missed. Nothing here is ever a
--      `-1` send — a pile going down in Paleto is not news in Vespucci.
--    • THE TRUCK AND TRAILER ARE NETWORKED, and therefore outlive the client that made
--      them. That is the `modules/doorstep` hazard and it gets the doorstep ANSWER: the
--      claimer spawns them, reports the net ids the moment they exist, and the server
--      deletes them on `playerDropped`, on a lapsed claim, or after the driver departs.
--
--  What a run is NOT: a second inventory. Boxes are cargo, never items — there is
--  nothing to lose, drop, or sell on the way, and a run that goes wrong costs the
--  restaurant only the trip. The money left at CHECKOUT, so the cargo is already the
--  restaurant's; an abandoned run is re-claimable by anyone who could have started it.
-- =============================================

local CFG_DEFAULTS = {
    max_stock = 100, boxes_per_cap = 4,
    box_model = "hei_prop_heist_box", truck_model = "phantom", trailer_model = "trailers",
    truck_gap = 8.5, claim_ttl = 900,
}

-- Units a box holds when there is NO cap to divide up. An uncapped larder gives
-- "boxes per full larder" nothing to measure against, so a run needs some size, and a
-- load is still bounded (this times boxes_per_cap) rather than unbounded.
local UNCAPPED_BOX_UNITS = 25

local SCOPE_RADIUS = 90.0   -- audience around a loading zone for its pile/run events (TUNE IN-GAME)
local SWEEP_MS     = 15000  -- how often lapsed claims are swept
local DEPART_MS    = 25000  -- how long the loaded rig is left in the world before cleanup

local function num(v, d, lo, hi)
    v = tonumber(v); if not v then return d end
    if v < lo then return lo elseif v > hi then return hi end
    return v
end

local function str(v, d)
    return (type(v) == "string" and v ~= "") and v or d
end

-- A placed point, or nil. Every consumer treats nil as "this zone isn't finished", so a
-- half-placed zone is simply not offered rather than being offered and then failing.
local function point(p)
    if type(p) ~= "table" then return nil end
    local x, y, z = tonumber(p.x), tonumber(p.y), tonumber(p.z)
    if not (x and y and z) then return nil end
    return { x = x, y = y, z = z, heading = tonumber(p.heading) or 0.0 }
end

-- VALIDATE ON READ, the same pattern NpcConfig / ReservationSlots use: the NUI writes
-- this setting whole, so nothing downstream may assume a shape. A zone missing either
-- of its two points is DROPPED here, which is why no other function in this file has to
-- ask whether a package point exists.
function SupplyConfig()
    local raw = GetSetting("supply_runs", {})
    if type(raw) ~= "table" then raw = {} end
    local depots = {}
    for _, d in ipairs(type(raw.depots) == "table" and raw.depots or {}) do
        if type(d) == "table" and d.id then
            local zones = {}
            for _, z in ipairs(type(d.zones) == "table" and d.zones or {}) do
                local pkg, trl = point(z and z.package), point(z and z.trailer)
                if z and z.id and pkg and trl then
                    -- `load` is where a box is actually put ON the trailer, placed in
                    -- its own pass against a side-on camera. OPTIONAL, because a bay
                    -- placed before that pass existed has none: the client falls back to
                    -- measuring the model's rear, which is what the pass replaced.
                    zones[#zones + 1] = { id = tostring(z.id), package = pkg, trailer = trl,
                                          load = point(z.load) }
                end
            end
            depots[#depots + 1] = {
                id    = tostring(d.id),
                label = str(d.label, tostring(d.id)),
                blip  = type(d.blip) == "table" and d.blip or nil,
                -- WHERE THE ORDER IS PLACED. With runs on, the Supplies tab is not a
                -- shop any more: you buy at the counter of the depot that will hand you
                -- the boxes, so the money and the cargo are in the same place.
                shop  = point(d.shop),
                zones = zones,
            }
        end
    end
    -- BOXES PER CAP, not units per box: an admin sets how many trips a full larder is
    -- worth, and the unit size falls out of it. Stating it the other way round meant
    -- doubling the cap doubled the number of boxes to carry, which is not what raising
    -- a limit is meant to do.
    local hasShop, hasBay = false, false
    for _, d in ipairs(depots) do
        if d.shop then hasShop = true end
        if #d.zones > 0 then hasBay = true end
    end
    local cap      = math.floor(num(raw.max_stock, CFG_DEFAULTS.max_stock, 0, 1000000))
    local perCap   = math.floor(num(raw.boxes_per_cap, CFG_DEFAULTS.boxes_per_cap, 1, 30))
    local boxUnits = (cap > 0) and math.max(1, math.ceil(cap / perCap)) or UNCAPPED_BOX_UNITS
    return {
        -- ENABLED MEANS USABLE. A server that ticked the box but never placed a depot
        -- would otherwise turn every purchase into cargo nobody can collect — the one
        -- failure mode that eats a restaurant's money with no way to get it back. With
        -- nothing placed this reads as off, which is the safe direction to be wrong in.
        -- ENABLED MEANS THE WHOLE LOOP IS PLACEABLE, not merely that a depot exists:
        -- ordering needs a SHOP point and collecting needs a finished BAY, so a config
        -- with one and not the other leaves a restaurant either unable to buy at all or
        -- paying for cargo it can never fetch. Missing either, this reads as off.
        enabled       = (raw.enabled == true) and hasShop and hasBay,
        max_stock     = cap,
        boxes_per_cap = perCap,
        -- Derived, and reported so the panel can show what the admin's two numbers
        -- actually work out to rather than making them do the division.
        box_units     = boxUnits,
        max_boxes     = perCap,
        box_model     = str(raw.box_model, CFG_DEFAULTS.box_model),
        truck_model   = str(raw.truck_model, CFG_DEFAULTS.truck_model),
        trailer_model = str(raw.trailer_model, CFG_DEFAULTS.trailer_model),
        truck_gap     = num(raw.truck_gap, CFG_DEFAULTS.truck_gap, 3.0, 30.0),
        claim_ttl     = math.floor(num(raw.claim_ttl, CFG_DEFAULTS.claim_ttl, 60, 7200)),
        depots        = depots,
    }
end

-- The two questions the rest of the resource asks. Both are guarded calls at their call
-- sites (this module loads after management), and both answer for the DISABLED case, so
-- no caller needs to know the feature exists beyond "is there a cap / do I queue a run".
function SupplyRunsEnabled() return SupplyConfig().enabled end

-- The per-ITEM larder ceiling, 0 = uncapped. Deliberately tied to `enabled`: the cap is
-- what makes the commute a REGULAR one, and on a server that hasn't switched runs on it
-- would just be a limit with no way to work around it.
function SupplyStockCap()
    local c = SupplyConfig()
    return c.enabled and c.max_stock or 0
end

-- Is this player actually AT a depot counter? The panel-side gate is cosmetic (the NUI
-- is untrusted, and a forged `shop` flag would put the shop back in everyone's pocket),
-- so this is what `buyStock` is really gated on. Read live rather than off the position
-- cache: it is asked once per panel open and once per purchase, not on a hot path.
local SHOP_REACH = 4.0

-- Returns the DEPOT they are standing at, or nil. It answers with the depot rather than
-- a yes/no because ordering now starts the run right there: the checkout needs to know
-- which warehouse is about to put boxes on its floor. Truthy either way, so the callers
-- that only ask "is he at a counter" read the same.
function SupplyShopNear(src)
    local cfg = SupplyConfig()
    if not cfg.enabled then return nil end
    local ped = GetPlayerPed(src)
    if not ped or ped == 0 then return nil end
    local c = GetEntityCoords(ped)
    for _, d in ipairs(cfg.depots) do
        local sp = d.shop
        if sp then
            local dx, dy, dz = c.x - sp.x, c.y - sp.y, c.z - sp.z
            if (dx * dx + dy * dy + dz * dz) <= (SHOP_REACH * SHOP_REACH) then return d end
        end
    end
    return nil
end

-- ─── pending orders ──────────────────────────────────────────────────────────
-- Bought, paid for, not yet fetched. Cached like every other table in this resource;
-- the mutators write through to both.

local SupplyCache = {}   -- [restaurantId][orderId] = row (lines decoded)

local function cacheOrder(row)
    SupplyCache[row.restaurant_id] = SupplyCache[row.restaurant_id] or {}
    SupplyCache[row.restaurant_id][row.id] = row
end

local function LoadSupplyOrders()
    SupplyCache = {}
    local rows = MySQL.query.await(
        "SELECT * FROM pickle_restaurant_supply_orders WHERE status = 'pending'") or {}
    for _, row in ipairs(rows) do
        row.lines = (type(row.lines) == "string") and json.decode(row.lines) or (row.lines or {})
        cacheOrder(row)
    end
end

-- How many units of one stock key are already bought but still sitting at the depot.
-- The cap counts these: ordering twice in a row must not slip past a ceiling that only
-- looked at what had actually arrived.
function PendingSupplyUnits(rid, key)
    local n = 0
    for _, row in pairs(SupplyCache[rid] or {}) do
        for _, l in ipairs(row.lines or {}) do
            if l.key == key then n = n + (tonumber(l.qty) or 0) end
        end
    end
    return n
end

-- Every pending run for a restaurant, newest last — what the Supplies tab lists so a
-- boss can see what is waiting to be collected.
function PendingSupplyOrders(rid)
    local out = {}
    for _, row in pairs(SupplyCache[rid] or {}) do
        local lines = {}
        for _, l in ipairs(row.lines or {}) do
            lines[#lines + 1] = { key = l.key, qty = l.qty, label = StockKeyLabel(l.key) }
        end
        out[#out + 1] = { id = row.id, boxes = row.boxes, units = row.units, lines = lines }
    end
    table.sort(out, function(a, b) return a.id < b.id end)
    return out
end

-- How many boxes an order of `units` becomes. The box is a fixed number of units, so
-- the pile is a readable picture of the order — and `max_boxes` is what a checkout is
-- validated against, so this never has to clamp a real order down (an order too big to
-- haul is refused at the till, not quietly shrunk into fewer boxes than were paid for).
local function boxesFor(cfg, units)
    return math.max(1, math.min(cfg.max_boxes, math.ceil(units / cfg.box_units)))
end

function SupplyBoxesFor(units) return boxesFor(SupplyConfig(), units) end
function SupplyRunCapacity()
    local c = SupplyConfig()
    return c.box_units * c.max_boxes
end

-- Queue a purchase as cargo. Called from `management:buyStock` AFTER the money has left
-- the restaurant balance, which is what makes the cargo the restaurant's rather than the
-- buyer's: an abandoned run is claimable by anyone who could have started one.
function CreateSupplyOrder(rid, identifier, lines, units)
    local cfg = SupplyConfig()
    local boxes = boxesFor(cfg, units)
    -- BACKTICK `lines`: it is a RESERVED WORD in MySQL/MariaDB (LOAD DATA ... LINES),
    -- so an unquoted column of that name is a syntax error. CreateTables never hit it
    -- because the schema backticks every column; this INSERT did.
    --
    -- PROTECTED, because the money has ALREADY LEFT by the time this runs. oxmysql
    -- RAISES a failed query as a Lua error, which would abort the purchase callback
    -- mid-way: past the debit, before the refund that exists for exactly this case. A
    -- restaurant would be charged for cargo that was never created and the caller would
    -- get no answer at all. Returning nil instead lets `BuySupplies` hand the money
    -- back. Logged loudly: a broken INSERT is an operator problem, not a gameplay one.
    local ok, id = pcall(function()
        return MySQL.insert.await(
            "INSERT INTO pickle_restaurant_supply_orders (`restaurant_id`, `identifier`, `lines`, `units`, `boxes`) "
            .. "VALUES (?, ?, ?, ?, ?)",
            { rid, identifier, json.encode(lines), units, boxes })
    end)
    if not ok or not id then
        print(("[pickle_restaurants] supply order INSERT failed for restaurant %s: %s")
            :format(tostring(rid), tostring(id)))
        return nil
    end
    cacheOrder({ id = id, restaurant_id = rid, identifier = identifier,
                 lines = lines, units = units, boxes = boxes, status = "pending" })
    return id, boxes
end

-- ─── live runs ───────────────────────────────────────────────────────────────
-- ONE per loading zone, keyed by "depotId|zoneId". `taken` is how many boxes have left
-- the pile, `loaded` how many are on the trailer; the difference is the one in the
-- claimer's arms (a run only ever has one player, so it is 0 or 1).

local Runs = {}          -- [zoneKey] = run
local RunBySrc = {}      -- [src] = zoneKey — one run per player, so the sweep is O(1)

local function zoneKey(depotId, zoneId) return tostring(depotId) .. "|" .. tostring(zoneId) end

local function findZone(cfg, depotId, zoneId)
    for _, d in ipairs(cfg.depots) do
        if d.id == depotId then
            for _, z in ipairs(d.zones) do
                if z.id == zoneId then return d, z end
            end
        end
    end
    return nil
end

-- The public shape of a zone: what the client renders (how many boxes are still on the
-- pile) plus who it belongs to, so only the claimer is offered the actions. Sent to an
-- AUDIENCE, so it deliberately carries no identifiers — a bystander watching a pile go
-- down has no business knowing which restaurant's cargo it is.
local function runState(key)
    local run = Runs[key]
    if not run then return { key = key, active = false } end
    return {
        key     = key,
        active  = true,
        owner   = run.src,
        boxes   = run.boxes,
        taken   = run.taken,
        loaded  = run.loaded,
        carrying = run.taken > run.loaded,
    }
end

local function audience(run)
    local p = run.package
    return PlayersNearPoint(p.x, p.y, p.z, SCOPE_RADIUS)
end

-- Push one zone's state to everyone who can see that pile. The hydration edge for
-- anyone out of range is `supply:state` (below), which the client's own range watcher
-- calls as it arrives — so scoping this is safe in the sense CLAUDE.md requires.
local function pushState(key)
    local run = Runs[key]
    -- A zone that just went free has no run to resolve an audience from, so the last
    -- run's own package point is what names the room that needs telling.
    local pt = run and run.package or nil
    if not pt then return end
    SendTo(PlayersNearPoint(pt.x, pt.y, pt.z, SCOPE_RADIUS), "pickle_restaurants:supply:zone", runState(key))
end

-- Ending a run, from every direction: finished, abandoned, lapsed, disconnected. ONE
-- function, because each of those has to do the same three things — free the bay, tell
-- the room, and take the haulage rig back out of the world — and a second copy of that
-- is how one of them ends up leaking a truck.
local function endRun(key, reason)
    local run = Runs[key]
    if not run then return end
    Runs[key] = nil
    if run.src then RunBySrc[run.src] = nil end
    -- Vehicles are NETWORKED and were spawned by a client that may already be gone:
    -- deleting them is the server's job (the doorstep pattern). Deleting an entity that
    -- is already deleted is a no-op, so racing the claimer's own cleanup is harmless.
    for _, netId in ipairs(run.entities or {}) do
        local ent = NetworkGetEntityFromNetworkId(netId)
        if ent and ent ~= 0 and DoesEntityExist(ent) then DeleteEntity(ent) end
    end
    -- The pile has to come down on every nearby client whatever ended the run, so the
    -- room is told with the run already gone from the table (runState answers "free").
    SendTo(PlayersNearPoint(run.package.x, run.package.y, run.package.z, SCOPE_RADIUS),
           "pickle_restaurants:supply:zone", { key = key, active = false })
    if reason == "lapsed" and run.src then
        ShowNotification(run.src, _L("supply_run_lapsed"))
    end
end

AddEventHandler("playerDropped", function()
    local key = RunBySrc[source]
    if key then endRun(key, "dropped") end
end)

CreateThread(function()
    while true do
        Wait(SWEEP_MS)
        local now = os.time()
        for key, run in pairs(Runs) do
            if run.expires <= now then endRun(key, "lapsed") end
        end
    end
end)

-- ─── the run, start to finish ────────────────────────────────────────────────
--
-- THERE IS NO CLAIM STEP. Ordering IS the claim: paying at the counter picks a free bay
-- at that depot, spawns the pile and hands the buyer their run. Targeting a bay and then
-- choosing an order off a list was a menu standing between a player and work they had
-- already paid for, and it made the boxes appear at a moment nothing on screen explained.
--
-- ONE ACTIVE ORDER PER PLAYER, which is what lets every surface here be answer-free: the
-- bay knows whose run it is, and a resumed run needs no picker because there is only ever
-- one thing to resume.

-- Whoever is running this bay right now, and whoever is running anything.
function SupplyActiveRun(src) return Runs[RunBySrc[src] or ""] end

-- This player's outstanding order, if any. Keyed by IDENTIFIER, so it survives a
-- reconnect: an order is paid for, and dropping out must not lose it.
function PendingSupplyFor(identifier)
    if not identifier then return nil end
    for rid, orders in pairs(SupplyCache) do
        for _, row in pairs(orders) do
            if row.identifier == identifier then return row, rid end
        end
    end
    return nil
end

-- The first bay at this depot nobody is working. nil = the depot is full, which is
-- refused BEFORE any money moves: a checkout that takes payment and then has nowhere to
-- put the boxes is the one failure this whole flow exists to avoid.
local function freeBayAt(depot)
    for _, z in ipairs(depot.zones or {}) do
        if not Runs[zoneKey(depot.id, z.id)] then return z end
    end
    return nil
end

-- Put a run on a bay and tell its owner. The pile is server state, so the state push is
-- what makes the boxes appear for everyone nearby; `runStarted` is the extra the OWNER
-- needs and nobody else does (the models to spawn the rig from, and the two points to
-- put on their map).
local function startRun(src, depot, zone, order)
    local cfg = SupplyConfig()
    local key = zoneKey(depot.id, zone.id)
    Runs[key] = {
        key = key, src = src, identifier = GetIdentifier(src),
        rid = order.restaurant_id, orderId = order.id,
        boxes = order.boxes, taken = 0, loaded = 0,
        package = zone.package, trailer = zone.trailer,
        entities = {},
        expires = os.time() + cfg.claim_ttl,
    }
    RunBySrc[src] = key
    pushState(key)
    TriggerClientEvent("pickle_restaurants:supply:runStarted", src, {
        key = key, boxes = order.boxes, depot = depot.id, depotLabel = depot.label,
        -- `load` rides along so the owner's map marker lands where the box actually
        -- goes; nil on a bay placed before that pass existed, and the client measures.
        package = zone.package, trailer = zone.trailer, load = zone.load,
        box_model = cfg.box_model, truck_model = cfg.truck_model,
        trailer_model = cfg.trailer_model, truck_gap = cfg.truck_gap,
    })
    return key
end

-- Called by `BuySupplies` the moment an order is paid for, at the depot it was paid at.
-- Returns the box count, or nil + an error key if the depot can't take the run (which the
-- checkout has already tested for, but the world moves between a check and a write).
function BeginSupplyRun(src, depot, order)
    if not depot or not order then return nil end
    if RunBySrc[src] then return nil, "supply_already_running" end
    local zone = freeBayAt(depot)
    if not zone then return nil, "supply_depot_full" end
    startRun(src, depot, zone, order)
    return order.boxes
end

-- Can this player start a run here at all? Asked BEFORE payment so a refusal costs
-- nothing. Returns true, or false + the error key.
function CanBeginSupplyRun(src, depot)
    if RunBySrc[src] then return false, "supply_already_running" end
    if PendingSupplyFor(GetIdentifier(src)) then return false, "supply_order_outstanding" end
    if not depot or not freeBayAt(depot) then return false, "supply_depot_full" end
    return true
end

-- RESUME: the run ended without the order being collected (disconnect, lapsed claim, or
-- the player gave the bay up). The order is still paid for, so walking up to any free bay
-- picks it straight back up. No list, because one active order means there is never more
-- than one thing this could be.
lib.callback.register("pickle_restaurants:supply:resume", function(src, d)
    local cfg = SupplyConfig()
    if not cfg.enabled then return { ok = false, error = _L("supply_disabled") } end
    local depot, zone = findZone(cfg, tostring(d and d.depot), tostring(d and d.zone))
    if not zone then return { ok = false, error = _L("supply_no_zone") } end
    if Runs[zoneKey(depot.id, zone.id)] then return { ok = false, error = _L("supply_zone_busy") } end
    if RunBySrc[src] then return { ok = false, error = _L("supply_already_running") } end

    local order, rid = PendingSupplyFor(GetIdentifier(src))
    if not order then return { ok = false, error = _L("supply_nothing_waiting") } end
    -- The permission is re-checked, not remembered: someone fired since ordering has no
    -- business hauling that restaurant's cargo in.
    if not HasPerm(rid, src, "manage_stock") then return { ok = false, error = _L("no_permission") } end
    startRun(src, depot, zone, order)
    return { ok = true }
end)

-- The claimer's networked truck + trailer, reported the moment they exist so the server
-- can take them back out of the world if that client never gets to (crash, timeout,
-- resource restart). Same contract as `doorstep:sceneEntities`.
RegisterNetEvent("pickle_restaurants:supply:entities", function(netIds)
    local src = source
    local run = Runs[RunBySrc[src] or ""]
    if not run or run.src ~= src then return end
    for _, id in ipairs(type(netIds) == "table" and netIds or {}) do
        if tonumber(id) then run.entities[#run.entities + 1] = tonumber(id) end
    end
end)

-- Take one box off the pile. The pile is server state, so this is the ONE place it goes
-- down — the client that asked doesn't decide, it is told along with everyone else.
lib.callback.register("pickle_restaurants:supply:takeBox", function(src)
    local run = Runs[RunBySrc[src] or ""]
    if not run or run.src ~= src then return { ok = false, error = _L("supply_no_run") } end
    if run.taken > run.loaded then return { ok = false, error = _L("supply_hands_full") } end
    if run.taken >= run.boxes then return { ok = false, error = _L("supply_pile_empty") } end
    run.taken = run.taken + 1
    pushState(run.key)
    return { ok = true, carrying = true, left = run.boxes - run.taken }
end)

-- Put the carried box on the trailer. The last one finishes the run: the stock lands in
-- the larder HERE, server-side, off the order row — never off anything the client sent.
lib.callback.register("pickle_restaurants:supply:loadBox", function(src)
    local run = Runs[RunBySrc[src] or ""]
    if not run or run.src ~= src then return { ok = false, error = _L("supply_no_run") } end
    if run.taken <= run.loaded then return { ok = false, error = _L("supply_no_box") } end
    run.loaded = run.loaded + 1
    pushState(run.key)
    if run.loaded < run.boxes then
        return { ok = true, done = false, left = run.boxes - run.loaded }
    end

    -- LOADED. Credit the larder from the ORDER, mark it collected, and tell the claimer
    -- to send the rig on its way. The run stays in the table until the departure has
    -- played out so its truck is still tracked for cleanup.
    local order = SupplyCache[run.rid] and SupplyCache[run.rid][run.orderId]
    if order then
        SupplyCache[run.rid][run.orderId] = nil
        MySQL.update("UPDATE pickle_restaurant_supply_orders SET status = 'collected' WHERE id = ?", { run.orderId })
        for _, l in ipairs(order.lines or {}) do
            local qty = math.floor(tonumber(l.qty) or 0)
            if l.key and qty > 0 then AddStock(run.rid, l.key, qty) end
        end
        AddLedger(run.rid, "supply", 0, _L("ledger_supply_collected", order.units or 0), GetIdentifier(src))
        ShowNotification(src, _L("supply_run_complete"))
    end
    run.departed = true
    local key = run.key
    -- The rig leaves under the claimer's control (it is their networked vehicle), then
    -- the server tidies up whatever is left of it — including the case where they
    -- disconnect during the drive-off, which endRun covers from the dropped handler.
    SetTimeout(DEPART_MS, function() endRun(key, "departed") end)
    return { ok = true, done = true, depart = true }
end)

-- Give the bay back without finishing. The order stays PENDING — it is paid for, so it
-- waits for the next person rather than being lost.
lib.callback.register("pickle_restaurants:supply:abandon", function(src)
    local key = RunBySrc[src]
    if not key then return { ok = false } end
    endRun(key, "abandoned")
    return { ok = true }
end)

-- HYDRATION EDGE for the scoped state pushes: a client walking into a depot asks for
-- every zone it can now see, in ONE call (a depot has several bays, and a call per bay
-- on every approach is the per-seat mistake modules/mirror already learned).
lib.callback.register("pickle_restaurants:supply:state", function(src, d)
    local out = {}
    for _, key in ipairs(type(d) == "table" and d.keys or {}) do
        out[#out + 1] = runState(tostring(key))
    end
    -- Whether THIS player has a paid order still waiting, so an idle bay knows whether
    -- to offer resuming it. Answered here rather than as its own callback because it is
    -- wanted at exactly the moment this one is already being asked: walking in.
    return { ok = true, zones = out, order = PendingSupplyFor(GetIdentifier(src)) ~= nil }
end)

-- ─── authoring the depots (admin) ────────────────────────────────────────────
-- The depot LIST is written only from here, never by the Settings tab's auto-save: the
-- panel edits the scalars and the gizmo places the points, and a debounced write of the
-- whole setting racing a placement would drop the bay that was just placed. The
-- `supply_runs` sanitizer in modules/admin/server.lua enforces the other half of that
-- rule (a settings write with no `depots` key keeps the ones already stored).

local function writeDepots(depots)
    local raw = GetSetting("supply_runs", {})
    if type(raw) ~= "table" then raw = {} end
    local next_ = {}
    for k, v in pairs(raw) do next_[k] = v end
    next_.depots = depots
    SetSetting("supply_runs", next_)
    SyncWorldSoon() -- the depot points ride the world sync (BuildSyncPayload → settings.supply)
end

-- Raw (unvalidated) depots, which is what an EDITOR has to work on: SupplyConfig drops
-- a half-placed bay, and editing through it would silently delete the zone an admin is
-- part-way through placing.
local function rawDepots()
    local raw = GetSetting("supply_runs", {})
    local list = (type(raw) == "table" and type(raw.depots) == "table") and raw.depots or {}
    local out = {}
    for _, d in ipairs(list) do
        if type(d) == "table" and d.id then out[#out + 1] = d end
    end
    return out
end

-- Ids are generated, never typed: they key the runtime state, so a duplicate would make
-- two bays one bay.
local function freshId(prefix, taken)
    local n = 1
    while taken[prefix .. n] do n = n + 1 end
    return prefix .. n
end

lib.callback.register("pickle_restaurants:supply:removeDepot", function(src, d)
    if not IsPlayerAdmin(src) then return { ok = false } end
    local id = tostring(d and d.id)
    local depots, out = rawDepots(), {}
    for _, dep in ipairs(depots) do
        if dep.id ~= id then out[#out + 1] = dep end
    end
    writeDepots(out)
    return { ok = true }
end)

lib.callback.register("pickle_restaurants:supply:setDepot", function(src, d)
    if not IsPlayerAdmin(src) then return { ok = false } end
    local id = tostring(d and d.id)
    local depots = rawDepots()
    for _, dep in ipairs(depots) do
        if dep.id == id then
            if d.label ~= nil then dep.label = str(d.label, dep.label) end
            if d.blip ~= nil then dep.blip = (type(d.blip) == "table") and d.blip or nil end
        end
    end
    writeDepots(depots)
    return { ok = true }
end)

-- One bay, placed in TWO gizmo passes (the package point and the trailer point). Both
-- are required (a bay with one of them is not a bay), which is why this saves them
-- together rather than a point at a time.
--
-- No `depot` = a NEW depot, created here WITH its first bay. Placement is the only way
-- one comes into existence, exactly like a seat: an "add" button that made an empty row
-- and left the points for later would put a depot in the list that does nothing, and a
-- cancelled gizmo would strand it there.
lib.callback.register("pickle_restaurants:supply:saveZone", function(src, d)
    if not IsPlayerAdmin(src) then return { ok = false } end
    local pkg, trl = point(d and d.package), point(d and d.trailer)
    if not (pkg and trl) then return { ok = false, error = _L("supply_zone_incomplete") } end
    local depots = rawDepots()
    local depotId = d and d.depot and tostring(d.depot) or nil
    if not depotId then
        local taken = {}
        for _, dep in ipairs(depots) do taken[dep.id] = true end
        depotId = freshId("depot", taken)
        depots[#depots + 1] = {
            id = depotId, label = str(d and d.label, _L("supply_depot_default")),
            shop = point(d and d.shop), zones = {},
        }
    end
    for _, dep in ipairs(depots) do
        if dep.id == depotId then
            dep.zones = type(dep.zones) == "table" and dep.zones or {}
            local zid = d.zone and tostring(d.zone) or nil
            if zid then
                for _, z in ipairs(dep.zones) do
                    if tostring(z.id) == zid then
                        z.package, z.trailer, z.load = pkg, trl, point(d.load)
                        writeDepots(depots)
                        return { ok = true, id = zid }
                    end
                end
            end
            local taken = {}
            for _, z in ipairs(dep.zones) do taken[tostring(z.id)] = true end
            local newId = freshId("bay", taken)
            dep.zones[#dep.zones + 1] = { id = newId, package = pkg, trailer = trl, load = point(d.load) }
            writeDepots(depots)
            return { ok = true, id = newId }
        end
    end
    return { ok = false, error = _L("supply_no_depot") }
end)

lib.callback.register("pickle_restaurants:supply:removeZone", function(src, d)
    if not IsPlayerAdmin(src) then return { ok = false } end
    local depotId, zoneId = tostring(d and d.depot), tostring(d and d.zone)
    local depots = rawDepots()
    for _, dep in ipairs(depots) do
        if dep.id == depotId then
            local out = {}
            for _, z in ipairs(dep.zones or {}) do
                if tostring(z.id) ~= zoneId then out[#out + 1] = z end
            end
            dep.zones = out
        end
    end
    -- A bay being edited out from under a live run ends that run: its pile and its
    -- points no longer exist, so there is nothing left to finish.
    local key = zoneKey(depotId, zoneId)
    if Runs[key] then endRun(key, "removed") end
    writeDepots(depots)
    return { ok = true }
end)

-- Move (or first place) an existing depot's shop counter. Its own callback because the
-- shop belongs to the DEPOT while a bay's two points belong to the bay.
lib.callback.register("pickle_restaurants:supply:saveShop", function(src, d)
    if not IsPlayerAdmin(src) then return { ok = false } end
    local sp = point(d and d.shop)
    if not sp then return { ok = false, error = _L("supply_shop_incomplete") } end
    local depotId = tostring(d and d.depot)
    local depots = rawDepots()
    for _, dep in ipairs(depots) do
        if dep.id == depotId then
            dep.shop = sp
            writeDepots(depots)
            return { ok = true }
        end
    end
    return { ok = false, error = _L("supply_no_depot") }
end)

-- Which restaurants may this player order for, from a depot counter? The same gate that
-- bought supplies from the panel before: `manage_stock`.
lib.callback.register("pickle_restaurants:supply:shopFor", function(src)
    if not SupplyShopNear(src) then return { ok = false, error = _L("supply_not_at_shop") } end
    local out = {}
    for rid, r in pairs(RestaurantCache) do
        if HasPerm(rid, src, "manage_stock") then
            out[#out + 1] = { id = rid, label = r.label }
        end
    end
    table.sort(out, function(a, b) return (a.label or ""):lower() < (b.label or ""):lower() end)
    if #out == 0 then return { ok = false, error = _L("supply_shop_no_restaurant") } end
    return { ok = true, restaurants = out }
end)

-- The admin panel's own view of the depots: the RAW list (so a part-placed bay is
-- visible and fixable) plus whether each bay is in use right now.
function SupplyAdminData()
    local out = {}
    for _, dep in ipairs(rawDepots()) do
        local zones = {}
        for _, z in ipairs(dep.zones or {}) do
            zones[#zones + 1] = {
                id = tostring(z.id),
                package = point(z.package), trailer = point(z.trailer), load = point(z.load),
                busy = Runs[zoneKey(dep.id, z.id)] ~= nil or nil,
            }
        end
        out[#out + 1] = { id = dep.id, label = dep.label, blip = dep.blip,
                          shop = point(dep.shop), zones = zones }
    end
    return out
end

CreateThread(function()
    while not RestaurantsReady do Wait(200) end
    LoadSupplyOrders()
end)

-- Nothing spawned by this module survives a restart: the haulage rigs are networked, so
-- they would be left standing in every depot with nobody able to move them.
AddEventHandler("onResourceStop", function(res)
    if res ~= GetCurrentResourceName() then return end
    for key in pairs(Runs) do endRun(key, "shutdown") end
end)
