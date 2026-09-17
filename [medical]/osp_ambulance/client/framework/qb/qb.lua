-- Qbox provides qb-core via its bridge; prefer qbox.lua so both frameworks do not load.
if GetResourceState('qbx_core') == 'started' then return end
if GetResourceState('qb-core') ~= 'started' then return end

QBCore = exports['qb-core']:GetCoreObject()
onDuty = false
CreateThread(function()
    QBCore.Functions.GetPlayerData(function(PlayerData)
        if PlayerData.job ~= nil then
            PlayerJob = PlayerData.job
            onDuty = PlayerData.job.onduty
        end
    end)
end)

function GiveVehicleKeys(veh)
    TriggerEvent("vehiclekeys:client:SetOwner", QBCore.Functions.GetPlate(veh))
end

function GetPlayerData()
    return QBCore.Functions.GetPlayerData()
end

function GetCharacterName()
    if GetPlayerData().charinfo ~= nil then
        return GetPlayerData().charinfo.firstname
    end
end

function AmbulanceDeleteVehicle(veh)
    QBCore.Functions.DeleteVehicle(veh)
end

function GetPlayerJobGrade()
    return PlayerJob.grade.level
end

function FullFuel(veh)
    SetVehicleFuelLevel(veh, 100.0)
    -- exports['LegacyFuel']:SetFuel(veh, 100.0)
end

function IfInJail()
    QBCore.Functions.GetPlayerData(function(PlayerData)
        if PlayerData.metadata["injail"] > 0 then
            TriggerEvent("prison:client:Enter", PlayerData.metadata["injail"])
        end
    end)
end

function IsHandCuffed()
    if GetResourceState('qb-policejob') == 'started' then
        return exports['qb-policejob']:IsHandcuffed()
    end

    local PlayerData = GetPlayerData()
    return PlayerData and PlayerData.metadata and PlayerData.metadata['ishandcuffed'] or false
end

function loadPlayerData()
    if TryStartPlayerDataLoad and not TryStartPlayerDataLoad() then return end
    DebugPrint('loading onplayerloaded event')
    if GetResourceState('spawnmanager') == 'started' then
        exports.spawnmanager:setAutoSpawn(false)
    end
    Wait(Config.startDamageTimer)
    DebugPrint('loading player data')
    -- TriggerEvent('hospital:client:Revive')
    local ped = PlayerPedId()
    local player = PlayerId()
    SetEntityMaxHealth(ped, 200)
    SetEntityHealth(ped, 200)
    SetPlayerHealthRechargeMultiplier(player, 0.0)
    SetPlayerHealthRechargeLimit(player, 0.0)
    -- Framework scripts load before main.lua; wait until BodyDamage is initialized.
    local readyTimeout = GetGameTimer() + 10000
    while (not IsBodyDamageReady or not IsBodyDamageReady(BodyDamage)) and GetGameTimer() < readyTimeout do
        if BodyDamage and EnsureBodyDamageStructure then
            EnsureBodyDamageStructure(BodyDamage)
        end
        Wait(100)
    end
    if not IsBodyDamageReady or not IsBodyDamageReady(BodyDamage) then
        DebugPrint('BodyDamage not ready on player load — continuing with defaults')
        if EnsureBodyDamageStructure then
            EnsureBodyDamageStructure(BodyDamage)
        end
    end

    local playerReadyTimeout = GetGameTimer() + 10000
    local playerData
    QBCore.Functions.GetPlayerData(function(pd)
        playerData = pd
    end)
    while (not playerData or not playerData.citizenid) and GetGameTimer() < playerReadyTimeout do
        Wait(100)
        QBCore.Functions.GetPlayerData(function(pd)
            playerData = pd
        end)
    end

    local data = FetchWoundData and FetchWoundData() or lib.callback.await('osp_ambulance:getWoundData', 8000)

    DebugPrint('status: ', BodyDamage.isDead, BodyDamage.inLastStand)
    if type(data) == 'table' then
        BodyDamage = EnsureBodyDamageStructure(data) or data
        BodyDamage.ServerId = GetPlayerServerId(NetworkGetPlayerIndexFromPed(PlayerPedId()))
        BodyDamage.MessageLog = {}
        BodyDamage.inBodyBag = false
        BodyDamage.shockableRythm = false
        if ApplyWoundBloodType then
            ApplyWoundBloodType(data)
        end
        BodyDamage.reportedBloodType = (type(data.reportedBloodType) == 'string' and data.reportedBloodType) or ''
        BodyDamage.bAnalysedBlood = data.bAnalysedBlood or false
        BodyDamage.bDrawnBlood = false
        BodyDamage.bInChair = false
        SaveBodyDamage(GetPlayerServerId(NetworkGetPlayerIndexFromPed(PlayerPedId())), BodyDamage, true)
        local pendingMedical = CaptureLoginMedicalState and CaptureLoginMedicalState()
        if WaitForSpawnSelection then
            WaitForSpawnSelection()
        end
        if ApplyLoginMedicalState then
            ApplyLoginMedicalState(pendingMedical)
        end
        TriggerServerEvent("hospital:server:SetDeathStatus", BodyDamage.isDead)
        TriggerServerEvent("hospital:server:SetLaststandStatus", BodyDamage.inLastStand)
    elseif data == false then
        EnsureBodyDamageStructure(BodyDamage)
        if ApplyWoundBloodType then
            ApplyWoundBloodType(nil)
        end
    else
        DebugPrint('wound data load failed — not assigning a new blood type or persisting defaults')
        EnsureBodyDamageStructure(BodyDamage)
    end

    QBCore.Functions.GetPlayerData(function(PlayerData)
        PlayerJob = PlayerData.job
        onDuty = PlayerData.job.onduty
        SetPedArmour(PlayerPedId(), PlayerData.metadata["armor"])
        for _,x in pairs(Config.AmbulanceJobs) do
            if PlayerJob.name == x and onDuty then
                TriggerServerEvent("hospital:server:AddDoctor", PlayerJob.name)
            end
        end
    end)
    EnsureBodyDamageStructure(BodyDamage)
    BodyDamage.BodyPartDamage.appliedTourniquets["Rarm"] = false
    BodyDamage.BodyPartDamage.appliedTourniquets["Larm"] = false
    BodyDamage.BodyPartDamage.appliedTourniquets["Rleg"] = false
    BodyDamage.BodyPartDamage.appliedTourniquets["Lleg"] = false
    Wait(2000)
    local timeLeft = lib.callback.await('osp_ambulance:checkInjuryTime', 1000)
    if timeLeft then
        if timeLeft?.crutch then
            TriggerEvent('osp_ambulance:giveCrutch', timeLeft.time)
        elseif timeLeft?.WheelChair then
            TriggerEvent('osp_ambulance:giveWheelChair', timeLeft.time)
        end
    end
    -- TriggerServerEvent("police:server:UpdateBlips")
    PlayerLoaded = true
    BodyDamage.playerName = GetCharacterName()
    SaveBodyDamage(GetPlayerServerId(NetworkGetPlayerIndexFromPed(PlayerPedId())), BodyDamage, true)
    initLanguages()
    loadScreens()
    ReloadJobInteractions()
    createPlayerMedicalMenuInteraction()
    Wait(100)
    ConfigLoader.ApplyRuntimeTables(Config)
    local medicationDataWithoutFunctions = deepCopyWithoutFunctions(Config.Medication)
    local jsonData = json.encode(medicationDataWithoutFunctions)
    SendNUIMessage({
        damageStatus = json.encode(BodyDamage),
        medicationData = jsonData,
        castsData = json.encode(Config.Casts),
    })
