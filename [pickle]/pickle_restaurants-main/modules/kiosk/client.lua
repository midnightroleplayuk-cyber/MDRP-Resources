-- =============================================
--  modules/kiosk | client.lua
--  The self-service kiosk as an INTERACTIVE in-world DUI screen, not a fullscreen
--  NUI. Idle, the kiosk shows the restaurant's BRAND (modules/rendertarget paints
--  `kiosk_large_brand`, or solid black when no brand is configured). On interact we
--  take that same texture over with OUR order-page DUI (the built React app in
--  "#kiosk" mode — views/KioskDui.tsx), pointed at the model the player is at, winning
--  by last-write-wins over the brand driver's replacement.
--  A scripted camera frames the screen head-on and the player drives a VIRTUAL
--  CURSOR (mouse-look deltas → SendDuiMouse*) over the page. Placing an order or
--  stepping away hands the screen back to the brand driver (ReassertBrandFor).
--
--  There is NO fullscreen focus grab: the game stays in control, we just disable
--  input for the duration and forward the cursor to the DUI. The order still becomes
--  an ordinary kitchen ticket (modules/sales `sales:kioskOrder`), so nothing about
--  the fulfilment flow changes.
--
--  Everything geometry-shaped here (camera framing, cursor speed, DUI aspect) is a
--  best-guess default — TUNE IN-GAME.
-- =============================================

-- The DUI runs the built React app at the kiosk screen's SURFACE aspect. That comes from
-- the `kiosk` render target in the ONE registry (core/shared.lua) — its upright config
-- w/h swapped for a 90/270 turn (RenderTargetSurface) — so the order DUI and the brand
-- screen can never disagree. Edit Config.RenderTargets' `kiosk` entry, not here.
local KIOSK_RT = RenderTargetByKey("kiosk")
local KIOSK_SW, KIOSK_SH = 1080, 1920
if KIOSK_RT then KIOSK_SW, KIOSK_SH = RenderTargetSurface(KIOSK_RT) end
local KIOSK = {
    w = KIOSK_SW, h = KIOSK_SH,
    -- Virtual-cursor speed relative to raw mouse-look delta (higher = faster).
    -- 0.375 = three quarters of the 0.5 this shipped at: an in-world screen is small in
    -- the frame and a mouse-look delta that reads as a gentle turn was throwing the
    -- cursor across the page. TUNE IN-GAME.
    sensitivity = 0.375,
    -- How long (ms) to hold the framed screen on close while the page slides its brand
    -- cover back down over the menu, before we swap the texture to the idle brand
    -- driver. Keep >= KioskDui's SLIDE_MS so the conceal finishes first. TUNE IN-GAME.
    close_ms = 500,
    -- Per-model framing, in the PROP'S local space (y = the prop's forward):
    --   cam  = where the camera sits (in front of the screen, looking back at it)
    --   look = the screen centre the camera aims at
    --   fov  = camera field of view (smaller = tighter crop on the screen)
    -- The two kiosk models differ only in screen height off the ground.
    geo = {
        ["kiosk"]        = { cam = vec3(0.0, -1.85, 0.0), look = vec3(0.0, 0.0, 0.0), fov = 42.0 },
        ["kiosk_ground"] = { cam = vec3(0.0, -1.85, 1.25), look = vec3(0.0, 0.0, 1.25), fov = 44.0 },
    },
}

-- ─── order-page DUI (created once, reused) ───────────────────────────────────

local dui, duiReady, duiGen = nil, false, 0

local function rtNames()
    return ("pickle_kiosk_txd_%d"):format(duiGen), ("pickle_kiosk_tex_%d"):format(duiGen)
end

local function ensureDui()
    if dui then return end
    duiGen = duiGen + 1
    duiReady = false
    local url = ("https://cfx-nui-%s/nui/index.html#kiosk"):format(GetCurrentResourceName())
    dui = CreateDui(url, KIOSK.w, KIOSK.h)
    local txdName, texName = rtNames()
    local txd = CreateRuntimeTxd(txdName)
    CreateRuntimeTextureFromDuiHandle(txd, texName, GetDuiHandle(dui))
    CreateThread(function()
        local mine = duiGen
        while dui and duiGen == mine and not IsDuiAvailable(dui) do Wait(50) end
        if duiGen == mine then duiReady = true end
    end)
