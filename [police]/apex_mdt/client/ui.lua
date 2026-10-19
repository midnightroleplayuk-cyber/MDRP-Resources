--[[
    Apex MDT - NUI bridge for the tablet.
    OpenPanel/ClosePanel + a single generic server-proxy NUI callback
    (`cb`) so the browser can reach any server handler without a bespoke
    Lua callback per action.
]]

UI = UI or {}

local panelOpen = false

-- ─── Officer mugshot (live headshot, ox_inventory technique) ──
local headshotHandle, headshotTexture
local function getMugshot()
    if not (Config.avatar and Config.avatar.enable and Config.avatar.useMugshot) then return nil end
    if headshotTexture and headshotHandle and IsPedheadshotValid(headshotHandle) then
        return ('https://nui-img/%s/%s'):format(headshotTexture, headshotTexture)
    end
    if headshotHandle then UnregisterPedheadshot(headshotHandle) end
    local ped = PlayerPedId()
    headshotHandle = RegisterPedheadshot(ped)
    local timeout = GetGameTimer() + 2000
    while not IsPedheadshotReady(headshotHandle) or not IsPedheadshotValid(headshotHandle) do
        if GetGameTimer() > timeout then return nil end
        Wait(0)
    end
    headshotTexture = GetPedheadshotTxdString(headshotHandle)
    return ('https://nui-img/%s/%s'):format(headshotTexture, headshotTexture)
end
UI.GetMugshot = getMugshot

CreateThread(function() Wait(4000); pcall(getMugshot) end)
RegisterNetEvent('esx:playerLoaded', function() headshotTexture = nil; CreateThread(function() Wait(2000); pcall(getMugshot) end) end)
RegisterNetEvent('QBCore:Client:OnPlayerLoaded', function() headshotTexture = nil; CreateThread(function() Wait(2000); pcall(getMugshot) end) end)

-- ─── Open / close ────────────────────────────────────────
function UI.IsOpen() return panelOpen end

function UI.OpenPanel()
    if panelOpen then return end
    local ok, mode = Apex.Callback('apex_mdt:canOpen')
    if not ok then
        local msg = (mode == 'not_on_duty' and L('notify_not_on_duty'))
            or (mode == 'no_item' and 'You need a tablet to use the MDT.')
            or L('notify_no_access')
        Apex.Notify(msg, 'error')
        return
    end
    local boot = Apex.Callback('apex_mdt:bootstrap')
    if not boot or not boot.ok then
        Apex.Notify(L('notify_no_access'), 'error')
        return
    end
    -- Only the photo taken during setup is used (no live ped-headshot default).
    boot.officer.duty = Duty and Duty.IsOn() or boot.officer.duty
    panelOpen = true
    SetNuiFocus(true, true)
    SendNUIMessage({ action = 'open', payload = boot })
end

function UI.ClosePanel()
    if not panelOpen then return end
    panelOpen = false
    SetNuiFocus(false, false)
    SetNuiFocusKeepInput(false)
    SendNUIMessage({ action = 'close' })
end

-- Live-refresh the OPEN tablet after a job change (police ↔ ambulance): pull a
-- fresh bootstrap (new mode/theme/department/apps) and re-init the NUI in place
-- without replaying the boot animation. No reopen, no script restart.
function UI.Refresh()
    if not panelOpen then return end
    local ok = Apex.Callback('apex_mdt:canOpen')
    if not ok then UI.ClosePanel(); return end                 -- lost access on the new job
    local boot = Apex.Callback('apex_mdt:bootstrap')
    if not boot or not boot.ok then UI.ClosePanel(); return end
    boot.officer.duty = Duty and Duty.IsOn() or boot.officer.duty
    SendNUIMessage({ action = 'reinit', payload = boot })
end

RegisterNUICallback('close', function(_, cb)
    cb({}); UI.ClosePanel()
end)

