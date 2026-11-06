Bridge = {}

local function isStarted(resource)
    return GetResourceState(resource):find('start') ~= nil
end

local framework = Config.Framework
if framework == 'auto' then
    if isStarted('qbx_core') then framework = 'qbox'
    elseif isStarted('qb-core') then framework = 'qb'
    elseif isStarted('es_extended') then framework = 'esx'
    end
end

Bridge.Framework = framework

local QBCore, ESX
if framework == 'qb' then
    QBCore = exports['qb-core']:GetCoreObject()
elseif framework == 'esx' then
    ESX = exports.es_extended:getSharedObject()
elseif framework ~= 'qbox' then
    lib.print.error('No supported framework found. Set Config.Framework manually.')
end

local function getPlayer(src)
    if framework == 'qbox' then return exports.qbx_core:GetPlayer(src) end
    if framework == 'qb' then return QBCore.Functions.GetPlayer(src) end
    if framework == 'esx' then return ESX.GetPlayerFromId(src) end
end

-- Money types used by this resource: 'cash' | 'bank'
local esxAccounts = { cash = 'money', bank = 'bank' }

---@return string|nil
function Bridge.GetCitizenId(src)
    local player = getPlayer(src)
    if not player then return nil end
    if framework == 'esx' then return player.identifier end
    return player.PlayerData.citizenid
end

function Bridge.GetCharName(src)
    local player = getPlayer(src)
    if not player then return 'Unknown' end
    if framework == 'esx' then return player.getName() end
    local info = player.PlayerData.charinfo
    return ('%s %s'):format(info.firstname, info.lastname)
end

function Bridge.GetMoney(src, moneyType)
    local player = getPlayer(src)
    if not player then return 0 end
    if framework == 'esx' then
        local account = player.getAccount(esxAccounts[moneyType] or moneyType)
        return account and account.money or 0
    end
    return player.PlayerData.money[moneyType] or 0
end

function Bridge.RemoveMoney(src, moneyType, amount, reason)
    local player = getPlayer(src)
    if not player or amount <= 0 then return false end
    if Bridge.GetMoney(src, moneyType) < amount then return false end
    if framework == 'esx' then
        player.removeAccountMoney(esxAccounts[moneyType] or moneyType, amount, reason)
        return true
    end
    return player.Functions.RemoveMoney(moneyType, amount, reason) ~= false
end

function Bridge.AddMoney(src, moneyType, amount, reason)
    local player = getPlayer(src)
    if not player or amount <= 0 then return false end
    if framework == 'esx' then
        player.addAccountMoney(esxAccounts[moneyType] or moneyType, amount, reason)
        return true
    end
    return player.Functions.AddMoney(moneyType, amount, reason) ~= false
end

function Bridge.Notify(src, message, notifyType)
    TriggerClientEvent('ox_lib:notify', src, { description = message, type = notifyType or 'inform' })
end

---@return number|nil src of the online player with this citizen id
function Bridge.GetSourceFromCitizenId(citizenid)
    if not citizenid then return nil end
    local player
    if framework == 'qbox' then
        player = exports.qbx_core:GetPlayerByCitizenId(citizenid)
        return player and player.PlayerData.source
    elseif framework == 'qb' then
        player = QBCore.Functions.GetPlayerByCitizenId(citizenid)
        return player and player.PlayerData.source
    elseif framework == 'esx' then
        player = ESX.GetPlayerFromIdentifier(citizenid)
        return player and player.source
    end
end

---Runs cb(src) whenever a character finishes loading.
function Bridge.OnPlayerLoaded(cb)
    if framework == 'esx' then
        AddEventHandler('esx:playerLoaded', function(playerId) cb(playerId) end)
    else
        -- Server-side event fired by qb-core and Qbox with the player object once a character is in
        AddEventHandler('QBCore:Server:PlayerLoaded', function(player)
            local src = player and player.PlayerData and player.PlayerData.source
            if src then cb(src) end
        end)
    end
end

---Registers a usable item for qb/qbox/esx. ox_inventory users use the client export instead.
function Bridge.RegisterUsableItem(item, cb)
    if GetResourceState('ox_inventory') == 'started' then return false end
    if framework == 'qbox' then
        exports.qbx_core:CreateUseableItem(item, function(src) cb(src) end)
    elseif framework == 'qb' then
        QBCore.Functions.CreateUseableItem(item, function(src) cb(src) end)
    elseif framework == 'esx' then
        ESX.RegisterUsableItem(item, function(src) cb(src) end)
    end
    return true
end

function Bridge.GetJob(src)
    local player = getPlayer(src)
    if not player then return nil end
    if framework == 'esx' then return player.job and player.job.name end
    return player.PlayerData.job and player.PlayerData.job.name
end

function Bridge.GetJobGrade(src)
    local player = getPlayer(src)
    if not player then return 0 end
    if framework == 'esx' then return player.job and tonumber(player.job.grade) or 0 end
    local grade = player.PlayerData.job and player.PlayerData.job.grade
    return type(grade) == 'table' and (tonumber(grade.level) or 0) or (tonumber(grade) or 0)
