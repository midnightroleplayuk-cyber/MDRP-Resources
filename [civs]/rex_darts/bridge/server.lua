--[[
    Server framework bridge: ESX, QBCore, QBox, standalone.
    Open file (escrow_ignore): adapt money / items / society calls to your own resources if needed.
]]

Bridge = {}

local RES = GetCurrentResourceName()
local ESX, QBCore
local function started(res) return GetResourceState(res) == 'started' end

local function detect()
    if Config.Framework ~= 'auto' then return Config.Framework end
    if started('qbx_core') then return 'qbox' end
    if started('qb-core') then return 'qb' end
    if started('es_extended') then return 'esx' end
    return 'standalone'
end

Bridge.Framework = detect()

if Bridge.Framework == 'esx' then
    ESX = exports['es_extended']:getSharedObject()
elseif Bridge.Framework == 'qb' then
    QBCore = exports['qb-core']:GetCoreObject()
end

function Bridge.GetPlayer(src)
    if Bridge.Framework == 'esx' then return ESX.GetPlayerFromId(src) end
    if Bridge.Framework == 'qb' then return QBCore.Functions.GetPlayer(src) end
    if Bridge.Framework == 'qbox' then return exports.qbx_core:GetPlayer(src) end
    return nil
end

---Stable identifier used for stats (citizenid / ESX identifier / license in standalone).
function Bridge.GetIdentifier(src)
    local p = Bridge.GetPlayer(src)
    if p then
        if Bridge.Framework == 'esx' then return p.identifier end
        return p.PlayerData and p.PlayerData.citizenid
    end
    return GetPlayerIdentifierByType(src, 'license') or ('src:' .. tostring(src))
end

function Bridge.GetName(src)
    local p = Bridge.GetPlayer(src)
    if p then
        if Bridge.Framework == 'esx' then
            local ok, name = pcall(p.getName)
            if ok and name then return name end
        elseif p.PlayerData and p.PlayerData.charinfo then
            local ci = p.PlayerData.charinfo
            return ('%s %s'):format(ci.firstname or '', ci.lastname or '')
        end
    end
    return GetPlayerName(src) or ('#' .. tostring(src))
end

function Bridge.IsAdmin(src)
    return src == 0 or IsPlayerAceAllowed(src, Config.AdminAce)
end

---------------------------------------------------------------------------------------------------
-- Money. Standalone: bets are disabled (Bridge.HasMoney = false).
---------------------------------------------------------------------------------------------------
Bridge.HasMoney = Bridge.Framework ~= 'standalone'

local function esxAccount(account) return account == 'cash' and 'money' or account end

function Bridge.GetMoney(src, account)
    local p = Bridge.GetPlayer(src)
    if not p then return 0 end
    if Bridge.Framework == 'esx' then
        local acc = p.getAccount(esxAccount(account))
        return acc and acc.money or 0
    end
    return (p.PlayerData.money and p.PlayerData.money[account]) or 0
end

function Bridge.AddMoney(src, account, amount, reason)
    amount = math.floor(tonumber(amount) or 0)
    if amount <= 0 or not Bridge.HasMoney then return true end
    local p = Bridge.GetPlayer(src)
    if not p then return false end
    if Bridge.Framework == 'esx' then
        p.addAccountMoney(esxAccount(account), amount, reason)
        return true
    end
    return p.Functions.AddMoney(account, amount, reason) ~= false
end

function Bridge.RemoveMoney(src, account, amount, reason)
    amount = math.floor(tonumber(amount) or 0)
    if amount <= 0 or not Bridge.HasMoney then return true end
    local p = Bridge.GetPlayer(src)
    if not p then return false end
    if Bridge.GetMoney(src, account) < amount then return false end
    if Bridge.Framework == 'esx' then
        p.removeAccountMoney(esxAccount(account), amount, reason)
        return true
    end
    return p.Functions.RemoveMoney(account, amount, reason) ~= false
end

---Credits a job / society account. Tries the common banking resources in order.
function Bridge.AddSocietyMoney(society, amount)
    amount = math.floor(tonumber(amount) or 0)
    if amount <= 0 or not society or society == '' then return false end
    if started('Renewed-Banking') then
        if pcall(function() exports['Renewed-Banking']:addAccountMoney(society, amount) end) then return true end
    end
    if started('qb-banking') then
        if pcall(function() exports['qb-banking']:AddMoney(society, amount, RES) end) then return true end
    end
    if started('qb-management') then
        if pcall(function() exports['qb-management']:AddMoney(society, amount) end) then return true end
    end
    if started('okokBanking') then
        if pcall(function() exports['okokBanking']:AddMoney(society, amount) end) then return true end
    end
    if Bridge.Framework == 'esx' and started('esx_addonaccount') then
        local done = false
        TriggerEvent('esx_addonaccount:getSharedAccount', 'society_' .. society, function(account)
            if account then account.addMoney(amount) done = true end
        end)
        return done
    end
    print(('^3[%s] No society account found for "%s", %d not credited.^7'):format(RES, society, amount))
    return false
end

---------------------------------------------------------------------------------------------------
-- Items (ox_inventory first, then the framework inventory)
---------------------------------------------------------------------------------------------------
function Bridge.AddItem(src, item, count)
    count = count or 1
    if started('ox_inventory') then return exports.ox_inventory:AddItem(src, item, count) and true or false end
    local p = Bridge.GetPlayer(src)
    if not p then return false end
    if Bridge.Framework == 'esx' then p.addInventoryItem(item, count) return true end
    return p.Functions.AddItem(item, count) ~= false
end

function Bridge.RemoveItem(src, item, count)
    count = count or 1
    if started('ox_inventory') then return exports.ox_inventory:RemoveItem(src, item, count) and true or false end
    local p = Bridge.GetPlayer(src)
    if not p then return false end
    if Bridge.Framework == 'esx' then
        local it = p.getInventoryItem(item)
        if not it or (it.count or 0) < count then return false end
        p.removeInventoryItem(item, count)
        return true
    end
    return p.Functions.RemoveItem(item, count) ~= false
end

---Registers a usable item. ox_inventory: add  server = { export = '<resource>.useItem' }  to the item
---(see install/ox_inventory_items.lua); the export below forwards to cb.
function Bridge.RegisterUsableItem(item, cb)
    exports('useItem', function(event, _, inventory)
        if event == 'usingItem' then
            cb(inventory.id)
            return false -- the item is only removed once the object is really placed
        end
    end)
    if Bridge.Framework == 'esx' then
        ESX.RegisterUsableItem(item, function(src) cb(src) end)
    elseif Bridge.Framework == 'qb' then
        QBCore.Functions.CreateUseableItem(item, function(src) cb(src) end)
    elseif Bridge.Framework == 'qbox' then
        pcall(function() exports.qbx_core:CreateUseableItem(item, function(src) cb(src) end) end)
    end
end

function Bridge.Notify(src, message, nType)
    TriggerClientEvent(RES .. ':client:notify', src, message, nType or 'inform')
end
