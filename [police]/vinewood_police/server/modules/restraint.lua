-- Handcuffs, escort and vehicles. The server decides everything: distance, who's cuffed, who's
-- escorting whom, which seat is free. Clients only play the animations it tells them to.
--
-- State: cuffed   = { mode = 'front'|'rear', doubleLocked, by, byLabel, at }  (persisted)
--        escort   = { by = officerSrc }                                       (on the prisoner)
--        escorting = prisonerSrc                                              (on the officer)
VPO.Restraint = {}
local R = VPO.Restraint
local Cfg = Config.Restraint
local L = VPO.L

local busy = {}      -- [target] = officer, while a cuff/uncuff sequence is running
local escorts = {}   -- [prisoner] = officer
local seatLocks = {} -- ['netId:seat'] = expiry (GetGameTimer)

---------------------------------------------------------------------------
-- Helpers
---------------------------------------------------------------------------
local function ped(src)
    local p = GetPlayerPed(src)
    return (p and p ~= 0 and DoesEntityExist(p)) and p or nil
end

local function dist(a, b)
    local pa, pb = ped(a), ped(b)
    if not pa or not pb then return math.huge end
    return #(GetEntityCoords(pa) - GetEntityCoords(pb))
end

local function vehicleOf(src)
    local p = ped(src)
    local v = p and GetVehiclePedIsIn(p, false) or 0
    return v ~= 0 and v or nil
end

function R.Cuffs(src) return VPO.State.Get(src, 'cuffed') end
function R.IsCuffed(src) return VPO.State.Get(src, 'cuffed') ~= nil end
function R.EscortedBy(src) return escorts[tonumber(src)] end

local function targetFrom(src, d)
    local target = tonumber(type(d) == 'table' and d.target or nil)
    if not target or target == src or not GetPlayerName(target) then return nil, L('restraint_no_target') end
    if dist(src, target) > Cfg.Distance then return nil, L('restraint_too_far') end
    return target
end

local function anim(a) return a and { dict = a.dict, clip = a.clip, flag = a.flag } or nil end

local function sequence(officer, target, kind, mode, time)
    local set = kind == 'uncuff' and Cfg.Uncuff or (mode == 'front' and Cfg.Front or Cfg.Rear)
    TriggerClientEvent('vinewood_police:client:restraint:sequence', officer,
        { role = 'officer', kind = kind, mode = mode, other = target, time = time, anim = anim(set.Officer) })
    TriggerClientEvent('vinewood_police:client:restraint:sequence', target,
        { role = 'suspect', kind = kind, mode = mode, other = officer, time = time, anim = anim(set.Suspect),
          attach = set.Suspect and set.Suspect.attach or nil })
end

local function cancelSequence(officer, target)
    if GetPlayerName(officer) then TriggerClientEvent('vinewood_police:client:restraint:cancel', officer) end
    if GetPlayerName(target) then TriggerClientEvent('vinewood_police:client:restraint:cancel', target) end
end

---------------------------------------------------------------------------
-- Escort
---------------------------------------------------------------------------
function R.StopEscort(prisoner, reason)
    prisoner = tonumber(prisoner)
    local officer = prisoner and escorts[prisoner]
    if not officer then return end
    escorts[prisoner] = nil
    if GetPlayerName(prisoner) then VPO.State.Set(prisoner, 'escort', nil) end
    if GetPlayerName(officer) and VPO.State.Get(officer, 'escorting') == prisoner then VPO.State.Set(officer, 'escorting', nil) end
    VPO.Log.debug('Escort of %s by %s ended (%s)', prisoner, officer, reason or '-')
end

local function startEscort(officer, prisoner)
    escorts[prisoner] = officer
    VPO.State.Set(prisoner, 'escort', { by = officer })
    VPO.State.Set(officer, 'escorting', prisoner)
end

