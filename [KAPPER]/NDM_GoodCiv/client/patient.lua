-- Patient side: publish downed state, show the "help is coming" card, and get moved
-- in and out of vehicles by responders.

local downed = false
local stage = 0 -- 0 up, 1 last stand, 2 no signs of life
local lastDamage = 'other'

local VEHICLE_WEAPONS = {
    [GetHashKey('WEAPON_RUN_OVER_BY_CAR')] = true,
    [GetHashKey('WEAPON_RAMMED_BY_CAR')] = true,
    [GetHashKey('VEHICLE_WEAPON_ROTORS')] = true,
}
local FALL_WEAPON = GetHashKey('WEAPON_FALL')

-- GetWeaponDamageType: 2 melee, 3 bullet, 5 explosive
local DAMAGE_TYPES = { [2] = 'melee', [3] = 'bullet', [5] = 'explosive' }

local function classifyDamage(weapon)
    if VEHICLE_WEAPONS[weapon] then return 'vehicle' end
    if weapon == FALL_WEAPON then return 'fall' end
    return DAMAGE_TYPES[GetWeaponDamageType(weapon)] or 'other'
end

-- Remember what last hurt us; frameworks that resurrect into last stand clear the cause of death.
AddEventHandler('gameEventTriggered', function(name, args)
    if name ~= 'CEventNetworkEntityDamage' then return end
    if args[1] ~= PlayerPedId() then return end
    local weapon = args[7]
    if weapon and weapon ~= 0 then lastDamage = classifyDamage(weapon) end
end)

local function publish()
    LocalPlayer.state:set('goodciv:patient', { downed = downed, stage = stage, damage = lastDamage }, true)
end

CreateThread(function()
    publish()
    local downedAt
    local autoSent = false
    while true do
        local nowStage = Bridge.DownedStage()
        local now = nowStage > 0
        if now ~= downed then
            downed = now
            downedAt = now and GetGameTimer() or nil
            autoSent = false
            if not now then lastDamage = 'other' end
        end
        if nowStage ~= stage then
            stage = nowStage
            publish()
        end
        if downed and not autoSent and Config.Dispatch.AutoAlertDelay > 0
            and GetGameTimer() - downedAt >= Config.Dispatch.AutoAlertDelay * 1000 then
            autoSent = true
            TriggerServerEvent('goodciv:server:autoAlert')
        end
        Wait(500)
    end
end)

---------------------------------------------------------------------------
-- Character loaded -> restore carrier opt-in
---------------------------------------------------------------------------
local function ready() TriggerServerEvent('goodciv:server:ready') end
RegisterNetEvent('QBCore:Client:OnPlayerLoaded', ready)
RegisterNetEvent('esx:playerLoaded', ready)
AddEventHandler('onClientResourceStart', function(res)
    if res == GetCurrentResourceName() and NetworkIsPlayerActive(PlayerId()) then ready() end
end)
if Bridge.Name == 'standalone' then
    AddEventHandler('playerSpawned', function()
        if not LocalPlayer.state['goodciv:carrier'] then ready() end
    end)
end

---------------------------------------------------------------------------
-- Woken by CPR: once the revive script has stood us up, drop health low.
-- (osp_ambulance then keeps it from going back up until treated / checked in.)
---------------------------------------------------------------------------
RegisterNetEvent('goodciv:client:wakeHealth', function(health)
    if GetInvokingResource() then return end
    local deadline = GetGameTimer() + 10000
    while Bridge.IsDowned() and GetGameTimer() < deadline do Wait(250) end
    if Bridge.IsDowned() then return end
    -- Let the revive script finish setting its own health first.
    Wait(1000)
    local ped = PlayerPedId()
    health = math.max(101, math.floor(tonumber(health) or 120))
    if GetEntityHealth(ped) > health then SetEntityHealth(ped, health) end
end)

---------------------------------------------------------------------------
-- Status card
---------------------------------------------------------------------------
RegisterNetEvent('goodciv:client:patientStatus', function(data)
    Nui.Send('patientStatus', data)
end)

RegisterNetEvent('goodciv:client:patientClosed', function(reason)
    Nui.Send('patientStatus', false)
    if reason then Nui.Toast('info', reason) end
end)