end

local function oxInventory()
    return GetResourceState('ox_inventory') == 'started'
end

function Bridge.HasItem(src, item, count)
    count = count or 1
    if oxInventory() then
        return (exports.ox_inventory:GetItemCount(src, item) or 0) >= count
    end
    local player = getPlayer(src)
    if not player then return false end
    if framework == 'esx' then
        local inv = player.getInventoryItem(item)
        return inv ~= nil and (inv.count or 0) >= count
    end
    local found = player.Functions.GetItemByName(item)
    return found ~= nil and (found.amount or found.count or 0) >= count
end

function Bridge.GetItemCount(src, item)
    if oxInventory() then return exports.ox_inventory:GetItemCount(src, item) or 0 end
    local player = getPlayer(src)
    if not player then return 0 end
    if framework == 'esx' then
        local inv = player.getInventoryItem(item)
        return inv and inv.count or 0
    end
    local found = player.Functions.GetItemByName(item)
    return found and (found.amount or found.count or 0) or 0
end

function Bridge.AddItem(src, item, count)
    count = count or 1
    if oxInventory() then
        if not exports.ox_inventory:CanCarryItem(src, item, count) then return false end
        return exports.ox_inventory:AddItem(src, item, count) == true
    end
    local player = getPlayer(src)
    if not player then return false end
    if framework == 'esx' then
        if not player.canCarryItem(item, count) then return false end
        player.addInventoryItem(item, count)
        return true
    end
    return player.Functions.AddItem(item, count) ~= false
end

function Bridge.RemoveItem(src, item, count)
    count = count or 1
    if oxInventory() then
        return exports.ox_inventory:RemoveItem(src, item, count) == true
    end
    local player = getPlayer(src)
    if not player then return false end
    if framework == 'esx' then
        player.removeInventoryItem(item, count)
        return true
    end
    return player.Functions.RemoveItem(item, count) ~= false
end

-------------------------------------------------------------------------------
-- Item list (for picking items in the staff panel instead of typing names into config)
-------------------------------------------------------------------------------

local itemCache, itemCacheAt = nil, 0

---Every item the inventory knows: { name, label, image }. Cached for a minute.
function Bridge.ListItems()
    if itemCache and GetGameTimer() - itemCacheAt < 60000 then return itemCache end
    local list = {}
    if GetResourceState('ox_inventory') == 'started' then
        for name, it in pairs(exports.ox_inventory:Items() or {}) do
            local image = it.client and it.client.image or (name .. '.png')
            list[#list + 1] = { name = name, label = it.label or name, image = image:find('://') and image or ('nui://ox_inventory/web/images/' .. image) }
        end
    elseif framework == 'qb' or framework == 'qbox' then
        local items = (QBCore and QBCore.Shared and QBCore.Shared.Items) or {}
        local imageRes = GetResourceState('qb-inventory') == 'started' and 'qb-inventory' or 'ps-inventory'
        for name, it in pairs(items) do
            list[#list + 1] = { name = name, label = it.label or name, image = ('nui://%s/html/images/%s'):format(imageRes, it.image or (name .. '.png')) }
        end
    elseif framework == 'esx' then
        for _, r in ipairs(MySQL.query.await('SELECT name, label FROM items') or {}) do
            list[#list + 1] = { name = r.name, label = r.label or r.name }
        end
    end
    table.sort(list, function(a, b) return a.label:lower() < b.label:lower() end)
    itemCache, itemCacheAt = list, GetGameTimer()
    return list
end

---Items whose name or label contains the search text (best matches first), at most `limit`.
function Bridge.SearchItems(query, limit)
    query = tostring(query or ''):lower():gsub('[%c]', ''):sub(1, 40)
    limit = limit or 30
    local starts, contains = {}, {}
    for _, it in ipairs(Bridge.ListItems()) do
        local name, label = it.name:lower(), it.label:lower()
        if query == '' then
            contains[#contains + 1] = it
        elseif name:sub(1, #query) == query or label:sub(1, #query) == query then
            starts[#starts + 1] = it
        elseif name:find(query, 1, true) or label:find(query, 1, true) then
            contains[#contains + 1] = it
        end
        if #starts >= limit then break end
    end
    local out = {}
    for _, group in ipairs({ starts, contains }) do
        for _, it in ipairs(group) do
            if #out >= limit then return out end
            out[#out + 1] = it
        end
    end
    return out
end

---Does this item exist in the inventory? (If the list can't be read, assume yes rather than block staff.)
function Bridge.ItemExists(name)
    if type(name) ~= 'string' or name == '' then return false end
    local list = Bridge.ListItems()
    if #list == 0 then return true end
    for _, it in ipairs(list) do if it.name == name then return true end end
    return false
end

function Bridge.ItemLabel(name)
    for _, it in ipairs(Bridge.ListItems()) do if it.name == name then return it.label end end
    return name
end
