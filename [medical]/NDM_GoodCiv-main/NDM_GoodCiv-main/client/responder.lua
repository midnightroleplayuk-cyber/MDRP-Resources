-- Responder side: alerts, accepting, navigation, and the on-scene / transport loop.
Responder = {}

local alerts = {}        -- ordered list of { id, expires }
local active             -- incident view while responding
local blip
local limitedVehicle
local lastBodyHealth

local function topAlert() return alerts[1] end

local function removeAlert(id)
    for i = #alerts, 1, -1 do
        if alerts[i].id == id then table.remove(alerts, i) end
    end
    Nui.Send('dismissAlert', { id = id })
end

local function clearBlip()
    if blip then RemoveBlip(blip) blip = nil end
end

local function setBlip(coords, label)
    clearBlip()
    blip = AddBlipForCoord(coords.x, coords.y, coords.z)
    SetBlipSprite(blip, 280)
    SetBlipColour(blip, 1)
    SetBlipScale(blip, 1.0)
    SetBlipRoute(blip, true)
    SetBlipRouteColour(blip, 1)
    BeginTextCommandSetBlipName('STRING')
    AddTextComponentSubstringPlayerName(label)
    EndTextCommandSetBlipName(blip)
end

local function releaseVehicle()
    if limitedVehicle and DoesEntityExist(limitedVehicle) then
        SetVehicleMaxSpeed(limitedVehicle, 0.0)
    end
    limitedVehicle, lastBodyHealth = nil, nil
end

function Responder.Active() return active end

function Responder.PatientPed()
    if not active then return 0 end
    local player = GetPlayerFromServerId(active.patient)
    if player == -1 then return 0 end
    return GetPlayerPed(player)
end

