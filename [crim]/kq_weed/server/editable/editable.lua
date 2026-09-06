-- Base player framework functions
function RemovePlayerMoney(player, amount)
    local success = exports.kq_link:RemovePlayerMoney(player, amount)

    return success
end

function AddPlayerMoney(player, amount)
    local success = exports.kq_link:AddPlayerMoney(player, amount)

    return success
end

function RemovePlayerItem(player, item, amount)
    local success, itemsMetadata = exports.kq_link:RemovePlayerItem(player, item, amount or 1)

    return success, itemsMetadata
end

function GetPlayerItemData(player, item, meta)
    local success = exports.kq_link:GetPlayerItemData(player, item, meta)

    return success
end

function AddPlayerItem(player, item, amount, meta)
    local success = exports.kq_link:AddPlayerItem(player, item, amount or 1, meta)

    return success
end

function AddPlayerItemToFit(player, item, amount, meta)
    local success = exports.kq_link:AddPlayerItemToFit(player, item, amount or 1, meta)

    return success
end


-- License/Admins
function GetPlayerLicense(player)
    return GetPlayerIdentifierByType(player, 'license')
end

-- Used for allowing to pickup all pots/tables
function IsPlayerAdmin(player)
    return IsPlayerAceAllowed(player, 'command')
end

-- Player skill checks
SkillChecks = {
    --- PLANTS
    -- Whether the player is allowed to plant weed
    CanPlayerPlantWeed = function(player)
        return true
    end,
    -- Whether the player is allowed to water plants
    CanPlayerWaterPlant = function(player)
        return true
    end,
    -- Whether the player is allowed to spray pesticide
    CanSprayInsects = function(player)
        return true
    end,
    -- Whether the player is allowed to fertilize plants
    CanPlayerFertilizePlant = function(player)
        return true
    end,
    -- Whether the player is allowed to collect plants
    CanPlayerCollectPlant = function(player)
        return true
    end,
    -- Whether the player is allowed to destroy plants
    CanPlayerDestroyPlant = function(player)
        return true
    end,

    --- WILD WEED
    -- Whether the player is allowed to collect wild weed plants
    CanCollectWildWeed = function(player)
        return true
    end,

    --- TABLES
    -- Whether the player is allowed to bag the weed
    CanPlayerBagWeed = function(player)
        return true
    end,
    -- Whether the player is allowed to roll joints
    CanPlayerRollJoints = function(player)
        return true
    end,

    --- PRESS
    -- Whether the player is allowed to bag the weed
    CanPlayerPressBricks = function(player)
        return true
    end,
}

-- Dummy functions which get triggered when certain actions happen. Allowing you to do trigger additional events. Add XP, extra items, unlock skills etc.
Dummy = {
    PlantSeeded = function(player, weedType, potTag)
        return
    end,
    PlantWatered = function(player, potTag)
        return
    end,
    PlantFertilized = function(player, fertilizerType, potTag)
        return
    end,
    PlantCollected = function(player, weedType, potTag)
        return
    end,

    WeedBagged = function(player, weedType, amount)
        return
    end,
    JointsRolled = function(player, weedType, amount)
        return
    end,

    BrickPressed = function(player, weedType)
        return
    end,
}

-- GrowOp/Lockup access
function CanOpenGrowOp(player, locationData)
    if locationData.jobs then
        local jobs = {}

        if type(locationData.jobs) == 'table' then
            jobs = locationData.jobs
        else
            jobs = { locationData.jobs }
        end

        local players = exports.kq_link:GetPlayersWithJob(locationData.jobs)
        if not table.contains(players, player) then
            return false
        end
    end

    if locationData.requiredItem then
        if exports.kq_link:GetPlayerItemCount(player, locationData.requiredItem) <= 0 then
            return false
        end
    end

    return true
end

function CanOpenLockup(player, locationData)
    if locationData.jobs then
        local jobs = {}

        if type(locationData.jobs) == 'table' then
            jobs = locationData.jobs
        else
            jobs = { locationData.jobs }
        end

        local players = exports.kq_link:GetPlayersWithJob(locationData.jobs)
        if not table.contains(players, player) then
            return false
        end
    end

    if locationData.requiredItem then
        if exports.kq_link:GetPlayerItemCount(player, locationData.requiredItem) <= 0 then
            return false
        end
    end

    return true
end


-- Usable items

