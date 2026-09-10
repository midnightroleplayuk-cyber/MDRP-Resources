incomingScreenScale = 0.16
incomingScreenOffset = vector3(-0.48, 0.0, -0.87)
incomingScreenRot = vector3(-20.0, 180.0, 90.0)
stationaryScale = 0.077
stationaryScreenOffset = vector3(-0.013, 0.16, -1.06)
stationaryScreenRot = vector3(195.0, 0.0, 0.0)
ecgScreenScale = 0.07
ecgScreenOffset = vector3(-0.115, 0.26, 0.075)
ecgScreenRotation = vector3(5.0, 180.0, 90.0)
xrayScreenOffset = vector3(-0.045, 0.01, 0.36)
xrayScreenRot = vector3(0.0, 180.0, 90.0)
ecgPedOffset = vector3(0.42, 0.0, 0.03)
ecgPedRotation = vector3(0.0, 255.0, 80.0)

PlayerJob = {}
PlayerLoaded = PlayerLoaded or false
BloodTypeReady = BloodTypeReady or false
soundTable = {}
isHandCuffed = false

lastStandDict = "combat@damage@writhe"
lastStandAnim = "writhe_loop"
deadAnimDict = "dead"
deadAnim = "dead_a"
getOutDict = 'switch@franklin@bed'
getOutAnim = 'sleep_getup_rubeyes'

local checkInPoly = {}

local nodam = false

if Config and Config.UseXsound then
    xSound = exports.xsound
end

function GetMedicalInventoryItems()

    DebugPrint('Getting Medical Inventory Items')
    
    if Config.AmbulanceBypassItems and IsEmsStaff() then
        return createBypassItemTable()
    else
        return Inventory[GetInventoryTool()].GetInventory()
    end
end

local ambulanceItemNamesCache = nil

local function addAmbulanceItemName(items, name)
    if name and name ~= '' then
        items[name] = true
    end
end

function GetAmbulanceItemNames()
    if ambulanceItemNamesCache then
        return ambulanceItemNamesCache
    end

    local items = {}

    if type(Config.ItemShop) == 'table' then
        for _, shopItem in pairs(Config.ItemShop) do
            addAmbulanceItemName(items, shopItem.name)
        end
    end

    if type(Config.Medication) == 'table' then
        for _, medication in pairs(Config.Medication) do
            addAmbulanceItemName(items, medication.itemName)
        end
    end

    if type(Config.Casts) == 'table' then
        for _, castGroup in pairs(Config.Casts) do
            if type(castGroup.casts) == 'table' then
                for _, cast in pairs(castGroup.casts) do
                    addAmbulanceItemName(items, cast.itemName)
                    addAmbulanceItemName(items, cast.removalItemName)
                end
            end
        end
    end

    if type(Config.PrescriptionMedications) == 'table' then
        for _, medication in pairs(Config.PrescriptionMedications) do
            addAmbulanceItemName(items, medication.itemName)
        end
    end

    addAmbulanceItemName(items, 'bloodsample')
    addAmbulanceItemName(items, 'expiredblood')
    addAmbulanceItemName(items, 'prescription')

    ambulanceItemNamesCache = items
    return items
end

