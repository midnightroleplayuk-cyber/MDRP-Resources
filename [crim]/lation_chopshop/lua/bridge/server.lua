Framework, Inventory = nil, nil

local runtime = require 'shared.runtime'
local setup = runtime.setup

-- Handle player login
--- @param source any
local function OnPlayerLoaded(source)
    TriggerEvent('lation_chopshop:playerLoaded', source)
end

-- Handle player logout
--- @param source any
local function OnPlayerLogout(source)
    TriggerEvent('lation_chopshop:playerDropped', source)
end

-- Get framework
local function InitFramework()
    if GetResourceState('es_extended') == 'started' then
        ESX = exports['es_extended']:getSharedObject()
        Framework = 'esx'

        AddEventHandler('esx:playerLoaded', function(source) OnPlayerLoaded(source) end)
        AddEventHandler('esx:playerDropped', function(source) OnPlayerLogout(source) end)
    elseif GetResourceState('qbx_core') == 'started' then
        Framework = 'qbx'

        RegisterNetEvent('QBCore:Server:PlayerLoaded', function(player) OnPlayerLoaded(player.PlayerData.source) end)
        AddEventHandler('QBCore:Server:OnPlayerUnload', function(source) OnPlayerLogout(source) end)
    elseif GetResourceState('qb-core') == 'started' then
        QBCore = exports['qb-core']:GetCoreObject()
        Framework = 'qb'

        AddEventHandler('QBCore:Server:PlayerLoaded', function(player) OnPlayerLoaded(player.PlayerData.source) end)
        AddEventHandler('QBCore:Server:OnPlayerUnload', function(source) OnPlayerLogout(source) end)
    else
        -- Add custom framework here
    end
end

-- Get inventory
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

-- Get player from source
--- @param source number Player ID
function GetPlayer(source)
    if not source then return end
    if Framework == 'esx' then
        return ESX.GetPlayerFromId(source)
    elseif Framework == 'qb' then
        return QBCore.Functions.GetPlayer(source)
    elseif Framework == 'qbx' then
        return exports.qbx_core:GetPlayer(source)
    else
        -- Add custom framework here
    end
end

-- Function to get a player identifier by source
--- @param source number Player ID
function GetIdentifier(source)
    local player = GetPlayer(source)
    if not player then return end
    if Framework == 'esx' then
        return player.identifier
    elseif Framework == 'qb' or Framework == 'qbx' then
        return player.PlayerData.citizenid
    else
        -- Add custom framework here
    end
end

-- Return player's name
--- @param source number Player ID
--- @return string
function GetName(source)
    local player = GetPlayer(source)
    if not player then return 'Unknown' end
    if Framework == 'esx' then
        return player.getName()
    elseif Framework == 'qb' or Framework == 'qbx' then
        return player.PlayerData.charinfo.firstname.. ' ' ..player.PlayerData.charinfo.lastname
    else
        -- Add custom framework here
    end
    return 'Unknown'
end

-- Return player job
--- @param source number Player ID
function GetPlayerJob(source)
    local player = GetPlayer(source)
    if not player then return 'unemployed' end
    if Framework == 'esx' then
        return player.getJob().name
    elseif Framework == 'qb' or Framework == 'qbx' then
        return player.PlayerData.job.name
    else
        -- Add custom framework here
    end
    return 'unemployed'
end

-- Return true if the player has a blacklisted job for chopping
--- @param source number
--- @return boolean
function IsBlacklistedJob(source)
    if not source then return false end

    local jobs = runtime.setup.blacklistedJobs
    if not jobs or #jobs == 0 then return false end

    local playerJob = GetPlayerJob(source)
    if not playerJob then return false end

    for _, job in pairs(jobs) do
        if job == playerJob then
            return true
        end
    end

    return false
end


