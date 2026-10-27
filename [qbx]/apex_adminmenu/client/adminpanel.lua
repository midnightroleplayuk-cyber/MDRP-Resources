-- ============================================================
-- Admin Panel — client controller (separate from quick menu)
-- Opens via /adminpanel or the configured keybind (default F6).
-- Uses its own NUI page at html/admin/index.html.
-- ============================================================

local panelOpen = false
local panelBlips = {}   -- [id] = handle
-- Hoisted so OpenAdminPanel can fold any avatars that arrived while
-- the panel was closed into the bootstrap snapshot before sending it
-- to the NUI. Populated by the `panel:avatarReady` net event below.
local avatarBuffer = {} -- [license] = url

-- ── Focus ──────────────────────────────────────────────────
-- "Keep input" is a GLOBAL flag another resource may have left on (a
-- HUD that wanted a cursor without eating the keyboard). With it on, the
-- keys typed into the panel also reach the game: T opens the chat over
-- the panel, letters move the ped, F9 opens the quick menu. The panel is
-- full-screen and wants the keyboard to itself, so it turns the flag off
-- while open and puts it back the way it found it.
local keepInputWas = false

local function keepingInput()
    if type(IsNuiFocusKeepingInput) ~= 'function' then return false end
    local ok, v = pcall(IsNuiFocusKeepingInput)
    return ok and v == true
end

local function setFocus(state)
    if state then
        keepInputWas = keepingInput()
        SetNuiFocus(true, true)
        if keepInputWas then SetNuiFocusKeepInput(false) end
    else
        SetNuiFocus(false, false)
        if keepInputWas then SetNuiFocusKeepInput(true) end
        keepInputWas = false
    end
end

-- Forward declarations; the bodies live further down with the key table.
local StartPanelFocusWatch, StartKeyCaptureWatch
local captureWatchRunning = false
local PANEL_VERSION = GetResourceMetadata(GetCurrentResourceName(), 'version', 0) or '?'

OpenAdminPanel = function()
    if panelOpen then return end
    local boot = lib.callback.await('apex_adminmenu:panel:bootstrap', false)
    if not boot or not boot.allowed then
        TriggerEvent('apex_adminmenu:notify', 'Admin Panel',
            'You do not have access to the admin panel.', 'error')
        return
    end
    panelOpen = true
    setFocus(true)

    -- Fold any avatars buffered while the panel was closed into the
    -- snapshot the server just produced. This guarantees that every
    -- avatar we've ever heard about is present in the boot payload,
    -- so the NUI cache is fully populated before the first render.
    boot.avatarSnapshot = boot.avatarSnapshot or {}
    for lic, url in pairs(avatarBuffer) do
        if not boot.avatarSnapshot[lic] then
            boot.avatarSnapshot[lic] = url
        end
    end

    -- Image config for the Vehicles page. Same shape apex_garage sends,
    -- so the NUI-side lookup is a straight port.
    boot.images = PanelImageConfig()

    SendNUIMessage({ action = 'panel:open', boot = boot })
    StartPanelEscapeWatch()
    StartPanelFocusWatch()
    -- F8: which build is actually running. The first question when "the
    -- update changed nothing".
    print(('^5[apex_adminmenu]^7 Admin Panel v%s opened (server reports v%s)'):format(PANEL_VERSION, tostring(boot.version or '?')))
end

-- Resolved here rather than in the NUI because `base` needs the live
-- resource name for the nui:// URL.
function PanelImageConfig()
    local img = Config.VehicleImages or {}
    if img.enabled == false then return false end
    return {
        custom = img.custom ~= false,
        base   = ('nui://%s/html/images/'):format(GetCurrentResourceName()),
        exts   = img.extensions or { 'png', 'jpg', 'jpeg', 'webp' },
        url    = img.fallbackUrl or false,
    }
end

-- ── Escape to close ────────────────────────────────────────
-- The panel's own Escape handler lives in html/admin/app.js, i.e.
-- INSIDE the iframe. It only fires when the iframe holds keyboard
-- focus; if the click that opened the panel (or any click on the
-- parent document) left focus on the outer page, the key event never
-- reached it and Escape did nothing. The parent page's handler is no
-- help either — it only closes the F9 quick menu.
--
-- Reading the key from Lua sidesteps the whole question of which
-- document has focus. IsRawKeyDown also survives the control-disabling
-- other features do, the same reason the movable-menu toggle uses it.
local escapeWatchRunning = false

function StartPanelEscapeWatch()
    if escapeWatchRunning then return end
    escapeWatchRunning = true

    CreateThread(function()
        local VK_ESCAPE = 0x1B
        local hasRaw    = type(IsRawKeyDown) == 'function'
        local wasDown   = false

        while panelOpen do
            Wait(0)

            -- Suppress the game's own Escape binding for as long as the
            -- panel is up, otherwise the panel closes AND the pause menu
            -- opens on the same keypress.
            DisableControlAction(0, 200, true) -- INPUT_FRONTEND_PAUSE
            DisableControlAction(0, 322, true) -- ESC

            local down
            if hasRaw then
                local ok, res = pcall(IsRawKeyDown, VK_ESCAPE)
                down = ok and res or false
            else
                -- Fallback for builds without the raw-key natives.
                down = IsDisabledControlPressed(0, 200) or IsDisabledControlPressed(0, 322)
            end

            -- Close on the press edge, not while held. Not while a key
            -- capture overlay owns Escape (panelEscGuard), and not for the
            -- press that just cancelled one (escSwallowUntil).
            if down and not wasDown and not panelEscGuard and GetGameTimer() >= escSwallowUntil then
                CloseAdminPanel()
                break
            end
            wasDown = down
        end

        escapeWatchRunning = false
    end)
end

