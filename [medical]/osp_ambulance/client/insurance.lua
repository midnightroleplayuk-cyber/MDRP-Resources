local checkInPeds = {}
local checkInTargetIds = {}
local checkInTargetNames = {}
local checkInZoneActive = false
local insuranceMenuOpen = false

local function SetInsuranceBlur(enabled)
    if enabled then
        TriggerScreenblurFadeIn(250.0)
    else
        TriggerScreenblurFadeOut(250.0)
    end
end

local function CloseInsuranceMenu()
    if not insuranceMenuOpen then
        SetNuiFocus(false, false)
        return
    end
    insuranceMenuOpen = false
    SetNuiFocus(false, false)
    SetInsuranceBlur(false)
end

RegisterNUICallback('insuranceCheckin', function(data, cb)
    if IsInsurvivable(BodyDamage) then
        SendTextMessage(GetLang().interactions.medicalHeader, GetLang().error.insurvivable_injury, 5000, "error")
        cb({ ok = false })
        return
    end
    TriggerEvent('osp_ambulance:checkin', { hospitalID = data.hospitalId })
    CloseInsuranceMenu()
    cb({ ok = true })
end)

RegisterNUICallback('insurancePurchase', function(data, cb)
    local result = lib.callback.await('osp_ambulance:purchaseInsurance', false, data and data.planId) or {}
    cb(result)
end)

RegisterNUICallback('insuranceClose', function(_, cb)
    CloseInsuranceMenu()
    cb({ ok = true })
end)

RegisterNetEvent('osp_ambulance:applyInsuranceCl', function(insurance)
    if type(insurance) ~= 'table' then return end

    BodyDamage = BodyDamage or {}
    BodyDamage.insurance = insurance

    local serverId = GetPlayerServerId(NetworkGetPlayerIndexFromPed(PlayerPedId()))
    if SaveBodyDamage then
        SaveBodyDamage(serverId, BodyDamage, true)
    end
    TriggerServerEvent('osp_ambulance:saveWoundDataSv', BodyDamage)
end)

local function CheckInControls(hospitalId)
    CreateThread(function()
        checkInZoneActive = true
        while checkInZoneActive do
            if IsControlJustPressed(0, 38) then
                OpenCheckInMenu(hospitalId)
            end
            Wait(3)
        end
    end)
end

function OpenCheckInMenu(hospitalId)
    TriggerEvent('osp_ambulance:checkin', { hospitalID = hospitalId })
end

RegisterNetEvent('osp_ambulance:openCheckInMenu', function(data)
    OpenCheckInMenu(data and data.hospitalID)
end)

-- Bumped on every reload. A reload that was overtaken while waiting for the model stops
-- spawning, otherwise two overlapping reloads each spawn a full set of peds (duplicates).
local checkInReloadId = 0

local function SpawnCheckInPed(hospitalId, index, coords, reloadId)
    if type(coords) == 'table' and coords.coords then
        coords = coords.coords
    end
    if not coords or coords.x == nil or coords.y == nil or coords.z == nil then
        return
    end

    local model = joaat(Config.CheckInNPCModel or 's_m_m_doctor_01')
    lib.requestModel(model)
    if reloadId ~= checkInReloadId then return end

    local heading = coords.w or 0.0
    local ped = CreatePed(0, model, coords.x, coords.y, coords.z - 1.0, heading, false, false)
    SetEntityHeading(ped, heading)
    FreezeEntityPosition(ped, true)
    SetEntityInvincible(ped, true)
    SetBlockingOfNonTemporaryEvents(ped, true)

    if Config.CheckInNPCScenario then
        TaskStartScenarioInPlace(ped, Config.CheckInNPCScenario, 0, true)
    end

    checkInPeds[#checkInPeds + 1] = ped

    if Config.UseTarget then
        local zoneName = "hospital-checkin-" .. hospitalId .. "-" .. index
        local zoneId = TargetingBoxZone(zoneName, coords, 2.5, 2.5, 2, {
            type = "client",
            event = "osp_ambulance:openCheckInMenu",
            icon = "fa-solid fa-clipboard-list",
            label = GetLang().text.check,
            hospitalID = hospitalId,
        })
        if Config.UseOxTarget then
            if zoneId then
                checkInTargetIds[#checkInTargetIds + 1] = zoneId
            end
        else
            checkInTargetNames[#checkInTargetNames + 1] = zoneName
        end
    else
        SetupCheckInZone(hospitalId, index, coords)
    end
end

local function DeleteCheckInPeds()
    for _, ped in pairs(checkInPeds) do
        if ped and DoesEntityExist(ped) then
            SetEntityAsMissionEntity(ped, true, true)
            DeleteEntity(ped)
        end
    end
    checkInPeds = {}
end

function ReloadCheckInLocations()
    checkInReloadId = checkInReloadId + 1
    local reloadId = checkInReloadId
    checkInZoneActive = false

    if Config.UseTarget then
        if Config.UseOxTarget then
            for _, id in pairs(checkInTargetIds) do
                if id then
                    RemoveZone(id)
                end
            end
        else
            for _, name in pairs(checkInTargetNames) do
                RemoveZone(name)
            end
        end
        checkInTargetIds = {}
        checkInTargetNames = {}
    elseif ClearCheckInZones then
        ClearCheckInZones()
    end

    DeleteCheckInPeds()

    if type(Config.Hospitals) ~= 'table' then
        return
    end

    for hospitalId, hospital in pairs(Config.Hospitals) do
        if type(hospital.checking) == 'table' then
            for index, coords in pairs(hospital.checking) do
                if reloadId ~= checkInReloadId then return end
                SpawnCheckInPed(hospitalId, index, coords, reloadId)
            end
        end
    end
end

CreateThread(function()
    Wait(2000)
    ReloadCheckInLocations()
end)

AddEventHandler('onResourceStop', function(resourceName)
    if resourceName ~= GetCurrentResourceName() then return end
    checkInZoneActive = false
    CloseInsuranceMenu()
    removeTextUi()
    DeleteCheckInPeds()
end)
