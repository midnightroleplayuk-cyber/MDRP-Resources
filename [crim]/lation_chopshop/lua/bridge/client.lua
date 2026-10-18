local runtime = require 'shared.runtime'

Framework, Inventory = nil, nil
PlayerLoaded = false

local function waitForRuntimeReady(timeoutMs)
    if runtime.isReady() then
        return true
    end

    local waited = 0
    local stepMs = 100

    while waited < timeoutMs do
        Wait(stepMs)

        if runtime.isReady() then
            return true
        end

        waited = waited + stepMs
    end

    return runtime.isReady()
end

-- Handle player login
local function OnPlayerLoaded()
    if PlayerLoaded then return end

    if not waitForRuntimeReady(15000) then
        print('^3[lation_chopshop] Delaying player initialization until runtime config sync is ready.^0')
        return
    end

    PlayerLoaded = true
    TriggerEvent('lation_chopshop:playerLoaded')
end

-- Handle player logout
local function OnPlayerLogout()
    if not PlayerLoaded then return end
    PlayerLoaded = false
    TriggerEvent('lation_chopshop:playerDropped')
end

-- Initialize framework
local function InitFramework()
    if GetResourceState('es_extended') == 'started' then
        ESX = exports['es_extended']:getSharedObject()
        Framework = 'esx'

        RegisterNetEvent('esx:playerLoaded', function() OnPlayerLoaded() end)
        RegisterNetEvent('esx:onPlayerLogout', function() OnPlayerLogout() end)
    elseif GetResourceState('qbx_core') == 'started' then
        Framework = 'qbx'

        AddEventHandler('QBCore:Client:OnPlayerLoaded', function() OnPlayerLoaded() end)
        RegisterNetEvent('qbx_core:client:playerLoggedOut', function() OnPlayerLogout() end)
    elseif GetResourceState('qb-core') == 'started' then
        QBCore = exports['qb-core']:GetCoreObject()
        Framework = 'qb'

        RegisterNetEvent('QBCore:Client:OnPlayerLoaded', function() OnPlayerLoaded() end)
        RegisterNetEvent('QBCore:Client:OnPlayerUnload', function() OnPlayerLogout() end)
    else
        -- Add custom framework here
    end
end

-- Initialize inventory
local function InitInventory()
    if GetResourceState('ox_inventory') == 'started' then
        Inventory = 'ox_inventory'
    elseif GetResourceState('qb-inventory') == 'started' then
        Inventory = 'qb-inventory'
    elseif GetResourceState('qs-inventory') == 'started' then
        Inventory = 'qs-inventory'
    elseif GetResourceState('origen_inventory') == 'started' then
        Inventory = 'origen_inventory'
    elseif GetResourceState('codem-inventory') == 'started' then
        Inventory = 'codem-inventory'
    elseif GetResourceState('core_inventory') == 'started' then
        Inventory = 'core_inventory'
    elseif GetResourceState('tgiann-inventory') == 'started' then
        Inventory = 'tgiann-inventory'
    elseif GetResourceState('jaksam_inventory') == 'started' then
        Inventory = 'jaksam_inventory'
    else
        -- Add custom inventory here
    end
end

-- Get player data
--- @return any
function GetPlayerData()
    if Framework == 'esx' then
        return ESX.GetPlayerData()
    elseif Framework == 'qb' then
        return QBCore.Functions.GetPlayerData()
    elseif Framework == 'qbx' then
        return exports.qbx_core:GetPlayerData()
    else
        -- Add custom framework here
    end
end

-- Get player job name
--- @return string
function GetPlayerJob()
    local player = GetPlayerData()
    if not player then return 'unemployed' end
    if Framework == 'esx' then
        return player.job.name
    elseif Framework == 'qb' then
        return player.job.name
    elseif Framework == 'qbx' then
        return player.job.name
    else
        -- Add custom framework here
    end
    return 'unemployed'
end

--- @param notify boolean|nil
--- @return boolean
function IsBlacklistedJob(notify)
    local jobs = runtime.setup.blacklistedJobs
    if not jobs or #jobs == 0 then return false end

    local playerJob = GetPlayerJob()
    if not playerJob then return false end

    for _, job in pairs(jobs) do
        if job == playerJob then
            if notify then
                ShowNotification(locale('notify.blacklisted-job'), 'error')
            end
            return true
        end
    end

    return false
end