function FilterSupplyItems(invItems)
    local allowedItems = GetAmbulanceItemNames()
    local filtered = {}

    for _, item in pairs(invItems or {}) do
        if item.item and allowedItems[item.item] then
            filtered[#filtered + 1] = item
        end
    end

    return filtered
end

function BuildInventoryNuiFields(invItems)
    invItems = invItems or GetMedicalInventoryItems()

    return {
        invItems = json.encode(invItems),
        supplyItems = json.encode(FilterSupplyItems(invItems)),
    }
end

RegisterNetEvent('EMSToggle:Duty', function()
    onDuty = not onDuty
    if GetActiveFramework() == 'qb' then
        TriggerServerEvent("QBCore:ToggleDuty")
        -- TriggerServerEvent("police:server:UpdateBlips")
    else
        if onDuty then
            TriggerServerEvent("hospital:server:AddDoctor", PlayerJob.name)
            SendTextMessage(GetLang().interactions.medicalHeader, GetLang().info.on_duty, 5000, "success")
        else
            SendTextMessage(GetLang().interactions.medicalHeader, GetLang().info.off_duty, 5000, "error")
            TriggerServerEvent("hospital:server:RemoveDoctor", PlayerJob.name)
        end
    end
end)


DutyBlips = {}

local pendingDutyBlips
local dutyBlipsBusy = false

local function ClearDutyBlips()
    if DutyBlips then
        for _, blip in pairs(DutyBlips) do
            if blip and DoesBlipExist(blip) then
                RemoveBlip(blip)
            end
        end
    end
    DutyBlips = {}
end

local function StyleDutyBlip(blip, playerLabel, playerLocation)
    SetBlipSprite(blip, 1)
    ShowHeadingIndicatorOnBlip(blip, true)
    if playerLocation and playerLocation.w then
        SetBlipRotation(blip, math.ceil(playerLocation.w))
    end
    SetBlipScale(blip, 1.0)
    SetBlipColour(blip, 5)
    SetBlipAsShortRange(blip, true)
    BeginTextCommandSetBlipName('STRING')
    AddTextComponentString(playerLabel or '')
    EndTextCommandSetBlipName(blip)
end

local function ApplyDutyBlips(players)
    if not onDuty or not IsEmsStaff() then
        ClearDutyBlips()
        return
    end

    ClearDutyBlips()

    if not players then
        return
    end

    local myServerId = GetPlayerServerId(PlayerId())
    for _, data in pairs(players) do
        local src = tonumber(data.source)
        if src and src ~= myServerId then
            CreateDutyBlips(GetPlayerFromServerId(src), data.label, data.job, data.location)
        end
    end
end

RegisterNetEvent('osp_ambulance:jobBlipsCl', function(players)
    pendingDutyBlips = players or {}
    if dutyBlipsBusy then
        return
    end

    dutyBlipsBusy = true
    CreateThread(function()
        while pendingDutyBlips ~= nil do
            local snapshot = pendingDutyBlips
            pendingDutyBlips = nil
            ApplyDutyBlips(snapshot)
        end
        dutyBlipsBusy = false
        if pendingDutyBlips ~= nil then
            TriggerEvent('osp_ambulance:jobBlipsCl', pendingDutyBlips)
        end
    end)
end)

function CreateDutyBlips(playerId, playerLabel, playerJob, playerLocation)
    if playerId == PlayerId() then
        return
    end

    local blip
    if playerId and playerId ~= -1 and NetworkIsPlayerActive(playerId) then
        local ped = GetPlayerPed(playerId)
        if ped and ped ~= 0 then
            blip = GetBlipFromEntity(ped)
            if DoesBlipExist(blip) then
                return
            end
            blip = AddBlipForEntity(ped)
        end
    end

    if not blip then
        if not playerLocation then
            return
        end
        blip = AddBlipForCoord(playerLocation.x, playerLocation.y, playerLocation.z)
    end

    StyleDutyBlip(blip, playerLabel, playerLocation)
    DutyBlips[#DutyBlips + 1] = blip
end


function IsValidBloodType(bloodType)
    return type(bloodType) == 'string' and bloodType ~= '' and Config.bloodTypes and Config.bloodTypes[bloodType] ~= nil
end

function GetMedicalBloodType()
    if BodyDamage and IsValidBloodType(BodyDamage.bloodType) then
        return BodyDamage.bloodType
    end
    return nil
end

function GetEvidenceIdentifier()
    local playerData = GetPlayerData and GetPlayerData()
    if type(playerData) ~= 'table' then return nil end
    return playerData.citizenid or playerData.identifier
end

function GetEvidenceBloodType()
    return GetMedicalBloodType()
end

-- Restore a stored type, or assign once. Never overwrites a valid type.
function ApplyWoundBloodType(woundData)
    BloodTypeReady = true

    local incoming = woundData and woundData.bloodType
    if IsValidBloodType(incoming) then
        BodyDamage.bloodType = incoming
        return incoming
    end

    if IsValidBloodType(BodyDamage.bloodType) then
        return BodyDamage.bloodType
    end

    local created = CreateBloodType and CreateBloodType() or nil
    if IsValidBloodType(created) then
        BodyDamage.bloodType = created
        return created
    end

    BodyDamage.bloodType = ''
    return nil
end

local playerDataLoadStarted = false
local spawnSelectorSeen = false
SpawnSelectionReady = SpawnSelectionReady or false

local SpawnSelectorResources = {
    'qbx_spawn',
    'qb-spawn',
    'vms_spawnselector',
    'um-spawn',
    'okokSpawnSelector',
    'spawnselector',
    '0r-spawn',
    '0r_spawn',
}

local SpawnSelectorOpenEvents = {
    'qb-spawn:client:setupSpawns',
    'qb-spawn:client:openUI',
    'qbx_spawn:client:setupSpawns',
    'vms_spawnselector:open',
    'vms_spawnselector:client:open',
}

function HasSpawnSelectorResource()
    for i = 1, #SpawnSelectorResources do
        if GetResourceState(SpawnSelectorResources[i]) == 'started' then
            return true
        end
    end
    return false
end

function MarkSpawnSelectorOpen()
    spawnSelectorSeen = true
    SpawnSelectionReady = false
end

function MarkSpawnSelectionReady()
    SpawnSelectionReady = true
end

-- Override this if your spawn selector uses a different "I'm done" signal.
function CustomWaitForSpawnSelection()
    return false
end

function WaitForSpawnSelection()
    if CustomWaitForSpawnSelection and CustomWaitForSpawnSelection() then
        SpawnSelectionReady = true
        return
    end

    Wait(300)

    if SpawnSelectionReady then
        return
    end

    local hasSelector = HasSpawnSelectorResource()
    if not hasSelector and not spawnSelectorSeen and not IsEntityPositionFrozen(PlayerPedId()) then
        SpawnSelectionReady = true
        return
    end

    -- Character load often happens before the selector opens.
    local openDeadline = GetGameTimer() + 8000
    while not spawnSelectorSeen
        and not SpawnSelectionReady
        and not IsEntityPositionFrozen(PlayerPedId())
        and GetGameTimer() < openDeadline
    do
        Wait(100)
    end

    if SpawnSelectionReady then
        return
    end

    -- Already confirmed: selector closed and the ped is in the world.
    if spawnSelectorSeen and not IsEntityPositionFrozen(PlayerPedId()) and not IsScreenFadedOut() then
        SpawnSelectionReady = true
        return
    end

    if not spawnSelectorSeen and not IsEntityPositionFrozen(PlayerPedId()) then
        SpawnSelectionReady = true
        return
    end

    local deadline = GetGameTimer() + 180000
    while not SpawnSelectionReady and GetGameTimer() < deadline do
        if not IsEntityPositionFrozen(PlayerPedId()) and not IsScreenFadedOut() then
            break
        end
        Wait(100)
    end

    while IsScreenFadedOut() and GetGameTimer() < deadline do
        Wait(50)
    end

    SpawnSelectionReady = true
    Wait(250)
end

local loginMedicalPending = false

function IsLoginMedicalPending()
    return loginMedicalPending == true
end

function CaptureLoginMedicalState()
    local pending
    if BodyDamage.inLastStand and ShouldSkipLaststand and ShouldSkipLaststand(BodyDamage, { source = 'login' }) then
        pending = { skipLaststand = true }
    elseif BodyDamage.inLastStand then
        pending = { laststand = true }
    elseif BodyDamage.isDead then
        pending = { dead = true }
    elseif BodyDamage.playerHealth ~= nil then
        pending = { health = BodyDamage.playerHealth, armour = BodyDamage.playerArmour }
    end

    -- Keep wounds/blood type, but do not show death UI until spawn is confirmed.
    loginMedicalPending = pending and (pending.dead or pending.laststand or pending.skipLaststand) or false
    if loginMedicalPending then
        BodyDamage.isDead = false
        BodyDamage.inLastStand = false
    end

    return pending
end

function ApplyLoginMedicalState(pending)
    loginMedicalPending = false
    if type(pending) ~= 'table' then return end

    if pending.skipLaststand or pending.dead then
        BodyDamage.inLastStand = false
        BodyDamage.isDead = false
        deathTime = Config.RespawnTime
        OnDeath()
        DeathTimer()
    elseif pending.laststand then
        SetLaststand(true)
    elseif pending.health ~= nil then
        local ped = PlayerPedId()
        local health = pending.health
        local armour = pending.armour or 0
        CreateThread(function()
            SetEntityHealth(ped, health)
            SetPedArmour(ped, armour)
            Wait(1000)
            SetEntityHealth(PlayerPedId(), health)
        end)
    end
end

function TryStartPlayerDataLoad()
    if playerDataLoadStarted then
        -- qbx_spawn fires OnPlayerLoaded again after a location is chosen.
        MarkSpawnSelectionReady()
        return false
    end
    playerDataLoadStarted = true
    return true
end

function ResetPlayerDataLoad()
    playerDataLoadStarted = false
    BloodTypeReady = false
    spawnSelectorSeen = false
    SpawnSelectionReady = false
    loginMedicalPending = false
end

for i = 1, #SpawnSelectorOpenEvents do
    RegisterNetEvent(SpawnSelectorOpenEvents[i], MarkSpawnSelectorOpen)
    AddEventHandler(SpawnSelectorOpenEvents[i], MarkSpawnSelectorOpen)
end

function FetchWoundData()
    local data
    for _ = 1, 5 do
        data = lib.callback.await('osp_ambulance:getWoundData', 8000)
        if data ~= nil then
            return data
        end
        Wait(500)
    end
    return nil
end

-- Override this to send blood drops to a third-party evidence script (client-side).
-- bloodType is always the medical-system type. Return true if you handled the drop.
function CreateCustomBloodDropEvidence(bloodType, coords, identifier)
    -- Example:
    -- exports['my_evidence']:CreateBloodDrop(identifier, bloodType, coords)
    -- return true
    return false
end

function CreateBloodDropEvidence()
    local bloodType = GetEvidenceBloodType()
    if not bloodType then return end

    local randX = math.random() + math.random(-1, 1)
    local randY = math.random() + math.random(-1, 1)
    local coords = GetOffsetFromEntityInWorldCoords(PlayerPedId(), randX, randY, 0)
    local identifier = GetEvidenceIdentifier()

    if CreateCustomBloodDropEvidence(bloodType, coords, identifier) then
        return
    end

    -- Default QB / Qbox / ESX police evidence, using the medical-system blood type
    if identifier then
        TriggerServerEvent('evidence:server:CreateBloodDrop', identifier, bloodType, coords)
    end

    TriggerServerEvent('osp_ambulance:createBloodDropEvidence', bloodType, coords)
end

CreateThread(function()
    Wait(2000)
    if PlayerLoaded then return end
    if type(loadPlayerData) ~= 'function' then return end
    local playerData = GetPlayerData and GetPlayerData()
    if type(playerData) ~= 'table' then return end
    if not playerData.citizenid and not playerData.identifier then return end
    loadPlayerData(playerData)
end)

local BODY_DAMAGE_PARTS = { 'Rarm', 'Larm', 'Rleg', 'Lleg', 'Torso', 'Head' }
local BODY_DAMAGE_LIMBS = { 'Rarm', 'Larm', 'Rleg', 'Lleg' }

-- State bags / JSON round-trips often produce sparse or string-keyed wound tables.
-- `#` then returns 0 and bandage/sewing logic silently removes nothing.
function CompactWoundList(list)
    local compact = {}
    if type(list) ~= 'table' then
        return compact
    end

    local indexed = {}
    for k, wound in pairs(list) do
        if type(wound) == 'string' and wound ~= '' then
            local idx = tonumber(k)
            if idx then
                indexed[#indexed + 1] = { idx = idx, wound = wound }
            else
                compact[#compact + 1] = wound
            end
        end
    end

    if #indexed > 0 then
        table.sort(indexed, function(a, b)
            return a.idx < b.idx
        end)
        local ordered = {}
        for i = 1, #indexed do
            ordered[#ordered + 1] = indexed[i].wound
        end
        for i = 1, #compact do
            ordered[#ordered + 1] = compact[i]
        end
        return ordered
    end

    return compact
end

-- Fills missing nested tables/keys after DB load or state sync without wiping existing wound data.
function EnsureBodyDamageStructure(bd)
    if type(bd) ~= 'table' then
        return nil
    end

    bd.BodyPartDamage = type(bd.BodyPartDamage) == 'table' and bd.BodyPartDamage or {}
    local bpd = bd.BodyPartDamage

    bpd.BloodLevel = tonumber(bpd.BloodLevel) or 6.0
    bpd.DamageType = type(bpd.DamageType) == 'table' and bpd.DamageType or {}
    bpd.appliedTourniquets = type(bpd.appliedTourniquets) == 'table' and bpd.appliedTourniquets or {}
    bpd.appliedSplints = type(bpd.appliedSplints) == 'table' and bpd.appliedSplints or {}
    bpd.Bleeding = type(bpd.Bleeding) == 'table' and bpd.Bleeding or {}
    bpd.Wounds = type(bpd.Wounds) == 'table' and bpd.Wounds or {}
    bpd.Fractures = type(bpd.Fractures) == 'table' and bpd.Fractures or {}
    bpd.CosmeticFractures = type(bpd.CosmeticFractures) == 'table' and bpd.CosmeticFractures or {}
    bpd.FractureTime = type(bpd.FractureTime) == 'table' and bpd.FractureTime or {}
    bpd.NeedSewed = type(bpd.NeedSewed) == 'table' and bpd.NeedSewed or {}

    if type(bpd.Triage) ~= 'string' then
        bpd.Triage = 'None'
    end

    bpd.TotalBloodFill = tonumber(bpd.TotalBloodFill) or 0
    bpd.RefillBloodLeft = tonumber(bpd.RefillBloodLeft) or 0
    bpd.TotalInfusionFill = tonumber(bpd.TotalInfusionFill) or 0
    bpd.RefillInfusionLeft = tonumber(bpd.RefillInfusionLeft) or 0
    if type(bpd.ActiveInfusions) ~= 'table' then
        bpd.ActiveInfusions = {}
    end
    if type(bpd.ConflictingBlood) ~= 'table' then
        bpd.ConflictingBlood = { stage = 0, tick = 0 }
    end

    for i = 1, #BODY_DAMAGE_PARTS do
        local part = BODY_DAMAGE_PARTS[i]
        bpd.Wounds[part] = CompactWoundList(bpd.Wounds[part])
        if bpd.Fractures[part] == nil then
            bpd.Fractures[part] = false
        end
        if bpd.CosmeticFractures[part] == nil then
            bpd.CosmeticFractures[part] = false
        end
        if bpd.FractureTime[part] == nil then
            bpd.FractureTime[part] = 0
        end
        if bpd.NeedSewed[part] == nil then
            bpd.NeedSewed[part] = false
        end
        if bpd.Bleeding[part] == nil then
            bpd.Bleeding[part] = 0
        else
            bpd.Bleeding[part] = tonumber(bpd.Bleeding[part]) or 0
        end
        if bpd.DamageType[part] == nil then
            bpd.DamageType[part] = 0
        else
            bpd.DamageType[part] = tonumber(bpd.DamageType[part]) or 0
        end
    end

    for i = 1, #BODY_DAMAGE_LIMBS do
        local part = BODY_DAMAGE_LIMBS[i]
        if bpd.appliedTourniquets[part] == nil then
            bpd.appliedTourniquets[part] = false
        end
    end

    if type(bd.BloodPressure) ~= 'table' then
        bd.BloodPressure = { 120, 80 }
    else
        bd.BloodPressure[1] = tonumber(bd.BloodPressure[1]) or tonumber(bd.BloodPressure['1']) or 120
        bd.BloodPressure[2] = tonumber(bd.BloodPressure[2]) or tonumber(bd.BloodPressure['2']) or 80
    end

    if type(bd.Pulse) ~= 'number' then
        bd.Pulse = tonumber(bd.Pulse) or 80
    end
    if type(bd.Pain) ~= 'number' then
        bd.Pain = tonumber(bd.Pain) or 0
    end
    if type(bd.Temp) ~= 'number' then
        bd.Temp = tonumber(bd.Temp) or 37.0
    end
    if type(bd.oxygenSaturation) ~= 'number' then
        bd.oxygenSaturation = tonumber(bd.oxygenSaturation) or 99
    end
    if type(bd.Conscious) ~= 'boolean' then
        bd.Conscious = bd.Conscious ~= false and bd.Conscious ~= 0
    end
    if type(bd.isDead) ~= 'boolean' then
        bd.isDead = bd.isDead == true
    end
    if type(bd.inLastStand) ~= 'boolean' then
        bd.inLastStand = bd.inLastStand == true
    end
    if type(bd.cardiacState) ~= 'string' or bd.cardiacState == '' then
        bd.cardiacState = 'NSR'
    end
    if type(bd.MessageLog) ~= 'table' then
        bd.MessageLog = {}
    end
    if type(bd.activeConditions) ~= 'table' then
        bd.activeConditions = {}
    end
    if type(bd.addictions) ~= 'table' then
        bd.addictions = {}
    end
    if type(bd.drugDoses) ~= 'table' then
        bd.drugDoses = {}
    end
    if type(bd.overdose) ~= 'table' then
        bd.overdose = { active = false }
    end
    if type(bd.hrIncrease) ~= 'number' then
        bd.hrIncrease = tonumber(bd.hrIncrease) or 0
    end
    if type(bd.hrDecrease) ~= 'number' then
        bd.hrDecrease = tonumber(bd.hrDecrease) or 0
    end

    -- bloodType was historically initialized as {} which is truthy and broke persistence checks
    if type(bd.bloodType) ~= 'string' then
        bd.bloodType = ''
    end
    if type(bd.reportedBloodType) ~= 'string' then
        bd.reportedBloodType = ''
    end

    return bd
end

function IsBodyDamageReady(bd)
    bd = bd or BodyDamage
    local bpd = bd and bd.BodyPartDamage
    return type(bpd) == 'table'
        and type(bpd.Wounds) == 'table'
        and type(bpd.Wounds.Lleg) == 'table'
        and type(bpd.DamageType) == 'table'
        and type(bpd.DamageType.Lleg) == 'number'
        and type(bd.BloodPressure) == 'table'
        and type(bd.BloodPressure[1]) == 'number'
end

RegisterNetEvent('osp_ambulance:SaveBodyDamageCl', function()
    local data = FetchWoundData and FetchWoundData() or lib.callback.await('osp_ambulance:getWoundData', 8000)
    if data then
        BodyDamage = EnsureBodyDamageStructure(data) or data
        if ApplyWoundBloodType then
            ApplyWoundBloodType(data)
        end
        BodyDamage.ServerId = GetPlayerServerId(NetworkGetPlayerIndexFromPed(PlayerPedId()))
        BodyDamage.MessageLog = {}
        BodyDamage.inBodyBag = false
        local pendingMedical = CaptureLoginMedicalState and CaptureLoginMedicalState()
        if WaitForSpawnSelection then
            WaitForSpawnSelection()
        end
        if ApplyLoginMedicalState then
            ApplyLoginMedicalState(pendingMedical)
        end
    elseif data == false then
        EnsureBodyDamageStructure(BodyDamage)
        if ApplyWoundBloodType then
            ApplyWoundBloodType(nil)
        end
    else
        DebugPrint('wound data load failed — keeping local BodyDamage without persisting')
        EnsureBodyDamageStructure(BodyDamage)
        return
    end
    if BodyDamage.Fractures == nil or not BodyDamage.BodyPartDamage or BodyDamage.BodyPartDamage.CosmeticFractures == nil then
        migratePlayerdata()
    end
    EnsureBodyDamageStructure(BodyDamage)
    SaveBodyDamage(GetPlayerServerId(NetworkGetPlayerIndexFromPed(PlayerPedId())), BodyDamage, true)
end)



local currentTextUi = nil
local textUiOptions = { position = "left-center" }

function textUi(txt)
    if currentTextUi == txt then return end -- already shown, don't spam NUI every tick
    currentTextUi = txt
    lib.showTextUI(txt, textUiOptions)
end

function removeTextUi()
    if currentTextUi == nil then return end
    currentTextUi = nil
    lib.hideTextUI()
end

local serverTimeOffset = 0

function SyncServerTime()
    local serverTime = lib.callback.await('osp_ambulance:getServerTime', false)
    if serverTime then
        serverTimeOffset = serverTime - math.floor(GetGameTimer() / 1000)
    end
end

function GetServerTime()
    return math.floor(GetGameTimer() / 1000) + serverTimeOffset
end

local bodyPartLabels = {
    Head = 'Head',
    Torso = 'Torso',
    Rarm = 'Right Arm',
    Larm = 'Left Arm',
    Rleg = 'Right Leg',
    Lleg = 'Left Leg',
}

local function GetConditionConfigById(conditionId)
    for _, condition in pairs(Config.PrescriptionConditions or {}) do
        if condition.id == conditionId then
            return condition
        end
    end
end

local function GetDrugConfigById(drugId)
    for _, drug in pairs(Config.AddictiveDrugs or {}) do
        if drug.id == drugId then
            return drug
        end
    end
end

local function GetConditionSymptomLabels(effects)
    local symptoms = {}
    if type(effects) ~= 'table' then return symptoms end
    local ui = GetLang().ui or {}
    if effects.coughAnim then
        symptoms[#symptoms + 1] = ui.symptom_coughing or 'Coughing'
    end
    if effects.painPulse then
        symptoms[#symptoms + 1] = ui.symptom_pain_flares or 'Pain flares'
    end
    if effects.cameraShake or effects.stressAmount then
        symptoms[#symptoms + 1] = ui.symptom_anxiety or 'Anxiety / nervousness'
    end
    if effects.staminaDrain then
        symptoms[#symptoms + 1] = ui.symptom_fatigue or 'Fatigue / insomnia'
    end
    return symptoms
end

local function GetWithdrawalSymptomLabels(stage)
    local symptoms = {}
    if type(stage) ~= 'table' then return symptoms end
    local ui = GetLang().ui or {}
    if stage.tempIncrease and stage.tempIncrease > 0 then
        symptoms[#symptoms + 1] = ui.symptom_elevated_temp or 'Elevated temperature'
    end
    if stage.sprintMultiplier and stage.sprintMultiplier < 1.0 then
        symptoms[#symptoms + 1] = ui.symptom_weakness or 'Weakness / reduced stamina'
    end
    if stage.aimPenalty then
        symptoms[#symptoms + 1] = ui.symptom_tremors or 'Tremors / unsteady hands'
    end
    if stage.heartbeat then
        symptoms[#symptoms + 1] = ui.symptom_palpitations or 'Palpitations'
    end
    if stage.healthDrain and stage.healthDrain > 0 then
        symptoms[#symptoms + 1] = ui.symptom_malaise or 'General malaise'
    end
    if stage.vomitChance and stage.vomitChance > 0 then
        symptoms[#symptoms + 1] = ui.symptom_nausea or 'Nausea'
    end
    return symptoms
end

local function GetActiveWithdrawalStage(drugConfig, secondsSinceDose)
    local activeStage = nil
    local stageIndex = 0
    for i, stage in ipairs(drugConfig.withdrawalStages or {}) do
        if secondsSinceDose >= (tonumber(stage.afterSeconds) or 0) then
            activeStage = stage
            stageIndex = i
        end
    end
    return activeStage, stageIndex
end

function BuildClinicalFindings(bodyDamage)
    local findings = {
        bleedingActive = false,
        bleedingSeverity = 'none',
        bleedingSites = {},
        conditions = {},
        withdrawal = {},
        overdose = false,
    }

    if type(bodyDamage) ~= 'table' then
        return findings
    end

    local bleeding = bodyDamage.BodyPartDamage and bodyDamage.BodyPartDamage.Bleeding
    local maxBleed = 0
    if type(bleeding) == 'table' then
        for part, amount in pairs(bleeding) do
            local value = tonumber(amount) or 0
            if value > maxBleed then
                maxBleed = value
            end
            if value > 0 then
                findings.bleedingSites[#findings.bleedingSites + 1] = {
                    part = part,
                    label = bodyPartLabels[part] or part,
                    amount = value,
                }
            end
        end
    end

    findings.bleedingActive = maxBleed > 0
    if maxBleed > 0.5 then
        findings.bleedingSeverity = 'severe'
    elseif maxBleed > 0 then
        findings.bleedingSeverity = 'active'
    end

    local now = GetServerTime()
    for conditionId, conditionData in pairs(bodyDamage.activeConditions or {}) do
        if type(conditionData) == 'table' then
            local expiresAt = tonumber(conditionData.expiresAt)
            local expired = expiresAt and now >= expiresAt
            if not expired then
                local conditionConfig = GetConditionConfigById(conditionId)
                local suppressedUntil = tonumber(conditionData.suppressedUntil) or 0
                local suppressed = now < suppressedUntil
                findings.conditions[#findings.conditions + 1] = {
                    id = conditionId,
                    label = (conditionConfig and conditionConfig.label) or conditionId,
                    suppressed = suppressed,
                    contagious = conditionConfig and conditionConfig.contagious == true or false,
                    symptoms = suppressed and {} or GetConditionSymptomLabels(conditionConfig and conditionConfig.effects),
                }
            end
        end
    end

    for drugId, addictionData in pairs(bodyDamage.addictions or {}) do
        if type(addictionData) == 'table' and addictionData.addicted then
            local drugConfig = GetDrugConfigById(drugId)
            local lastDose = tonumber(addictionData.lastDoseAt) or 0
            local elapsed = math.max(now - lastDose, 0)
            local grace = tonumber(drugConfig and drugConfig.withdrawalGracePeriod) or 300
            local ui = GetLang().ui or {}
            local entry = {
                id = drugId,
                label = (drugConfig and drugConfig.label) or drugId,
                stage = 0,
                status = 'craving',
                symptoms = { ui.symptom_drug_craving or 'Drug craving' },
            }

            if elapsed >= grace and drugConfig then
                local stage, stageIndex = GetActiveWithdrawalStage(drugConfig, elapsed)
                entry.status = 'withdrawal'
                entry.stage = stageIndex
                entry.symptoms = GetWithdrawalSymptomLabels(stage)
                if #entry.symptoms == 0 then
                    entry.symptoms = { ui.withdrawal_symptoms or 'Withdrawal symptoms' }
                end
            elseif elapsed >= grace then
                entry.status = 'withdrawal'
                entry.symptoms = { ui.withdrawal_symptoms or 'Withdrawal symptoms' }
            end

            findings.withdrawal[#findings.withdrawal + 1] = entry
        end
    end

    local overdose = bodyDamage.overdose
    findings.overdose = type(overdose) == 'table' and overdose.active == true and not overdose.treated

    return findings
end

function EncodeBodyDamageForNui(stat)
    if type(stat) ~= 'table' then
        return 'null'
    end

    local payload = deepCopyWithoutFunctions(EnsureBodyDamageStructure(stat) or stat)

    -- State bags / sparse Lua tables often JSON-encode as objects. The medical UI
    -- treats Wounds/MessageLog as arrays (.length / spread), so compact them first.
    local bpd = payload.BodyPartDamage
    if type(bpd) == 'table' and type(bpd.Wounds) == 'table' then
        for i = 1, #BODY_DAMAGE_PARTS do
            local part = BODY_DAMAGE_PARTS[i]
            bpd.Wounds[part] = CompactWoundList(bpd.Wounds[part])
        end
    end

    if type(payload.MessageLog) == 'table' then
        local compactLog = {}
        for _, entry in pairs(payload.MessageLog) do
            if entry ~= nil then
                compactLog[#compactLog + 1] = entry
            end
        end
        payload.MessageLog = compactLog
    else
        payload.MessageLog = {}
    end

    payload.clinicalFindings = BuildClinicalFindings(payload)
    return json.encode(payload)
end

function GetLocalServerId()
    return GetPlayerServerId(NetworkGetPlayerIndexFromPed(PlayerPedId()))
end

-- Skelly uses the local BodyDamage table; the medical UI historically read the
-- state bag, which can lag behind or miss nested wound arrays. Prefer local
-- data when inspecting yourself, and always normalize before returning.
function ResolvePlayerBodyDamage(playerId, syncLocal)
    playerId = tonumber(playerId)
    if not playerId then
        return nil
    end

    local myId = GetLocalServerId()
    if playerId == myId then
        EnsureBodyDamageStructure(BodyDamage)
        BodyDamage.ServerId = myId
        if syncLocal then
            SaveBodyDamage(myId, BodyDamage, true)
        end
        return BodyDamage
    end

    -- Ask the patient for their live BodyDamage. State bags alone are not reliable
    -- for large nested tables / rapid vital changes between clients.
    local serverStat = lib.callback.await('osp_ambulance:getPlayerBodyDamage', 2500, playerId)
    if type(serverStat) == 'table' then
        return EnsureBodyDamageStructure(serverStat) or serverStat
    end

    local ent = Player(playerId)
    local stat = ent.state.BodyDamage
    local timeout = GetGameTimer() + 1500
    while type(stat) ~= 'table' and GetGameTimer() < timeout do
        Wait(50)
        stat = ent.state.BodyDamage
    end

    if type(stat) == 'table' then
        return EnsureBodyDamageStructure(stat) or stat
    end

    return nil
end

-- Authoritative vitals for other clients (server-proxied). The server refreshes
-- the replicated state bag from this payload so monitors stay closer to truth.
lib.callback.register('osp_ambulance:getLocalBodyDamage', function()
    if not IsBodyDamageReady(BodyDamage) then
        return nil
    end

    local myId = GetLocalServerId()
    if myId and myId > 0 then
        BodyDamage.ServerId = myId
    end

    return deepCopyWithoutFunctions(BodyDamage)
end)

RegisterNetEvent('osp_ambulance:syncBodyDamageState', function()
    if not IsBodyDamageReady(BodyDamage) then return end
    local myId = GetLocalServerId()
    if not myId or myId <= 0 then return end
    BodyDamage.ServerId = myId
    SaveBodyDamage(myId, BodyDamage, true)
end)

local function CoordsToVec3(coords)
    if not coords then return nil end

    local coordType = type(coords)
    if coordType == 'vector3' then
        return coords
    end
    if coordType == 'vector4' then
        return vector3(coords.x, coords.y, coords.z)
    end
    if coordType == 'table' then
        local nested = coords.coords
        if nested then
            return CoordsToVec3(nested)
        end

        local x = tonumber(coords.x or coords[1])
        local y = tonumber(coords.y or coords[2])
        local z = tonumber(coords.z or coords[3])
        if x and y and z then
            return vector3(x, y, z)
        end
    end

    return nil
end

function TargetingBoxZone(name, coords, x, y, z, ...)
    local options = {...}
    local vec = CoordsToVec3(coords)
    if not vec then return end

    local id
    if Config.UseOxTarget then
        id = exports.ox_target:addBoxZone({
            coords = vec,
            size = vec3(x, y, z),
            rotation = 0,
            debug = false,
            drawSprite = true,
            options = options
        })
    else
        exports[Config.TargetName]:AddBoxZone(name, vec, x, y, {
            name = name,
            heading = 0,
            debugPoly = false,
            minZ = vec.z - z,
            maxZ = vec.z + z,
        }, {
            options = options,
            distance = 1.5
        })
    end
    return id
end

function TargetingEntityZone(entity, ...)
    local options = {...}
    local id = exports[Config.TargetName]:AddEntityZone(entity, entity, {
        name = entity,
        heading = GetEntityHeading(entity),
        debugPoly = false,
    }, {
        options = options,
        distance = 4.0
    })
    return id
end

function TargetEntity(entity, ...)
    local options = {...}
    if Config.UseOxTarget then
        exports.ox_target:addLocalEntity(entity, options)
    else
        exports[Config.TargetName]:AddTargetEntity(entity, {
            options = options,
            distance = 4.0
        })
    end
end

function TargetModel(entity, ...)
    local options = {...}
    if Config.UseOxTarget then
        exports.ox_target:addModel(entity, options)
    else
        exports[Config.TargetName]:AddTargetModel(entity, {
            options = options,
            distance = 4.0
        })
    end
end

function registerContext(data)
    lib.registerContext({
        id = data.id,
        title = data.title,
        options = data.options,
        menu = data.menu,
    })
end

function showContext(id)
    lib.showContext(id)
end


function RemoveTargetZone(entity)
    if Config.UseOxTarget then
        exports.ox_target:removeLocalEntity(entity, entity)
    else
        exports[Config.TargetName]:RemoveTargetEntity(entity)
    end
end

oxTargetIds = {}
jobTargetZoneNames = {}
jobLibZones = {}
hospitalBlips = {}
bedTargetZoneIds = {}
bedTargetZoneNames = {}
bedLibZones = {}
bloodChairZoneNames = {}

function RemoveZone(entity)
    if Config.UseOxTarget then
        exports.ox_target:removeZone(entity)
    else
        exports[Config.TargetName]:RemoveZone(entity)
    end
end

local function RemoveLibZoneList(list)
    for _, zone in pairs(list or {}) do
        if zone and zone.remove then
            zone:remove()
        end
    end
end

local function AddHospitalTargetZone(name, coords, x, y, z, option)
    local id = TargetingBoxZone(name, coords, x, y, z, option)

    if Config.UseOxTarget then
        if id then
            oxTargetIds[#oxTargetIds + 1] = id
        end
    else
        jobTargetZoneNames[#jobTargetZoneNames + 1] = name
    end

    return id
end

local function TrackBedTargetZone(name, coords, x, y, z, option)
    local id = TargetingBoxZone(name, coords, x, y, z, option)

    if Config.UseOxTarget then
        if id then
            bedTargetZoneIds[#bedTargetZoneIds + 1] = id
        end
    else
        bedTargetZoneNames[#bedTargetZoneNames + 1] = name
    end

    return id
end

function SendTextMessage(msgtitle, msg, time, type2)
    if Config.UseOxNotif then
        lib.notify({
            title = msgtitle,
            description = msg,
            type = type2,
            position = 'top-right',
        })
    else
        if GetActiveFramework() == 'qb' then
            QBCore.Functions.Notify(msg, type2, time)
        elseif GetActiveFramework() == 'esx' then
            TriggerEvent('esx:showNotification', source, msg, type2, time)
        end
    end
end

RegisterNetEvent("osp_ambulance:SendTextMessage")
AddEventHandler("osp_ambulance:SendTextMessage", function(msgtitle, msg, time, type)
    SendTextMessage(msgtitle, msg, time, type)
end)


function ProgressBar(msg, time, animdict, anim)
    if Config.UseRadialProgressBar then
        if lib.progressCircle({
            duration = time,
            position = 'bottom',
            useWhileDead = true,
            canCancel = false,
            disable = {
                car = true,
            },
            anim = {
                dict = animdict,
                clip = anim
            },
        }) then return true else return false end
    else
        if animdict then
            if lib.progressBar({
                duration = time,
                label = msg,
                useWhileDead = true,
                canCancel = false,
                disable = {
                    car = true,
                },
                anim = {
                    dict = animdict,
                    clip = anim
                },
            }) then return true else return false end
        else
            if lib.progressBar({
                duration = time,
                label = msg,
                useWhileDead = true,
                canCancel = false,
                disable = {
                    car = true,
                },
            }) then return true else return false end
        end
    end
end



function drawtext3d(coordsx, coordsy, coordsz, text)
    local onScreen,_x,_y=World3dToScreen2d(coordsx, coordsy, coordsz)
    local px,py,pz=table.unpack(GetGameplayCamCoords())

    SetTextScale(0.25, 0.25)
    SetTextFont(4)
    SetTextProportional(1)
    SetTextColour(255, 255, 255, 215)
    SetTextEntry("STRING")
    SetTextCentre(1)
    AddTextComponentString(text)
    DrawText(_x,_y)
    local factor = string.len(text) / 270
    DrawRect(_x, _y + 0.008, 0.008 + factor, 0.03, 0, 0, 0, 0)
end

function GetDamagingWeapon(ped)
    for k, v in pairs(Config.Weapons) do
        if HasPedBeenDamagedByWeapon(ped, k, 0) then
            return v
        end
    end
    return nil
end

function SetVehicleExtras(veh, table)
    for k,v in pairs(table) do
        SetVehicleExtra(veh, k, v)
    end
end

function DebugPrint(...)
    if Config.Debug then
        print(...)
    end
end

stretcherDebug = false
function stretcherDebug(...)
    if Config.Debug or stretcherDebug then
        print('[osp_ambulance:stretcher]', ...)
    end
end

-- Override this to integrate a custom dispatch system.
-- Built-in adapters live in integrations/dispatch/* and are selected via Config.Dispatch.
function TriggerDispatchAlert(coords, message)
    local tool = GetEnsuredDispatchTool()
    local dispatch = Dispatch[tool]

    if dispatch and dispatch.alert then
        dispatch.alert(coords, message)
        return true
    end

    if tool ~= 'default' and Dispatch['default'] and Dispatch['default'].alert then
        Dispatch['default'].alert(coords, message)
        return true
    end

    return false
end

-- Single entry point for EMS notify (auto on down / manual G).
-- AutomaticAmbulanceAlert only affects automatic calls; manual always works once per down.
function RequestEmsAlert(isAutomatic)
    if emsNotified then
        return false
    end

    if isAutomatic and not Config.AutomaticAmbulanceAlert then
        return false
    end

    local lang = GetLang()
    local message = lang and lang.info and lang.info.civ_down or 'Civilian Down'
    TriggerDispatchAlert(GetEntityCoords(PlayerPedId()), message)
    emsNotified = true
    SendNUIMessage({
        emsnotif = 2,
    })
    return true
end

local nuiAlertSounds = {
    codeblue = true,
    incoming = true,
}

local nuiAlertLastPlay = {}

function TriggerNuiAlertSound(sound, coords, distance)
    if not nuiAlertSounds[sound] then
        return
    end

    local now = GetGameTimer()
    if nuiAlertLastPlay[sound] and (now - nuiAlertLastPlay[sound]) < 500 then
        return
    end

    local range = distance or Config.IncomingScreenSoundRange or 50.0
    local pedCoords = GetEntityCoords(PlayerPedId())
    if #(pedCoords - coords) > range then
        return
    end

    nuiAlertLastPlay[sound] = now
    SendNUIMessage({
        action = 'playAlertSound',
        sound = sound,
        volume = 1.0,
    })
end

function StopNuiAlertSound(sound)
    if sound then
        nuiAlertLastPlay[sound] = nil
        SendNUIMessage({
            action = 'stopAlertSound',
            sound = sound,
        })
        return
    end

    nuiAlertLastPlay = {}
    SendNUIMessage({
        action = 'stopAlertSound',
    })
end

function TriggerSound(sound, coords, distance)
    TriggerNuiAlertSound(sound, coords, distance)
    if Config.UseXsound then
        return
    end
    while not RequestScriptAudioBank('audiodirectory/ambulance_sounds', false) do Wait(0) end
    local soundId = GetSoundId()
    PlaySoundFromCoord(soundId, sound, coords, 'ambulance_soundset', false, distance)
    soundTable[soundId] = sound
    CreateThread(function()
        while not HasSoundFinished(soundId) do Wait(100) end
        StopSound(soundId)
        ReleaseSoundId(soundId)
        soundTable[soundId] = nil
	end)
    return soundId
end

RegisterCommand("clearsounds", function(source, args, rawCommand)
    for k,v in pairs(soundTable) do
        StopSound(k)
        ReleaseSoundId(k)
        soundTable[k] = nil
    end
    StopNuiAlertSound()
end, false)






-- CreateThread(function()
--     local sleep = 2000
--     while true do
--         if BodyDamage.bInChair then
--             sleep = 1
--             if IsControlJustPressed(0, 38) then
--                 TriggerEvent('osp_ambulance:getOutBloodChair')
--             end
--         else
--             sleep = 2000
--         end
--         Wait(sleep)
--     end
-- end)





local cprMinigameResult = nil
local cprMinigameActive = false

local nuiMinigameResult = nil
local nuiMinigameActive = false
local nuiMinigameKind = nil -- 'cpr' | 'bandage' | ...

RegisterNUICallback('CPRMiniGameResult', function(result, cb)
    cprMinigameActive = false
    cprMinigameResult = result
    cb('ok')
end)

RegisterNUICallback('BandageMiniGameResult', function(result, cb)
    nuiMinigameActive = false
    nuiMinigameKind = nil
    nuiMinigameResult = result
    SetNuiFocus(false, false)
    cb('ok')
end)

RegisterNUICallback('QuickClotMiniGameResult', function(result, cb)
    nuiMinigameActive = false
    nuiMinigameKind = nil
    nuiMinigameResult = result
    SetNuiFocus(false, false)
    cb('ok')
end)

RegisterNUICallback('SewingMiniGameResult', function(result, cb)
    nuiMinigameActive = false
    nuiMinigameKind = nil
    nuiMinigameResult = result
    SetNuiFocus(false, false)
    cb('ok')
end)


function runNuiMinigame(kind, payload, opts)
    opts = opts or {}
    nuiMinigameResult = nil
    nuiMinigameActive = true
    nuiMinigameKind = kind

    Wait(50)
    if opts.cursor then
        SetNuiFocus(true, true)
    end
    SendNUIMessage(payload)
    Wait(50)

    local timeoutAt = GetGameTimer() + 120000
    while nuiMinigameResult == nil do
        if GetGameTimer() > timeoutAt then
            print(('[osp_ambulance] NUI minigame "%s" timed out'):format(tostring(kind)))
            SendNUIMessage({ type = kind .. 'Hide' })
            nuiMinigameActive = false
            nuiMinigameKind = nil
            if opts.cursor then
                SetNuiFocus(false, false)
            end
            return false
        end
        Wait(0)
    end

    nuiMinigameActive = false
    nuiMinigameKind = nil
    if opts.cursor then
        SetNuiFocus(false, false)
    end
    local result = nuiMinigameResult
    nuiMinigameResult = nil
    return result and result.success == true
end

RegisterCommand('+interact', function()
    if BodyDamage and BodyDamage.bInChair then
        TriggerEvent('osp_ambulance:getOutBloodChair')
        return
    end

    if isInHospitalBed and canLeaveBed then
        removeTextUi()
        LeaveBed()
        return
    end

    if cprMinigameActive then
        SendNUIMessage({ type = 'cprKey', action = 'press' })
        return
    end
end, false)

RegisterCommand('-interact', function()
    if cprMinigameActive then
        SendNUIMessage({ type = 'cprKey', action = 'release' })
    end
end, false)

local function abortActiveMinigame()
    if cprMinigameActive then
        SendNUIMessage({ type = 'cprKey', action = 'abort' })
        return
    end
    if nuiMinigameActive and nuiMinigameKind then
        SendNUIMessage({ type = nuiMinigameKind .. 'Key', action = 'abort' })
    end
end

RegisterCommand('cancel', abortActiveMinigame, false)
RegisterCommand('cancel_alt', abortActiveMinigame, false)

RegisterKeyMapping('+interact', 'Interact', 'keyboard', 'E')
RegisterKeyMapping('cancel', 'Cancel', 'keyboard', 'ESCAPE')
RegisterKeyMapping('cancel_alt', 'Cancel (ALT)', 'keyboard', 'BACK')

local CPR_HELPUP_DICT_A = 'mini@cpr@char_a@cpr_str'
local CPR_HELPUP_DICT_B = 'mini@cpr@char_b@cpr_str'
local CPR_HELPUP_ANIM = 'cpr_success'

local function playCprHelpUp(otherServerId, isMedic)
    local ped = PlayerPedId()
    local otherPed = GetPlayerPed(GetPlayerFromServerId(otherServerId))
    local anchorPed = (isMedic and DoesEntityExist(otherPed)) and otherPed or ped
    local coords = GetEntityCoords(anchorPed)
    local heading = GetEntityHeading(anchorPed)

    -- Synced scene origin is the patient; medic snaps to the same point so offsets match
    if isMedic then
        SetEntityCoordsNoOffset(ped, coords.x, coords.y, coords.z, false, false, false)
        SetEntityHeading(ped, heading)
    end

    lib.requestAnimDict(CPR_HELPUP_DICT_A, 1000)
    lib.requestAnimDict(CPR_HELPUP_DICT_B, 1000)

    ClearPedTasks(ped)

    local dict = isMedic and CPR_HELPUP_DICT_A or CPR_HELPUP_DICT_B
    -- Each client only adds itself; both use the same scene origin so the pair stays synced
    local scene = NetworkCreateSynchronisedScene(coords.x, coords.y, coords.z-1.0, 0.0, 0.0, heading, 2, false, false, 1.0, 0.0, 1.0)
    NetworkAddPedToSynchronisedScene(ped, scene, dict, CPR_HELPUP_ANIM, 8.0, -8.0, 13, 16, 1148846080, 0)
    NetworkStartSynchronisedScene(scene)

    local duration = (GetAnimDuration(dict, CPR_HELPUP_ANIM) or 0.0) * 1000
    if duration < 1000 then
        duration = 25000
    end
    Wait(duration)

    NetworkStopSynchronisedScene(scene)
    ClearPedTasks(ped)
end

RegisterNetEvent('osp_ambulance:CprHelpUpCl', function(otherServerId, isMedic)
    playCprHelpUp(otherServerId, isMedic)
end)

function CPRFunction(data)
    Wait(500)
    local ent = Player(data.PlayerId)
    local stat = ent.state.BodyDamage
    if not stat.isDead then
        SendTextMessage(GetLang().interactions.medicalHeader, 'The player is not dead!', 3000, "error")
        return
    end
    if IsInsurvivable(stat) then
        SendTextMessage(GetLang().interactions.medicalHeader, GetLang().error.insurvivable_injury, 5000, "error")
        return
    end
    local performingcpr = true
    local startingPulse = stat.Pulse
    local startingState = stat.cardiacState
    local revived = false

    local cprAnimDict = 'missheistfbi3b_ig8_2'
    local cprAnimName = 'cpr_loop_paramedic'
    local cprTimeCycle = 60*1000


    -- Teleport player to a relative position to target player
    local targetPed = GetPlayerPed(GetPlayerFromServerId(data.PlayerId))
    local targetHeading = GetEntityHeading(targetPed)
    local targetCoords = GetOffsetFromEntityInWorldCoords(targetPed, vector3(0.55, -0.35, 0.0))
    SetEntityCoords(PlayerPedId(), targetCoords)
    SetEntityHeading(PlayerPedId(), targetHeading+90)


    lib.requestAnimDict(cprAnimDict, 1000)

    if stat.Pulse == 0 or stat.isDead then
    -- if true then
        stat.Pulse = 60
        stat.cardiacState = 'NSR'
        stat.beingPerformedCPROn = true
        SaveBodyDamage(data.PlayerId, stat, true)

        -- Trigger CPR Minigame (no NUI focus — poll E until the minigame ends)
        cprMinigameResult = nil
        cprMinigameActive = true
        SendNUIMessage({
            type = 'cpr',
            duration = cprTimeCycle/1000,
            PlayerId = data.PlayerId,
        })

        CreateThread(function()
            local wasPressed = false
            while cprMinigameActive do
                -- E is INPUT_PICKUP (38) and INPUT_TALK (46); KeyMapping often leaves the native control disabled
                local pressed = IsControlPressed(0, 38) or IsDisabledControlPressed(0, 38)
                    or IsControlPressed(0, 46) or IsDisabledControlPressed(0, 46)
                if pressed and not wasPressed then
                    SendNUIMessage({ type = 'cprKey', action = 'press' })
                elseif not pressed and wasPressed then
                    SendNUIMessage({ type = 'cprKey', action = 'release' })
                end
                wasPressed = pressed
                Wait(0)
            end
            if wasPressed then
                SendNUIMessage({ type = 'cprKey', action = 'release' })
            end
        end)
    end

    CreateThread(function()
        while performingcpr do
            if not IsEntityPlayingAnim(PlayerPedId(), cprAnimDict, cprAnimName, 3) then
                TaskPlayAnim(PlayerPedId(), cprAnimDict, cprAnimName, 8.0, -8.0, -1, 1, 0, false, false, false)
            end

            -- Minigame finished — resolve outcome and stop the anim loop
            if cprMinigameResult ~= nil then
                cprMinigameActive = false
                local result = cprMinigameResult
                cprMinigameResult = nil

                local ent = Player(data.PlayerId)
                local stat = ent.state.BodyDamage
                local cprStatus = 'fail'

                if result.success then
                    if result.avgBpm and result.avgBpm > 90 and result.enoughValid then
                        local chance = math.random(1, 100)
                        if chance < 50 then
                            cprStatus = 'shockable'
                        else
                            cprStatus = 'success'
                        end
                    end
                end

                -- if not ProgressBar('Performing CPR', cprTimeCycle) then return end

                if cprStatus == 'success' then
                    SendTextMessage(GetLang().interactions.medicalHeader, 'Patient is showing signs of improvement!', 2000, "success")
                    revived = true
                elseif cprStatus == 'shockable' then
                    -- shockable rythm
                    SendTextMessage(GetLang().interactions.medicalHeader, 'Patient has gotten a shockable rythm!', 2000, "success")
                    table.insert(stat.MessageLog, GetLang().vitals.cpr_was_performed_until..' | '.. time)

                    stat.shockableRythm = true
                elseif cprStatus == 'fail' then
                    -- Add a random torso wound during unsuccessful CPR attempt
                    if stat and stat.BodyPartDamage and stat.BodyPartDamage.Wounds and stat.BodyPartDamage.Wounds['Torso'] then
                        local possibleChestWounds = {"contusion", "crush", "abrasion"}
                        local woundType = possibleChestWounds[math.random(1, #possibleChestWounds)]
                        table.insert(stat.BodyPartDamage.Wounds['Torso'], woundType)
                        table.insert(stat.MessageLog, "Wound inflicted by CPR: "..woundType ..' | '.. time)
                    end
                    SendTextMessage(GetLang().interactions.medicalHeader, 'Patient has not improved, continue CPR!', 2000, "success")
                    table.insert(stat.MessageLog, GetLang().vitals.cpr_was_performed_until..' | '.. time)

                    -- Reopen UI
                    SetNuiFocus(true, true)
                    SendNUIMessage(
                        {
                            display = true,
                            uiStyle = Config.MedicalMenuStyle,
                            autoTriage = Config.AutoTriage,
                            damageStatus = json.encode(stat),
                        }
                    )
                end

                stat.beingPerformedCPROn = false
                performingcpr = false
                SaveBodyDamage(data.PlayerId, stat, true)

                if cprStatus == 'success' then
                    TriggerServerEvent('osp_ambulance:CprHelpUpSv', data.PlayerId)
                else
                    ClearPedTasks(PlayerPedId())
                end
                break
            end

            Wait(500)
        end
    end)
end


local keyCooldown = 0
function DeadMovement(ped) -- Crawl
    loadAnimDict("move_injured_ground")
    if IsDisabledControlPressed(0, 34) then
        SetEntityHeading(ped, GetEntityHeading(ped)+0.25 )
    elseif IsDisabledControlPressed(0, 35) then
        SetEntityHeading(ped, GetEntityHeading(ped)-0.25 )
    end

    if IsDisabledControlJustPressed(0, 32) then
        -- Wait(1000)
        ClearPedTasks(ped)
        TaskPlayAnimAdvanced(ped, "move_injured_ground", "front_loop", GetEntityCoords(ped), 1.0, 0.0, GetEntityHeading(ped), 1.0, 1.0, 1.0, 1, 1.0, 0, 0)
    elseif IsDisabledControlJustReleased(0, 32) then
        TaskPlayAnimAdvanced(ped, "move_injured_ground", "front_loop", GetEntityCoords(ped), 1.0, 0.0, GetEntityHeading(ped), 1.0, 1.0, 1.0, 46, 1.0, 0, 0)
    end
    if not IsEntityPlayingAnim(ped,  "move_injured_ground", "front_loop", 3) and not IsDisabledControlJustPressed(0, 32) then
        TaskPlayAnimAdvanced(ped, "move_injured_ground", "front_loop", GetEntityCoords(ped), 1.0, 0.0, GetEntityHeading(ped), 1.0, 1.0, 1.0, 46, 1.0, 0, 0)
    end
end

RegisterNetEvent("osp_ambulance:OnPlayerLastStand", function(bool)
    if bool then
        TriggerEvent('osp_ambulance:OnPlayerDead')
    end
    if Config.MutePlayerOnLastStand then
        TriggerServerEvent('osp_ambulance:mutePlayer', true)
    end
    DebugPrint('Setting laststand')
    SetLaststand(bool)
    if bool then
        RecorrectHospitalBedAfterDeathState()
    end
end)

RegisterNetEvent("osp_ambulance:OnPlayerDeath", function()
    TriggerEvent('osp_ambulance:OnPlayerDead')
    if Config.MutePlayerOnDeath then
        TriggerServerEvent('osp_ambulance:mutePlayer', true)
    end
    OnDeath()
    RecorrectHospitalBedAfterDeathState()
end)


RegisterNetEvent("osp_ambulance:OnPlayerDead")
AddEventHandler("osp_ambulance:OnPlayerDead", function()
    if GetActiveFramework() == 'esx' then
        TriggerServerEvent('osp_amblance:setDeathStatus', true)
        ESX.SetPlayerData('dead', true)
        if IsHandCuffed() then
            isHandCuffed = true
            TriggerEvent('esx_policejob:handcuff')
        end
    elseif GetActiveFramework() == 'qb' or GetActiveFramework() == 'qbox' then
        if IsHandCuffed() then
            isHandCuffed = true
            TriggerEvent('police:client:GetCuffed', -1)
        end
        TriggerEvent('police:client:DeEscort')
    end
    TriggerServerEvent('osp_ambulance:OnPlayerDead')

    -- GetPlayerData().dead = true
    -- You can use this event to do something when the player dies/is dead
end)

RegisterNetEvent("osp_ambulance:OnPlayerSpawn")
AddEventHandler("osp_ambulance:OnPlayerSpawn", function()
    -- exports['pma-voice']:toggleMutePlayer(0)
    if disableAllSystems() then
        NetworkResurrectLocalPlayer(GetEntityCoords(PlayerPedId()), 180.0, true, false)
    end
    -- NetworkResurrectLocalPlayer(GetEntityCoords(PlayerPedId()), 180.0, true, false)
    if GetActiveFramework() == 'esx' then
        ESX.SetPlayerData('dead', false)
        -- TriggerServerEvent('esx:onPlayerSpawn')
        -- TriggerEvent('playerSpawned')
        TriggerServerEvent('osp_amblance:setDeathStatus', false)
        if isHandCuffed then
            isHandCuffed = false
            TriggerEvent('esx_policejob:handcuff')
        end
    elseif GetActiveFramework() == 'qb' or GetActiveFramework() == 'qbox' then
        if isHandCuffed then
            isHandCuffed = false
            TriggerEvent('police:client:GetCuffed', -1)
        end
    end
    TriggerServerEvent('osp_ambulance:OnPlayerSpawn')
    -- GetPlayerData().dead = false
    -- You can use this event to do something when the player spawns
end)

RegisterNetEvent('qb-clothing:client:openMenu', function()
    nodam = true
end)

RegisterNetEvent('qb-clothing:client:onMenuClose', function()
    nodam = false
end)

RegisterNetEvent('qb-clothing:loadPlayerSkin', function()
    nodam = false
    BodyDamage.clothesStripped = false
end)

RegisterNetEvent("osp_ambulance:appearanceEnter", function() -- Disable wounding when appearance is open (have been reported to be causing issues with the wound system)
    nodam = true
end)

RegisterNetEvent("osp_ambulance:appearanceExit", function() -- Enable wounding when appearance is closed
    nodam = false
end)

function disableAllSystems()
    if inGamePlay() then -- in integrations/ingame/client.lua
        return true
    end
    
    if nodam or BodyDamage == false or GetPlayerInvincible(GetPlayerPed(-1)) then
        return true
    end
    return false
end

-- Override to add custom insurvivable injury logic (weapon hashes, jobs, extra wound checks, etc).
-- context.weaponHash, context.weaponClass, context.bodyPart, context.fatal, context.source
-- Return true  = force insurvivable (skip laststand when Config.InsurvivableInjuries.skipLaststand)
-- Return false = force survivable (ignore config rules for this evaluation)
-- Return nil   = use Config.InsurvivableInjuries.rules
function CustomInsurvivableCheck(bodyDamage, context)
    return nil
end

function RejectInsurvivableTreatment(playerId)
    local stat
    if ResolvePlayerBodyDamage then
        stat = ResolvePlayerBodyDamage(playerId)
    end
    if not stat and playerId then
        local ent = Player(playerId)
        stat = ent and ent.state and ent.state.BodyDamage
    end
    if stat and stat.isDead and IsInsurvivable and IsInsurvivable(stat) then
        SendTextMessage(GetLang().interactions.medicalHeader, GetLang().error.insurvivable_injury, 5000, "error")
        return true
    end
    return false
end

function disabledControls()
    DisableAllControlActions(0)
    EnableControlAction(0, 1, true) -- LookLeftRight
    EnableControlAction(0, 2, true) -- LookUpDown
    EnableControlAction(0, 245, true) -- T
    EnableControlAction(0, 38, true) -- A
    EnableControlAction(0, 0, true)
    EnableControlAction(0, 322, true) -- ESC
    EnableControlAction(0, 213, true) -- HOME
    EnableControlAction(0, 249, true) -- N
    EnableControlAction(0, 46, true) -- E
    EnableControlAction(0, 47, true) -- G
end

function isPedMovingCheck(ped)
    local timeout = 5000
    while GetEntitySpeed(ped) > 0.5 or IsPedRagdoll(ped) do
        Wait(10)
        timeout = timeout - 10
        if timeout <= 0 then
            break
        end
    end
end


function GetPlayers()
    local maxplayers = GetConvarInt('sv_maxclients', 255) - 1
    -- local maxplayers = 255
    local players = {}

    for i=0, maxplayers do
        if NetworkIsPlayerActive(i) then
            table.insert(players, i)
        end
    end
    return players
end

-- function GetPlayers()
--     local players = {}
--     for _, playerId in pairs(GetActivePlayers()) do
--         table.insert(players, playerId)
--     end
--     return players
-- end


function IsInjuryCausingLimp()
    if not IsBodyDamageReady(BodyDamage) then
        return false
    end
    for k,x in pairs(Config.Wounds) do
        for _,v in pairs(BodyDamage.BodyPartDamage.Wounds["Lleg"]) do
            if k == v then
                if x.causeLimping then
                    return true
                end
            end
        end
        for _,v in pairs(BodyDamage.BodyPartDamage.Wounds["Rleg"]) do
            if k == v then
                if x.causeLimping then
                    return true
                end
            end
        end
    end
    if BodyDamage.BodyPartDamage.Fractures["Rleg"] or BodyDamage.BodyPartDamage.Fractures["Lleg"] then
        return true
    end
    return false
end


SlowEffect1 = false
SlowEffect2 = false
SlowEffect3 = false

local isinjuried = false


function ProcessRunStuff()
    if not IsBodyDamageReady(BodyDamage) then
        return
    end
    if IsInjuryCausingLimp() then
        isinjuried = true
        RequestAnimSet("move_m@injured")
        while not HasAnimSetLoaded("move_m@injured") do
            Wait(0)
        end
        SetPedMovementClipset(PlayerPedId(), "move_m@injured", 1)
        SetPlayerSprint(PlayerId(), false)
    else
        if isinjuried then
            ResetPedMovementClipset(PlayerPedId(), 0.0)
            SetPlayerSprint(PlayerId(), true)
            isinjuried = false
        end
    end
    if Config.UseMovementRate then
        local rlegDmg = BodyDamage.BodyPartDamage.DamageType["Rleg"] or 0
        local llegDmg = BodyDamage.BodyPartDamage.DamageType["Lleg"] or 0
        if rlegDmg > 0 or llegDmg > 0 then
            SlowEffect1 = true
        elseif rlegDmg > 1 or llegDmg > 1 then
            SlowEffect2 = true
        elseif (rlegDmg > 2 or llegDmg > 2) or (BodyDamage.BodyPartDamage.Fractures["Rleg"] or BodyDamage.BodyPartDamage.Fractures["Lleg"]) then
            SlowEffect2 = true
        else
            SlowEffect1 = false
            SlowEffect2 = false
            SlowEffect3 = false
            SetRunSprintMultiplierForPlayer(PlayerId(), 1.0)
            SetPedMoveRateOverride(PlayerPedId(), 1.0)
        end
    end
end

function CauseFractureStaggering() -- Will be triggered every second
    if not IsBodyDamageReady(BodyDamage) then
        return
    end
    local ped = PlayerPedId()
    for k, x in pairs(BodyDamage.BodyPartDamage.Fractures) do
        if (k == "Rleg" or k == "Lleg") and (x == true or x == 'xrayed') then
            for _, v in pairs(Config.Fractures) do
                if v.bone == k and IsPedRunning(ped) then
                    SetPedToRagdoll(ped, 1500, 2000, 3, true, true, false)
                    ShakeGameplayCam('SMALL_EXPLOSION_SHAKE', GetClientCamShake(Config.CameraShakeIntensity))
                end
            end
        end
    end
end

function LockSteering() -- Will be triggered every 15 seconds
    if not IsBodyDamageReady(BodyDamage) then
        return
    end
    local ped = PlayerPedId()
    if (BodyDamage.BodyPartDamage.Fractures["Rarm"] == true or BodyDamage.BodyPartDamage.Fractures["Larm"] == true) or (BodyDamage.BodyPartDamage.Fractures["Rarm"] == 'xrayed' or BodyDamage.BodyPartDamage.Fractures["Larm"] == 'xrayed') then
        local continue = false
        for k,v in pairs(Config.Fractures) do
            if v.bone == 'Rarm' or v.bone == 'Larm' then
                if v.lockSteering then
                    continue = true
                end
            end
        end
        if not continue then return end

        local chance = math.random(1, 2)
        if chance > 1 then
            local timer = 500
            CreateThread(function()
                while true do
                    if IsPedInAnyVehicle(ped, true) then
                        DisableControlAction(0, 63, true)
                        DisableControlAction(0, 64, true)
                        DisableAllControlActions(0)
                        EnableControlAction(0, 1, true) -- LookLeftRight
                        EnableControlAction(0, 2, true) -- LookUpDown
                        EnableControlAction(0, 245, true) -- T
                        EnableControlAction(0, 38, true) -- A
                        EnableControlAction(0, 0, true)
                        EnableControlAction(0, 322, true) -- ESC
                        EnableControlAction(0, 213, true) -- HOME
                        EnableControlAction(0, 249, true) -- N
                        EnableControlAction(0, 46, true) -- E
                        EnableControlAction(0, 47, true) -- G
                        EnableControlAction(0, 71, true) -- E
                        EnableControlAction(0, 72, true) -- G
                    end
                    if IsPlayerFreeAiming(PlayerId()) then
                        DisablePlayerFiring(PlayerId(), true) -- Disable weapon firing
                    end
                    timer = timer - 1
                    Wait(1)
                    if timer <= 0 then
                        EnableAllControlActions(0)
                        EnableControlAction(0, 63, true)
                        EnableControlAction(0, 64, true)
                        DisablePlayerFiring(PlayerId(), false)
                        break
                    end
                end
            end)
        end
    end

end

function HasAccess(feature)
    return ConfigLoader.HasAccess(Config, PlayerJob and PlayerJob.name, feature, onDuty == true)
end

function JobHasAccess(feature)
    return ConfigLoader.JobHasAccess(Config, PlayerJob and PlayerJob.name, feature)
end

function IsEmsStaff()
    return ConfigLoader.IsEmsJob(Config, PlayerJob and PlayerJob.name)
end

function IsAuthorized()
    return IsEmsStaff() and onDuty == true
end

local MEDICAL_MENU_ACCESS_FEATURES = {
    'cpr',
    'bodybag',
    'revivekit',
    'transportation',
    'cast',
    'splint',
    'quickChecks',
    'castsaw',
    'stripclothes',
}

-- Treatment-tab actions follow the job profile. Duty is only for hospital facilities.
function HasMedicalActionAccess(feature)
    return JobHasAccess(feature)
end

function GetMedicalMenuJobAccess()
    local access = {}
    local jobs = Config and Config.Jobs
    for i = 1, #MEDICAL_MENU_ACCESS_FEATURES do
        local feature = MEDICAL_MENU_ACCESS_FEATURES[i]
        if type(jobs) ~= 'table' then
            access[feature] = true
        else
            access[feature] = HasMedicalActionAccess(feature) == true
        end
    end
    return access
end

signPoly = {}
stashPoly = {}
shopPoly = {}
roofPoly = {}
mainPoly = {}
elevatorPoly = {}
bloodPoly = {}
analysisPoly = {}
function ReloadJobInteractions()
    if Config.UseTarget then
        if Config.UseOxTarget then
            for _, id in pairs(oxTargetIds) do
                if id then
                    RemoveZone(id)
                end
            end
            oxTargetIds = {}
        else
            for _, name in pairs(jobTargetZoneNames) do
                RemoveZone(name)
            end
            jobTargetZoneNames = {}
        end
    else
        RemoveLibZoneList(signPoly)
        RemoveLibZoneList(stashPoly)
        RemoveLibZoneList(shopPoly)
        RemoveLibZoneList(roofPoly)
        RemoveLibZoneList(mainPoly)
        RemoveLibZoneList(elevatorPoly)
        RemoveLibZoneList(bloodPoly)
        signPoly = {}
        stashPoly = {}
        shopPoly = {}
        roofPoly = {}
        mainPoly = {}
        elevatorPoly = {}
        bloodPoly = {}
    end

    RemoveLibZoneList(jobLibZones)
    jobLibZones = {}

    if type(Config.Hospitals) ~= 'table' then
        return
    end

    CreateThread(function()
        while not PlayerJob do
            Wait(100)
        end

        for id, hospital in pairs(Config.Hospitals) do
            if Config.UseGarageSystem then
                for k,v in pairs(hospital["vehicle"] or {}) do
                    local function onEnter(self)
                        if HasAccess('vehicles') then
                            textUi(GetLang().text.veh_button)
                            EMSVehicle(k, id)
                        end
                    end

                    local function onExit(self)
                        CheckVehicle = false
                        removeTextUi()
                    end

                    jobLibZones[#jobLibZones + 1] = lib.zones.box({
                        coords = vec3(v.x, v.y, v.z),
                        name = "hospital-vehicle-"..id.."-"..k,
                        size = vec3(5.0, 5.0, 5.0),
                        rotation = 70,
                        debug = false,
                        inside = inside,
                        onEnter = onEnter,
                        onExit = onExit
                    })
                end
            end

            for k, v in pairs(hospital["helicopter"] or {}) do
                local function onEnter(self)
                    if HasAccess('helicopter') then
                        textUi(GetLang().text.heli_button)
                        EMSHelicopter(k, id)
                    end
                end

                local function onExit(self)
                    CheckHeli = false
                    removeTextUi()
                end

                jobLibZones[#jobLibZones + 1] = lib.zones.box({
                    coords = vec3(v.x, v.y, v.z),
                    name = "hospital-helicopter"..id.."-"..k,
                    size = vec3(5.0, 5.0, 5.0),
                    rotation = 70,
                    debug = false,
                    inside = inside,
                    onEnter = onEnter,
                    onExit = onExit
                })
            end



            for k, v in pairs(hospital["boss"] or {}) do
                local function inside(self)
                    if HasAccess('boss') and GetPlayerData().job.grade_name == 'boss' then
                        textUi('[E] Bossmenu')

                        if IsControlJustPressed(0, 38) then
                            TriggerEvent('esx_society:openBossMenu', PlayerJob.name, function(data, menu)
                                menu.close()
                            end, { wash = false })
                        end
                    end
                end

                local function onExit(self)
                    removeTextUi()
                end

                jobLibZones[#jobLibZones + 1] = lib.zones.box({
                    coords = vec3(v.x, v.y, v.z),
                    name = "hospital-boss-"..id.."-"..k,
                    size = vec3(1.5, 1.5, 1.5),
                    rotation = 20,
                    debug = false,
                    inside = inside,
                    onEnter = onEnter,
                    onExit = onExit
                })
            end

            for k, v in pairs(hospital["cloakroom"] or {}) do
                local function inside(self)
                    if HasAccess('cloakroom') then
                        textUi('[E] Cloakroom')
                        if IsControlJustPressed(0, 38) then
                            OpenCloakroom()
                        end
                    end
                end

                local function onExit(self)
                    removeTextUi()
                end

                jobLibZones[#jobLibZones + 1] = lib.zones.box({
                    coords = vec3(v.x, v.y, v.z),
                    name = "hospital-cloakroom-"..id.."-"..k,
                    size = vec3(1.5, 1.5, 1.5),
                    rotation = 20,
                    debug = false,
                    inside = inside,
                    onEnter = onEnter,
                    onExit = onExit
                })
            end
        end
    end)


    if Config.UseTarget then
        CreateThread(function()
            for id, hospital in pairs(Config.Hospitals) do
                if JobHasAccess('duty') then
                    for k, v in pairs(hospital["duty"] or {}) do
                        AddHospitalTargetZone("hospital-duty-"..id.."-"..k, v, 1.5,1,2,
                            {
                                type = "client",
                                event = "EMSToggle:Duty",
                                icon = "fa fa-clipboard",
                                label = GetLang().text.duty,
                                job = PlayerJob.name
                            }
                        )
                    end
                end
                if JobHasAccess('stash') then
                    for k, v in pairs(hospital["stash"] or {}) do
                        AddHospitalTargetZone("hospital-stash-"..id.."-"..k, v, 1,1,2,
                            {
                                type = "client",
                                event = "osp_ambulance:stash",
                                icon = "fa fa-hand",
                                label = GetLang().text.pstash,
                                job = PlayerJob.name
                            }
                        )
                    end
                end
                if JobHasAccess('shop') then
                    for k, v in pairs(hospital["shop"] or {}) do
                        AddHospitalTargetZone("hospital-shop-"..id.."-"..k, v, 1,1,2,
                            {
                                type = "client",
                                event = "osp_ambulance:shop",
                                icon = "fa fa-hand",
                                label = GetLang().text.store,
                                job = PlayerJob.name
                            }
                        )
                    end
                end
                if JobHasAccess('bloodstorage') then
                    for k, v in pairs(hospital["bloodstorage"] or {}) do
                        AddHospitalTargetZone("hospital-bloodstorage-"..id.."-"..k, v, 1,1,2,
                            {
                                type = "client",
                                event = "osp_ambulance:bloodstorage",
                                icon = "fa fa-hand",
                                label = GetLang().text.bloodstorage,
                                job = PlayerJob.name
                            }
                        )
                    end
                end
                if JobHasAccess('bloodanalysis') then
                    for k, v in pairs(hospital["bloodanalysis"] or {}) do
                        AddHospitalTargetZone("hospital-bloodanalysis-"..id.."-"..k, v, 1,1,2,
                            {
                                type = "client",
                                event = "osp_ambulance:analyseBlood",
                                icon = "fa fa-hand",
                                label = GetLang().text.bloodanalysis,
                                job = PlayerJob.name
                            }
                        )
                    end
                end

                if JobHasAccess('elevator') then
                    local elevators = GetHospitalElevators(id)

                    for e, elevator in ipairs(elevators) do
                        for k, v in ipairs(elevator.floors) do
                            if v and v.coords then
                                AddHospitalTargetZone("hospital-elevator-"..id.."-"..e.."-"..k, v.coords, 2,2,2,
                                    {
                                        type = "client",
                                        event = "osp_ambulance:elevator",
                                        hosID = id,
                                        elevator = e,
                                        floor = k,
                                        icon = "fa-solid fa-elevator",
                                        label = GetLang().text.elevator_button,
                                        job = PlayerJob.name
                                    }
                                )
                            end
                        end
                    end
                end
            end
        end)
    else
        CreateThread(function()
            for id, hospital in pairs(Config.Hospitals) do
                if JobHasAccess('duty') then
                    for k, v in pairs(hospital["duty"] or {}) do
                        local function inside(self)
                            if not onDuty then
                                textUi(GetLang().text.onduty_button)
                            else
                                textUi(GetLang().text.offduty_button)
                            end

                            if IsControlJustPressed(0, 38) then
                                TriggerEvent('EMSToggle:Duty')
                            end
                        end

                        local function onExit(self)
                            removeTextUi()
                        end

                        signPoly[#signPoly + 1] = lib.zones.box({
                            coords = vec3(v.x, v.y, v.z),
                            name = "hospital-sign-"..id.."-"..k,
                            size = vec3(1.5, 1.5, 1.5),
                            rotation = 20,
                            debug = false,
                            inside = inside,
                            onExit = onExit
                        })
                    end
                end


                if JobHasAccess('stash') then
                    for k, v in pairs(hospital["stash"] or {}) do

                        local function inside(self)
                            if HasAccess('stash') then
                                textUi(GetLang().text.pstash_button)

                                if IsControlJustPressed(0, 38) then
                                    TriggerEvent('osp_ambulance:stash')
                                end
                            end
                        end

                        local function onExit(self)
                            removeTextUi()
                        end

                        stashPoly[#stashPoly + 1] = lib.zones.box({
                            coords = vec3(v.x, v.y, v.z),
                            name = "hospital-stash-"..id.."-"..k,
                            size = vec3(1.5, 1.5, 1.5),
                            rotation = 20,
                            debug = false,
                            inside = inside,
                            onExit = onExit
                        })
                    end
                end

                if JobHasAccess('shop') then
                    for k, v in pairs(hospital["shop"] or {}) do

                        local function inside(self)
                            if HasAccess('shop') then
                                textUi(GetLang().text.store_button)

                                if IsControlJustPressed(0, 38) then
                                    TriggerEvent('osp_ambulance:shop')
                                end
                            end
                        end

                        local function onExit(self)
                            removeTextUi()
                        end

                        shopPoly[#shopPoly + 1] = lib.zones.box({
                            coords = vec3(v.x, v.y, v.z),
                            name = "hospital-shop-"..id.."-"..k,
                            size = vec3(1.5, 1.5, 1.5),
                            rotation = 70,
                            debug = false,
                            inside = inside,
                            onExit = onExit
                        })
                    end
                end

                if JobHasAccess('bloodstorage') then
                    for k, v in pairs(hospital["bloodstorage"] or {}) do

                        local function inside(self)
                            if HasAccess('bloodstorage') then
                                textUi(GetLang().text.bloodstorage_button)

                                if IsControlJustPressed(0, 38) then
                                    TriggerEvent('osp_ambulance:bloodstorage')
                                end
                            end
                        end

                        local function onExit(self)
                            removeTextUi()
                        end

                        bloodPoly[#bloodPoly + 1] = lib.zones.box({
                            coords = vec3(v.x, v.y, v.z),
                            name = "hospital-bloodstorage-"..id.."-"..k,
                            size = vec3(1.5, 1.5, 1.5),
                            rotation = 20,
                            debug = false,
                            inside = inside,
                            onExit = onExit
                        })
                    end
                end

                if JobHasAccess('bloodanalysis') then
                    for k, v in pairs(hospital["bloodanalysis"] or {}) do
                        local function inside(self)
                            if HasAccess('bloodanalysis') then
                                textUi(GetLang().text.bloodanalysis_button)

                                if IsControlJustPressed(0, 38) then
                                    TriggerEvent('osp_ambulance:analyseBlood')
                                end
                            end
                        end

                        local function onExit(self)
                            removeTextUi()
                        end

                        bloodPoly[#bloodPoly + 1] = lib.zones.box({
                            coords = vec3(v.x, v.y, v.z),
                            name = "hospital-bloodanalysis-"..id.."-"..k,
                            size = vec3(1.5, 1.5, 1.5),
                            rotation = 20,
                            debug = false,
                            inside = inside,
                            onExit = onExit
                        })
                    end
                end

                if JobHasAccess('elevator') then
                    local elevators = GetHospitalElevators(id)

                    for e, elevator in ipairs(elevators) do
                        for k, v in ipairs(elevator.floors) do
                            if v and v.coords then
                                local elevatorIndex = e
                                local floorIndex = k
                                local coords = v.coords

                                local function inside(self)
                                    textUi(GetLang().text.elevator_button)

                                    if IsControlJustPressed(0, 38) then
                                        TriggerEvent('osp_ambulance:elevator', { hosID = id, elevator = elevatorIndex, floor = floorIndex })
                                    end
                                end

                                local function onExit(self)
                                    removeTextUi()
                                end

                                elevatorPoly[#elevatorPoly + 1] = lib.zones.box({
                                    coords = vec3(coords.x, coords.y, coords.z),
                                    name = "hospital-elevator-"..id.."-"..e.."-"..k,
                                    size = vec3(2.0, 2.0, 2.0),
                                    rotation = 70,
                                    debug = false,
                                    inside = inside,
                                    onExit = onExit
                                })
                            end
                        end
                    end
                end
            end
        end)
    end
end
Wait(500)
ReloadJobInteractions()

ox_bloodChairIDs = {}
donationPoly = {}
chairIndex = 0

function ReloadBloodChairs(data) -- only feed data when updating a single chair
    local function RemoveOldZone(chairID, hosID)
        if Config.UseTarget then
            if Config.UseOxTarget then
                for _, name in pairs(ox_bloodChairIDs) do
                    RemoveZone(name)
                end
                ox_bloodChairIDs = {}
            else
                RemoveZone('hospital-donation-'..chairID..'-'..hosID)
            end
        else
            if #donationPoly > 0 then
                for k,v in pairs(donationPoly) do
                    v:remove()
                end
            end
        end
    end

    local function UpdateBloodChair(chairID, chair, hosID, donator)
        local lclPlayer = GetPlayerServerId(NetworkGetPlayerIndexFromPed(PlayerPedId()))
        local targetCoords = vector4(chair.coords.x, chair.coords.y, chair.coords.z - 0.5, chair.coords.w)

        if not chair.taken then
            -- Set chair target to donate zone
            if Config.UseTarget then
                chairIndex = chairIndex + 1

                local zoneName = "donation".. chairIndex
                local zoneId = TargetingBoxZone(zoneName, targetCoords, 2.3,2.3,1,
                    {
                        type = "client",
                        event = "osp_ambulance:getInBloodChair",
                        icon = "fa fa-hand-holding-droplet",
                        label = GetLang().text.donate_blood,
                        hospitalID = hosID,
                        chairID = chairID,
                        chair = chair,
                    }
                )
                if Config.UseOxTarget then
                    if zoneId then
                        ox_bloodChairIDs[#ox_bloodChairIDs+1] = zoneId
                    end
                else
                    bloodChairZoneNames[#bloodChairZoneNames+1] = zoneName
                end
            else
                local function inside(self)
                    textUi('[E] Donate Blood')
                    if IsControlJustPressed(0, 38) then
                        TriggerEvent('osp_ambulance:getInBloodChair', {chairID = chairID, chair = chair, hospitalID = hosID})
                    end
                end

                local function onExit(self)
                    removeTextUi()
                end

                donationPoly[#donationPoly + 1] = lib.zones.box({
                    coords = vec4(targetCoords.x, targetCoords.y, targetCoords.z, targetCoords.w),
                    name = "hospital-donation-"..hosID.."-"..chairID,
                    size = vec3(2, 2, 2),
                    rotation = 20,
                    debug = false,
                    inside = inside,
                    onEnter = onEnter,
                    onExit = onExit
                })
            end
        elseif not (donator == lclPlayer) then
            -- Set chair target to draw blood options
            if Config.UseTarget then
                chairIndex = chairIndex + 1

                local bloodZoneName = "donation-blood".. chairIndex
                local bloodZoneId = TargetingBoxZone(bloodZoneName, targetCoords, 2.3,2.3,1,
                    {
                        type = "client",
                        event = "osp_ambulance:drawBlood",
                        icon = "fa fa-hand-holding-droplet",
                        label = GetLang().text.draw_blood,
                        hospitalID = hosID,
                        chairID = chairID,
                        chair = chair,
                        donator = donator,
                    }
                )
                local sampleZoneName = "donation-sample".. chairIndex
                local sampleZoneId = TargetingBoxZone(sampleZoneName, targetCoords, 2.3,2.3,1,
                    {
                        type = "client",
                        event = "osp_ambulance:drawBloodsample",
                        icon = "fa fa-hand-holding-droplet",
                        label = GetLang().text.draw_blood_sample,
                        hospitalID = hosID,
                        chairID = chairID,
                        chair = chair,
                        donator = donator,
                    }
                )
                if Config.UseOxTarget then
                    if bloodZoneId then
                        ox_bloodChairIDs[#ox_bloodChairIDs+1] = bloodZoneId
                    end
                    if sampleZoneId then
                        ox_bloodChairIDs[#ox_bloodChairIDs+1] = sampleZoneId
                    end
                else
                    bloodChairZoneNames[#bloodChairZoneNames+1] = bloodZoneName
                    bloodChairZoneNames[#bloodChairZoneNames+1] = sampleZoneName
                end
            else
                CreateThread(function()
                    local coords = vector3(targetCoords.x, targetCoords.y, targetCoords.z)
                    while true do
                        local sleep = 1000
                        if #(coords - GetEntityCoords(PlayerPedId())) < 2 then
                            sleep = 0
                            drawtext3d(coords.x, coords.y, coords.z+0.3, GetLang().text.draw_blood)
                            drawtext3d(coords.x, coords.y, coords.z+0.2, GetLang().text.draw_blood_sample)

                            if IsControlJustPressed(0, Controls.Resolve(Config.drawBlood)) then
                                Wait(100)
                                TriggerEvent("osp_ambulance:drawBlood", {chairID = chairID, hospitalID = hosID, donator = donator})
                            elseif IsControlJustPressed(0, Controls.Resolve(Config.drawBloodSample)) then
                                Wait(100)
                                TriggerEvent("osp_ambulance:drawBloodsample", {chairID = chairID, hospitalID = hosID, donator = donator})
                            end
                        end
                        Wait(sleep)
                    end
                end)
            end
        end
    end

    if data then
        -- updating single chair on event trigger
        RemoveOldZone(data.id, data.hosID)
        UpdateBloodChair(data.id, data.chairInfo, data.hosID, data.donator)
    else
        -- Full rebuild from current Config so moved/added/removed chairs take effect.
        if Config.UseTarget then
            if Config.UseOxTarget then
                for _, id in pairs(ox_bloodChairIDs) do
                    if id then
                        RemoveZone(id)
                    end
                end
            else
                for _, name in pairs(bloodChairZoneNames) do
                    RemoveZone(name)
                end
            end
            ox_bloodChairIDs = {}
            bloodChairZoneNames = {}
        else
            RemoveLibZoneList(donationPoly)
            donationPoly = {}
        end
        chairIndex = 0

        for hosID, hospital in pairs(Config.Hospitals or {}) do
            for chairID, chair in pairs(hospital["donation"] or {}) do
                UpdateBloodChair(chairID, chair, hosID, nil)
            end
        end
    end
end
Wait(500)
ReloadBloodChairs()

RegisterNetEvent('hospital:client:SetDoctorCount', function(amount)
    doctorCount = amount
end)

function ReloadBedInteractions()
    for _, id in pairs(bedTargetZoneIds) do
        if id then
            RemoveZone(id)
        end
    end
    for _, name in pairs(bedTargetZoneNames) do
        RemoveZone(name)
    end
    RemoveLibZoneList(bedLibZones)
    bedTargetZoneIds = {}
    bedTargetZoneNames = {}
    bedLibZones = {}

    if type(Config.Hospitals) ~= 'table' then
        return
    end

    if Config.UseTarget then
        local bedIndex = 0
        local xrayIndex = 0

        for id, hospital in pairs(Config.Hospitals) do
            for _, v in pairs(hospital["beds"] or {}) do
                bedIndex = bedIndex + 1
                TrackBedTargetZone("beds".. bedIndex, v.coords, 2.3, 2.3, 1,
                    {
                        type = "client",
                        event = "osp_ambulance:beds",
                        icon = "fas fa-bed",
                        label = GetLang().update1.lay_in_bed,
                        hospitalID = id,
                    }
                )
            end
            for k, v in pairs(hospital["Xray"] or {}) do
                xrayIndex = xrayIndex + 1
                bedIndex = bedIndex + 1
                TrackBedTargetZone("beds".. bedIndex, v.bedcoords, 2.3, 2.3, 1,
                    {
                        type = "client",
                        event = "osp_ambulance:beds",
                        icon = "fas fa-bed",
                        label = GetLang().update1.lay_in_bed,
                        hospitalID = id,
                    }
                )
                TrackBedTargetZone("xrayMonitor".. xrayIndex, v.screencoords, 2.3, 2.3, 1,
                    {
                        type = "client",
                        event = "osp_ambulance:xray",
                        icon = "fa-solid fa-person-rays",
                        label = GetLang().text.start_xray,
                        xray = hospital["Xray"][k],
                        hospitalID = id,
                        xrayIndex = k,
                    }
                )
            end
        end
        return
    end

    for id, hospital in pairs(Config.Hospitals) do
        for k, v in pairs(hospital["beds"] or {}) do
            local function onEnter(self)
                if not isInHospitalBed then
                    textUi(GetLang().text.lie_bed)
                    CheckInControls("beds", id)
                end
            end

            local function onExit(self)
                listen = false
                removeTextUi()
            end

            bedLibZones[#bedLibZones+1] = lib.zones.box({
                coords = vec3(v.coords.x, v.coords.y, v.coords.z),
                name = "hospital-beds-"..id.."-"..k,
                size = vec3(2.5, 2.3, 2.3),
                rotation = -20,
                debug = false,
                inside = inside,
                onEnter = onEnter,
                onExit = onExit
            })
        end

        for k, v in pairs(hospital["Xray"] or {}) do
            local function onEnter(self)
                if not isInHospitalBed then
                    textUi(GetLang().text.lie_bed)
                    CheckInControls("beds", id)
                end
            end

            local function onExit(self)
                listen = false
                removeTextUi()
            end

            bedLibZones[#bedLibZones+1] = lib.zones.box({
                coords = vec3(v.bedcoords.x, v.bedcoords.y, v.bedcoords.z),
                name = "hospital-xray-beds-"..id.."-"..k,
                size = vec3(2.5, 2.3, 2.3),
                rotation = -20,
                debug = false,
                inside = inside,
                onEnter = onEnter,
                onExit = onExit
            })

            local function XonEnter(self)
                textUi('[E] Start X-RAY')
                CreateThread(function()
                    listen = true
                    while listen do
                        if IsControlJustPressed(0, 38) then
                            TriggerEvent('osp_ambulance:xray', {
                                xray = hospital["Xray"][k],
                                hospitalID = id,
                                xrayIndex = k,
                            })
                            listen = false
                        end
                        Wait(1)
                    end
                end)
            end

            local function XonExit(self)
                listen = false
                removeTextUi()
            end

            bedLibZones[#bedLibZones+1] = lib.zones.box({
                coords = vec3(v.screencoords.x, v.screencoords.y, v.screencoords.z),
                name = "xrayMonitor"..id.."-"..k,
                size = vec3(2.5, 2.3, 2.3),
                rotation = -20,
                debug = false,
                inside = inside,
                onEnter = XonEnter,
                onExit = XonExit
            })
        end
    end
end

CreateThread(function()
    ReloadBedInteractions()
end)

function SetupCheckInZone(hospitalId, index, coords)
    local function onEnter()
        textUi(GetLang().text.check_in)
        CheckInControls("checkin", hospitalId)
    end

    local function onExit()
        checkInZoneActive = false
        removeTextUi()
    end

    checkInPoly[#checkInPoly + 1] = lib.zones.box({
        coords = vec3(coords.x, coords.y, coords.z),
        name = 'hospital-checkin-npc-' .. hospitalId .. '-' .. index,
        size = vec3(3.5, 3.5, 2.0),
        rotation = coords.w or 0,
        debug = false,
        onEnter = onEnter,
        onExit = onExit,
    })
end

function ClearCheckInZones()
    RemoveLibZoneList(checkInPoly)
    checkInPoly = {}
end

RegisterNUICallback('GetLang', function(_, cb)
    SendNUIMessage({
        type = "lang",
        translations = json.encode(GetLang())
    })
    if cb then cb({ ok = true }) end
end)

CreateThread(function()
    SetTimeout(3000, function()
        if GetPlayerData() then
            loadPlayerData()
        end
    end)
end)


RegisterNUICallback('RecieveSkellyData', function(data, cb)
    BodyDamage.skellyWidth = data.skellyWidth
    BodyDamage.skellyPos = data.skellyPos
    TriggerServerEvent('osp_ambulance:saveWoundDataSv', BodyDamage)
    SendNUIMessage(
        {
            damageStatus = json.encode(BodyDamage),
        }
    )
    if cb then cb({ ok = true }) end
end)

RegisterNUICallback('CheckBloodType', function(data)
    if RejectInsurvivableTreatment(data.PlayerId) then
        return
    end
    local ent = Player(data.PlayerId)
    local stat = ent.state.BodyDamage
    local bloodType = (type(stat.bloodType) == 'string' and Config.bloodTypes[stat.bloodType]) and stat.bloodType or nil

    if not bloodType then
        bloodType = CreateBloodType(data.PlayerId)
    end

    if not bloodType then
        SendTextMessage(GetLang().interactions.medicalHeader, GetLang().error.missing_item, 5000, "error")
        return
    end

    if not Config.RequireAnalysis or stat.bAnalysedBlood then
        SendTextMessage(GetLang().interactions.medicalHeader, 'Blood Type: '..bloodType, 5000, "info")
    else
        SendTextMessage(GetLang().interactions.medicalHeader, GetLang().error.blood_not_analysed, 5000, "error")
    end
end)

local keycooldown = false
openMedicalMenu = false
RegisterKeyMapping('medicalsystem', 'Open Medical Menu', 'keyboard', Config.OpenKey)
RegisterCommand("medicalsystem", function(source, args, rawCommand)
    TriggerEvent('osp_ambulance:openMedicalMenu', GetPlayerServerId(PlayerId()))
end, false)


function getPlayerDistance(playerId)
    local playerCoords = lib.callback.await('osp_ambulance:getPlayerCoords', 1000, playerId)
    if playerCoords then
        local dist = #(GetEntityCoords(PlayerPedId()) - playerCoords)
        return dist
    else
        print('^1Returned missing player coords (nil)')
        return 1000.0
    end
end


RegisterNetEvent('osp_ambulance:openMedicalMenu', function(playerId)
    if keycooldown or openMedicalMenu or lang == nil then return end
    if BodyDamage.isDead then return end
    if BodyDamage.inLastStand then return end
    keycooldown = true
    if not HasAccess('medicalMenu') then
        keycooldown = false
        return
    end
    openMedicalMenu = true

    if playerId == nil then
        playerId = GetPlayerServerId(lib.getClosestPlayer(GetEntityCoords(PlayerPedId()), Config.MedicalMenuMaxDistance, true))
        if playerId == nil then
            SendTextMessage(GetLang().interactions.medicalHeader, 'No player is nearby!', 5000, "error")
            openMedicalMenu = false
            keycooldown = false
            return
        end
    end
    local dist = #(GetEntityCoords(PlayerPedId()) - GetEntityCoords(GetPlayerPed(GetPlayerFromServerId(playerId))))
    if dist > Config.MedicalMenuMaxDistance then
        SendTextMessage(GetLang().interactions.medicalHeader, 'Player is too far away!', 5000, "error")
        openMedicalMenu = false
        keycooldown = false
        return
    end

    local stat = ResolvePlayerBodyDamage(playerId, true)
    if not stat or not IsBodyDamageReady(stat) then
        DebugPrint('state is nil or not ready', playerId)
        SendTextMessage(GetLang().interactions.medicalHeader, 'Medical data is still loading, try again.', 5000, "error")
        openMedicalMenu = false
        keycooldown = false
        return
    end
    DebugPrint('Player state data ', stat, stat.isDead, playerId)
    local invPayload = BuildInventoryNuiFields()
    ConfigLoader.ApplyRuntimeTables(Config)
    local medicationDataWithoutFunctions = deepCopyWithoutFunctions(Config.Medication)
    local medications = json.encode(medicationDataWithoutFunctions)
    SendNUIMessage(
        {
            damageStatus = EncodeBodyDamageForNui(stat),
            medicationData = medications,
            castsData = json.encode(Config.Casts),
            invItems = invPayload.invItems,
            supplyItems = invPayload.supplyItems,
            bypassItems = Config.AmbulanceBypassItems,
            display = true,
            uiStyle = Config.MedicalMenuStyle,
            autoTriage = Config.AutoTriage,
            isAuthorized = IsEmsStaff() == true,
            jobAccess = GetMedicalMenuJobAccess(),
        }
    )
    Wait(100)
    SetNuiFocus(true, true)
    Wait(1000)
    keycooldown = false
end)

function createPlayerMedicalMenuInteraction()
    CreateThread(function()
        if Config.UseTarget then
            if Config.UseOxTarget then
                exports.ox_target:removeGlobalPlayer('playerInteract')
                if JobHasAccess('medicalMenu') then
                    exports.ox_target:addGlobalPlayer({
                        {
                            name = 'playerInteract',
                            icon = 'fa-solid fa-clipboard',
                            label = 'Medical Menu',
                            onSelect = function(data)
                                if IsPedAPlayer(data.entity) then
                                    local playerId = GetPlayerServerId(NetworkGetPlayerIndexFromPed(data.entity))
                                    TriggerEvent('osp_ambulance:openMedicalMenu', playerId)
                                end
                            end,
                        }
                    })
                end
            else
                exports[Config.TargetName]:RemoveGlobalPlayer('Medical Menu')
                if JobHasAccess('medicalMenu') then
                    exports[Config.TargetName]:AddGlobalPlayer({
                        options = {
                            {
                            type = "client",
                            icon = 'fa-solid fa-clipboard',
                            label = 'Medical Menu',
                            action = function(entity)
                                if IsPedAPlayer(entity) then
                                    local playerId = GetPlayerServerId(NetworkGetPlayerIndexFromPed(entity))
                                    TriggerEvent('osp_ambulance:openMedicalMenu', playerId)
                                end
                            end,
                            }
                        },
                        distance = 5.5,
                    })
                end
            end
        else
            RegisterKeyMapping('tmedicalsystem', 'Open Target Medical Menu', 'keyboard', Config.OpenTargetKey)
            RegisterCommand("tmedicalsystem", function(source, args, rawCommand)
                local targetplayer = GetPlayerServerId(lib.getClosestPlayer(GetEntityCoords(PlayerPedId()), Config.MedicalMenuMaxDistance, false))
                TriggerEvent('osp_ambulance:openMedicalMenu', targetplayer)
            end, false)
        end
    end)
end
createPlayerMedicalMenuInteraction()

RegisterCommand("code", function(source, args, rawCommand)
    local hospitalID = tonumber(args[1])
    local monitorID = tonumber(args[2])
    TriggerServerEvent('osp_ambulance:SyncCodeBlueSv', monitorID, hospitalID)
end, false)

RegisterCommand("clearcode", function(source, args, rawCommand)
    local hospitalID = tonumber(args[1])
    TriggerServerEvent('osp_ambulance:ClearCodeBlueSv', hospitalID)
end, false)

local openSkelly = false
RegisterKeyMapping('skelly', 'Open Skelly Overview', 'keyboard', Config.SkellyKey)
RegisterCommand("skelly", function(source, args, rawCommand)
    if openSkelly then
        openSkelly = false
        SendNUIMessage(
            {
                onDamage = json.encode(BodyDamage),
                openSkelly = false,
            }
        )
    else
        openSkelly = true
        SendNUIMessage(
            {
                onDamage = json.encode(BodyDamage),
                openSkelly = true,
            }
        )
    end
end, false)

local editSkelly = false

if Config and Config.EditSkellyKey ~= '' then
    RegisterKeyMapping('editskelly', 'Edit Skelly Position', 'keyboard', Config.EditSkellyKey)
end

RegisterCommand("editskelly", function(source, args, rawCommand)
    Wait(100)
    SetNuiFocus(true, true)
    SendNUIMessage(
        {
            editSkelly = true,
            skellyWidth = BodyDamage.skellyWidth,
            skellyPos = BodyDamage.skellyPos,
        }
    )
end, false)


exports('GetAmbulanceData', function(playerid)
    if playerid then
        local ent = Player(playerid)
        local stat = ent.state.BodyDamage
        return stat
    else
        local ent = Player(GetPlayerServerId(PlayerId()))
        local stat = ent.state.BodyDamage
        return stat
    end
end)

exports('isDead', function()
    if BodyDamage.isDead or BodyDamage.inLastStand then
        return true
    end
    return false
end)

exports('IsInsurvivable', function(bodyDamage)
    return IsInsurvivable(bodyDamage or BodyDamage)
end)

RegisterNetEvent("osp_ambulance:SendAttachCl")
AddEventHandler("osp_ambulance:SendAttachCl", function(ped, pos)

    RegisterNetEvent("osp_ambulance:ChockCl")
    AddEventHandler("osp_ambulance:ChockCl", function(currentjoule)
        joule = currentjoule
        if GetEntityHealth(PlayerPedId()) >= 100 and BodyDamage.cardiacState == 'NSR' and not (BodyDamage.isDead or BodyDamage.inLastStand) then
            deathTime = 0
            OnDeath()
            DeathTimer()
        end
        if (BodyDamage.isDead or BodyDamage.inLastStand or BodyDamage.shockableRythm) then
            if (joule > 20) and (joule < 80) then
                if BodyDamage.cardiacState == 'asystole' then
                    local chance = math.random(1,2)
                    if chance == 1 then
                        TriggerEvent("osp_ambulance:partialRevive")
                    end
                end

                if BodyDamage.cardiacState == 'torsades' then
                    local chance = math.random(1,2)
                    if chance == 1 then
                        BodyDamage.cardiacState = 'NSR'
                        TriggerEvent("osp_ambulance:partialRevive")
                    else
                        BodyDamage.cardiacState = 'asystole'
                    end
                end

                if BodyDamage.shockableRythm then
                    local chance = math.random(1,2)
                    if chance == 1 then
                        BodyDamage.cardiacState = 'NSR'
                        TriggerEvent("osp_ambulance:partialRevive")
                        BodyDamage.shockableRythm = false
                    end
                end

            elseif (joule < 150) and (joule > 80) then
                if BodyDamage.cardiacState == 'asystole' then
                    local chance = math.random(1,2)
                    if chance == 1 then
                        TriggerEvent("osp_ambulance:partialRevive")
                    else
                        local chance = math.random(1,2)
                        if chance == 1 then
                            CreateThread(function()
                                BodyDamage.cardiacState = 'NSR'
                                BodyDamage.Pulse = 80
                                Wait(5000)
                                BodyDamage.cardiacState = 'asystole'
                                BodyDamage.Pulse = 0
                                SaveBodyDamage(GetPlayerServerId(NetworkGetPlayerIndexFromPed(PlayerPedId())), BodyDamage)
                            end)
                        else
                            BodyDamage.cardiacState = 'asystole'
                        end
                    end
                end

                if BodyDamage.cardiacState == 'torsades' then
                    local chance = math.random(1,2)
                    if chance == 1 then
                        BodyDamage.cardiacState = 'NSR'
                        TriggerEvent("osp_ambulance:partialRevive")
                    else
                        BodyDamage.cardiacState = 'asystole'
                    end
                end

                if BodyDamage.shockableRythm then
                    local chance = math.random(1,2)
                    if chance == 1 then
                        BodyDamage.cardiacState = 'NSR'
                        TriggerEvent("osp_ambulance:partialRevive")
                        BodyDamage.shockableRythm = false
                    end
                end

            elseif (joule > 150) then
                if BodyDamage.cardiacState == 'asystole' then
                    local chance = math.random(1,1)
                    if chance == 1 then
                        TriggerEvent("osp_ambulance:partialRevive")
                    else
                        CreateThread(function()
                            BodyDamage.cardiacState = 'NSR'
                            BodyDamage.Pulse = 80
                            Wait(5000)
                            BodyDamage.cardiacState = 'asystole'
                            BodyDamage.Pulse = 0
                            SaveBodyDamage(GetPlayerServerId(NetworkGetPlayerIndexFromPed(PlayerPedId())), BodyDamage)
                        end)
                    end
                end

                if BodyDamage.cardiacState == 'vFib' then
                    local chance = math.random(1,2)
                    if chance == 1 then
                        TriggerEvent("osp_ambulance:partialRevive")
                    end
                end

                if BodyDamage.cardiacState == 'torsades' then
                    local chance = math.random(1,3)
                    if chance == 1 then
                        BodyDamage.cardiacState = 'NSR'
                        BodyDamage.Pulse = 80
                    else
                        BodyDamage.Pulse = 0
                        BodyDamage.cardiacState = 'asystole'
                    end
                end


                if BodyDamage.shockableRythm then
                    local chance = math.random(1,4)
                    if chance == 1 then
                        BodyDamage.cardiacState = 'NSR'
                        TriggerEvent("osp_ambulance:partialRevive")
                        BodyDamage.shockableRythm = false
                    end
                end

            end
        end

        SaveBodyDamage(GetPlayerServerId(NetworkGetPlayerIndexFromPed(PlayerPedId())), BodyDamage)
    end)
end)


RegisterNetEvent('hospital:client:ambulanceAlert', function(coords, text)
    local street1, street2 = GetStreetNameAtCoord(coords.x, coords.y, coords.z)
    local street1name = GetStreetNameFromHashKey(street1)
    local street2name = GetStreetNameFromHashKey(street2)
    SendTextMessage(GetLang().interactions.medicalHeader, (text .. ' \n ' .. street1name.. ' ' ..street2name), 5000, "success")
    PlaySound(-1, "Lose_1st", "GTAO_FM_Events_Soundset", 0, 0, 1)
    local transG = 250
    local blip = AddBlipForCoord(coords.x, coords.y, coords.z)
    local blip2 = AddBlipForCoord(coords.x, coords.y, coords.z)
    local blipText = GetLang().info.ems_alert
    SetBlipSprite(blip, 153)
    SetBlipSprite(blip2, 161)
    SetBlipColour(blip, 1)
    SetBlipColour(blip2, 1)
    SetBlipDisplay(blip, 4)
    SetBlipDisplay(blip2, 8)
    SetBlipAlpha(blip, transG)
    SetBlipAlpha(blip2, transG)
    SetBlipScale(blip, 0.8)
    SetBlipScale(blip2, 2.0)
    SetBlipAsShortRange(blip, false)
    SetBlipAsShortRange(blip2, false)
    PulseBlip(blip2)
    BeginTextCommandSetBlipName('STRING')
    AddTextComponentString(blipText)
    EndTextCommandSetBlipName(blip)
    while transG ~= 0 do
        Wait(Config.DeadBlipDelay)
        transG = transG - 1
        SetBlipAlpha(blip, transG)
        SetBlipAlpha(blip2, transG)
        if transG == 0 then
            RemoveBlip(blip)
            return
        end
    end
end)

function ReloadHospitalBlips()
    for _, blip in pairs(hospitalBlips) do
        if blip and DoesBlipExist(blip) then
            RemoveBlip(blip)
        end
    end
    hospitalBlips = {}

    for _, hospital in pairs(Config.Hospitals or {}) do
        local blipConfig = hospital.blip
        if blipConfig and blipConfig.enable and blipConfig.coords then
            local coords = blipConfig.coords
            local xblip = AddBlipForCoord(coords.x, coords.y, coords.z)
            SetBlipSprite(xblip, blipConfig.icon)
            SetBlipAsShortRange(xblip, true)
            SetBlipScale(xblip, blipConfig.scale)
            SetBlipColour(xblip, blipConfig.color)
            BeginTextCommandSetBlipName("STRING")
            AddTextComponentString(hospital.label)
            EndTextCommandSetBlipName(xblip)
            hospitalBlips[#hospitalBlips + 1] = xblip
        end
    end
end

CreateThread(function()
    ReloadHospitalBlips()
end)

RegisterNetEvent('hospital:client:RespawnAtHospital', function()
    if GetActiveFramework() == 'qb' or GetActiveFramework() == 'qbox' then
        if IsHandCuffed() then
            TriggerEvent("police:client:GetCuffed", -1)
        end
        TriggerEvent("police:client:DeEscort")
    end

    -- Override HandleCustomRespawn in this file for fully custom respawn logic.
    -- Return true if you handled everything yourself.
    -- Return a vector3/vector4 (or {x,y,z[,w]}) to teleport there (server still runs inventory wipe / bill).
    -- Return false/nil to use Config.RespawnMode ('bed' or 'coords').
    local custom = HandleCustomRespawn()
    if custom == true then
        return
    end

    if custom then
        TriggerServerEvent('hospital:server:RespawnAtCoords')
        RespawnPlayerAtCoords(custom)
        return
    end

    TriggerServerEvent("hospital:server:RespawnAtHospital")
end)

-- Normalize vector3 / vector4 / {x,y,z[,w]} / {1,2,3[,4]} into x,y,z,w.
function NormalizeRespawnCoords(coords)
    if not coords then
        return nil
    end

    local coordType = type(coords)
    if coordType == 'vector4' then
        return coords.x, coords.y, coords.z, coords.w
    end
    if coordType == 'vector3' then
        return coords.x, coords.y, coords.z, 0.0
    end
    if coordType == 'table' then
        local x = coords.x or coords[1]
        local y = coords.y or coords[2]
        local z = coords.z or coords[3]
        local w = coords.w or coords[4] or 0.0
        if x and y and z then
            return x + 0.0, y + 0.0, z + 0.0, w + 0.0
        end
    end

    return nil
end

-- Finds the closest entry in Config.RespawnLocations.
-- Override this if you want custom location tables / filtering.
function GetClosestRespawnLocation(fromCoords)
    local locations = Config.RespawnLocations
    if type(locations) ~= 'table' then
        return nil
    end

    local origin = fromCoords or GetEntityCoords(PlayerPedId())
    local closestCoords = nil
    local closestDist = nil

    for _, location in pairs(locations) do
        local x, y, z, w = NormalizeRespawnCoords(location)
        if x then
            local dist = #(origin - vector3(x, y, z))
            if not closestDist or dist < closestDist then
                closestDist = dist
                closestCoords = vector4(x, y, z, w)
            end
        end
    end

    return closestCoords
end

-- Override to replace default respawn destination logic.
-- Return true = fully handled (you must wipe inventory / bill yourself if needed).
-- Return coords = teleport to those coords (server still runs wipe / bill via RespawnAtCoords).
-- Return false/nil = continue with Config.RespawnMode.
function HandleCustomRespawn()
    return false
end

-- External insurance: called when a player uses a hospital check-in NPC.
-- Return true if you handled the interaction (open your insurance menu, or start check-in).
-- Return false to use the built-in hospital reception / insurance menu.
-- Used when Config.UseBuiltInInsurance is false. Pair with GetExternalInsurance in server_open.lua.
function HandleExternalInsuranceMenu(hospitalId)
    -- TriggerEvent('osp_ambulance:checkin', { hospitalID = hospitalId })
    -- return true

    -- exports['my_insurance']:OpenMenu()
    -- return true

    return false
end

-- Teleport + revive at a set of coordinates (no hospital bed).
-- Called by hospital:client:RespawnAtCoords or when HandleCustomRespawn returns coords.
function RespawnPlayerAtCoords(coords)
    local x, y, z, w = NormalizeRespawnCoords(coords)
    if not x then
        return false
    end

    local ply = PlayerPedId()

    DoScreenFadeOut(1000)
    while not IsScreenFadedOut() do
        Wait(100)
    end

    if IsPedDeadOrDying(ply) or (BodyDamage and (BodyDamage.isDead or BodyDamage.inLastStand)) then
        NetworkResurrectLocalPlayer(x, y, z, w, true, false)
    end

    SetEntityCoordsNoOffset(ply, x, y, z, false, false, false)
    SetEntityHeading(ply, w)
    FreezeEntityPosition(ply, false)

    TriggerEvent('hospital:client:Revive', false)

    DoScreenFadeIn(1000)
    return true
end

RegisterNetEvent('hospital:client:RespawnAtCoords', function(coords)
    if not coords then
        coords = GetClosestRespawnLocation(GetEntityCoords(PlayerPedId()))
    end
    RespawnPlayerAtCoords(coords)
end)

function migratePlayerdata()
    EnsureBodyDamageStructure(BodyDamage)
    BodyDamage.hrIncrease = BodyDamage.hrIncrease or 0
    BodyDamage.hrDecrease = BodyDamage.hrDecrease or 0
    BodyDamage.hrIncrease = 0
    BodyDamage.hrDecrease = 0
    BodyDamage.skellyWidth = BodyDamage.skellyWidth or '20vh'
    BodyDamage.skellyPos = BodyDamage.skellyPos or nil
    BodyDamage.BodyPartDamage.TotalBloodFill = 0
    BodyDamage.BodyPartDamage.RefillBloodLeft = 0
    BodyDamage.BodyPartDamage.TotalInfusionFill = 0
    BodyDamage.BodyPartDamage.RefillInfusionLeft = 0
    BodyDamage.BodyPartDamage.ActiveInfusions = {}
    BodyDamage.BodyPartDamage.Fractures["Rarm"] = false
    BodyDamage.BodyPartDamage.Fractures["Larm"] = false
    BodyDamage.BodyPartDamage.Fractures["Rleg"] = false
    BodyDamage.BodyPartDamage.Fractures["Lleg"] = false
    BodyDamage.BodyPartDamage.Fractures["Torso"] = false
    BodyDamage.BodyPartDamage.Fractures["Head"] = false

    BodyDamage.BodyPartDamage.CosmeticFractures["Rarm"] = false
    BodyDamage.BodyPartDamage.CosmeticFractures["Larm"] = false
    BodyDamage.BodyPartDamage.CosmeticFractures["Rleg"] = false
    BodyDamage.BodyPartDamage.CosmeticFractures["Lleg"] = false
    BodyDamage.BodyPartDamage.CosmeticFractures["Torso"] = false
    BodyDamage.BodyPartDamage.CosmeticFractures["Head"] = false

    BodyDamage.BodyPartDamage.FractureTime["Rarm"] = 0
    BodyDamage.BodyPartDamage.FractureTime["Larm"] = 0
    BodyDamage.BodyPartDamage.FractureTime["Rleg"] = 0
    BodyDamage.BodyPartDamage.FractureTime["Lleg"] = 0
    BodyDamage.BodyPartDamage.FractureTime["Torso"] = 0
    BodyDamage.BodyPartDamage.FractureTime["Head"] = 0
end

-- Restoring the player on admin revive

function RestorePlayer(player, skipSave)
    SetEntityMaxHealth(player, 200)
    SetEntityHealth(player, 200)
    ClearPedBloodDamage(player)
    SetPlayerSprint(PlayerId(), true)
    ResetPedMovementClipset(player, 0.0)
    if HasWounds() then
        TriggerServerEvent('hud:server:RelieveStress', 100)
    end

    -- Always restore needs after an admin revive. Qbox metadata is updated
    -- server-side by hospital:server:resetHungerThirst, which tuff-hud reads.
    TriggerServerEvent("hospital:server:resetHungerThirst")

    if GetActiveFramework() == 'qb' or GetActiveFramework() == 'qbox' then
        TriggerServerEvent("hospital:server:SetDeathStatus", false)
        TriggerServerEvent("hospital:server:SetLaststandStatus", false)
    end
    TriggerEvent('osp_ambulance:OnPlayerSpawn')
    emsNotified = false
    putInVehicle = false
    itemsInjected = {}
    EnsureBodyDamageStructure(BodyDamage)
    BodyDamage.overdose = { active = false, treated = true }
    TriggerEvent('osp_ambulance:overdoseTreatedCl')
    BodyDamage.hrIncrease = 0
    BodyDamage.hrDecrease = 0
    BodyDamage.BodyPartDamage.BloodLevel = 6.0
    BodyDamage.Pain = 0
    BodyDamage.Conscious = true
    BodyDamage.Pulse = 80
    BodyDamage.oxygenSaturation = 99
    BodyDamage.Temp = 37.0
    BodyDamage.cardiacState = 'NSR'
    BodyDamage.BloodPressure[1] = 120
    BodyDamage.BloodPressure[2] = 80
    BodyDamage.isCarried = false
    BodyDamage.isDead = false
    BodyDamage.inLastStand = false
    BodyDamage.clothesStripped = false
    BodyDamage.beingPerformedCPROn = false
    BodyDamage.insurvivable = false
    BodyDamage.BodyPartDamage.Wounds["Rarm"] = {}
    BodyDamage.BodyPartDamage.Wounds["Larm"] = {}
    BodyDamage.BodyPartDamage.Wounds["Rleg"] = {}
    BodyDamage.BodyPartDamage.Wounds["Lleg"] = {}
    BodyDamage.BodyPartDamage.Wounds["Lleg"] = {}
    BodyDamage.BodyPartDamage.Wounds["Torso"] = {}
    BodyDamage.BodyPartDamage.Wounds["Head"] = {}
    BodyDamage.BodyPartDamage.NeedSewed["Rarm"] = false
    BodyDamage.BodyPartDamage.NeedSewed["Larm"] = false
    BodyDamage.BodyPartDamage.NeedSewed["Rleg"] = false
    BodyDamage.BodyPartDamage.NeedSewed["Lleg"] = false
    BodyDamage.BodyPartDamage.NeedSewed["Torso"] = false
    BodyDamage.BodyPartDamage.NeedSewed["Head"] = false
    BodyDamage.BodyPartDamage.Bleeding["Rarm"] = 0
    BodyDamage.BodyPartDamage.Bleeding["Larm"] = 0
    BodyDamage.BodyPartDamage.Bleeding["Rleg"] = 0
    BodyDamage.BodyPartDamage.Bleeding["Lleg"] = 0
    BodyDamage.BodyPartDamage.Bleeding["Torso"] = 0
    BodyDamage.BodyPartDamage.Bleeding["Head"] = 0
    BodyDamage.BodyPartDamage.DamageType["Rarm"] = 0
    BodyDamage.BodyPartDamage.DamageType["Larm"] = 0
    BodyDamage.BodyPartDamage.DamageType["Rleg"] = 0
    BodyDamage.BodyPartDamage.DamageType["Lleg"] = 0
    BodyDamage.BodyPartDamage.DamageType["Torso"] = 0
    BodyDamage.BodyPartDamage.DamageType["Head"] = 0
    BodyDamage.BodyPartDamage.Fractures["Rarm"] = false
    BodyDamage.BodyPartDamage.Fractures["Larm"] = false
    BodyDamage.BodyPartDamage.Fractures["Rleg"] = false
    BodyDamage.BodyPartDamage.Fractures["Lleg"] = false
    BodyDamage.BodyPartDamage.Fractures["Torso"] = false
    BodyDamage.BodyPartDamage.Fractures["Head"] = false
    BodyDamage.BodyPartDamage.CosmeticFractures = BodyDamage.BodyPartDamage.CosmeticFractures or {}
    BodyDamage.BodyPartDamage.CosmeticFractures["Rarm"] = false
    BodyDamage.BodyPartDamage.CosmeticFractures["Larm"] = false
    BodyDamage.BodyPartDamage.CosmeticFractures["Rleg"] = false
    BodyDamage.BodyPartDamage.CosmeticFractures["Lleg"] = false
    BodyDamage.BodyPartDamage.CosmeticFractures["Torso"] = false
    BodyDamage.BodyPartDamage.CosmeticFractures["Head"] = false
    BodyDamage.BodyPartDamage.FractureTime["Rarm"] = 0
    BodyDamage.BodyPartDamage.FractureTime["Larm"] = 0
    BodyDamage.BodyPartDamage.FractureTime["Rleg"] = 0
    BodyDamage.BodyPartDamage.FractureTime["Lleg"] = 0
    BodyDamage.BodyPartDamage.FractureTime["Torso"] = 0
    BodyDamage.BodyPartDamage.FractureTime["Head"] = 0
    BodyDamage.BodyPartDamage.appliedTourniquets = BodyDamage.BodyPartDamage.appliedTourniquets or {}
    BodyDamage.BodyPartDamage.appliedTourniquets["Rarm"] = false
    BodyDamage.BodyPartDamage.appliedTourniquets["Larm"] = false
    BodyDamage.BodyPartDamage.appliedTourniquets["Rleg"] = false
    BodyDamage.BodyPartDamage.appliedTourniquets["Lleg"] = false
    BodyDamage.BodyPartDamage.appliedSplints = {}
    BodyDamage.BodyPartDamage.Triage = "None"
    BodyDamage.BodyPartDamage.TotalBloodFill = 0
    BodyDamage.BodyPartDamage.RefillBloodLeft = 0
    BodyDamage.BodyPartDamage.TotalInfusionFill = 0
    BodyDamage.BodyPartDamage.RefillInfusionLeft = 0
    BodyDamage.BodyPartDamage.ActiveInfusions = {}
    BodyDamage.BodyPartDamage.ConflictingBlood = { stage = 0, tick = 0 }
    BodyDamage.MessageLog = {}
    TriggerEvent('osp_ambulance:clearConditionsCl')
    TriggerEvent('osp_ambulance:clearAddictionsCl')
    ProcessRunStuff()
    if not skipSave then
        SaveBodyDamage(GetPlayerServerId(NetworkGetPlayerIndexFromPed(PlayerPedId())), BodyDamage)
    end
end

RegisterNetEvent('osp_ambulance:partialRevive', function(bypassInsurvivable)
    if not bypassInsurvivable and IsInsurvivable(BodyDamage) then
        SendTextMessage(GetLang().interactions.medicalHeader, GetLang().error.insurvivable_injury, 5000, "error")
        return
    end
    TriggerEvent('osp_ambulance:restoreStrippedClothesAppearance')
    FreezeEntityPosition(PlayerPedId(), false)
    TriggerServerEvent('osp_ambulance:mutePlayer', false)
    local ply = PlayerPedId()
    if BodyDamage.isCarried then
        BodyDamage.isCarried = false
        ClearPedSecondaryTask(PlayerPedId())
        DetachEntity(PlayerPedId(), true, false)
    end
    if BodyDamage.isDead or BodyDamage.inLastStand then
        local pos = GetEntityCoords(ply, true)
        NetworkResurrectLocalPlayer(pos.x, pos.y, pos.z, GetEntityHeading(ply), true, false)
        BodyDamage.isDead = false
        SetEntityInvincible(ply, false)
        SetLaststand(false)
    end
    if isInHospitalBed then
        loadAnimDict(inBedDict)
        TaskPlayAnim(ply, inBedDict , inBedAnim, 8.0, 1.0, -1, 1, 0, 0, 0, 0 )
        canLeaveBed = true
        textUi(GetLang().text.bed_out)
    else
        -- ClearPedTasksImmediately(PlayerPedId())
    end
    SetExtraTimecycleModifier("fp_vig_red")
    SetExtraTimecycleModifierStrength(1.0)
    SetPedMotionBlur(ply, false)
    ClearExtraTimecycleModifier()
    SendNUIMessage(
        {
            death = 3,
            blackout = 4,
            slowheartbeat = 'close',
            rapidheartbeat = 'close',
        }
    )
    SetEntityInvincible(ply, false)
    SetEntityMaxHealth(ply, 200)
    SetEntityHealth(ply, 125)
    if GetActiveFramework() == 'qb' then
        TriggerServerEvent("hospital:server:SetDeathStatus", false)
        TriggerServerEvent("hospital:server:SetLaststandStatus", false)
    end
    TriggerEvent('osp_ambulance:OnPlayerSpawn')
    emsNotified = false
    BodyDamage.Conscious = true
    BodyDamage.isDead = false
    BodyDamage.inLastStand = false
    BodyDamage.cardiacState = 'NSR'
    itemsInjected = {}
    BodyDamage.overdose = { active = false, treated = true }
    TriggerEvent('osp_ambulance:overdoseTreatedCl')
    BodyDamage.Pulse = 70
    BodyDamage.oxygenSaturation = 95
    BodyDamage.Temp = 37.0
    BodyDamage.BodyPartDamage.BloodLevel = 6.0
    BodyDamage.BloodPressure[1] = 120
    BodyDamage.BloodPressure[2] = 80
    BodyDamage.hrIncrease = 0
    BodyDamage.hrDecrease = 0
    putInVehicle = false
    TriggerServerEvent("hospital:server:resetHungerThirst")
    ProcessRunStuff()
    SetEntityVisible(PlayerPedId(), true, true)
    BodyDamage.isInBodybag = false
    DeleteEntity(bodyBag)
    SaveBodyDamage(GetPlayerServerId(NetworkGetPlayerIndexFromPed(PlayerPedId())), BodyDamage)
    if GetActiveFramework() == 'esx' then
        TriggerServerEvent('osp_ambulance:setDeathStatus', false)
        ESX.SetPlayerData('dead', false)
    end
end)

RegisterNetEvent('hospital:client:Revive', function(bypassInsurvivable)
    if not bypassInsurvivable and IsInsurvivable(BodyDamage) then
        SendTextMessage(GetLang().interactions.medicalHeader, GetLang().error.insurvivable_injury, 5000, "error")
        return
    end
    TriggerEvent('osp_ambulance:restoreStrippedClothesAppearance')
    FreezeEntityPosition(PlayerPedId(), false)
    TriggerServerEvent('osp_ambulance:mutePlayer', false)
    local ply = PlayerPedId()
    if BodyDamage.isCarried then
        BodyDamage.isCarried = false
        ClearPedSecondaryTask(PlayerPedId())
        DetachEntity(PlayerPedId(), true, false)
    end
    if BodyDamage.isDead or BodyDamage.inLastStand then
        local pos = GetEntityCoords(ply, true)
        NetworkResurrectLocalPlayer(pos.x, pos.y, pos.z, GetEntityHeading(ply), true, false)
        BodyDamage.isDead = false
        SetEntityInvincible(ply, false)
        SetLaststand(false)
    end
    if isInHospitalBed then
        loadAnimDict(inBedDict)
        TaskPlayAnim(ply, inBedDict , inBedAnim, 8.0, 1.0, -1, 1, 0, 0, 0, 0 )
        SetEntityInvincible(ply, true)
        canLeaveBed = true
        textUi(GetLang().text.bed_out)
    else
        -- ClearPedTasksImmediately(PlayerPedId())
    end
    RestorePlayer(ply)
    TriggerEvent('osp_ambulance:restoreStrippedClothesAppearance')
    SetExtraTimecycleModifier("fp_vig_red")
    SetExtraTimecycleModifierStrength(1.0)
    SetPedMotionBlur(ply, false)
    ClearExtraTimecycleModifier()
    SetEntityInvincible(ply, false)
    SendNUIMessage(
        {
            death = 3,
            blackout = 4,
            slowheartbeat = 'close',
            rapidheartbeat = 'close',
        }
    )
    SendTextMessage(GetLang().interactions.medicalHeader, GetLang().info.healthy, 5000, "success")
    SetEntityVisible(PlayerPedId(), true, true)
    BodyDamage.isInBodybag = false
    DeleteEntity(bodyBag)
    if GetActiveFramework() == 'esx' then
        TriggerServerEvent('osp_ambulance:setDeathStatus', false)
        ESX.SetPlayerData('dead', false)
    end
end)


RegisterNetEvent('hospital:client:KillPlayer', function()
    SetEntityHealth(PlayerPedId(), 0)
end)



-- -- Example code snippet of how a custom item can be used to heal a player

-- RegisterNetEvent('osp_ambulance:useIfak', function()
--     local dict, anim = 'anim@scripted@npc@freemode@ig1_cook_lab@flask_rack@' , 'idle_01'
--     ProgressBar(GetLang().update1.useIfak, 4000, dict, anim)
-- end)

-- RegisterNetEvent('osp_ambulance:useBandage', function()
--     -- FreezeEntityPosition(PlayerPedId(), true)
--     local dict, anim = 'anim@scripted@npc@freemode@ig1_cook_lab@flask_rack@' , 'idle_01'
--     ProgressBar(GetLang().update1.applyBandage, 3000, dict, anim)
--     local ped = PlayerPedId()
--     local health = GetEntityHealth(ped)
--     local maxHealth = GetEntityMaxHealth(ped)
--     if maxHealth > health then
--         if health + 25 > maxHealth then
--             SetEntityHealth(ped, maxHealth)
--         else
--             SetEntityHealth(ped, health + 25)
--         end
--     end
--     for k,v in pairs(BodyDamage.BodyPartDamage.Bleeding) do
--         local chance = math.random(1,4)
--         if chance == 1 then
--             local partBleeding = BodyDamage.BodyPartDamage.Bleeding[k] or 0
--             if partBleeding < 0.3 then
--                 BodyDamage.BodyPartDamage.Bleeding[k] = 0.0
--             else
--                 BodyDamage.BodyPartDamage.Bleeding[k] = partBleeding / 2
--             end
--         end
--     end
--     SaveBodyDamage(GetPlayerServerId(NetworkGetPlayerIndexFromPed(PlayerPedId())), BodyDamage)
--     -- FreezeEntityPosition(PlayerPedId(), false)
-- end)

-- RegisterNetEvent('osp_ambulance:useTorniquet', function()
--     -- FreezeEntityPosition(PlayerPedId(), true)
--     local dict, anim = 'anim@scripted@npc@freemode@ig1_cook_lab@flask_rack@' , 'idle_01'
--     ProgressBar(GetLang().update1.applyTourniquet, 3000, dict, anim)
--     local ped = PlayerPedId()
--     CreateThread(function()
--         for k,v in pairs(BodyDamage.BodyPartDamage.appliedTourniquets) do
--             BodyDamage.BodyPartDamage.appliedTourniquets[k] = true
--         end
--         Wait(1000*120) -- How long until the tourniquets wear down and are removed
--         for k,v in pairs(BodyDamage.BodyPartDamage.appliedTourniquets) do
--             BodyDamage.BodyPartDamage.appliedTourniquets[k] = false
--         end
--         SaveBodyDamage(GetPlayerServerId(NetworkGetPlayerIndexFromPed(PlayerPedId())), BodyDamage)
--     end)
--     -- FreezeEntityPosition(PlayerPedId(), false)
-- end)

-- RegisterNetEvent('osp_ambulance:painKillers', function()
--     -- FreezeEntityPosition(PlayerPedId(), true)
--     local dict, anim = 'anim@scripted@npc@freemode@ig1_cook_lab@flask_rack@' , 'idle_01'
--     ProgressBar(GetLang().update1.consumePainkillers, 3000, dict, anim)
--     local ped = PlayerPedId()
--     local health = GetEntityHealth(ped)
--     local maxHealth = GetEntityMaxHealth(ped)
--     if maxHealth > health then
--         if health + 10 > maxHealth then
--             SetEntityHealth(ped, maxHealth)
--         else
--             SetEntityHealth(ped, health + 10)
--         end
--     end
--     TriggerServerEvent('hud:server:RelieveStress', 100)
--     BodyDamage.Pain = BodyDamage.Pain/2
--     BodyDamage.hrDecrease = BodyDamage.hrDecrease + 10
--     -- FreezeEntityPosition(PlayerPedId(), false)
-- end)


Weapons = {
	-- // WEAPONS
	-- Melee
	[`weapon_unarmed`] 				 = {['name'] = 'weapon_unarmed', 		['label'] = 'Fists', 				['weapontype'] = 'Melee',	['ammotype'] = nil, ['damagereason'] = 'Melee killed / Whacked / Executed / Beat down / Murdered / Battered'},
	[`weapon_dagger`] 				 = {['name'] = 'weapon_dagger', 		['label'] = 'Dagger', 				['weapontype'] = 'Melee',	['ammotype'] = nil,	['damagereason'] = 'Knifed / Stabbed / Eviscerated'},
	[`weapon_bat`] 					 = {['name'] = 'weapon_bat', 			['label'] = 'Bat', 					['weapontype'] = 'Melee',	['ammotype'] = nil,	['damagereason'] = 'Melee killed / Whacked / Executed / Beat down / Murdered / Battered'},
	[`weapon_bottle`] 				 = {['name'] = 'weapon_bottle', 		['label'] = 'Broken Bottle', 		['weapontype'] = 'Melee',	['ammotype'] = nil,	['damagereason'] = 'Knifed / Stabbed / Eviscerated'},
	[`weapon_crowbar`] 				 = {['name'] = 'weapon_crowbar', 		['label'] = 'Crowbar', 				['weapontype'] = 'Melee',	['ammotype'] = nil,	['damagereason'] = 'Melee killed / Whacked / Executed / Beat down / Murdered / Battered'},
	[`weapon_flashlight`] 			 = {['name'] = 'weapon_flashlight', 	['label'] = 'Flashlight', 			['weapontype'] = 'Melee',	['ammotype'] = nil,	['damagereason'] = 'Melee killed / Whacked / Executed / Beat down / Murdered / Battered'},
	[`weapon_golfclub`] 			 = {['name'] = 'weapon_golfclub', 		['label'] = 'Golfclub', 			['weapontype'] = 'Melee',	['ammotype'] = nil,	['damagereason'] = 'Melee killed / Whacked / Executed / Beat down / Murdered / Battered'},
	[`weapon_hammer`] 				 = {['name'] = 'weapon_hammer', 		['label'] = 'Hammer', 				['weapontype'] = 'Melee',	['ammotype'] = nil,	['damagereason'] = 'Melee killed / Whacked / Executed / Beat down / Murdered / Battered'},
	[`weapon_hatchet`] 				 = {['name'] = 'weapon_hatchet', 		['label'] = 'Hatchet', 				['weapontype'] = 'Melee',	['ammotype'] = nil,	['damagereason'] = 'Knifed / Stabbed / Eviscerated'},
	[`weapon_knuckle`] 				 = {['name'] = 'weapon_knuckle', 		['label'] = 'Knuckle', 				['weapontype'] = 'Melee',	['ammotype'] = nil,	['damagereason'] = 'Melee killed / Whacked / Executed / Beat down / Murdered / Battered'},
	[`weapon_knife`] 				 = {['name'] = 'weapon_knife', 			['label'] = 'Knife', 				['weapontype'] = 'Melee',	['ammotype'] = nil,	['damagereason'] = 'Knifed / Stabbed / Eviscerated'},
	[`weapon_machete`] 				 = {['name'] = 'weapon_machete', 		['label'] = 'Machete', 				['weapontype'] = 'Melee',	['ammotype'] = nil,	['damagereason'] = 'Knifed / Stabbed / Eviscerated'},
	[`weapon_switchblade`] 			 = {['name'] = 'weapon_switchblade', 	['label'] = 'Switchblade', 			['weapontype'] = 'Melee',	['ammotype'] = nil,	['damagereason'] = 'Knifed / Stabbed / Eviscerated'},
	[`weapon_nightstick`] 			 = {['name'] = 'weapon_nightstick', 	['label'] = 'Nightstick', 			['weapontype'] = 'Melee',	['ammotype'] = nil,	['damagereason'] = 'Melee killed / Whacked / Executed / Beat down / Murdered / Battered'},
	[`weapon_wrench`] 				 = {['name'] = 'weapon_wrench', 		['label'] = 'Wrench', 				['weapontype'] = 'Melee',	['ammotype'] = nil,	['damagereason'] = 'Melee killed / Whacked / Executed / Beat down / Murdered / Battered'},
	[`weapon_battleaxe`] 			 = {['name'] = 'weapon_battleaxe', 		['label'] = 'Battle Axe', 			['weapontype'] = 'Melee',	['ammotype'] = nil,	['damagereason'] = 'Knifed / Stabbed / Eviscerated'},
	[`weapon_poolcue`] 				 = {['name'] = 'weapon_poolcue', 		['label'] = 'Poolcue', 				['weapontype'] = 'Melee',	['ammotype'] = nil,	['damagereason'] = 'Melee killed / Whacked / Executed / Beat down / Murdered / Battered'},
	[`weapon_briefcase`] 			 = {['name'] = 'weapon_briefcase', 		['label'] = 'Briefcase', 			['weapontype'] = 'Melee',	['ammotype'] = nil,	['damagereason'] = 'Melee killed / Whacked / Executed / Beat down / Murdered / Battered'},
	[`weapon_briefcase_02`] 		 = {['name'] = 'weapon_briefcase_02', 	['label'] = 'Briefcase', 			['weapontype'] = 'Melee',	['ammotype'] = nil,	['damagereason'] = 'Melee killed / Whacked / Executed / Beat down / Murdered / Battered'},
	[`weapon_garbagebag`] 			 = {['name'] = 'weapon_garbagebag', 	['label'] = 'Garbage Bag', 			['weapontype'] = 'Melee',	['ammotype'] = nil,	['damagereason'] = 'Melee killed / Whacked / Executed / Beat down / Murdered / Battered'},
	[`weapon_handcuffs`] 			 = {['name'] = 'weapon_handcuffs', 		['label'] = 'Handcuffs', 			['weapontype'] = 'Melee',	['ammotype'] = nil,	['damagereason'] = 'Melee killed / Whacked / Executed / Beat down / Murdered / Battered'},
	[`weapon_bread`] 				 = {['name'] = 'weapon_bread', 			['label'] = 'Baquette', 			['weapontype'] = 'Melee',	['ammotype'] = nil,	['damagereason'] = 'Melee killed / Whacked / Executed / Beat down / Murdered / Battered'},
	[`weapon_stone_hatchet`] 		 = {['name'] = 'weapon_stone_hatchet', 	['label'] = 'Stone Hatchet',        ['weapontype'] = 'Melee',	['ammotype'] = nil,	['damagereason'] = 'Knifed / Stabbed / Eviscerated'},

    -- Handguns
	[`weapon_pistol`] 				 = {['name'] = 'weapon_pistol', 		['label'] = 'Pistol', 				    ['weapontype'] = 'Pistol',	['ammotype'] = 'AMMO_PISTOL',	['damagereason'] = 'Pistoled / Blasted / Plugged / Bust a cap in'},
	[`weapon_pistol_mk2`] 			 = {['name'] = 'weapon_pistol_mk2', 	['label'] = 'Pistol Mk2', 			    ['weapontype'] = 'Pistol',	['ammotype'] = 'AMMO_PISTOL',	['damagereason'] = 'Pistoled / Blasted / Plugged / Bust a cap in'},
	[`weapon_combatpistol`] 		 = {['name'] = 'weapon_combatpistol', 	['label'] = 'Combat Pistol', 			['weapontype'] = 'Pistol',	['ammotype'] = 'AMMO_PISTOL',	['damagereason'] = 'Pistoled / Blasted / Plugged / Bust a cap in'},
	[`weapon_appistol`] 			 = {['name'] = 'weapon_appistol', 		['label'] = 'AP Pistol', 				['weapontype'] = 'Pistol',	['ammotype'] = 'AMMO_PISTOL',	['damagereason'] = 'Pistoled / Blasted / Plugged / Bust a cap in'},
	[`weapon_stungun`] 				 = {['name'] = 'weapon_stungun', 		['label'] = 'Taser', 					['weapontype'] = 'Pistol',	['ammotype'] = 'AMMO_STUNGUN',	['damagereason'] = 'Died'},
	[`weapon_pistol50`] 			 = {['name'] = 'weapon_pistol50', 		['label'] = 'Pistol .50 Cal', 			['weapontype'] = 'Pistol',	['ammotype'] = 'AMMO_PISTOL',	['damagereason'] = 'Pistoled / Blasted / Plugged / Bust a cap in'},
	[`weapon_snspistol`] 			 = {['name'] = 'weapon_snspistol', 		['label'] = 'SNS Pistol', 				['weapontype'] = 'Pistol',	['ammotype'] = 'AMMO_PISTOL',	['damagereason'] = 'Pistoled / Blasted / Plugged / Bust a cap in'},
	[`weapon_snspistol_mk2`] 	     = {['name'] = 'weapon_snspistol_mk2', 	['label'] = 'SNS Pistol MK2', 			['weapontype'] = 'Pistol',	['ammotype'] = 'AMMO_PISTOL',   ['damagereason'] = 'Pistoled / Blasted / Plugged / Bust a cap in'},
	[`weapon_heavypistol`] 			 = {['name'] = 'weapon_heavypistol', 	['label'] = 'Heavy Pistol', 			['weapontype'] = 'Pistol',	['ammotype'] = 'AMMO_PISTOL',	['damagereason'] = 'Pistoled / Blasted / Plugged / Bust a cap in'},
	[`weapon_vintagepistol`] 		 = {['name'] = 'weapon_vintagepistol', 	['label'] = 'Vintage Pistol', 			['weapontype'] = 'Pistol',	['ammotype'] = 'AMMO_PISTOL',	['damagereason'] = 'Pistoled / Blasted / Plugged / Bust a cap in'},
	[`weapon_flaregun`] 			 = {['name'] = 'weapon_flaregun', 		['label'] = 'Flare Gun', 				['weapontype'] = 'Pistol',	['ammotype'] = 'AMMO_FLARE',	['damagereason'] = 'Died'},
	[`weapon_marksmanpistol`] 		 = {['name'] = 'weapon_marksmanpistol', ['label'] = 'Marksman Pistol', 			['weapontype'] = 'Pistol',	['ammotype'] = 'AMMO_PISTOL',	['damagereason'] = 'Pistoled / Blasted / Plugged / Bust a cap in'},
	[`weapon_revolver`] 			 = {['name'] = 'weapon_revolver', 		['label'] = 'Revolver', 				['weapontype'] = 'Pistol',	['ammotype'] = 'AMMO_PISTOL',	['damagereason'] = 'Pistoled / Blasted / Plugged / Bust a cap in'},
	[`weapon_revolver_mk2`] 		 = {['name'] = 'weapon_revolver_mk2', 	['label'] = 'Revolver MK2', 		    ['weapontype'] = 'Pistol',	['ammotype'] = 'AMMO_PISTOL',	['damagereason'] = 'Pistoled / Blasted / Plugged / Bust a cap in'},
	[`weapon_doubleaction`] 	     = {['name'] = 'weapon_doubleaction', 	['label'] = 'Double Action Revolver',	['weapontype'] = 'Pistol',	['ammotype'] = 'AMMO_PISTOL',	['damagereason'] = 'Pistoled / Blasted / Plugged / Bust a cap in'},
	[`weapon_raypistol`]			 = {['name'] = 'weapon_raypistol',		['label'] = 'Ray Pistol',			    ['weapontype'] = 'Pistol',	['ammotype'] = 'AMMO_PISTOL',	['damagereason'] = 'Pistoled / Blasted / Plugged / Bust a cap in'},
	[`weapon_ceramicpistol`]		 = {['name'] = 'weapon_ceramicpistol', 	['label'] = 'Ceramic Pistol',		    ['weapontype'] = 'Pistol',	['ammotype'] = 'AMMO_PISTOL',	['damagereason'] = 'Pistoled / Blasted / Plugged / Bust a cap in'},
	[`weapon_navyrevolver`]        	 = {['name'] = 'weapon_navyrevolver', 	['label'] = 'Navy Revolver',		    ['weapontype'] = 'Pistol',	['ammotype'] = 'AMMO_PISTOL',	['damagereason'] = 'Pistoled / Blasted / Plugged / Bust a cap in'},
	[`weapon_gadgetpistol`] 		 = {['name'] = 'weapon_gadgetpistol', 	['label'] = 'Gadget Pistol',		    ['weapontype'] = 'Pistol',	['ammotype'] = 'AMMO_PISTOL',	['damagereason'] = 'Pistoled / Blasted / Plugged / Bust a cap in'},
	[`weapon_stungun_mp`] 			 = {['name'] = 'weapon_stungun_mp', 	['label'] = 'Taser', 					['weapontype'] = 'Pistol',	['ammotype'] = 'AMMO_STUNGUN',	['damagereason'] = 'Died'},

    -- Submachine Guns
	[`weapon_microsmg`] 			 = {['name'] = 'weapon_microsmg', 		['label'] = 'Micro SMG', 			['weapontype'] = 'Submachine Gun',	['ammotype'] = 'AMMO_SMG',		['damagereason'] = 'Riddled / Drilled / Finished / Submachine Gunned'},
	[`weapon_smg`] 				 	 = {['name'] = 'weapon_smg', 			['label'] = 'SMG', 					['weapontype'] = 'Submachine Gun',	['ammotype'] = 'AMMO_SMG',		['damagereason'] = 'Riddled / Drilled / Finished / Submachine Gunned'},
	[`weapon_smg_mk2`] 				 = {['name'] = 'weapon_smg_mk2', 		['label'] = 'SMG MK2', 			    ['weapontype'] = 'Submachine Gun',	['ammotype'] = 'AMMO_SMG',		['damagereason'] = 'Riddled / Drilled / Finished / Submachine Gunned'},
	[`weapon_assaultsmg`] 			 = {['name'] = 'weapon_assaultsmg', 	['label'] = 'Assault SMG', 			['weapontype'] = 'Submachine Gun',	['ammotype'] = 'AMMO_SMG',		['damagereason'] = 'Riddled / Drilled / Finished / Submachine Gunned'},
	[`weapon_combatpdw`] 			 = {['name'] = 'weapon_combatpdw', 		['label'] = 'Combat PDW', 			['weapontype'] = 'Submachine Gun',	['ammotype'] = 'AMMO_SMG',		['damagereason'] = 'Riddled / Drilled / Finished / Submachine Gunned'},
	[`weapon_machinepistol`] 		 = {['name'] = 'weapon_machinepistol', 	['label'] = 'Tec-9', 				['weapontype'] = 'Submachine Gun',	['ammotype'] = 'AMMO_PISTOL',	['damagereason'] = 'Riddled / Drilled / Finished / Submachine Gunned'},
	[`weapon_minismg`] 				 = {['name'] = 'weapon_minismg', 		['label'] = 'Mini SMG', 			['weapontype'] = 'Submachine Gun',	['ammotype'] = 'AMMO_SMG',		['damagereason'] = 'Riddled / Drilled / Finished / Submachine Gunned'},
	[`weapon_raycarbine`]	         = {['name'] = 'weapon_raycarbine', 	['label'] = 'Raycarbine',	        ['weapontype'] = 'Submachine Gun',	['ammotype'] = 'AMMO_SMG',		['damagereason'] = 'Riddled / Drilled / Finished / Submachine Gunned'},

    -- Shotguns
	[`weapon_pumpshotgun`] 			 = {['name'] = 'weapon_pumpshotgun', 	 	['label'] = 'Pump Shotgun', 			['weapontype'] = 'Shotgun',	['ammotype'] = 'AMMO_SHOTGUN',	['damagereason'] = 'Devastated / Pulverized / Shotgunned'},
	[`weapon_pumpshotgun_mk2`]		 = {['name'] = 'weapon_pumpshotgun_mk2',	['label'] = 'Pump Shotgun MK2', 		['weapontype'] = 'Shotgun',	['ammotype'] = 'AMMO_SHOTGUN',	['damagereason'] = 'Devastated / Pulverized / Shotgunned'},
	[`weapon_sawnoffshotgun`] 		 = {['name'] = 'weapon_sawnoffshotgun', 	['label'] = 'Sawn-off Shotgun', 		['weapontype'] = 'Shotgun',	['ammotype'] = 'AMMO_SHOTGUN',	['damagereason'] = 'Devastated / Pulverized / Shotgunned'},
	[`weapon_assaultshotgun`] 		 = {['name'] = 'weapon_assaultshotgun', 	['label'] = 'Assault Shotgun', 			['weapontype'] = 'Shotgun',	['ammotype'] = 'AMMO_SHOTGUN',	['damagereason'] = 'Devastated / Pulverized / Shotgunned'},
	[`weapon_bullpupshotgun`] 		 = {['name'] = 'weapon_bullpupshotgun', 	['label'] = 'Bullpup Shotgun', 			['weapontype'] = 'Shotgun',	['ammotype'] = 'AMMO_SHOTGUN',	['damagereason'] = 'Devastated / Pulverized / Shotgunned'},
	[`weapon_musket`] 			     = {['name'] = 'weapon_musket', 			['label'] = 'Musket', 					['weapontype'] = 'Shotgun',	['ammotype'] = 'AMMO_SHOTGUN',	['damagereason'] = 'Devastated / Pulverized / Shotgunned'},
	[`weapon_heavyshotgun`] 		 = {['name'] = 'weapon_heavyshotgun', 	 	['label'] = 'Heavy Shotgun', 			['weapontype'] = 'Shotgun',	['ammotype'] = 'AMMO_SHOTGUN',	['damagereason'] = 'Devastated / Pulverized / Shotgunned'},
	[`weapon_dbshotgun`] 			 = {['name'] = 'weapon_dbshotgun', 		 	['label'] = 'Double-barrel Shotgun', 	['weapontype'] = 'Shotgun',	['ammotype'] = 'AMMO_SHOTGUN',	['damagereason'] = 'Devastated / Pulverized / Shotgunned'},
	[`weapon_autoshotgun`] 			 = {['name'] = 'weapon_autoshotgun', 	 	['label'] = 'Auto Shotgun', 			['weapontype'] = 'Shotgun',	['ammotype'] = 'AMMO_SHOTGUN',	['damagereason'] = 'Devastated / Pulverized / Shotgunned'},
	[`weapon_combatshotgun`]		 = {['name'] = 'weapon_combatshotgun', 		['label'] = 'Combat Shotgun',		    ['weapontype'] = 'Shotgun',	['ammotype'] = 'AMMO_SHOTGUN',	['damagereason'] = 'Devastated / Pulverized / Shotgunned'},

    -- Assault Rifles
	[`weapon_assaultrifle`] 		 = {['name'] = 'weapon_assaultrifle', 	 	['label'] = 'Assault Rifle', 				['weapontype'] = 'Assault Rifle',	['ammotype'] = 'AMMO_RIFLE',	['damagereason'] = 'Ended / Rifled / Shot down / Floored'},
	[`weapon_assaultrifle_mk2`] 	 = {['name'] = 'weapon_assaultrifle_mk2', 	['label'] = 'Assault Rifle MK2', 			['weapontype'] = 'Assault Rifle',	['ammotype'] = 'AMMO_RIFLE',	['damagereason'] = 'Ended / Rifled / Shot down / Floored'},
	[`weapon_carbinerifle`] 		 = {['name'] = 'weapon_carbinerifle', 	 	['label'] = 'Carbine Rifle', 				['weapontype'] = 'Assault Rifle',	['ammotype'] = 'AMMO_RIFLE',	['damagereason'] = 'Ended / Rifled / Shot down / Floored'},
    [`weapon_carbinerifle_mk2`] 	 = {['name'] = 'weapon_carbinerifle_mk2', 	['label'] = 'Carbine Rifle MK2', 			['weapontype'] = 'Assault Rifle',	['ammotype'] = 'AMMO_RIFLE',	['damagereason'] = 'Ended / Rifled / Shot down / Floored'},
	[`weapon_advancedrifle`] 		 = {['name'] = 'weapon_advancedrifle', 	 	['label'] = 'Advanced Rifle', 				['weapontype'] = 'Assault Rifle',	['ammotype'] = 'AMMO_RIFLE',	['damagereason'] = 'Ended / Rifled / Shot down / Floored'},
	[`weapon_specialcarbine`] 		 = {['name'] = 'weapon_specialcarbine', 	['label'] = 'Special Carbine', 				['weapontype'] = 'Assault Rifle',	['ammotype'] = 'AMMO_RIFLE',	['damagereason'] = 'Ended / Rifled / Shot down / Floored'},
	[`weapon_specialcarbine_mk2`]	 = {['name'] = 'weapon_specialcarbine_mk2',	['label'] = 'Specialcarbine MK2',	        ['weapontype'] = 'Assault Rifle',	['ammotype'] = 'AMMO_RIFLE',	['damagereason'] = 'Ended / Rifled / Shot down / Floored'},
	[`weapon_bullpuprifle`] 		 = {['name'] = 'weapon_bullpuprifle', 	 	['label'] = 'Bullpup Rifle', 				['weapontype'] = 'Assault Rifle',	['ammotype'] = 'AMMO_RIFLE',	['damagereason'] = 'Ended / Rifled / Shot down / Floored'},
	[`weapon_bullpuprifle_mk2`]		 = {['name'] = 'weapon_bullpuprifle_mk2', 	['label'] = 'Bull Puprifle MK2',			['weapontype'] = 'Assault Rifle',	['ammotype'] = 'AMMO_RIFLE',	['damagereason'] = 'Ended / Rifled / Shot down / Floored'},
	[`weapon_compactrifle`] 		 = {['name'] = 'weapon_compactrifle', 	 	['label'] = 'Compact Rifle', 				['weapontype'] = 'Assault Rifle',	['ammotype'] = 'AMMO_RIFLE',	['damagereason'] = 'Ended / Rifled / Shot down / Floored'},
	[`weapon_militaryrifle`]		 = {['name'] = 'weapon_militaryrifle', 		['label'] = 'Military Rifle',   			['weapontype'] = 'Assault Rifle',	['ammotype'] = 'AMMO_RIFLE',	['damagereason'] = 'Ended / Rifled / Shot down / Floored'},
    [`weapon_heavyrifle`] 			 = {['name'] = 'weapon_heavyrifle', 	 	['label'] = 'Heavy Rifle', 					['weapontype'] = 'Assault Rifle',	['ammotype'] = 'AMMO_RIFLE',	['damagereason'] = 'Ended / Rifled / Shot down / Floored'},

    -- Light Machine Guns
	[`weapon_mg`] 					 = {['name'] = 'weapon_mg', 			['label'] = 'Machinegun', 			['weapontype'] = 'Light Machine Gun',	['ammotype'] = 'AMMO_MG',	['damagereason'] = 'Machine gunned / Sprayed / Ruined'},
	[`weapon_combatmg`] 			 = {['name'] = 'weapon_combatmg', 		['label'] = 'Combat MG', 			['weapontype'] = 'Light Machine Gun',	['ammotype'] = 'AMMO_MG',	['damagereason'] = 'Machine gunned / Sprayed / Ruined'},
	[`weapon_combatmg_mk2`]	 		 = {['name'] = 'weapon_combatmg_mk2', 	['label'] = 'Combat MG MK2',	    ['weapontype'] = 'Light Machine Gun',	['ammotype'] = 'AMMO_MG',	['damagereason'] = 'Machine gunned / Sprayed / Ruined'},
	[`weapon_gusenberg`] 			 = {['name'] = 'weapon_gusenberg', 		['label'] = 'Thompson SMG', 		['weapontype'] = 'Light Machine Gun',	['ammotype'] = 'AMMO_MG',	['damagereason'] = 'Machine gunned / Sprayed / Ruined'},

    -- Sniper Rifles
	[`weapon_sniperrifle`] 			 = {['name'] = 'weapon_sniperrifle', 	 	['label'] = 'Sniper Rifle', 			['weapontype'] = 'Sniper Rifle',	['ammotype'] = 'AMMO_SNIPER',			['damagereason'] = 'Sniped / Picked off / Scoped'},
	[`weapon_heavysniper`] 			 = {['name'] = 'weapon_heavysniper', 	 	['label'] = 'Heavy Sniper', 			['weapontype'] = 'Sniper Rifle',	['ammotype'] = 'AMMO_SNIPER',			['damagereason'] = 'Sniped / Picked off / Scoped'},
	[`weapon_heavysniper_mk2`]		 = {['name'] = 'weapon_heavysniper_mk2', 	['label'] = 'Heavysniper MK2',	        ['weapontype'] = 'Sniper Rifle',	['ammotype'] = 'AMMO_SNIPER',			['damagereason'] = 'Sniped / Picked off / Scoped'},
	[`weapon_marksmanrifle`] 		 = {['name'] = 'weapon_marksmanrifle', 	 	['label'] = 'Marksman Rifle', 			['weapontype'] = 'Sniper Rifle',	['ammotype'] = 'AMMO_SNIPER',			['damagereason'] = 'Sniped / Picked off / Scoped'},
	[`weapon_marksmanrifle_mk2`]	 = {['name'] = 'weapon_marksmanrifle_mk2',	['label'] = 'Marksman Rifle MK2',	    ['weapontype'] = 'Sniper Rifle',	['ammotype'] = 'AMMO_SNIPER',			['damagereason'] = 'Sniped / Picked off / Scoped'},
	[`weapon_remotesniper`] 		 = {['name'] = 'weapon_remotesniper', 	 	['label'] = 'Remote Sniper', 			['weapontype'] = 'Sniper Rifle',	['ammotype'] = 'AMMO_SNIPER_REMOTE',	['damagereason'] = 'Sniped / Picked off / Scoped'},

    -- Heavy Weapons
	[`weapon_rpg`] 					 = {['name'] = 'weapon_rpg', 			      	['label'] = 'RPG', 						['weapontype'] = 'Heavy Weapons',	['ammotype'] = 'AMMO_RPG',				['damagereason'] = 'Killed / Exploded / Obliterated / Destroyed / Erased / Annihilated'},
	[`weapon_grenadelauncher`] 		 = {['name'] = 'weapon_grenadelauncher', 	  	['label'] = 'Grenade Launcher', 		['weapontype'] = 'Heavy Weapons',	['ammotype'] = 'AMMO_GRENADELAUNCHER',	['damagereason'] = 'Killed / Exploded / Obliterated / Destroyed / Erased / Annihilated'},
	[`weapon_grenadelauncher_smoke`] = {['name'] = 'weapon_grenadelauncher_smoke',	['label'] = 'Smoke Grenade Launcher',	['weapontype'] = 'Heavy Weapons',	['ammotype'] = 'AMMO_GRENADELAUNCHER',	['damagereason'] = 'Killed / Exploded / Obliterated / Destroyed / Erased / Annihilated'},
	[`weapon_minigun`] 				 = {['name'] = 'weapon_minigun', 		      	['label'] = 'Minigun', 					['weapontype'] = 'Heavy Weapons',	['ammotype'] = 'AMMO_MINIGUN',			['damagereason'] = 'Killed / Exploded / Obliterated / Destroyed / Erased / Annihilated'},
	[`weapon_firework`] 			 = {['name'] = 'weapon_firework', 		 	  	['label'] = 'Firework Launcher', 		['weapontype'] = 'Heavy Weapons',	['ammotype'] = nil,						['damagereason'] = 'Killed / Exploded / Obliterated / Destroyed / Erased / Annihilated'},
	[`weapon_railgun`] 				 = {['name'] = 'weapon_railgun', 		 	  	['label'] = 'Railgun', 					['weapontype'] = 'Heavy Weapons',	['ammotype'] = nil,						['damagereason'] = 'Killed / Exploded / Obliterated / Destroyed / Erased / Annihilated'},
	[`weapon_hominglauncher`] 		 = {['name'] = 'weapon_hominglauncher', 	 	['label'] = 'Homing Launcher', 			['weapontype'] = 'Heavy Weapons',	['ammotype'] = 'AMMO_STINGER',			['damagereason'] = 'Killed / Exploded / Obliterated / Destroyed / Erased / Annihilated'},
	[`weapon_compactlauncher`] 		 = {['name'] = 'weapon_compactlauncher',  	  	['label'] = 'Compact Launcher', 		['weapontype'] = 'Heavy Weapons',	['ammotype'] = nil,						['damagereason'] = 'Killed / Exploded / Obliterated / Destroyed / Erased / Annihilated'},
	[`weapon_rayminigun`]			 = {['name'] = 'weapon_rayminigun', 		 	['label'] = 'Ray Minigun',		        ['weapontype'] = 'Heavy Weapons',	['ammotype'] = 'AMMO_MINIGUN',			['damagereason'] = 'Killed / Exploded / Obliterated / Destroyed / Erased / Annihilated'},
    [`weapon_emplauncher`] 			 = {['name'] = 'weapon_emplauncher', 			['label'] = 'EMP Launcher', 			['weapontype'] = 'Heavy Weapons',	['ammotype'] = 'AMMO_EMPLAUNCHER',		['damagereason'] = 'Died'},

    -- Throwables
	[`weapon_grenade`] 		        = {['name'] = 'weapon_grenade', 		['label'] = 'Grenade', 			['weapontype'] = 'Throwable',	['ammotype'] = nil,				['damagereason'] = 'Bombed / Exploded / Detonated / Blew up'},
	[`weapon_bzgas`] 		        = {['name'] = 'weapon_bzgas', 			['label'] = 'BZ Gas', 			['weapontype'] = 'Throwable',	['ammotype'] = nil,				['damagereason'] = 'Died'},
	[`weapon_molotov`] 		        = {['name'] = 'weapon_molotov', 		['label'] = 'Molotov', 			['weapontype'] = 'Throwable',	['ammotype'] = nil,				['damagereason'] = 'Torched / Flambeed / Barbecued'},
	[`weapon_stickybomb`] 	        = {['name'] = 'weapon_stickybomb', 	    ['label'] = 'C4', 				['weapontype'] = 'Throwable',	['ammotype'] = nil,				['damagereason'] = 'Bombed / Exploded / Detonated / Blew up'},
	[`weapon_proxmine`] 	        = {['name'] = 'weapon_proxmine', 		['label'] = 'Proxmine Grenade', ['weapontype'] = 'Throwable',	['ammotype'] = nil,				['damagereason'] = 'Bombed / Exploded / Detonated / Blew up'},
	[`weapon_snowball`] 	        = {['name'] = 'weapon_snowball', 		['label'] = 'Snowball', 		['weapontype'] = 'Throwable',	['ammotype'] = nil,				['damagereason'] = 'Died'},
	[`weapon_pipebomb`] 	        = {['name'] = 'weapon_pipebomb', 		['label'] = 'Pipe Bomb', 		['weapontype'] = 'Throwable',	['ammotype'] = nil,				['damagereason'] = 'Bombed / Exploded / Detonated / Blew up'},
	[`weapon_ball`] 		        = {['name'] = 'weapon_ball', 			['label'] = 'Ball', 			['weapontype'] = 'Throwable',	['ammotype'] = 'AMMO_BALL',		['damagereason'] = 'Died'},
	[`weapon_smokegrenade`]         = {['name'] = 'weapon_smokegrenade', 	['label'] = 'Smoke Grenade', 	['weapontype'] = 'Throwable',	['ammotype'] = nil,				['damagereason'] = 'Died'},
	[`weapon_flare`] 		        = {['name'] = 'weapon_flare', 			['label'] = 'Flare pistol', 	['weapontype'] = 'Throwable',	['ammotype'] = 'AMMO_FLARE',	['damagereason'] = 'Died'},

    -- Miscellaneous
	[`weapon_petrolcan`] 			= {['name'] = 'weapon_petrolcan', 		 	['label'] = 'Petrol Can', 				['weapontype'] = 'Miscellaneous',	['ammotype'] = 'AMMO_PETROLCAN',		['damagereason'] = 'Died'},
	[`gadget_parachute`] 			= {['name'] = 'gadget_parachute', 		 	['label'] = 'Parachute', 				['weapontype'] = 'Miscellaneous',	['ammotype'] = nil,						['damagereason'] = 'Died'},
	[`weapon_fireextinguisher`] 	= {['name'] = 'weapon_fireextinguisher',	['label'] = 'Fire Extinguisher',		['weapontype'] = 'Miscellaneous',	['ammotype'] = nil,						['damagereason'] = 'Died'},
	[`weapon_hazardcan`]			= {['name'] = 'weapon_hazardcan',			['label'] = 'Hazardcan',			    ['weapontype'] = 'Miscellaneous',	['ammotype'] = 'AMMO_PETROLCAN',		['damagereason'] = 'Died'},
    [`weapon_fertilizercan`]		= {['name'] = 'weapon_fertilizercan',		['label'] = 'Fertilizer Can',			['weapontype'] = 'Miscellaneous',	['ammotype'] = 'AMMO_FERTILIZERCAN',	['damagereason'] = 'Died'},
	[`weapon_barbed_wire`]			= {['name'] = 'weapon_barbed_wire',			['label'] = 'Barbed Wire',				['weapontype'] = 'Miscellaneous',	['ammotype'] = nil,						['damagereason'] = 'Prodded'},
	[`weapon_drowning`]				= {['name'] = 'weapon_drowning',			['label'] = 'Drowning',					['weapontype'] = 'Miscellaneous',	['ammotype'] = nil,						['damagereason'] = 'Died'},
	[`weapon_drowning_in_vehicle`]	= {['name'] = 'weapon_drowning_in_vehicle',	['label'] = 'Drowning in a Vehicle',	['weapontype'] = 'Miscellaneous',	['ammotype'] = nil,						['damagereason'] = 'Died'},
	[`weapon_bleeding`]				= {['name'] = 'weapon_bleeding',			['label'] = 'Bleeding',					['weapontype'] = 'Miscellaneous',	['ammotype'] = nil,						['damagereason'] = 'Bled out'},
	[`weapon_electric_fence`]		= {['name'] = 'weapon_electric_fence',		['label'] = 'Electric Fence',			['weapontype'] = 'Miscellaneous',	['ammotype'] = nil,						['damagereason'] = 'Fried'},
	[`weapon_explosion`]			= {['name'] = 'weapon_explosion',			['label'] = 'Explosion',				['weapontype'] = 'Miscellaneous',	['ammotype'] = nil,						['damagereason'] = 'Killed / Exploded / Obliterated / Destroyed / Erased / Annihilated'},
	[`weapon_fall`]					= {['name'] = 'weapon_fall',				['label'] = 'Fall',						['weapontype'] = 'Miscellaneous',	['ammotype'] = nil,						['damagereason'] = 'Committed suicide'},
	[`weapon_exhaustion`]			= {['name'] = 'weapon_exhaustion',			['label'] = 'Exhaustion',				['weapontype'] = 'Miscellaneous',	['ammotype'] = nil,						['damagereason'] = 'Died'},
	[`weapon_hit_by_water_cannon`]	= {['name'] = 'weapon_hit_by_water_cannon',	['label'] = 'Water Cannon',				['weapontype'] = 'Miscellaneous',	['ammotype'] = nil,						['damagereason'] = 'Died'},
	[`weapon_rammed_by_car`]		= {['name'] = 'weapon_rammed_by_car',		['label'] = 'Rammed - Vehicle',			['weapontype'] = 'Miscellaneous',	['ammotype'] = nil,						['damagereason'] = 'Flattened / Ran over / Ran down'},
	[`weapon_run_over_by_car`]		= {['name'] = 'weapon_run_over_by_car',		['label'] = 'Run Over - Vehicle',		['weapontype'] = 'Miscellaneous',	['ammotype'] = nil,						['damagereason'] = 'Flattened / Ran over / Ran down'},
	[`weapon_heli_crash`]			= {['name'] = 'weapon_heli_crash',			['label'] = 'Heli Crash',				['weapontype'] = 'Miscellaneous',	['ammotype'] = nil,						['damagereason'] = 'Helicopter Crash'},
	[`weapon_fire`]					= {['name'] = 'weapon_fire',				['label'] = 'Fire',						['weapontype'] = 'Miscellaneous',	['ammotype'] = nil,						['damagereason'] = 'Torched / Flambeed / Barbecued'},

	-- Animals
    [`weapon_animal`]               = {['name'] = 'weapon_animal',	['label'] = 'Animal',	['weapontype'] = 'Animals',	['ammotype'] = nil,	['damagereason'] = 'Mauled'},
    [`weapon_cougar`]               = {['name'] = 'weapon_cougar',	['label'] = 'Cougar',	['weapontype'] = 'Animals',	['ammotype'] = nil,	['damagereason'] = 'Mauled'},
}

function OpenCloakroom()
    registerContext({
        id = 'cloakroom',
        title = 'Cloakroom',
        options = {
        {
            title = 'Civilian Wear',
            description = 'Your offduty civilian clothes',
            icon = 'hand',
            onSelect = function()
                ESX.TriggerServerCallback('esx_skin:getPlayerSkin', function(skin, jobSkin)
                    TriggerEvent('skinchanger:loadSkin', skin)
                end)
            end,
        },
        {
            title = 'Job Wear',
            description = 'Your onduty ambulance clothes',
            icon = 'hand',
            onSelect = function()
                ESX.TriggerServerCallback('esx_skin:getPlayerSkin', function(skin, jobSkin)
                    if skin.sex == 0 then
                        TriggerEvent('skinchanger:loadClothes', skin, jobSkin.skin_male)
                    else
                        TriggerEvent('skinchanger:loadClothes', skin, jobSkin.skin_female)
                    end
                end)
            end,
        },
        }
    })
    showContext('cloakroom')
end

RegisterNetEvent('osp_ambulance:SendBillEmail', function(amount)
    if GetActiveFramework() == 'qb' then
        SetTimeout(math.random(2500, 4000), function()
            local gender = GetLang().info.mr
            if GetPlayerData().charinfo.gender == 1 then
                gender = GetLang().info.mrs
            end
            local charinfo = GetPlayerData().charinfo
            TriggerServerEvent('qb-phone:server:sendNewMail', {
                sender = GetLang().mail.sender,
                subject = GetLang().mail.subject,
                message = GetLang().mail.message, {gender = gender, lastname = charinfo.lastname, costs = amount},
                button = {}
            })
        end)
    else
        -- Don't know if I should make anything here for esx
    end
end)

function inBed(ped)
    TaskPlayAnim(ped, inBedDict , inBedAnim, 8.0, 1.0, -1, 1, 0, 0, 0, 0 )
    SetEntityCoords(ped, bedOccupyingData.coords.x, bedOccupyingData.coords.y, bedOccupyingData.coords.z + 0.02)
    SetEntityInvincible(ped, true)
    Wait(500)
    FreezeEntityPosition(ped, true)
    SetEntityHeading(ped, bedOccupyingData.coords.w)

    SetEntityCoords(ped, bedOccupyingData.coords.x, bedOccupyingData.coords.y, bedOccupyingData.coords.z + 0.02)
    TaskPlayAnim(ped, inBedDict , inBedAnim, 8.0, 1.0, -1, 1, 0, 0, 0, 0 )


    local playerCoords = GetEntityCoords(ped)

end

function RestoreHospitalBedPose(ped)
    if not isInHospitalBed or not bedOccupyingData then
        return false
    end
    ped = ped or PlayerPedId()
    local coords = bedOccupyingData.coords
    FreezeEntityPosition(ped, false)
    SetEntityCoords(ped, coords.x, coords.y, coords.z + 0.02)
    SetEntityHeading(ped, coords.w)
    SetEntityRotation(ped, 0.0, 0.0, coords.w, 2, true)
    SetEntityInvincible(ped, true)
    loadAnimDict(inBedDict)
    TaskPlayAnim(ped, inBedDict, inBedAnim, 8.0, 1.0, -1, 1, 0, 0, 0, 0)
    FreezeEntityPosition(ped, true)
    SetEntityHeading(ped, coords.w)
    SetEntityRotation(ped, 0.0, 0.0, coords.w, 2, true)
    return true
end

function RecorrectHospitalBedAfterDeathState()
    if not isInHospitalBed then
        return
    end
    RestoreHospitalBedPose(PlayerPedId())
    CreateThread(function()
        Wait(50)
        if isInHospitalBed and BodyDamage and (BodyDamage.isDead or BodyDamage.inLastStand) then
            RestoreHospitalBedPose(PlayerPedId())
        end
        Wait(450)
        if isInHospitalBed and BodyDamage and (BodyDamage.isDead or BodyDamage.inLastStand) then
            RestoreHospitalBedPose(PlayerPedId())
        end
    end)
end

function stopExternalAnimations(ped)
    if IsEntityPlayingAnim(ped, "missminuteman_1ig_2", "handsup_base", 3) then
        StopAnimTask(ped,  "missminuteman_1ig_2", "handsup_base", 0)
    end
end

function playerCastAnimation(dict, anim, bodypart)
    local ped = PlayerPedId()
    local fractureStatus = BodyDamage.BodyPartDamage.Fractures[bodypart]
    CreateThread(function()
        lib.requestAnimDict(dict)
        while true do
            if not IsEntityPlayingAnim(ped, dict, anim, 3) then
                TaskPlayAnim(ped, dict, anim, 8.0, 1.0, -1, 1, 0, 0, 0, 0)
            end
            if fractureStatus ~= BodyDamage.BodyPartDamage.Fractures[bodypart] then
                ClearPedTasks(ped)
                break
            end
            Wait(100)
        end
    end)
end

CreateThread(function()
    if Config.EnableCosmeticCasts then
        SendNUIMessage(
            {
                EnableCosmeticCasts = true,
            }
        )
    end
end)

RegisterNetEvent('osp_ambulance:PlacedInStretcher', function()
    -- if you want to do something when placed in stretcher you can use this
end)

RegisterNetEvent('osp_ambulance:PutInVehicle', function(playerId)
    local ent = Player(playerId)
    local stat = ent.state.BodyDamage
    local ped = PlayerPedId()


    if not stat.Conscious and not stat.inBodybag then
        local closestPlayer = lib.getClosestPlayer(GetEntityCoords(ped), 3.0, true)
        if playerId then
            if isCarrying then
                isCarrying = false
                ClearPedTasksImmediately(PlayerPedId())
                DetachEntity(ped, true, false)
                local closestPlayer = lib.getClosestPlayer(GetEntityCoords(ped), 3.0, false)
                if playerId then
                    TriggerServerEvent('osp_ambulance:StopCarrySv', playerId)
                end
            end
            Wait(200)
            TriggerServerEvent('osp_ambulance:PutInSv', playerId)
        end
    else
        SendTextMessage(GetLang().interactions.medicalHeader, GetLang().error.not_conscious, 5000, "error")
    end
end)

RegisterNetEvent('osp_ambulance:GetOutVehicle', function(playerId)
    local ent = Player(playerId)
    local stat = ent.state.BodyDamage
    local ped = PlayerPedId()

    if not stat.Conscious and not stat.inBodybag then
        local closestPlayer = lib.getClosestPlayer(GetEntityCoords(ped), 3.0, true)
        if playerId then
            TriggerServerEvent('osp_ambulance:GetOutSv', playerId)
        end
    else
        SendTextMessage(GetLang().interactions.medicalHeader, GetLang().error.not_conscious, 5000, "error")
    end

end)

RegisterNetEvent('osp_ambulance:Carry', function(playerId)
    local ent = Player(playerId)
    local stat = ent.state.BodyDamage
    local ped = PlayerPedId()

    if not isCarrying then
        if not stat.inBodybag then
            isCarrying = true
            local closestPlayer = lib.getClosestPlayer(GetEntityCoords(ped), 3.0, false)
            if playerId then
                TriggerServerEvent('osp_ambulance:CarrySv', playerId)
                loadAnimDict('missfinale_c2mcs_1')
                TaskPlayAnim(ped, 'missfinale_c2mcs_1', 'fin_c2_mcs_1_camman', 8.0, 1.0, -1, 51, 0, 0, 0, 0)
                CreateThread(function()
                    while true do
                        if not IsEntityPlayingAnim(ped, 'missfinale_c2mcs_1', 'fin_c2_mcs_1_camman', 3) then
                            TaskPlayAnim(ped, 'missfinale_c2mcs_1', 'fin_c2_mcs_1_camman', 8.0, 1.0, -1, 51, 0, 0, 0, 0)
                        end
                        if isCarrying == false then
                            ClearPedTasksImmediately(PlayerPedId())
                            DetachEntity(PlayerPedId(), true, false)
                            break
                        end
                        if IsControlJustPressed(0, 73) then
                            isCarrying = false
                            ClearPedTasksImmediately(PlayerPedId())
                            DetachEntity(ped, true, false)
                            local closestPlayer = lib.getClosestPlayer(GetEntityCoords(ped), 3.0, false)
                            if playerId then
                                TriggerServerEvent('osp_ambulance:StopCarrySv', playerId)
                            end
                            break
                        end
                        Wait(25)
                    end
                end)
            else
                SendTextMessage(GetLang().interactions.medicalHeader, GetLang().error.no_player, 5000, "error")
            end
        end
    else
        isCarrying = false
        ClearPedTasksImmediately(PlayerPedId())
        DetachEntity(ped, true, false)
        local closestPlayer = lib.getClosestPlayer(GetEntityCoords(ped), 3.0, false)
        if playerId then
            TriggerServerEvent('osp_ambulance:StopCarrySv', playerId)
        end
    end

end)

RegisterNetEvent('osp_ambulance:PlacedInStretcher', function()
    -- if you want to do something when placed in stretcher you can use this
end)


function LoadBloodChairObjects()
    for id, _ in pairs(Config.Hospitals) do
        for _, chair in pairs(Config.Hospitals[id].donation) do
            RequestModel(chair.model)
            while not HasModelLoaded(chair.model) do
                Wait(100)
            end
            local bloodChair = CreateObject(chair.model, chair.coords.x, chair.coords.y, chair.coords.z - 1.0, true, false, false)
            if bloodChair then
                SetEntityHeading(bloodChair, (chair.coords.w-180.0))
            else
                print("Failed to load blood chair", chair)
            end
        end
    end
end

function InBloodChair(chair)
    -- Edit this if you would like to do something else to the player when interacting with the blood donation zone/target, default is to simulate the player to sit in a chair

    loadAnimDict("amb@code_human_train_driver@base")

    DoScreenFadeOut(1000)
    while not IsScreenFadedOut() do
        Wait(100)
    end

    FreezeEntityPosition(PlayerPedId(), true)
    SetEntityCoords(PlayerPedId(), chair.coords.x, chair.coords.y, (chair.coords.z - (Config.BloodChairOffsetZ or 0.0)))
    SetEntityHeading(PlayerPedId(), chair.coords.w)
    TaskPlayAnim(PlayerPedId(), "amb@code_human_train_driver@base", "sit", 8.0, -8.0, -1, 1, 0, false, false, false)

    DoScreenFadeIn(1000)

    CreateThread(function()
        while BodyDamage.bInChair do
            if not IsEntityPlayingAnim(PlayerPedId(), "amb@code_human_train_driver@base", "sit", 3) then
                ClearPedTasks(PlayerPedId())
                TaskPlayAnim(PlayerPedId(), "amb@code_human_train_driver@base", "sit", 8.0, -8.0, -1, 1, 0, false, false, false)
            end

            local playerCoords = GetEntityCoords(PlayerPedId())
            local chairCoords = vector3(chair.coords.x, chair.coords.y, chair.coords.z)

            local distance = #(playerCoords - chairCoords)

            if distance > 2.0 then
                SetEntityCoords(PlayerPedId(), chair.coords.x, chair.coords.y, (chair.coords.z - (Config.BloodChairOffsetZ or 0.0)))
                SetEntityHeading(PlayerPedId(), chair.coords.w)
            end
            Wait(1000)
        end
    end)
end

function OutBloodChair(chair)
    -- Edit this if you would like to do something else to the player when cancelling the logic in the function above, default is to reset the player and move them out of the chair

    DoScreenFadeOut(1000)
    while not IsScreenFadedOut() do
        Wait(100)
    end

    local ped = PlayerPedId()
    local outCoords = GetOffsetFromEntityInWorldCoords(ped, vector3(0.0, chair.getOutOffset or 0.8, 0.0))

    FreezeEntityPosition(ped, false)
    SetEntityCoords(ped, outCoords.x, outCoords.y, outCoords.z)
    ClearPedTasks(ped)
    DoScreenFadeIn(1000)
end

dynamicActionAnimActive = false
dynamicActionAnimToken = 0

function stopDynamicActionAnimations()
    dynamicActionAnimActive = false
    dynamicActionAnimToken = dynamicActionAnimToken + 1
    ClearPedTasks(PlayerPedId())
end

function dynamicActionAnimations(targetPlayer, animtime)
    local srcPed = PlayerPedId()
    local targetPed = GetPlayerPed(GetPlayerFromServerId(targetPlayer))
    if not targetPed or not DoesEntityExist(targetPed) then print('returning') return end

    -- Invalidate any previous keep-alive thread
    dynamicActionAnimActive = false
    dynamicActionAnimToken = dynamicActionAnimToken + 1
    local animToken = dynamicActionAnimToken

    local animDict = nil
    local animName = nil
    local animLib = nil

    local anims = {
        dead = {dict = "dead", substr = {"dead", "dies", "corpse", "lay", "death", "bodybag"}},
        move_injured_ground = {dict = "move_injured_ground", substr = {"front_loop"}},
        laststand = {dict = lastStandDict, substr = {lastStandAnim}},
        lying = {dict = "anim@gangops@morgue@table@", substr = {"body_search", "table"}},
        idle = {dict = "amb@world_human_hang_out_street@male_b@idle_a", substr={"idle"}},
        sit = {dict="anim@heists@prison_heistunfinished_biztarget_idle", substr={"idle_c"}},
        -- add more cases as needed
    }

    local foundAnimType = nil
    for dictType,animData in pairs(anims) do
        for i = 0, GetNumberOfPedDrawableVariations(targetPed, 0) do
            if IsEntityPlayingAnim(targetPed, animData.dict, animData.substr[1], 3) then
                foundAnimType = dictType
                break
            end
        end
        if foundAnimType then break end
    end

    local srcCoords = GetEntityCoords(srcPed)
    local tgtCoords = GetEntityCoords(targetPed)
    local distance = #(srcCoords - tgtCoords)
    local dz = srcCoords.z - tgtCoords.z

    --print('Z value', dz)
    -- Get the ground Z under the targetPed and use it to get the center coords above ground
    local tgtPos = GetEntityCoords(targetPed)
    local found, groundZ = GetGroundZFor_3dCoord(tgtPos.x, tgtPos.y, tgtPos.z, 0)
    -- Get coordinates of the ground under the ped
    local groundCoord = vector3(tgtPos.x, tgtPos.y, groundZ)
    -- Get head bone index and coords
    local headBone = GetPedBoneIndex(targetPed, 0x796e) -- Head bone
    local headCoord = GetWorldPositionOfEntityBone(targetPed, headBone)
    local heightCoord = headCoord - groundCoord


    -- Pick animation for source player, based on target's animation & offsets
    local actionAnim = nil
    local actionDict = nil


    -- local actionDict = 'amb@world_human_clipboard@male@idle_a'
    -- local actionAnim = "idle_a"

    local flag = 1
    local function triggerAnimation()
        if targetPlayer == GetPlayerServerId(PlayerId()) then
            actionDict = 'anim@heists@narcotics@funding@gang_idle'
            actionAnim = 'gang_chatting_idle01'
        elseif foundAnimType == 'dead' or oundAnimType == 'move_injured_ground' or oundAnimType == 'laststand' or heightCoord.z < 1.0 then
            -- If target is dead, play kneel and inspect/check animation
            -- actionDict = "amb@medic@standing@kneel@base"
            -- actionAnim = "base"
            actionDict = 'anim@heists@narcotics@funding@gang_idle'
            actionAnim = 'gang_chatting_idle01'
        elseif foundAnimType == 'lying' then
            actionDict = 'anim@heists@narcotics@funding@gang_idle'
            actionAnim = 'gang_chatting_idle01'
        elseif distance > 2.0 then
            -- If far, approach/jog animation
            -- Move the source ped close to the target ped before doing an animation
            TaskGoStraightToCoord(srcPed, tgtCoords.x, tgtCoords.y, tgtCoords.z, 1.0, -1, GetEntityHeading(srcPed), 0.0)
            TaskTurnPedToFaceEntity(srcPed, targetPed, -1)
            -- Wait until the ped is close enough (or add a timeout if desired)
            distance = 1
            while #(GetEntityCoords(srcPed) - tgtCoords) > 1.0 do
                Wait(10)
            end
            triggerAnimation()
        elseif dz > 1.0 then
            -- If significantly above, look up or reach up
            actionDict = "random@car_thief@waiting_ig_4"
            actionAnim = "lookout"
        elseif foundAnimType == "sit" or heightCoord.z < 1.4 then
            -- If sitting, lean forward and talk
           actionDict = "amb@medic@standing@kneel@base"
            actionAnim = "base"
        else
            -- Default standing action
            actionDict = 'anim@heists@narcotics@funding@gang_idle'
            actionAnim = 'gang_chatting_idle01'
            flag = 16
        end
    end
    triggerAnimation()
    --print('playering', actionDict, actionAnim)
    if actionDict and actionAnim then
        lib.requestAnimDict(actionDict, 1000)
        -- Loop until stopDynamicActionAnimations() (covers minigame + progress bar)
        dynamicActionAnimActive = true
        TaskPlayAnim(srcPed, actionDict, actionAnim, 8.0, 8.0, -1, flag, 0, false, false, false)
        CreateThread(function()
            while dynamicActionAnimActive and dynamicActionAnimToken == animToken do
                if not IsEntityPlayingAnim(srcPed, actionDict, actionAnim, 3) then
                    TaskPlayAnim(srcPed, actionDict, actionAnim, 8.0, 8.0, -1, flag, 0, false, false, false)
                end
                Wait(500)
            end
        end)
    end
end




function dynamicMinigameActions(action, opts)
    opts = opts or {}

    local minigames = {
        ["bandage"] = {
            type = "nui",
            game = "bandage",
        },
        ["quickclot"] = {
            type = "nui",
            game = "quickclot",
        },
        ["tourniquet"] = {
            type = "skillcheck",
            difficulty = {"easy"},
        },
        ["infusion"] = {
            type = "skillcheck",
            difficulty = {"easy"},
        },
        ["medication"] = {
            type = "skillcheck",
            difficulty = {"easy"},
        },
        ["sewing"] = {
            type = "nui",
            game = "sewing",
        },
        ["custom"] = {
            type = "skillcheck",
            difficulty = {"easy"},
        },
        -- Add more as needed
    }

    -- QuickClot uses a wound-packing minigame instead of the bandage wrap path
    if opts.item == 'quick_clot' and action == 'bandage' then
        action = 'quickclot'
    end

    local settings = minigames[action]
    if not settings then
        print(("No minigame defined for action: %s"):format(tostring(action)))
        return true -- Allow unknown actions by default
    end

    if settings.type == "skillcheck" then
        return lib.skillCheck(settings.difficulty)
    elseif settings.type == "nui" then
        local payload = {
            type = settings.game,
            item = opts.item,
            title = opts.title,
        }

        if settings.game == "bandage" then
            local wraps = 4
            if opts.item == 'elastic_bandage' then
                wraps = 5
            elseif opts.item == 'packing_bandage' then
                wraps = 3
            elseif opts.item == 'field_dressing' then
                wraps = 4
            end
            payload.wraps = opts.wraps or wraps
        elseif settings.game == "quickclot" then
            payload.title = opts.title or "Pack QuickClot"
        elseif settings.game == "sewing" then
            payload.title = opts.title or "Sew Injuries"
            payload.stitches = opts.stitches or 6
        end

        -- Path / packing / suture minigames need mouse cursor / NUI focus
        return runNuiMinigame(settings.game, payload, { cursor = true })
    else
        print("Unknown minigame type: " .. tostring(settings.type))
        return true
    end
end

function createBypassItemTable()
    local tbl = {}
    if not IsEmsStaff() then return tbl end
    local medicationDataWithoutFunctions = deepCopyWithoutFunctions(Config.Medication)
    for k, v in pairs(medicationDataWithoutFunctions) do
        table.insert(tbl, {
            item = v.itemName,
            amount = 999
        })
    end
    for _, v in pairs(Config.bloodTypes) do
        table.insert(tbl, {
            item = 'blood250ml_' .. v.itemName,
            amount = 999
        })
        table.insert(tbl, {
            item = 'blood500ml_' .. v.itemName,
            amount = 999
        })
    end
    table.insert(tbl, { item = 'bodybag', amount = 999 })
    table.insert(tbl, { item = 'revivekit', amount = 999 })
    return tbl
end

RegisterNetEvent('osp_ambulance:usePrescriptionMedication', function(itemName)
    local medicationConfig = nil
    for _, medication in pairs(Config.PrescriptionMedications or {}) do
        if medication.itemName == itemName then
            medicationConfig = medication
            break
        end
    end

    if not medicationConfig then return end

    local dict = 'anim@scripted@npc@freemode@ig1_cook_lab@flask_rack@'
    local anim = 'idle_01'


    local playerPed = PlayerPedId()
    local medProp = medicationConfig.prop or "v_club_vu_pills" -- fallback to pill bottle
    local bone = 18905 -- hand bone
    local object = nil

    lib.requestModel(medProp, 1000)

    object = CreateObject(medProp, GetEntityCoords(playerPed), true, true, false)
    SetEntityCollision(object, false, true)
    AttachEntityToEntity(object, playerPed, GetPedBoneIndex(PlayerPedId(), 18905), 0.1, 0.0, 0.0, 0.0, 0.0, 0.0, true, true, false, true, 1, true)

    CreateThread(function()
        Wait(4200)
        if DoesEntityExist(object) then
            DeleteObject(object)
        end
        SetModelAsNoLongerNeeded(medProp)
    end)


    if not ProgressBar(GetLang().prescriptions.consuming, 4000, dict, anim) then
        if DoesEntityExist(object) then
            DeleteObject(object)
        end
        return
    end

    TriggerServerEvent('osp_ambulance:removeItem', itemName, 1)

    SuppressConditionsForMedication(itemName)

    if medicationConfig.effects then
        ApplyMedicationEffects(medicationConfig.effects)
    elseif itemName == 'cough_syrup' then
        ClearPedTasks(PlayerPedId())
    elseif itemName == 'xanax' then
        TriggerServerEvent('hud:server:RelieveStress', 80)
        StopGameplayCamShaking(true)
    elseif itemName == 'melatonin' then
        ResetInsomniaMovement()
        RestorePlayerStamina(PlayerId(), 50.0)
    end

    SaveBodyDamage(GetPlayerServerId(NetworkGetPlayerIndexFromPed(PlayerPedId())), BodyDamage)

    TriggerServerEvent('osp_ambulance:recordDrugUseSv', itemName, 'prescription')
end)

RegisterNetEvent("osp_ambulance:medicationCl")
AddEventHandler("osp_ambulance:medicationCl", function(item, data)
    Wait(1000)
    if BodyDamage.hrIncrease >= 20 then
        SendNUIMessage(
            {
                rapidheartbeat = true,
            }
        )
    elseif BodyDamage.hrDecrease >= 30 then
        SendNUIMessage(
            {
                slowheartbeat = true,
            }
        )
    end
end)

local savedStrippedClothes = {}
local savedStrippedProps = {}
local STRIP_COMPONENTS = { 1, 3, 4, 5, 6, 7, 8, 9, 10, 11 }

local function savePlayerOutfit(ped)
    savedStrippedClothes = {}
    for _, component in ipairs(STRIP_COMPONENTS) do
        savedStrippedClothes[component] = {
            drawable = GetPedDrawableVariation(ped, component),
            texture = GetPedTextureVariation(ped, component),
            palette = GetPedPaletteVariation(ped, component),
        }
    end
    savedStrippedProps = {}
    for i = 0, 7 do
        if GetPedPropIndex(ped, i) ~= -1 then
            savedStrippedProps[i] = {
                drawable = GetPedPropIndex(ped, i),
                texture = GetPedPropTextureIndex(ped, i),
            }
        end
    end
end

local function applyStrippedOutfit(ped, saveOutfit)
    if saveOutfit then
        savePlayerOutfit(ped)
    end
    local model = GetEntityModel(ped)
    if model == GetHashKey('mp_m_freemode_01') then
        SetPedComponentVariation(ped, 1, 0, 0, 0)
        SetPedComponentVariation(ped, 3, 15, 0, 0)
        SetPedComponentVariation(ped, 4, 14, 0, 0)
        SetPedComponentVariation(ped, 5, 0, 0, 0)
        SetPedComponentVariation(ped, 6, 34, 0, 0)
        SetPedComponentVariation(ped, 7, 0, 0, 0)
        SetPedComponentVariation(ped, 8, 15, 0, 0)
        SetPedComponentVariation(ped, 9, 0, 0, 0)
        SetPedComponentVariation(ped, 10, 0, 0, 0)
        SetPedComponentVariation(ped, 11, 15, 0, 0)
    elseif model == GetHashKey('mp_f_freemode_01') then
        SetPedComponentVariation(ped, 1, 0, 0, 0)
        SetPedComponentVariation(ped, 3, 15, 0, 0)
        SetPedComponentVariation(ped, 4, 15, 0, 0)
        SetPedComponentVariation(ped, 5, 0, 0, 0)
        SetPedComponentVariation(ped, 6, 35, 0, 0)
        SetPedComponentVariation(ped, 7, 0, 0, 0)
        SetPedComponentVariation(ped, 8, 15, 0, 0)
        SetPedComponentVariation(ped, 9, 0, 0, 0)
        SetPedComponentVariation(ped, 10, 0, 0, 0)
        SetPedComponentVariation(ped, 11, 15, 0, 0)
    else
        for _, component in ipairs(STRIP_COMPONENTS) do
            SetPedComponentVariation(ped, component, 0, 0, 0)
        end
    end
    for i = 0, 7 do
        ClearPedProp(ped, i)
    end
end

local function restorePlayerOutfit(ped)
    if next(savedStrippedClothes) then
        for component, saved in pairs(savedStrippedClothes) do
            SetPedComponentVariation(ped, component, saved.drawable, saved.texture, saved.palette)
        end
        for propId, saved in pairs(savedStrippedProps) do
            SetPedPropIndex(ped, propId, saved.drawable, saved.texture, true)
        end
        savedStrippedClothes = {}
        savedStrippedProps = {}
    else
        TriggerEvent('qb-clothing:loadPlayerSkin')
        TriggerEvent('illenium-appearance:client:reloadSkin')
    end
end

RegisterNetEvent('osp_ambulance:ToggleStrippedClothesCl', function(strip)
    local ped = PlayerPedId()
    if strip then
        applyStrippedOutfit(ped, true)
        BodyDamage.clothesStripped = true
    else
        restorePlayerOutfit(ped)
        BodyDamage.clothesStripped = false
    end
    SaveBodyDamage(GetPlayerServerId(NetworkGetPlayerIndexFromPed(PlayerPedId())), BodyDamage)
end)

RegisterNetEvent('osp_ambulance:restoreStrippedClothesAppearance', function()
    if not BodyDamage.clothesStripped then return end
    restorePlayerOutfit(PlayerPedId())
    BodyDamage.clothesStripped = false
    SaveBodyDamage(GetPlayerServerId(NetworkGetPlayerIndexFromPed(PlayerPedId())), BodyDamage)
end)




RegisterCommand("bloodtype", function()
    if BodyDamage and BodyDamage.bloodType then
        print("Your blood type is: " .. tostring(BodyDamage.bloodType))
        TriggerEvent('chat:addMessage', {
            color = { 255, 0, 0},
            multiline = true,
            args = {"Blood Type", "Your blood type is: " .. tostring(BodyDamage.bloodType)}
        })
    else
        print("Blood type not available.")
        TriggerEvent('chat:addMessage', {
            color = { 255, 0, 0},
            multiline = true,
            args = {"Blood Type", "Blood type not available."}
        })
    end
end, false)