-- NUI focus can be taken down from under the panel: a second NUI of this
-- resource (the F9 quick menu, the reports pane) or of another one opens
-- on top, then closes with SetNuiFocus(false) — the panel is still drawn
-- but the cursor is gone and nothing in it can be clicked or typed into,
-- and the only way out was Esc + reopen ("I have to restart the menu").
-- While the panel is open and nothing else holds the focus, it takes the
-- focus back and asks the page to put the keyboard where it was.
StartPanelFocusWatch = function()
    CreateThread(function()
        Wait(500)
        while panelOpen do
            Wait(250)
            if panelOpen and not IsNuiFocused() then
                SetNuiFocus(true, true)
                SetNuiFocusKeepInput(false)
                SendNUIMessage({ action = 'panel:refocus' })
            end
        end
    end)
end

CloseAdminPanel = function()
    if not panelOpen then return end
    panelOpen = false
    panelEscGuard = false
    setFocus(false)
    SendNUIMessage({ action = 'panel:close' })
end

-- Other modules (the notify handler in main.lua) need to know whether the
-- panel is up, because a toast drawn outside it is drawn UNDER it.
function IsPanelOpen() return panelOpen end

-- ── Server answers, drawn inside the panel ──────────────────
-- Every refusal and confirmation the server sends about a panel action
-- lands here (kind = 'error' | 'success' | 'warning' | 'info'). While the
-- panel is open it is shown as one of the panel's own toasts; otherwise
-- (a keybind fired with the panel closed) through the usual notify.
RegisterNetEvent('apex_adminmenu:panel:toast', function(kind, message, duration)
    message = tostring(message or '')
    if message == '' then return end
    if panelOpen then
        SendNUIMessage({ action = 'panel:toast', kind = kind or 'info', message = message, duration = duration })
    else
        TriggerEvent('apex_adminmenu:notify', 'Admin Panel', message, kind or 'info')
    end
end)

-- The key-capture overlay (Settings > Keybinds) says "press Esc to cancel".
-- The Lua Escape watch below would close the whole panel on that same
-- press, so the overlay asks for a guard while it is up.
--
-- While the guard is up this side also READS the keyboard for the overlay
-- (StartKeyCaptureWatch). CEF only delivers key events to a document that
-- holds keyboard focus, and the panel is an iframe inside the quick menu's
-- page: when nothing in it had been clicked, or another NUI had taken the
-- focus frame, the overlay sat on "Waiting…" for keys it would never see
-- — with Esc guarded and the overlay covering every button, the panel was
-- stuck until the resource was restarted. The raw-key natives do not care
-- which document is focused, so the key is read here and handed to the
-- page as `panel:keyCaptured`; the page accepts whichever arrives first.
panelEscGuard  = false
escSwallowUntil = 0   -- GetGameTimer() before which an Esc press is the overlay's, not ours
local escGuardSince = 0
RegisterNUICallback('panel:escGuard', function(data, cb)
    local on = type(data) == 'table' and data.on == true
    cb('ok')
    if on and not panelEscGuard then
        panelEscGuard, escGuardSince = true, GetGameTimer()
        StartKeyCaptureWatch()
    elseif not on then
        panelEscGuard = false
    end
end)

RegisterNUICallback('panel:close', function(_, cb)
    CloseAdminPanel()
    cb('ok')
end)

-- Generic relay: NUI -> server event with permission check there.
RegisterNUICallback('panel:event', function(data, cb)
    cb('ok')
    if not data or not data.name then return end
    TriggerServerEvent('apex_adminmenu:panel:' .. data.name, table.unpack(data.args or {}))
end)

-- ── Vehicle model → spawn code ─────────────────────────────
-- ESX stores the model as a numeric hash inside owned_vehicles.vehicle,
-- which is why the panel listed cars as "841808271". Resolving it needs
-- GetDisplayNameFromVehicleModel — a CLIENT native — so the server can't
-- do it and we enrich the rows here on the way to the NUI.
--
-- Identical to apex_garage's Garage.SpawnName, on purpose: the spawn code
-- is also the key the image lookup uses (html/images/<spawncode>.png).
function PanelSpawnName(model)
    if not model then return nil end
    local hash = tonumber(model) or joaat(tostring(model))
    local name = GetDisplayNameFromVehicleModel(hash)
    if not name or name == '' or name == 'CARNOTFOUND' or name == 'NULL' then return nil end
    return name:lower()
end

-- Human label for a model: the game's localised display name when it has
-- one ("Adder"), otherwise the spawn code, otherwise whatever we were given.
local function panelVehicleLabel(spawn, model)
    if spawn then
        local label = GetLabelText(spawn:upper())
        if label and label ~= '' and label ~= 'NULL' then return label end
        return spawn
    end
    return tostring(model or '—')
end

-- Callback relay so the UI can use a single fetch() pattern.
RegisterNUICallback('panel:cb', function(data, cb)
    if not data or not data.name then cb({}); return end
    local args = data.args or {}
    local res  = lib.callback.await('apex_adminmenu:panel:' .. data.name, false, table.unpack(args))

    if data.name == 'vehicles' and type(res) == 'table' then
        for i = 1, #res do
            local row = res[i]
            if type(row) == 'table' then
                row.spawn = PanelSpawnName(row.model)
                row.label = panelVehicleLabel(row.spawn, row.label or row.model)
            end
        end
    end

    cb(res)
end)

-- Coords helper for blip "Use current coords".
RegisterNUICallback('panel:myCoords', function(_, cb)
    local c = GetEntityCoords(cache.ped or PlayerPedId())
    cb({ x = c.x, y = c.y, z = c.z, heading = GetEntityHeading(cache.ped or PlayerPedId()) })
end)

-- ── Console live stream ────────────────────────────────────
RegisterNetEvent('apex_adminmenu:panel:consoleLine', function(line)
    if panelOpen then SendNUIMessage({ action = 'panel:console', line = line }) end
end)