-- ─── Generic server proxy ────────────────────────────────
-- The browser calls fetch('https://apex_mdt/cb', { name, args }) and
-- gets back { ret = { a, b, c } } - up to three return values from the
-- matching server callback. This is how every app talks to the server.
RegisterNUICallback('cb', function(data, cb)
    local name = data and data.name
    if not name then cb({ ret = {} }); return end
    local args = data.args or {}
    -- Rebuild a clean 1..n sequence (JSON may give a sparse/keyed table).
    local seq, i = {}, 0
    while args[tostring(i + 1)] ~= nil or args[i + 1] ~= nil do
        i = i + 1
        seq[i] = (args[i] ~= nil) and args[i] or args[tostring(i)]
    end
    local a, b, c = Apex.Callback('apex_mdt:' .. name, table.unpack(seq, 1, i))
    cb({ ret = { a, b, c } })
end)

-- ─── Client-only helpers the NUI can call ────────────────
RegisterNUICallback('waypoint', function(data, cb)
    cb({})
    if data and data.coords then
        SetNewWaypoint(data.coords.x + 0.0, data.coords.y + 0.0)
        Apex.Notify(L('notify_waypoint_set'), 'success')
    end
end)

RegisterNUICallback('toggle_duty', function(data, cb)
    cb({})
    if Duty then Duty.Toggle() end
end)

RegisterNUICallback('panic', function(_, cb)
    cb({})
    if Dispatch then Dispatch.Panic() end
end)

RegisterNUICallback('play_sound', function(_, cb) cb({}) end)

-- The viewer's own live position, so the map always shows "you".
RegisterNUICallback('my_pos', function(_, cb)
    local c = GetEntityCoords(PlayerPedId())
    cb({ x = c.x, y = c.y, z = c.z })
end)

