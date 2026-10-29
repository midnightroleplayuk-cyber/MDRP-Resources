-- =============================================
--  modules/register | client.lua
--  The STAFF POS register painted on the counter's `register_brand` screen. It is an
--  ALWAYS-ON board (like the menu/orders screens in modules/screens): the counter
--  screen persistently shows the register UI — the priced catalog + the live ticket
--  queue for the nearest counter's restaurant — even when nobody's using it. This
--  REPLACES the old customer-facing till display (the removed modules/screens
--  `register` board); the counter screen IS the POS now.
--
--  On INTERACT (a physical counter, prop_type "counter") it becomes interactive, the
--  same way modules/kiosk works: `OpenRegisterScreen(prop, ent)` frames a scripted
--  camera on the screen, hides the ped, swaps the idle board for the cashier's
--  perm-gated payload (with the nearby customers they can charge), and drives a VIRTUAL
--  CURSOR (mouse-look deltas → SendDuiMouse*) over the page. Stepping away hands the
--  screen back to the idle board.
--
--  VIRTUAL registers (prop_type "virtual_register") are invisible anchors with no
--  screen to paint, so they keep the ordinary fullscreen NUI (OpenRegister in
--  modules/sales) — this module is only for the physical counter.
--
--  Orders ring up through the SAME callbacks the NUI used (sales:createOrder /
--  completeOrder / cancelOrder); the live open-ticket list — which the NUI got via
--  SendNUIMessage — is forwarded into the DUI here (SendDuiMessage `registerOrders`)
--  off the server's orders broadcast, for both the idle board and an open session.
--
--  RESOLUTION + ORIENTATION come from the ONE render-target registry in
--  core/shared.lua (`Config.RenderTargets`, key "register"), so the DUI, the texture
--  name and the crop UI can never disagree. Camera framing / cursor speed are the only
--  register-local tunables (TUNE IN-GAME); resolution/orientation belong to the
--  registry.
-- =============================================

-- The register's render target (resolution / texture / orientation) — read from the
-- single registry so it can't drift from the brand crop UI or the screens driver.
local RT = RenderTargetByKey("register") or { w = 1024, h = 1024, rot = 0, txn = "register_brand", prop_type = "counter" }
local REGISTER_TXN = RT.txn
local PROP_TYPE    = RT.prop_type or "counter"

-- The DUI SURFACE aspect (upright config w/h swapped for a 90/270 turn). RegisterDui reads
-- these as the surface and rotates the content upright via `orient`, so the DUI is sized to
-- the surface, not the upright display aspect.
local RT_SW, RT_SH = RenderTargetSurface(RT)

local REGISTER = {
    w = RT_SW or 1024, h = RT_SH or 1024,
    -- Virtual-cursor speed relative to raw mouse-look delta. 0.375 = three quarters of
    -- the 0.5 this shipped at, matching the kiosk — the two in-world screens must feel
    -- the same, since a cashier uses both. TUNE IN-GAME.
    sensitivity = 0.375,
    -- Framing in the counter's LOCAL space (y = the prop's forward, toward the customer
    -- side the screen faces): the scripted camera sits in FRONT of the screen looking
    -- back at it, so the cashier uses it head-on whichever side they walked up from (the
    -- ped is hidden for the duration).
    geo = {
        ["counter"] = { cam = vec3(0.0, -0.9, 0.55), look = vec3(0.0, 0.0, 0.175), fov = 30.0 },
    },
}

-- Screen texture ORIENTATION (rot/flip), seeded from the registry. The page paints with
-- the SAME transform to land upright, and the cursor→surface mapping mirrors it.
local orient = { rot = RT.rot or 0, flipx = RT.flipx or false, flipy = RT.flipy or false }

local function RegisterModel() return (CounterModel and CounterModel()) or RT.txd or "pickle_register_01" end

local TICK_MS = 1000  -- idle-driver cadence: re-pick the nearest counter + (re)paint

-- ─── register-page DUI (created once, reused) ────────────────────────────────

local dui, duiReady, duiGen = nil, false, 0

local function rtNames()
    return ("pickle_register_txd_%d"):format(duiGen), ("pickle_register_tex_%d"):format(duiGen)