-- ── Settings save result ───────────────────────────────────
-- The Settings page used to show "Settings saved." the instant the
-- button was clicked, with nothing on the other end confirming it. A
-- save the server refused (missing permission, unwritable table) looked
-- identical to one that worked, which is how "I put the webhook links in
-- and they get deleted" went unexplained for so long. The server now
-- answers every save; relay that answer to the UI verbatim.
RegisterNetEvent('apex_adminmenu:panel:globalSettingsSaved', function(ok, message, settings)
    if not panelOpen then return end
    SendNUIMessage({
        action   = 'panel:settingsSaved',
        ok       = ok and true or false,
        message  = message,
        settings = settings
    })
end)

-- ── Chat live messages ─────────────────────────────────────
RegisterNetEvent('apex_adminmenu:panel:chatMsg', function(msg)
    if panelOpen then SendNUIMessage({ action = 'panel:chatMsg', msg = msg }) end
end)

-- ── Blips: render + sync ───────────────────────────────────
local function clearBlips()
    for id, h in pairs(panelBlips) do
        if DoesBlipExist(h) then RemoveBlip(h) end
        panelBlips[id] = nil
    end
end

local function renderBlips(rows)
    clearBlips()
    for _, b in ipairs(rows or {}) do
        local h = AddBlipForCoord(b.x + 0.0, b.y + 0.0, b.z + 0.0)
        SetBlipSprite(h, b.sprite or 1)
        SetBlipColour(h, b.color or 1)
        SetBlipScale(h, (b.scale or 0.8) + 0.0)
        SetBlipDisplay(h, b.display or 4)
        SetBlipAsShortRange(h, (b.short_range or 1) == 1)
        BeginTextCommandSetBlipName('STRING')
        AddTextComponentSubstringPlayerName(b.label or 'Blip')
        EndTextCommandSetBlipName(h)
        panelBlips[b.id] = h
    end
end

RegisterNetEvent('apex_adminmenu:panel:blipsSync', function(rows)
    renderBlips(rows)
end)

-- ============================================================
-- Spectate stream — target side
-- One capture loop no matter how many admins watch: `specWatchers` is
-- a counter.
--
-- Frames come from our own NUI (html/index.html), which renders the game
-- view straight into a stream-sized canvas (~480p). screenshot-basic
-- grabbed and JPEG-encoded the WHOLE screen instead — a visible hitch on
-- the watched player at every capture — and its 100-300 KB frames took
-- seconds to cross two 200 KB/s latent hops, which is why Monitoring
-- played like a slideshow. It stays as the fallback for clients where
-- the NUI capture does not work, with the NUI shrinking its frames.
-- ============================================================
local MonCfg        = Config.Monitoring or {}
local FRAME_EVERY   = math.max(200, tonumber(MonCfg.Interval) or 500)
local FRAME_WIDTH   = math.max(320, tonumber(MonCfg.Width) or 854)
local FRAME_QUALITY = tonumber(MonCfg.Quality) or 0.5
local UPLOAD_BPS    = 300 * 1024

local specWatchers = 0
local specLoopGen  = 0
-- True from the moment a frame is requested until the server confirms it
-- arrived. The capture loop uses it as backpressure.
local awaitingAck  = false
local frameSeq     = 0
local pendingFrame        -- seq of the frame being captured, nil when idle
local useScreenshotBasic = false -- the NUI capture failed on this client
local captureDead  = false       -- neither capture path works here

local function sendFrame(uri)
    if specWatchers <= 0 or type(uri) ~= 'string' or uri == '' then return end
    -- LATENT: a frame blows past the reliable-event size limit and would
    -- disconnect the target ("Reliable network event size overflow").
    TriggerLatentServerEvent('apex_adminmenu:panel:specFrame', UPLOAD_BPS, uri)
end

local function captureWithScreenshotBasic(seq)
    if GetResourceState('screenshot-basic') ~= 'started' then return false end
    return pcall(function()
        exports['screenshot-basic']:requestScreenshot({
            encoding = 'jpg', quality = 0.7
        }, function(result)
            if pendingFrame ~= seq or type(result) ~= 'string' or result == '' then return end
            local uri = result:match('^data:image/[%w%-+.]+;base64,') and result
                    or ('data:image/jpeg;base64,' .. result)
            SendNUIMessage({ action = 'spec:shrink', seq = seq, uri = uri,
                width = FRAME_WIDTH, quality = FRAME_QUALITY })
        end)
    end)
end

local function captureFrame()
    frameSeq = frameSeq + 1
    pendingFrame = frameSeq
    if useScreenshotBasic then
        if not captureWithScreenshotBasic(frameSeq) then pendingFrame = nil end
    else
        SendNUIMessage({ action = 'spec:grab', seq = frameSeq,
            width = FRAME_WIDTH, quality = FRAME_QUALITY })
    end
end

-- The NUI answers both spec:grab and spec:shrink here.
RegisterNUICallback('spec:frame', function(data, cb)
    cb('ok')
    if type(data) ~= 'table' or data.seq == nil or data.seq ~= pendingFrame then return end
    if type(data.uri) == 'string' and data.uri ~= '' then
        pendingFrame = nil
        sendFrame(data.uri)
        return
    end

    -- Only spec:grab ever answers empty: no WebGL, or the game view hook
    -- gave nothing back. Switch to screenshot-basic for this session.
    if not useScreenshotBasic and GetResourceState('screenshot-basic') == 'started' then
        useScreenshotBasic = true
        if Config.Debug then
            print(('[apex_adminmenu] spectate: NUI capture failed (%s), using screenshot-basic'):format(tostring(data.error)))
        end
        if not captureWithScreenshotBasic(pendingFrame) then pendingFrame = nil end
        return
    end

    pendingFrame, captureDead = nil, true
    TriggerServerEvent('apex_adminmenu:panel:specUnavailable')
end)