end

-- Block until the DUI has loaded the React bundle and is painting real frames (or the
-- timeout lapses). Returns true once ready. Used before framing a kiosk so the FIRST
-- open shows the order page immediately instead of a blank/half-loaded surface that the
-- player has to step away and re-enter to fix.
local function waitDuiReady(timeoutMs)
    ensureDui()
    local mine = duiGen
    local waited = 0
    while dui and duiGen == mine and not IsDuiAvailable(dui) and waited < (timeoutMs or 5000) do
        Wait(50)
        waited = waited + 50
    end
    return dui ~= nil and duiGen == mine and IsDuiAvailable(dui)
end

-- Warm the DUI up shortly after the resource starts so the React bundle is fully loaded
-- and painting BEFORE the player ever interacts. It isn't bound to any prop texture until
-- a kiosk is actually opened (applyOrderScreen) — it just renders offscreen — so this
-- costs one idle DUI in exchange for a glitch-free first open.
CreateThread(function()
    Wait(2000)
    ensureDui()
end)

-- Which kiosk model our order DUI currently replaces (nil = not applied). The
-- replacement is per-txd, so we only take over the model the player is actually at.
local appliedModel = nil
-- The data payload currently being shown/pushed (identity-checked so a stale retry
-- loop from an earlier open stops the moment a new push begins).
local pendingPayload = nil

-- Session state, declared up here so the helper closures below capture the LOCALS
-- (a later declaration would leave those closures reading a stray global instead).
local active = nil          -- { model, ent, rid } while a kiosk is open, else nil
local closing = false       -- true while the brand cover slides down on exit (input still suppressed)
local vx, vy = 0.5, 0.5     -- virtual cursor, normalised [0..1]
local lastCurX, lastCurY    -- last cursor pos pushed to the page (skip idle resends)
local lastDown              -- last button-down state pushed to the page