-- Returns number of players with police job(s)
--- @return number
function GetPoliceCount()
    local count, jobs = 0, {}
    for _, job in pairs(setup.police) do
        jobs[job] = true
    end
    if Framework == 'esx' then
        for job, _ in pairs(jobs) do
            count += #ESX.GetExtendedPlayers('job', job)
        end
    elseif Framework == 'qb' then
        for _, playerId in pairs(QBCore.Functions.GetPlayers()) do
            local player = QBCore.Functions.GetPlayer(playerId)
            if jobs[player.PlayerData.job.name] and player.PlayerData.job.onduty then
                count += 1
            end
        end
    elseif Framework == 'qbx' then
        for job, _ in pairs(jobs) do
            count = count + exports.qbx_core:GetDutyCountJob(job)
        end
    else
        -- Add custom framework here
    end
    return count
end

-- Returns number of specified item in players inventory
--- @param source number Player ID
--- @param item string Item to search
--- @return number
function GetItemCount(source, item)
    if not source or not item then return 0 end
    local player = GetPlayer(source)
    if not player then return 0 end
    if Inventory then
        if Inventory == 'ox_inventory' then
            return exports[Inventory]:Search(source, 'count', item) or 0
        elseif Inventory == 'core_inventory' then
            return exports[Inventory]:getItemCount(source, item)
        elseif Inventory == 'jaksam_inventory' then
            return exports[Inventory]:getTotalItemAmount(source, item) or 0
        else
            local itemData = exports[Inventory]:GetItemByName(source, item)
            if not itemData then return 0 end
            return itemData.amount or itemData.count or 0
        end
    else
        if Framework == 'esx' then
            local itemData = player.getInventoryItem(item)
            if not itemData then return 0 end
            return itemData.count or itemData.amount or 0
        elseif Framework == 'qb' then
            local itemData = player.Functions.GetItemByName(item)
            if not itemData then return 0 end
            return itemData.amount or itemData.count or 0
        else
            -- Add custom framework here
        end
    end
    return 0
end

-- Returns if player can carry item
--- @param source number Player ID
--- @param item string Item name
--- @param count number Item quantity
function CanCarry(source, item, count)
    if count <= 0 then return true end
    local player = GetPlayer(source)
    if not player then return false end
    if Inventory then
        if Inventory == 'ox_inventory' then
            return exports[Inventory]:CanCarryItem(source, item, count)
        elseif Inventory == 'qb-inventory' then
            return exports[Inventory]:CanAddItem(source, item, count)
        elseif Inventory == 'qs-inventory' then
            return exports[Inventory]:CanCarryItem(source, item, count)
        elseif Inventory == 'origen_inventory' then
            -- origen's CanCarry export not working as expected, just return true
            return true
        elseif Inventory == 'codem-inventory' then
            -- CodeM docs dont specify an export for this so..
            return true
        elseif Inventory == 'core_inventory' then
            -- core's canCarry export not working as expected, just return true
            return true
        elseif Inventory == 'tgiann-inventory' then
            return exports[Inventory]:CanCarryItem(source, item, count)
        elseif Inventory == 'jaksam_inventory' then
            return exports[Inventory]:canCarryItem(source, item, count)
        else
            -- Add custom inventory here
            return true
        end
    else
        if Framework == 'esx' then
            if player.canCarryItem(item, count) then
                return true
            end
            return false
        elseif Framework == 'qb' then
            local totalWeight = QBCore.Player.GetTotalWeight(player.PlayerData.items)
            if not totalWeight then return false end
            local itemInfo = QBCore.Shared.Items[item:lower()]
            if not itemInfo then return false end
            if (totalWeight + (itemInfo['weight'] * count)) <= 120000 then
                return true
            end
            return false
        else
            -- Add custom framework here
        end
    end
    return true
end

-- Adds an item to players inventory
--- @param source number Player ID
--- @param item string Item to add
--- @param count number Quantity to add
--- @param metadata any|table Optional metadata
function AddItem(source, item, count, metadata)
    if count <= 0 then return end
    local player = GetPlayer(source)
    if not player then return end
    if Inventory then
        if Inventory == 'ox_inventory' then
            exports[Inventory]:AddItem(source, item, count, metadata)
        elseif Inventory == 'core_inventory' or Inventory == 'jaksam_inventory' then
            exports[Inventory]:addItem(source, item, count, metadata)
        else
            exports[Inventory]:AddItem(source, item, count, nil, metadata)
        end
    else
        if Framework == 'esx' then
            player.addInventoryItem(item, count)
        elseif Framework == 'qb' then
            player.Functions.AddItem(item, count, nil, metadata)
        else
            -- Add custom framework here
        end
    end