-- Get item data from inventory
--- @param item string
--- @return any
function GetItemData(item)
    if not item then return end
    if Inventory then
        if Inventory == 'ox_inventory' then
            return exports[Inventory]:Items(item)
        elseif Inventory == 'qb-inventory' then
            return QBCore.Shared.Items[item]
        elseif Inventory == 'qs-inventory' then
            local items = exports[Inventory]:GetItemList()
            if not items then return end
            return items[item]
        elseif Inventory == 'origen_inventory' then
            local items = exports[Inventory]:GetItems()
            if not items then return end
            return items[item]
        elseif Inventory == 'codem-inventory' then
            local items = exports[Inventory]:GetItemList()
            if not items then return end
            return items[item]
        elseif Inventory == 'core_inventory' then
            if Framework == 'qb' then
                return QBCore.Shared.Items[item]
            else
                print('^1[ERROR]: An issue has occured, please contact support at: https://discord.gg/9EbY4nM5uu^0')
            end
        elseif Inventory == 'tgiann-inventory' then
            return exports[Inventory]:GetItemList(item)
        elseif Inventory == 'jaksam_inventory' then
            return exports[Inventory]:getStaticItem(item)
        else
            -- Add custom inventory here
        end
    else
        if Framework == 'esx' then
            print('^1[ERROR]: An error has occured with lation_chopshop - please contact support^0')
        elseif Framework == 'qb' then
            return QBCore.Shared.Items[item]
        elseif Framework == 'qbx' then
            print('^1[ERROR]: Are you really not using ox_inventory? Contact support please lul.^0')
        end
    end
end

--- Display label for an inventory item, falling back to the raw spawn name when
--- the inventory has no entry for it. Item catalogs only exist client-side, so
--- anything the server wants to show a player by name has to resolve it here.
--- @param item string
--- @return string
function GetItemLabel(item)
    if not item or item == '' then return '' end

    local data = GetItemData(item)
    if type(data) == 'table' and type(data.label) == 'string' and data.label ~= '' then
        return data.label
    end

    return item
end

-- Check if player has item
--- @param item string
--- @param amount number
--- @return boolean
function HasItem(item, amount)
    if not item or not amount then return false end
    if Inventory then
        if Inventory == 'ox_inventory' then
            return exports[Inventory]:Search('count', item) >= amount
        elseif Inventory == 'core_inventory' then
            return exports[Inventory]:hasItem(item, amount)
        elseif Inventory == 'jaksam_inventory' then
            return exports[Inventory]:getTotalItemAmount(item) >= amount
        else
            return exports[Inventory]:HasItem(item, amount)
        end
    else
        local playerData = GetPlayerData()
        if not playerData then return false end
        local inventory = Framework == 'esx' and playerData.inventory or playerData.items
        if not inventory then return false end
        for _, itemData in pairs(inventory) do
            if itemData and itemData.name == item then
                local count = itemData.amount or itemData.count or 0
                if count >= amount then
                    return true
                end
            end
        end
        return false
    end
end

-- Disables access to open/view inventory
function DisableInventory()
    if Inventory == 'ox_inventory' then
        LocalPlayer.state.invBusy = true
    elseif Inventory == 'qb-inventory' then
        LocalPlayer.state.inv_busy = true
    elseif Inventory == 'qs-inventory' then
        exports[Inventory]:setInventoryDisabled(true)
    elseif Inventory == 'core_inventory' then
        exports[Inventory]:lockInventory()
    elseif Inventory == 'tgiann-inventory' then
        exports[Inventory]:SetInventoryActive(false)
    else
        -- Add custom inventory here
    end
end

-- Enables access to open/view inventory
function EnableInventory()
    if Inventory == 'ox_inventory' then
        LocalPlayer.state.invBusy = false
    elseif Inventory == 'qb-inventory' then
        LocalPlayer.state.inv_busy = false
    elseif Inventory == 'qs-inventory' then
        exports[Inventory]:setInventoryDisabled(false)
    elseif Inventory == 'core_inventory' then
        exports[Inventory]:unlockInventory()
    elseif Inventory == 'tgiann-inventory' then
        exports[Inventory]:SetInventoryActive(true)
    else
        -- Add custom inventory here
    end
end

AddEventHandler('onResourceStart', function(resourceName)
    if resourceName == GetCurrentResourceName() then
        if cache and cache.ped and cache.ped ~= 0 and DoesEntityExist(cache.ped) then
            OnPlayerLoaded()
        end
    end
end)

RegisterNetEvent('lation_chopshop:runtimeReady', function()
    if PlayerLoaded then return end
    if not cache or not cache.ped or cache.ped == 0 then return end
    if not DoesEntityExist(cache.ped) then return end

    OnPlayerLoaded()
end)

InitFramework()
InitInventory()