-- Nearby players (sorted by distance) with their character names - powers the
-- "nearest player" pickers in Billing / Pharmacy / Admissions.
RegisterNUICallback('nearby_players', function(_, cb)
    local me, myc = PlayerPedId(), GetEntityCoords(PlayerPedId())
    local found = {}
    for _, pid in ipairs(GetActivePlayers()) do
        local ped = GetPlayerPed(pid)
        if ped ~= 0 and ped ~= me and DoesEntityExist(ped) then
            local d = #(GetEntityCoords(ped) - myc)
            if d <= 30.0 then found[#found + 1] = { serverId = GetPlayerServerId(pid), dist = math.floor(d * 10) / 10 } end
        end
    end
    table.sort(found, function(a, b) return a.dist < b.dist end)
    local ids = {}
    for i, f in ipairs(found) do ids[i] = f.serverId end
    local resolved = (#ids > 0) and Apex.Callback('apex_mdt:resolvePlayers', ids) or {}
    local byId = {}
    for _, r in ipairs(resolved or {}) do byId[r.serverId] = r end
    local out = {}
    for _, f in ipairs(found) do
        local r = byId[f.serverId]
        out[#out + 1] = { serverId = f.serverId, id = r and r.id or nil, name = (r and r.name) or ('Player ' .. f.serverId), dist = f.dist }
    end
    cb(out)
end)

-- Tablet Control Center → enable/disable in-game dispatch alerts.
RegisterNUICallback('set_dispatch_alerts', function(data, cb)
    cb({})
    if Dispatch and Dispatch.SetAlerts then Dispatch.SetAlerts(not (data and data.on == false)) end
end)

-- ─── Photo booth - position the camera, then capture ─────
-- Orbit the camera around the player (mouse), zoom (scroll), raise/lower
-- (arrows), SPACE to capture, ESC to cancel. Captures via screenshot-basic
-- when present (real framed photo → base64); otherwise falls back to the
-- native ped headshot.
--
-- SOFT-LOCK SAFETY. Every exit runs through finishBooth(), and finishBooth()
-- is the only place that tears the camera down. The control thread stays
-- alive AFTER the shutter, so ESC keeps working while the screenshot is in
-- flight, and a capture that never answers (screenshot-basic's NUI silently
-- failing to render a frame on some builds/GPUs - no console error at all)
-- times out into the headshot fallback instead of trapping the player in the
-- camera. `boothToken` makes late or duplicate answers no-ops.
local photoCam, boothActive = nil, false
local boothPurpose = 'avatar'   -- 'avatar' | 'chat' | 'mugshot'
local boothStoreId = nil        -- citizen identifier when capturing a mugshot
local boothToken     = 0        -- bumped on every start AND finish
local boothCapturing = false    -- shutter fired, waiting on the screenshot
local boothPrevPed, boothPrevVeh = nil, nil   -- saved cam view modes (chat POV)

local function photoCfg()     return Config.photo or {} end
local function shotResource() return photoCfg().resource or 'screenshot-basic' end
local function shotReady()    return GetResourceState(shotResource()) == 'started' end
local function shotTimeout()  return math.max(2000, tonumber(photoCfg().timeoutMs) or 10000) end

-- The nearest other player's ped (the subject standing in front of you).
local function nearestPlayerPed()
    local me, myc = PlayerPedId(), GetEntityCoords(PlayerPedId())
    local best, bestD = nil, 12.0
    for _, pid in ipairs(GetActivePlayers()) do
        local ped = GetPlayerPed(pid)
        if ped ~= 0 and ped ~= me and DoesEntityExist(ped) then
            local d = #(GetEntityCoords(ped) - myc)
            if d < bestD then best, bestD = ped, d end
        end
    end
    return best
end

local function restoreCamViewMode()
    if boothPrevPed then SetFollowPedCamViewMode(boothPrevPed); boothPrevPed = nil end
    if boothPrevVeh then SetFollowVehicleCamViewMode(boothPrevVeh); boothPrevVeh = nil end
end

local function destroyBoothCam()
    RenderScriptCams(false, false, 0, true, false)
    if photoCam then
        if DoesCamExist(photoCam) then DestroyCam(photoCam, false) end
        photoCam = nil
    end
    restoreCamViewMode()
end

-- token: the booth run this result belongs to - anything else is stale and dropped.
-- data: string  → real captured photo (base64)
--       nil     → capture unavailable/timed out → native headshot fallback
--       false   → user cancelled (Esc) → no photo is set
local function finishBooth(token, data)
    if token ~= boothToken then return end       -- late / duplicate answer
    boothToken = boothToken + 1                  -- invalidate anything still in flight
    boothActive, boothCapturing = false, false
    local purpose, storeId = boothPurpose, boothStoreId
    destroyBoothCam()
    -- (the radar comes back on its own - HideHudAndRadarThisFrame is per-frame,
    --  so we must not DisplayRadar(true) here and fight the server's HUD script)
    -- Only take focus back if the tablet is actually still open.
    SetNuiFocus(panelOpen, panelOpen)
    SendNUIMessage({ action = 'cameraClose' })
    SendNUIMessage({ action = 'captureEnd' })
    if type(data) == 'string' and data ~= '' then
        -- Hand the full-screen capture to the NUI to downscale before it's used
        -- (raw screenshot base64 is too large to send over a network event).
        SendNUIMessage({ action = 'photoCaptured', payload = { data = data, purpose = purpose, storeId = storeId } })
        return
    end
    if data == nil and purpose == 'avatar' then
        -- getMugshot() yields, so never run it inside a screenshot callback.
        CreateThread(function()
            local mug = getMugshot()
            if mug then
                SendNUIMessage({ action = 'setAvatar', payload = { url = mug, persist = true } })
            else
                SendNUIMessage({ action = 'photoCancelled' })
                Apex.Notify(L('notify_photo_failed'), 'error')
            end
        end)
        return
    end
    SendNUIMessage({ action = 'photoCancelled' })   -- cancelled - keep setup gated
end

-- Force everything back to normal. Used by onResourceStop, by death, and by
-- the /mdtcamreset escape hatch.
local function resetBooth(silent)
    boothToken = boothToken + 1
    boothActive, boothCapturing = false, false
    destroyBoothCam()
    DisplayRadar(true)
    SetNuiFocus(false, false); SetNuiFocusKeepInput(false)
    if not silent then
        SendNUIMessage({ action = 'cameraClose' })
        SendNUIMessage({ action = 'captureEnd' })
        SendNUIMessage({ action = 'photoCancelled' })
    end
end
UI.ResetBooth = resetBooth

-- The booth is silent by design, so a capture that never answers used to look
-- like "the MDT froze". Say out loud what actually happened.
local function warnCaptureTimeout()
    print(('^3[apex_mdt]^7 "%s" did not answer requestScreenshot within %d ms - fell back to the ped headshot.')
        :format(shotResource(), shotTimeout()))
    print('^3[apex_mdt]^7 Run /mdtphototest to check the screenshot resource, or set Config.photo.method = \'headshot\'.')
    Apex.Notify(L('notify_photo_timeout'), 'error')
end

local function shutter(token)
    if token ~= boothToken then return end
    local pcfg = photoCfg()
    SendNUIMessage({ action = 'cameraShot' })   -- hide the viewfinder for the frame
    Wait(math.max(50, math.min(1500, tonumber(pcfg.settleMs) or 250)))
    if token ~= boothToken then return end
    if not shotReady() then finishBooth(token, nil); return end   -- → headshot fallback
    -- pcall: a missing/renamed export must not kill the thread silently.
    local ok = pcall(function()
        exports[shotResource()]:requestScreenshot(
            { encoding = pcfg.encoding or 'jpg', quality = pcfg.quality or 0.85 },
            function(data) finishBooth(token, data) end)
    end)
    if not ok then finishBooth(token, nil) end
end

local function runBooth(targetPed)
    if boothActive then return end
    boothToken = boothToken + 1
    local token = boothToken
    boothActive, boothCapturing = true, false
    local subject = targetPed or PlayerPedId()
    local pcfg = photoCfg()
    SendNUIMessage({ action = 'captureStart' })   -- hide the tablet
    SendNUIMessage({ action = 'cameraOpen' })      -- show the viewfinder
    SetNuiFocus(false, false)
    local heading = GetEntityHeading(subject)
    local yaw, pitch, dist, hgt = -heading, 0.0, (pcfg.camDist and pcfg.camDist + 0.35 or 0.95), 0.0
    photoCam = CreateCam('DEFAULT_SCRIPTED_CAMERA', true)
    SetCamFov(photoCam, pcfg.camFov or 38.0)
    SetCamActive(photoCam, true)
    RenderScriptCams(true, false, 0, true, false)
    CreateThread(function()
        local deadline = nil
        while boothActive and token == boothToken do
            -- 199/200 = pause, 202/177 = cancel/back - all disabled so the pause
            -- menu can't swallow the key we use to leave the booth.
            for _, c in ipairs({ 1, 2, 22, 24, 25, 142, 172, 173, 177, 199, 200, 202, 257 }) do
                DisableControlAction(0, c, true)
            end
            if not DoesEntityExist(subject) then finishBooth(token, false); return end
            local center = GetPedBoneCoords(subject, 31086, 0.0, 0.0, 0.0)
            if not boothCapturing then
                yaw   = yaw + GetDisabledControlNormal(0, 1) * 10.0
                pitch = math.max(-35.0, math.min(35.0, pitch - GetDisabledControlNormal(0, 2) * 10.0))
                if IsDisabledControlPressed(0, 241) then dist = math.max(0.45, dist - 0.02) end   -- scroll up
                if IsDisabledControlPressed(0, 242) then dist = math.min(2.4, dist + 0.02) end    -- scroll down
                if IsDisabledControlPressed(0, 172) then hgt = math.min(0.6, hgt + 0.01) end       -- arrow up
                if IsDisabledControlPressed(0, 173) then hgt = math.max(-0.6, hgt - 0.01) end       -- arrow down
            end
            local rp, ry = math.rad(pitch), math.rad(yaw)
            SetCamCoord(photoCam, center.x + dist * math.cos(rp) * math.sin(ry),
                                  center.y + dist * math.cos(rp) * math.cos(ry),
                                  center.z + hgt + dist * math.sin(rp))
            PointCamAtCoord(photoCam, center.x, center.y, center.z + hgt)
            if pcfg.hideHud ~= false then HideHudAndRadarThisFrame() end
            -- ESC / BACKSPACE cancels at ANY time - including while the shutter
            -- is waiting on the screenshot resource.
            if IsDisabledControlJustPressed(0, 200) or IsDisabledControlJustPressed(0, 202)
                or IsDisabledControlJustPressed(0, 177) or IsPauseMenuActive() then
                finishBooth(token, false); return
            end
            if boothCapturing then
                if deadline and GetGameTimer() > deadline then
                    warnCaptureTimeout()
                    finishBooth(token, nil); return       -- → headshot fallback
                end
            elseif IsDisabledControlJustPressed(0, 22) then                       -- SPACE
                boothCapturing = true
                deadline = GetGameTimer() + shotTimeout()
                CreateThread(function() shutter(token) end)
            end
            Wait(0)
        end
    end)
end

-- Chat photos: interactive FIRST-PERSON aim - look around with the mouse,
-- SPACE to capture, ESC to cancel. No timecycle/vision filters applied.
local function captureFirstPerson()
    if boothActive then return end
    local pcfg = photoCfg()
    -- A POV chat photo has no headshot fallback, so this one really does need
    -- the screenshot resource. Bail out loudly instead of opening a dead camera.
    if not shotReady() then
        SendNUIMessage({ action = 'photoCancelled' })
        Apex.Notify(L('notify_photo_no_resource'), 'error')
        return
    end
    boothToken = boothToken + 1
    local token = boothToken
    boothActive, boothCapturing = true, false
    CreateThread(function()
        SendNUIMessage({ action = 'captureStart' })   -- hide the tablet
        SendNUIMessage({ action = 'cameraOpen' })      -- viewfinder
        SetNuiFocus(false, false)
        boothPrevPed = GetFollowPedCamViewMode()
        boothPrevVeh = GetFollowVehicleCamViewMode()
        SetFollowPedCamViewMode(4); SetFollowVehicleCamViewMode(4)   -- first person
        -- strip any colour grade / vision so the photo is clean (no green tint)
        ClearTimecycleModifier(); SetTimecycleModifierStrength(0.0)
        SetNightvision(false); SetSeethrough(false)
        local deadline = nil
        while boothActive and token == boothToken do
            HideHudAndRadarThisFrame()
            local ped = PlayerPedId()
            DisableControlAction(0, 24, true); DisableControlAction(0, 25, true); DisableControlAction(0, 257, true)
            DisablePlayerFiring(ped, true)
            DisableControlAction(0, 22, true)    -- jump → used as the shutter
            DisableControlAction(0, 199, true); DisableControlAction(0, 200, true)   -- pause/esc
            DisableControlAction(0, 202, true); DisableControlAction(0, 177, true)   -- cancel/back
            if IsDisabledControlJustPressed(0, 200) or IsDisabledControlJustPressed(0, 202)
                or IsDisabledControlJustPressed(0, 177) or IsPauseMenuActive() then
                finishBooth(token, false); return
            end
            if boothCapturing then
                if deadline and GetGameTimer() > deadline then
                    warnCaptureTimeout()
                    finishBooth(token, false); return
                end
            elseif IsDisabledControlJustPressed(0, 22) then          -- SPACE = capture
                boothCapturing = true
                deadline = GetGameTimer() + shotTimeout()
                CreateThread(function()
                    if token ~= boothToken then return end
                    SendNUIMessage({ action = 'cameraShot' })
                    ClearTimecycleModifier()
                    Wait(math.max(50, math.min(1500, tonumber(pcfg.settleMs) or 250)))
                    if token ~= boothToken then return end
                    local ok = pcall(function()
                        exports[shotResource()]:requestScreenshot(
                            { encoding = pcfg.encoding or 'jpg', quality = pcfg.quality or 0.85 },
                            function(data) finishBooth(token, data) end)
                    end)
                    if not ok then finishBooth(token, false) end
                end)
            end
            Wait(0)
        end
    end)
end

RegisterNUICallback('capture_photo', function(data, cb)
    cb({})
    local pcfg = photoCfg()
    -- Every early return MUST answer the NUI: the setup wizard leaves its
    -- "Take Photo" button on a spinner until it hears back, and a silent
    -- return there is a dead end the player cannot leave.
    if pcfg.enable == false then SendNUIMessage({ action = 'photoCancelled' }); return end
    -- A booth is already running (double-click): drop this one silently - -- answering here would restore the UI on top of the live camera.
    if boothActive then return end
    boothPurpose = (data and data.purpose) or 'avatar'
    boothStoreId = data and data.storeId or nil
    if boothPurpose == 'chat' then captureFirstPerson(); return end   -- POV snapshot for chat
    if boothPurpose == 'mugshot' then
        -- frame the SUBJECT in front of you (nearest player) and capture their face
        local subject = nearestPlayerPed()
        if not subject then
            SendNUIMessage({ action = 'photoCancelled' })
            Apex.Notify(L('notify_photo_no_subject'), 'error')
            return
        end
        runBooth(subject); return
    end
    if pcfg.method == 'headshot' then
        CreateThread(function()
            local mug = getMugshot()
            if mug then
                SendNUIMessage({ action = 'setAvatar', payload = { url = mug, persist = true } })
            else
                SendNUIMessage({ action = 'photoCancelled' })
                Apex.Notify(L('notify_photo_failed'), 'error')
            end
        end)
        return
    end
    runBooth()
end)

-- Persist a base64 photo the NUI produced (headshot → canvas conversion).
RegisterNUICallback('save_photo', function(data, cb)
    cb({})
    if data and type(data.data) == 'string' then TriggerServerEvent('apex_mdt:savePhoto', data.data) end
end)

-- Persist a citizen/patient mugshot (downscaled by the NUI) under their identifier.
RegisterNUICallback('save_mugshot', function(data, cb)
    cb({})
    if data and type(data.id) == 'string' and type(data.data) == 'string' then
        TriggerServerEvent('apex_mdt:saveMugshot', data.id, data.data)
    end
end)

-- ─── Live refresh into an open panel ─────────────────────
function UI.Push(action, payload)
    if not panelOpen then return end
    SendNUIMessage({ action = action, payload = payload or {} })
end

-- ─── Cleanup ─────────────────────────────────────────────
-- Dying (or being teleported/revived by another script) while framing a photo
-- used to leave the scripted camera up. Bail out instead.
CreateThread(function()
    while true do
        Wait(500)
        if boothActive and IsEntityDead(PlayerPedId()) then finishBooth(boothToken, false) end
    end
end)

-- Escape hatch. If ANYTHING ever leaves the photo camera on screen - a third
-- party screenshot resource dying mid-capture, another script stealing the
-- render cams - this puts the player straight back without a relog.
RegisterCommand('mdtcamreset', function()
    resetBooth(false)
    Apex.Notify(L('notify_photo_reset'), 'success')
end, false)

-- Diagnostics. The booth never throws, so this is how you tell a broken
-- screenshot resource apart from a broken MDT. Prints the verdict to F8.
RegisterCommand('mdtphototest', function()
    local res   = shotResource()
    local state = GetResourceState(res)
    print(('^5[apex_mdt]^7 photo test · resource "%s" state = %s'):format(res, state))
    if state ~= 'started' then
        print(('^1[apex_mdt]^7 photo test · FAILED - not running. Add `ensure %s` to server.cfg.'):format(res))
        Apex.Notify(L('notify_photo_no_resource'), 'error')
        return
    end
    local answered, startedAt = false, GetGameTimer()
    local ok = pcall(function()
        exports[res]:requestScreenshot({ encoding = 'jpg', quality = 0.5 }, function(data)
            answered = true
            print(('^2[apex_mdt]^7 photo test · OK - answered in %d ms, %d base64 chars.')
                :format(GetGameTimer() - startedAt, (type(data) == 'string') and #data or 0))
            Apex.Notify(('Photo test OK (%d ms).'):format(GetGameTimer() - startedAt), 'success')
        end)
    end)
    if not ok then
        print(('^1[apex_mdt]^7 photo test · FAILED - "%s" has no requestScreenshot export.'):format(res))
        Apex.Notify(L('notify_photo_no_resource'), 'error')
        return
    end
    CreateThread(function()
        Wait(shotTimeout())
        if not answered then
            print(('^1[apex_mdt]^7 photo test · FAILED - "%s" never answered in %d ms.'):format(res, shotTimeout()))
            print('^1[apex_mdt]^7 Reinstall screenshot-basic (github.com/citizenfx/screenshot-basic) or set Config.photo.method = \'headshot\'.')
            Apex.Notify(L('notify_photo_timeout'), 'error')
        end
    end)
end, false)

AddEventHandler('onResourceStop', function(r)
    if r == GetCurrentResourceName() then
        -- Restarting the resource must NOT leave the player in the booth camera.
        resetBooth(true)
        if headshotHandle then UnregisterPedheadshot(headshotHandle); headshotHandle = nil end
        SendNUIMessage({ action = 'close' })
    end
end)

RegisterNetEvent('apex_mdt:open',  function() UI.OpenPanel() end)
RegisterNetEvent('apex_mdt:close', function() UI.ClosePanel() end)
