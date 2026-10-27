-- Fades out, loads the area, then lands on the ground near the target height (or stays at it if there is none).
-- A driver is moved with their vehicle.
RegisterNetEvent('helm:client:teleport', function(x, y, z)
    x, y, z = x + 0.0, y + 0.0, z + 0.0
    local ped = PlayerPedId()
    local veh = GetVehiclePedIsIn(ped, false)
    local ent = (veh ~= 0 and GetPedInVehicleSeat(veh, -1) == ped) and veh or ped

    DoScreenFadeOut(250)
    while not IsScreenFadedOut() do Wait(0) end
    FreezeEntityPosition(ent, true)
    RequestCollisionAtCoord(x, y, z)
    SetEntityCoords(ent, x, y, z, false, false, false, false)

    local waited = 0
    while not HasCollisionLoadedAroundEntity(ent) and waited < 3000 do
        RequestCollisionAtCoord(x, y, z)
        Wait(50)
        waited = waited + 50
    end
    local found, groundZ = GetGroundZFor_3dCoord(x, y, z + 3.0, false)
    if found then SetEntityCoords(ent, x, y, groundZ, false, false, false, false) end

    FreezeEntityPosition(ent, false)
    DoScreenFadeIn(250)
end)

-- Older config.lua files may not have Config.Notices, so every value has a default.
local notices = Config.Notices or {}
local ANNOUNCE_SECONDS = notices.AnnouncementSeconds or 12
local WARN_MIN_SECONDS = notices.WarningMinSeconds or 5
local NOTICE_SECONDS = notices.NoticeSeconds or 8
local SOUND = notices.Sound ~= false

local open = false        -- staff menu
local warningOpen = false  -- a warning is waiting to be acknowledged

-- The menu and the warning both need the cursor; release it only when neither is showing.
local function updateFocus()
    local want = open or warningOpen
    SetNuiFocus(want, want)
end

local function closeMenu()
    if not open then return end
    open = false
    SendNUIMessage({ type = 'close' })
    updateFocus()
end

RegisterCommand(Config.MenuCommand, function()
    if open then return closeMenu() end
    TriggerServerEvent('helm:server:openMenu')
end, false)

RegisterKeyMapping(Config.MenuCommand, 'Open Helm staff menu', 'keyboard', Config.MenuKey)

RegisterNetEvent('helm:client:openMenu', function(data)
    open = true
    SendNUIMessage({ type = 'open', data = data })
    updateFocus()
end)

RegisterNUICallback('close', function(_, cb)
    closeMenu()
    cb({})
end)

RegisterNUICallback('action', function(data, cb)
    TriggerServerEvent('helm:server:action', data)
    cb({})
end)

-- Reports tab in the staff menu.
RegisterNUICallback('reports', function(_, cb)
    TriggerServerEvent('helm:server:reports')
    cb({})
end)

RegisterNUICallback('reportAction', function(data, cb)
    TriggerServerEvent('helm:server:reportAction', data)
    cb({})
end)

RegisterNetEvent('helm:client:reports', function(data)
    SendNUIMessage({ type = 'reports', data = data })
end)

-- ---------------------------------------------------------------------------
-- On-screen notices
-- ---------------------------------------------------------------------------

-- Announcement banner at the top of the screen. It does not take the cursor, so play carries on.
RegisterNetEvent('helm:client:announce', function(message, by)
    SendNUIMessage({ type = 'announce', message = message, by = by, seconds = ANNOUNCE_SECONDS })
    if SOUND then PlaySoundFrontend(-1, 'CHALLENGE_UNLOCKED', 'HUD_AWARDS', true) end
end)

-- Warning notice in the middle of the screen. The player has to acknowledge it.
RegisterNetEvent('helm:client:warn', function(reason, by)
    warningOpen = true
    SendNUIMessage({ type = 'warn', reason = reason, by = by, seconds = WARN_MIN_SECONDS })
    updateFocus()
    if SOUND then PlaySoundFrontend(-1, 'TIMER_STOP', 'HUD_MINI_GAME_SOUNDSET', true) end
end)

