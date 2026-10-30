-- =============================================
--  modules/interactive | client.lua
--  Shared NUI focus helpers + the cursor->world raycast used to drag
--  ingredients out of the bottom bar into the 3D world.
-- =============================================

NUIView = "none"
-- The theme seed of the most recently opened panel (admin app theme / boss
-- restaurant theme). Kept so an in-world flow that runs WHILE the panel is
-- closed — object placement — can re-skin its NUI overlay to that panel's
-- theme instead of the default kit CloseNUI resets to. See ReassertNUITheme.
LastNUITheme = nil

function OpenNUI(view, data)
    NUIView = view
    LastNUITheme = data and data.theme or nil
    SetNuiFocus(true, true)
    SetNuiFocusKeepInput(false)
    SendNUIMessage({ action = "setView", view = view, data = data })
    -- The read-only corner "Tickets" widget rides along in restaurant-scoped
    -- experiences where staff can't reach the POS ticket tab (the kitchen station
    -- and the boss panel). The register has its own Tickets tab, and the admin
    -- panel is franchise-wide with no single restaurant — both skip the widget.
    local rid = data and (data.restaurantId or data.restaurant_id)
    if rid and ShowTicketWidget and (view == "cooking" or view == "management") then
        ShowTicketWidget(rid, data.theme)
    elseif HideTicketWidget then
        HideTicketWidget()
    end
end

function CloseNUI()
    NUIView = "none"
    SetNuiFocus(false, false)
    SendNUIMessage({ action = "setView", view = "none" })
    if HideTicketWidget then HideTicketWidget() end
end

-- Re-skin the NUI to the last panel's theme WITHOUT reopening a view. The
-- object-placement gizmo runs with the panel closed but still draws a NUI
-- overlay (the [E]/[G] control hints via ShowInteractText); closing for
-- placement reset the theme to the default kit, so the hints rendered off-brand.
-- Called once as placement begins to carry the launching panel's theme through
-- it; the theme is restored anyway when the panel reopens afterward.
function ReassertNUITheme()
    SendNUIMessage({ action = "applyTheme", theme = LastNUITheme })
end

RegisterNUICallback("close", function(_, cb)
    CloseNUI()
    cb({})
end)

-- ESC closes whatever panel is open. A view that owns world props / a camera and
-- has to tear them down first (the cooking station, the eat-in meal view) registers
-- its own closer here instead of polling for the key itself — one per-frame reader
-- for everything, so nothing misses a keypress on a slow tick.
EscapeHandlers = {} -- NUIView name -> function called instead of CloseNUI
function SetEscapeHandler(view, fn) EscapeHandlers[view] = fn end

-- THE PRESS THAT CLOSES A VIEW MUST NOT SURVIVE IT. Every ESC exit here has the same
-- shape: a loop disables the pause controls while the view is up, the key closes the
-- view, and the loop's condition is false on the NEXT frame — so the game gets the
-- rest of that keypress (the hold, the release) with nothing disabling it any more,
-- and the pause menu opens behind the panel that just closed. It reads exactly like
-- ESC doing two things at once, which is what it is.
--
-- So closing ARMS this: the pause inputs stay disabled and the frontend stays shoved
-- shut until the key is physically up plus a short tail, whoever is closing —
-- the fullscreen panels below, the in-world register and the kiosk. One helper, since
-- every one of those had its own copy of the disable and none of them had this.
-- TUNE IN-GAME: the tail.
-- THE GUARD MUST START ON THE FRAME IT IS ARMED. This was one long-lived thread
-- idling at Wait(100) between guards, so arming it did nothing for up to a tenth of a
-- second — and the press it exists to catch is already in flight. That hole is what
-- made the pause menu still flash open on SOME exits and not others: whether it did
-- depended only on where in the idle tick the key landed, which reads exactly like
-- "a slight fade every other exit". Same bug, same fix, as modules/quad's
-- `ensureDrawThread`: no idle poll, a thread started on demand that runs at frame
-- rate and ends when the guard does.
local PAUSE_KEYS = { 199, 200, 322, 194, 202 }
local guardUntil, guarding = 0, false

