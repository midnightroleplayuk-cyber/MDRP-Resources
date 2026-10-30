-- =============================================
--  modules/screens | client.lua
--  The customer-facing SCREENS, rendered onto placed props by the same
--  render-target trick modules/rendertarget uses for packaging brands — a DUI paints
--  an HTML page (html/screens.html) into a runtime texture, and AddReplaceTexture
--  swaps it in for the prop's branded screen texture. Unlike a brand image the page
--  is DYNAMIC and fed live data each tick:
--
--    menu   — pickle_screen_menu_01 / texture s_m_brand
--             what the restaurant is selling: a paged slideshow of its priced menu
--             (image + name + price), sized to read from across the room. One page if
--             everything fits. Tracks menu edits (the menu rides the restaurant sync).
--    orders — pickle_screen_orders_01 / texture s_o_brand
--             open tickets in progress, NEWEST FIRST, with a PREPARING/READY chip.
--             Kept live off the sales orders broadcast (seeded once on arrival).
--
--  (The counter's `register_brand` screen is no longer driven here — the register is
--  now the cashier's interactive POS DUI, modules/register, which owns that texture.)
--
--  AddReplaceTexture is GLOBAL per (txd + txn) — so, exactly like the packaging brand,
--  only ONE restaurant's board shows on a given screen model at a time. We drive each
--  screen from the NEAREST restaurant that actually has that screen prop placed, so a
--  player reading a restaurant's board sees that restaurant's data. Every screen uses a
--  different model AND a different texture, so they never collide with each other or
--  with the packaging brands.
--
--  Aspect + orientation are TUNED like the brand textures: in the ONE render-target
--  registry (core/shared.lua), which SCREENS below is a filtered view of.
-- =============================================

-- The menu + orders boards are the "screen" render targets — a filtered VIEW of the
-- ONE registry in core/shared.lua (`Config.RenderTargets`), so their resolution +
-- orientation live in exactly one place. Each entry carries key/kind/prop_type/txd/txn/
-- w/h/rot/gap — edit them in Config.RenderTargets, not here.
-- NOTE: the counter's `register_brand` screen is NO LONGER a screen here — the register
-- is now the cashier's interactive POS DUI (modules/register), which owns that texture.
local SCREENS = RenderTargetsByGroup("screen")
local SCREEN_BY_KEY, SCREEN_BY_MODEL = {}, {}
for _, t in ipairs(SCREENS) do SCREEN_BY_KEY[t.key] = t; SCREEN_BY_MODEL[t.txd] = t end

local TICK_MS = 1000   -- driver cadence: re-pick nearest + re-push changed data

-- forced state while debugging (a fixed rid shown on every screen), else nil.

-- Live open-order lists, per restaurant, projected for the orders board and kept
-- current by the sales orders broadcast below. Seeded once per restaurant the first
-- time its board goes active (a player who arrives between broadcasts).
local ScreenOrders = {}   -- [rid] = projected orders list (newest first)
local seededOrders = {}   -- [rid] = true once the one-shot seed has been requested

-- Priced board menus, per restaurant. FETCHED, not synced: the menu used to ride the world
-- sync payload, where it was the largest term and went to every player regardless of
-- whether they were near a board (this module is its only reader). Same seed-once shape as
-- the orders above; RefreshScreens drops it so a price edit re-fetches.
local ScreenMenus = {}    -- [rid] = { { label, price, image, kind }, … }
local seededMenus = {}    -- [rid] = true once the one-shot fetch has been requested

-- Bumped every time a BROADCAST updates a restaurant's data. A one-shot seed reply that
-- comes back to find the epoch moved on is STALE and must be dropped: the broadcast that
-- overtook it is the newer truth, and "nothing there" is a value the seed can't tell
-- apart from "not asked yet" (an emptied cart / a cleared list would otherwise be
-- overwritten by the reply and stay wrong until the next change — possibly forever).
local dataEpoch = {}      -- [rid] = integer
local function bumpEpoch(rid) dataEpoch[rid] = (dataEpoch[rid] or 0) + 1 end

-- ─── per-screen DUI + runtime texture (mirrors modules/rendertarget) ──────────

local function rtNames(t) return
    ("pickle_screen_txd_%s_%d"):format(t.key, t.gen or 0),
    ("pickle_screen_tex_%s_%d"):format(t.key, t.gen or 0)
end

-- Deliver the current payload to the DUI. A DUI that hasn't loaded yet drops the push
-- and returns false, so the caller keeps t.sig unset and retries next tick (the same
-- blank-on-load fix modules/rendertarget documents).
local function pushToDui(t)
    if not (t.dui and t.ready and t.cur) then return false end
    local d = t.cur
    -- screens.html sizes its surface to the w/h it receives and rotates the content, so
    -- it must get the SURFACE aspect (upright config w/h swapped for a 90/270 turn).
    d.w, d.h = RenderTargetSurface(t)
    d.rot, d.flipx, d.flipy = t.rot or 0, t.flipx or false, t.flipy or false
    d.key, d.res = t.key, GetCurrentResourceName()
    SendDuiMessage(t.dui, json.encode(d))
    return true
end

local function ensureDui(t)
    if t.dui then return end
    t.gen = (t.gen or 0) + 1
    t.ready = false
    local url = ("https://cfx-nui-%s/html/screens.html"):format(GetCurrentResourceName())
    -- Surface = the texture's pixel aspect (upright config w/h swapped for a 90/270 turn).
    local sw, sh = RenderTargetSurface(t)
    t.dui = CreateDui(url, sw, sh)
    local txdName, texName = rtNames(t)
    local txd = CreateRuntimeTxd(txdName)
    CreateRuntimeTextureFromDuiHandle(txd, texName, GetDuiHandle(t.dui))
    CreateThread(function()
        local mine = t.gen
        while t.dui and t.gen == mine and not IsDuiAvailable(t.dui) do Wait(50) end
        if t.gen ~= mine then return end
        t.ready = true
        pushToDui(t)
    end)
end

local function applyReplacement(t)
    if t.applied then return end
    local txdName, texName = rtNames(t)
    AddReplaceTexture(t.txd, t.txn, txdName, texName)
    t.applied = true
end

local function removeReplacement(t)
    if not t.applied then return end
    RemoveReplaceTexture(t.txd, t.txn)
    t.applied = false
end

-- One re-bind after the page has painted its first real frame, against a live surface
-- instead of the blank one the initial bind would catch (the render-target blank-on-
-- load fix). The DUI then updates the prop LIVE every frame — the slideshow animates
-- and later data pushes show without any further rebinding.
local function rebindAfterPaint(t)
    t.rebindSeq = (t.rebindSeq or 0) + 1
    local mine = t.rebindSeq
    CreateThread(function()
        local tries = 0
        while t.dui and not IsDuiAvailable(t.dui) and tries < 150 do Wait(30); tries = tries + 1 end
        if not t.dui or t.rebindSeq ~= mine then return end
        Wait(600) -- let screens.html lay out + fetch its images before the safety rebind
        if t.dui and t.rebindSeq == mine and t.applied then
            removeReplacement(t); applyReplacement(t)
        end
    end)
end

-- ─── data payloads ────────────────────────────────────────────────────────────

-- The board wears the restaurant's OWN theme: the same { primary, mode, radius }
-- seed every scoped NUI panel gets. screens.html derives the whole palette from it
-- (a port of web/src/lib/theme.ts), so a menu/orders board and the restaurant's
-- panels are the same design. nil → the page's shipped default seed.
local function restaurantTheme(r)
    return r and r.theme or nil
end

-- Project a restaurant's live open orders for the board: newest ticket first, only
-- what a public "now preparing" display should show — ticket #, the item lines
-- (qty + label + image) and whether the kitchen has it ready. No customer identity.
local function projectOrders(orders)
    local out = {}
    for _, o in ipairs(orders or {}) do
        local items = {}
        for _, l in ipairs(o.lines or {}) do
            items[#items + 1] = { label = l.label or GetItemLabel(l.item), qty = l.qty or 1, image = l.image }
        end
        out[#out + 1] = { ticket = o.ticket, items = items,
                          ready = (o.fulfill and o.fulfill.ready) == true }
    end
    table.sort(out, function(a, b) return (a.ticket or 0) > (b.ticket or 0) end) -- newest first
    return out
end

-- The payload a screen should currently show for restaurant `r`, or nil if there's
-- nothing to render (no menu / no orders yet — the page draws its own empty state).
local function payloadFor(t, r)
    if not r then return nil end
    if t.kind == "menu" then
        -- nil until the fetch lands, which is fine: payloadFor returning an empty list
        -- makes the page draw its own empty state, and the next driver tick re-pushes
        -- once ScreenMenus has it.
        return { action = "menu", title = r.label, theme = restaurantTheme(r),
                 items = ScreenMenus[r.id] or {} }
    else
        return { action = "orders", title = r.label, theme = restaurantTheme(r),
                 orders = ScreenOrders[r.id] or {} }
    end
end

-- A stable signature so unchanged data isn't re-pushed every tick (the slideshow /
-- board animate client-side; we only re-push when the CONTENT actually changes).
local function payloadSig(rid, d)
    if not d then return "nil" end
    return tostring(rid) .. "|" .. json.encode(d)
end

-- ─── nearest-screen driver ───────────────────────────────────────────────────

-- Nearest restaurant that has THIS screen prop placed, using the prop's own world
-- position (so the board belongs to the screen you're standing at). No range gate:
-- these are placed world props we spawn ourselves, so the replacement stays active
-- whenever the screen exists at all — AddReplaceTexture is global anyway, and only the
-- DATA (which restaurant's board) depends on which screen you're nearest. Returns nil
-- only when NO restaurant has this screen placed (→ restore the native texture).
local function nearestFor(t)
    local here = GetEntityCoords(PlayerPedId())
    local best, bestDist
    for _, r in pairs(Restaurants or {}) do
        -- Only a restaurant whose props we actually HOLD can drive a board. Prop ROWS are
        -- kept for every restaurant on the server, but entities are loaded by proximity
        -- (modules/main's reconciler) and AddReplaceTexture only takes on a model that
        -- exists — so without this, the "nearest" board could be one across the map whose
        -- prop isn't in the world, and we'd bind a texture to nothing and fetch its menu
        -- for no reason. The comment above about there being no range gate predates
        -- proximity loading: IsRestaurantLoaded IS the range gate now.
        if IsRestaurantLoaded and IsRestaurantLoaded(r.id) then
        for _, p in ipairs(r.props or {}) do
            if p.prop_type == t.prop_type then
                local dist = #(here - vector3(p.x + 0.0, p.y + 0.0, p.z + 0.0))
                if not bestDist or dist < bestDist then bestDist, best = dist, r end
            end
        end
        end
    end
    return best
end

-- Ensure the orders board has a current list for `rid`: it stays live off the
-- broadcast, but the first time a restaurant's board activates we ask the server once
-- (a player standing there before any order changes would otherwise see it empty).
-- Ensure the menu board has this restaurant's priced menu. Unlike the orders list there is
-- no broadcast to stay live off — a menu changes when a boss edits it, which fires a world
-- sync, and RefreshScreens (called from main's ApplySync) drops the cache so the next tick
-- re-fetches. No epoch guard needed for that reason: nothing can overtake this reply.
local function seedMenu(rid)
    if not rid or seededMenus[rid] then return end
    seededMenus[rid] = true
    CreateThread(function()
        local res = lib.callback.await("pickle_restaurants:screens:getMenu", false, { id = rid })
        ScreenMenus[rid] = (res and res.menu) or {}
    end)
end

local function seedOrders(rid)
    if not rid or seededOrders[rid] then return end
    seededOrders[rid] = true
    local epoch = dataEpoch[rid]
    CreateThread(function()
        local res = lib.callback.await("pickle_restaurants:screens:getOrders", false, { id = rid })
        if dataEpoch[rid] ~= epoch then return end -- a broadcast overtook us; it's newer
        ScreenOrders[rid] = projectOrders(res and res.orders)
    end)
end

-- Show restaurant `r`'s data on screen `t` (nil = nothing in range → restore texture).
local function driveScreen(t, r)
    if not r then
        -- Nothing is driving this screen: paint a solid BLACK board rather than
        -- reverting to the model's baked-in placeholder texture. Keep the replacement
        -- applied so the black frame stays bound.
        local firstApply = not t.applied
        t.rid = nil
        ensureDui(t)
        applyReplacement(t)
        if t.sig ~= "black" then
            t.cur = { action = "black" }
            if pushToDui(t) then t.sig = "black" end
        end
        if firstApply then rebindAfterPaint(t) end
        return
    end
    -- Fetch whichever data this board needs for the restaurant it's now showing. Both are
    -- one-shot per restaurant and cheap to call every tick (they return immediately once
    -- asked), so the driver doesn't have to track which boards it has already seeded.
    if t.kind == "orders" then seedOrders(r.id) else seedMenu(r.id) end
    local firstApply = not t.applied
    local ridChanged = t.rid ~= r.id
    t.rid = r.id
    ensureDui(t)
    applyReplacement(t)
    local payload = payloadFor(t, r)
    local sig = payloadSig(r.id, payload)
    if sig ~= t.sig then
        t.cur = payload
        if pushToDui(t) then t.sig = sig end
    end
    if firstApply or ridChanged then rebindAfterPaint(t) end
end

local function driveOnce()
    for _, t in ipairs(SCREENS) do
        local r = nearestFor(t)
        driveScreen(t, r)
    end
end

CreateThread(function()
    while true do
        Wait(TICK_MS)
        driveOnce()
    end
end)

-- Warm both DUIs at start (create + paint an empty frame) BEFORE any replacement or
-- model streaming, so the runtime texture holds a real frame when a board first binds
-- — the same cold-DUI fix modules/rendertarget applies.
CreateThread(function()
    Wait(700)
    for _, t in ipairs(SCREENS) do
        ensureDui(t)
        -- Warm to a solid BLACK board — the unbranded default — so the first texture
        -- bind catches black, never the DUI's raw white surface.
        t.cur = { action = "black" }
        t.sig = "black"
        pushToDui(t)
    end
end)

-- Live orders: the sales module broadcasts the full open-ticket list to EVERYONE on
-- every change. Cache the projection for any restaurant so its board is current the
-- next driver tick — whether or not we're near it right now.
RegisterNetEvent("pickle_restaurants:sales:orders", function(rid, orders)
    if not rid then return end
    ScreenOrders[rid] = projectOrders(orders)
    seededOrders[rid] = true -- a broadcast supersedes any need to seed
    bumpEpoch(rid)
end)

-- screens.html POSTs here the instant it has painted a real frame, so we bind the
-- replacement against live content rather than the blank surface the first bind would
-- catch. Idempotent; only fires for a board that has content.
RegisterNUICallback("screen:painted", function(d, cb)
    local t = d and d.key and SCREEN_BY_KEY[d.key]
    if t and t.dui and t.applied then
        removeReplacement(t); applyReplacement(t)
    end
    cb("ok")
end)

-- Called by main's SpawnProp the instant a screen prop streams in. This is our ONE
-- reliable binding opportunity: AddReplaceTexture only takes while a prop of the model
-- actually EXISTS, and a placed screen never re-streams on its own (unlike packaging,
-- which re-streams every time an item is cooked/held). So force the replacement ACTIVE
-- and (re)bound now, while the prop is present — even if the driver hasn't picked this
-- restaurant yet (the DUI shows its warm frame until the next tick pushes real data).
function ReassertScreenFor(model)
    local t = model and SCREEN_BY_MODEL[model]
    if not t then return end
    ensureDui(t)
    applyReplacement(t)   -- remove+add path is inside rebindAfterPaint below
    rebindAfterPaint(t)   -- re-bind against the painted surface while the prop exists
end

-- Re-assert every screen after a world (re)build. main's ApplySync respawns all props
-- and then calls this (mirroring RefreshBrands): re-push the current data and re-bind
-- each active screen while its freshly-spawned prop exists.
function RefreshScreens()
    for _, t in ipairs(SCREENS) do t.sig = nil end -- force a re-push with fresh data
    -- A menu price may have changed — that's what a sync usually IS — and the menu no
    -- longer rides the payload, so drop the fetched copies and let the driver re-ask.
    -- Cleared rather than re-fetched here: only the boards actually in range will ask,
    -- and they ask on the very next tick.
    ScreenMenus, seededMenus = {}, {}
    driveOnce()
    for _, t in ipairs(SCREENS) do
        if t.applied then rebindAfterPaint(t) end
    end
end

-- ─── teardown ────────────────────────────────────────────────────────────────

AddEventHandler("onResourceStop", function(res)
    if res ~= GetCurrentResourceName() then return end
    for _, t in ipairs(SCREENS) do
        removeReplacement(t)
        if t.dui then DestroyDui(t.dui); t.dui = nil end
    end
end)