RegisterNetEvent('apex_adminmenu:panel:specAck', function()
    awaitingAck = false
end)

RegisterNetEvent('apex_adminmenu:panel:specBegin', function()
    specWatchers = specWatchers + 1
    if specWatchers > 1 then return end
    if Config.Debug then print('[apex_adminmenu] spectate: starting capture loop') end
    -- A stop and a restart inside one tick must not leave two loops running.
    specLoopGen = specLoopGen + 1
    local gen = specLoopGen
    CreateThread(function()
        if gen ~= specLoopGen then return end
        awaitingAck, pendingFrame, captureDead = false, nil, false
        local sentAt, nextAt = 0, 0
        while specWatchers > 0 and gen == specLoopGen do
            local now = GetGameTimer()
            if awaitingAck then
                -- Capture the next frame only once the server confirmed the
                -- previous one landed, so the send queue can never outrun
                -- the link. The deadline keeps a lost ack — or a capture
                -- that never answered — from stalling the stream for good.
                if now - sentAt >= 10000 then
                    awaitingAck, pendingFrame = false, nil
                end
            elseif now >= nextAt and not captureDead then
                awaitingAck, sentAt, nextAt = true, now, now + FRAME_EVERY
                captureFrame()
            end
            Wait(50)
        end
        if gen ~= specLoopGen then return end -- the newer loop owns the state
        awaitingAck, pendingFrame = false, nil
        if Config.Debug then print('[apex_adminmenu] spectate: stopped capture loop') end
    end)
end)
RegisterNetEvent('apex_adminmenu:panel:specEnd', function()
    specWatchers = math.max(0, specWatchers - 1)
end)

-- ── In-game spectate ──────────────────────────────────────
-- The panel's Spectate button and the spectate-closest keybind land
-- here. Nothing listened for this event, so both did nothing at all.
-- The server checked the permission; SpectatePlayer (playeroptions.lua)
-- checks it again when it asks where the target is.
RegisterNetEvent('apex_adminmenu:panel:beginSpectate', function(targetId)
    if panelOpen then CloseAdminPanel() end
    if SpectatePlayer then SpectatePlayer(targetId) end
end)

-- ── Spectate stream — admin side ──────────────────────────
RegisterNetEvent('apex_adminmenu:panel:specFrame', function(targetId, dataUri)
    -- Forward to the NUI regardless of panel state — the UI checks itself.
    SendNUIMessage({ action = 'panel:specFrame', targetId = targetId, dataUri = dataUri })
end)
RegisterNetEvent('apex_adminmenu:panel:specError', function(targetId, msg)
    SendNUIMessage({ action = 'panel:specError', targetId = targetId, message = msg })
end)

-- Announce slide — the server pushes a card here; we just forward
-- it to the NUI which handles rendering + auto-dismiss.
RegisterNetEvent('apex_adminmenu:announceSlide', function(payload)
    if type(payload) ~= 'table' then return end
    SendNUIMessage({
        action   = 'announce:show',
        title    = payload.title,
        message  = payload.message,
        type     = payload.type     or 'info',
        position = payload.position or 'top-center',
        duration = payload.duration or 8
    })
end)

-- Event Logs live push from the server.
RegisterNetEvent('apex_adminmenu:panel:eventRow', function(row)
    if panelOpen then
        SendNUIMessage({ action = 'panel:event', row = row })
    end
end)
RegisterNetEvent('apex_adminmenu:panel:eventRulesUpdated', function(rules)
    if panelOpen then
        SendNUIMessage({ action = 'panel:eventRules', rules = rules })
    end
end)
RegisterNetEvent('apex_adminmenu:panel:eventLogsCleared', function()
    if panelOpen then
        SendNUIMessage({ action = 'panel:eventLogsCleared' })
    end
end)

-- Avatar broadcast — server tells us a Steam avatar just arrived for
-- a license. Even if the panel is currently closed, we keep the latest
-- url -> license mapping so we can re-deliver it when the user reopens
-- the panel. Without this buffer the *first* open misses every
-- broadcast that fired before the NUI was ready.
-- (avatarBuffer is declared near the top of the file so OpenAdminPanel
--  can fold it into the bootstrap snapshot.)
RegisterNetEvent('apex_adminmenu:panel:avatarReady', function(license, url)
    if not license or license == '' or not url or url == '' then return end
    avatarBuffer[license] = url
    if panelOpen then
        SendNUIMessage({ action = 'panel:avatarReady', license = license, url = url })
    end
end)

-- Server -> client clock sync (also drives the in-game time).
--RegisterNetEvent('apex_adminmenu:panel:timeSync', function(hour, minute)
    --if NetworkOverrideClockTime then
        --NetworkOverrideClockTime(tonumber(hour) or 12, tonumber(minute) or 0, 0)
    --end
    --if panelOpen then
        --SendNUIMessage({ action = 'panel:timeSync', hour = hour, minute = minute })
    --end
--end)

-- Push our real in-game time to the server every few seconds so the
-- admin panel can show "current server time" rather than a simulated
-- clock. We do this on the client because the GetClock* natives are
-- client-only.
CreateThread(function()
    while true do
        Wait(5000)
        if NetworkIsSessionStarted and NetworkIsSessionStarted() then
            local h = GetClockHours and GetClockHours() or nil
            local m = GetClockMinutes and GetClockMinutes() or nil
            if h and m then
                TriggerServerEvent('apex_adminmenu:panel:reportTime', h, m)
            end
        end
    end
end)

