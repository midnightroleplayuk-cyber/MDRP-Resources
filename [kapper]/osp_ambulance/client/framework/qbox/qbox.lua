if GetResourceState('qbx_core') ~= 'started' then return end

onDuty = false

function GiveVehicleKeys(veh)
    TriggerEvent('vehiclekeys:client:SetOwner', GetVehicleNumberPlateText(veh))
end

function GetPlayerData()
    return exports.qbx_core:GetPlayerData()
end

function GetCharacterName()
    local playerData = GetPlayerData()
    if playerData and playerData.charinfo ~= nil then
        return playerData.charinfo.firstname
    end
end

function AmbulanceDeleteVehicle(veh)
    DeleteVehicle(veh)
end

function GetPlayerJobGrade()
    return PlayerJob.grade.level or PlayerJob.grade
end

function FullFuel(veh)
    SetVehicleFuelLevel(veh, 100.0)
end

function IfInJail()
    local PlayerData = GetPlayerData()
    if PlayerData and PlayerData.metadata and PlayerData.metadata['injail'] and PlayerData.metadata['injail'] > 0 then
        TriggerEvent('prison:client:Enter', PlayerData.metadata['injail'])
    end
end

function IsHandCuffed()
    if GetResourceState('qbx_police') == 'started' then
        return exports.qbx_police:IsHandcuffed()
    end
    if GetResourceState('qbx_policejob') == 'started' then
        return exports.qbx_policejob:IsHandcuffed()
    end
    if GetResourceState('qb-policejob') == 'started' then
        return exports['qb-policejob']:IsHandcuffed()
    end

    local PlayerData = GetPlayerData()
    return PlayerData and PlayerData.metadata and PlayerData.metadata['ishandcuffed'] or false
end

function loadPlayerData()
    if TryStartPlayerDataLoad and not TryStartPlayerDataLoad() then return end
    DebugPrint('loading qbox playerLoggedIn event')
    if GetResourceState('spawnmanager') == 'started' then
        exports.spawnmanager:setAutoSpawn(false)
    end
    Wait(Config.startDamageTimer)
    DebugPrint('loading player data')
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
    local playerData = GetPlayerData()
    while (not playerData or not playerData.citizenid) and GetGameTimer() < playerReadyTimeout do
        Wait(100)
        playerData = GetPlayerData()
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
        TriggerServerEvent('hospital:server:SetDeathStatus', BodyDamage.isDead)
        TriggerServerEvent('hospital:server:SetLaststandStatus', BodyDamage.inLastStand)
    elseif data == false then
        EnsureBodyDamageStructure(BodyDamage)
        if ApplyWoundBloodType then
            ApplyWoundBloodType(nil)
        end
    else
        DebugPrint('wound data load failed — not assigning a new blood type or persisting defaults')
        EnsureBodyDamageStructure(BodyDamage)
    end

    local PlayerData = GetPlayerData()
    local jobTimeout = GetGameTimer() + 10000
    while (not PlayerData or not PlayerData.job) and GetGameTimer() < jobTimeout do
        Wait(100)
        PlayerData = GetPlayerData()
    end

    if PlayerData and PlayerData.job then
        PlayerJob = PlayerData.job
        onDuty = PlayerData.job.onduty
        SetPedArmour(PlayerPedId(), (PlayerData.metadata and PlayerData.metadata['armor']) or 0)
        for _,x in pairs(Config.AmbulanceJobs) do
            if PlayerJob.name == x and onDuty then
                TriggerServerEvent('hospital:server:AddDoctor', PlayerJob.name)
            end
        end
    else
        DebugPrint('PlayerData.job not available on player load')
    end
    EnsureBodyDamageStructure(BodyDamage)
    BodyDamage.BodyPartDamage.appliedTourniquets['Rarm'] = false
    BodyDamage.BodyPartDamage.appliedTourniquets['Larm'] = false
    BodyDamage.BodyPartDamage.appliedTourniquets['Rleg'] = false
    BodyDamage.BodyPartDamage.appliedTourniquets['Lleg'] = false
    Wait(2000)
    local timeLeft = lib.callback.await('osp_ambulance:checkInjuryTime', 1000)
    if timeLeft then
        if timeLeft?.crutch then
            TriggerEvent('osp_ambulance:giveCrutch', timeLeft.time)
        elseif timeLeft?.WheelChair then
            TriggerEvent('osp_ambulance:giveWheelChair', timeLeft.time)
        end
    end
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