---------------------------------------------------------------------------
-- Alerts
---------------------------------------------------------------------------
RegisterNetEvent('goodciv:client:alert', function(incident, timeout)
    if active then return end
    local dist = #(GetEntityCoords(PlayerPedId()) - incident.coords)
    local street = GetStreetNameFromHashKey(GetStreetNameAtCoord(incident.coords.x, incident.coords.y, incident.coords.z))
    removeAlert(incident.id)
    alerts[#alerts + 1] = { id = incident.id, expires = GetGameTimer() + timeout * 1000 }
    Nui.Send('alert', {
        id = incident.id,
        title = L('alert_title'),
        tags = incident.tags,
        street = street,
        distance = math.floor(dist),
        timeout = timeout,
        acceptKey = Config.Alerts.AcceptKey,
        declineKey = Config.Alerts.DeclineKey,
    })
    if Config.Alerts.Sound then
        PlaySoundFrontend(-1, Config.Alerts.Sound.name, Config.Alerts.Sound.set, false)
    end
end)

RegisterNetEvent('goodciv:client:dismissAlert', function(id, reason)
    local had = false
    for i = 1, #alerts do if alerts[i].id == id then had = true end end
    removeAlert(id)
    if had and reason then Nui.Toast('info', reason) end
end)

local function accept()
    local a = topAlert()
    if not a or active then return end
    removeAlert(a.id)
    TriggerServerEvent('goodciv:server:accept', a.id)
end

local function decline()
    local a = topAlert()
    if a then removeAlert(a.id) end
end

RegisterCommand('goodciv_accept', accept, false)
RegisterCommand('goodciv_decline', decline, false)
RegisterKeyMapping('goodciv_accept', 'GoodCiv: accept emergency', 'keyboard', Config.Alerts.AcceptKey)
RegisterKeyMapping('goodciv_decline', 'GoodCiv: decline emergency', 'keyboard', Config.Alerts.DeclineKey)

RegisterNUICallback('accept', function(data, cb) cb('ok') accept() end)
RegisterNUICallback('decline', function(data, cb) cb('ok') decline() end)

-- Expire alerts locally.
CreateThread(function()
    while true do
        Wait(1000)
        local t = GetGameTimer()
        for i = #alerts, 1, -1 do
            if alerts[i].expires <= t then removeAlert(alerts[i].id) end
        end
    end
end)

---------------------------------------------------------------------------
-- Responding
---------------------------------------------------------------------------
RegisterNetEvent('goodciv:client:accepted', function(incident)
    for i = #alerts, 1, -1 do removeAlert(alerts[i].id) end
    active = incident
    setBlip(incident.coords, 'GoodCiv patient')
    Nui.Send('responderHud', active)
end)

RegisterNetEvent('goodciv:client:incidentUpdate', function(incident)
    if not active or active.id ~= incident.id then return end
    local hadTransport = active.transport ~= nil
    active = incident
    Nui.Send('responderHud', active)
    Treatment.Refresh(active)
    if incident.transport and not hadTransport then
        local h = GoodCiv.NearestHospital(GetEntityCoords(PlayerPedId()))
        setBlip(h.coords, h.label)
    elseif not incident.transport and hadTransport then
        releaseVehicle()
        setBlip(incident.coords, 'GoodCiv patient')
    end
end)

RegisterNetEvent('goodciv:client:incidentClosed', function(id, reason)
    if not active or active.id ~= id then return end
    active = nil
    clearBlip()
    releaseVehicle()
    Treatment.Close()
    Nui.Send('responderHud', false)
    if reason then Nui.Toast('info', reason) end
end)

RegisterNUICallback('abandon', function(data, cb)
    cb('ok')
    if active then TriggerServerEvent('goodciv:server:abandon') end
end)

local function treatOrHandover()
    if not active or Treatment.IsBusy() then return end
    local ped = PlayerPedId()
    local coords = GetEntityCoords(ped)
    local patient = Responder.PatientPed()
    if patient == 0 then return end
    local pcoords = GetEntityCoords(patient)
    if active.transport and GoodCiv.HospitalAt(pcoords) and #(coords - pcoords) < 12.0 then
        TriggerServerEvent('goodciv:server:handover')
    elseif not IsPedInAnyVehicle(ped, false) and #(coords - pcoords) <= Config.Treatment.Distance then
        Treatment.Open(active)
    end
end

RegisterCommand('goodciv_treat', treatOrHandover, false)
RegisterKeyMapping('goodciv_treat', 'GoodCiv: treat / hand over patient', 'keyboard', 'G')

-- On-scene prompts, blip tracking, speed limit and crash detection.
CreateThread(function()
    local treatToken = Nui.KeyToken('goodciv_treat')
    while true do
        local sleep = 1000
        if active then
            sleep = 250
            local ped = PlayerPedId()
            local coords = GetEntityCoords(ped)
            local patient = Responder.PatientPed()

            if patient ~= 0 then
                local pcoords = GetEntityCoords(patient)
                local dist = #(coords - pcoords)
                if not active.transport and blip then
                    SetBlipCoords(blip, pcoords.x, pcoords.y, pcoords.z)
                end
                if active.transport and GoodCiv.HospitalAt(pcoords) and dist < 12.0 then
                    sleep = 0
                    Nui.HelpText(L('help_handover', treatToken))
                elseif not active.transport and dist <= Config.Treatment.Distance
                    and not IsPedInAnyVehicle(ped, false) and not Treatment.IsOpen() then
                    sleep = 0
                    Nui.HelpText(L('help_treat', treatToken))
                end
            end

            if active.transport then
                local veh = GetVehiclePedIsIn(ped, false)
                if veh ~= 0 and VehToNet(veh) == active.transport.vehicle and GetPedInVehicleSeat(veh, -1) == ped then
                    if limitedVehicle ~= veh then
                        limitedVehicle = veh
                        lastBodyHealth = GetVehicleBodyHealth(veh)
                        if Config.Transport.SpeedLimitMph > 0 then
                            SetVehicleMaxSpeed(veh, Config.Transport.SpeedLimitMph / 2.236936)
                        end
                    end
                    local body = GetVehicleBodyHealth(veh)
                    if lastBodyHealth - body >= Config.Transport.CrashThreshold then
                        TriggerServerEvent('goodciv:server:crash')
                    end
                    lastBodyHealth = body
                elseif limitedVehicle then
                    releaseVehicle()
                end
            end
        end
        Wait(sleep)
    end
end)

AddEventHandler('onResourceStop', function(res)
    if res ~= GetCurrentResourceName() then return end
    clearBlip()
    releaseVehicle()
end)