-- Kick or ban: Helm's removal screen until the server disconnects the player. Controls are locked meanwhile;
-- the server drops the player on its own timer, so this is presentation only.
RegisterNetEvent('helm:client:removed', function(info)
    if type(info) ~= 'table' then return end
    SendNUIMessage({
        type = 'removed', kind = info.kind, reason = info.reason, by = info.by,
        expiresAt = info.expiresAt, seconds = info.seconds,
    })
    if SOUND then PlaySoundFrontend(-1, 'LOSER', 'HUD_AWARDS', true) end
    CreateThread(function()
        local ped = PlayerPedId()
        FreezeEntityPosition(ped, true)
        local untilAt = GetGameTimer() + ((tonumber(info.seconds) or 8) + 5) * 1000
        while GetGameTimer() < untilAt do
            DisableAllControlActions(0)
            Wait(0)
        end
        FreezeEntityPosition(ped, false)
    end)
end)

-- Sent when the last queued warning has been acknowledged.
RegisterNUICallback('warnAck', function(data, cb)
    warningOpen = false
    updateFocus()
    TriggerServerEvent('helm:server:warnAck', type(data) == 'table' and tonumber(data.count) or 1)
    cb({})
end)

AddEventHandler('onResourceStop', function(res)
    if res == GetCurrentResourceName() and (open or warningOpen) then SetNuiFocus(false, false) end
end)

-- ---------------------------------------------------------------------------
-- Staff notices (new reports, flagged joins, ban evasion), report replies and other short notices:
-- a card at the top of the screen in the warning style. It does not take the cursor, so play carries on.
-- ---------------------------------------------------------------------------

RegisterNetEvent('helm:client:staffNotice', function(title, message, seconds)
    if type(message) ~= 'string' or message == '' then return end
    SendNUIMessage({ type = 'notice', title = tostring(title or ''), message = message:sub(1, 500), seconds = tonumber(seconds) or NOTICE_SECONDS })
    if SOUND then PlaySoundFrontend(-1, 'Text_Arrive_Tone', 'Phone_SoundSet_Default', true) end
end)

-- Staff alerts switch in the staff menu.
RegisterNUICallback('toggleAlerts', function(_, cb)
    TriggerServerEvent('helm:server:toggleAlerts')
    cb({})
end)

RegisterNetEvent('helm:client:alertsState', function(on)
    SendNUIMessage({ type = 'alerts', on = on == true })
end)

-- ---------------------------------------------------------------------------
-- Screenshots asked for on the panel. The NUI page captures the game frame and hands it back here.
-- ---------------------------------------------------------------------------

RegisterNetEvent('helm:client:screenshot', function(requestId, opts)
    if type(requestId) ~= 'string' then return end
    opts = type(opts) == 'table' and opts or {}
    SendNUIMessage({ type = 'screenshot', id = requestId, maxWidth = opts.maxWidth, quality = opts.quality })
end)

-- Live video for the panel: the NUI page does the streaming. false stops it.
RegisterNetEvent('helm:client:liveVideo', function(opts)
    if type(opts) ~= 'table' then
        SendNUIMessage({ type = 'liveVideoStop' })
        return
    end
    SendNUIMessage({ type = 'liveVideo', id = opts.id, token = opts.token, url = opts.url, iceServers = opts.iceServers })
end)

RegisterNUICallback('screenshot', function(data, cb)
    cb({})
    if type(data) ~= 'table' or type(data.id) ~= 'string' then return end
    -- A latent event: the picture goes up in the background without stalling the connection.
    TriggerLatentServerEvent('helm:server:screenshot', 250000, data.id, data.image, data.error)
end)

-- ---------------------------------------------------------------------------
-- Spectate. Started by the server only. The staff member's own ped is hidden and frozen under the target,
-- then put back where it was. Backspace (or /helmspec) stops.
-- ---------------------------------------------------------------------------

local spec = nil -- { target, name, home, lastFetch }

