-- ─────────────────────────────────────────────────────────────────────────────
-- modules/phone — companion phone app backend
--
-- A DoorDash/Uber-Eats-style phone app for pickle_restaurants. The UI is the React
-- build served at nui/phone.html and hosted inside the phone's app iframe; this file
-- is the SERVER contract behind it. It leans on the existing engine globals for the
-- heavy lifting (BuildPricedCatalog / CreateOrder / AdjustBalance / HasPerm / the
-- sales:orders broadcast) and only OWNS the genuinely-new customer/staff/social
-- surfaces: reviews, loyalty punch-cards, favorites, shifts + tip pool, promotions,
-- reservations, the sales-analytics rollup, the top-chef leaderboard, and cooking
-- achievements.
--
-- Order PLACEMENT + COMPLETION stay in modules/sales/server.lua (that's where the
-- private pricing/fulfilment machinery lives) — this module only reads/annotates
-- them and reacts to the `pickle_restaurants:internal:orderCompleted` seam sales
-- fires on a completed ticket.
-- ─────────────────────────────────────────────────────────────────────────────

-- ─── caches (module-global, write-through like the rest of the engine) ─────────
ReviewCache      = {}   -- [restaurantId] = { rows = { review, ... }, avg, count }
LoyaltyCache     = {}   -- [restaurantId][identifier] = { punches, redeemed }
PromoCache       = {}   -- [restaurantId] = { promo, ... } (active only)
ReservationCache = {}   -- [restaurantId][id] = reservation row
ShiftCache       = {}   -- [restaurantId][identifier] = open shift row (clocked in)
CookStatCache    = {}   -- [restaurantId][identifier] = { name, cooked, revenue }
AchievementCache = {}   -- [identifier][key] = { progress, unlocked }

-- Cooking achievement ladder (progress = lifetime tickets cooked by this player).
-- Purely additive/social — unlocking one just posts a phone notification + badge.
PHONE_ACHIEVEMENTS = {
    { key = "first_cook",  label = _L("ach_first_cook"), desc = _L("ach_first_cook_desc"), goal = 1 },
    { key = "line_cook",   label = _L("ach_line_cook"),  desc = _L("ach_line_cook_desc"),  goal = 25 },
    { key = "sous_chef",   label = _L("ach_sous_chef"),  desc = _L("ach_sous_chef_desc"),  goal = 100 },
    { key = "head_chef",   label = _L("ach_head_chef"),  desc = _L("ach_head_chef_desc"),  goal = 500 },
    { key = "iron_chef",   label = _L("ach_iron_chef"),  desc = _L("ach_iron_chef_desc"),  goal = 1000 },
}

local function LoyaltyGoal()  return math.max(2, math.floor(tonumber(GetSetting("loyalty_goal", 8)) or 8)) end
local function LoyaltyOn()    return GetSetting("loyalty_enabled", true) ~= false end