--- Clears cuffs and escort (admin, prison transfer, release). reason goes in the audit log.
function R.Release(target, reason, actor)
    target = tonumber(target)
    if not target then return false end
    R.StopEscort(target, reason)
    local prev = VPO.State.Get(target, 'cuffed')
    if not prev then return false end
    VPO.State.Set(target, 'cuffed', nil)
    VPO.Audit.Log({ action = 'restraint.release', actor = actor, source = actor and 'player' or 'system',
        targetType = 'player', targetId = VPO.Bridge.GetIdentifier(target), previous = prev, reason = reason })
    return true
end

---------------------------------------------------------------------------
-- Cuff / uncuff
---------------------------------------------------------------------------
VPO.Net.Callback('restraint:cuff', { permission = 'restraint.cuff', rate = 'restraint' }, function(src, o, d)
    local target, err = targetFrom(src, d)
    if not target then return { error = err } end
    local mode = (type(d) == 'table' and d.mode == 'front') and 'front' or 'rear'

    if R.IsCuffed(src) then return { error = L('restraint_you_are_cuffed') } end
    if vehicleOf(src) or vehicleOf(target) then return { error = L('restraint_in_vehicle') } end
    if R.IsCuffed(target) then return { error = L('restraint_already_cuffed') } end
    if busy[target] or busy[src] then return { error = L('restraint_busy') } end
    if Cfg.RequireItem and not VPO.Inventory.Has(src, Cfg.Item, 1) then return { error = L('restraint_no_cuffs') } end

    local time = (mode == 'front' and Cfg.Front or Cfg.Rear).Time
    busy[target], busy[src] = src, target
    sequence(src, target, 'cuff', mode, time)
    Wait(time)

    local ok = busy[target] == src and GetPlayerName(target) and GetPlayerName(src)
        and dist(src, target) <= Cfg.Distance + 1.0 and not R.IsCuffed(target) and VPO.IsOnDuty(src) ~= false
    busy[target], busy[src] = nil, nil
    if not ok then
        cancelSequence(src, target)
        return { error = L('restraint_failed') }
    end

    VPO.State.Set(target, 'cuffed', { mode = mode, doubleLocked = false, by = o.identifier, byLabel = VPO.Officers.Label(o), at = os.time() })
    VPO.Duty.AddStat(src, 'restraints', 1)
    VPO.Audit.Log({ action = 'restraint.cuff', actor = src, targetType = 'player', targetId = VPO.Bridge.GetIdentifier(target), new = { mode = mode } })
    VPO.Notify(target, L(mode == 'front' and 'restraint_cuffed_front' or 'restraint_cuffed_rear'), 'inform')
    if Config.Standards.PromptOnCuff then VPO.Standards.Prompt(src, 'Handcuffing', VPO.Bridge.GetName(target), nil) end
    return { ok = true }
end)

VPO.Net.Callback('restraint:uncuff', { permission = 'restraint.cuff', rate = 'restraint' }, function(src, _, d)
    local target, err = targetFrom(src, d)
    if not target then return { error = err } end
    if not R.IsCuffed(target) then return { error = L('restraint_not_cuffed') } end
    if busy[target] or busy[src] then return { error = L('restraint_busy') } end
    if vehicleOf(src) or vehicleOf(target) then return { error = L('restraint_in_vehicle') } end

    local mode = R.Cuffs(target).mode
    R.StopEscort(target, 'uncuff')
    busy[target], busy[src] = src, target
    sequence(src, target, 'uncuff', mode, Cfg.Uncuff.Time)
    Wait(Cfg.Uncuff.Time)
    local ok = busy[target] == src and GetPlayerName(target) and GetPlayerName(src) and dist(src, target) <= Cfg.Distance + 1.0
    busy[target], busy[src] = nil, nil
    if not ok then
        cancelSequence(src, target)
        return { error = L('restraint_failed') }
    end
    local prev = VPO.State.Set(target, 'cuffed', nil)
    VPO.Audit.Log({ action = 'restraint.uncuff', actor = src, targetType = 'player', targetId = VPO.Bridge.GetIdentifier(target), previous = prev })
    VPO.Notify(target, L('restraint_uncuffed'), 'inform')
    return { ok = true }
end)