function GuardPauseKeys(tailMs)
    guardUntil = math.max(guardUntil, GetGameTimer() + (tonumber(tailMs) or 250))
    if guarding then return end
    guarding = true
    CreateThread(function()
        while GetGameTimer() < guardUntil do
            local held = false
            for _, c in ipairs(PAUSE_KEYS) do
                DisableControlAction(0, c, true)
                if IsDisabledControlPressed(0, c) then held = true end
            end
            -- Still on the key: the tail hasn't started yet. Without this a held ESC
            -- outlasts a fixed timer and lands on the frontend the moment we stop.
            if held then guardUntil = GetGameTimer() + 250 end
            ForcePauseMenuClosed()
            Wait(0)
        end
        guarding = false
    end)
end

-- NUI focus alone does NOT stop ESC from reaching the frontend: the game still
-- processes the pause controls, so escaping a panel also opened the pause menu.
-- They are DISABLED every frame a panel is up (and the menu shoved closed if one
-- slipped through), and the key is read back with the Disabled* variants.
-- BACKSPACE (194 / 202) is accepted as the alternate "step out" key.
CreateThread(function()
    while true do
        if NUIView ~= "none" then
            DisableControlAction(0, 199, true) -- INPUT_FRONTEND_PAUSE
            DisableControlAction(0, 200, true) -- INPUT_FRONTEND_PAUSE_ALTERNATE
            DisableControlAction(0, 322, true) -- ESC
            -- Same working pattern as the gizmo/placement loops: force the frontend
            -- back closed before the key is read, so a single tap can't paint a frame
            -- of pause menu on its way to closing the panel.
            ForcePauseMenuClosed()
            if IsDisabledControlJustReleased(0, 322) or IsDisabledControlJustReleased(0, 200)
                or IsDisabledControlJustReleased(0, 202) or IsDisabledControlJustReleased(0, 194) then
                local handler = EscapeHandlers[NUIView]
                if handler then handler() else CloseNUI() end
                -- ...and keep the key away from the frontend on the way OUT. See
                -- GuardPauseKeys: the frame this loop stops guarding is the frame the
                -- game gets the press back, which is how ESC both closed the panel and
                -- opened the pause menu behind it.
                GuardPauseKeys()
            end
            Wait(0)
        else
            Wait(250)
        end
    end
end)

-- Raycast from the live NUI cursor position into the world. Reuses the gizmo's
-- ScreenToWorld helper (defined in modules/gizmo/client.lua). When the station
-- camera is active we raycast from *that* camera so drag-to-place lines up with
-- what the player actually sees.
function CursorToWorld()
    local camPos, camRot
    if StationCam and DoesCamExist(StationCam) then
        camPos = GetCamCoord(StationCam)
        camRot = GetCamRot(StationCam, 2)
    else
        camPos = GetGameplayCamCoord()
        camRot = GetGameplayCamRot(2)
    end
    return GetCursorRaycast(camPos, camRot)
end

-- ─── hiding your OWN body, and only on your own screen ───────────────────────
-- Every in-world interactive view (the station camera, the kiosk, the register) takes
-- the ped out of its own shot. That is a LOCAL presentation choice, and it was being
-- made with `SetEntityVisible(ped, false, false)` — which on a PLAYER ped propagates:
-- everyone else watched the cashier vanish from behind the counter. `SetEntityVisible`
-- has no "local only" mode for a networked ped; the native that does is
-- `SetEntityLocallyInvisible`, documented as "not visible FOR YOURSELF", and it lasts
-- one FRAME, so it has to be re-asserted every tick for as long as the view is open.
--
-- Every consumer goes through here rather than reaching for either native: one loop,
-- one flag, and no way for two views to leave the ped hidden after both have closed.
local pedHidden, pedHideLoop = false, false

function SetLocalPedHidden(on)
    pedHidden = on and true or false
    if not pedHidden then
        -- HEAL a ped hidden by the old networked call (a client that opened a view
        -- before this fix, or a session torn down mid-hide): asserting real visibility
        -- costs nothing when it was never taken away.
        SetEntityVisible(PlayerPedId(), true, false)
        return
    end
    if pedHideLoop then return end
    pedHideLoop = true
    CreateThread(function()
        while pedHidden do
            SetEntityLocallyInvisible(PlayerPedId())
            Wait(0)
        end
        pedHideLoop = false
    end)
end

function IsLocalPedHidden() return pedHidden end

AddEventHandler("onResourceStop", function(res)
    if res ~= GetCurrentResourceName() then return end
    -- never leave a player looking at an invisible body of their own
    if pedHidden then SetLocalPedHidden(false) end
end)