-- ─── schema ────────────────────────────────────────────────────────────────────
local function CreatePhoneTables()
    MySQL.query.await([[
        CREATE TABLE IF NOT EXISTS `pickle_restaurant_reviews` (
            `id` INT UNSIGNED NOT NULL AUTO_INCREMENT,
            `restaurant_id` INT UNSIGNED NOT NULL,
            `identifier` VARCHAR(80) NOT NULL,
            `name` VARCHAR(100) DEFAULT NULL,
            `rating` TINYINT UNSIGNED NOT NULL DEFAULT 5,
            `comment` TEXT DEFAULT NULL,
            `photo` TEXT DEFAULT NULL,
            `created_at` TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
            PRIMARY KEY (`id`),
            KEY `idx_rest` (`restaurant_id`)
        )
    ]])
    MySQL.query.await([[
        CREATE TABLE IF NOT EXISTS `pickle_restaurant_loyalty` (
            `restaurant_id` INT UNSIGNED NOT NULL,
            `identifier` VARCHAR(80) NOT NULL,
            `punches` INT UNSIGNED NOT NULL DEFAULT 0,
            `redeemed` INT UNSIGNED NOT NULL DEFAULT 0,
            `updated_at` TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
            PRIMARY KEY (`restaurant_id`, `identifier`)
        )
    ]])
    MySQL.query.await([[
        CREATE TABLE IF NOT EXISTS `pickle_restaurant_favorites` (
            `id` INT UNSIGNED NOT NULL AUTO_INCREMENT,
            `identifier` VARCHAR(80) NOT NULL,
            `restaurant_id` INT UNSIGNED NOT NULL,
            `label` VARCHAR(80) DEFAULT NULL,
            `cart` JSON NOT NULL,
            `created_at` TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
            PRIMARY KEY (`id`),
            KEY `idx_owner` (`identifier`)
        )
    ]])
    MySQL.query.await([[
        CREATE TABLE IF NOT EXISTS `pickle_restaurant_shifts` (
            `id` INT UNSIGNED NOT NULL AUTO_INCREMENT,
            `restaurant_id` INT UNSIGNED NOT NULL,
            `identifier` VARCHAR(80) NOT NULL,
            `name` VARCHAR(100) DEFAULT NULL,
            `clock_in` TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
            `clock_out` TIMESTAMP NULL DEFAULT NULL,
            `seconds` INT UNSIGNED NOT NULL DEFAULT 0,
            `tips` INT NOT NULL DEFAULT 0,
            `orders_cooked` INT UNSIGNED NOT NULL DEFAULT 0,
            PRIMARY KEY (`id`),
            KEY `idx_rest_open` (`restaurant_id`, `clock_out`)
        )
    ]])
    MySQL.query.await([[
        CREATE TABLE IF NOT EXISTS `pickle_restaurant_promos` (
            `id` INT UNSIGNED NOT NULL AUTO_INCREMENT,
            `restaurant_id` INT UNSIGNED NOT NULL,
            `label` VARCHAR(80) NOT NULL,
            `percent` TINYINT UNSIGNED NOT NULL DEFAULT 10,
            `kind` VARCHAR(16) NOT NULL DEFAULT 'discount',
            `active` TINYINT UNSIGNED NOT NULL DEFAULT 1,
            `created_at` TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
            PRIMARY KEY (`id`),
            KEY `idx_rest` (`restaurant_id`)
        )
    ]])
    MySQL.query.await([[
        CREATE TABLE IF NOT EXISTS `pickle_restaurant_reservations` (
            `id` INT UNSIGNED NOT NULL AUTO_INCREMENT,
            `restaurant_id` INT UNSIGNED NOT NULL,
            `identifier` VARCHAR(80) NOT NULL,
            `name` VARCHAR(100) DEFAULT NULL,
            `party` TINYINT UNSIGNED NOT NULL DEFAULT 2,
            `slot` VARCHAR(20) DEFAULT NULL,
            `status` VARCHAR(12) NOT NULL DEFAULT 'booked',
            `created_at` TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
            PRIMARY KEY (`id`),
            KEY `idx_rest` (`restaurant_id`)
        )
    ]])
    MySQL.query.await([[
        CREATE TABLE IF NOT EXISTS `pickle_restaurant_achievements` (
            `identifier` VARCHAR(80) NOT NULL,
            `akey` VARCHAR(40) NOT NULL,
            `progress` INT UNSIGNED NOT NULL DEFAULT 0,
            `unlocked_at` TIMESTAMP NULL DEFAULT NULL,
            PRIMARY KEY (`identifier`, `akey`)
        )
    ]])
    MySQL.query.await([[
        CREATE TABLE IF NOT EXISTS `pickle_restaurant_cook_stats` (
            `restaurant_id` INT UNSIGNED NOT NULL,
            `identifier` VARCHAR(80) NOT NULL,
            `name` VARCHAR(100) DEFAULT NULL,
            `cooked` INT UNSIGNED NOT NULL DEFAULT 0,
            `revenue` BIGINT NOT NULL DEFAULT 0,
            PRIMARY KEY (`restaurant_id`, `identifier`)
        )
    ]])
    -- Delivery chat (customer ⇄ driver). Persisted, not just cached: a conversation
    -- between two players is what admins get asked to adjudicate ("the driver was
    -- abusive", "I gave them the gate code and they never came"), and an in-memory-only
    -- thread also loses an active conversation to a server restart mid-run.
    -- `identifier` is kept alongside the display name so a log entry survives a rename.
    MySQL.query.await([[
        CREATE TABLE IF NOT EXISTS `pickle_restaurant_delivery_chat` (
            `id` INT UNSIGNED NOT NULL AUTO_INCREMENT,
            `restaurant_id` INT UNSIGNED NOT NULL,
            `order_id` INT UNSIGNED NOT NULL,
            `identifier` VARCHAR(80) NOT NULL,
            `role` VARCHAR(10) NOT NULL,
            `name` VARCHAR(100) DEFAULT NULL,
            `text` VARCHAR(255) NOT NULL,
            `created_at` TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
            PRIMARY KEY (`id`),
            KEY `idx_order` (`order_id`),
            KEY `idx_age` (`created_at`)
        )
    ]])

    if GetSetting("loyalty_goal", nil) == nil then SetSetting("loyalty_goal", 8) end
    if GetSetting("loyalty_enabled", nil) == nil then SetSetting("loyalty_enabled", true) end
end

-- ─── cache loaders ──────────────────────────────────────────────────────────────
local function ReviewAvg(rows)
    if #rows == 0 then return 0 end
    local sum = 0
    for _, r in ipairs(rows) do sum = sum + (tonumber(r.rating) or 0) end
    return math.floor((sum / #rows) * 10 + 0.5) / 10
end

local function LoadReviews()
    ReviewCache = {}
    local rows = MySQL.query.await(
        "SELECT id, restaurant_id, identifier, name, rating, comment, photo, created_at FROM pickle_restaurant_reviews ORDER BY id DESC") or {}
    for _, row in ipairs(rows) do
        local rid = row.restaurant_id
        ReviewCache[rid] = ReviewCache[rid] or { rows = {}, avg = 0, count = 0 }
        ReviewCache[rid].rows[#ReviewCache[rid].rows + 1] = row
    end
    for _, entry in pairs(ReviewCache) do
        entry.count = #entry.rows
        entry.avg = ReviewAvg(entry.rows)
    end
end

local function LoadLoyalty()
    LoyaltyCache = {}
    for _, row in ipairs(MySQL.query.await("SELECT restaurant_id, identifier, punches, redeemed FROM pickle_restaurant_loyalty") or {}) do
        LoyaltyCache[row.restaurant_id] = LoyaltyCache[row.restaurant_id] or {}
        LoyaltyCache[row.restaurant_id][row.identifier] = { punches = row.punches, redeemed = row.redeemed }
    end
end

local function LoadPromos()
    PromoCache = {}
    for _, row in ipairs(MySQL.query.await("SELECT id, restaurant_id, label, percent, kind, active FROM pickle_restaurant_promos WHERE active = 1") or {}) do
        PromoCache[row.restaurant_id] = PromoCache[row.restaurant_id] or {}
        PromoCache[row.restaurant_id][#PromoCache[row.restaurant_id] + 1] = row
    end
end

-- A reservation is not just a row any more: it HOLDS seat anchors and may ADMIT
-- guests, so both children are loaded onto the cached row (`seats` = array of prop
-- ids, `guests` = array of { identifier, name }). Everything downstream — the sit
-- gate in modules/seating, the `reservedSeats` sync map, the phone screens — reads
-- the cache, never these tables, so the two lists have to be there from boot.
-- `created_ts` rides along because the "now" slot's window starts at CREATION, and
-- ReservationActive (core/server.lua) needs a number to compare against os.time().
local function LoadReservations()
    ReservationCache = {}
    -- Prune the children of reservations that are no longer live FIRST. Cancelling and
    -- the expiry sweep both free their own seats, but a crash between the two writes (or
    -- a row cancelled straight in the database) would otherwise leave an anchor held by a
    -- reservation nobody can cancel — a seat locked forever, with no in-game way back.
    -- This is a prune, like the delivery-chat retention sweep, not a migration.
    for _, tbl in ipairs({ "pickle_restaurant_reservation_seats", "pickle_restaurant_reservation_guests" }) do
        MySQL.query.await(("DELETE FROM `%s` WHERE `reservation_id` NOT IN (SELECT `id` FROM `pickle_restaurant_reservations` WHERE `status` = 'booked')"):format(tbl))
    end
    local byId = {}
    for _, row in ipairs(MySQL.query.await([[
        SELECT id, restaurant_id, identifier, name, party, slot, status,
               created_at, UNIX_TIMESTAMP(created_at) AS created_ts
          FROM pickle_restaurant_reservations WHERE status = 'booked'
    ]]) or {}) do
        row.seats, row.guests = {}, {}
        ReservationCache[row.restaurant_id] = ReservationCache[row.restaurant_id] or {}
        ReservationCache[row.restaurant_id][row.id] = row
        byId[row.id] = row
    end
    for _, s in ipairs(MySQL.query.await("SELECT reservation_id, prop_id FROM pickle_restaurant_reservation_seats") or {}) do
        local row = byId[s.reservation_id]
        -- Rows whose reservation is gone (cancelled/expired between the two queries)
        -- are simply dropped: the sweep deletes them, and a held seat with no live
        -- reservation would lock an anchor nobody can free.
        if row then row.seats[#row.seats + 1] = tonumber(s.prop_id) end
    end
    for _, g in ipairs(MySQL.query.await("SELECT reservation_id, identifier, name FROM pickle_restaurant_reservation_guests") or {}) do
        local row = byId[g.reservation_id]
        if row then row.guests[#row.guests + 1] = { identifier = g.identifier, name = g.name } end
    end
end

local function LoadCookStats()
    CookStatCache = {}
    for _, row in ipairs(MySQL.query.await("SELECT restaurant_id, identifier, name, cooked, revenue FROM pickle_restaurant_cook_stats") or {}) do
        CookStatCache[row.restaurant_id] = CookStatCache[row.restaurant_id] or {}
        CookStatCache[row.restaurant_id][row.identifier] = { name = row.name, cooked = row.cooked, revenue = row.revenue }
    end
end

local function LoadAchievements()
    AchievementCache = {}
    for _, row in ipairs(MySQL.query.await("SELECT identifier, akey, progress, unlocked_at FROM pickle_restaurant_achievements") or {}) do
        AchievementCache[row.identifier] = AchievementCache[row.identifier] or {}
        AchievementCache[row.identifier][row.akey] = { progress = row.progress, unlocked = row.unlocked_at ~= nil }
    end
end

-- Reopen shifts that were open when the resource restarted (best-effort — a crash
-- mid-shift shouldn't strand someone clocked-in forever, so we just drop them here;
-- they clock in fresh). We don't auto-close in DB, just skip stale cache seeding.
CreateThread(function()
    while not RestaurantsReady do Wait(200) end
    CreatePhoneTables()
    -- Restore in-flight delivery drop points. MUST run here (not in modules/sales,
    -- which owns DeliveryTargets): this is the first point where the dest_x/dest_y
    -- columns are guaranteed to exist — CreatePhoneTables adds them, and core's
    -- LoadOrders runs before any module boot thread.
    if RehydrateDeliveryTargets then RehydrateDeliveryTargets() end
    LoadReviews(); LoadLoyalty(); LoadPromos(); LoadReservations(); LoadCookStats(); LoadAchievements()
    PhoneReady = true
    print("[pickle_restaurants] phone companion backend ready")
end)

-- ─── helpers ─────────────────────────────────────────────────────────────────────
local function Now() return os.time() end

-- Best active promo for a restaurant → { label, percent, kind } or nil. Happy-hour
-- and flat discounts both just reduce the cart total by `percent`; the biggest wins.
function ActivePromo(rid)
    local best
    for _, p in ipairs(PromoCache[rid] or {}) do
        if not best or p.percent > best.percent then best = p end
    end
    if not best then return nil end
    return { id = best.id, label = best.label, percent = best.percent, kind = best.kind }
end

-- The employment context for a source at every restaurant they can act on: which
-- ones they work at, their effective perms, and whether they're a boss (owner/admin
-- or a boss GRADE). Used to decide which phone tabs (Kitchen / Manage) to surface.
--
-- Employment is a JOB now, not a payroll row: a restaurant names a framework job in
-- `metadata.job` and anyone holding that job works there at their grade's rank. We
-- don't compare the two ourselves — ResolvePerms is the ONE authority and already
-- does (admin → owner → job+rank), and its 3rd return is the player's job info, which
-- is what carries the grade the phone prints. Asking it is also what keeps a role it
-- learns about later (an admin, the owner) working here without a second special case.
local function EmploymentFor(src)
    local id = GetIdentifier(src)
    local out = {}
    for rid, r in pairs(RestaurantCache) do
        local perms, isBoss, job = ResolvePerms(rid, src)
        if perms then
            out[#out + 1] = {
                id = rid, label = r.label,
                -- `isOwner` is kept as the name the app already reads (it has always
                -- meant "may do everything here"), with isBoss alongside it for the
                -- new copy — a boss grade is not the owner, but holds the same keys.
                isOwner = isBoss or false,
                isBoss  = isBoss or false,
                job     = RestaurantJob and RestaurantJob(rid) or nil,
                grade      = job and job.grade or nil,
                gradeLabel = job and job.gradeLabel or nil,
                perms = perms,
                clockedIn = ShiftCache[rid] ~= nil and ShiftCache[rid][id] ~= nil,
            }
        end
    end
    return out
end

-- A compact, display-safe restaurant card for the customer feed.
function RestaurantCard(r, playerCoords)
    local rev = ReviewCache[r.id]
    local counter = r.counter
    local dist
    if playerCoords and counter and counter.x then
        local dx, dy = counter.x - playerCoords.x, counter.y - playerCoords.y
        dist = math.floor(math.sqrt(dx * dx + dy * dy))
    end
    -- "Open" heuristic: staff clocked in, else has a counter anchor + menu enabled.
    local staffOn = false
    for _ in pairs(ShiftCache[r.id] or {}) do staffOn = true break end
    return {
        id      = r.id,
        label   = r.label or r.name,
        theme   = r.metadata and r.metadata.theme or nil,
        brand   = r.metadata and (r.metadata.phone_image or r.metadata.brand_image) or nil,
        coords  = counter and { x = counter.x, y = counter.y } or nil,
        rating  = rev and rev.avg or 0,
        reviews = rev and rev.count or 0,
        promo   = ActivePromo(r.id),
        dist    = dist,
        open    = (r.menu_enabled ~= 0) and (staffOn or (counter ~= nil)),
        staffOn = staffOn,
    }
end

-- ─── shift lookups (globals — modules/npc_customers gates spawning on these) ──────
-- "On shift" is CLOCKED IN, which is deliberately stricter than "employed and nearby":
-- a cook standing in the kitchen off the clock isn't working, and NPC demand keying off
-- mere presence meant a restaurant generated trade nobody had signed on to serve.

-- Is anyone at all on shift at this restaurant right now?
function AnyoneClockedIn(rid)
    for _ in pairs(ShiftCache[rid] or {}) do return true end
    return false
end

-- Is THIS player on shift here?
function IsClockedIn(rid, src)
    local sc = ShiftCache[rid]
    return (sc and sc[GetIdentifier(src)]) ~= nil
end

-- The ONLINE server ids clocked in here. This is the audience for the phone's kitchen
-- board (the KDS), which is the one staff surface that is NOT at the restaurant: a
-- manager reads the queue from anywhere, so SyncOrders can't find them by distance.
-- Resolving identifier→source costs a player scan each, so it walks the shift set (a
-- handful) rather than every connected player.
function ClockedInSources(rid)
    local out = {}
    for ident in pairs(ShiftCache[rid] or {}) do
        local src = ResolveSourceForIdentifier and ResolveSourceForIdentifier(ident) or nil
        if src then out[#out + 1] = src end
    end
    return out
end

-- ─── notifications through the phone ─────────────────────────────────────────────
-- Server-side push to a player's equipped phone. `PhoneAppNotify` is defined by
-- whichever bridge/phone/* variant matched an installed phone — nil when the server
-- runs none, so this is a no-op rather than an error in every caller.
function PhoneNotify(src, title, content, thumbnail)
    if not PhoneAppNotify then return end
    PhoneAppNotify(src, title, content, thumbnail)
end

-- ─────────────────────────────────────────────────────────────────────────────
-- DELIVERY CHAT — a two-party thread between a customer and their driver.
--
-- Write-through, like the rest of the engine: every message hits MySQL AND the cache,
-- and reads come off the cache. Chat is PERSISTED rather than transient (unlike the
-- claim it hangs off) because a conversation between two players is an admin record —
-- it's what gets adjudicated after the fact — and because an in-memory thread loses an
-- active conversation to a server restart mid-run. Rows are pruned on boot; the CACHE
-- is dropped when the ticket closes, since nothing reads a finished order's thread.
--
-- Strictly TWO-party. Not the restaurant, not the boss, not an admin — the gate is
-- "are you this order's customer, or the driver currently holding it", re-checked on
-- every single call, because the claim can change mid-conversation.
-- ─────────────────────────────────────────────────────────────────────────────
DeliveryChat = {}          -- [orderId] = { { role, name, text, at }, … } (hot threads)

local CHAT_KEEP       = 40    -- messages held in memory per order (oldest dropped)
local CHAT_MAX_LEN    = 200
local CHAT_MIN_MS     = 700   -- floor between messages from one player
local CHAT_RETAIN_DAYS = 14   -- how long the log is kept before pruning. TUNE.
local ChatRate        = {}    -- [src] = last send (GetGameTimer)

AddEventHandler("playerDropped", function() ChatRate[source] = nil end)

-- The log is an audit trail, not an archive — without this it grows forever. Runs once
-- on boot rather than on a timer: a server that never restarts isn't accumulating
-- meaningful volume either (a handful of rows per delivery).
CreateThread(function()
    while not PhoneReady do Wait(1000) end
    -- Interpolated, not bound: a placeholder inside an INTERVAL expression is a known
    -- rough edge across MySQL/MariaDB prepared statements. Safe here — the value is a
    -- local numeric constant, never user input.
    MySQL.query(("DELETE FROM `pickle_restaurant_delivery_chat` WHERE `created_at` < (NOW() - INTERVAL %d DAY)")
        :format(CHAT_RETAIN_DAYS))
end)

-- Rehydrate one ticket's thread from the log. Only ever needed when the server
-- restarted mid-delivery: the order is reloaded and still open, but its cache entry is
-- gone. Reads the tail, oldest-first, so the UI order matches a live thread exactly.
local function ChatLoad(orderId)
    local rows = MySQL.query.await([[
        SELECT `role`, `name`, `text`, UNIX_TIMESTAMP(`created_at`) AS `at`
          FROM `pickle_restaurant_delivery_chat`
         WHERE `order_id` = ?
         ORDER BY `id` DESC LIMIT ?
    ]], { orderId, CHAT_KEEP }) or {}
    local thread = {}
    for i = #rows, 1, -1 do
        local r = rows[i]
        thread[#thread + 1] = { role = r.role, name = r.name, text = r.text, at = tonumber(r.at) }
    end
    DeliveryChat[orderId] = thread
    return thread
end

-- modules/sales has a function of this name, but it's a forward-declared LOCAL there
-- (`local findPlayerByIdentifier` above its definition), so it isn't reachable from
-- another file no matter how global the definition looks. Hence our own copy.
local function ChatFindPlayer(identifier)
    if not identifier then return nil end
    for _, p in ipairs(GetPlayers()) do
        p = tonumber(p)
        if GetIdentifier(p) == identifier then return p end
    end
end

-- Resolves the caller's SIDE of this ticket, or an error for anyone else.
local function ChatParty(src, rid, orderId)
    local o = OrderCache[rid] and OrderCache[rid][orderId]
    if not o or o.status ~= "open" then return nil, nil, _L("order_not_open") end
    if o.order_type ~= "delivery" then return nil, nil, _L("chat_not_delivery") end
    local me = GetIdentifier(src)
    if o.customer_identifier == me then return o, "customer" end
    if o.driver_identifier and o.driver_identifier == me then return o, "driver" end
    return nil, nil, _L("chat_not_yours")
end

-- Deliver to BOTH sides (including the sender, so their own message lands the same way
-- the other side's does — one render path, no optimistic-echo divergence).
local function ChatPush(o, rid, msg)
    for _, ident in ipairs({ o.customer_identifier, o.driver_identifier }) do
        local s = ChatFindPlayer(ident)
        if s then
            TriggerClientEvent("pickle_restaurants:phone:chat", s,
                { orderId = o.id, rid = rid, message = msg })
        end
    end
end

-- Called by the order-close paths in modules/sales (alongside DeliveryTargets). Drops
-- the CACHE only — the logged rows stay for moderation until the retention prune.
function ClearDeliveryChat(orderId)
    DeliveryChat[orderId] = nil
end

lib.callback.register("pickle_restaurants:phone:chatHistory", function(src, d)
    local rid, oid = tonumber(d and d.id), tonumber(d and d.orderId)
    local o, role, err = ChatParty(src, rid, oid)
    if not o then return { ok = false, error = err } end
    -- nil (not empty) means this thread was never cached — a restart mid-run. An empty
    -- table is a real "no messages yet" and must NOT re-query on every open.
    local thread = DeliveryChat[oid] or ChatLoad(oid)
    return { ok = true, role = role, messages = thread }
end)

lib.callback.register("pickle_restaurants:phone:chatSend", function(src, d)
    local rid, oid = tonumber(d and d.id), tonumber(d and d.orderId)
    local o, role, err = ChatParty(src, rid, oid)
    if not o then return { ok = false, error = err } end

    local now = GetGameTimer()
    if ChatRate[src] and now - ChatRate[src] < CHAT_MIN_MS then
        return { ok = false, error = _L("chat_too_fast") }
    end

    -- Collapse all whitespace (newlines included — the bubble is one run of text) and
    -- clamp the length. The NUI is untrusted, so the cap is enforced HERE, not by the
    -- input's maxlength.
    local text = (tostring(d.text or ""):gsub("%s+", " "))
    text = (text:gsub("^%s*(.-)%s*$", "%1"))
    if text == "" then return { ok = false, error = _L("chat_empty") } end
    if #text > CHAT_MAX_LEN then text = text:sub(1, CHAT_MAX_LEN) end
    ChatRate[src] = now

    local thread = DeliveryChat[oid] or ChatLoad(oid)
    local msg = {
        role = role,
        name = GetPlayerCharacterName and GetPlayerCharacterName(src) or nil,
        text = text,
        at   = os.time(),
    }
    thread[#thread + 1] = msg
    -- Trim the CACHE from the front so a long run can't grow it without bound. The log
    -- keeps every message — this only bounds what's held in memory and re-sent on open.
    while #thread > CHAT_KEEP do table.remove(thread, 1) end

    -- Write-through. Fire-and-forget: the message is already in the cache and on its
    -- way to both phones, so a slow insert must never stall the send. A lost row costs
    -- the audit log one line, never the conversation.
    MySQL.insert("INSERT INTO `pickle_restaurant_delivery_chat` (restaurant_id, order_id, identifier, role, name, text) VALUES (?, ?, ?, ?, ?, ?)",
        { rid, oid, GetIdentifier(src), role, msg.name, text })

    ChatPush(o, rid, msg)

    -- Nudge the OTHER side's phone: a chat nobody sees isn't a chat. The sender never
    -- notifies themself, and an offline counterpart simply misses it (the thread is
    -- still there when they open the ticket).
    local otherIdent = (role == "customer") and o.driver_identifier or o.customer_identifier
    local otherSrc = ChatFindPlayer(otherIdent)
    if otherSrc then
        PhoneNotify(otherSrc, _L("chat_notify_title", msg.name or "?"), text)
    end
    return { ok = true }
end)

-- ─────────────────────────────────────────────────────────────────────────────
-- HOME — the app bootstrap for a customer opening the app.
-- ─────────────────────────────────────────────────────────────────────────────
lib.callback.register("pickle_restaurants:phone:home", function(src, d)
    if not PhoneReady then return { ok = false, error = _L("phone_loading") } end
    local id = GetIdentifier(src)
    local coords = d and d.coords or nil

    local cards = {}
    for _, r in pairs(RestaurantCache) do
        cards[#cards + 1] = RestaurantCard(r, coords)
    end
    table.sort(cards, function(a, b)
        if a.open ~= b.open then return a.open end
        if (a.dist or 1e9) ~= (b.dist or 1e9) then return (a.dist or 1e9) < (b.dist or 1e9) end
        return (a.rating or 0) > (b.rating or 0)
    end)

    -- Favorites (saved carts) for the reorder shortcut.
    local favorites = MySQL.query.await(
        "SELECT id, restaurant_id, label, cart, created_at FROM pickle_restaurant_favorites WHERE identifier = ? ORDER BY id DESC LIMIT 20", { id }) or {}
    for _, f in ipairs(favorites) do
        f.cart = f.cart and json.decode(f.cart) or {}
        local r = GetRestaurant(f.restaurant_id)
        f.restaurant = r and (r.label or r.name) or "Closed"
    end

    -- The player's own live + recent orders (across all restaurants).
    local orders = PlayerOrders(id, 8)

    -- Loyalty summary across restaurants the player has punches at.
    local loyalty = {}
    for rid, byId in pairs(LoyaltyCache) do
        local l = byId[id]
        if l and (l.punches > 0 or l.redeemed > 0) then
            local r = GetRestaurant(rid)
            loyalty[#loyalty + 1] = {
                id = rid, label = r and (r.label or r.name) or ("#" .. rid),
                punches = l.punches, goal = LoyaltyGoal(), redeemed = l.redeemed,
            }
        end
    end

    return {
        ok         = true,
        name       = GetPlayerCharacterName(src),
        currency   = _L("currency_symbol"),
        -- ONE global phone skin (the `phone_theme` setting) — NOT per-restaurant. The
        -- app applies this once on boot and keeps it for every storefront it browses.
        theme      = GetSetting("phone_theme", nil),
        restaurants= cards,
        favorites  = favorites,
        orders     = orders,
        loyalty    = loyalty,
        loyaltyGoal= LoyaltyGoal(),
        loyaltyOn  = LoyaltyOn(),
        employment = EmploymentFor(src),
        achievements = PlayerAchievements(id),
    }
end)

-- Map payload for one order row → what the in-app Leaflet map needs to draw:
-- the restaurant pin (the counter anchor, RecomputeCounterAnchor's cached point) and,
-- for a delivery, the drop pin. Returns nil when NEITHER coordinate is resolvable —
-- the UI treats an absent `map` key as "this ticket has no map".
local function OrderMap(o, r)
    local otype = (o.order_type == "delivery") and "delivery" or "pickup"
    local counter = r and r.counter
    local rest = (counter and counter.x) and { x = counter.x + 0.0, y = counter.y + 0.0 } or nil

    local dest
    if otype == "delivery" then
        local dx, dy = tonumber(o.dest_x), tonumber(o.dest_y)
        -- Fall back to the live in-memory target when the row has no drop point.
        if (not dx or not dy) and DeliveryTargets and DeliveryTargets[o.id] then
            dx, dy = tonumber(DeliveryTargets[o.id].x), tonumber(DeliveryTargets[o.id].y)
        end
        if dx and dy then dest = { x = dx + 0.0, y = dy + 0.0 } end
    end

    if not rest and not dest then return nil end
    return { restaurant = rest, dest = dest, type = otype }
end

-- Player's orders (live open + recent closed), newest first. Reads the orders table
-- directly (cache only holds OPEN rows) and annotates each with a coarse phone
-- status for the tracking screen.
function PlayerOrders(identifier, limit)
    local rows = MySQL.query.await([[
        SELECT o.id, o.restaurant_id, o.ticket, o.total, o.status, o.order_type,
               o.scheduled_for, o.address, o.dest_x, o.dest_y, o.rated,
               o.created_at, o.closed_at, o.`lines`
          FROM `pickle_restaurant_orders` o
         WHERE o.customer_identifier = ?
         ORDER BY o.id DESC LIMIT ?
    ]], { identifier, limit or 12 }) or {}
    local out = {}
    for _, o in ipairs(rows) do
        local r = GetRestaurant(o.restaurant_id)
        local lines = o.lines and json.decode(o.lines) or {}
        -- Live fulfilment readiness (only meaningful while open + cached).
        local ready = false
        local cached = OrderCache[o.restaurant_id] and OrderCache[o.restaurant_id][o.id]
        if cached and OrderReadyForPickup then ready = OrderReadyForPickup(o.restaurant_id, o.id) end
        -- Has a driver actually CLAIMED this delivery? Distinct from `ready`, which
        -- only says the kitchen can fulfil it — the tracking UI needs both, or a cooked
        -- order announces a driver that nobody has assigned. The claim is transient
        -- (in-memory, released on cancel/disconnect), so it's only ever true while cached.
        local driving = (cached and cached.driver_identifier ~= nil) or false
        out[#out + 1] = {
            orderId    = o.id,
            ticket     = o.ticket,
            restaurant = r and (r.label or r.name) or ("Restaurant #" .. o.restaurant_id),
            restaurantId = o.restaurant_id,
            theme      = r and r.metadata and r.metadata.theme or nil,
            total      = o.total,
            status     = o.status,
            type       = o.order_type or "pickup",
            scheduled  = o.scheduled_for,
            address    = o.address,
            rated      = (o.rated or 0) == 1,
            ready      = ready,
            driving    = driving,
            map        = OrderMap(o, r),
            lines      = lines,
            createdAt  = o.created_at,
            closedAt   = o.closed_at,
        }
    end
    return out
end

-- Every placed seat anchor at a restaurant (modules/seating props), lowest prop id
-- first. A reservation HOLDS specific anchors out of this list, so allocation has to
-- walk it in a stable order — otherwise two bookings a second apart could pick the
-- same "first free" seat in a different order and read as a different table each time.
-- A restaurant with no seats placed can't be reserved at all (nowhere to seat the
-- party), so capacity is 0 and booking is refused — we never guess a default.
-- Defined up here, above the reservations section it belongs to, because the MENU
-- payload reports the count too: booking a table is reached from the storefront, and
-- a restaurant with no seating shouldn't offer the row.
local function SeatAnchors(rid)
    local out = {}
    for _, p in pairs(PropCache or {}) do
        if p.restaurant_id == rid and p.prop_type == "seat" then out[#out + 1] = p.id end
    end
    table.sort(out)
    return out
end

local function SeatCapacity(rid) return #SeatAnchors(rid) end

-- ─────────────────────────────────────────────────────────────────────────────
-- MENU — the storefront for one restaurant (public, display-safe).
-- ─────────────────────────────────────────────────────────────────────────────
lib.callback.register("pickle_restaurants:phone:menu", function(src, d)
    local id = tonumber(d and d.id)
    local r = GetRestaurant(id)
    if not r then return { ok = false, error = _L("phone_restaurant_unavailable") } end

    local catalog = select(1, BuildPricedCatalog(id, true))
    local rev = ReviewCache[id]
    local reviews = {}
    if rev then
        for i = 1, math.min(#rev.rows, 30) do
            local row = rev.rows[i]
            reviews[#reviews + 1] = {
                name = row.name or "Guest", rating = row.rating,
                comment = row.comment, photo = row.photo, createdAt = row.created_at,
            }
        end
    end

    local pid = GetIdentifier(src)
    local l = LoyaltyCache[id] and LoyaltyCache[id][pid]
    return {
        ok        = true,
        id        = id,
        label     = r.label or r.name,
        theme     = r.metadata and r.metadata.theme or nil,
        brand     = r.metadata and (r.metadata.phone_image or r.metadata.brand_image) or nil,
        catalog   = catalog,
        promo     = ActivePromo(id),
        rating    = rev and rev.avg or 0,
        reviewCount = rev and rev.count or 0,
        reviews   = reviews,
        loyalty   = { punches = l and l.punches or 0, goal = LoyaltyGoal(), on = LoyaltyOn() },
        seats     = SeatCapacity(id), -- 0 = nowhere to seat a party; hides "reserve a table"
        currency  = _L("currency_symbol"),
    }
end)

-- ─────────────────────────────────────────────────────────────────────────────
-- FAVORITES / reorder
-- ─────────────────────────────────────────────────────────────────────────────
lib.callback.register("pickle_restaurants:phone:saveFavorite", function(src, d)
    local id = GetIdentifier(src)
    local rid = tonumber(d and d.id)
    if not GetRestaurant(rid) then return { ok = false } end
    local cart = d.cart
    if type(cart) ~= "table" or #cart == 0 then return { ok = false, error = _L("phone_nothing_to_save") } end
    local label = tostring(d.label or "Favorite"):sub(1, 60)
    local fid = MySQL.insert.await(
        "INSERT INTO pickle_restaurant_favorites (identifier, restaurant_id, label, cart) VALUES (?, ?, ?, ?)",
        { id, rid, label, json.encode(cart) })
    return { ok = fid ~= nil, id = fid }
end)

lib.callback.register("pickle_restaurants:phone:deleteFavorite", function(src, d)
    local id = GetIdentifier(src)
    MySQL.update.await("DELETE FROM pickle_restaurant_favorites WHERE id = ? AND identifier = ?", { tonumber(d.id), id })
    return { ok = true }
end)

-- ─────────────────────────────────────────────────────────────────────────────
-- REVIEWS & RATINGS
-- ─────────────────────────────────────────────────────────────────────────────
lib.callback.register("pickle_restaurants:phone:submitReview", function(src, d)
    local id = GetIdentifier(src)
    local rid = tonumber(d and d.id)
    if not GetRestaurant(rid) then return { ok = false } end
    local rating = math.max(1, math.min(5, math.floor(tonumber(d.rating) or 5)))
    -- Only guests who have actually ordered here may review (soft trust gate).
    local ordered = MySQL.scalar.await(
        "SELECT 1 FROM pickle_restaurant_orders WHERE restaurant_id = ? AND customer_identifier = ? LIMIT 1", { rid, id })
    if not ordered then return { ok = false, error = _L("phone_review_needs_order") } end
    local comment = d.comment and tostring(d.comment):sub(1, 400) or nil
    local photo = d.photo and tostring(d.photo):sub(1, 300) or nil
    MySQL.insert.await(
        "INSERT INTO pickle_restaurant_reviews (restaurant_id, identifier, name, rating, comment, photo) VALUES (?, ?, ?, ?, ?, ?)",
        { rid, id, GetPlayerCharacterName(src), rating, comment, photo })
    if d.orderId then
        MySQL.update("UPDATE pickle_restaurant_orders SET rated = 1 WHERE id = ? AND customer_identifier = ?", { tonumber(d.orderId), id })
    end
    LoadReviews()
    return { ok = true }
end)

-- ─────────────────────────────────────────────────────────────────────────────
-- LOYALTY — punch on every completed order; redeem a free item at the goal.
-- Incremented from the orderCompleted seam below.
-- ─────────────────────────────────────────────────────────────────────────────
local function LoyaltyPunch(rid, identifier)
    if not LoyaltyOn() then return end
    LoyaltyCache[rid] = LoyaltyCache[rid] or {}
    local l = LoyaltyCache[rid][identifier] or { punches = 0, redeemed = 0 }
    l.punches = l.punches + 1
    LoyaltyCache[rid][identifier] = l
    MySQL.query.await([[
        INSERT INTO pickle_restaurant_loyalty (restaurant_id, identifier, punches) VALUES (?, ?, 1)
        ON DUPLICATE KEY UPDATE punches = punches + 1
    ]], { rid, identifier })
    return l.punches
end

-- Redemption is applied ATOMICALLY inside sales:placeOrder (a free item = the
-- cheapest line's price off the total). These two globals are the check + commit
-- it calls, so a failed order never burns a punch card.
function PhoneCanRedeem(rid, identifier)
    if not LoyaltyOn() then return false end
    local l = LoyaltyCache[rid] and LoyaltyCache[rid][identifier]
    return l ~= nil and l.punches >= LoyaltyGoal()
end

function PhoneCommitRedeem(rid, identifier)
    local goal = LoyaltyGoal()
    local l = LoyaltyCache[rid] and LoyaltyCache[rid][identifier]
    if not l or l.punches < goal then return false end
    l.punches = l.punches - goal
    l.redeemed = l.redeemed + 1
    MySQL.query.await("UPDATE pickle_restaurant_loyalty SET punches = ?, redeemed = ? WHERE restaurant_id = ? AND identifier = ?",
        { l.punches, l.redeemed, rid, identifier })
    return true
end

-- The inverse of PhoneCommitRedeem: give a burned redemption back when the order it
-- was spent on is CANCELLED. Called (guarded — this module may not be loaded) from
-- RefundOrder in core/server.lua for any order row carrying `redeemed = 1`.
-- A cancelled order refunds the money; the free item it also paid with has to come
-- back the same way, or a cancel quietly costs the customer a full punch card.
-- Idempotent by construction at the call site: RefundOrder flags the order refunded
-- before it gets here, so one order can only ever restore one redemption.
function PhoneRestoreRedeem(rid, identifier)
    if not identifier then return false end
    LoyaltyCache[rid] = LoyaltyCache[rid] or {}
    local l = LoyaltyCache[rid][identifier] or { punches = 0, redeemed = 0 }
    l.punches  = l.punches + LoyaltyGoal()
    l.redeemed = math.max(0, l.redeemed - 1)
    LoyaltyCache[rid][identifier] = l
    MySQL.query.await([[
        INSERT INTO pickle_restaurant_loyalty (restaurant_id, identifier, punches, redeemed) VALUES (?, ?, ?, ?)
        ON DUPLICATE KEY UPDATE punches = VALUES(punches), redeemed = VALUES(redeemed)
    ]], { rid, identifier, l.punches, l.redeemed })
    return true
end

-- ─────────────────────────────────────────────────────────────────────────────
-- RESERVATIONS — a reservation is an ACCESS GRANT over real seat anchors.
--
-- It used to be a PLACE: booking handed the party a private booth in its own routing
-- bucket, teleported them into it and teleported them back out. That is gone (the
-- bucket, `phone:enterBooth`/`phone:leaveBooth`, the client's BOOTH anchor). Two
-- reasons it had to go: a routing bucket takes the party OUT of the world their
-- restaurant is in — nobody can serve them, and the staff at the counter can't even
-- see the guests they booked — and the "put this player back in bucket 0" drop handler
-- it needed CLOBBERED every other resource's bucket assignment for that player (jails,
-- apartments, instanced jobs), which is a bug we were shipping for a feature nobody
-- could be served in. A reservation now holds the restaurant's OWN placed seats, in
-- the world, for one timeslot.
--
-- Rules (the sit gate in modules/seating/server.lua is the ONE door that enforces it):
--   * ONE active reservation per person, anywhere. Asking for more seats in the SAME
--     slot at the SAME restaurant EXTENDS it; a different slot or restaurant is
--     refused rather than silently becoming a second booking.
--   * The SERVER allocates which anchors are held — the phone never names a seat.
--   * The slot must be a canonical id from the `reservation_slots` setting. This used
--     to accept ANY string up to 20 chars, so a hand-made payload could book a slot
--     that no capacity check, no other booking and no expiry sweep would ever match.
--   * Only the holder and its granted guests may sit on a held anchor.
--   * Expiry is core's sweep (`status = 'expired'`), which drops the cache entry and
--     frees the seats; nothing here has to poll for it.
-- ─────────────────────────────────────────────────────────────────────────────
local MAX_PARTY  = 12   -- seats one reservation may hold in total
local MAX_GUESTS = 12   -- extra people admitted to those seats

-- Canonical slot ids, read through the core accessor so an admin's `reservation_slots`
-- edit applies immediately. Normalized here because the setting is admin-typed (a list
-- of ids, or of { id = … } rows if the editor ever grows labels) and a broken/empty
-- list must not make booking impossible — "now" always exists.
local function SlotIds()
    local out = {}
    for _, s in ipairs((ReservationSlots and ReservationSlots()) or {}) do
        local id = (type(s) == "table") and s.id or s
        if type(id) == "string" and id ~= "" then out[#out + 1] = id end
    end
    if #out == 0 then out[1] = "now" end
    return out
end

-- The submitted slot, or nil for anything that isn't on the canonical list.
local function ValidSlot(slot)
    slot = tostring(slot or "")
    for _, id in ipairs(SlotIds()) do if id == slot then return id end end
    return nil
end

-- Is this row still live? ReservationActive (core/server.lua) owns the window maths —
-- status, plus the slot's time today .. + `reservation_hold_minutes`. Guarded so a
-- load order that reaches us first degrades to "booked means live" instead of erroring.
local function ResActive(res)
    if not res then return false end
    if ReservationActive then return ReservationActive(res) and true or false end
    return (res.status or "booked") == "booked"
end

-- Seat anchors already held for one slot at one restaurant, as a set. `exceptId` skips
-- the caller's own reservation, so EXTENDING one doesn't count its existing seats
-- against the capacity it's allowed to grow into.
local function HeldSeats(rid, slot, exceptId)
    local held = {}
    for id, res in pairs(ReservationCache[rid] or {}) do
        if id ~= exceptId and res.slot == slot and ResActive(res) then
            for _, pid in ipairs(res.seats or {}) do held[pid] = true end
        end
    end
    return held
end

-- The one active reservation a player holds, anywhere (nil = none). Scanning every
-- restaurant is the point: the limit is per PERSON, not per restaurant, so the check
-- can't be scoped to the one they're booking.
local function MyReservation(identifier)
    for _, byId in pairs(ReservationCache) do
        for _, res in pairs(byId) do
            if res.identifier == identifier and ResActive(res) then return res end
        end
    end
    return nil
end

-- ─── globals the rest of the resource reads ──────────────────────────────────

-- The active reservation holding a seat anchor, or nil for a free seat. This is what
-- modules/seating's sit gate asks — the truth about who may sit is here, server-side,
-- never in the synced hint map.
function ReservationForSeat(propId)
    propId = tonumber(propId)
    if not propId then return nil end
    for _, byId in pairs(ReservationCache) do
        for _, res in pairs(byId) do
            if ResActive(res) then
                for _, pid in ipairs(res.seats or {}) do
                    if pid == propId then return res end
                end
            end
        end
    end
    return nil
end

-- May this identifier take a seat this reservation holds? The holder and every granted
-- guest, nobody else. Guests are per RESERVATION (so all of its seats at once) — a
-- party splits itself across the table it booked, and per-seat grants would mean the
-- host handing out permission six times for one group.
function ReservationAdmits(res, identifier)
    if not res or not identifier then return false end
    if res.identifier == identifier then return true end
    for _, g in ipairs(res.guests or {}) do
        if g.identifier == identifier then return true end
    end
    return false
end

-- Add a guest to a reservation (write-through). Returns ok, error-key. Used by the
-- phone's own grant AND by the "ask to sit here" accept in modules/seating.
function ReservationAddGuest(res, identifier, name)
    if not res or not identifier then return false, "reserve_not_found" end
    if res.identifier == identifier then return true end          -- the holder is already in
    for _, g in ipairs(res.guests or {}) do
        if g.identifier == identifier then return true end        -- idempotent: already a guest
    end
    if #(res.guests or {}) >= MAX_GUESTS then return false, "reserve_guest_limit" end
    MySQL.insert.await("INSERT INTO pickle_restaurant_reservation_guests (reservation_id, identifier, name) VALUES (?, ?, ?)",
        { res.id, identifier, name })
    res.guests = res.guests or {}
    res.guests[#res.guests + 1] = { identifier = identifier, name = name }
    return true
end

-- The per-restaurant seat-hold map BuildSyncPayload ships to clients so a held seat's
-- interaction can READ as reserved (modules/main/client.lua). Deliberately
-- holder-agnostic — it's a label hint, and a map naming who holds what would publish
-- every party's guest list to every client. The sit callback is the authority.
function ReservedSeatMap(rid)
    local out = {}
    for _, res in pairs(ReservationCache[rid] or {}) do
        if ResActive(res) then
            for _, pid in ipairs(res.seats or {}) do out[pid] = true end
        end
    end
    return out
end

-- Free every seat + guest a reservation held and drop it from the cache. ONE place, so
-- cancel (below) and any other ending can't disagree about what "over" means. The row
-- itself is left to the caller — cancel marks it cancelled, the sweep marks it expired.
function ReleaseReservation(res)
    if not res then return end
    MySQL.update.await("DELETE FROM pickle_restaurant_reservation_seats WHERE reservation_id = ?", { res.id })
    MySQL.update.await("DELETE FROM pickle_restaurant_reservation_guests WHERE reservation_id = ?", { res.id })
    if ReservationCache[res.restaurant_id] then ReservationCache[res.restaurant_id][res.id] = nil end
end

-- ─── display shapes ──────────────────────────────────────────────────────────

-- One reservation as the phone renders it. `seats` is the real held anchor ids (the
-- Reserve screen counts them — a party of four that only got three anchors must not
-- read as four) and `guests` is the manage-able list.
local function ReservationView(res)
    local r = GetRestaurant(res.restaurant_id)
    local guests = {}
    for _, g in ipairs(res.guests or {}) do
        guests[#guests + 1] = { identifier = g.identifier, name = g.name }
    end
    local seats = {}
    for _, pid in ipairs(res.seats or {}) do seats[#seats + 1] = pid end
    return {
        id           = res.id,
        restaurantId = res.restaurant_id,
        restaurant   = r and (r.label or r.name) or ("#" .. tostring(res.restaurant_id)),
        slot         = res.slot,
        party        = tonumber(res.party) or #seats,
        seats        = seats,
        seatCount    = #seats,
        guests       = guests,
        maxParty     = MAX_PARTY,
        maxGuests    = MAX_GUESTS,
        createdAt    = res.created_at,
    }
end

-- Per-slot availability for a restaurant, so the phone can grey out full slots, size
-- its party stepper to what's actually left, and show the caller their own booking.
lib.callback.register("pickle_restaurants:phone:reserveAvailability", function(src, d)
    local id = GetIdentifier(src)
    local rid = tonumber(d and d.id)
    if not GetRestaurant(rid) then return { ok = false, error = _L("phone_restaurant_unavailable") } end
    local anchors = SeatAnchors(rid)
    local mine = MyReservation(id)
    local slots = {}
    for _, slot in ipairs(SlotIds()) do
        -- A slot's own held seats, minus the caller's if theirs is in this slot: what
        -- they can still take is what nobody else holds.
        local held = HeldSeats(rid, slot, mine and mine.restaurant_id == rid and mine.id or nil)
        local taken = 0
        for _, pid in ipairs(anchors) do if held[pid] then taken = taken + 1 end end
        slots[#slots + 1] = { id = slot, taken = taken, remaining = math.max(0, #anchors - taken) }
    end
    return {
        ok       = true,
        capacity = #anchors,
        slots    = slots,
        maxParty = MAX_PARTY,
        -- The caller's ONE active reservation, wherever it is — the screen needs it even
        -- when it belongs to another restaurant, because that's what makes booking here
        -- impossible until they cancel it.
        mine     = mine and ReservationView(mine) or nil,
    }
end)

-- Book (or extend) a table. `party` is the DESIRED TOTAL party size, not an increment:
-- the phone's stepper is a party size, and treating it as "add this many" would double
-- a party every time the screen was re-submitted.
lib.callback.register("pickle_restaurants:phone:reserve", function(src, d)
    local id = GetIdentifier(src)
    local rid = tonumber(d and d.id)
    if not GetRestaurant(rid) then return { ok = false, error = _L("phone_restaurant_unavailable") } end
    local party = math.max(1, math.min(MAX_PARTY, math.floor(tonumber(d and d.party) or 2)))
    local slot = ValidSlot(d and d.slot)
    if not slot then return { ok = false, error = _L("reserve_bad_slot") } end

    -- ONE active reservation per person. The same slot at the same restaurant EXTENDS
    -- it (a party that grew); anything else is a second booking, which is what we're
    -- refusing — so say WHICH mismatch it is, or "you already have one" reads as a bug
    -- to someone who thinks they're editing the booking they can see on screen.
    local mine = MyReservation(id)
    if mine then
        if mine.restaurant_id ~= rid then return { ok = false, error = _L("reserve_other_restaurant", ReservationView(mine).restaurant) } end
        if mine.slot ~= slot then return { ok = false, error = _L("reserve_other_slot") } end
    end

    local anchors = SeatAnchors(rid)
    if #anchors <= 0 then return { ok = false, error = _L("reserve_no_seats") } end

    local have = mine and #(mine.seats or {}) or 0
    local need = party - have
    if need <= 0 then
        -- Nothing to allocate: they already hold at least the party they asked for. A
        -- reservation is never SHRUNK here — giving seats back is what cancelling is —
        -- so this is a success, not a no-such-thing error.
        return { ok = true, id = mine.id, party = tonumber(mine.party) or have, reservation = ReservationView(mine) }
    end

    -- Allocate from the anchors nobody else holds for this slot, in id order.
    local held = HeldSeats(rid, slot, mine and mine.id or nil)
    local mineHeld = {}
    for _, pid in ipairs(mine and mine.seats or {}) do mineHeld[pid] = true end
    local pick = {}
    for _, pid in ipairs(anchors) do
        if not held[pid] and not mineHeld[pid] then
            pick[#pick + 1] = pid
            if #pick >= need then break end
        end
    end
    if #pick < need then return { ok = false, error = _L("reserve_slot_full") } end

    local name = GetPlayerCharacterName(src)
    local res = mine
    if res then
        res.party = have + #pick
        MySQL.update.await("UPDATE pickle_restaurant_reservations SET party = ? WHERE id = ?", { res.party, res.id })
    else
        local resId = MySQL.insert.await(
            "INSERT INTO pickle_restaurant_reservations (restaurant_id, identifier, name, party, slot) VALUES (?, ?, ?, ?, ?)",
            { rid, id, name, #pick, slot })
        if not resId then return { ok = false, error = _L("reserve_failed") } end
        res = {
            id = resId, restaurant_id = rid, identifier = id, name = name,
            party = #pick, slot = slot, status = "booked",
            -- Both stamps, because "now" starts at CREATION and ReservationActive reads
            -- whichever it prefers; the row's own DEFAULT CURRENT_TIMESTAMP is the same
            -- instant, so the cache can't drift from the table.
            created_at = os.date("%Y-%m-%d %H:%M:%S"), created_ts = os.time(),
            seats = {}, guests = {},
        }
        ReservationCache[rid] = ReservationCache[rid] or {}
        ReservationCache[rid][resId] = res
    end
    for _, pid in ipairs(pick) do
        MySQL.insert.await("INSERT INTO pickle_restaurant_reservation_seats (reservation_id, prop_id) VALUES (?, ?)",
            { res.id, pid })
        res.seats[#res.seats + 1] = pid
    end
    -- The seat interaction's "Reserved" label is baked in when the interaction is built,
    -- so a booking that pushes nothing leaves every client offering a plain "Sit" on a
    -- held anchor until the next config change. The MAP is all that changed, so send the
    -- map — this used to re-send the entire world config to every player.
    SyncReservedSeats(rid)
    return { ok = true, id = res.id, party = res.party, seats = res.seats, reservation = ReservationView(res) }
end)

lib.callback.register("pickle_restaurants:phone:cancelReservation", function(src, d)
    local id = GetIdentifier(src)
    local resId = tonumber(d and d.id)
    -- Find it in the cache rather than trusting the id: the UPDATE below is scoped to
    -- the owner anyway, but the SEATS have to be freed too, and that needs the row.
    local res
    for _, byId in pairs(ReservationCache) do
        local r = byId[resId]
        if r and r.identifier == id then res = r break end
    end
    if not res then return { ok = false, error = _L("reserve_not_found") } end
    MySQL.update.await("UPDATE pickle_restaurant_reservations SET status = 'cancelled' WHERE id = ? AND identifier = ?", { resId, id })
    local rid = res.restaurant_id
    ReleaseReservation(res)
    SyncReservedSeats(rid) -- the freed anchors go back to reading as plain seats
    return { ok = true }
end)

lib.callback.register("pickle_restaurants:phone:myReservations", function(src)
    local id = GetIdentifier(src)
    -- Read the CACHE, not the table: it's the only store that carries the held seats and
    -- the guest list, and it's what the sit gate answers from — one source of truth.
    local out = {}
    for _, byId in pairs(ReservationCache) do
        for _, res in pairs(byId) do
            if res.identifier == id and ResActive(res) then out[#out + 1] = ReservationView(res) end
        end
    end
    table.sort(out, function(a, b) return a.id > b.id end)
    return { ok = true, reservations = out }
end)

-- ─── guests ──────────────────────────────────────────────────────────────────
-- Who else may use the seats this reservation holds. Listed, granted and revoked by
-- the HOLDER only — a guest can't invite the rest of the street into a table they
-- were let into.
local function OwnedReservation(src, resId)
    local id = GetIdentifier(src)
    for _, byId in pairs(ReservationCache) do
        local res = byId[tonumber(resId)]
        if res and res.identifier == id then return res end
    end
    return nil
end

lib.callback.register("pickle_restaurants:phone:reservationGuests", function(src, d)
    local res = OwnedReservation(src, d and d.id)
    if not res then return { ok = false, error = _L("reserve_not_found") } end
    local guests = {}
    for _, g in ipairs(res.guests or {}) do
        guests[#guests + 1] = {
            identifier = g.identifier, name = g.name,
            -- online-ness is what tells the holder whether revoking has any effect
            -- right now (a seated guest is standing up), so it's resolved per call.
            online = SourceForIdentifier(g.identifier) ~= nil,
        }
    end
    return { ok = true, id = res.id, guests = guests, maxGuests = MAX_GUESTS }
end)

-- Granting takes a SERVER ID, not an identifier: the holder is inviting somebody who
-- is standing in front of them, and a server id is the only handle a player can read
-- off another player. An identifier from the NUI would also let anyone name anyone.
lib.callback.register("pickle_restaurants:phone:grantGuest", function(src, d)
    local res = OwnedReservation(src, d and d.id)
    if not res then return { ok = false, error = _L("reserve_not_found") } end
    local target = tonumber(d and d.serverId)
    if not target or target == src or GetPlayerName(target) == nil then
        return { ok = false, error = _L("reserve_guest_not_found") }
    end
    local ident = GetIdentifier(target)
    if not ident then return { ok = false, error = _L("reserve_guest_not_found") } end
    local ok, err = ReservationAddGuest(res, ident, GetPlayerCharacterName(target))
    if not ok then return { ok = false, error = _L(err or "reserve_guest_limit") } end
    PhoneNotify(target, _L("reserve_guest_added_title"), _L("reserve_guest_added_body", ReservationView(res).restaurant))
    return { ok = true, guests = ReservationView(res).guests }
end)

lib.callback.register("pickle_restaurants:phone:revokeGuest", function(src, d)
    local res = OwnedReservation(src, d and d.id)
    if not res then return { ok = false, error = _L("reserve_not_found") } end
    local ident = d and d.identifier and tostring(d.identifier) or nil
    if not ident then return { ok = false, error = _L("reserve_guest_not_found") } end
    MySQL.update.await("DELETE FROM pickle_restaurant_reservation_guests WHERE reservation_id = ? AND identifier = ?",
        { res.id, ident })
    for i = #(res.guests or {}), 1, -1 do
        if res.guests[i].identifier == ident then table.remove(res.guests, i) end
    end
    -- A revoked guest sitting on one of the held seats is NOT thrown out mid-meal: the
    -- gate is checked when someone sits down, and standing a player up from another
    -- player's phone is a grief vector. They simply can't sit back down.
    return { ok = true, guests = ReservationView(res).guests }
end)

-- ─────────────────────────────────────────────────────────────────────────────
-- STAFF — clock in / out + tip-pool accrual
-- ─────────────────────────────────────────────────────────────────────────────
lib.callback.register("pickle_restaurants:phone:shiftStatus", function(src, d)
    local id = GetIdentifier(src)
    local rid = tonumber(d and d.id)
    local perms = ResolvePerms(rid, src)
    if not perms then return { ok = false, error = _L("phone_not_employed") } end
    local open = ShiftCache[rid] and ShiftCache[rid][id]
    -- Roster: everyone currently clocked in here (for the tip-pool split preview).
    local roster = {}
    for pid, sh in pairs(ShiftCache[rid] or {}) do
        roster[#roster + 1] = { name = sh.name, tips = sh.tips or 0, since = sh.clock_in_ts }
    end
    return {
        ok = true,
        clockedIn = open ~= nil,
        since = open and open.clock_in_ts or nil,
        tips = open and open.tips or 0,
        roster = roster,
    }
end)

lib.callback.register("pickle_restaurants:phone:clockIn", function(src, d)
    local id = GetIdentifier(src)
    local rid = tonumber(d and d.id)
    local perms = ResolvePerms(rid, src)
    if not perms then return { ok = false, error = _L("phone_not_employed") } end
    if ShiftCache[rid] and ShiftCache[rid][id] then return { ok = true } end
    local name = GetPlayerCharacterName(src)
    local shiftId = MySQL.insert.await(
        "INSERT INTO pickle_restaurant_shifts (restaurant_id, identifier, name) VALUES (?, ?, ?)", { rid, id, name })
    ShiftCache[rid] = ShiftCache[rid] or {}
    ShiftCache[rid][id] = { shiftId = shiftId, name = name, tips = 0, cooked = 0, clock_in_ts = Now() }
    return { ok = true }
end)

lib.callback.register("pickle_restaurants:phone:clockOut", function(src, d)
    local id = GetIdentifier(src)
    local rid = tonumber(d and d.id)
    local sh = ShiftCache[rid] and ShiftCache[rid][id]
    if not sh then return { ok = false, error = _L("phone_not_clocked_in") } end
    local secs = Now() - (sh.clock_in_ts or Now())
    MySQL.update.await(
        "UPDATE pickle_restaurant_shifts SET clock_out = NOW(), seconds = ?, tips = ?, orders_cooked = ? WHERE id = ?",
        { secs, sh.tips or 0, sh.cooked or 0, sh.shiftId })
    ShiftCache[rid][id] = nil
    return { ok = true, seconds = secs, tips = sh.tips or 0 }
end)

-- Called by the sales tip path (see the orderCompleted seam) to split a tip across
-- everyone currently on shift at that restaurant. Even split, remainder to the cook.
--
-- The shift row's `tips` is a SHIFT STAT — what this person earned tonight, printed on
-- the clock-out summary. It is not money. The money side is the unpaid tip POOL
-- (`AddTip`, paid out by the boss with `PayTips`), which is why each share is recorded
-- there too: tips are staff money, and a tip that only ever incremented a stat was a
-- number nobody could ever collect.
function DistributeTip(rid, amount, cookIdentifier)
    local onShift = {}
    for pid, sh in pairs(ShiftCache[rid] or {}) do onShift[#onShift + 1] = pid end
    if #onShift == 0 then return end
    local each = math.floor(amount / #onShift)
    local rem = amount - each * #onShift
    for _, pid in ipairs(onShift) do
        local sh = ShiftCache[rid][pid]
        local share = each + (pid == cookIdentifier and rem or 0)
        sh.tips = (sh.tips or 0) + share
        -- Guarded: AddTip lives in core, and a zero share is not worth a row.
        if AddTip and share > 0 then AddTip(rid, share, pid, "order") end
    end
end

-- ─────────────────────────────────────────────────────────────────────────────
-- OWNER — sales analytics rollup + promotions
-- ─────────────────────────────────────────────────────────────────────────────
lib.callback.register("pickle_restaurants:phone:analytics", function(src, d)
    local rid = tonumber(d and d.id)
    if not HasPerm(rid, src, "view_finances") then return { ok = false, error = _L("no_permission") } end
    local r = GetRestaurant(rid)

    -- Revenue / payroll / refunds from the ledger (last 30 days).
    local ledger = MySQL.query.await([[
        SELECT type, amount, created_at FROM pickle_restaurant_ledger
         WHERE restaurant_id = ? AND created_at >= (NOW() - INTERVAL 30 DAY)
    ]], { rid }) or {}
    local revenue, payroll, refunds = 0, 0, 0
    local byDay = {}   -- yyyy-mm-dd → revenue
    for _, e in ipairs(ledger) do
        local day = tostring(e.created_at):sub(1, 10)
        if e.type == "sale" then revenue = revenue + e.amount; byDay[day] = (byDay[day] or 0) + e.amount
        elseif e.type == "payroll" then payroll = payroll + e.amount
        elseif e.type == "refund" then refunds = refunds + math.abs(e.amount) end
    end
    local days = {}
    for day, amt in pairs(byDay) do days[#days + 1] = { day = day, revenue = amt } end
    table.sort(days, function(a, b) return a.day < b.day end)

    -- Best-sellers + peak hours from completed orders (last 30 days).
    local orders = MySQL.query.await([[
        SELECT `lines`, total, created_at FROM `pickle_restaurant_orders`
         WHERE restaurant_id = ? AND status = 'completed' AND created_at >= (NOW() - INTERVAL 30 DAY)
    ]], { rid }) or {}
    local sellers, hours, ticketCount = {}, {}, 0
    for h = 0, 23 do hours[h] = 0 end
    for _, o in ipairs(orders) do
        ticketCount = ticketCount + 1
        local hr = tonumber(tostring(o.created_at):sub(12, 13)) or 0
        hours[hr] = (hours[hr] or 0) + 1
        for _, line in ipairs(o.lines and json.decode(o.lines) or {}) do
            local key = line.label or line.item
            sellers[key] = sellers[key] or { label = key, qty = 0, image = line.image }
            sellers[key].qty = sellers[key].qty + (line.qty or 1)
        end
    end
    local best = {}
    for _, s in pairs(sellers) do best[#best + 1] = s end
    table.sort(best, function(a, b) return a.qty > b.qty end)
    while #best > 8 do table.remove(best) end
    local peak = {}
    for h = 0, 23 do peak[#peak + 1] = { hour = h, orders = hours[h] } end

    return {
        ok = true,
        balance = r and RestaurantBalance(r.id) or 0,
        revenue = revenue, payroll = payroll, refunds = refunds,
        tickets = ticketCount,
        avgTicket = ticketCount > 0 and math.floor(revenue / ticketCount) or 0,
        days = days, bestSellers = best, peak = peak,
        currency = _L("currency_symbol"),
    }
end)

lib.callback.register("pickle_restaurants:phone:promos", function(src, d)
    local rid = tonumber(d and d.id)
    if not HasPerm(rid, src, "manage_menu") then return { ok = false, error = _L("no_permission") } end
    local rows = MySQL.query.await("SELECT id, label, percent, kind, active FROM pickle_restaurant_promos WHERE restaurant_id = ? ORDER BY id DESC", { rid }) or {}
    return { ok = true, promos = rows }
end)

lib.callback.register("pickle_restaurants:phone:savePromo", function(src, d)
    local rid = tonumber(d and d.id)
    if not HasPerm(rid, src, "manage_menu") then return { ok = false, error = _L("no_permission") } end
    local label = tostring(d.label or "Promo"):sub(1, 60)
    local percent = math.max(1, math.min(90, math.floor(tonumber(d.percent) or 10)))
    local kind = (d.kind == "happy_hour") and "happy_hour" or "discount"
    local active = d.active ~= false
    local promoId = d.promoId and tonumber(d.promoId)
    -- Was this promo ALREADY live? A push notification is for a promo that has just gone
    -- out, not for every keystroke of editing one — and this panel auto-saves, so without
    -- this an admin retyping a label would notify every player on the server once per
    -- debounce tick. Read before the write, so the comparison is against the old row.
    local wasActive = false
    if promoId then
        local prev = MySQL.single.await("SELECT active FROM pickle_restaurant_promos WHERE id = ? AND restaurant_id = ?",
            { promoId, rid })
        wasActive = prev ~= nil and (tonumber(prev.active) or 0) ~= 0
    end
    if promoId then
        MySQL.update.await("UPDATE pickle_restaurant_promos SET label=?, percent=?, kind=?, active=? WHERE id=? AND restaurant_id=?",
            { label, percent, kind, active and 1 or 0, promoId, rid })
    else
        promoId = MySQL.insert.await("INSERT INTO pickle_restaurant_promos (restaurant_id, label, percent, kind, active) VALUES (?, ?, ?, ?, ?)",
            { rid, label, percent, kind, active and 1 or 0 })
    end
    LoadPromos()
    SyncWorldSoon()
    -- Announce it to every phone, DoorDash-style. THE ONE REMAINING DELIBERATE `-1`
    -- BROADCAST OF A GAMEPLAY EVENT, and it is one because the audience genuinely is
    -- everybody: it fires PhoneApp.Notify on the client, i.e. a phone notification, which
    -- has to reach phones that are CLOSED. Scoping it by distance would make it a promo
    -- only advertised to people already standing in the restaurant, which is the opposite
    -- of advertising. Rare, now that it only fires on the RISING EDGE.
    if active and not wasActive then
        local r = GetRestaurant(rid)
        TriggerClientEvent("pickle_restaurants:phone:pushPromo", -1, {
            title = _L("promo_push_title", r and (r.label or r.name) or _L("phone_order_fallback"), percent),
            content = label, rid = rid,
        })
    end
    return { ok = true, id = promoId }
end)

lib.callback.register("pickle_restaurants:phone:deletePromo", function(src, d)
    local rid = tonumber(d and d.id)
    if not HasPerm(rid, src, "manage_menu") then return { ok = false, error = _L("no_permission") } end
    MySQL.update.await("DELETE FROM pickle_restaurant_promos WHERE id = ? AND restaurant_id = ?", { tonumber(d.promoId), rid })
    LoadPromos()
    return { ok = true }
end)

-- ─────────────────────────────────────────────────────────────────────────────
-- SOCIAL — top-chef leaderboard + achievements
-- ─────────────────────────────────────────────────────────────────────────────
lib.callback.register("pickle_restaurants:phone:leaderboard", function(src, d)
    local rid = tonumber(d and d.id)   -- nil = global across all restaurants
    local tally = {}
    local function add(identifier, name, cooked, revenue)
        tally[identifier] = tally[identifier] or { name = name, cooked = 0, revenue = 0 }
        tally[identifier].cooked = tally[identifier].cooked + cooked
        tally[identifier].revenue = tally[identifier].revenue + revenue
        if name then tally[identifier].name = name end
    end
    if rid then
        for pid, s in pairs(CookStatCache[rid] or {}) do add(pid, s.name, s.cooked, s.revenue) end
    else
        for _, byId in pairs(CookStatCache) do
            for pid, s in pairs(byId) do add(pid, s.name, s.cooked, s.revenue) end
        end
    end
    local list = {}
    local myId = GetIdentifier(src)
    for pid, s in pairs(tally) do
        list[#list + 1] = { name = s.name or "Chef", cooked = s.cooked, revenue = s.revenue, me = pid == myId }
    end
    table.sort(list, function(a, b) return a.cooked > b.cooked end)
    while #list > 25 do table.remove(list) end
    return { ok = true, leaderboard = list }
end)

function PlayerAchievements(identifier)
    local mine = AchievementCache[identifier] or {}
    -- Lifetime cooked = max progress recorded on any milestone (they share the counter).
    local cooked = 0
    for _, a in pairs(mine) do cooked = math.max(cooked, a.progress or 0) end
    local out = {}
    for _, def in ipairs(PHONE_ACHIEVEMENTS) do
        local a = mine[def.key]
        out[#out + 1] = {
            key = def.key, label = def.label, desc = def.desc, goal = def.goal,
            progress = math.min(cooked, def.goal),
            unlocked = (a and a.unlocked) or cooked >= def.goal,
        }
    end
    return out
end

-- Record one cooked ticket against a player's milestones; unlock + notify on cross.
local function BumpAchievements(src, identifier)
    AchievementCache[identifier] = AchievementCache[identifier] or {}
    local mine = AchievementCache[identifier]
    local cooked = 0
    for _, a in pairs(mine) do cooked = math.max(cooked, a.progress or 0) end
    cooked = cooked + 1
    for _, def in ipairs(PHONE_ACHIEVEMENTS) do
        local a = mine[def.key] or { progress = 0, unlocked = false }
        a.progress = cooked
        if not a.unlocked and cooked >= def.goal then
            a.unlocked = true
            MySQL.query.await([[
                INSERT INTO pickle_restaurant_achievements (identifier, akey, progress, unlocked_at)
                VALUES (?, ?, ?, NOW())
                ON DUPLICATE KEY UPDATE progress = VALUES(progress), unlocked_at = NOW()
            ]], { identifier, def.key, cooked })
            if src then PhoneNotify(src, _L("ach_unlocked_title"), _L("ach_unlocked_body", def.label, def.desc)) end
        else
            MySQL.query.await([[
                INSERT INTO pickle_restaurant_achievements (identifier, akey, progress)
                VALUES (?, ?, ?)
                ON DUPLICATE KEY UPDATE progress = VALUES(progress)
            ]], { identifier, def.key, cooked })
        end
        mine[def.key] = a
    end
end

-- ─────────────────────────────────────────────────────────────────────────────
-- The completion seam. modules/sales fires this on a completed ticket:
--   TriggerEvent("pickle_restaurants:internal:orderCompleted", rid, order, cookSrc, tip)
-- We use it for loyalty punches (customer), cook stats + achievements + leaderboard
-- (cook), and tip-pool accrual.
-- ─────────────────────────────────────────────────────────────────────────────
AddEventHandler("pickle_restaurants:internal:orderCompleted", function(rid, order, cookSrc, tip)
    if not order then return end
    -- Loyalty punch for a real player customer (skip NPCs / anon).
    local cust = order.customer_identifier
    if cust and not tostring(cust):find("^npc:") then
        local punches = LoyaltyPunch(rid, cust)
        if punches and punches >= LoyaltyGoal() then
            local custSrc = SourceForIdentifier and SourceForIdentifier(cust)
            if custSrc then PhoneNotify(custSrc, _L("loyalty_reward_title"), _L("loyalty_reward_body")) end
        end
    end

    -- Cook credit: stats, achievements, leaderboard, tip pool.
    if cookSrc then
        local cookId = GetIdentifier(cookSrc)
        if cookId then
            CookStatCache[rid] = CookStatCache[rid] or {}
            local s = CookStatCache[rid][cookId] or { name = GetPlayerCharacterName(cookSrc), cooked = 0, revenue = 0 }
            s.cooked = s.cooked + 1
            s.revenue = s.revenue + (order.total or 0)
            s.name = GetPlayerCharacterName(cookSrc)
            CookStatCache[rid][cookId] = s
            MySQL.query.await([[
                INSERT INTO pickle_restaurant_cook_stats (restaurant_id, identifier, name, cooked, revenue)
                VALUES (?, ?, ?, 1, ?)
                ON DUPLICATE KEY UPDATE cooked = cooked + 1, revenue = revenue + VALUES(revenue), name = VALUES(name)
            ]], { rid, cookId, s.name, order.total or 0 })
            BumpAchievements(cookSrc, cookId)
            local sh = ShiftCache[rid] and ShiftCache[rid][cookId]
            if sh then sh.cooked = (sh.cooked or 0) + 1 end
        end
        if tip and tip > 0 then DistributeTip(rid, tip, GetIdentifier(cookSrc)) end
    end

    -- Tell the customer's phone the hand-off HAPPENED. This seam fires on COMPLETION
    -- — the food physically changed hands (completeOrder requires the customer at the
    -- counter / the driver at the door) — NOT when the kitchen finished cooking. So the
    -- copy is delivered / collected, never "ready" or "on the way": out-for-delivery has
    -- its own push in sales' startDelivery, and readiness is a live flag on the tracking
    -- screen. Title and body must describe the SAME state.
    local custSrc = SourceForIdentifier and SourceForIdentifier(order.customer_identifier)
    if custSrc then
        -- The run is over: take the driver blip off the customer's minimap. The app
        -- already asks for this, but only while its tracking screen is open — a phone
        -- in a pocket kept the blip for the rest of the session.
        TriggerClientEvent("pickle_restaurants:phone:deliveryEnded", custSrc, { orderId = order.id })
        local r = GetRestaurant(rid)
        local name = r and (r.label or r.name) or _L("phone_order_fallback")
        local ticket = tostring(order.ticket or "?")
        if order.order_type == "delivery" then
            PhoneNotify(custSrc, _L("phone_order_delivered_title"), _L("phone_order_delivered_body", name, ticket))
        else
            PhoneNotify(custSrc, _L("phone_order_collected_title"), _L("phone_order_collected_body", name, ticket))
        end
    end
end)

-- Resolve an online player's source from their identifier (for push notifications).
function SourceForIdentifier(identifier)
    for _, src in ipairs(GetPlayers()) do
        if GetIdentifier(tonumber(src)) == identifier then return tonumber(src) end
    end
    return nil
end

-- ─── `pickle_phoneapp` ────────────────────────────────────────────────────────
-- Prints everything needed to add the companion app to a phone by hand, plus which
-- phone resources are actually on this server and what state they're in. A phone
-- whose runtime registration API we can't reach (or that has none — several expect
-- apps to be listed in their own config file) leaves "the app never appeared" with
-- no visible cause; this makes the answer one command away instead of a code read.
local PHONE_RESOURCES = { "lb-phone", "qs-smartphone", "qs-smartphone-pro", "gksphone", "qb-phone" }

RegisterCommand("pickle_phoneapp", function(source)
    if source ~= 0 and not IsPlayerAdmin(source) then return end
    local found = {}
    for _, res in ipairs(PHONE_RESOURCES) do
        local state = GetResourceState(res)
        if state ~= "missing" then found[#found + 1] = ("%s (%s)"):format(res, state) end
    end
    PrintPhoneAppInstall(#found > 0
        and ("Phone resources detected: " .. table.concat(found, ", "))
        or "No supported phone resource is installed on this server.")
end, false)