VPO.Net.Callback('restraint:doubleLock', { permission = 'restraint.cuff', rate = 'restraint' }, function(src, _, d)
    local target, err = targetFrom(src, d)
    if not target then return { error = err } end
    local c = R.Cuffs(target)
    if not c then return { error = L('restraint_not_cuffed') } end
    if c.doubleLocked then return { error = L('restraint_already_double') } end
    c = VPO.Util.Copy(c)
    c.doubleLocked = true
    VPO.State.Set(target, 'cuffed', c)
    VPO.Notify(target, L('restraint_double_locked_target'), 'inform')
    return { ok = true, message = L('restraint_double_locked') }
end)

--- Welfare check: how the cuffs were applied, by whom and when.
VPO.Net.Callback('restraint:check', { permission = 'restraint.cuff', rate = 'restraint' }, function(src, _, d)
    local target, err = targetFrom(src, d)
    if not target then return { error = err } end
    local c = R.Cuffs(target)
    if not c then return { error = L('restraint_not_cuffed') } end
    return { ok = true, message = L('restraint_check', c.mode == 'front' and L('restraint_front') or L('restraint_rear'),
        c.doubleLocked and L('restraint_double') or L('restraint_not_double'), c.byLabel or '?', os.date('%H:%M', c.at or os.time())) }
end)

---------------------------------------------------------------------------
-- Escort
---------------------------------------------------------------------------
VPO.Net.Callback('restraint:escort', { permission = 'restraint.escort', rate = 'restraint' }, function(src, _, d)
    local target, err = targetFrom(src, d)
    if not target then return { error = err } end
    if Cfg.EscortRequiresCuffs and not R.IsCuffed(target) then return { error = L('restraint_not_cuffed') } end
    if R.IsCuffed(src) then return { error = L('restraint_you_are_cuffed') } end
    if escorts[target] then return { error = L('restraint_already_escorted') } end
    if VPO.State.Get(src, 'escorting') then return { error = L('restraint_you_are_escorting') } end
    if busy[target] then return { error = L('restraint_busy') } end
    if vehicleOf(src) or vehicleOf(target) then return { error = L('restraint_in_vehicle') } end
    startEscort(src, target)
    return { ok = true }
end)

VPO.Net.Callback('restraint:release', { permission = 'restraint.escort', rate = 'restraint' }, function(src)
    local prisoner = VPO.State.Get(src, 'escorting')
    if not prisoner then return { error = L('restraint_not_escorting') } end
    R.StopEscort(prisoner, 'released')
    return { ok = true }
end)

---------------------------------------------------------------------------
-- Vehicles
---------------------------------------------------------------------------
local function vehicleFrom(src, d)
    local net = tonumber(type(d) == 'table' and d.net or nil)
    local veh = net and NetworkGetEntityFromNetworkId(net) or 0
    if not veh or veh == 0 or not DoesEntityExist(veh) or GetEntityType(veh) ~= 2 then return nil, nil, L('restraint_no_vehicle') end
    local p = ped(src)
    if not p or #(GetEntityCoords(p) - GetEntityCoords(veh)) > Cfg.VehicleDistance then return nil, nil, L('restraint_vehicle_far') end
    return veh, net
end

VPO.Net.Callback('restraint:seat', { permission = 'restraint.escort', rate = 'restraint' }, function(src, _, d)
    local prisoner = VPO.State.Get(src, 'escorting')
    if not prisoner or escorts[prisoner] ~= src then return { error = L('restraint_not_escorting') } end
    local veh, net, err = vehicleFrom(src, d)
    if not veh then return { error = err } end

    local now, seat = GetGameTimer(), nil
    for _, s in ipairs(Cfg.Seats) do
        local key = net .. ':' .. s
        if GetPedInVehicleSeat(veh, s) == 0 and (not seatLocks[key] or seatLocks[key] < now) then
            seat = s
            seatLocks[key] = now + 4000
            break
        end
    end
    if not seat then return { error = L('restraint_no_seat') } end

    R.StopEscort(prisoner, 'seated')
    TriggerClientEvent('vinewood_police:client:restraint:seat', prisoner, net, seat)
    return { ok = true }
end)

