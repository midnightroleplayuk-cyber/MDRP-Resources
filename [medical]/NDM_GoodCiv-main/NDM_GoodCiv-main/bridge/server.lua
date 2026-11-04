-- Server-side framework bridge. Everything framework-specific on the server lives here.
Bridge = {}

local function started(res) return GetResourceState(res) == 'started' end

local function detect()
    if Config.Framework ~= 'auto' then return Config.Framework end
    if started('qbx_core') then return 'qbox' end
    if started('qb-core') then return 'qbcore' end
    if started('es_extended') then return 'esx' end
    return 'standalone'
end

Bridge.Name = detect()

local function detectInventory()
    if Config.Inventory ~= 'auto' then return Config.Inventory end
    if started('ox_inventory') then return 'ox_inventory' end
    if Bridge.Name == 'standalone' then return 'none' end
    return 'framework'
end

Bridge.Inventory = detectInventory()

local QBCore, ESX
if Bridge.Name == 'qbcore' then
    QBCore = exports['qb-core']:GetCoreObject()
elseif Bridge.Name == 'esx' then
    ESX = exports.es_extended:getSharedObject()
end

local function getPlayer(src)
    if Bridge.Name == 'qbox' then
        return exports.qbx_core:GetPlayer(src)
    elseif Bridge.Name == 'qbcore' then
        return QBCore.Functions.GetPlayer(src)
    elseif Bridge.Name == 'esx' then
        return ESX.GetPlayerFromId(src)
    end
end

function Bridge.GetIdentifier(src)
    local p = getPlayer(src)
    if p then
        if Bridge.Name == 'esx' then return p.identifier end
        return p.PlayerData.citizenid
    end
    return GetPlayerIdentifierByType(src, 'license') or ('src:' .. src)
end

function Bridge.GetName(src)
    local p = getPlayer(src)
    if p then
        if Bridge.Name == 'esx' then return p.getName() end
        local ci = p.PlayerData.charinfo
        if ci then return ('%s %s'):format(ci.firstname, ci.lastname) end
    end
    return GetPlayerName(src) or ('Player ' .. src)
end

---@return { name: string, onduty: boolean } | nil
function Bridge.GetJob(src)
    local p = getPlayer(src)
    if not p then return nil end
    if Bridge.Name == 'esx' then
        local job = p.getJob()
        -- ESX Legacy 1.10+ has job.onDuty; older versions have no duty concept.
        return { name = job.name, onduty = job.onDuty ~= false }
    end
    local job = p.PlayerData.job
    return { name = job.name, onduty = job.onduty and true or false }
end

function Bridge.IsMedicOnDuty(src)
    if Bridge.Name == 'standalone' then
        return IsPlayerAceAllowed(src, Config.Medics.StandaloneAce)
    end
    local job = Bridge.GetJob(src)
    return job ~= nil and job.onduty and GoodCiv.InList(Config.Medics.Jobs, job.name)
end

function Bridge.IsBlockedJob(src)
    local job = Bridge.GetJob(src)
    if job and GoodCiv.InList(Config.Carriers.BlockedJobs, job.name) then return true end
    if Bridge.Name == 'standalone' then
        return IsPlayerAceAllowed(src, Config.Medics.StandaloneAce)
    end
    return false
end

function Bridge.HasItem(src, item, count)
    if not item or Bridge.Inventory == 'none' then return true end
    count = count or 1
    if Bridge.Inventory == 'ox_inventory' then
        return (exports.ox_inventory:Search(src, 'count', item) or 0) >= count
    end
    local p = getPlayer(src)
    if not p then return false end
    if Bridge.Name == 'esx' then
        local it = p.getInventoryItem(item)
        return it ~= nil and (it.count or 0) >= count
    end
    local it = p.Functions.GetItemByName(item)
    return it ~= nil and (it.amount or it.count or 0) >= count
end

function Bridge.RemoveItem(src, item, count)
    if not item or Bridge.Inventory == 'none' then return true end
    count = count or 1
    if Bridge.Inventory == 'ox_inventory' then
        return exports.ox_inventory:RemoveItem(src, item, count)
    end
    local p = getPlayer(src)
    if not p then return false end
    if Bridge.Name == 'esx' then
        p.removeInventoryItem(item, count)
        return true
    end
    return p.Functions.RemoveItem(item, count)
end

function Bridge.AddMoney(src, amount)
    if amount <= 0 then return end
    local p = getPlayer(src)
    if not p then return end
    if Bridge.Name == 'esx' then
        local account = Config.Rewards.Account == 'cash' and 'money' or Config.Rewards.Account
        p.addAccountMoney(account, amount)
    else
        p.Functions.AddMoney(Config.Rewards.Account, amount, 'goodciv-reward')
    end
end

function Bridge.Revive(src)
    local fn = Config.Revive[Bridge.Name]
    if fn then fn(src) end
end

---Server ids of every online player who is an on-duty medic.
function Bridge.GetOnDutyMedics()
    local medics = {}
    for _, id in ipairs(GetPlayers()) do
        local src = tonumber(id)
        if Bridge.IsMedicOnDuty(src) then medics[#medics + 1] = src end
    end
    return medics
end

print(('^2[goodciv]^7 framework: %s, inventory: %s'):format(Bridge.Name, Bridge.Inventory))