end

local function ensureDui()
    if dui then return end
    duiGen = duiGen + 1
    duiReady = false
    local url = ("https://cfx-nui-%s/nui/index.html#register"):format(GetCurrentResourceName())
    dui = CreateDui(url, REGISTER.w, REGISTER.h)
    local txdName, texName = rtNames()
    local txd = CreateRuntimeTxd(txdName)
    CreateRuntimeTextureFromDuiHandle(txd, texName, GetDuiHandle(dui))
    CreateThread(function()
        local mine = duiGen
        while dui and duiGen == mine and not IsDuiAvailable(dui) do Wait(50) end
        if duiGen == mine then duiReady = true end
    end)
end

local appliedModel = nil

local function applyScreen(model)
    if appliedModel == model then return end
    if appliedModel then RemoveReplaceTexture(appliedModel, REGISTER_TXN) end
    local txdName, texName = rtNames()
    AddReplaceTexture(model, REGISTER_TXN, txdName, texName)
    appliedModel = model
end

local function removeScreen()
    if not appliedModel then return end
    RemoveReplaceTexture(appliedModel, REGISTER_TXN)
    appliedModel = nil
end

-- Re-bind once the page has painted a real frame, so the texture binds to live content
-- instead of the blank surface the first bind would catch (the shared blank-on-load fix).
local function rebindAfterPaint(model)
    CreateThread(function()
        local tries = 0
        while dui and not IsDuiAvailable(dui) and tries < 150 do Wait(30); tries = tries + 1 end
        if not dui or appliedModel ~= model then return end
        Wait(500)
        if dui and appliedModel == model then
            RemoveReplaceTexture(model, REGISTER_TXN)
            local txdName, texName = rtNames()
            AddReplaceTexture(model, REGISTER_TXN, txdName, texName)
        end
    end)
end

-- RegisterDui POSTs here the instant it has painted the register UI; re-bind the texture
-- against the live frame (idempotent; fires for both the idle board and a session).
RegisterNUICallback("register:painted", function(_, cb)
    if dui and appliedModel then
        RemoveReplaceTexture(appliedModel, REGISTER_TXN)
        local txdName, texName = rtNames()
        AddReplaceTexture(appliedModel, REGISTER_TXN, txdName, texName)
    end
    cb("ok")
end)

-- Send the register page a data payload (full board/session state). This REMOUNTS the
-- page's OrderBuilder (clears any cart) — so it's only sent when the shown restaurant or
-- the session changes, never per ticket tick (those go through pushOrders below).
local function pushData(payload)
    if dui then SendDuiMessage(dui, json.encode({ action = "registerData", data = payload, orient = orient })) end
end

-- Push just the live ticket list (no remount) — the register page updates its Tickets
-- tab in place off this, exactly like the NUI did off the `orders` broadcast.
local function pushOrders(orders)
    if dui then SendDuiMessage(dui, json.encode({ action = "registerOrders", orders = orders or {} })) end
end

-- ─── idle board state (the always-on display) ────────────────────────────────

-- The static-ish part of a restaurant's idle board (label/theme/catalog), seeded
-- once from a PUBLIC callback — the same display-safe data the menu/orders boards show
-- (no balance/commission, no nearby players; those are only in the perm-gated payload a
-- cashier gets on interact).
local IdleData   = {}   -- [rid] = { label, theme, catalog }
local seededIdle = {}   -- [rid] = true once the one-shot seed has been requested
local LiveTickets = {}  -- [rid] = the live open-ticket list (off the orders broadcast)

local shownRid  = nil   -- which restaurant the DUI is currently painting (idle board)
local pushedRid = nil   -- which restaurant we've actually pushed registerData for

-- interactive session (a cashier using a physical counter), else nil.
local active = nil          -- { rid, ent }
local vx, vy = 0.5, 0.5     -- virtual cursor, normalised [0..1]
local lastCurX, lastCurY    -- last cursor pos pushed (skip idle resends)
local lastDown              -- last button-down state pushed

