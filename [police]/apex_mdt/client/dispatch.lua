--[[
    Apex MDT - Dispatch / world side
    Streams the unit's GPS to the server while on duty, receives 911/112
    calls + panic alerts, drops world blips on active calls, handles the
    "respond → waypoint" flow, the EMS heal hook, and the ALPR scanner.
]]

Dispatch = Dispatch or {}

local function feat(k) return Config.features and Config.features[k] ~= false end

local callBlips = {}      -- id → blip
local alertsEnabled = true   -- toggled from the tablet Control Center
function Dispatch.SetAlerts(on) alertsEnabled = on ~= false end

-- ─── GPS streaming (only while on duty) ──────────────────
CreateThread(function()
    local interval = (Config.map and Config.map.streamIntervalMs) or 3000
    while true do
        Wait(interval)
        if feat('enableUnitTracking') and Duty and Duty.IsOn() then
            local c = GetEntityCoords(PlayerPedId())
            TriggerServerEvent('apex_mdt:updatePosition', { x = c.x, y = c.y, z = c.z })
        end
    end
end)

-- ─── Active-call world blips ─────────────────────────────
local function clearCallBlips()
    for id, b in pairs(callBlips) do if DoesBlipExist(b) then RemoveBlip(b) end end
    callBlips = {}
end

local function syncCallBlips(calls)
    clearCallBlips()
    if not feat('enableCallBlips') then return end
    for _, c in ipairs(calls or {}) do
        if c.coords then
            local b = AddBlipForCoord(c.coords.x + 0.0, c.coords.y + 0.0, c.coords.z + 0.0)
            SetBlipSprite(b, 161)
            SetBlipColour(b, c.priority == 'critical' and 1 or (c.priority == 'high' and 17 or 5))
            SetBlipScale(b, 0.9)
            SetBlipAsShortRange(b, false)
            BeginTextCommandSetBlipName('STRING')
            AddTextComponentString((c.code or '') .. ' ' .. (c.label or 'Call'))
            EndTextCommandSetBlipName(b)
            callBlips[c.id] = b
        end
    end
end

-- ─── Incoming events from the server ─────────────────────
RegisterNetEvent('apex_mdt:newCall', function(call)
    -- In-game alert (tablet closed) - suppressed when Dispatch Alerts are
    -- turned off in the tablet Control Center.
    if alertsEnabled and feat('notifyOnNewCall') then
        Apex.Notify(L('notify_new_call', (call.code or call.label or ''), call.location or ''),
            call.priority == 'critical' and 'error' or 'warning')
        PlaySoundFrontend(-1, 'Menu_Accept', 'Phone_SoundSet_Default', true)
    end
    -- Always keep the open tablet's CAD list in sync (the on-screen banner
    -- itself is gated NUI-side by the same preference).
    if UI and UI.IsOpen() then UI.Push('newCall', call) end
end)

RegisterNetEvent('apex_mdt:dispatchUpdate', function(data)
    syncCallBlips(data and data.calls)
    if UI and UI.IsOpen() then UI.Push('dispatchUpdate', data) end
end)

RegisterNetEvent('apex_mdt:setWaypoint', function(coords)
    if coords then SetNewWaypoint(coords.x + 0.0, coords.y + 0.0) end
end)

RegisterNetEvent('apex_mdt:panicAlert', function(data)
    Apex.Notify(('%s - %s'):format(data.callsign or data.name or 'Unit', (L('notify_panic', data.name or '')):gsub('%%s%s*', '')), 'error', 8000)
    PlaySoundFrontend(-1, 'Lose_1st', 'GTAO_FM_Events_Soundset', true)
    if data.coords then SetNewWaypoint(data.coords.x + 0.0, data.coords.y + 0.0) end
    if UI and UI.IsOpen() then UI.Push('panicAlert', data) end
end)

RegisterNetEvent('apex_mdt:newMessage', function(msg)
    if UI and UI.IsOpen() then UI.Push('newMessage', msg) end
end)