---------------------------------------------------------------------------
-- Checked in at hospital (osp_ambulance / qb-ambulancejob)
---------------------------------------------------------------------------
-- The server only sends SendToBed with isRevive = true once a check-in has
-- gone through (check-in open, bed free), so the GoodCiv call is no longer needed.
RegisterNetEvent('hospital:client:SendToBed', function(_, _, isRevive)
    if not isRevive then return end
    Nui.Send('patientStatus', false)
    TriggerServerEvent('goodciv:server:checkedIn')
end)

---------------------------------------------------------------------------
-- Forward /medic to dispatch scripts that are fed from the caller's client
---------------------------------------------------------------------------
RegisterNetEvent('goodciv:client:forwardDispatch', function(provider)
    if provider == 'ps-dispatch' and GetResourceState('ps-dispatch') == 'started' then
        exports['ps-dispatch']:InjuriedPerson()
    elseif provider == 'cd_dispatch' and GetResourceState('cd_dispatch') == 'started' then
        local data = exports['cd_dispatch']:GetPlayerInfo()
        TriggerServerEvent('cd_dispatch:AddNotification', {
            job_table = Config.Medics.Jobs,
            coords = data.coords,
            title = 'Medical emergency',
            message = ('A %s needs medical attention at %s'):format(data.sex, data.street),
            flash = 0,
            unique_id = data.unique_id,
            sound = 1,
            blip = { sprite = 153, scale = 1.2, colour = 1, flashes = false, text = 'Medical emergency', time = 5, radius = 0 },
        })
    end
end)

---------------------------------------------------------------------------
-- Transport
---------------------------------------------------------------------------
local function freeSeat(veh)
    local seats = GetVehicleMaxNumberOfPassengers(veh)
    -- Prefer rear seats, then front passenger.
    for seat = seats - 1, 0, -1 do
        if IsVehicleSeatFree(veh, seat) then return seat end
    end
end

RegisterNetEvent('goodciv:client:enterVehicle', function(netId)
    if not NetworkDoesNetworkIdExist(netId) then return TriggerServerEvent('goodciv:server:loadFailed') end
    local veh = NetToVeh(netId)
    local seat = veh ~= 0 and freeSeat(veh)
    if not seat then return TriggerServerEvent('goodciv:server:loadFailed') end
    local ped = PlayerPedId()
    ClearPedTasksImmediately(ped)
    SetPedIntoVehicle(ped, veh, seat)
end)

local function leaveVehicle()
    local ped = PlayerPedId()
    local veh = GetVehiclePedIsIn(ped, false)
    if veh == 0 then return end
    local pos = GetOffsetFromEntityInWorldCoords(veh, -2.0, 0.0, 0.0)
    ClearPedTasksImmediately(ped)
    SetEntityCoords(ped, pos.x, pos.y, pos.z, false, false, false, false)
end

RegisterNetEvent('goodciv:client:leaveVehicle', leaveVehicle)

RegisterNetEvent('goodciv:client:handover', function(drop)
    leaveVehicle()
    local ped = PlayerPedId()
    DoScreenFadeOut(500)
    Wait(600)
    SetEntityCoords(ped, drop.x, drop.y, drop.z, false, false, false, false)
    SetEntityHeading(ped, drop.w)
    Wait(400)
    DoScreenFadeIn(500)
    Nui.Send('patientStatus', false)
end)

---------------------------------------------------------------------------
-- Built-in medic alert (Config.Dispatch.Provider = 'builtin')
---------------------------------------------------------------------------
RegisterNetEvent('goodciv:client:medicCall', function(call)
    Nui.Toast('warning', call.message)
    PlaySoundFrontend(-1, 'Lose_1st', 'GTAO_FM_Events_Soundset', false)
    local blip = AddBlipForCoord(call.coords.x, call.coords.y, call.coords.z)
    SetBlipSprite(blip, 153)
    SetBlipColour(blip, 1)
    SetBlipScale(blip, 1.1)
    SetBlipFlashes(blip, true)
    BeginTextCommandSetBlipName('STRING')
    AddTextComponentSubstringPlayerName('Medical call')
    EndTextCommandSetBlipName(blip)
    SetTimeout(120000, function() RemoveBlip(blip) end)
end)
