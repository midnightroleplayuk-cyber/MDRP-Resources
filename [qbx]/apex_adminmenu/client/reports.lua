-- ============================================================
-- Reports Center — client controller
-- Bridges the NUI panel with the server-side report store.
-- Protocol mirrors apex_reports (newFeedback / assist / resolve)
-- but uses a single in-app overlay (the side-panel "Reports" pane).
-- ============================================================

local isAdmin       = false
local staffMode     = false
local nuiFocused    = false
local lastSnapshot  = {}

-- ── Helpers ────────────────────────────────────────────────
local function setFocus(state)
    if state == nuiFocused then return end
    nuiFocused = state
    SetNuiFocus(state, state)
    SetNuiFocusKeepInput(false)
end

local function pushSnapshot()
    SendNUIMessage({
        action  = 'reports:update',
        reports = lastSnapshot
    })
end

-- ── Open / close ───────────────────────────────────────────
local function openCenter(openTo)
    -- The Reports pane lives in the page that hosts the F6 panel's iframe.
    -- Opened while the panel is up it would sit underneath it, take the
    -- keyboard, and drop the panel's NUI focus when closed. The admin asked
    -- for reports: give them reports, with the panel out of the way.
    if IsPanelOpen and IsPanelOpen() and CloseAdminPanel then
        CloseAdminPanel()
        Wait(50)
    end
    local res = lib.callback.await('apex_adminmenu:reports:fetch', 200) or {}
    isAdmin      = res.isAdmin   or false
    staffMode    = res.staffMode or false
    lastSnapshot = res.reports   or {}

    setFocus(true)
    SendNUIMessage({
        action          = 'reports:open',
        isAdmin         = isAdmin,
        staffMode       = staffMode,
        reports         = lastSnapshot,
        allowSelfReport = true,
        openTo          = openTo
    })
end

OpenReportsCenter = function() openCenter(isAdmin and 'inbox' or 'new') end
OpenPlayerReport  = function() openCenter('new') end

local function closeCenter()
    setFocus(false)
end

-- ── NUI callbacks (UI -> client -> server) ────────────────
RegisterNUICallback('reports:close', function(_, cb)
    closeCenter()
    cb('ok')
end)

-- ── HUD positioning mode ─────────────────────────────────
-- Keeps the NUI focused (cursor stays visible & clickable) while the
-- player can still move; we just bring keepInput on so the underlying
-- game controls aren't fully released.
RegisterNUICallback('reports:positionMode', function(data, cb)
    cb('ok')
    if data.enabled then
        -- Mouse + keyboard go to the page so the admin can drag the HUD.
        SetNuiFocus(true, true)
        SetNuiFocusKeepInput(false)
    else
        -- Resume the normal Reports overlay focus.
        SetNuiFocus(true, true)
        SetNuiFocusKeepInput(false)
    end
end)

RegisterNUICallback('reports:submit', function(data, cb)
    TriggerServerEvent('apex_adminmenu:reports:submit',
        data.category or 'player_report',
        data.subject  or '',
        data.details  or '')
    cb('ok')
end)

RegisterNUICallback('reports:openDetail', function(data, cb)
    TriggerServerEvent('apex_adminmenu:reports:openDetail', tonumber(data.id))
    cb('ok')
end)

RegisterNUICallback('reports:sendMessage', function(data, cb)
    TriggerServerEvent('apex_adminmenu:reports:message',
        tonumber(data.id),
        data.text or '',
        data.image)
    cb('ok')
end)

RegisterNUICallback('reports:assist', function(data, cb)
    TriggerServerEvent('apex_adminmenu:reports:assist', tonumber(data.id))
    cb('ok')
end)

RegisterNUICallback('reports:resolve', function(data, cb)
    TriggerServerEvent('apex_adminmenu:reports:resolve', tonumber(data.id))
    cb('ok')
end)

RegisterNUICallback('reports:teleport', function(data, cb)
    TriggerServerEvent('apex_adminmenu:reports:teleport', tonumber(data.id))
    cb('ok')
end)

RegisterNUICallback('reports:bring', function(data, cb)
    TriggerServerEvent('apex_adminmenu:reports:bring', tonumber(data.id))
    cb('ok')
end)

RegisterNUICallback('reports:staffMode', function(data, cb)
    staffMode = data.enabled and true or false
    TriggerServerEvent('apex_adminmenu:reports:staffMode', staffMode)
    if not staffMode then
        SendNUIMessage({ action = 'staff:hide' })
    end
    cb('ok')
end)

-- Screenshot capture.
-- We use screenshot-basic's `requestScreenshot` and forward the result as
-- a chunked binary upload via NetEvents. This sidesteps the (~1MB) event
-- size limit AND avoids needing an external host or HTTP handler that
-- the client can reach. The server reassembles the chunks in memory and
-- hands every viewer a tiny "img://<id>" placeholder; the actual bytes
-- are streamed back to clients on demand.
local function notify(msg, type)
    TriggerEvent('apex_adminmenu:notify', 'Reports', msg, type or 'info')
    if Config.Debug then
        print(('[apex_adminmenu][reports] %s'):format(msg))
    end