-- The kiosk screen's texture ORIENTATION, borrowed from the brand target each open
-- (kiosk_large_brand's rot/flip). The order page must paint with the SAME transform
-- to land upright on the prop, so we forward it to KioskDui AND apply it to the
-- cursor→surface mapping below.
--
-- It is PER MODEL: the wall (`kiosk`) and floor (`kiosk_ground`) props embed the same
-- texture but their UVs run it at different rotations, so each has its OWN registry
-- entry and the order page has to paint at whichever one we're standing at — exactly
-- like modules/rendertarget does for the idle brand image.
local orient = { rot = 0, flipx = false, flipy = false }

-- Map the virtual cursor (u,v — the UPRIGHT content the player sees, [0..1]) to a
-- pixel on the DUI SURFACE, applying the exact transform brand.html's withOrient
-- uses (rotate about centre + flips). For a 90/270 turn the content box is landscape
-- (W/H swapped) — which is also why the order UI gets a proper wide layout there.
local function surfacePoint(u, v)
    local W, H = KIOSK.w, KIOSK.h
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

local function applyOrderScreen(model)
    if appliedModel == model then return end
    if appliedModel then RemoveReplaceTexture(appliedModel, "kiosk_large_brand") end
    local txdName, texName = rtNames()
    AddReplaceTexture(model, "kiosk_large_brand", txdName, texName)
    appliedModel = model
end

local function removeOrderScreen()
    if not appliedModel then return end
    RemoveReplaceTexture(appliedModel, "kiosk_large_brand")
    appliedModel = nil
end

-- Borrow the orientation (and surface aspect) of the render target for the kiosk the
-- player just walked up to. `prop_type` IS the registry key ("kiosk" / "kiosk_ground"),
-- so no separate model→key map is needed. A rot that changes the SURFACE aspect (a
-- 90/270 turn on only one of the two) means the DUI itself is the wrong shape —
-- recreate it at the new size, since a DUI can't be resized in place.
local function borrowOrient(propType)
    local t = RenderTargetByKey(propType) or RenderTargetByKey("kiosk")
    if not t then return end
    orient.rot   = t.rot or 0
    orient.flipx = t.flipx or false
    orient.flipy = t.flipy or false
    local sw, sh = RenderTargetSurface(t)
    if sw ~= KIOSK.w or sh ~= KIOSK.h then
        KIOSK.w, KIOSK.h = sw, sh
        removeOrderScreen()
        if dui then DestroyDui(dui); dui = nil end
        ensureDui()
    end
end

-- Re-bind once the page has actually painted a real frame, so the texture binds to
-- live content instead of the blank surface the first bind would catch (the same
-- blank-on-load fix modules/rendertarget / modules/screens use).
local function rebindAfterPaint(model)
    CreateThread(function()
        local tries = 0
        while dui and not IsDuiAvailable(dui) and tries < 150 do Wait(30); tries = tries + 1 end
        if not dui or appliedModel ~= model then return end
        Wait(500)
        if dui and appliedModel == model then
            RemoveReplaceTexture(model, "kiosk_large_brand")
            local txdName, texName = rtNames()
            AddReplaceTexture(model, "kiosk_large_brand", txdName, texName)
        end
    end)
end

-- KioskDui POSTs here the instant it has rendered the order UI (i.e. it received our
-- data). That both ACKs the data push (so we stop resending) and lets us bind the
-- texture against a live frame (mirrors rt:painted / screen:painted).
local dataAcked = false
RegisterNUICallback("kiosk:painted", function(_, cb)
    dataAcked = true
    if dui and appliedModel then
        RemoveReplaceTexture(appliedModel, "kiosk_large_brand")
        local txdName, texName = rtNames()
        AddReplaceTexture(appliedModel, "kiosk_large_brand", txdName, texName)
    end
    cb("ok")
end)

-- Send the order data to the page (idempotent — safe to resend; the page just re-renders
-- the same content). Carries the screen orientation so the page lands upright.
local function sendKioskData(payload)
    if dui then SendDuiMessage(dui, json.encode({ action = "kioskData", data = payload, orient = orient })) end
end

-- Render the order page into the DUI and BLOCK until it has painted a real frame (the
-- page POSTs kiosk:painted), or the timeout lapses. Because the DUI is pre-warmed the
-- page's listener already exists, so the first send is received immediately; we resend
-- each tick only as a safety net. Returns true once painted.
local function pushKioskDataAndWait(payload, timeoutMs)
    dataAcked = false
    pendingPayload = payload
    local mine = payload
    local waited = 0
    while dui and pendingPayload == mine and not dataAcked and waited < (timeoutMs or 2000) do
        sendKioskData(payload)
        Wait(100)
        waited = waited + 100
    end
    return dataAcked
end

-- ─── scripted framing camera ─────────────────────────────────────────────────

local kioskCam = nil

-- World position of a prop-local offset, from the entity when we have it (exact),
-- else computed from the placed heading (fallback if the prop isn't streamed).
local function localToWorld(prop, ent, off)
    if ent and DoesEntityExist(ent) then
        return GetOffsetFromEntityInWorldCoords(ent, off.x, off.y, off.z)
    end
    local h = math.rad(prop.heading or 0.0)
    local c, s = math.cos(h), math.sin(h)
    return vec3(prop.x + (off.x * c - off.y * s), prop.y + (off.x * s + off.y * c), (prop.z or 0.0) + off.z)
end

local function setupCam(prop, ent, geo)
    if kioskCam then DestroyCam(kioskCam, false); kioskCam = nil end -- re-frame: no leak
    local camPos  = localToWorld(prop, ent, geo.cam)
    local lookPos = localToWorld(prop, ent, geo.look)
    kioskCam = CreateCam("DEFAULT_SCRIPTED_CAMERA", true)
    SetCamCoord(kioskCam, camPos.x, camPos.y, camPos.z)
    PointCamAtCoord(kioskCam, lookPos.x, lookPos.y, lookPos.z)
    SetCamFov(kioskCam, geo.fov or 42.0)
    SetCamActive(kioskCam, true)
    RenderScriptCams(true, true, 350, true, true)
end

local function teardownCam()
    RenderScriptCams(false, true, 350, true, true)
    if kioskCam then DestroyCam(kioskCam, false); kioskCam = nil end
end

-- ─── the interactive session ─────────────────────────────────────────────────

-- The exit hint is drawn EVERY FRAME the session is up, never re-armed for its own
-- ~7s lifetime: a bubble left to live out its timer is still on screen seconds after
-- you have stepped away from the kiosk, telling you how to leave something you have
-- already left. Per-frame is gone the frame the session ends — the same way
-- modules/seating's seated prompt behaves, which is the model here.
--
-- The BEEP is what the old expire-and-re-arm guard was really avoiding, so it fires
-- on the first frame only. Silencing a repeat is the fix for that; letting the
-- message outlive the thing it describes was not.
local helpBeeped = false
local function helpThisFrame()
    AddTextEntry("pk_kiosk_help", _L("kiosk_exit_hint"))
    BeginTextCommandDisplayHelp("pk_kiosk_help")
    EndTextCommandDisplayHelp(0, false, not helpBeeped, -1)
    helpBeeped = true
end

function CloseKioskScreen()
    if not active then return end
    local model = active.model
    active = nil
    -- take the hint down NOW: the last frame's bubble would otherwise sit there for
    -- its full lifetime while the player walks off
    ClearAllHelpMessages()
    helpBeeped = false
    if dui then
        SendDuiMouseUp(dui, "l") -- release a held button, just in case
        -- Slide the brand cover back down over the menu. We hold the framed screen
        -- (camera + hidden ped) through the slide so the conceal is actually seen, then
        -- swap to the idle brand — which looks identical to the cover, so it's seamless.
        SendDuiMessage(dui, json.encode({ action = "kioskClosing" }))
    end
    -- Keep input suppressed + HUD hidden while the cover slides (the cursor loop reads
    -- `closing`). The handoff is DEFERRED to its own thread so this returns immediately
    -- — CloseKioskScreen is called from inside the cursor loop (the ESC path), and a
    -- Wait here would block that loop and drop the input suppression mid-slide.
    closing = true
    CreateThread(function()
        Wait(KIOSK.close_ms)
        if active then return end -- a new open raced us; leave its session intact
        closing = false
        local ped = PlayerPedId()
        FreezeEntityPosition(ped, false)
        SetLocalPedHidden(false)
        teardownCam()
        removeOrderScreen()
        -- Hand the screen back to the brand driver (idle brand / black default) by
        -- re-binding its render target now the order screen is gone — otherwise the
        -- model would revert to its baked-in placeholder texture until the next tick.
        if ReassertBrandFor then ReassertBrandFor(model) end
        if dui then SendDuiMessage(dui, json.encode({ action = "kioskReset" })) end
    end)
end

-- Opened from main's kiosk interaction (both wall `kiosk` and floor `kiosk_ground`).
local opening = false
function OpenKioskScreen(prop, ent)
    if active or opening then return end
    opening = true
    local rid = prop.restaurant_id

    -- Kick the DUI loading FIRST (usually already warm from the startup pre-warm) so the
    -- bundle keeps loading WHILE we fetch the kiosk data over the network.
    ensureDui()
    -- ...at THIS model's texture orientation (the wall kiosk paints a half turn from the
    -- floor one), so the order page and the cursor mapping land upright on the prop.
    borrowOrient(prop.prop_type)

    local data = lib.callback.await("pickle_restaurants:sales:getKiosk", false, { id = rid })
    if not data or not data.ok then
        opening = false
        return ShowNotification((data and data.error) or _L("sales_kiosk_unavailable"))
    end

    -- Don't touch the screen until the DUI is actually loaded and painting — otherwise
    -- the first open catches a blank/half-rendered surface and the player has to re-enter.
    -- The data fetch above already gave it a head start; wait out whatever's left.
    waitDuiReady(5000)
    if active then opening = false; return end -- a concurrent open won the race

    local geo = KIOSK.geo[prop.prop_type] or KIOSK.geo["kiosk"]

    closing = false -- cancel any in-flight close handoff; this open owns the screen now

    -- Render the order page (brand cover DOWN over the menu) into the DUI and wait for it
    -- to paint BEFORE we bind the texture to the prop. The kiosk's idle screen is the
    -- brand texture (modules/rendertarget); by making our first bound frame the matching
    -- brand cover — not the blank bg placeholder the page shows before data arrives — the
    -- swap is seamless instead of a flash. The cover then lifts (kioskReveal) below.
    pushKioskDataAndWait(data, 2000)

    -- Take the kiosk screen texture over on THIS model only. The brand driver's target
    -- for this model stays applied; our order screen wins by last-write-wins, and
    -- CloseKioskScreen hands it back (ReassertBrandFor) when we step away.
    applyOrderScreen(prop.model)

    setupCam(prop, ent, geo)
    vx, vy = 0.5, 0.5
    lastCurX, lastCurY = nil, nil -- force the cursor to (re)show, centred, this open
    -- Hide the player for the duration, like stepping into an interactive entity:
    -- the scripted camera frames only the screen, so the ped shouldn't be in shot.
    local ped = PlayerPedId()
    FreezeEntityPosition(ped, true)
    SetLocalPedHidden(true)
    active = { model = prop.model, ent = ent, rid = rid }

    rebindAfterPaint(prop.model)
    -- Now that the screen is bound and the camera is framing it, lift the brand cover to
    -- reveal the menu (the page holds it down until we ask, so the reveal is always seen
    -- and never races the texture swap).
    if dui then SendDuiMessage(dui, json.encode({ action = "kioskReveal" })) end
    opening = false
end

-- KioskDui's "Done" button asks us to step away.
RegisterNUICallback("kiosk:exit", function(_, cb)
    CloseKioskScreen()
    cb("ok")
end)

-- The focus / cursor loop: only spins while a kiosk is open.
CreateThread(function()
    while true do
        if active then
            DisableAllControlActions(0)
            -- ESC steps away from the kiosk; it must never also reach the frontend.
            -- DisableAllControlActions alone doesn't stop it — force the menu closed
            -- (same pattern as the gizmo/placement loops).
            ForcePauseMenuClosed()
            HideHudAndRadarThisFrame()
            helpThisFrame()

            -- mouse-look deltas drive the virtual cursor (read even while disabled).
            -- Two things happen with (vx,vy): the DUI mouse is moved to the matching
            -- SURFACE pixel (so clicks hit-test correctly), and the page is told the
            -- UPRIGHT position so it can draw the cursor ITSELF. CEF doesn't composite
            -- its own cursor onto the runtime texture in this build, and a world-drawn
            -- sprite lives in a different projection than the click — so the page draws
            -- the cursor inside its rotated stage, guaranteeing it sits exactly where a
            -- click lands. Both are the same (vx,vy), so cursor and click always agree.
            local dx = GetDisabledControlNormal(0, 1) -- LookLeftRight
            local dy = GetDisabledControlNormal(0, 2) -- LookUpDown
            -- Left mouse, detected two ways for robustness: INPUT_ATTACK (24) and
            -- INPUT_CURSOR_ACCEPT (237). Whichever the build reports for a disabled
            -- left-click, we forward it to the DUI.
            local pressed     = IsDisabledControlPressed(0, 24)     or IsDisabledControlPressed(0, 237)
            local justPressed = IsDisabledControlJustPressed(0, 24)  or IsDisabledControlJustPressed(0, 237)
            local justUp      = IsDisabledControlJustReleased(0, 24) or IsDisabledControlJustReleased(0, 237)
            -- FREEZE the cursor while the button is held OR being released this frame:
            -- the mousedown and mouseup must land on the SAME element for the browser
            -- to fire a `click`, and a physical mouse always drifts a little as you
            -- press/release. (The release frame also has to stay put — moving it before
            -- SendDuiMouseUp would send the up on a different element.)
            if not pressed and not justUp then
                -- The cursor lives in normalised [0..1] space, but the surface is
                -- PORTRAIT — one unit of vy spans DH pixels, one unit of vx spans DW,
                -- and DH > DW — so equal mouse travel would move the cursor MORE pixels
                -- vertically (it feels faster up/down). Scale each axis by its share of
                -- the SHORTER side so a given mouse motion covers the same number of
                -- pixels either way. (swap for a 90/270 screen, matching surfacePoint.)
                local rot  = orient.rot % 360
                local swap = (rot == 90 or rot == 270)
                local DW   = swap and KIOSK.h or KIOSK.w
                local DH   = swap and KIOSK.w or KIOSK.h
                local ref  = math.min(DW, DH)
                vx = math.max(0.0, math.min(1.0, vx + dx * KIOSK.sensitivity * (ref / DW)))
                vy = math.max(0.0, math.min(1.0, vy + dy * KIOSK.sensitivity * (ref / DH)))
            end
            if dui then
                local sx, sy = surfacePoint(vx, vy)
                SendDuiMouseMove(dui, sx, sy)
                -- push the cursor when it moves OR the button state changes (so the
                -- page can tint it while pressed — a live check that Lua sees the click)
                if vx ~= lastCurX or vy ~= lastCurY or pressed ~= lastDown then
                    lastCurX, lastCurY, lastDown = vx, vy, pressed
                    SendDuiMessage(dui, json.encode({ action = "kioskCursor", x = vx, y = vy, down = pressed }))
                end
                -- wheel scroll (mouse wheel up / down)
                if IsDisabledControlPressed(0, 241) then SendDuiMouseWheel(dui, 45, 0) end
                if IsDisabledControlPressed(0, 242) then SendDuiMouseWheel(dui, -45, 0) end
                -- CLICK. CEF's SendDuiMouseDown/Up don't resolve to a page click in
                -- this build (they don't reuse the last SendDuiMouseMove position, so
                -- the click lands at the surface origin, not under the cursor). So we
                -- hand the page the exact SURFACE pixel and let it hit-test + dispatch
                -- a real DOM click there itself (kioskClick) — build-independent.
                if justPressed then
                    SendDuiMessage(dui, json.encode({ action = "kioskClick", x = sx, y = sy }))
                end
            end

            -- step away: ESC / Backspace
            if IsDisabledControlJustPressed(0, 200) or IsDisabledControlJustPressed(0, 202)
                or IsDisabledControlJustPressed(0, 322) or IsDisabledControlJustPressed(0, 194) then
                CloseKioskScreen()
                -- The frame after this one, `active` is false and this loop stops
                -- disabling the pause controls — so the REST of the same keypress
                -- reaches the frontend and the pause menu opens behind the screen we
                -- just stepped away from. GuardPauseKeys (modules/interactive) holds
                -- them off until the key is actually up.
                if GuardPauseKeys then GuardPauseKeys() end
            end

            Wait(0)
        elseif closing then
            -- Hold the frame steady while the brand cover slides down: keep input off
            -- and the HUD hidden, but no cursor/click handling (the session is over).
            DisableAllControlActions(0)
            HideHudAndRadarThisFrame()
            Wait(0)
        else
            Wait(250)
        end
    end
end)
-- ─── teardown ────────────────────────────────────────────────────────────────

AddEventHandler("onResourceStop", function(res)
    if res ~= GetCurrentResourceName() then return end
    if active then
        RenderScriptCams(false, false, 0, true, true)
        if kioskCam then DestroyCam(kioskCam, false) end
        local ped = PlayerPedId()
        SetLocalPedHidden(false)
        FreezeEntityPosition(ped, false)
    end
    removeOrderScreen()
    if dui then DestroyDui(dui); dui = nil end
end)
