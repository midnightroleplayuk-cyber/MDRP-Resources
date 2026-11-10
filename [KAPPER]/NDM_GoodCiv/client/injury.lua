-- After being brought round on scene the patient is "injured": health is capped low
-- (Config.Injury) until they check in at a hospital, either at a GoodCiv check-in
-- point or through the server's own hospital script (Config.CheckIn).
Injury = { active = false }

local I = Config.Injury
local C = Config.CheckIn
local appliedAt = 0
local percent = I.HealthPercent
local checkingIn = false
local clipsetPed = 0

local function capFor(ped)
    -- Player peds are dead at 100; 100..max is the usable range.
    local max = GetEntityMaxHealth(ped)
    return math.floor(100 + (max - 100) * percent / 100)
end

local function nearestCheckIn()
    if C.Mode == 'external' then return nil end
    return GoodCiv.NearestHospital(GetEntityCoords(PlayerPedId()))
end

local function applyClipset(ped)
    if not I.Clipset then return end
    if not HasAnimSetLoaded(I.Clipset) then
        RequestAnimSet(I.Clipset)
        local timeout = GetGameTimer() + 2000
        while not HasAnimSetLoaded(I.Clipset) and GetGameTimer() < timeout do Wait(10) end
    end
    SetPedMovementClipset(ped, I.Clipset, 0.25)
end

local function showBadge()
    local h = nearestCheckIn()
    Nui.Send('injury', {
        title = L('injured_title'),
        text = h and L('injured_goto', h.label) or L('injured_external'),
    })
end

RegisterNetEvent('goodciv:client:setInjured', function(pct, fresh)
    if GetInvokingResource() then return end
    Injury.active = true
    percent = tonumber(pct) or I.HealthPercent
    appliedAt = GetGameTimer()
    local ped = PlayerPedId()
    local cap = capFor(ped)
    if GetEntityHealth(ped) > cap then SetEntityHealth(ped, cap) end
    clipsetPed = ped
    applyClipset(ped)
    showBadge()
    if fresh and I.Waypoint then
        local h = nearestCheckIn()
        if h then SetNewWaypoint(h.drop.x, h.drop.y) end
    end
end)

RegisterNetEvent('goodciv:client:clearInjury', function(heal)
    if GetInvokingResource() then return end
    Injury.active = false
    local ped = PlayerPedId()
    if I.Clipset then ResetPedMovementClipset(ped, 0.25) end
    if heal then
        SetEntityHealth(ped, GetEntityMaxHealth(ped))
        ClearPedBloodDamage(ped)
    end
    Nui.Send('injury', false)
end)

-- Hold the cap. Heals from other scripts (bandages, food, etc.) are clamped back.
CreateThread(function()
    local lastCheck = 0
    while true do
        if not Injury.active or (Down and Down.active) then
            Wait(500)
        else
            local ped = PlayerPedId()
            if I.DisableSprint then
                DisableControlAction(0, 21, true) -- sprint
                DisableControlAction(0, 22, true) -- jump
            end
            local t = GetGameTimer()
            if t - lastCheck > 500 then
                lastCheck = t
                local cap = capFor(ped)
                if GetEntityHealth(ped) > cap then SetEntityHealth(ped, cap) end
                -- Re-apply the injured walk if the ped was replaced (respawn, model change).
                if I.Clipset and ped ~= clipsetPed then
                    clipsetPed = ped
                    applyClipset(ped)
                end
            end
            Wait(0)
        end
    end
end)

---------------------------------------------------------------------------
-- External hospital scripts
---------------------------------------------------------------------------
local function externalTreated()
    if not Injury.active or C.Mode == 'goodciv' then return end
    if GetGameTimer() - appliedAt < C.ExternalGrace * 1000 then return end
    TriggerServerEvent('goodciv:server:externalCheckIn')
end

if C.Mode ~= 'goodciv' then
    for _, name in ipairs(C.ExternalEvents) do
        RegisterNetEvent(name)
        AddEventHandler(name, externalTreated)
    end
end

-- exports.ndm_goodciv:CheckIn() from your hospital script's client once treated.
exports('CheckIn', externalTreated)
exports('IsInjured', function() return Injury.active end)

---------------------------------------------------------------------------
-- GoodCiv check-in points
---------------------------------------------------------------------------
local blips = {}

local function refreshBlips()
    for _, b in ipairs(blips) do RemoveBlip(b) end
    blips = {}
    if C.Mode == 'external' or C.Blips == 'none' then return end
    for _, h in ipairs(GoodCiv.Hospitals) do
        if C.Blips == 'all' or h.custom then
            local b = AddBlipForCoord(h.drop.x, h.drop.y, h.drop.z)
            SetBlipSprite(b, 61)
            SetBlipColour(b, 2)
            SetBlipScale(b, 0.8)
            SetBlipAsShortRange(b, true)
            BeginTextCommandSetBlipName('STRING')
            AddTextComponentSubstringPlayerName(h.label)
            EndTextCommandSetBlipName(b)
            blips[#blips + 1] = b
        end
    end
end

AddStateBagChangeHandler('goodciv:hospitals', 'global', function(_, _, value)
    GoodCiv.SetHospitals(value)
    refreshBlips()
    if Injury.active then showBadge() end
    if Admin then Admin.Refresh() end
end)

CreateThread(refreshBlips)

local function feeFor(h)
    local fee = h.fee or C.Fee
    if Bridge.Name == 'standalone' then fee = 0 end
    return fee
end

RegisterNetEvent('goodciv:client:checkInRun', function(duration, label)
    if GetInvokingResource() then return end
    checkingIn = true
    local ped = PlayerPedId()
    FreezeEntityPosition(ped, true)
    DoScreenFadeOut(800)
    Nui.Send('progress', { label = L('checkin_progress', label), duration = duration })
    Wait(duration * 1000)
    Nui.Send('progress', false)
    FreezeEntityPosition(ped, false)
    DoScreenFadeIn(800)
    checkingIn = false
end)

CreateThread(function()
    if C.Mode == 'external' then return end
    while true do
        local sleep = 1000
        if not checkingIn and not (Down and Down.active) and not (Admin and Admin.IsOpen()) then
            local ped = PlayerPedId()
            local coords = GetEntityCoords(ped)
            for _, h in ipairs(GoodCiv.Hospitals) do
                local p = vector3(h.drop.x, h.drop.y, h.drop.z)
                local d = #(coords - p)
                if d < 15.0 then
                    sleep = 0
                    DrawMarker(1, p.x, p.y, p.z - 0.98, 0, 0, 0, 0, 0, 0, 1.2, 1.2, 0.4,
                        34, 197, 139, 120, false, false, 2, false, nil, nil, false)
                    if d <= C.Distance and not IsPedInAnyVehicle(ped, false) then
                        local fee = feeFor(h)
                        Nui.HelpText(fee > 0 and L('help_checkin_fee', fee) or L('help_checkin'))
                        if IsControlJustPressed(0, 38) then
                            TriggerServerEvent('goodciv:server:checkIn', h.id)
                        end
                    end
                end
            end
        end
        Wait(sleep)
    end
end)

AddEventHandler('onResourceStop', function(res)
    if res ~= GetCurrentResourceName() then return end
    for _, b in ipairs(blips) do RemoveBlip(b) end
    if Injury.active and I.Clipset then ResetPedMovementClipset(PlayerPedId(), 0.25) end
end)