-- Vehicle purge from "Vehicle Delete" card.
RegisterNetEvent('apex_adminmenu:panel:purgeIdleVehicles', function()
    -- Delete every vehicle that has no occupants nearby (8m radius).
    local myCoords = GetEntityCoords(cache.ped or PlayerPedId())
    for _, veh in ipairs(GetGamePool('CVehicle') or {}) do
        local occupied = false
        for seat = -1, 6 do
            if GetPedInVehicleSeat(veh, seat) ~= 0 then occupied = true; break end
        end
        if not occupied then
            local vc = GetEntityCoords(veh)
            if #(myCoords - vc) < 250.0 then
                SetEntityAsMissionEntity(veh, true, true)
                DeleteEntity(veh)
            end
        end
    end
end)

-- Tells the target WHY they were jailed. The confinement itself is not
-- done here: the server hands off to the running jail resource (see
-- dispatchJail in server/adminpanel.lua), because that is what owns the
-- cell, the countdown and the relog persistence.
--
-- This used to be the whole of "jail" — the comment here read "jail
-- notification stub (you can hook a proper jail system here)" — and the
-- notification it fired went nowhere either, so a jail did nothing at all
-- beyond its database row.
RegisterNetEvent('apex_adminmenu:panel:jailed', function(minutes, reason)
    TriggerEvent('apex_adminmenu:notify', 'Jailed',
        ('%d min · %s'):format(tonumber(minutes) or 0, reason or '-'), 'error', 'fa-handcuffs')
end)

-- ── Commands & keybind ─────────────────────────────────────
-- Name and aliases come from Config.Commands.AdminPanel so a server
-- can rename the command or keep the one its staff already types
-- (that is what puts /admin on the panel by default).
local PanelCmd     = (Config.Commands and Config.Commands.AdminPanel) or {}
local panelCommand = PanelCmd.command or 'adminpanel'

