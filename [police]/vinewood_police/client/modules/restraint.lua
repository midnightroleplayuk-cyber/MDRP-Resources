-- This player's side of restraint: cuffed controls and pose, cuff sequences, being escorted,
-- being put in or taken out of a vehicle. Driven by the server-owned statebags.
local Cfg = Config.Restraint
local cuffs, escortBy, escortingTarget = nil, nil, nil
local sequenceUntil = 0

local function loadDict(dict)
    if HasAnimDictLoaded(dict) then return true end
    RequestAnimDict(dict)
    local deadline = GetGameTimer() + 5000
    while not HasAnimDictLoaded(dict) and GetGameTimer() < deadline do Wait(10) end
    return HasAnimDictLoaded(dict)
end

local function play(ped, a, duration)
    if not a or not loadDict(a.dict) then return end
    TaskPlayAnim(ped, a.dict, a.clip, 8.0, -8.0, duration or -1, a.flag or 0, 0.0, false, false, false)
end

local function idleFor(mode) return (mode == 'front' and Cfg.Front or Cfg.Rear).Idle end

local function stopIdle(ped, mode)
    local a = idleFor(mode)
    if a then StopAnimTask(ped, a.dict, a.clip, 2.0) end
end

local function otherPed(serverId)
    local p = GetPlayerFromServerId(serverId)
    return p ~= -1 and GetPlayerPed(p) or 0
end

---------------------------------------------------------------------------
-- Cuffed state
---------------------------------------------------------------------------
local function applyCuffs(value)
    local ped = PlayerPedId()
    local before = cuffs
    cuffs = value
    if value then
        SetCurrentPedWeapon(ped, GetHashKey('WEAPON_UNARMED'), true)
        SetEnableHandcuffs(ped, true)
        SetPedCanPlayGestureAnims(ped, false)
        if before and before.mode ~= value.mode then stopIdle(ped, before.mode) end
        if not IsPedInAnyVehicle(ped, false) then play(ped, idleFor(value.mode)) end
    elseif before then
        stopIdle(ped, before.mode)
        SetEnableHandcuffs(ped, false)
        SetPedCanPlayGestureAnims(ped, true)
    end
    if (before ~= nil) ~= (value ~= nil) then
        local ok, err = pcall(VPO.Hooks.OnRestrained, value ~= nil, value)
        if not ok then VPO.Log.error('OnRestrained hook failed: %s', err) end
    end
end

-- Controls blocked while cuffed, escorted or escorting.
local CUFFED_BLOCK = { 21, 22, 23, 24, 25, 37, 44, 45, 47, 58, 140, 141, 142, 143, 257, 263, 264 }
local DRIVE_BLOCK = { 59, 60, 63, 64, 71, 72, 76 }
local ESCORTED_BLOCK = { 30, 31, 32, 33, 34, 35 }
local ESCORTING_BLOCK = { 21, 22, 23, 24, 25, 37, 44, 140, 141, 142, 143, 257, 263, 264 }

CreateThread(function()
    while true do
        local active = cuffs or escortBy or escortingTarget or GetGameTimer() < sequenceUntil
        if not active then
            Wait(250)
        else
            Wait(0)
            local ped = PlayerPedId()
            if cuffs or GetGameTimer() < sequenceUntil then
                for _, c in ipairs(CUFFED_BLOCK) do DisableControlAction(0, c, true) end
                if Cfg.BlockVehicleExit and IsPedInAnyVehicle(ped, false) then DisableControlAction(0, 75, true) end
                if IsPedInAnyVehicle(ped, false) and GetPedInVehicleSeat(GetVehiclePedIsIn(ped, false), -1) == ped then
                    for _, c in ipairs(DRIVE_BLOCK) do DisableControlAction(0, c, true) end
                end
            end
            if escortBy then for _, c in ipairs(ESCORTED_BLOCK) do DisableControlAction(0, c, true) end end
            if escortingTarget then for _, c in ipairs(ESCORTING_BLOCK) do DisableControlAction(0, c, true) end end
            if GetGameTimer() < sequenceUntil then
                for _, c in ipairs(ESCORTED_BLOCK) do DisableControlAction(0, c, true) end
            end
        end
    end
end)