local function stopSpectate(reason, instant)
    if not spec then return end
    local home = spec.home
    spec = nil
    local ped = PlayerPedId()
    if not instant then
        DoScreenFadeOut(200)
        while not IsScreenFadedOut() do Wait(0) end
    end
    NetworkSetInSpectatorMode(false, ped)
    SetEntityCoords(ped, home.x, home.y, home.z, false, false, false, false)
    SetEntityVisible(ped, true, false)
    SetEntityCollision(ped, true, true)
    FreezeEntityPosition(ped, false)
    SetEntityInvincible(ped, false)
    DoScreenFadeIn(200)
    TriggerServerEvent('helm:server:spectateStopped')
    if reason then TriggerEvent('helm:client:staffNotice', 'Spectate', reason) end
end

local function moveNear(c)
    local ped = PlayerPedId()
    RequestCollisionAtCoord(c.x, c.y, c.z)
    -- Below the target and out of sight, close enough for the target to stay in scope.
    SetEntityCoords(ped, c.x, c.y, c.z - 15.0, false, false, false, false)
end

RegisterNetEvent('helm:client:spectate', function(target, coords, name)
    if spec then stopSpectate() end
    local ped = PlayerPedId()
    spec = { target = target, name = name or ('ID ' .. tostring(target)), home = GetEntityCoords(ped), lastFetch = 0 }

    DoScreenFadeOut(200)
    while not IsScreenFadedOut() do Wait(0) end
    SetEntityVisible(ped, false, false)
    SetEntityCollision(ped, false, false)
    FreezeEntityPosition(ped, true)
    SetEntityInvincible(ped, true)
    if coords then moveNear(coords) end

    CreateThread(function()
        local waited = 0
        while spec and spec.target == target do
            local player = GetPlayerFromServerId(target)
            local tped = player ~= -1 and GetPlayerPed(player) or 0
            if tped ~= 0 and DoesEntityExist(tped) then
                if not NetworkIsInSpectatorMode() then
                    NetworkSetInSpectatorMode(true, tped)
                    if IsScreenFadedOut() then DoScreenFadeIn(200) end
                end
                -- Follow the target so it never drops out of scope.
                local tc = GetEntityCoords(tped)
                if #(GetEntityCoords(PlayerPedId()) - tc) > 60.0 then moveNear(tc) end
            elseif GetGameTimer() - spec.lastFetch > 2000 then
                spec.lastFetch = GetGameTimer()
                TriggerServerEvent('helm:server:spectateWhere')
                waited = waited + 1
                if waited > 8 then
                    if IsScreenFadedOut() then DoScreenFadeIn(200) end
                    stopSpectate('Could not reach that player.')
                    return
                end
            end
            Wait(250)
        end
    end)

    CreateThread(function()
        while spec and spec.target == target do
            BeginTextCommandDisplayHelp('STRING')
            AddTextComponentSubstringPlayerName(('Spectating %s. Press ~INPUT_FRONTEND_RRIGHT~ to stop.'):format(spec.name))
            EndTextCommandDisplayHelp(0, false, false, -1)
            if IsControlJustPressed(0, 194) then stopSpectate() return end -- Backspace
            Wait(0)
        end
    end)
end)

RegisterNetEvent('helm:client:spectateWhere', function(c)
    if spec and type(c) == 'table' then moveNear(c) end
end)

RegisterNetEvent('helm:client:spectateEnd', function(reason) stopSpectate(reason) end)

RegisterCommand('helmspec', function() stopSpectate() end, false)

AddEventHandler('onResourceStop', function(res)
    -- No waiting while the resource stops: put the ped back straight away.
    if res == GetCurrentResourceName() and spec then stopSpectate(nil, true) DoScreenFadeIn(0) end
end)

-- ---------------------------------------------------------------------------
-- Freeze and heal, done by staff to this player.
-- ---------------------------------------------------------------------------

local frozenBy = nil

local function notice(title, message) TriggerEvent('helm:client:staffNotice', title, message) end