local function seedIdle(rid)
    if not rid or seededIdle[rid] then return end
    seededIdle[rid] = true
    CreateThread(function()
        local res = lib.callback.await("pickle_restaurants:register:getPublic", false, { id = rid })
        if not (res and res.ok) then seededIdle[rid] = nil; return end
        IdleData[rid] = { label = res.label, theme = res.theme, catalog = res.catalog }
        if LiveTickets[rid] == nil then LiveTickets[rid] = res.tickets or {} end
        if shownRid == rid then pushedRid = nil end -- have data now → (re)push this tick
    end)
end

local function idlePayload(rid)
    local d = IdleData[rid]
    if not d then return nil end
    -- `idle` tells the page this is the always-on board, not a cashier session, so it
    -- hides the staff-only chrome (balance, close button) — there's no cursor to drive
    -- them anyway until someone interacts.
    return { restaurantId = rid, label = d.label, theme = d.theme, idle = true,
             catalog = d.catalog, tickets = LiveTickets[rid] or {} }
end

-- Nearest restaurant that has a counter placed, by the prop's own world position — no
-- range gate (a placed screen stays painted whenever a counter exists anywhere; the
-- replacement is global per txd+txn, so only WHICH restaurant's data depends on which
-- counter you're nearest). Mirrors modules/screens' nearestFor.
local function nearestCounterRestaurant()
    local here = GetEntityCoords(PlayerPedId())
    local best, bestDist
    for _, r in pairs(Restaurants or {}) do
        -- Same range gate as modules/screens' nearestFor: prop ROWS exist for every
        -- restaurant, but only the one we're AT has a counter entity to paint (props are
        -- loaded by proximity — modules/main's reconciler).
        if IsRestaurantLoaded and IsRestaurantLoaded(r.id) then
            for _, p in ipairs(r.props or {}) do
                if p.prop_type == PROP_TYPE then
                    local dist = #(here - vector3(p.x + 0.0, p.y + 0.0, p.z + 0.0))
                    if not bestDist or dist < bestDist then bestDist, best = dist, r end
                end
            end
        end
    end
    return best
end

-- One pass of the idle driver: paint the nearest counter's register board. Paused while
-- a session owns the DUI (the interactive payload is up); resumed on close.
local function driveIdle()
    if active then return end
    ensureDui()
    local r = nearestCounterRestaurant()
    if not r then
        removeScreen(); shownRid = nil; pushedRid = nil
        return
    end
    applyScreen(RegisterModel())
    shownRid = r.id
    seedIdle(r.id)
    if IdleData[r.id] and pushedRid ~= r.id then
        pushData(idlePayload(r.id))
        pushedRid = r.id
        rebindAfterPaint(RegisterModel())
    end
end

CreateThread(function()
    -- Warm the DUI at start so the runtime texture holds a real frame before the first
    -- bind (the shared cold-DUI fix). Then run the idle driver.
    Wait(700)
    ensureDui()
    while true do
        driveIdle()
        Wait(TICK_MS)
    end
end)

-- Live open-ticket list: forward to the DUI whenever it's the restaurant currently shown
-- (idle board) or being rung up (session). Cached for every restaurant so a board that
-- activates later is current.
RegisterNetEvent("pickle_restaurants:sales:orders", function(rid, orders)
    if not rid then return end
    LiveTickets[rid] = orders or {}
    local showing = (active and active.rid) or shownRid
    if showing == rid then pushOrders(orders) end
end)

-- Re-seed the idle board after a world/config (re)build (main's ApplySync calls this,
-- like RefreshScreens): the catalog/menu may have changed, so drop the seed cache and
-- force a re-push on the next driver pass.
function RefreshRegister()
    seededIdle, IdleData = {}, {}
    pushedRid = nil
    if not active then driveIdle() end
end

-- Called by main's SpawnProp the instant a counter model streams in. AddReplaceTexture
-- only holds while a prop of the model EXISTS, and a placed counter can stream out/in,
-- so re-bind the register screen now against the DUI's current (already-painted) frame
-- while the prop is present (mirrors modules/screens' ReassertScreenFor).
function ReassertRegister()
    if active or not dui then return end
    if appliedModel then
        RemoveReplaceTexture(appliedModel, REGISTER_TXN)
        local txdName, texName = rtNames()
        AddReplaceTexture(appliedModel, REGISTER_TXN, txdName, texName)
    else
        driveIdle()
    end
end

-- ─── map the virtual cursor to a surface pixel (mirrors RegisterDui's stage) ──

local function surfacePoint(u, v)
    local W, H = REGISTER.w, REGISTER.h
    local rot = orient.rot % 360
    local swap = (rot == 90 or rot == 270)
    local DW = swap and H or W
    local DH = swap and W or H
    local fx = orient.flipx and -1.0 or 1.0
    local fy = orient.flipy and -1.0 or 1.0
    local cx = (u - 0.5) * DW * fx
    local cy = (v - 0.5) * DH * fy
    local rad = math.rad(rot)
    local cos, sin = math.cos(rad), math.sin(rad)
    local sx = W * 0.5 + (cos * cx - sin * cy)
    local sy = H * 0.5 + (sin * cx + cos * cy)
    return math.floor(sx + 0.5), math.floor(sy + 0.5)
end

-- ─── scripted framing camera ─────────────────────────────────────────────────

local registerCam = nil

local function localToWorld(prop, ent, off)
    if ent and DoesEntityExist(ent) then
        return GetOffsetFromEntityInWorldCoords(ent, off.x, off.y, off.z)
    end
    local h = math.rad(prop.heading or 0.0)
    local c, s = math.cos(h), math.sin(h)
    return vec3(prop.x + (off.x * c - off.y * s), prop.y + (off.x * s + off.y * c), (prop.z or 0.0) + off.z)
end

local function setupCam(prop, ent, geo)
    if registerCam then DestroyCam(registerCam, false); registerCam = nil end
    local camPos  = localToWorld(prop, ent, geo.cam)
    local lookPos = localToWorld(prop, ent, geo.look)
    registerCam = CreateCam("DEFAULT_SCRIPTED_CAMERA", true)
    SetCamCoord(registerCam, camPos.x, camPos.y, camPos.z)
    PointCamAtCoord(registerCam, lookPos.x, lookPos.y, lookPos.z)
    SetCamFov(registerCam, geo.fov or 30.0)
    SetCamActive(registerCam, true)
    RenderScriptCams(true, true, 350, true, true)
end

local function teardownCam()
    RenderScriptCams(false, true, 350, true, true)
    if registerCam then DestroyCam(registerCam, false); registerCam = nil end
end

-- ─── the interactive session ─────────────────────────────────────────────────

-- Per-frame, cleared on close, beep on the first frame only — see the same helper in
-- modules/kiosk for why (a re-armed bubble outlives the session it describes).
local helpBeeped = false
local function helpThisFrame()
    AddTextEntry("pk_register_help", _L("register_exit_hint"))
    BeginTextCommandDisplayHelp("pk_register_help")
    EndTextCommandDisplayHelp(0, false, not helpBeeped, -1)
    helpBeeped = true
end

function CloseRegisterScreen()
    if not active then return end
    active = nil
    ClearAllHelpMessages()
    helpBeeped = false
    if dui then SendDuiMouseUp(dui, "l") end -- release a held button, just in case
    local ped = PlayerPedId()
    FreezeEntityPosition(ped, false)
    SetLocalPedHidden(false)
    teardownCam()
    -- Hand the screen back to the idle board (keep it bound — never blank).
    pushedRid = nil
    driveIdle()
end

-- Opened from main's counter interaction (physical register only). `ent` is the spawned
-- counter model, used to frame the camera exactly.
function OpenRegisterScreen(prop, ent)
    if active then return end
    local rid = prop.restaurant_id
    local data = lib.callback.await("pickle_restaurants:sales:getRegister", false, { id = rid })
    if not data or not data.ok then
        return ShowNotification((data and data.error) or _L("sales_no_work"))
    end
    local geo = REGISTER.geo[prop.prop_type] or REGISTER.geo["counter"]
    local model = RegisterModel()

    ensureDui()
    applyScreen(model)
    setupCam(prop, ent, geo)
    vx, vy = 0.5, 0.5
    lastCurX, lastCurY = nil, nil -- force the cursor to (re)show, centred
    local ped = PlayerPedId()
    FreezeEntityPosition(ped, true)
    SetLocalPedHidden(true)
    active = { rid = rid, ent = ent }

    -- Swap the idle board for the cashier's perm-gated payload (adds the nearby
    -- customers + balance). Re-bind once it paints.
    pushData(data)
    LiveTickets[rid] = data.tickets or LiveTickets[rid] or {}
    rebindAfterPaint(model)
end

-- RegisterDui's close button asks us to step away.
RegisterNUICallback("register:exit", function(_, cb)
    CloseRegisterScreen()
    cb("ok")
end)

-- The focus / cursor loop: only forwards input while a session is open.
CreateThread(function()
    while true do
        if active then
            DisableAllControlActions(0)
            -- ESC steps away from the register; it must never also reach the frontend.
            -- DisableAllControlActions alone doesn't stop it — force the menu closed
            -- (same pattern as the gizmo/placement loops).
            ForcePauseMenuClosed()
            HideHudAndRadarThisFrame()
            helpThisFrame()

            local dx = GetDisabledControlNormal(0, 1) -- LookLeftRight
            local dy = GetDisabledControlNormal(0, 2) -- LookUpDown
            local pressed     = IsDisabledControlPressed(0, 24)     or IsDisabledControlPressed(0, 237)
            local justPressed = IsDisabledControlJustPressed(0, 24)  or IsDisabledControlJustPressed(0, 237)
            local justUp      = IsDisabledControlJustReleased(0, 24) or IsDisabledControlJustReleased(0, 237)
            -- Freeze the cursor while the button is held OR released this frame so
            -- mousedown and mouseup land on the same element (needed to fire a `click`).
            if not pressed and not justUp then
                local rot  = orient.rot % 360
                local swap = (rot == 90 or rot == 270)
                local DW   = swap and REGISTER.h or REGISTER.w
                local DH   = swap and REGISTER.w or REGISTER.h
                local ref  = math.min(DW, DH)
                vx = math.max(0.0, math.min(1.0, vx + dx * REGISTER.sensitivity * (ref / DW)))
                vy = math.max(0.0, math.min(1.0, vy + dy * REGISTER.sensitivity * (ref / DH)))
            end
            if dui then
                local sx, sy = surfacePoint(vx, vy)
                SendDuiMouseMove(dui, sx, sy)
                if vx ~= lastCurX or vy ~= lastCurY or pressed ~= lastDown then
                    lastCurX, lastCurY, lastDown = vx, vy, pressed
                    SendDuiMessage(dui, json.encode({ action = "registerCursor", x = vx, y = vy, down = pressed }))
                end
                if IsDisabledControlPressed(0, 241) then SendDuiMouseWheel(dui, 45, 0) end
                if IsDisabledControlPressed(0, 242) then SendDuiMouseWheel(dui, -45, 0) end
                -- CLICK: hand the page the exact SURFACE pixel and let it hit-test +
                -- dispatch a real DOM click (build-independent — see modules/kiosk).
                if justPressed then
                    SendDuiMessage(dui, json.encode({ action = "registerClick", x = sx, y = sy }))
                end
            end

            -- step away: ESC / Backspace
            if IsDisabledControlJustPressed(0, 200) or IsDisabledControlJustPressed(0, 202)
                or IsDisabledControlJustPressed(0, 322) or IsDisabledControlJustPressed(0, 194) then
                CloseRegisterScreen()
                -- The frame after this one, `active` is false and this loop stops
                -- disabling the pause controls — so the REST of the same keypress
                -- reaches the frontend and the pause menu opens behind the screen we
                -- just stepped away from. GuardPauseKeys (modules/interactive) holds
                -- them off until the key is actually up.
                if GuardPauseKeys then GuardPauseKeys() end
            end

            Wait(0)
        else
            Wait(200)
        end
    end
end)
-- ─── teardown ────────────────────────────────────────────────────────────────

AddEventHandler("onResourceStop", function(res)
    if res ~= GetCurrentResourceName() then return end
    if active then
        RenderScriptCams(false, false, 0, true, true)
        if registerCam then DestroyCam(registerCam, false) end
        local ped = PlayerPedId()
        SetLocalPedHidden(false)
        FreezeEntityPosition(ped, false)
    end
    removeScreen()
    if dui then DestroyDui(dui); dui = nil end
end)