-- Keep the pose on: other tasks, ragdolls and getting out of vehicles can clear it.
CreateThread(function()
    while true do
        Wait(500)
        if cuffs and GetGameTimer() >= sequenceUntil then
            local ped = PlayerPedId()
            local a = idleFor(cuffs.mode)
            if a and not IsEntityDead(ped) and not IsPedRagdoll(ped) and not IsPedInAnyVehicle(ped, false)
                and not IsEntityPlayingAnim(ped, a.dict, a.clip, 3) then
                play(ped, a)
            end
            if GetSelectedPedWeapon(ped) ~= GetHashKey('WEAPON_UNARMED') then
                SetCurrentPedWeapon(ped, GetHashKey('WEAPON_UNARMED'), true)
            end
        end
    end
end)

---------------------------------------------------------------------------
-- Escort (being escorted)
---------------------------------------------------------------------------
--- Attach point on the officer. The pelvis (11816, used by older configs) rocks as they walk and tilts the
--- prisoner sideways, so it's swapped for the root (0), which stays upright.
local function boneOn(op, bone)
    -- Older configs used the pelvis without a matching pose, which tilted the prisoner; those get the
    -- root. A config made for the escorting animation sets keepBone and uses its bone exactly.
    if bone == nil or (bone == 11816 and not Cfg.Escort.keepBone) then bone = 0 end
    return GetPedBoneIndex(op, bone)
end

local tuning = nil -- while the officer is adjusting: { bone, offset, rot }

local function attachTo(officerServerId)
    local ped, op = PlayerPedId(), otherPed(officerServerId)
    if op == 0 then return false end
    local e = tuning or Cfg.Escort
    AttachEntityToEntity(ped, op, boneOn(op, e.bone), e.offset.x, e.offset.y, e.offset.z,
        e.rot.x, e.rot.y, e.rot.z, false, false, false, false, e.vertex or 2, true)
    return true
end

---------------------------------------------------------------------------
-- /escortadjust (officer, while escorting): move and turn the prisoner live, then print the config lines.
-- The prisoner's game re-attaches on every change, so what you see is what everyone sees.
---------------------------------------------------------------------------
RegisterNetEvent('vinewood_police:client:escortTune', function(t)
    if not escortBy then return end
    if type(t) == 'table' and t.offset then
        tuning = { bone = t.bone or 0, keepBone = true, vertex = Cfg.Escort.vertex or 2,
            offset = vector3(t.offset.x, t.offset.y, t.offset.z), rot = vector3(t.rot.x, t.rot.y, t.rot.z) }
    else
        tuning = nil
    end
    DetachEntity(PlayerPedId(), true, false)
    attachTo(escortBy)
end)