end

RegisterNetEvent('QBCore:Client:OnPlayerLoaded', loadPlayerData)


RegisterNetEvent('QBCore:Client:OnPlayerUnload', function()
    local ped = PlayerPedId()
    TriggerServerEvent('osp_ambulance:saveWoundDataSv', BodyDamage)
    PlayerLoaded = false
    if lastDeadState ~= nil then lastDeadState = false end
    if ResetPlayerDataLoad then ResetPlayerDataLoad() end
    for _,x in pairs(Config.AmbulanceJobs) do
        if PlayerJob.name == x and onDuty then
            TriggerServerEvent("hospital:server:RemoveDoctor", PlayerJob.name)
        end
    end
    TriggerServerEvent("hospital:server:SetArmor", GetPedArmour(ped))
    SetExtraTimecycleModifier("fp_vig_red")
    SetExtraTimecycleModifierStrength(1.0)
    SetPedMotionBlur(player, false)
    ClearExtraTimecycleModifier()
    SendNUIMessage(
        {
            death = 3,
            blackout = 4,
        }
    )
    if bedOccupying then
        TriggerServerEvent("hospital:server:LeaveBed", bedOccupying)
    end
    deathTime = 0
    RestorePlayer(ped, true)
    SetEntityInvincible(ped, false)
    SetPedArmour(ped, 0)
end)

local oldjob = nil
local duty = false
RegisterNetEvent('QBCore:Client:OnJobUpdate', function(JobInfo)
    PlayerJob = JobInfo
    if oldjob ~= PlayerJob.name or duty ~= onDuty then
        local isauth = false
        for _,x in pairs(Config.AmbulanceJobs) do
            if PlayerJob.name == x then
                onDuty = PlayerJob.onduty
                if onDuty then
                    TriggerServerEvent("hospital:server:AddDoctor", PlayerJob.name)
                end
            end
        end
        if not isauth then
            TriggerServerEvent("hospital:server:RemoveDoctor", PlayerJob.name)
        end
        duty = onDuty
        oldjob = PlayerJob.name
        ReloadJobInteractions()
        createPlayerMedicalMenuInteraction()
    end
end)

RegisterNetEvent('QBCore:Client:SetDuty', function(duty)
    DebugPrint('Duty state got updated to: ', duty)

    for _,x in pairs(Config.AmbulanceJobs) do
        if PlayerJob.name == x and duty == onDuty then
            if duty then
                TriggerServerEvent("hospital:server:AddDoctor", PlayerJob.name)
            else
                TriggerServerEvent("hospital:server:RemoveDoctor", PlayerJob.name)
            end
        end
    end
    onDuty = duty
end)

function checkOnDuty()
    QBCore.Functions.GetPlayerData(function(PlayerData)
        if PlayerData ~= nil then
            while #(Config.AmbulanceJobs) == 0 do Wait(3000) end
            if PlayerData.job ~= nil then
                PlayerJob = PlayerData.job
                onDuty = PlayerData.job.onduty
                for _,x in pairs(Config.AmbulanceJobs) do
                    if PlayerJob.name == x and onDuty then
                        TriggerServerEvent("hospital:server:AddDoctor", PlayerJob.name)
                    end
                end
            end
        end
    end)
end

RegisterNetEvent('osp_ambulance:stash', function()
    if not BodyDamage then return end
    if not HasAccess('stash') then return end

    local stashid = 'ambulancestash_' .. GetPlayerData().citizenid
    return Inventory[GetInventoryTool()].OpenStash(stashid)
end)

RegisterNetEvent('osp_ambulance:bloodstorage', function()
    if not BodyDamage then return end
    if not HasAccess('bloodstorage') then return end

    local stashid = 'bloodstorage_' .. GetPlayerData().citizenid
    return Inventory[GetInventoryTool()].OpenBloodStorage(stashid)
end)