VPO.Net.Callback('restraint:unseat', { permission = 'restraint.escort', rate = 'restraint' }, function(src, _, d)
    if VPO.State.Get(src, 'escorting') then return { error = L('restraint_you_are_escorting') } end
    local veh, net, err = vehicleFrom(src, d)
    if not veh then return { error = err } end

    local prisoner
    for _, id in ipairs(GetPlayers()) do
        local p = tonumber(id)
        if p ~= src and R.IsCuffed(p) and vehicleOf(p) == veh then prisoner = p; break end
    end
    if not prisoner then return { error = L('restraint_nobody_cuffed') } end

    TriggerClientEvent('vinewood_police:client:restraint:unseat', prisoner, net)
    -- Give them time to climb out, then take hold of them.
    local deadline = GetGameTimer() + 4000
    while GetGameTimer() < deadline and vehicleOf(prisoner) do Wait(200) end
    if vehicleOf(prisoner) then return { error = L('restraint_failed') } end
    if R.IsCuffed(prisoner) and not escorts[prisoner] and not VPO.State.Get(src, 'escorting') and dist(src, prisoner) <= Cfg.VehicleDistance + 2.0 then
        startEscort(src, prisoner)
    end
    return { ok = true }
end)

---------------------------------------------------------------------------
-- Escort watchdog: ends an escort the officer can no longer hold
---------------------------------------------------------------------------
CreateThread(function()
    while true do
        Wait(1000)
        for prisoner, officer in pairs(escorts) do
            local reason
            local op = ped(officer)
            if not GetPlayerName(prisoner) or not GetPlayerName(officer) or not op then reason = 'left'
            elseif GetEntityHealth(op) <= 0 then reason = 'officer_down'
            elseif vehicleOf(officer) then reason = 'officer_in_vehicle'
            elseif dist(officer, prisoner) > Cfg.EscortBreakDistance then reason = 'too_far'
            elseif Cfg.EscortRequiresCuffs and not R.IsCuffed(prisoner) then reason = 'uncuffed'
            elseif VPO.IsOnDuty(officer) == false then reason = 'off_duty' end
            if reason then R.StopEscort(prisoner, reason) end
        end
    end
end)

---------------------------------------------------------------------------
-- Clean-up
---------------------------------------------------------------------------
local function cleanup(src)
    if escorts[src] then R.StopEscort(src, 'left') end
    for prisoner, officer in pairs(escorts) do
        if officer == src then R.StopEscort(prisoner, 'officer_left') end
    end
    local other = busy[src]
    if other then busy[other], busy[src] = nil, nil end
end

VPO.Bridge.OnPlayerUnloaded(function(src) cleanup(src) end)
AddEventHandler('playerDropped', function() cleanup(source) end)

VPO.Duty.OnSignOff(function(src)
    local prisoner = VPO.State.Get(src, 'escorting')
    if prisoner then R.StopEscort(prisoner, 'signed_off') end
end)

-- Live escort tuning: the escorting officer's adjustments go to the prisoner's game to re-attach
VPO.Net.On('restraint:escortTune', { permission = 'restraint.escort', rate = 'restraint', silent = true }, function(src, _, t)
    local target
    for prisoner, officer in pairs(escorts) do if officer == src then target = prisoner end end
    if not target then return end
    if type(t) == 'table' then
        local function n(v, lim) v = tonumber(v); if not v or v ~= v then return 0.0 end return math.max(-lim, math.min(lim, v)) end
        t = { bone = (tonumber(t.bone) == 11816) and 11816 or 0,
              offset = { x = n(t.offset and t.offset.x, 3.0), y = n(t.offset and t.offset.y, 3.0), z = n(t.offset and t.offset.z, 3.0) },
              rot = { x = n(t.rot and t.rot.x, 360.0), y = n(t.rot and t.rot.y, 360.0), z = n(t.rot and t.rot.z, 360.0) } }
    else
        t = false
    end
    TriggerClientEvent('vinewood_police:client:escortTune', target, t)
end)