local adjusting = false
RegisterCommand('escortadjust', function()
    if not escortingTarget then return VPO.ClientNotify(VPO.L('escort_adjust_need'), 'error') end
    if adjusting then return end
    adjusting = true
    CreateThread(function()
        local e = Cfg.Escort
        local o = { x = e.offset.x, y = e.offset.y, z = e.offset.z }
        local r = { x = e.rot.x, y = e.rot.y, z = e.rot.z }
        local bone = (e.bone == 11816 and e.keepBone) and 11816 or 0
        local anim = e.OfficerAnim ~= false and e.OfficerAnim ~= nil
        local lastSent = 0
        local function send()
            TriggerServerEvent('vinewood_police:server:restraint:escortTune', { bone = bone, offset = o, rot = r })
        end
        send()
        while adjusting and escortingTarget do
            Wait(0)
            for _, c in ipairs({ 172, 173, 174, 175, 10, 11, 44, 38, 47, 74, 191, 201, 177, 200, 21 }) do DisableControlAction(0, c, true) end
            local step = IsDisabledControlPressed(0, 21) and 0.05 or 0.01   -- Shift = bigger steps
            local turn = IsDisabledControlPressed(0, 21) and 5.0 or 1.0
            local changed = false
            local function held(c) return IsDisabledControlJustPressed(0, c) end
            if held(172) then o.y = o.y + step; changed = true end      -- up arrow: forward
            if held(173) then o.y = o.y - step; changed = true end      -- down arrow: back
            if held(175) then o.x = o.x + step; changed = true end      -- right arrow: right
            if held(174) then o.x = o.x - step; changed = true end      -- left arrow: left
            if held(10) then o.z = o.z + step; changed = true end       -- page up: up
            if held(11) then o.z = o.z - step; changed = true end       -- page down: down
            if held(44) then r.z = r.z + turn; changed = true end       -- Q: turn left
            if held(38) then r.z = r.z - turn; changed = true end       -- E: turn right
            if held(47) then bone = bone == 0 and 11816 or 0; changed = true end -- G: root / pelvis
            if held(74) then                                               -- H: officer animation on / off
                anim = not anim
                Cfg.Escort.OfficerAnim = anim and (Cfg.Escort._anim or { dict = 'anim@policearrest', clip = 'escorting', flag = 49 }) or false
                if not anim then ClearPedSecondaryTask(PlayerPedId()) end
            end
            if changed and GetGameTimer() - lastSent > 60 then send(); lastSent = GetGameTimer() end
            BeginTextCommandDisplayHelp('STRING')
            AddTextComponentSubstringPlayerName(('Escort: offset %.2f %.2f %.2f  turn %.0f  bone %s  anim %s~n~Arrows move  PgUp/PgDn height  Q/E turn  Shift faster~n~G root/pelvis  H animation  Enter print  Backspace cancel'):format(
                o.x, o.y, o.z, r.z, bone == 0 and 'root' or 'pelvis', anim and 'on' or 'off'))
            EndTextCommandDisplayHelp(0, false, false, -1)
            if IsDisabledControlJustReleased(0, 191) or IsDisabledControlJustReleased(0, 201) then
                local lines = {
                    ('bone = %d,'):format(bone),
                    ('offset = vec3(%.3f, %.3f, %.3f),'):format(o.x, o.y, o.z),
                    ('rot = vec3(%.1f, %.1f, %.1f),'):format(r.x, r.y, r.z),
                    ('keepBone = %s,'):format(bone == 11816 and 'true' or 'false'),
                    anim and "OfficerAnim = { dict = 'anim@policearrest', clip = 'escorting', flag = 49 }," or 'OfficerAnim = false,',
                }
                print('[vinewood_police] Paste into Config.Restraint.Escort in config/restraint.lua:')
                for _, l in ipairs(lines) do print('        ' .. l) end
                -- Use these for the rest of the session too
                Cfg.Escort.bone, Cfg.Escort.keepBone = bone, bone == 11816
                Cfg.Escort.offset, Cfg.Escort.rot = vec3(o.x, o.y, o.z), vec3(r.x, r.y, r.z)
                VPO.ClientNotify(VPO.L('escort_adjust_printed'), 'success', 6000)
                break
            end
            if IsDisabledControlJustReleased(0, 177) or IsDisabledControlJustReleased(0, 200) then
                TriggerServerEvent('vinewood_police:server:restraint:escortTune', false)
                break
            end
        end
        adjusting = false
    end)
end, false)

---------------------------------------------------------------------------
-- The officer's escorting animation (upper body, so they can still walk and run)
---------------------------------------------------------------------------
Cfg.Escort._anim = Cfg.Escort.OfficerAnim or { dict = 'anim@policearrest', clip = 'escorting', flag = 49 }
local function officerAnim(on)
    local a = Cfg.Escort.OfficerAnim
    if not a then return end
    local me = PlayerPedId()
    if on then
        RequestAnimDict(a.dict)
        local deadline = GetGameTimer() + 3000
        while not HasAnimDictLoaded(a.dict) and GetGameTimer() < deadline do Wait(10) end
        if HasAnimDictLoaded(a.dict) and not IsEntityPlayingAnim(me, a.dict, a.clip, 3) then
            TaskPlayAnim(me, a.dict, a.clip, 8.0, -8.0, -1, a.flag or 49, 0, false, false, false)
        end
    else
        StopAnimTask(me, a.dict, a.clip, 2.0)
    end
end

-- Started once when you begin escorting, and only put back if something else has stopped it for a
-- couple of seconds (not re-started constantly)
CreateThread(function()
    local was, missing = false, 0
    while true do
        Wait(500)
        local now = escortingTarget ~= nil and escortingTarget ~= false
        local a = Cfg.Escort.OfficerAnim
        if now and a then
            if not was then officerAnim(true); missing = 0
            elseif not IsEntityPlayingAnim(PlayerPedId(), a.dict, a.clip, 3) then
                missing = missing + 1
                if missing >= 4 then officerAnim(true); missing = 0 end
            else missing = 0 end
        elseif was and not now then
            officerAnim(false)
        end
        was = now
    end
end)