end

local CHUNK = 60 * 1024  -- 60 KB per packet, well under the 1 MB limit

local function sendScreenshotChunks(reportId, dataUri)
    local total = math.ceil(#dataUri / CHUNK)
    -- Generate a per-capture token so chunks of different captures don't mix.
    local token = ('%d-%d'):format(GetGameTimer(), math.random(1, 1e6))

    for i = 1, total do
        local startIdx = (i - 1) * CHUNK + 1
        local endIdx   = math.min(i * CHUNK, #dataUri)
        TriggerServerEvent('apex_adminmenu:reports:imgChunk',
            reportId, token, i, total, dataUri:sub(startIdx, endIdx))
        Wait(20) -- gentle pacing
    end
end

-- ── Capture core (used after the free-cam confirms) ─────
local function performCapture(reportId)
    if GetResourceState('screenshot-basic') ~= 'started' then
        notify('screenshot-basic resource is not running on the server', 'error')
        return
    end

    SendNUIMessage({ action = 'reports:beforeShot' })
    setFocus(false)
    Wait(200)

    local function handle(result)
        SendNUIMessage({ action = 'reports:afterShot' })

        if type(result) ~= 'string' or result == '' then
            notify('Screenshot capture returned no data', 'error')
            return
        end

        local dataUri = result:match('^data:image/[%w%-+.]+;base64,') and result
            or ('data:image/jpeg;base64,' .. result)

        notify(('Sending screenshot (%d KB)…'):format(math.floor(#dataUri / 1024)), 'info')
        CreateThread(function()
            sendScreenshotChunks(reportId, dataUri)
        end)
    end

    -- Quality / encoding come from Config.Reports.Screenshot.
    local shot = (Config.Reports and Config.Reports.Screenshot) or {}
    local ok = pcall(function()
        exports['screenshot-basic']:requestScreenshot({
            encoding = shot.Encoding or 'jpg',
            quality  = tonumber(shot.Quality) or 0.5
        }, handle)
    end)
    if not ok then
        pcall(function()
            exports['screenshot-basic']:requestScreenshot(handle)
        end)
    end
end

-- ============================================================
-- Aim-and-shoot composer
-- We close the Reports overlay and give the world back to the
-- player so they can re-orient using the regular GTA gameplay
-- camera (look around with the mouse exactly as in normal play).
-- No detached / free camera, no teleporting — they shoot from
-- wherever their character is standing.
-- ENTER captures and sends, ESC cancels.
-- ============================================================
local ComposeActive = false

local function stopComposeMode()
    if not ComposeActive then return end
    ComposeActive = false
    SendNUIMessage({ action = 'reports:freecam:hide' })
    -- Re-open the report overlay where the player left off.
    setFocus(true)
    SendNUIMessage({ action = 'reports:reopenAfterShot' })
end

local function startComposeMode(reportId)
    if ComposeActive then return end
    ComposeActive = true

    -- Hand control back to the world.
    setFocus(false)
    SendNUIMessage({ action = 'reports:close' })
    Wait(60)

    -- Show the in-world helper card.
    SendNUIMessage({ action = 'reports:freecam:show' })

    CreateThread(function()
        local sentShot = false
        while ComposeActive do
            -- Block weapon-related inputs so the player can't exploit
            -- the compose mode to fire or aim a weapon while the chat
            -- is technically still open.
            DisableControlAction(0, 24,  true) -- Attack
            DisableControlAction(0, 25,  true) -- Aim
            DisableControlAction(0, 257, true) -- Attack2
            DisableControlAction(0, 263, true) -- MeleeAttack1
            DisableControlAction(0, 142, true) -- MeleeAttackAlternate
            DisableControlAction(0, 140, true) -- MeleeAttackLight
            DisableControlAction(0, 141, true) -- MeleeAttackHeavy

            -- ENTER → capture.
            if not sentShot and IsControlJustReleased(0, 191) then -- INPUT_FRONTEND_ACCEPT
                sentShot = true
                SendNUIMessage({ action = 'reports:freecam:hide' })
                Wait(120) -- let the HUD fade out before snapping
                performCapture(reportId)
                Wait(800) -- give the capture/upload time to start
                stopComposeMode()
                break
            end

            -- ESC → abort.
            if IsControlJustReleased(0, 322) then -- INPUT_FRONTEND_PAUSE
                stopComposeMode()
                notify('Screenshot cancelled', 'info')
                break
            end

            Wait(0)
        end
    end)
end

RegisterNUICallback('reports:screenshot', function(data, cb)
    local id = tonumber(data.id)
    cb('ok')
    if not id then return end
    startComposeMode(id)
end)

-- Safety: clear the compose state if the resource stops.
AddEventHandler('onResourceStop', function(res)
    if res == GetCurrentResourceName() and ComposeActive then
        stopComposeMode()
    end
end)

-- ── Server -> client pushes ───────────────────────────────
RegisterNetEvent('apex_adminmenu:reports:syncList', function(reports)
    lastSnapshot = reports or {}
    pushSnapshot()
end)

RegisterNetEvent('apex_adminmenu:reports:openDetail', function(report, messages)
    -- If the overlay isn't already on screen (e.g. opened via PageUp
    -- hotkey while in reports mode), bring it up first so the chat is
    -- actually visible.
    if not nuiFocused then
        isAdmin = true
        local res = lib.callback.await('apex_adminmenu:reports:fetch', 200) or {}
        lastSnapshot = res.reports or lastSnapshot
        staffMode    = res.staffMode or staffMode
        setFocus(true)
        SendNUIMessage({
            action          = 'reports:open',
            isAdmin         = true,
            staffMode       = staffMode,
            reports         = lastSnapshot,
            allowSelfReport = false,
            openTo          = 'inbox'
        })
    end

    SendNUIMessage({
        action   = 'reports:detail',
        report   = report,
        messages = messages or {}
    })
end)

RegisterNetEvent('apex_adminmenu:reports:message', function(reportId, message)
    SendNUIMessage({
        action  = 'reports:message',
        message = message
    })
end)

RegisterNetEvent('apex_adminmenu:reports:notifyAdmin', function(report)
    if not isAdmin then return end
    TriggerEvent('apex_adminmenu:notify', 'New report',
        ('#%d · %s'):format(report.id or 0, report.subject or '(no subject)'),
        'info', 'fa-headset')
end)

RegisterNetEvent('apex_adminmenu:reports:notifyPlayer', function(text)
    TriggerEvent('apex_adminmenu:notify', 'Staff', text or '', 'info', 'fa-headset')
end)

RegisterNetEvent('apex_adminmenu:reports:staffSync', function(reports, current)
    if not staffMode then return end
    SendNUIMessage({
        action  = 'staff:update',
        reports = reports or {},
        current = current
    })
end)

RegisterNetEvent('apex_adminmenu:reports:teleportTo', function(coords)
    if not coords then return end
    DoScreenFadeOut(200)
    Wait(220)
    SetEntityCoords(cache.ped, coords.x, coords.y, coords.z + 0.1, false, false, false, false)
    Wait(80)
    DoScreenFadeIn(300)
end)

-- ── Staff mode HUD lifecycle ──────────────────────────────
RegisterNetEvent('apex_adminmenu:reports:staffModeState', function(enabled, reports, current)
    staffMode = enabled and true or false
    if enabled then
        SendNUIMessage({ action = 'staff:show', reports = reports or {}, current = current })
    else
        SendNUIMessage({ action = 'staff:hide' })
    end
end)

-- ── Commands ──────────────────────────────────────────────
RegisterCommand('report', function()
    OpenPlayerReport()
end, false)
TriggerEvent('chat:removeSuggestion', '/report')

RegisterCommand('reports', function()
    local hasPerms = lib.callback.await('apex_adminmenu:checkPerms', 100)
    if not hasPerms then return end
    isAdmin = true
    openCenter('inbox')
end, false)
TriggerEvent('chat:removeSuggestion', '/reports')

RegisterCommand('reportmode', function()
    local hasPerms = lib.callback.await('apex_adminmenu:checkPerms', 100)
    if not hasPerms then return end
    isAdmin = true
    staffMode = not staffMode
    TriggerServerEvent('apex_adminmenu:reports:staffMode', staffMode)
end, false)
TriggerEvent('chat:removeSuggestion', '/reportmode')

-- ── Hotkeys (Reports Mode) ────────────────────────────────
-- PageUp   → assist / open the next pending report (admin)
-- PageDown → resolve the report currently being assisted (admin)
RegisterCommand('+apex_acceptReport', function()
    if not isAdmin then return end
    TriggerServerEvent('apex_adminmenu:reports:acceptNext')
end, false)
RegisterCommand('-apex_acceptReport', function() end, false)
RegisterKeyMapping('+apex_acceptReport', 'Reports · Accept next pending', 'keyboard', 'PRIOR')

RegisterCommand('+apex_resolveReport', function()
    if not isAdmin then return end
    TriggerServerEvent('apex_adminmenu:reports:resolveCurrent')
end, false)
RegisterCommand('-apex_resolveReport', function() end, false)
RegisterKeyMapping('+apex_resolveReport', 'Reports · Resolve current', 'keyboard', 'NEXT')

-- Resource cleanup.
AddEventHandler('onResourceStop', function(res)
    if res == GetCurrentResourceName() and nuiFocused then
        SetNuiFocus(false, false)
    end
end)