RegisterNetEvent('helm:client:freeze', function(on, by)
    if not on then
        if not frozenBy then return end
        frozenBy = nil
        local ped = PlayerPedId()
        local veh = GetVehiclePedIsIn(ped, false)
        FreezeEntityPosition(ped, false)
        if veh ~= 0 then FreezeEntityPosition(veh, false) end
        notice('Unfrozen', 'Staff unfroze you. You can move again.')
        return
    end
    local already = frozenBy ~= nil
    frozenBy = by or 'Staff'
    notice('Frozen', ('%s froze you. Wait for them to contact you.'):format(frozenBy))
    if already then return end
    CreateThread(function()
        while frozenBy do
            local ped = PlayerPedId()
            local veh = GetVehiclePedIsIn(ped, false)
            FreezeEntityPosition(ped, true)
            if veh ~= 0 then FreezeEntityPosition(veh, true) end
            DisablePlayerFiring(PlayerId(), true)
            DisableControlAction(0, 24, true) -- attack
            DisableControlAction(0, 25, true) -- aim
            DisableControlAction(0, 75, true) -- leave vehicle
            Wait(0)
        end
    end)
end)

RegisterNetEvent('helm:client:heal', function()
    local ped = PlayerPedId()
    -- A downed player needs a revive (their ambulance script tracks that), not just health.
    if IsEntityDead(ped) or IsPedFatallyInjured(ped) then return end
    SetEntityHealth(ped, GetEntityMaxHealth(ped))
    SetPedArmour(ped, 100)
    ClearPedBloodDamage(ped)
    ResetPedVisibleDamage(ped)
    HelmClearOspInjuries()
end)

-- OSP Ambulance keeps wounds, bleeding, fractures and vitals in the BodyDamage state bag, and keeps draining health
-- while they're there. Reset them to OSP's healthy defaults (osp-development.gitbook.io, Player Statebag).
function HelmClearOspInjuries()
    if GetResourceState('osp_ambulance') ~= 'started' then return end
    local d = LocalPlayer.state.BodyDamage
    if type(d) ~= 'table' then return end
    d.Pain, d.Pulse, d.Temp, d.Conscious = 0, 80, 37.0, true
    d.hrIncrease, d.hrDecrease, d.BloodPressure, d.cardiacState = 0, 0, { 120, 80 }, 'NSR'
    local parts = d.BodyPartDamage
    if type(parts) == 'table' then
        for key, v in pairs(parts) do
            if key == 'BloodLevel' then
                parts[key] = 6.0
            elseif type(v) == 'table' then
                -- Per body part (Rarm, Larm, Rleg, Lleg, Torso, Head): wounds become empty lists, flags false, amounts 0.
                for part, x in pairs(v) do
                    v[part] = type(x) == 'table' and {} or type(x) == 'boolean' and false or type(x) == 'number' and 0 or x
                end
            elseif type(v) == 'number' then
                parts[key] = 0 -- blood and infusion refills
            end
        end
    end
    LocalPlayer.state:set('BodyDamage', d, true)
end

-- ---------------------------------------------------------------------------
-- Staff tools: noclip, teleport to waypoint, fix / delete vehicle, copy coordinates. The server checks the staff
-- member's panel role first (helm:server:selfTool), then sends the tool back here.
-- ---------------------------------------------------------------------------

local noclip = false

-- The vehicle when driving it, otherwise the player.
local function movingEntity()
    local ped = PlayerPedId()
    local veh = GetVehiclePedIsIn(ped, false)
    if veh ~= 0 and GetPedInVehicleSeat(veh, -1) == ped then return veh, ped end
    return ped, ped
end

local NOCLIP_KEYS = { 19, 21, 22, 30, 31, 32, 33, 34, 35, 36, 38, 44 }

