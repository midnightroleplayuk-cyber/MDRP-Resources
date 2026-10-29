if GetResourceState('qb-core') ~= 'started' then return end

QBCore = exports['qb-core']:GetCoreObject()

function ShowNotification(text)
	QBCore.Functions.Notify(text)
end

function CanAccessGroup(data)
    if not data then return true end
    local pdata = QBCore.Functions.GetPlayerData()
    for k,v in pairs(data) do 
        if (pdata.job.name == k and pdata.job.grade.level >= v) then return true end
    end
    return false
end 

function GetPlayersInArea(coords, radius)
    local coords = coords or GetEntityCoords(PlayerPedId())
    local radius = radius or 3.0
    local list = QBCore.Functions.GetPlayersFromCoords(coords, radius)
    local players = {}
    for _, player in pairs(list) do 
        if player ~= PlayerId() then
            players[#players + 1] = player
        end
    end
    return players
end


function ToggleOutfit(onduty)
    if onduty then 
        local outfits = Config.BountyHunters.outfits
        local gender = QBCore.Functions.GetPlayerData().charinfo.gender
        local outfit = gender == 1 and outfits.female or outfits.male
        if not outfit then return end 
        TriggerEvent('qb-clothing:client:loadOutfit', {outfitData = outfit})
    else
        TriggerServerEvent("qb-clothes:loadPlayerSkin")
    end
end

function ResetClothes()
    TriggerServerEvent("qb-clothes:loadPlayerSkin")
end

function Revive()
    TriggerEvent("hospital:client:Revive")
    TriggerServerEvent("hospital:server:resetHungerThirst")
end

function Kill()
    SetEntityHealth(PlayerPedId(), 0)
end

RegisterNetEvent(GetCurrentResourceName()..":showNotification", function(text)
    ShowNotification(text)
end)

RegisterNetEvent('QBCore:Client:OnPlayerLoaded', function()
    TriggerServerEvent("pickle_clubs:initializePlayer")
end)

-- Drunk Effects System
local CurrentAlcoholLevel = 0.0 -- Current alcohol level as proportion of alcoholPerDrink
local IsDrunkEffectsActive = false
local CurrentWalkCycle = nil
local DrunkEffectsThread = nil

-- Function to get current drunk level category
local function GetDrunkLevel()
    if not Config.DrunkEffects or not Config.DrunkEffects.enabled then return "none" end
    
    local thresholds = Config.DrunkEffects.thresholds
    if CurrentAlcoholLevel >= thresholds.extreme then
        return "extreme"
    elseif CurrentAlcoholLevel >= thresholds.heavy then
        return "heavy"
    elseif CurrentAlcoholLevel >= thresholds.moderate then
        return "moderate"
    elseif CurrentAlcoholLevel >= thresholds.light then
        return "light"
    elseif CurrentAlcoholLevel > 0.0 then
        -- Return "light" even below threshold to start effects immediately
        return "light"
    else
        return "none"
    end
end

-- Smoothly scale intensity from 0.0 to 1.0 based on alcohol level
local function GetDrunkIntensity()
    local maxLevel = Config.DrunkEffects.maxAlcoholLevel or 0.50
    return math.min(1.0, CurrentAlcoholLevel / math.max(0.01, maxLevel))
end

-- Function to apply visual effects
local function ApplyVisualEffects(level)
    if not Config.DrunkEffects or not Config.DrunkEffects.enabled or not Config.DrunkEffects.visualEffects then
        ClearTimecycleModifier()
        ClearExtraTimecycleModifier()
        return
    end

    local ped = PlayerPedId()

    if CurrentAlcoholLevel > 0.0 then
        local intensity = GetDrunkIntensity()

        SetTimecycleModifier("drug_wobbly")
        SetTimecycleModifierStrength(intensity)

        SetPedMotionBlur(ped, true)
        SetPedIsDrunk(ped, true)
    else
        ClearTimecycleModifier()
        ClearExtraTimecycleModifier()
        SetPedMotionBlur(ped, false)
        SetPedIsDrunk(ped, false)
    end
end

-- Function to apply camera shake
local function ApplyCameraShake(level)
    if not Config.DrunkEffects or not Config.DrunkEffects.enabled or not Config.DrunkEffects.cameraShake then
        StopGameplayCamShaking(true)
        return
    end

    if CurrentAlcoholLevel > 0.0 then
        local intensity = GetDrunkIntensity()
        ShakeGameplayCam("DRUNK_SHAKE", intensity)
    else
        StopGameplayCamShaking(true)
    end
end

-- Function to apply walk cycle
local function ApplyWalkCycle(level)
    if not Config.DrunkEffects or not Config.DrunkEffects.enabled or not Config.DrunkEffects.enableWalkCycles then 
        -- If walk cycles are disabled, ensure we reset if one was active
        if CurrentWalkCycle then
            local ped = PlayerPedId()
            ResetPedMovementClipset(ped, 0.25)
            CurrentWalkCycle = nil
        end
        return 
    end
    
    local ped = PlayerPedId()
    
    if level == "none" then
        -- Reset walk cycle to default
        if CurrentWalkCycle then
            ResetPedMovementClipset(ped, 0.25)
            CurrentWalkCycle = nil
            
        end
        return
    end
    
    local walkCycleClipset = Config.DrunkEffects.walkCycles[level]
    if not walkCycleClipset then return end
    
    -- Only change if different from current
    if CurrentWalkCycle ~= level then
        RequestAnimSet(walkCycleClipset)
        while not HasAnimSetLoaded(walkCycleClipset) do
            Wait(0)
        end
        
        SetPedMovementClipset(ped, walkCycleClipset, 0.25)
        CurrentWalkCycle = level
        
    end
end

-- Main drunk effects thread
local function StartDrunkEffectsThread()
    if DrunkEffectsThread then return end
    
    DrunkEffectsThread = CreateThread(function()
        while Config.DrunkEffects and Config.DrunkEffects.enabled and CurrentAlcoholLevel > 0.0 do
            Wait(0) -- Update every frame for smooth effects
            
            local level = GetDrunkLevel()
            
            -- Apply all effects every frame
            ApplyVisualEffects(level)
            ApplyCameraShake(level)
            ApplyWalkCycle(level)
            
        end
        
        -- Cleanup when alcohol reaches 0 (ensure walk cycle is reset)
        local ped = PlayerPedId()
        local level = GetDrunkLevel() -- Should be "none" at this point
        
        -- Explicitly reset walk cycle
        ApplyWalkCycle(level) -- This will handle the reset if level is "none"
        
        -- Additional cleanup
        ClearTimecycleModifier()
        ClearExtraTimecycleModifier()
        StopGameplayCamShaking(true)
        SetPedMotionBlur(ped, false)
        SetPedIsDrunk(ped, false)
        
        -- Ensure walk cycle is reset even if ApplyWalkCycle didn't catch it
        if CurrentWalkCycle then
            ResetPedMovementClipset(ped, 0.25)
            CurrentWalkCycle = nil
        end
        
        
        DrunkEffectsThread = nil
        IsDrunkEffectsActive = false
    end)
end

-- Alcohol decay thread
CreateThread(function()
    while true do
        Wait(Config.DrunkEffects and Config.DrunkEffects.decayInterval or 1000)
        
        if Config.DrunkEffects and Config.DrunkEffects.enabled and CurrentAlcoholLevel > 0.0 then
            local decayAmount = Config.DrunkEffects.decayRate * (Config.DrunkEffects.decayInterval / 1000)
            CurrentAlcoholLevel = math.max(0.0, CurrentAlcoholLevel - decayAmount)
            
            -- Start effects thread if not already running
            if CurrentAlcoholLevel > 0.0 and not IsDrunkEffectsActive then
                IsDrunkEffectsActive = true
                StartDrunkEffectsThread()
            end
        end
    end
end)

-- Cleanup on resource stop
AddEventHandler('onResourceStop', function(resourceName)
    if GetCurrentResourceName() ~= resourceName then return end
    
    -- Reset all drunk effects
    CurrentAlcoholLevel = 0.0
    local ped = PlayerPedId()
    ClearTimecycleModifier()
    ClearExtraTimecycleModifier()
    StopGameplayCamShaking(true)
    SetPedMotionBlur(ped, false)
    SetPedIsDrunk(ped, false)
    
    if CurrentWalkCycle then
        ResetPedMovementClipset(ped, 0.0)
        CurrentWalkCycle = nil
    end
    
    IsDrunkEffectsActive = false
    DrunkEffectsThread = nil
end)

RegisterNetEvent("pickle_clubs:addAlcohol", function(amount)
    -- amount is now the raw alcohol value (e.g. 0.05 for a full drink at 5%)
    if Config.DrunkEffects and Config.DrunkEffects.enabled then
        CurrentAlcoholLevel = CurrentAlcoholLevel + amount

        -- Start effects thread immediately if not already running
        if CurrentAlcoholLevel > 0.0 and not IsDrunkEffectsActive then
            IsDrunkEffectsActive = true
            StartDrunkEffectsThread()
        end

    end

    -- Evidence system (existing functionality)
    if amount < 0.5 then
        TriggerEvent('evidence:client:SetStatus', 'alcohol', 600)
    else
        TriggerEvent('evidence:client:SetStatus', 'heavyalcohol', 600)
        TriggerEvent('evidence:client:SetStatus', 'widepupils', 600)
    end
end)

-- Inventory Fallback

CreateThread(function()
    Wait(100)
    
    if InitializeInventory then return InitializeInventory() end -- Already loaded through inventory folder.

    Inventory = {}

    Inventory.Items = {}
    
    Inventory.Ready = false
    
    RegisterNetEvent("pickle_clubs:setupInventory", function(data)
        Inventory.Items = data.items
        Inventory.Ready = true
    end)
    
    RegisterNetEvent("pickle_clubs:updateInventory", function(inventory) 
        -- RefreshInventory(inventory)
    end)
end)