end

-- Removes an item from players inventory
--- @param source number Player ID
--- @param item string Item to remove
--- @param count number Quantity to remove
function RemoveItem(source, item, count)
    local player = GetPlayer(source)
    if not player then return end
    if Inventory then
        if Inventory == 'core_inventory' or Inventory == 'jaksam_inventory' then
            exports[Inventory]:removeItem(source, item, count)
        else
            exports[Inventory]:RemoveItem(source, item, count)
        end
    else
        if Framework == 'esx' then
            player.removeInventoryItem(item, count)
        elseif Framework == 'qb' then
            player.Functions.RemoveItem(item, count)
        else
            -- Add custom framework here
        end
    end
end

local MONEY_ACCOUNTS = {
    bank = true,
    cash = true,
    money = true,
}

-- True for framework money accounts (bank/cash), false for inventory item currency.
--- @param account string
--- @return boolean
function IsMoneyAccount(account)
    return type(account) == 'string' and MONEY_ACCOUNTS[account:lower()] == true
end

local isMoneyAccount = IsMoneyAccount

-- Convert money account based on framework
--- @param account string Money account
--- @return string
function ConvertMoney(account)
    if account == 'money' and (Framework == 'qb' or Framework == 'qbx') then
        account = 'cash'
    elseif account == 'cash' and Framework == 'esx' then
        account = 'money'
    else
        -- Add custom framework here
    end
    return account
end

-- Get player balance
--- @param source number Player ID
--- @param account string Account
--- @return number
function GetPlayerBalance(source, account)
    local player = GetPlayer(source)
    if not player then return 0 end
    if not isMoneyAccount(account) then
        return GetItemCount(source, account) or 0
    end
    if Framework == 'esx' then
        return player.getAccount(ConvertMoney(account)).money or 0
    elseif Framework == 'qb' then
        return player.PlayerData.money[ConvertMoney(account)] or 0
    elseif Framework == 'qbx' then
        return player.Functions.GetMoney(ConvertMoney(account)) or 0
    else
        -- Add custom framework here
    end
    return 0
end

-- Add money to player
--- @param source number Player ID
--- @param account string Account to add to
--- @param amount number Amount to add
function AddMoney(source, account, amount)
    local player = GetPlayer(source)
    if not player then return end
    if not isMoneyAccount(account) then
        AddItem(source, account, amount)
        return
    end
    if Framework == 'esx' then
        player.addAccountMoney(ConvertMoney(account), amount)
    elseif Framework == 'qb' or Framework == 'qbx' then
        player.Functions.AddMoney(ConvertMoney(account), amount)
    else
        -- Add custom framework here
    end
end

-- Remove money from player
--- @param source number Player ID
--- @param account string Account to remove from
--- @param amount number Amount to remove
function RemoveMoney(source, account, amount)
    local player = GetPlayer(source)
    if not player then return end
    if not isMoneyAccount(account) then
        RemoveItem(source, account, amount)
        return
    end
    if Framework == 'esx' then
        player.removeAccountMoney(ConvertMoney(account), amount)
    elseif Framework == 'qb' or Framework == 'qbx' then
        player.Functions.RemoveMoney(ConvertMoney(account), amount)
    else
        -- Add custom framework here
    end
end

-- Create usable item
--- @param item string
--- @param cb function
function CreateUseableItem(item, cb)
    if not item then return end
    if Framework == 'esx' then
        ESX.RegisterUsableItem(item, cb)
    elseif Framework == 'qb' then
        QBCore.Functions.CreateUseableItem(item, cb)
    elseif Framework == 'qbx' then
        exports.qbx_core:CreateUseableItem(item, cb)
    else
        -- Add custom framework here
    end
end

InitFramework()
InitInventory()