local function setNoclip(on)
    if on == noclip then return end
    if on and spec then notice('Noclip', 'Stop spectating first.') return end
    noclip = on
    if not on then
        local ent, ped = movingEntity()
        -- Land on the ground below, if there is one.
        local c = GetEntityCoords(ent)
        local found, groundZ = GetGroundZFor_3dCoord(c.x, c.y, c.z, false)
        if found then SetEntityCoordsNoOffset(ent, c.x, c.y, groundZ, false, false, false) end
        for _, e in ipairs({ ent, ped }) do
            FreezeEntityPosition(e, false)
            SetEntityCollision(e, true, true)
            SetEntityVisible(e, true, false)
            SetEntityInvincible(e, false)
        end
        notice('Noclip', 'Noclip off.')
        return
    end
    notice('Noclip', 'Noclip on. W A S D to move, E / Q up and down, Shift faster, Alt slower. You are invisible.')
    CreateThread(function()
        while noclip do
            local ent, ped = movingEntity()
            for _, e in ipairs({ ent, ped }) do
                FreezeEntityPosition(e, true)
                SetEntityCollision(e, false, false)
                SetEntityVisible(e, false, false)
                SetEntityInvincible(e, true)
            end
            SetLocalPlayerVisibleLocally(true)
            for _, k in ipairs(NOCLIP_KEYS) do DisableControlAction(0, k, true) end

            local rot = GetGameplayCamRot(2)
            local h, p = math.rad(rot.z), math.rad(rot.x)
            local fx, fy, fz = -math.sin(h) * math.cos(p), math.cos(h) * math.cos(p), math.sin(p)
            local rx, ry = math.cos(h), math.sin(h)
            local mx, my, mz = 0.0, 0.0, 0.0
            if IsDisabledControlPressed(0, 32) then mx, my, mz = mx + fx, my + fy, mz + fz end -- W
            if IsDisabledControlPressed(0, 33) then mx, my, mz = mx - fx, my - fy, mz - fz end -- S
            if IsDisabledControlPressed(0, 34) then mx, my = mx - rx, my - ry end              -- A
            if IsDisabledControlPressed(0, 35) then mx, my = mx + rx, my + ry end              -- D
            if IsDisabledControlPressed(0, 38) then mz = mz + 1.0 end                          -- E
            if IsDisabledControlPressed(0, 44) then mz = mz - 1.0 end                          -- Q
            local speed = 12.0
            if IsDisabledControlPressed(0, 21) then speed = 45.0 elseif IsDisabledControlPressed(0, 19) then speed = 3.0 end
            local step = speed * GetFrameTime()
            local c = GetEntityCoords(ent)
            SetEntityCoordsNoOffset(ent, c.x + mx * step, c.y + my * step, c.z + mz * step, true, true, true)
            SetEntityHeading(ent, rot.z)
            Wait(0)
        end
    end)
end

local function teleportToWaypoint()
    local blip = GetFirstBlipInfoId(8)
    if not DoesBlipExist(blip) then notice('Teleport', 'Set a waypoint on the map first.') return end
    local wp = GetBlipInfoIdCoord(blip)
    local ent = movingEntity()

    DoScreenFadeOut(250)
    while not IsScreenFadedOut() do Wait(0) end
    FreezeEntityPosition(ent, true)
    -- The waypoint has no height: load the area from above, then find the highest ground.
    SetEntityCoordsNoOffset(ent, wp.x, wp.y, 800.0, false, false, false)
    local waited = 0
    while not HasCollisionLoadedAroundEntity(ent) and waited < 3000 do
        RequestCollisionAtCoord(wp.x, wp.y, 800.0)
        Wait(50)
        waited = waited + 50
    end
    local z
    for height = 1000.0, 0.0, -25.0 do
        local found, groundZ = GetGroundZFor_3dCoord(wp.x, wp.y, height, false)
        if found then z = groundZ break end
    end
    if not z then
        local top = GetHeightmapTopZForPosition(wp.x, wp.y)
        z = (top and top > 0.0) and top or 100.0
    end
    SetEntityCoordsNoOffset(ent, wp.x, wp.y, z + 1.0, false, false, false)
    FreezeEntityPosition(ent, false)
    DoScreenFadeIn(250)
end