RegisterNetEvent('qbx_core:client:playerLoggedOut', function()
    local ped = PlayerPedId()
    TriggerServerEvent('osp_ambulance:saveWoundDataSv', BodyDamage)
    PlayerLoaded = false
    if lastDeadState ~= nil then lastDeadState = false end
    if ResetPlayerDataLoad then ResetPlayerDataLoad() end
    for _,x in pairs(Config.AmbulanceJobs) do
        if PlayerJob.name == x and onDuty then
            TriggerServerEvent('hospital:server:RemoveDoctor', PlayerJob.name)
        end
    end
    TriggerServerEvent('hospital:server:SetArmor', GetPedArmour(ped))
    SetExtraTimecycleModifier('fp_vig_red')
    SetExtraTimecycleModifierStrength(1.0)
    SetPedMotionBlur(ped, false)
    ClearExtraTimecycleModifier()
    SendNUIMessage(
        {
            death = 3,
            blackout = 4,
        }
    )
    if bedOccupying then
        TriggerServerEvent('hospital:server:LeaveBed', bedOccupying)
    end
    deathTime = 0
    RestorePlayer(ped, true)
    SetEntityInvincible(ped, false)
    SetPedArmour(ped, 0)
end)

local function isAmbulanceJob(jobName)
    if type(jobName) ~= 'string' then
        return false
    end

    for _, x in pairs(Config.AmbulanceJobs) do
        if jobName == x then
            return true
        end
    end

    return false
end

local function applyPlayerJob(JobInfo)
    if type(JobInfo) ~= 'table' or type(JobInfo.name) ~= 'string' then
        return
    end

    local previousJob = PlayerJob and PlayerJob.name
    local previousDuty = onDuty == true
    -- Job *definitions* have no onduty flag. Keep the current duty instead of forcing off-duty.
    local nextDuty = previousDuty
    if JobInfo.onduty ~= nil then
        nextDuty = JobInfo.onduty == true
    end
    local jobChanged = previousJob ~= JobInfo.name
    local dutyChanged = previousDuty ~= nextDuty

    PlayerJob = JobInfo
    onDuty = nextDuty

    local wasDoctor = previousJob and isAmbulanceJob(previousJob) and previousDuty
    local isDoctor = isAmbulanceJob(JobInfo.name) and nextDuty

    if wasDoctor and not isDoctor then
        TriggerServerEvent('hospital:server:RemoveDoctor', previousJob)
    elseif isDoctor and not wasDoctor then
        TriggerServerEvent('hospital:server:AddDoctor', JobInfo.name)
    end

    if not jobChanged and not dutyChanged then
        return
    end

    if jobChanged and ReloadJobInteractions then
        ReloadJobInteractions()
    end
    if createPlayerMedicalMenuInteraction then
        createPlayerMedicalMenuInteraction()
    end
end

-- Qbox player job changes use the QB-compatible event.
-- qbx_core:client:onJobUpdate is for job *definition* edits, not SetJob.
RegisterNetEvent('QBCore:Client:OnJobUpdate', function(JobInfo)
    applyPlayerJob(JobInfo)
end)

RegisterNetEvent('qbx_core:client:onJobUpdate', function()
    -- Definition edit only (jobName, job). Never treat that table as the player's job.
    local playerData = GetPlayerData()
    if playerData and playerData.job then
        applyPlayerJob(playerData.job)
    end
end)

RegisterNetEvent('qbx_core:client:onGroupUpdate', function()
    local playerData = GetPlayerData()
    if playerData and playerData.job then
        applyPlayerJob(playerData.job)
    end
end)

RegisterNetEvent('QBCore:Client:SetDuty', function(dutyState)
    DebugPrint('Duty state got updated to: ', dutyState)

    if type(PlayerJob) ~= 'table' then
        onDuty = dutyState == true
        return
    end

    PlayerJob.onduty = dutyState == true
    applyPlayerJob(PlayerJob)
end)

RegisterNetEvent('qbx_core:client:onSetDuty', function(dutyState)
    DebugPrint('Duty state got updated to: ', dutyState)

    if type(PlayerJob) ~= 'table' then
        onDuty = dutyState == true
        return
    end

    PlayerJob.onduty = dutyState == true
    applyPlayerJob(PlayerJob)
end)

function checkOnDuty()
    local PlayerData = exports.qbx_core:GetPlayerData()
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