local function applyEscort(value)
    local ped = PlayerPedId()
    local before = escortBy
    escortBy = value and value.by or nil
    if escortBy then
        attachTo(escortBy)
    elseif before then
        DetachEntity(ped, true, false)
    end
    if (before ~= nil) ~= (escortBy ~= nil) then pcall(VPO.Hooks.OnEscorted, escortBy ~= nil, escortBy) end
end

CreateThread(function()
    while true do
        Wait(500)
        if escortBy then
            local ped = PlayerPedId()
            if not IsEntityAttached(ped) then attachTo(escortBy) end
        end
    end
end)

---------------------------------------------------------------------------
-- Letting go: a key (rebindable) and a reminder on screen while you're escorting someone
---------------------------------------------------------------------------
RegisterCommand('vpo_letgo', function()
    if escortingTarget then
        CreateThread(function()
            local res = lib.callback.await('vinewood_police:cb:restraint:release', false)
            if type(res) == 'table' and res.error then VPO.ClientNotify(res.error, 'error') end
        end)
    end
end, false)
RegisterKeyMapping('vpo_letgo', 'Police: let go of the person you are escorting', 'keyboard', Cfg.LetGoKey or 'G')

local letGoInput = ('~INPUT_%X~'):format((GetHashKey('vpo_letgo') & 0xFFFFFFFF) | 0x80000000)

CreateThread(function()
    while true do
        if not escortingTarget then
            Wait(500)
        else
            Wait(0)
            BeginTextCommandDisplayHelp('STRING')
            AddTextComponentSubstringPlayerName(VPO.L('restraint_letgo_help', letGoInput))
            EndTextCommandDisplayHelp(0, false, false, -1)
        end
    end
end)

---------------------------------------------------------------------------
-- Statebags
---------------------------------------------------------------------------
local myBag = ('player:%s'):format(GetPlayerServerId(PlayerId()))
AddStateBagChangeHandler(VPO.StateDefs.cuffed.bag, myBag, function(_, _, value) SetTimeout(0, function() applyCuffs(value) end) end)
AddStateBagChangeHandler(VPO.StateDefs.escort.bag, myBag, function(_, _, value) SetTimeout(0, function() applyEscort(value) end) end)
AddStateBagChangeHandler(VPO.StateDefs.escorting.bag, myBag, function(_, _, value) escortingTarget = value end)

-- Pick up state that was already set before this script was listening (relog, restart).
local function sync()
    applyCuffs(LocalPlayer.state[VPO.StateDefs.cuffed.bag])
    applyEscort(LocalPlayer.state[VPO.StateDefs.escort.bag])
    escortingTarget = LocalPlayer.state[VPO.StateDefs.escorting.bag]
end
CreateThread(function() Wait(1500); sync() end)
VPO.ClientBridge.OnPlayerLoaded(function() SetTimeout(2000, sync) end)

function VPO.IsCuffed() return cuffs ~= nil end
function VPO.IsEscorting() return escortingTarget end

---------------------------------------------------------------------------
-- Cuff / uncuff sequences (the server says when; this only animates)
---------------------------------------------------------------------------
RegisterNetEvent('vinewood_police:client:restraint:sequence', function(d)
    if type(d) ~= 'table' then return end
    local ped = PlayerPedId()
    local op = otherPed(d.other)
    sequenceUntil = GetGameTimer() + (d.time or 3000)
    ClearPedTasks(ped)

    if d.role == 'suspect' then
        if op ~= 0 then
            if d.attach then
                local a = d.attach
                AttachEntityToEntity(ped, op, boneOn(op, a.bone), a.offset.x, a.offset.y, a.offset.z,
                    a.rot.x, a.rot.y, a.rot.z, false, false, false, false, 2, true)
            else
                -- Face the officer
                local me, them = GetEntityCoords(ped), GetEntityCoords(op)
                SetEntityHeading(ped, GetHeadingFromVector_2d(them.x - me.x, them.y - me.y))
            end
        end
        if d.anim then play(ped, d.anim, d.time) end
        SetTimeout(d.time or 3000, function()
            if d.attach and not escortBy then DetachEntity(ped, true, false) end
        end)
    else
        if op ~= 0 then
            local me, them = GetEntityCoords(ped), GetEntityCoords(op)
            SetEntityHeading(ped, GetHeadingFromVector_2d(them.x - me.x, them.y - me.y))
        end
        if d.anim then play(ped, d.anim, d.time) end
        SetTimeout(d.time or 3000, function()
            if d.anim then StopAnimTask(ped, d.anim.dict, d.anim.clip, 2.0) end
        end)
    end
end)