-- The vehicle the staff member is in, or the one right in front of them.
local function nearbyVehicle()
    local ped = PlayerPedId()
    local veh = GetVehiclePedIsIn(ped, false)
    if veh ~= 0 then return veh end
    local from = GetEntityCoords(ped)
    local to = GetOffsetFromEntityInWorldCoords(ped, 0.0, 5.0, 0.0)
    local ray = StartShapeTestCapsule(from.x, from.y, from.z, to.x, to.y, to.z, 1.0, 10, ped, 7)
    local status, hit, _, _, ent = GetShapeTestResult(ray)
    while status == 1 do
        Wait(0)
        status, hit, _, _, ent = GetShapeTestResult(ray)
    end
    if hit and hit ~= 0 and ent ~= 0 and IsEntityAVehicle(ent) then return ent end
    return 0
end

local function takeControl(ent)
    local started = GetGameTimer()
    NetworkRequestControlOfEntity(ent)
    while not NetworkHasControlOfEntity(ent) and GetGameTimer() - started < 1500 do
        Wait(50)
        NetworkRequestControlOfEntity(ent)
    end
    return NetworkHasControlOfEntity(ent)
end

local function fixVehicle()
    local veh = nearbyVehicle()
    if veh == 0 then notice('Vehicle', 'Get in a vehicle or stand right next to one.') return end
    if not takeControl(veh) then notice('Vehicle', 'Could not take control of that vehicle. Try again.') return end
    SetVehicleFixed(veh)
    SetVehicleDeformationFixed(veh)
    SetVehicleEngineHealth(veh, 1000.0)
    SetVehicleBodyHealth(veh, 1000.0)
    SetVehiclePetrolTankHealth(veh, 1000.0)
    SetVehicleUndriveable(veh, false)
    SetVehicleDirtLevel(veh, 0.0)
    notice('Vehicle', 'Vehicle repaired.')
end

local function deleteVehicle()
    local veh = nearbyVehicle()
    if veh == 0 then notice('Vehicle', 'Get in a vehicle or stand right next to one.') return end
    if not takeControl(veh) then notice('Vehicle', 'Could not take control of that vehicle. Try again.') return end
    SetEntityAsMissionEntity(veh, true, true)
    DeleteVehicle(veh)
    if DoesEntityExist(veh) then DeleteEntity(veh) end
    notice('Vehicle', DoesEntityExist(veh) and 'The vehicle could not be deleted.' or 'Vehicle deleted.')
end

RegisterNetEvent('helm:client:selfTool', function(tool)
    if tool == 'noclip' then setNoclip(not noclip)
    elseif tool == 'waypoint' then teleportToWaypoint()
    elseif tool == 'fixvehicle' then fixVehicle()
    elseif tool == 'deletevehicle' then deleteVehicle()
    end
end)

-- Copying coordinates needs no permission: it only reads where the staff member is.
local function copyCoords()
    local ped = PlayerPedId()
    local c = GetEntityCoords(ped)
    local text = ('vector4(%.2f, %.2f, %.2f, %.2f)'):format(c.x, c.y, c.z, GetEntityHeading(ped))
    SendNUIMessage({ type = 'copy', text = text })
    print(text)
    notice('Coordinates', text .. ' copied (also in the F8 console).')
end

RegisterNUICallback('selfTool', function(data, cb)
    cb({})
    local tool = type(data) == 'table' and data.tool
    if tool == 'coords' then return copyCoords() end
    if type(tool) ~= 'string' then return end
    -- Everything else moves the staff member or needs the screen, so the menu closes first.
    closeMenu()
    TriggerServerEvent('helm:server:selfTool', tool)
end)

-- Noclip has its own command so it can be bound to a key (Settings > Key Bindings > FiveM).
RegisterCommand('helmnoclip', function() TriggerServerEvent('helm:server:selfTool', 'noclip') end, false)
RegisterKeyMapping('helmnoclip', 'Helm staff noclip', 'keyboard', '')

AddEventHandler('onResourceStop', function(res)
    if res ~= GetCurrentResourceName() then return end
    if noclip then setNoclip(false) end
    if frozenBy then
        frozenBy = nil
        FreezeEntityPosition(PlayerPedId(), false)
    end
end)