if PanelCmd.enabled ~= false then
    local names = { panelCommand }

    RegisterCommand(panelCommand, function() OpenAdminPanel() end, false)
    TriggerEvent('chat:removeSuggestion', '/' .. panelCommand)

    -- Aliases are separate registrations of the same handler. Skipping
    -- one that equals the main command matters: registering the same
    -- name twice logs a warning every start-up.
    for _, alias in ipairs(PanelCmd.aliases or {}) do
        if type(alias) == 'string' and alias ~= '' and alias ~= panelCommand then
            RegisterCommand(alias, function() OpenAdminPanel() end, false)
            TriggerEvent('chat:removeSuggestion', '/' .. alias)
            names[#names + 1] = alias
        end
    end

    -- Printed to the CLIENT console (F8), unconditionally. Which chat
    -- commands actually exist is the first thing worth knowing when the
    -- menu "does not open", and it is the one thing you cannot see from
    -- the server console — a client command is registered on the client.
    print(('^5[apex_adminmenu]^7 Admin Panel commands: /%s  (F6)')
        :format(table.concat(names, ', /')))
end

-- Use a +command/key mapping so users can rebind in the FiveM UI.
RegisterCommand('+apex_openAdminPanel', function() OpenAdminPanel() end, false)
RegisterCommand('-apex_openAdminPanel', function() end, false)
RegisterKeyMapping('+apex_openAdminPanel', 'Open Admin Panel', 'keyboard', 'F6')

-- F8: apexpaneldiag — what this client knows about the panel's state, for
-- "it does not react" reports: version, open flag, NUI focus, keep-input,
-- Esc guard, capture watch, and what the page itself reports (keyboard
-- focus, active element, open overlay/modal). Paste the lines to support.
RegisterCommand('apexpaneldiag', function()
    print(('^5[apex_adminmenu]^7 panel diag v%s: open=%s nuiFocused=%s keepInput=%s escGuard=%s captureWatch=%s screenshot-basic=%s')
        :format(PANEL_VERSION, tostring(panelOpen), tostring(IsNuiFocused()), tostring(keepingInput()),
                tostring(panelEscGuard), tostring(captureWatchRunning), GetResourceState('screenshot-basic')))
    if panelOpen then
        SendNUIMessage({ action = 'panel:diag' })
    else
        print('^5[apex_adminmenu]^7 (panel closed - open it and run apexpaneldiag again for the page report)')
    end
end, false)
RegisterNUICallback('panel:diagReport', function(data, cb)
    cb('ok')
    print(('^5[apex_adminmenu]^7 page: %s'):format(json.encode(data or {})))
end)

-- ============================================================
-- Dynamic keybind dispatcher
-- ============================================================
-- FiveM's RegisterKeyMapping can't be changed at runtime, so we
-- poll the keyboard ourselves and call the action handler when the
-- configured key fires. We use `IsRawKeyPressed(vk)` because it
-- works with raw Windows virtual-key codes (covers every key on
-- the keyboard), unlike IsControlJustPressed which is limited to a
-- handful of game controls.
local apexKeybinds = {}

-- Maps the human-readable key names the panel sends (matching what
-- RegisterKeyMapping accepts, e.g. 'F4', 'K', 'PRIOR') to their
-- Windows virtual-key codes. List adapted from the FiveM key map.
local KEY_TO_VK = {
    -- Function keys
    F1 = 0x70, F2 = 0x71, F3 = 0x72, F4 = 0x73, F5 = 0x74, F6 = 0x75,
    F7 = 0x76, F8 = 0x77, F9 = 0x78, F10 = 0x79, F11 = 0x7A, F12 = 0x7B,
    -- Letters
    A = 0x41, B = 0x42, C = 0x43, D = 0x44, E = 0x45, F = 0x46, G = 0x47,
    H = 0x48, I = 0x49, J = 0x4A, K = 0x4B, L = 0x4C, M = 0x4D, N = 0x4E,
    O = 0x4F, P = 0x50, Q = 0x51, R = 0x52, S = 0x53, T = 0x54, U = 0x55,
    V = 0x56, W = 0x57, X = 0x58, Y = 0x59, Z = 0x5A,
    -- Digits (top row)
    ['0'] = 0x30, ['1'] = 0x31, ['2'] = 0x32, ['3'] = 0x33, ['4'] = 0x34,
    ['5'] = 0x35, ['6'] = 0x36, ['7'] = 0x37, ['8'] = 0x38, ['9'] = 0x39,
    -- Editing / navigation
    PRIOR  = 0x21, NEXT   = 0x22, END    = 0x23, HOME   = 0x24,
    INSERT = 0x2D, DELETE = 0x2E,
    -- Misc
    TAB     = 0x09, CAPITAL = 0x14, RETURN = 0x0D,
    SPACE   = 0x20, ESCAPE  = 0x1B,
    -- Symbols
    SEMICOLON = 0xBA, PLUS = 0xBB, COMMA = 0xBC, MINUS = 0xBD, PERIOD = 0xBE,
    SLASH = 0xBF, GRAVE = 0xC0, LBRACKET = 0xDB, BACKSLASH = 0xDC,
    RBRACKET = 0xDD, APOSTROPHE = 0xDE,
    -- Numpad
    ADD = 0x6B, SUBTRACT = 0x6D, MULTIPLY = 0x6A, DIVIDE = 0x6F,
    NUMPAD0 = 0x60, NUMPAD1 = 0x61, NUMPAD2 = 0x62, NUMPAD3 = 0x63,
    NUMPAD4 = 0x64, NUMPAD5 = 0x65, NUMPAD6 = 0x66, NUMPAD7 = 0x67,
    NUMPAD8 = 0x68, NUMPAD9 = 0x69, NUMPADENTER = 0x0D
}

-- Edge-detection: IsRawKeyPressed returns true every frame the key
-- is held, so we track the previous frame to fire only on press.
local lastKeyState = {}

-- ── Key capture for the Settings > Keybinds overlay ────────
-- Runs only while panelEscGuard is up (see the panel:escGuard callback).
-- Reads every bindable key plus Escape straight from the OS, with edge
-- detection, and hands the first fresh press to the page. The page may
-- also have seen the same keydown itself; it takes the first answer and
-- ignores the second. A guard the page never releases (its document
-- died, a fetch was lost) expires after 30 s so Esc can close the panel
-- again.
local CAPTURE_TIMEOUT_MS = 30000
-- (captureWatchRunning is declared at the top of the file, next to the
--  other forward declarations, so apexpaneldiag can read it.)

local function rawKeyHeld(vk)
    if type(IsRawKeyDown) == 'function' then
        local ok, res = pcall(IsRawKeyDown, vk)
        if ok then return res == true end
    end
    local ok, res = pcall(IsRawKeyPressed, vk)
    return ok and res == true
end

StartKeyCaptureWatch = function()
    if captureWatchRunning then return end
    captureWatchRunning = true
    CreateThread(function()
        local VK_ESCAPE = 0x1B
        -- A key already held when the overlay opened is not a fresh press.
        local was = { [VK_ESCAPE] = rawKeyHeld(VK_ESCAPE) }
        for _, vk in pairs(KEY_TO_VK) do was[vk] = rawKeyHeld(vk) end

        while panelOpen and panelEscGuard do
            Wait(0)
            -- The panel may have closed, or the page released the guard,
            -- while this frame was waiting: nothing to report any more.
            if not (panelOpen and panelEscGuard) then break end
            if GetGameTimer() - escGuardSince >= CAPTURE_TIMEOUT_MS then
                panelEscGuard = false
                SendNUIMessage({ action = 'panel:keyCaptured', key = 'ESCAPE', reason = 'timeout' })
                break
            end

            local hit = nil
            if rawKeyHeld(VK_ESCAPE) then
                if not was[VK_ESCAPE] then hit = 'ESCAPE' end
                was[VK_ESCAPE] = true
            else
                was[VK_ESCAPE] = false
            end
            if not hit then
                for name, vk in pairs(KEY_TO_VK) do
                    if vk ~= VK_ESCAPE then
                        local held = rawKeyHeld(vk)
                        if held and not was[vk] and not hit then hit = name end
                        was[vk] = held
                    end
                end
            end

            if hit then
                if hit == 'ESCAPE' then
                    -- This press belongs to the overlay; the Escape watch
                    -- must not read it as "close the panel" once the page
                    -- drops the guard a moment from now.
                    escSwallowUntil = GetGameTimer() + 600
                end
                SendNUIMessage({ action = 'panel:keyCaptured', key = hit })
                -- The page answers with panel:escGuard off. If it never does,
                -- the timeout above still clears the guard.
                break
            end
        end
        captureWatchRunning = false
    end)
end

-- Direct dispatch — no extra command indirection. We call the
-- actual functions exposed by selfoptions.lua / main.lua / etc.
-- This avoids the timing problem where ExecuteCommand sometimes
-- fired before the target command was registered, and also lets us
-- pass real state (e.g. toggle wallhack on/off based on its bool).
local function dispatchAction(action)
    if Config.Debug then
        print(('^5[apex_adminmenu]^7 keybind fired: %s'):format(tostring(action)))
    end
    if action == 'open_panel' then
        if OpenAdminPanel then OpenAdminPanel() end

    elseif action == 'open_quickmenu' then
        -- The quickmenu opens via the /adminmenu command which gates
        -- on the server perm callback. ExecuteCommand keeps that gate.
        ExecuteCommand('adminmenu')

    elseif action == 'open_reports' then
        if OpenReportsCenter then OpenReportsCenter() end

    elseif action == 'toggle_noclip' then
        if ToggleNoClip then ToggleNoClip() end

    elseif action == 'toggle_wallhack' then
        if WallhackMode then WallhackMode(not Wallhack) end

    elseif action == 'toggle_stafftag' then
        if StaffTagMode then StaffTagMode(not StaffTag) end

    elseif action == 'spectate_closest' then
        -- Pick the nearest other player and trigger a server spectate
        -- (the existing panel spectate event handles permissions).
        local me = PlayerPedId()
        local meCoords = GetEntityCoords(me)
        local nearestId, nearestDist = nil, math.huge
        for _, p in ipairs(GetActivePlayers()) do
            if p ~= PlayerId() then
                local ped = GetPlayerPed(p)
                if ped ~= 0 then
                    local d = #(meCoords - GetEntityCoords(ped))
                    if d < nearestDist then nearestDist, nearestId = d, GetPlayerServerId(p) end
                end
            end
        end
        if nearestId then TriggerServerEvent('apex_adminmenu:panel:spectatePlayer', nearestId) end
    end
end

RegisterNetEvent('apex_adminmenu:panel:keybindsUpdated', function(data)
    apexKeybinds = type(data) == 'table' and data or {}
    if Config.Debug then
        print(('^2[apex_adminmenu]^7 keybinds updated: %s'):format(json.encode(apexKeybinds)))
    end
end)

-- Poll thread — IsRawKeyPressed reports raw keyboard state with
-- Windows virtual-key codes. We do edge detection so each press
-- fires the action once, not every frame.
--
-- The per-frame Wait(0) is only paid while this player actually HAS
-- custom keybinds, which means staff who configured them. Everyone
-- else parks on a 500 ms tick and costs nothing.
CreateThread(function()
    while true do
        if not next(apexKeybinds) then
            Wait(500)
        elseif IsNuiFocused() then
            -- IsRawKeyPressed reads the physical keyboard and ignores NUI
            -- focus, so with a letter bound (say K = noclip) every "k" typed
            -- in the staff chat, a report answer or a job label toggled
            -- noclip, and a bound quick-menu key opened the F9 menu on top
            -- of the panel, whose close then dropped the panel's focus —
            -- "it doesn't let us type". Keybinds are game shortcuts: they
            -- stay quiet while any NUI owns the keyboard. Keys are marked
            -- held so the one that was being typed when focus ends is not
            -- fired as a fresh press.
            for _, bind in pairs(apexKeybinds) do
                local vk = bind and bind.key and KEY_TO_VK[bind.key]
                if vk then lastKeyState[vk] = true end
            end
            Wait(100)
        else
            Wait(0)
            for action, bind in pairs(apexKeybinds) do
                local key = bind and bind.key
                local vk = key and KEY_TO_VK[key]
                if vk then
                    local nowPressed = IsRawKeyPressed(vk)
                    if nowPressed and not lastKeyState[vk] then
                        dispatchAction(action)
                    end
                    lastKeyState[vk] = nowPressed
                end
            end
        end
    end
end)

-- Pull the operator's saved keybinds on resource start so they
-- become active without having to open the Settings page first.
-- Retries a few times because lib.callback.await needs the server
-- side to be ready.
CreateThread(function()
    local tries = 0
    while tries < 10 do
        Wait(2000)
        local ok, data = pcall(function()
            return lib.callback.await('apex_adminmenu:panel:keybinds', false)
        end)
        if ok and type(data) == 'table' and next(data) then
            apexKeybinds = data
            if Config.Debug then
                print(('^2[apex_adminmenu]^7 keybinds loaded: %s'):format(json.encode(data)))
            end
            return
        end
        tries = tries + 1
    end
    if Config.Debug then
        print('^3[apex_adminmenu]^7 no keybinds configured yet — bind one in Settings → Keybinds')
    end
end)

-- ── Extra player actions wired from the admin profile screen ──
-- Each event runs on the *target* player's client, applying the
-- effect locally. The server validates permissions before relaying.
RegisterNetEvent('apex_adminmenu:setHealth', function(hp)
    local ped = PlayerPedId()
    if not ped or ped == 0 then return end
    SetEntityHealth(ped, math.max(0, math.min(GetEntityMaxHealth(ped) or 200, tonumber(hp) or 200)))
end)

RegisterNetEvent('apex_adminmenu:setArmor', function(ar)
    local ped = PlayerPedId()
    if not ped or ped == 0 then return end
    SetPedArmour(ped, math.max(0, math.min(100, tonumber(ar) or 100)))
end)

RegisterNetEvent('apex_adminmenu:giveWeapon', function(weapon, ammo)
    local ped = PlayerPedId()
    if not ped or ped == 0 then return end
    local hash = type(weapon) == 'number' and weapon or GetHashKey(tostring(weapon))
    GiveWeaponToPed(ped, hash, tonumber(ammo) or 100, false, true)
end)

local function getVehicle(ped)
    local v = GetVehiclePedIsIn(ped, false)
    if v == 0 then v = GetVehiclePedIsIn(ped, true) end
    return v
end

RegisterNetEvent('apex_adminmenu:fixVehicle', function()
    local v = getVehicle(PlayerPedId())
    if v ~= 0 then
        SetVehicleFixed(v); SetVehicleEngineHealth(v, 1000.0)
        SetVehicleBodyHealth(v, 1000.0); SetVehiclePetrolTankHealth(v, 1000.0)
        SetVehicleUndriveable(v, false); SetVehicleEngineOn(v, true, true, false)
    end
end)

RegisterNetEvent('apex_adminmenu:cleanVehicle', function()
    local v = getVehicle(PlayerPedId())
    if v ~= 0 then SetVehicleDirtLevel(v, 0.0); WashDecalsFromVehicle(v, 1.0) end
end)

RegisterNetEvent('apex_adminmenu:spawnVehicleForTarget', function(model)
    local ped = PlayerPedId()
    if not ped or ped == 0 or not model then return end
    local hash = type(model) == 'number' and model or GetHashKey(tostring(model))
    if not IsModelInCdimage(hash) or not IsModelAVehicle(hash) then return end
    RequestModel(hash)
    local t = GetGameTimer() + 5000
    while not HasModelLoaded(hash) and GetGameTimer() < t do Wait(10) end
    if not HasModelLoaded(hash) then return end
    local c = GetEntityCoords(ped)
    local veh = CreateVehicle(hash, c.x, c.y, c.z, GetEntityHeading(ped), true, false)
    SetPedIntoVehicle(ped, veh, -1)
    SetModelAsNoLongerNeeded(hash)
end)

RegisterNetEvent('apex_adminmenu:respawn', function()
    -- Forcibly respawn by killing and letting the framework's medical
    -- system put the player back in the world.
    local ped = PlayerPedId()
    if not ped or ped == 0 then return end
    SetEntityHealth(ped, 0)

    -- Give the framework's own death/respawn flow the first go. The old code
    -- waited a flat 2.5s and then fired the spawn events regardless — so on
    -- every server where the framework HAD already respawned the player
    -- (which is most of them) every resource listening for those events ran
    -- its spawn logic a second time: skin reloaded, inventory refreshed,
    -- spawn scripts re-run.
    local waited = 0
    while waited < 8000 do
        Wait(250); waited = waited + 250
        ped = PlayerPedId()
        if ped ~= 0 and not IsEntityDead(ped) then return end
    end

    -- Still down after 8s — nothing picked it up. Nudge the spawn signal as
    -- a last resort, and only the one this framework actually uses.
    ped = PlayerPedId()
    if ped ~= 0 and not IsEntityDead(ped) then return end
    if Framework == 'esx' then TriggerEvent('esx:onPlayerSpawn') end
    TriggerEvent('playerSpawned')
end)

-- ── Safety ─────────────────────────────────────────────────
AddEventHandler('onResourceStop', function(res)
    if res == GetCurrentResourceName() then
        if panelOpen then SetNuiFocus(false, false) end
        clearBlips()
    end
end)

-- ============================================================
-- Screenshot pipeline
-- ============================================================
-- Server pings the target client to take a screenshot via the
-- exposed-image-uploader / screenshot-basic resource and ship it
-- back in chunks (FiveM net events are size-limited). The admin's
-- panel assembles the chunks and pops a modal with the image.
local function chunkAndUpload(token, base64)
    if not base64 or base64 == '' then return end
    local CHUNK = 60000
    local total = math.ceil(#base64 / CHUNK)
    for i = 1, total do
        local part = base64:sub((i - 1) * CHUNK + 1, i * CHUNK)
        TriggerServerEvent('apex_adminmenu:panel:screenshotChunk', token, i, total, part)
        Wait(50)  -- small gap to avoid net-event flood
    end
end

RegisterNetEvent('apex_adminmenu:panel:takeScreenshot', function(token)
    if GetResourceState('screenshot-basic') ~= 'started' then return end
    exports['screenshot-basic']:requestScreenshot({
        encoding = 'jpg', quality = 0.85
    }, function(data)
        if not data or data == '' then return end
        -- Different versions of screenshot-basic return either a raw
        -- base64 blob or a fully-formed data URI. We pass either —
        -- the server prepends the prefix if missing.
        chunkAndUpload(token, data)
    end)
end)

-- Admin receives the assembled image and forwards it to the NUI.
RegisterNetEvent('apex_adminmenu:panel:screenshotReady', function(dataUri, targetId, targetName)
    if panelOpen then
        SendNUIMessage({
            action  = 'panel:screenshot',
            dataUri = dataUri,
            target  = targetId,
            name    = targetName
        })
    end
end)

-- ============================================================
-- Suspicious key watcher
-- ============================================================
-- Reports to the server when the local player presses any of these
-- keys. These are the typical hotkeys used by external cheat menus
-- (most of them open trainers / mod menus). False positives are
-- fine — staff can review the feed and judge.
-- VK codes: INSERT = 0x2D, HOME = 0x24, END = 0x23, PAGE_UP = 0x21,
--           NUMPAD0..9 = 0x60..0x69, F8 = 0x77, NUM_LOCK = 0x90.
local SUS_KEYS = {
    { vk = 0x2D, name = 'INSERT',   context = 'Common mod-menu launcher (e.g. Stand)' },
    { vk = 0x24, name = 'HOME',     context = 'Common mod-menu launcher (e.g. Lambda)' },
    { vk = 0x77, name = 'F8',       context = 'Mod-menu / debug launcher' },
    { vk = 0x90, name = 'NUMLOCK',  context = 'Used by some external trainers' },
    { vk = 0x60, name = 'NUMPAD0',  context = 'Common cheat hotkey' },
    { vk = 0x6A, name = 'NUMPAD *', context = 'Common cheat hotkey' },
    { vk = 0x6F, name = 'NUMPAD /', context = 'Common cheat hotkey' }
}
local susLast = {}
local susThrottle = {}    -- [vk] = nextAllowedTime so we don't flood

CreateThread(function()
    Wait(8000)  -- let the player spawn first
    while true do
        Wait(120)   -- ~8Hz is plenty for keypress detection
        local now = GetGameTimer()
        for _, k in ipairs(SUS_KEYS) do
            local pressed = IsRawKeyPressed(k.vk)
            if pressed and not susLast[k.vk] then
                if not susThrottle[k.vk] or now >= susThrottle[k.vk] then
                    -- Throttle: at most once every 30s per key per player.
                    susThrottle[k.vk] = now + 30000
                    TriggerServerEvent('apex_adminmenu:panel:suspiciousKey', k.name, k.context)
                end
            end
            susLast[k.vk] = pressed
        end
    end
end)
