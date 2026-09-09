if GetResourceState('es_extended') ~= 'started' then return end

ESX = exports["es_extended"]:getSharedObject()
onDuty = false

function GiveVehicleKeys(veh)
    --- ADD VEHICLE KEYS CODE HERE IF NEEDED
end

function GetPlayerData()
    return ESX.PlayerData
end

function GetCharacterName()
    if GetPlayerData() ~= nil then
        local name = lib.callback.await('osp_ambulance:getName', 1000)
        if name ~= nil then
            return name.firstname
        else
            return nil
            -- return GetPlayerName(GetPlayerServerId(NetworkGetPlayerIndexFromPed(PlayerPedId())))
        end
    end
end

function AmbulanceDeleteVehicle(veh)
    DeleteVehicle(veh)
end

function GetPlayerJobGrade()
    return PlayerJob.grade
end

function FullFuel(veh)
    SetVehicleFuelLevel(veh, 100.0)
end

function IsHandCuffed()
    return IsPedCuffed(PlayerPedId())
end

function loadPlayerData(d)
    if TryStartPlayerDataLoad and not TryStartPlayerDataLoad() then return end
    PlayerLoaded = true
    if d then
        ESX.PlayerData = d
    end
    Wait(Config.startDamageTimer)
    local ped = PlayerPedId()
    local ply = PlayerId()
    SetEntityMaxHealth(ped, 200)
    SetEntityHealth(ped, 200)
    SetPlayerHealthRechargeMultiplier(ply, 0.0)
    SetPlayerHealthRechargeLimit(ply, 0.0)
    PlayerJob = ESX.PlayerData['job']
    while PlayerJob == nil do
        Wait(100)
        ESX.PlayerData = ESX.GetPlayerData()
        PlayerJob = ESX.PlayerData['job']
    end
    for _,x in pairs(Config.AmbulanceJobs) do
        if PlayerJob.name == x then
            onDuty = true
        end
    end
    for _,x in pairs(Config.AmbulanceJobs) do
        if PlayerJob.name == x and onDuty then
            TriggerServerEvent("hospital:server:AddDoctor", PlayerJob.name)
        end
    end
    local data = FetchWoundData and FetchWoundData() or lib.callback.await('osp_ambulance:getWoundData', 8000)
    if type(data) == 'table' then
        BodyDamage = EnsureBodyDamageStructure(data) or data
        BodyDamage.ServerId = GetPlayerServerId(NetworkGetPlayerIndexFromPed(PlayerPedId()))
        BodyDamage.MessageLog = {}
        BodyDamage.shockableRythm = false
        BodyDamage.inBodyBag = false
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
        if BodyDamage.inLastStand or BodyDamage.isDead then
            ESX.SetPlayerData('dead', true)
        end
    elseif data == false then
        EnsureBodyDamageStructure(BodyDamage)
        if ApplyWoundBloodType then
            ApplyWoundBloodType(nil)
        end
    else
        DebugPrint('wound data load failed — not assigning a new blood type or persisting defaults')
        EnsureBodyDamageStructure(BodyDamage)
    end
    if BodyDamage.Fractures == nil or not BodyDamage.BodyPartDamage or BodyDamage.BodyPartDamage.CosmeticFractures == nil then
        migratePlayerdata()
    end
    EnsureBodyDamageStructure(BodyDamage)
    BodyDamage.playerName = GetCharacterName()
    BodyDamage.BodyPartDamage.appliedTourniquets["Rarm"] = false
    BodyDamage.BodyPartDamage.appliedTourniquets["Larm"] = false
    BodyDamage.BodyPartDamage.appliedTourniquets["Rleg"] = false
    BodyDamage.BodyPartDamage.appliedTourniquets["Lleg"] = false
    SaveBodyDamage(GetPlayerServerId(NetworkGetPlayerIndexFromPed(PlayerPedId())), BodyDamage, true)
    Wait(2000)
    local timeLeft = lib.callback.await('osp_ambulance:checkInjuryTime', 100)
    if timeLeft then
        if timeLeft?.crutch then
            TriggerEvent('osp_ambulance:giveCrutch', timeLeft.time)
        elseif timeLeft?.WheelChair then
            TriggerEvent('osp_ambulance:giveWheelChair', timeLeft.time)
        end
    end
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

RegisterNetEvent('esx:playerLoaded')
AddEventHandler('esx:playerLoaded', function(d)
    loadPlayerData(d)
end)

RegisterNetEvent('esx:onPlayerLogout', function()
    PlayerLoaded = false
    if ResetPlayerDataLoad then ResetPlayerDataLoad() end
end)



RegisterNetEvent('osp_ambulance:loadScreens')
AddEventHandler('osp_ambulance:loadScreens', function()
    loadScreens()
end)


RegisterNetEvent('esx:setJob')
AddEventHandler('esx:setJob', function(job)
    ESX.PlayerData.job = job
    PlayerJob = ESX.PlayerData.job
    local isauth = false
    for _,x in pairs(Config.AmbulanceJobs) do
        if PlayerJob.name == x then
            onDuty = true
            if onDuty then
                isauth = true
                TriggerServerEvent("hospital:server:AddDoctor", PlayerJob.name)
            end
        end
    end
    Wait(100)
    if not isauth then
        onDuty = false
        TriggerServerEvent("hospital:server:RemoveDoctor", PlayerJob.name)
    end
    ReloadJobInteractions()
    createPlayerMedicalMenuInteraction()
end)


function checkOnDuty()
    ESX.PlayerData = ESX.GetPlayerData()
    PlayerJob = ESX.PlayerData.job
    while PlayerJob == nil do
        Wait(100)
    end
    while #(Config.AmbulanceJobs) == 0 do Wait(3000) end
    for _,x in pairs(Config.AmbulanceJobs) do
        if PlayerJob.name == x then
            onDuty = true
        end
    end
    for _,x in pairs(Config.AmbulanceJobs) do
        if PlayerJob.name == x and onDuty then
            TriggerServerEvent("hospital:server:AddDoctor", PlayerJob.name)
        end
    end
end


RegisterNetEvent('osp_ambulance:stash', function()
    if not BodyDamage then return end
    if not HasAccess('stash') then return end

    local stashid = 'ambulancestash_' .. GetPlayerData().identifier
    return Inventory[GetInventoryTool()].OpenStash(stashid)
end)

RegisterNetEvent('osp_ambulance:bloodstorage', function()
    if not BodyDamage then return end
    if not HasAccess('bloodstorage') then return end

    local stashid = 'bloodstorage_' .. GetPlayerData().identifier
    return Inventory[GetInventoryTool()].OpenBloodStorage(stashid)
end)

RegisterNetEvent('esx_ambulancejob:revive', function()
    TriggerEvent('hospital:client:Revive', true)
end)

AddEventHandler('playerSpawned', function()
    BodyDamage.isDead = false
    BodyDamage.inLastStand = false
    if GetResourceState('spawnmanager') == 'started' then
        exports.spawnmanager:setAutoSpawn(false)
    end
end)