RegisterNetEvent('vinewood_police:client:restraint:cancel', function()
    local ped = PlayerPedId()
    sequenceUntil = 0
    if not escortBy and IsEntityAttached(ped) then DetachEntity(ped, true, false) end
    if not cuffs then ClearPedTasks(ped) end
end)

---------------------------------------------------------------------------
-- Vehicles
---------------------------------------------------------------------------
local function vehicleFromNet(net)
    local deadline = GetGameTimer() + 3000
    while not NetworkDoesEntityExistWithNetworkId(net) and GetGameTimer() < deadline do Wait(50) end
    if not NetworkDoesEntityExistWithNetworkId(net) then return 0 end
    return NetToVeh(net)
end

RegisterNetEvent('vinewood_police:client:restraint:seat', function(net, seat)
    local ped = PlayerPedId()
    if not cuffs then return end
    local veh = vehicleFromNet(net)
    if veh == 0 then return end
    DetachEntity(ped, true, false)
    if cuffs then stopIdle(ped, cuffs.mode) end
    TaskWarpPedIntoVehicle(ped, veh, seat)
end)

RegisterNetEvent('vinewood_police:client:restraint:unseat', function(net)
    local ped = PlayerPedId()
    local veh = vehicleFromNet(net)
    if veh == 0 or GetVehiclePedIsIn(ped, false) ~= veh then return end
    TaskLeaveVehicle(ped, veh, 16)
end)

AddEventHandler('onResourceStop', function(res)
    if res ~= VPO.Resource then return end
    local ped = PlayerPedId()
    if escortBy then DetachEntity(ped, true, false) end
    if cuffs then
        stopIdle(ped, cuffs.mode)
        SetEnableHandcuffs(ped, false)
        pcall(VPO.Hooks.OnRestrained, false)
    end
end)

---------------------------------------------------------------------------
-- /animtest [clip] [dict]: plays a clip on you three ways, 4 seconds each, to compare in game:
--   1. full body (flag 0)  2. full body, looping (flag 1)  3. upper body while you can move (flag 49)
-- Defaults to the officer's escorting clip.
---------------------------------------------------------------------------
RegisterCommand('animtest', function(_, args)
    local clip = args[1] or 'escorting'
    local dict = args[2] or (Cfg.Escort.OfficerAnim and Cfg.Escort.OfficerAnim.dict) or 'anim@policearrest'
    CreateThread(function()
        RequestAnimDict(dict)
        local deadline = GetGameTimer() + 5000
        while not HasAnimDictLoaded(dict) and GetGameTimer() < deadline do Wait(10) end
        if not HasAnimDictLoaded(dict) then return print(('[vinewood_police] animtest: dictionary %s not found'):format(dict)) end
        local me = PlayerPedId()
        for _, t in ipairs({ { 0, 'full body' }, { 1, 'full body, looping' }, { 49, 'upper body, can move (what escorting uses)' } }) do
            ClearPedTasksImmediately(me)
            TaskPlayAnim(me, dict, clip, 8.0, -8.0, -1, t[1], 0.0, false, false, false)
            print(('[vinewood_police] animtest %s/%s flag %d: %s  playing=%s'):format(dict, clip, t[1], t[2], tostring(IsEntityPlayingAnim(me, dict, clip, 3))))
            local untilT = GetGameTimer() + 4000
            while GetGameTimer() < untilT do
                BeginTextCommandDisplayHelp('STRING')
                AddTextComponentSubstringPlayerName(('Anim test: %s~n~flag %d - %s'):format(clip, t[1], t[2]))
                EndTextCommandDisplayHelp(0, false, false, -1)
                Wait(0)
            end
        end
        ClearPedTasks(me)
    end)
end, false)