function IsAllowedToPlace(player, coords, objectType)
    local checks = Config.placing.checks

    coords = coords or GetEntityCoords(GetPlayerPed(player))

    if checks.onlyInNonDefaultRoutingBucket then
        if GetPlayerRoutingBucket(player) == 0 then
            return false, L('placement.cant_place', { name = L('placement.' .. objectType) })
        end
    end

    if checks.limits and checks.limits.enabled then
        local playersPlacedAmount = GetPlayerPlacedAmount(player, objectType)
        if objectType == 'pot' then
            if playersPlacedAmount >= checks.limits.maxPots then
                return false, L('placement.cant_place_limit', { name = L('placement.' .. objectType) })
            end
        elseif objectType == 'table' then
            if playersPlacedAmount >= checks.limits.maxTables then
                return false, L('placement.cant_place_limit', { name = L('placement.' .. objectType) })
            end
        elseif objectType == 'press' then
            if playersPlacedAmount >= checks.limits.maxPresses then
                return false, L('placement.cant_place_limit', { name = L('placement.' .. objectType) })
            end
        end
    end

    if checks.housing.enabled then
        if checks.housing.system == 'nolag_properties' then
            if not (Player(player).state.insideArea or Player(player).state.currentProperty or Player(player).state.propertyId) then
                return false, L('placement.cant_place', { name = L('placement.' .. objectType) })
            end
        elseif checks.housing.system == 'bcs_housing' then
            if not (Player(player).state.insideArea or Player(player).state.isInsideHome) then
                return false, L('placement.cant_place', { name = L('placement.' .. objectType) })
            end
        elseif checks.housing.system == 'vms_housing' then
            if not (exports['vms_housing']:GetPlayerCurrentProperty(player) ~= nil) then
                return false, L('placement.cant_place', { name = L('placement.' .. objectType) })
            end
        elseif checks.housing.system == 'loaf_housing' then
            if not (Player(player).state.loaf_housing_instance ~= nil) then
                return false, L('placement.cant_place', { name = L('placement.' .. objectType) })
            end
        elseif checks.housing.system == 'rtx_housing' then
            if not exports["rtx_housing"]:IsPlayerInsideProperty(player) then
                return false, L('placement.cant_place', { name = L('placement.' .. objectType) })
            end
        end

        return true --Assume client sided checks will occur for housing
    end

    if checks.whitelistedAreas and checks.whitelistedAreas.enabled then
        for k, area in pairs(checks.whitelistedAreas.areas) do
            if IsWithinDistance(coords, area.coords, area.radius) then
                return true
            end
        end
    else
        return true
    end

    return false, L('placement.cant_place', { name = L('placement.' .. objectType) })
end

local function OnPotUse(player)
    local allowed, message = IsAllowedToPlace(player, nil, 'pot')
    if not allowed then
        TriggerClientEvent('kq_link:client:notify', player, message, 'warning')
        return
    end

    TriggerClientEvent('kq_weed:client:enterPotPlacementMode', player)
end

exports.kq_link:RegisterUsableItem(Config.items.weedPot, function(source)
    OnPotUse(source)
end)

exports('UsePot', function(event, item, inventory)
    if event == 'usingItem' then
        local player = inventory.id
        OnPotUse(player)
        return true
    end
end)


local function OnTableUse(player)
    local allowed, message = IsAllowedToPlace(player, nil, 'table')
    if not allowed then
        TriggerClientEvent('kq_link:client:notify', player, message, 'warning')
        return
    end

    TriggerClientEvent('kq_weed:client:enterTablePlacementMode', player)
end

exports.kq_link:RegisterUsableItem(Config.items.weedTable, function(source)
    OnTableUse(source)
end)

exports('UseTable', function(event, item, inventory)
    if event == 'usingItem' then
        local player = inventory.id
        OnTableUse(player)
        return true
    end
end)


local function OnPressUse(player)
    local allowed, message = IsAllowedToPlace(player, nil, 'press')
    if not allowed then
        TriggerClientEvent('kq_link:client:notify', player, message, 'warning')
        return
    end

    TriggerClientEvent('kq_weed:client:enterPressPlacementMode', player)
end

exports.kq_link:RegisterUsableItem(Config.items.weedPress, function(source)
    OnPressUse(source)
end)

exports('UsePress', function(event, item, inventory)
    if event == 'usingItem' then
        local player = inventory.id
        OnPressUse(player)
        return true
    end
end)

local function ConsumeJoint(player, item)
    if not exports.kq_link:RemovePlayerItem(player, item, 1) then
        return
    end

    TriggerClientEvent('kq_weed:client:weedEffect', player, nil)
end

if Config.weedEffect and Config.weedEffect.enabled then
    for _, weed in pairs(Config.weedTypes) do
        if weed.jointItem then
            local item = weed.jointItem

            exports.kq_link:RegisterUsableItem(item, function(source)
                ConsumeJoint(source, item)
            end)
        end
    end

    exports('SmokeJoint', function(event, item, inventory)
        if event == 'usingItem' then
            ConsumeJoint(inventory.id, item.name)
            return true
        end
    end)
end

-- Object offset placement commands
RegisterCommand("kq_weed:potOffset", function(source)
    TriggerClientEvent('kq_weed:client:startOffsetPlacement', source, 'kq_weed_pot', 90.0)
end, true)

RegisterCommand("kq_weed:tableOffset", function(source)
    TriggerClientEvent('kq_weed:client:startOffsetPlacement', source, 'kq_weed_table', 180.0)
end, true)

RegisterCommand("kq_weed:pressOffset", function(source)
    TriggerClientEvent('kq_weed:client:startOffsetPlacement', source, 'kq_weed_press', 180.0)
end, true)

--
function OnAbuseDetected(message, player)
    -- This function gets triggered when a player is suspected of cheating (sending fake events or using glitches)
end