-- ─── EMS heal hook ───────────────────────────────────────
-- A dead ped cannot be healed: SetEntityHealth on a corpse raises the health
-- counter but leaves the player lying on the ground, with no error anywhere.
-- So "Treat" has to resurrect FIRST, and it hands that off to the framework's
-- own ambulance job when one is running - only that clears the death state
-- which gates the respawn/revive prompt.
local function reviveSelf()
    local ped = PlayerPedId()
    if not IsEntityDead(ped) then return end
    if GetResourceState('esx_ambulancejob') == 'started' then
        TriggerEvent('esx_ambulancejob:revive')
    elseif GetResourceState('qb-ambulancejob') == 'started' then
        TriggerEvent('hospital:client:Revive')
    else
        local c = GetEntityCoords(ped)
        NetworkResurrectLocalPlayer(c.x, c.y, c.z, GetEntityHeading(ped), true, false)
        ClearPedTasksImmediately(ped)
        SetEntityInvincible(ped, false)
    end
end

RegisterNetEvent('apex_mdt:heal', function(amount)
    reviveSelf()
    local ped = PlayerPedId()   -- the resurrect can hand back a new ped id
    local max = GetEntityMaxHealth(ped)
    SetEntityHealth(ped, math.min(max, GetEntityHealth(ped) + math.floor((amount or 100) / 100 * max)))
    ClearPedBloodDamage(ped)
    Apex.Notify('You have been treated by EMS.', 'success')
end)

-- ─── Player down → automatic EMS call ────────────────────
-- Without this the MDT never learns that anyone went down: a death produced
-- no call, so the EMS side of the tablet stayed empty while the player waited
-- on the ground. Fires once per death, framework-agnostic.
CreateThread(function()
    local wasDead = false
    while true do
        Wait(1000)
        if feat('enableEmsDownCall') then
            local dead = IsEntityDead(PlayerPedId())
            if dead and not wasDead then
                local c = GetEntityCoords(PlayerPedId())
                TriggerServerEvent('apex_mdt:playerDown', {
                    coords   = { x = c.x, y = c.y, z = c.z },
                    location = GetStreetNameFromHashKey(GetStreetNameAtCoord(c.x, c.y, c.z)),
                })
            end
            wasDead = dead
        end
    end
end)

-- ─── Panic ───────────────────────────────────────────────
function Dispatch.Panic()
    if not feat('enablePanicButton') then return end
    local c = GetEntityCoords(PlayerPedId())
    TriggerServerEvent('apex_mdt:panic', { x = c.x, y = c.y, z = c.z })
    Apex.Notify('PANIC broadcast sent.', 'error')
end

-- ─── ALPR (automatic licence-plate reader) ───────────────
-- Periodically reads the plate of the vehicle directly ahead while the
-- unit is in a car on duty; flags hits against active BOLO plates.
CreateThread(function()
    while true do
        Wait(2500)
        if feat('enablePoliceAlpr') and Duty and Duty.IsOn() then
            local ped = PlayerPedId()
            local veh = GetVehiclePedIsIn(ped, false)
            if veh ~= 0 then
                local ahead = GetEntityCoords(ped) + GetEntityForwardVector(ped) * 8.0
                local target = GetClosestVehicle(ahead.x, ahead.y, ahead.z, 6.0, 0, 70)
                if target ~= 0 and target ~= veh then
                    local plate = GetVehicleNumberPlateText(target)
                    if plate then
                        local hit = Apex.Callback('apex_mdt:getVehicle', plate:gsub('%s+$',''))
                        if hit and hit.ok and hit.vehicle and hit.vehicle.bolo then
                            Apex.Notify(L('notify_alpr_hit', plate, hit.vehicle.bolo.description or 'BOLO'), 'error', 6000)
                            PlaySoundFrontend(-1, 'CHECKPOINT_PERFECT', 'HUD_MINI_GAME_SOUNDSET', true)
                        end
                    end
                end
            end
        end
    end
end)

AddEventHandler('onResourceStop', function(r)
    if r == GetCurrentResourceName() then clearCallBlips() end
end)
