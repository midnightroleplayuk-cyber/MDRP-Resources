while not Config.Framework or not Config.Inventory do Wait(1) end

local avBusiness = false
local itemList = GetResourceState("codem-inventory") == "started" and exports['codem-inventory']:GetItemList()
local origenItems = {}

-- Get Framework Core
function getCore()
    if not Core then
        if Config.Framework == "qb" then
            return exports['qb-core']:GetCoreObject()
        elseif Config.Framework == "esx" then
            return exports['es_extended']:getSharedObject()
        elseif Config.Framework == "av" then
            return exports.av_core
        end
    end
    return Core
end

function avJob(group)
    group = group or {}
    local name = group.name or "civilian"
    local label = group.label or "Civilian"
    local grade = group.grade or 0
    local gradeLabel = group.gradeLabel or label
    local isboss = group.isboss
    if isboss == nil then isboss = grade == 1 end
    return {
        name = name,
        label = label,
        type = "none",
        onduty = true,
        isboss = isboss,
        payment = 0,
        defaultDuty = true,
        offDutyPay = false,
        grade = { name = gradeLabel, level = grade, isboss = isboss, payment = 0 },
        grade_name  = gradeLabel,
        grade_label = gradeLabel,
        grades = {
            [grade] = { name = gradeLabel, label = gradeLabel, payment = 0, isboss = isboss },
        },
        permissions = group.permissions or {},
    }
end

-- Register Item
function registerItem(name)
    if Config.Inventory == "origen_inventory" then
        dbug("Item", name, "registered for origenItems")
        origenItems[name] = true
        return
    end
    dbug('registerItem(name)', name)
    local callback = function(source, item, info)
        usedItem(source, item, info, name)
    end
    if Config.Inventory == "jaksam_inventory" then
        exports['jaksam_inventory']:registerUsableItem(name, function(source, itemData)
            callback(source, itemData, itemData)
        end)
        return
    end
    if Config.Framework == "qb" then
        Core.Functions.CreateUseableItem(name, callback)
    elseif Config.Framework == "qbox" then
        exports.qbx_core:CreateUseableItem(name, callback)
    elseif Config.Framework == "esx" then
        Core.RegisterUsableItem(name,callback)
    end
end

if Config.Inventory and Config.Inventory == "origen_inventory" then
    exports.origen_inventory:registerHook('itemUsed', function(payload)
        if not payload or not payload['item'] then
            warn("itemUsed hook was triggered with empty payload or empty payload['item'], this is a problem from origen_inventory.")
            return
        end
        local name = payload['item']['name']
        if not name then
            warn("itemUsed hook didn't received item name in payload, this is a problem from origen_inventory.")
            return
        end
        if not origenItems[name] then return end
        TriggerEvent('ox_inventory:usedItem', payload['source'], payload['item']['name'], payload['slot'], payload['item']['metadata'])
    end)
end

-- used Item
function usedItem(source,item,info,name)
    if Config.Inventory == "ox_inventory" then return end -- No need to trigger item, we are gonna use ox_inv event directly
    local metadata, slot = getMetadata(item, info)
    dbug('usedItem(source, item, metadata, slot)', source, name, metadata and json.encode(metadata), slot)
    TriggerEvent('ox_inventory:usedItem', source, name, slot, metadata)
end

-- get item label
function getItemLabel(name)
    if Config.Inventory == "jaksam_inventory" then
        local itemData = exports['jaksam_inventory']:getItemData(name)
        return itemData and itemData.label or false
    end
    if Config.Inventory == "ox_inventory" then
        local data = exports.ox_inventory:Items(name)
        if data and data['label'] then return data['label'] or false end
    end
    if Config.Inventory == "qs-inventory" then
        return exports['qs-inventory']:GetItemLabel(name)
    end
    if Config.Inventory == "origen_inventory" then
        return exports.origen_inventory:GetItemLabel(name)
    end
    if Config.Framework == "qb" then
        if Core and Core.Shared and Core.Shared.Items then
            return Core.Shared.Items[name] and Core.Shared.Items[name]['label'] or false
        end
    end
    if Config.Framework == "esx" then
        return Core and Core.GetItemLabel(name) or false
    end
    return false
end

-- Get Player ID by identifier
function getSourceByIdentifier(identifier)
    if Config.Framework == "qb" then
        local Player = Core.Functions.GetPlayerByCitizenId(identifier)
        if Player then
            return Player.PlayerData.source
        end
    elseif Config.Framework == "qbox" then
        local Player = getPlayerByIdentifier(identifier)
        if Player then
            return Player.PlayerData.source
        end
    elseif Config.Framework == "esx" then
        local xPlayer = Core.GetPlayerFromIdentifier(identifier)
        if xPlayer then
            return xPlayer.source
        end
    elseif Config.Framework == "av" then
        local player = exports.av_core:GetPlayerByCharId(identifier)
        if player then
            return player.data.source
        end
    end
    return false
end

function getPlayerByIdentifier(identifier)
    if Config.Framework == "qb" then
        local Player = Core.Functions.GetPlayerByCitizenId(identifier)
        if Player then
            return Player
        end
    elseif Config.Framework == "qbox" then
        return exports.qbx_core:GetPlayerByCitizenId(identifier)
    elseif Config.Framework == "esx" then
        local xPlayer = Core.GetPlayerFromIdentifier(identifier)
        if xPlayer then
            return xPlayer
        end
    elseif Config.Framework == "av" then
        return exports.av_core:GetPlayerByCharId(identifier) or false
    end
    return false
end

-- Save Player
function savePlayer(source)
    if Config.Framework == "qb" then
        local Player = Core.Functions.GetPlayer(source)
        if Player then
            Player.Functions.Save()
        end
    elseif Config.Framework == "qbox" then
        exports.qbx_core:Save(source)
    elseif Config.Framework == "esx" then
        local xPlayer = Core.GetPlayerFromId(source)
        if Core.SavePlayer and xPlayer then
            Core.SavePlayer(xPlayer)
        end
    elseif Config.Framework == "av" then
        local player = exports.av_core:GetPlayer(source)
        if player and player.methods and player.methods.Save then
            player.methods.Save()
        end
    end
end

-- Get Player Permission Level
function getPermission(src, level)
    dbug('getPermission(src,level)', src, level and type(level) == "table" and json.encode(level) or level)
    if Config.Framework == "qb" then
        if type(level) == 'string' then
            level = string.gsub(level, "^group%.", "")
            if IsPlayerAceAllowed(src, level) or Core.Functions.HasPermission(src, level) then return true end
        elseif type(level) == 'table' then
            for _, permLevel in pairs(level) do
                if IsPlayerAceAllowed(src, permLevel) or Core.Functions.HasPermission(src, permLevel) then return true end
            end
        end
    elseif Config.Framework == "qbox" then
        if type(level) == 'string' then
            if IsPlayerAceAllowed(src, level) then return true end
        elseif type(level) == 'table' then
            for _, permLevel in pairs(level) do
                if IsPlayerAceAllowed(src, permLevel) then return true end
            end
        end
    elseif Config.Framework == "esx" then
        local xPlayer = Core.GetPlayerFromId(src)
        local xGroup = xPlayer.getGroup()
        if type(level) == "string" then
            level = string.gsub(level, "^group%.", "")
            return xGroup == level
        else
            for _, permLevel in pairs(level) do
                if xGroup == permLevel then return true end
            end
        end
    elseif Config.Framework == "av" then
        local function check(perm)
            if IsPlayerAceAllowed(src, perm) then return true end
            local group = perm:gsub("^group%.", "")
            return exports.av_core:HasPermission(src, group) == true
        end
        if type(level) == "string" then
            return check(level)
        elseif type(level) == "table" then
            for _, permLevel in pairs(level) do
                if check(permLevel) then return true end
            end
        end
    end
    return false
end

-- Get Player Identifier
function getIdentifier(src)
    if Config.Framework == "qb" then
        local Player = Core.Functions.GetPlayer(src)
        if Player then
            return Player.PlayerData.citizenid
        end
    elseif Config.Framework == "qbox" then
        local Player = exports.qbx_core:GetPlayer(src)
        if Player then
            return Player.PlayerData.citizenid
        end
    elseif Config.Framework == "esx" then
        local xPlayer = Core.GetPlayerFromId(src)
        if xPlayer then
            return xPlayer.identifier
        end
    elseif Config.Framework == "av" then
        local player = exports.av_core:GetPlayer(src)
        if player then
            return player.data.charId
        end
    end
    return false
end

-- Get Player Object
function getPlayer(src)
    if Config.Framework == "qb" then
        return Core.Functions.GetPlayer(src)
    elseif Config.Framework == "qbox" then
        return exports.qbx_core:GetPlayer(src)
    elseif Config.Framework == "esx" then
        return Core.GetPlayerFromId(src)
    elseif Config.Framework == "av" then
        return exports.av_core:GetPlayer(src)
    end
end

-- Add Item to player
function addItem(src, item, amount, info, slot)
    amount = amount or 1
    dbug("addItem(src, item, amount, info, slot)")
    if not src or not item then
        warn("addToStash received a nil value (src, item, resource)", src, item, GetInvokingResource())
        return false
    end
    if Config.Inventory == "jaksam_inventory" then
        local success, result = exports['jaksam_inventory']:addItem(src, item, amount, info, slot)
        dbug('jaksam addItem', success, result)
        return success == true
    end
    if Config.Inventory == "tgiann-inventory" then
        return exports["tgiann-inventory"]:AddItem(src, item, amount, slot, info)
    end
    if Config.Inventory and Config.Inventory == "ox_inventory" then
        return exports.ox_inventory:AddItem(src, item, amount, info, slot)
    end
    if Config.Inventory and Config.Inventory == "origen_inventory" then
        return exports['origen_inventory']:addItem(src, item, amount, info, slot)
    end
    if Config.Framework == "qbox" then
        print("^1You should be using ox_inventory with qbox, otherwise edit the addItem function in laptop/server/editable/exports.lua^7")
        return false
    end
    if Config.Framework == "qb" then
        local Player = Core.Functions.GetPlayer(src)
        return Player.Functions.AddItem(item, amount, false, info)
    elseif Config.Framework == "esx" then
        local xPlayer = Core.GetPlayerFromId(src)
        if xPlayer.canCarryItem(item, amount) then
            if Config.Inventory == "qs-inventory" then
                exports['qs-inventory']:AddItem(src, item, amount, slot, info)
            else
                xPlayer.addInventoryItem(item, amount, info)
            end
            return true
        end
    end
    return false
end

-- Remove Item from Player
function removeItem(src, item, amount, slot, metadata)
    dbug('removeItem(src, item, amount, slot)', src, item, amount, slot)
    if not src then return false end
    amount = amount or 1
    if Config.Inventory == "jaksam_inventory" then
        local success, result = exports['jaksam_inventory']:removeItem(src, item, amount, metadata, slot)
        dbug('jaksam removeItem', success, result)
        return success == true
    end
    if Config.Inventory and Config.Inventory == "ox_inventory" then
        local res, msg = exports['ox_inventory']:RemoveItem(src, item, amount, metadata, slot, false, false)
        dbug('ox_inv(res,msg)', res, msg)
        return res
    elseif Config.Inventory == "qb-inventory" and not Config.OldQBInventory then
        return exports[Config.Inventory]:RemoveItem(src, item, amount, slot)
    elseif Config.Inventory == "origen_inventory" then
        return exports['origen_inventory']:removeItem(src, item, amount, metadata, slot)
    else
        return exports[Config.Inventory]:RemoveItem(src, item, amount, slot, metadata)
    end
end

-- Set Item metadata
function setItemMetadata(src, item, slot, metadata)
    dbug('setItemMetadata(src,item, slot, metadata?)', src, item, slot, metadata)
    if Config.Inventory == "jaksam_inventory" then
        local success, result = exports['jaksam_inventory']:setItemMetadataInSlot(src, slot, metadata)
        dbug('jaksam setItemMetadataInSlot', src, slot, success, result)
        return success == true
    end
    if Config.Inventory == "ox_inventory" then
        exports['ox_inventory']:SetMetadata(src, slot, metadata)
        return
    end
    if Config.Inventory == 'qs-inventory' then
        exports['qs-inventory']:SetItemMetadata(src, slot, metadata)
        return
    end
    if Config.Inventory == "origen_inventory" then
        exports['origen_inventory']:setMetadata(src, slot, metadata)
        return
    end
    if Config.Inventory == "codem-inventory" then
        exports['codem-inventory']:SetItemMetadata(src, slot, metadata)
        return
    end
    if Config.Inventory == "tgiann-inventory" then
        local itemName = item
        if type(item) == "table" then
            itemName = item and item[1]
        end
        exports["tgiann-inventory"]:UpdateItemMetadata(tostring(src), itemName, tostring(slot), metadata)
        return
    end
    exports[Config.Inventory]:SetItemData(src, item, 'info', metadata, slot)
end

-- Set Item Metadata in Stash, don't ask me why there's 2 exports doing (almost) exactly the same -.-
function setItemMetadataStash(stash, item, slot, metadata)
    --    print(stash, item, slot, json.encode(metadata))
    if Config.Inventory == "ox_inventory" then
        exports['ox_inventory']:SetMetadata(stash, slot, metadata)
        return
    end
end

-- Get Player money
function getMoney(src, account)
    dbug("getMoney(src,account)", src, account)
    if not src then return false end
    if Config.UseItemAsMoneyAccount and Config.UseItemAsMoneyAccount[account] then
        dbug("Account "..account.." is configured as item account, using getItem export instead of money")
        return getItemCount(src, account)
    end
    if Config.Framework == "qb" then
        local Player = getPlayer(src)
        if Player then
            if (Player.PlayerData and Player.PlayerData.metadata) and Player.PlayerData.metadata.crypto then
                if Player.PlayerData.metadata.crypto[account] then
                    return Player.PlayerData.metadata.crypto[account] or 0
                end
            end
            if Player.PlayerData.money[account] then
                return Player.PlayerData.money[account] or 0
            end
        end
        return false
    elseif Config.Framework == "qbox" then
        local identifier = getIdentifier(src)
        if identifier then
            return exports.qbx_core:GetMoney(identifier, account) or 0
        end
    elseif Config.Framework == "esx" then
        local xPlayer = getPlayer(src)
        if xPlayer and xPlayer.getAccount(account) then
            return xPlayer.getAccount(account).money
        else
            return false
        end
    elseif Config.Framework == "av" then
        return exports.av_core:GetMoney(src, account) or 0
    end
end

-- Add Money
function addMoney(src, account, amount, reason)
    dbug('addMoney(src,account,amount)', src, account, amount)
    if not src then return false end
    if Config.UseItemAsMoneyAccount and Config.UseItemAsMoneyAccount[account] then
        dbug("Account "..account.." is configured as item account, using addItem export instead of money")
        return addItem(src, account, amount)
    end
    if Config.Framework == "qb" then
        local Player = Core.Functions.GetPlayer(src)
        local Crypto = Player.PlayerData.metadata and Player.PlayerData.metadata.crypto or false
        if Crypto and Crypto[account] then
            Crypto[account] += tonumber(amount)
            Player.Functions.SetMetaData("crypto", Crypto)
        else
            Player.Functions.AddMoney(account, amount)
        end
    elseif Config.Framework == "qbox" then
        local identifier = getIdentifier(src)
        dbug("Using qbox, player identifier:", identifier)
        if identifier then
            dbug("Sending money using qbox export AddMoney(identifier, account, amount)", identifier, account, amount, reason)
            exports.qbx_core:AddMoney(identifier, account, amount, reason or '')
        end
    elseif Config.Framework == "esx" then
        local xPlayer = Core.GetPlayerFromId(src)
        xPlayer.addAccountMoney(account, amount)
    elseif Config.Framework == "av" then
        exports.av_core:AddMoney(src, account, amount, reason or 'av_laptop')
    end
end

-- Add Money to Offline Player
function addMoneyOffline(identifier, account, amount, reason)
    if Config.Framework == "av" then
        local online = exports.av_core:GetPlayerByCharId(identifier)
        if online then
            exports.av_core:AddMoney(online.data.source, account, amount, reason or 'av_laptop')
            return
        end
        local result = MySQL.query.await('SELECT `money` FROM `characters` WHERE `char_id` = ?', { identifier })
        if result and result[1] then
            local money = result[1].money and json.decode(result[1].money) or {}
            money[account] = (money[account] or 0) + amount
            MySQL.update.await('UPDATE `characters` SET `money` = ? WHERE `char_id` = ?',
                { json.encode(money), identifier })
        end
        return
    end
    if Config.Framework == "qb" or Config.Framework == "qbox" then
        local result = MySQL.query.await('SELECT * FROM players WHERE citizenid = ?', { identifier })
        if result and result[1] then
            local RecieverMoney = result[1].money and json.decode(result[1].money) or {}
            RecieverMoney[account] = RecieverMoney[account] or 0
            RecieverMoney[account] = (RecieverMoney[account] + amount)
            MySQL.update.await('UPDATE players SET money = ? WHERE citizenid = ?',
                { json.encode(RecieverMoney), identifier })
        end
    elseif Config.Framework == "esx" then
        local result = MySQL.query.await('SELECT * FROM users WHERE identifier = ?', { identifier })
        if result and result[1] then
            local RecieverMoney = result[1].accounts and json.decode(result[1].accounts)
            RecieverMoney[account] = RecieverMoney[account] or 0
            RecieverMoney[account] = (RecieverMoney[account] + amount)
            MySQL.update.await('UPDATE users SET accounts = ? WHERE identifier = ?',
                { json.encode(RecieverMoney), identifier })
        end
    end
end

function getMoneyOffline(identifier, account)
    dbug("getMoneyOffline(identifier,account)", identifier, account)
    if not identifier or not account then return false end

    local src = getSourceByIdentifier(identifier)
    if src then return getMoney(src, account) end

    if Config.UseItemAsMoneyAccount and Config.UseItemAsMoneyAccount[account] then
        dbug("Account "..account.." is configured as item account, an offline balance cannot be read")
        return false
    end

    if Config.Framework == "av" then
        local result = MySQL.query.await('SELECT `money` FROM `characters` WHERE `char_id` = ?', { identifier })
        if result and result[1] then
            local money = result[1].money and json.decode(result[1].money) or {}
            return tonumber(money[account]) or 0
        end
    elseif Config.Framework == "qb" or Config.Framework == "qbox" then
        local result = MySQL.query.await('SELECT `money` FROM players WHERE citizenid = ?', { identifier })
        if result and result[1] then
            local money = result[1].money and json.decode(result[1].money) or {}
            return tonumber(money[account]) or 0
        end
    elseif Config.Framework == "esx" then
        local result = MySQL.query.await('SELECT `accounts` FROM users WHERE identifier = ?', { identifier })
        if result and result[1] then
            local accounts = result[1].accounts and json.decode(result[1].accounts) or {}
            return tonumber(accounts[account]) or 0
        end
    end

    dbug("getMoneyOffline found no stored balance for", identifier)
    return false
end

-- Read one account balance for many identifiers at once (online or offline).
-- Returns a table keyed by identifier. Missing entries could not be resolved.
function getMoneyOfflineBatch(identifiers, account)
    local out = {}
    if type(identifiers) ~= "table" or not account then return out end
    if Config.UseItemAsMoneyAccount and Config.UseItemAsMoneyAccount[account] then return out end

    local pending = {}
    for _, identifier in ipairs(identifiers) do
        if identifier and out[identifier] == nil then
            local src = getSourceByIdentifier(identifier)
            if src then
                local money = getMoney(src, account)
                out[identifier] = tonumber(money) or 0
            else
                pending[#pending + 1] = identifier
            end
        end
    end
    if #pending == 0 then return out end

    local placeholders = string.rep("?,", #pending):sub(1, -2)
    local rows
    if Config.Framework == "av" then
        rows = MySQL.query.await('SELECT `char_id` AS id, `money` AS data FROM `characters` WHERE `char_id` IN (' .. placeholders .. ')', pending)
    elseif Config.Framework == "qb" or Config.Framework == "qbox" then
        rows = MySQL.query.await('SELECT `citizenid` AS id, `money` AS data FROM `players` WHERE `citizenid` IN (' .. placeholders .. ')', pending)
    elseif Config.Framework == "esx" then
        rows = MySQL.query.await('SELECT `identifier` AS id, `accounts` AS data FROM `users` WHERE `identifier` IN (' .. placeholders .. ')', pending)
    end
    for _, row in ipairs(rows or {}) do
        local ok, decoded = pcall(json.decode, row.data or "{}")
        out[row.id] = (ok and type(decoded) == "table" and tonumber(decoded[account])) or 0
    end
    return out
end

-- Remove money from player
function removeMoney(src, account, amount, reason)
    dbug("removeMoney(src, account, amount)", src, account, amount)
    if not src then return false end
    if Config.UseItemAsMoneyAccount and Config.UseItemAsMoneyAccount[account] then
        dbug("Account "..account.." is configured as item account, using removeItem export instead of money")
        return removeItem(src, account, amount)
    end
    if Config.Framework == "qb" then
        local Player = Core.Functions.GetPlayer(src)
        if Player then
            local Crypto = Player.PlayerData.metadata and Player.PlayerData.metadata.crypto or false
            if Crypto and Crypto[account] then
                Crypto[account] -= amount
                Player.Functions.SetMetaData("crypto", Crypto)
            else
                Player.Functions.RemoveMoney(account, amount)
            end
        end
    elseif Config.Framework == "qbox" then
        local identifier = getIdentifier(src)
        if identifier then
            exports.qbx_core:RemoveMoney(identifier, account, amount, reason or '')
        end
    elseif Config.Framework == "esx" then
        local xPlayer = Core.GetPlayerFromId(src)
        xPlayer.removeAccountMoney(account, amount)
    elseif Config.Framework == "av" then
        exports.av_core:RemoveMoney(src, account, amount, reason or 'av_laptop')
    end
end

-- Has item?
function hasItem(inventory, name, amount)
    if not inventory then return false end
    dbug('hasItem(inventory, name, amount)')
    local qty = amount and tonumber(amount) or 1
    if Config.Inventory == "jaksam_inventory" then
        return exports['jaksam_inventory']:hasItem(inventory, name, qty)
    end
    if Config.Inventory == "ox_inventory" then
        local item = exports['ox_inventory']:GetItem(inventory, name, nil, true)
        if item and tonumber(item) >= qty then
            return true
        else
            return false
        end
    end
    if Config.Inventory == "tgiann-inventory" then
        return exports["tgiann-inventory"]:HasItem(inventory, name, qty)
    end
    if Config.Inventory == "origen_inventory" then
        local count = 0
        local data = exports['origen_inventory']:getInventory(inventory)
        if data and data['inventory'] then
            for _, item in pairs(data['inventory']) do
                if item['name'] == name then
                    count += (item['count'] or 1)
                end
            end
        end
        return (count >= qty)
    end
    if Config.Framework == "qb" then
        return exports[Config.Inventory]:HasItem(inventory, name, qty)
    elseif Config.Framework == "esx" then
        local xPlayer = Core.GetPlayerFromId(inventory)
        local item = xPlayer.getInventoryItem(name)
        if item and item['count'] >= qty then
            return true
        end
    end
    return false
end

-- Get Player Job
function getJob(src)
    if not src then return false end
    if Config.Framework == "qb" then
        local Player = Core.Functions.GetPlayer(src)
        return Player.PlayerData.job
    elseif Config.Framework == "qbox" then
        local Player = getPlayer(src)
        return Player.PlayerData.job
    elseif Config.Framework == "esx" then
        local xPlayer = Core.GetPlayerFromId(src)
        return xPlayer.getJob()
    elseif Config.Framework == "av" then
        return avJob(exports.av_core:GetGroup(src))
    end
end

-- Check if player have X job or job type
function hasJob(source,job)
    if not source or not job then
        print("^3[WARNING] hasJob exports received null as argument (source, job):", source, job)
        return false
    end
    local PlayerJob = getJob(source)
    if type(job) == "string" then
        if PlayerJob and (PlayerJob.name == job or PlayerJob.type == job) then
            return true
        end
    else
        for _, name in pairs(job) do
            if PlayerJob.name == name or PlayerJob.type == name then
                return true
            end
        end
    end
    return false
end

-- Get Player Name
function getName(src)
    if not src then return false end
    if Config.Framework == "qb" then
        local Player = Core.Functions.GetPlayer(src)
        if Player then
            return Player.PlayerData.charinfo.firstname .. ' ' .. Player.PlayerData.charinfo.lastname
        end
    elseif Config.Framework == "qbox" then
        local Player = getPlayer(src)
        if Player then
            return Player.PlayerData.charinfo.firstname .. ' ' .. Player.PlayerData.charinfo.lastname
        end
    elseif Config.Framework == "esx" then
        local xPlayer = Core.GetPlayerFromId(src)
        if xPlayer then
            return xPlayer.getName()
        end
    elseif Config.Framework == "av" then
        local player = exports.av_core:GetPlayer(src)
        if player then
            local id = player.data.identity
            if id then
                return ('%s %s'):format(id.firstName or 'Unknown', id.lastName or '')
            end
            return player.data.name
        end
    end
    return false
end

function getIdentity(src)
    if not src then return nil end
    local out = { firstName = nil, lastName = nil, dob = nil, gender = nil, nationality = nil }
    if Config.Framework == "qb" or Config.Framework == "qbox" then
        local Player = getPlayer(src)
        local info = Player and Player.PlayerData and Player.PlayerData.charinfo or nil
        if info then
            out.firstName = info.firstname
            out.lastName = info.lastname
            out.dob = info.birthdate
            out.gender = (info.gender == 1 or info.gender == "1") and "F" or "M"
            out.nationality = info.nationality
        end
    elseif Config.Framework == "esx" then
        local xPlayer = Core.GetPlayerFromId(src)
        if xPlayer then
            local row = MySQL.single.await("SELECT `firstname`, `lastname`, `dateofbirth`, `sex` FROM `users` WHERE `identifier` = ? LIMIT 1", { xPlayer.identifier })
            if row then
                out.firstName = row.firstname
                out.lastName = row.lastname
                out.dob = row.dateofbirth
                out.gender = row.sex == "f" and "F" or "M"
            end
        end
    elseif Config.Framework == "av" then
        local player = exports.av_core:GetPlayer(src)
        local id = player and player.data and player.data.identity or nil
        if id then
            out.firstName = id.firstName
            out.lastName = id.lastName
            out.dob = id.dob or id.birthdate
            out.gender = id.gender
            out.nationality = id.nationality
        end
    end
    if not out.firstName and not out.lastName then
        local name = getName(src)
        if name then out.firstName = name end
    end
    return out
end

function getMetadata(item, info)
    local metadata = {}
    local slot = 1
    if item and type(item) == "table" and next(item) then
        local itemInfo = item.metadata or item.info or {}
        metadata = itemInfo or {}
        slot = item.slot or 1
    end
    if info and type(info) == "table" and next(info) then
        local itemInfo = info.metadata or info.info or {}
        metadata = itemInfo or {}
        slot = info.slot or 1
    end
    return metadata, slot
end

function getInventoryItem(inventory, name)
    if Config.Inventory == "jaksam_inventory" then
        return exports['jaksam_inventory']:getItemByName(inventory, name)
    end
    if Config.Inventory == "ox_inventory" then
        return exports.ox_inventory:GetItem(inventory, name)
    end
    if Config.Inventory == "origen_inventory" then
        return exports.origen_inventory:GetItemByName(inventory, name)
    end
    return exports[Config.Inventory]:GetItemByName(inventory, name)
end

-- Get All items from Player
function GetInventoryItems(id)
    dbug('GetInventoryItems(id)', id)
    if Config.Inventory == "jaksam_inventory" then
        local items = {}
        local inv = exports['jaksam_inventory']:getInventory(id)
        if inv and inv.items then
            for _, item in pairs(inv.items) do
                items[#items+1] = item
            end
        end
        return items
    end
    if Config.Inventory == "origen_inventory" then
        return exports.origen_inventory:getItems(id)
    end
    if Config.Inventory == "ox_inventory" then
        return exports['ox_inventory']:GetInventoryItems(id)
    end
    if Config.Inventory == "tgiann-inventory" then
        local list = exports["tgiann-inventory"]:GetPlayerItems(id)
        local items = {}
        if list and next(list) then
            for _, item in pairs(list) do
                items[#items+1] = item
            end
        end
        return items
    end
    if Config.Framework == "qbox" then
        print("^1If using Qbox with other inv than ox_inv you need to edit the GetInventoryItems function in laptop/server/editable/exports.lua^7")
    end
    if Config.Framework == "qb" then
        local Player = Core.Functions.GetPlayer(id)
        if Player then
            return Player.PlayerData.items
        end
    end
    if Config.Framework == "esx" then
        local xPlayer = Core.GetPlayerFromId(id)
        if xPlayer then
            return xPlayer.getInventory()
        end
    end
    return {}
end

-- Get all players from X job
function getJobPlayers(job)
    if GetResourceState("av_multijob") == "started" then
        return exports['av_multijob']:getJobPlayers(job)
    end
    if Config.Framework == "qb" then
        local data = {}
        local added = {}
        local Players = Core.Functions.GetQBPlayers()
        for k, v in pairs(Players) do
            if v['PlayerData']['job']['name'] == job then
                data[#data + 1] = {
                    identifier = v['PlayerData']['citizenid'],
                    name = v.PlayerData.charinfo.firstname .. ' ' .. v.PlayerData.charinfo.lastname,
                    grade = v.PlayerData.job.grade,
                }
                added[v['PlayerData']['citizenid']] = true
            end
        end
        local Players2 = MySQL.query.await("SELECT * FROM players WHERE job LIKE '%" .. job .. "%'", {})
        for k, v in pairs(Players2) do
            if not added[v['citizenid']] then
                local Player = getPlayerByIdentifier(v['citizenid'])
                if Player then
                    if Player.PlayerData.job.name == job then
                        data[#data + 1] = {
                            identifier = v['citizenid'],
                            name = Player.PlayerData.charinfo.firstname .. ' ' .. Player.PlayerData.charinfo.lastname,
                            grade = Player.PlayerData.job.grade,
                        }
                    end
                else
                    data[#data + 1] = {
                        identifier = v['citizenid'],
                        name = json.decode(v['charinfo']).firstname .. ' ' .. json.decode(v['charinfo']).lastname,
                        grade = json.decode(v['job']).grade,
                    }
                end
            end
        end
        return data
    elseif Config.Framework == "qbox" then
        local data = {}
        local Players = exports.qbx_core:GetGroupMembers(job, "job")
        if Players and next(Players) then
            for _, v in pairs(Players) do
                local res = exports.qbx_core:GetPlayerByCitizenId(v['citizenid'])
                PlayerData = res and res.PlayerData or false
                if not PlayerData then
                    local offline = exports.qbx_core:GetOfflinePlayer(v['citizenid'])
                    PlayerData = offline and offline.PlayerData or false
                end
                if PlayerData then
                    data[#data + 1] = {
                        identifier = PlayerData['citizenid'],
                        name = PlayerData.charinfo.firstname .. ' ' .. PlayerData.charinfo.lastname,
                        grade = PlayerData.job.grade,
                    }
                end
            end
        end
        return data
    elseif Config.Framework == "esx" then
        local data = {}
        local Players = MySQL.query.await("SELECT * FROM users WHERE job = ?", { job })
        for k, v in pairs(Players) do
            local xPlayer = getPlayerByIdentifier(v['identifier'])
            if xPlayer then
                local job = xPlayer.getJob()
                data[#data + 1] = {
                    identifier = v['identifier'],
                    name = xPlayer.getName(),
                    grade = { name = job.grade_label, level = job.grade },
                }
            else
                if Core.Jobs and not Core.Jobs[v['job']] then
                    Core = exports['es_extended']:getSharedObject()
                end
                local jobData = Core.Jobs[v['job']]
                local myGrade = jobData['grades'] and jobData['grades'][tostring(v['job_grade'])]
                if myGrade then
                    data[#data + 1] = {
                        identifier = v['identifier'],
                        name = v['firstname'] .. ' ' .. v['lastname'],
                        grade = { name = myGrade['label'], level = v['job_grade'] },
                    }
                else
                    dbug("No data for job grade ", v['job_grade'], " in job ", v['job'])
                end
            end
        end
        return data
    elseif Config.Framework == "av" then
        local data = {}
        local players = exports.av_core:GetPlayersByGroup(job)
        for i = 1, #players do
            local p = players[i]
            data[#data + 1] = {
                identifier = p.charId,
                name = p.name,
                grade = { name = p.gradeLabel, level = p.grade, isboss = p.isboss },
            }
        end
        return data
    end
end

function setJob(target, job, grade)
    if GetResourceState("av_multijob") == "started" then
        return exports['av_multijob']:setJob(target,job,grade)
    end
    target = tonumber(target)
    grade = grade or 0
    if Config.Framework == "qb" then
        local Player = Core.Functions.GetPlayer(target)
        if Player then
            if Core.Shared.Jobs[job] then
                Player.Functions.SetJob(job, grade)
                local jobData = Core.Shared.Jobs[job]['grades'][tostring(grade)]
                if not jobData then
                    jobData = Core.Shared.Jobs[job]['grades'][0] or Core.Shared.Jobs[job]['grades'][1]
                end
                if jobData then
                    local info = {
                        name = jobData['name'],
                        onduty = true,
                        isboss = false,
                        payment = jobData['payment'],
                        grade = { name = jobData['name'], level = grade}
                    }
                    MySQL.update.await('UPDATE players SET job = ? WHERE citizenid = ?',
                        { json.encode(info), Player.PlayerData.citizenid })
                    return true
                else
                    print("^3[WARNING]^7 Job "..job.." doesn't have grade 0 or 1")
                end
            end
        end
    elseif Config.Framework == "qbox" then
        local identifier = getIdentifier(target)
        if identifier then
            exports.qbx_core:SetJob(identifier, job, grade)
            exports.qbx_core:Save(target)
            return true
        end
    elseif Config.Framework == "esx" then
        local xPlayer = Core.GetPlayerFromId(target)
        if xPlayer then
            xPlayer.setJob(job, grade)
            MySQL.update.await('UPDATE users SET job = ?, job_grade = ? WHERE identifier = ?', { job, 0, xPlayer
                .identifier })
            return true
        end
    elseif Config.Framework == "av" then
        return exports.av_core:SetGroup(target, job, grade) == true
    end
    return false
end

function setJobGrade(identifier, job, grade)
    dbug("setJobGrade(identifier, job, grade)", identifier, job, grade)
    if GetResourceState("av_multijob") == "started" then
        exports['av_multijob']:setJobGrade(identifier,job,grade)
    end
    grade = grade or 0
    if Config.Framework == "qb" then
        local Player = Core.Functions.GetPlayerByCitizenId(identifier)
        local jobData = Core.Shared.Jobs[job]['grades'][grade]
        if not jobData then
            grade = tonumber(grade)
            jobData = Core.Shared.Jobs[job]['grades'][grade]
        end
        if not jobData then
            print("^3[WARNING] ^7Job grade "..grade.." not found in job "..job)
            return
        end
        if Player then
            Player.Functions.SetJob(job, grade)
        end
        local info = {
            name = job,
            onduty = true,
            isboss = jobData['isboss'],
            payment = jobData['payment'],
            grade = { name = jobData['name'], level = grade }
        }
        MySQL.update.await('UPDATE players SET job = ? WHERE citizenid = ?', { json.encode(info), identifier })
    elseif Config.Framework == "qbox" then
        exports.qbx_core:SetJob(identifier, job, grade or 0)
    elseif Config.Framework == "esx" then
        local xPlayer = Core.GetPlayerFromIdentifier(identifier)
        if xPlayer then
            xPlayer.setJob(job, grade)
        end
        MySQL.update.await('UPDATE users SET job = ?, job_grade = ? WHERE identifier = ?', { job, grade, identifier })
    elseif Config.Framework == "av" then
        local current = exports.av_core:GetGroup(identifier)
        if current and current.name == job then
            exports.av_core:SetGroupGrade(identifier, grade or 0)
        else
            exports.av_core:SetGroup(identifier, job, grade or 0)
        end
    end
end

function toggleDuty(source,state)
    if Config.Framework == "qbox" then
        local identifier = getIdentifier(source)
        if identifier then
            exports.qbx_core:SetJobDuty(identifier, state)
        end
    elseif Config.Framework == "qb" then
        local Player = getPlayer(source)
        if Player then
            Player.Functions.SetJobDuty(state)
        end
    elseif Config.Framework == "esx" then
        local Player = getPlayer(source)
        if Player then -- cmon esx just add a SetDuty function lol
            local job = Player.job
            if not job then return end -- idk just in case
            Player.setJob(job.name, job.grade, state)
        end
    elseif Config.Framework == "av" then

    end
end

function Discord(webhook, message)
    PerformHttpRequest(webhook, function() end, 'POST', json.encode({ username = 'AV Scripts', embeds = message }),
        { ['Content-Type'] = 'application/json' })
end

function getPhone(source)
    local phone = ""
    if Config.Framework == "qb" then
        local Player = Core.Functions.GetPlayer(source)
        if Player then
            phone = Player.PlayerData.charinfo.phone
        end
    elseif Config.Framework == "qbox" then
        local Player = getPlayer(source)
        if Player then
            phone = Player.PlayerData.charinfo.phone
        end
    elseif Config.Framework == "esx" then

    elseif Config.Framework == "av" then

    end
    return phone
end

function addToStash(name, item, count, metadata, slot)
    dbug("addToStash(name,item,count,metadata?,slot?)", name, item, count, metadata and json.encode(metadata) or "no", slot or "no")
    count = count or 1
    if not name or not item then
        warn("addToStash received a nil value (inventory, item, resource)", name, item, GetInvokingResource())
        return
    end
    if Config.Inventory == "jaksam_inventory" then
        local success, result = exports['jaksam_inventory']:addItem(name, item, count, metadata, slot)
        dbug('jaksam addToStash', name, item, count, success, result)
        return success == true
    end
    if Config.Inventory == "qs-inventory" then
        return exports['qs-inventory']:AddItemIntoStash(name, item, count, slot, metadata)
    end
    if Config.Inventory == "ox_inventory" then
        local success, _ = exports['ox_inventory']:AddItem(name, item, count, metadata, slot)
        return success
    end
    if Config.Inventory == "tgiann-inventory" then
        return exports["tgiann-inventory"]:AddItemToSecondaryInventory('stash', name, item, count, slot, metadata)
    end
    if Config.Inventory == "origen_inventory" then
        exports.origen_inventory:addItem(name, item, count, metadata, slot, true)
        return true
    end
    if Config.Inventory == "codem-inventory" then
        local stash_items = exports['codem-inventory']:GetStashItems(name)
        stash_items = stash_items or {}
        if stash_items then
            local slot = slot or #stash_items+1
            local itemInfo = itemList[item] or {}
            stash_items[tostring(slot)] = {
                name = itemInfo.name or item,
                label = itemInfo.label or exports['codem-inventory']:GetItemLabel(item),
                image = itemInfo.image or "",
                weight = itemInfo.weight or 0,
                type = itemInfo.type or 'item',
                amount = count,
                description = itemInfo.description or '',
                slot = slot and tostring(slot) or "1",
                info = metadata or {},
                unique = itemInfo.unique or true,
                useable = itemInfo.useable or false,
                shouldClose = itemInfo.shouldClose or false
            }
            exports['codem-inventory']:UpdateStash(name, stash_items)
            return true
        end
        return false
    end
    if Config.Inventory == "qb-inventory" and not Config.OldQBInventory then
        local res = exports[Config.Inventory]:AddItem(name, item, count, slot, metadata, false)
        return res
    else
        local res = exports[Config.Inventory]:addStashItem(name, slot, slot, item, count, metadata)
        TriggerEvent("inventory:server:SaveInventory", "stash", name)
        return res
    end
end

function getStashItems(name)
    if Config.Inventory == "jaksam_inventory" then
        local items = {}
        local inv = exports['jaksam_inventory']:getInventory(name)
        if inv and inv.items then
            for _, item in pairs(inv.items) do
                items[#items+1] = item
            end
        end
        return items
    end
    if Config.Inventory == "ox_inventory" then
        local inv = exports['ox_inventory']:GetInventory(name)
        return inv and inv.items or false
    end
    if Config.Inventory == "codem-inventory" then
        local items = {}
        local stash = exports[Config.Inventory]:GetStashItems(name)
        if stash and next(stash) then
            for _, v in pairs(stash) do
                items[#items+1] = v
            end
        end
        return items
    end
    if Config.Inventory == "tgiann-inventory" then
        local list = exports["tgiann-inventory"]:GetSecondaryInventoryItems("stash", name)
        local items = {}
        if list and next(list) then
            for _, item in pairs(list) do
                items[#items+1] = item
            end
        end
        return items
    end
    if Config.Inventory == "qb-inventory" and not Config.OldQBInventory then
        local inventories = MySQL.single.await('SELECT `items` FROM `inventories` WHERE `identifier` = ?', {
            name
        })
        if inventories and inventories['items'] then
            return json.decode(inventories['items'])
        end
    else
        local items = exports[Config.Inventory]:GetStashItems(name)
        if items then
            return items
        end
    end
    return false
end

-- Delete all stash items
function wipeStash(name)
    if Config.Inventory == "jaksam_inventory" then
        exports['jaksam_inventory']:clearInventory(name)
        return true
    end
    if Config.Inventory == "ox_inventory" then
        exports['ox_inventory']:ClearInventory(name)
        return
    end
    if Config.Inventory == "qs-inventory" then
        exports['qs-inventory']:ClearOtherInventory('stash', name)
    end
    if Config.Inventory == "tgiann-inventory" then
        exports["tgiann-inventory"]:DeleteInventory('stash', name)
        return
    end
    if Config.Inventory == "origen_inventory" then
        exports['origen_inventory']:ClearInventory(name)
        return
    end
    if Config.Inventory == "codem-inventory" then
        exports['codem-inventory']:UpdateStash(name, {})
        return
    end
    if Config.Inventory == "qb-inventory" and not Config.OldQBInventory then
        exports[Config.Inventory]:ClearStash(name)
        return
    end
    return exports[Config.Inventory]:WipeStash(name)
end

-- Remove a specific item from a stash
function removeStashItem(inv, item, count, metadata, slot)
    dbug('removeStashItem(inv,item,count,metadata,slot)', inv, item, count, metadata, slot)
    if Config.Inventory == "jaksam_inventory" then
        local success, result = exports['jaksam_inventory']:removeItem(inv, item, count, metadata, slot)
        dbug('jaksam removeStashItem', inv, item, count, success, result)
        return success == true
    end
    if Config.Inventory == "ox_inventory" then
        exports['ox_inventory']:RemoveItem(inv, item, count, metadata, slot)
        return
    end
    if Config.Inventory == "tgiann-inventory" then
        local res = exports["tgiann-inventory"]:RemoveItemFromSecondaryInventory('stash', inv, item, count, tostring(slot))
        dbug(res)
        return res
    end
    if Config.Inventory == "origen_inventory" then
        return exports['origen_inventory']:removeItem(inv, item, count, metadata, slot)
    end
    if Config.Inventory == "codem-inventory" then
        local found = false
        local count = count and tonumber(count) or 999
        local stashItems = exports['codem-inventory']:GetStashItems(inv)
        stashItems = stashItems or {}
        local slot = slot and tostring(slot) or false
        if slot then
            local itemExists = stashItems[slot] or false
            if itemExists and itemExists['name'] == item then
                local itemAmount = itemExists.amount or 1
                itemAmount -= count
                if itemAmount <= 0 then
                    stashItems[slot] = nil
                else
                    stashItems[slot].amount = itemAmount
                end
            end
            found = true
        end
        if not found then -- item not found (?)
            for k, v in pairs(stashItems) do
                if v['name'] == item then
                    local itemAmount = v.amount or 1
                    itemAmount -= count
                    if itemAmount <= 0 then
                        stashItems[k] = nil
                    else
                        stashItems[k].amount = itemAmount
                    end
                    found = true
                    break
                end
            end
        end
        if found then
            exports['codem-inventory']:UpdateStash(inv, stashItems)
        end
        return found
    end
    if Config.Inventory == "qs-inventory" then
        exports['qs-inventory']:RemoveItemIntoStash(inv, item, count, slot)
    else
        if Config.Inventory == "qb-inventory" and not Config.OldQBInventory then
            exports[Config.Inventory]:RemoveItem(inv, item, count, slot)
        else
            exports[Config.Inventory]:RemoveFromStash(inv, slot, item, count)
            TriggerEvent("inventory:server:SaveInventory", "stash", inv)
        end
    end
end

-- Register new stash
function registerStash(name, label, slots, weight)
    dbug("registerStash(name, label, slots, weight, resource)", name, label, slots, weight, GetInvokingResource())
    if not name or not slots or not weight then
        return false
    end
    if type(name) ~= "string" then
        return false
    end
    if Config.Inventory == "jaksam_inventory" then
        return exports['jaksam_inventory']:registerStash({
            id = name,
            label = label or name,
            maxSlots = slots or 10,
            maxWeight = weight or 100000,
            isPrivate = false,
            temporary = false,
            runtimeOnly = true
        })
    end
    if Config.Inventory == "ox_inventory" then
        exports['ox_inventory']:RegisterStash(name, label or name, slots, weight)
        return true
    end
    if Config.Inventory == "tgiann-inventory" then
        exports["tgiann-inventory"]:RegisterStash(name, label or name, slots, weight)
        return true
    end
    if Config.Inventory == "origen_inventory" then
        exports['origen_inventory']:RegisterStash(name, {
            label = label or name,
            slots = slots or 10,
            weight = weight or 10
        })
        return true
    end
    if Config.Inventory == "qb-inventory" and not Config.OldQBInventory then
        local data = {
            label = label,
            maxweight = weight,
            slots = slots
        }
        return exports['qb-inventory']:CreateInventory(name, data)
    end
    return false
end

function canCarryItem(inventory, item, amount)
    if Config.Inventory == "jaksam_inventory" then
        return exports['jaksam_inventory']:canCarryItem(inventory, item, amount) == true
    end
    if Config.Inventory == "ox_inventory" then
        return exports['ox_inventory']:CanCarryItem(inventory, item, amount)
    end
    return true
end

-- Is Player boss?
function isBoss(src)
    if Config.Framework == "qb" then
        local Player = Core.Functions.GetPlayer(src)
        return Player.PlayerData.job.isboss
    elseif Config.Framework == "qbox" then
        local Player = getPlayer(src)
        return Player.PlayerData.job.isboss
    elseif Config.Framework == "esx" then
		local xPlayer = Core.GetPlayerFromId(src)
		return Config.BossGrades[xPlayer.job.grade_name]
    elseif Config.Framework == "av" then
        return exports.av_core:IsBoss(src)
    end
    return false
end

function getJobData(job)
    if Config.Framework == "qb" then
        return Core.Shared.Jobs[job]
    elseif Config.Framework == "qbox" then
        return exports.qbx_core:GetJob(job)
    elseif Config.Framework == "esx" then
		if Core.Jobs and not Core.Jobs[job] then
            Core = exports['es_extended']:getSharedObject()
        end
        return Core.Jobs[job]
    elseif Config.Framework == "av" then
        return avJob(exports.av_core:GetGroups()[job])
    end
    return false
end

-- Get all available grades from X job
function getJobGrades(job)
    local grades = {}
    if Config.Framework == "qb" then
        local jobData = Core.Shared.Jobs[job]
        if jobData then
            for k, v in pairs(jobData.grades) do
                grades[#grades+1] = {
                    value = tostring(k),
                    label = v.name
                }
            end
        end
        return grades
    elseif Config.Framework == "qbox" then
        local jobData = exports.qbx_core:GetJob(job)
        if jobData then
            for k, v in pairs(jobData.grades) do
                grades[#grades+1] = {
                    value = tostring(k),
                    label = v.name
                }
            end
        end
        return grades
    elseif Config.Framework == "esx" then
        if not Core or not Core.Jobs then
            Core = exports['es_extended']:getSharedObject()
        end
        if not Core.Jobs[job] then
            Core = exports['es_extended']:getSharedObject() -- don't ask me why, this shitty Framework gives a lot of problems -.-
        end
        if Core and Core.Jobs[job] then
            local jobData = Core.Jobs[job].grades
            for k, v in pairs(jobData) do
                grades[#grades+1] = {
                    value = k,
                    label = v.label
                }
            end
        else
            print("[ERROR] Job "..job.." doesn't exist in Core? couldn't be found in Core.Jobs table")
        end
    elseif Config.Framework == "av" then
        grades[#grades+1] = {value = "0", label = "Member"}
        grades[#grades+1] = {value = "1", label = "Boss"}
    end
    return grades
end

-- Get all available jobs names and label (return a table with name and label)
function getAllJobs()
    local added = {}
    if Config.Framework == "qb" then
        local allJobs = Core.Shared.Jobs
        local result = {}
        for k, v in pairs(allJobs) do
            if not added[k] then
                added[k] = true
                result[#result+1] = {
                    value = k,
                    label = v['label'] or k
                }
            end
        end
        return result
    end
    if Config.Framework == "qbox" then
        local allJobs = exports.qbx_core:GetJobs()
        local result = {}
        for k, v in pairs(allJobs) do
            if not added[k] then
                added[k] = true
                result[#result+1] = {
                    value = k,
                    label = v['label'] or k
                }
            end
        end
        return result
    end
    if Config.Framework == "esx" then
        local allJobs = MySQL.query.await("SELECT * FROM jobs")
        local result = {}
        for _, v in pairs(allJobs) do
            if not added[v['name']] then
                added[v['name']] = true
                result[#result+1] = {
                    value = v['name'],
                    label = v['label'] or v['name']
                }
            end
        end
        return result
    end
    if Config.Framework == "av" then
        local result = {}
        local groups = exports.av_core:GetGroups()
        for name, g in pairs(groups or {}) do
            if not added[name] then
                added[name] = true
                result[#result+1] = { value = name, label = g.label or name }
            end
        end
        return result
    end
    return {}
end

-- When av_banking is running, society money lives in its society accounts
local function bankingSocieties()
    return GetResourceState("av_banking") == "started"
end

-- Returns society money or false
function getSociety(name)
    dbug("getSociety(name)", name)
    if not name then print('[ERROR] Function getSociety received NULL as argument') return end
    if bankingSocieties() then
        return exports['av_banking']:getSocietyMoney(name)
    end
    local res = MySQL.single.await('SELECT money FROM av_society WHERE job = ?', {name})
    if res and res['money'] then
        return res['money']
    else
        return false
    end
end
--[[
    source:string|null Who's sending the money, null = the script/server itself is sending the money
    job:string The job name of the society
    amount:number The amount of money to add
    description?:string A description to show in the business logs (if av_business is installed and enabled)
]]--
function addSociety(source, job, amount, name, description)
    dbug("addSociety(source, job, amount, name, description)", source, job, amount, name, description)
    if bankingSocieties() then
        local added = exports['av_banking']:addSocietyMoney(job, amount, name, description)
        if added and avBusiness then
            exports['av_business']:addMoney(name, job, amount, description)
        end
        return added
    end
    if avBusiness then
        exports['av_business']:addMoney(name, job, amount, description)
    end
    local exists = getSociety(job)
    if exists then
        MySQL.update.await('UPDATE av_society SET money = (money + ?) WHERE job = ?', {amount, job})
    else
        MySQL.insert.await('INSERT INTO av_society (job, money) VALUES (?, ?)', {job, amount})
    end
end

function removeSociety(src, job, amount, name, description)
    dbug("removeSociety(src, job, amount, name, description)", src, job, amount, name, description)
    if bankingSocieties() then
        local removed = exports['av_banking']:removeSocietyMoney(job, amount, name, description)
        if removed and avBusiness then
            exports['av_business']:removeMoney(name, job, amount, description)
        end
        return removed
    end
    if avBusiness then
        exports['av_business']:removeMoney(name, job, amount, description)
    end
    MySQL.update.await('UPDATE av_society SET money = (money - ?) WHERE job = ?', {amount, job})
end

function newSociety(job, label) -- Triggered when getSociety returns false in av_business:
    dbug("newSociety(job, label)", job, label)
    if bankingSocieties() then
        return exports['av_banking']:createSocietyAccount(job)
    end
    local exists = MySQL.single.await('SELECT `money` FROM `av_society` WHERE `job` = ?', {job})
    if exists then return end
    MySQL.insert.await('INSERT INTO `av_society` (`job`, `money`) VALUES (?, ?)', {job, 0})
end

function setOfflineJob(identifier, jobName, grade)
    grade = grade or 0
    if not identifier or not jobName then
        dbug("setOfflineJob(identifier, jobName) received a nil parameter", identifier, jobName)
        return
    end
    if GetResourceState("av_multijob") == "started" then
        return exports['av_multijob']:setOfflineJob(identifier,jobName)
    end
    dbug("setOfflineJob(identifier, jobName, grade)", identifier, jobName, grade)
    if Config.Framework == "qb" then
        local jobData = Core.Shared.Jobs[jobName] and Core.Shared.Jobs[jobName]['grades'][tostring(grade)] or false
        if not jobData then
            jobData = Core.Shared.Jobs[jobName] and (Core.Shared.Jobs[jobName]['grades'][grade] or Core.Shared.Jobs[jobName]['grades']["0"])
        end
        local newJob = {
            name = jobData['name'] or "unemployed",
            onduty = true,
            isboss = false,
            payment = jobData['payment'] or 10,
            grade = { name = jobData['name'] or "Freelancer", level = grade }
        }
        MySQL.update.await('UPDATE players SET job = ? WHERE citizenid = ?', { json.encode(newJob), identifier })
    elseif Config.Framework == "qbox" then
        exports.qbx_core:SetJob(identifier, jobName, grade or grade)
    elseif Config.Framework == "esx" then
        MySQL.update.await('UPDATE users SET job = ?, job_grade = ? WHERE identifier = ?',
            { jobName, grade, identifier })
    elseif Config.Framework == "av" then
        exports.av_core:SetGroup(identifier, jobName, grade or 0)
    end
end

function itemExists(item)
    if Config.Inventory == "jaksam_inventory" then
        return exports['jaksam_inventory']:getStaticItem(item)
    end
    if Config.Inventory == "ox_inventory" then
        local items = exports['ox_inventory']:Items()
        return items[item]
    end
    if Config.Inventory == "tgiann-inventory" then
        local items = exports["tgiann-inventory"]:Items()
        return items[item]
    end
    if Config.Framework == 'qb' then
        return Core.Shared.Items[item]
    elseif Config.Framework == 'esx' then
        if Core and not Core.Items then
            Core = exports['es_extended']:getSharedObject()
        end
        return Core.Items[item]
    end
    return false
end

function getItemBySlot(inventory,slot)
    dbug("getItemBySlot(inventory, slot)", inventory, slot)
    if Config.Inventory == "jaksam_inventory" then
        return exports['jaksam_inventory']:getItemFromSlot(inventory, slot)
    end
    if Config.Inventory == "ox_inventory" then
        return exports['ox_inventory']:GetSlot(inventory, slot)
    end
    if Config.Inventory == "origen_inventory" then
        return exports.origen_inventory:getSlot(inventory, slot)
    end
    return exports[Config.Inventory]:GetItemBySlot(inventory, slot)
end

function getNumPlayersFromJob(job) -- used by /cops.lua to get online players from specific job/job type
    if not job then return end
    local amount = 0
    if type(job) == "string" and alreadyCounted[job] then
        return alreadyCounted[job]
    end
    if Config.Framework == "qbox" then
        if type(job) == "string" then
            local count, _ = exports['qbx_core']:GetDutyCountJob(job)
            return count
        else
            for _, v in pairs(job) do
                local count, _ = exports['qbx_core']:GetDutyCountJob(v)
                amount += count
                alreadyCounted[v] = amount
            end
            return amount
        end
    end
    if Config.Framework == "qb" then
        if type(job) == "string" then
            local players = Core.Functions.GetQBPlayers()
            for _, v in pairs(players) do
                if v and (v.PlayerData.job.type == job or v.PlayerData.job.name == job) and v.PlayerData.job.onduty then
                    amount += 1
                    alreadyCounted[job] = amount
                end
            end
            return amount
        else
            local players = Core.Functions.GetQBPlayers()
            for _, v in pairs(job) do
                for _, j in pairs(players) do
                    if j and (j.PlayerData.job.type == v or j.PlayerData.job.name == v) and j.PlayerData.job.onduty then
                        amount += 1
                        alreadyCounted[v] = amount
                    end
                end
            end
            return amount
        end
    elseif Config.Framework == "esx" then
        if type(job) == "string" then
            local xPlayers = Core.GetExtendedPlayers('job', job)
            amount = #xPlayers
            alreadyCounted[job] = amount
            return amount
        else
            for _, v in pairs(job) do
                local xPlayers = Core.GetExtendedPlayers('job', v)
                amount += #xPlayers
                alreadyCounted[v] = amount
            end
            return amount
        end
    elseif Config.Framework == "av" then
        local function countOnline(group)
            local players = exports.av_core:GetPlayersByGroup(group)
            local c = 0
            for i = 1, #players do
                if players[i].online then c += 1 end
            end
            return c
        end
        if type(job) == "string" then
            amount = countOnline(job)
            alreadyCounted[job] = amount
        else
            for _, v in pairs(job) do
                amount += countOnline(v)
                alreadyCounted[v] = amount
            end
        end
        return amount
    end
    return amount
end

function addRestricted(name)
    if Config.Inventory == "qb-inventory" and not Config.OldQBInventory then
        exports[Config.Inventory]:addRestricted(name)
    end
end

function getAllItems()
    if itemList and next(itemList) then return itemList end
    local list = {}
    local usingInv = false
    if Config.Inventory == "jaksam_inventory" then
        list = exports["jaksam_inventory"]:getStaticItemsList()
        usingInv = true
    end
    if Config.Inventory == "ox_inventory" or Config.Inventory == "origen_inventory" or Config.Inventory == "tgiann-inventory" then
        list = exports[Config.Inventory]:Items()
        usingInv = true
    end
    if Config.Inventory == "codem-inventory" then
        list = itemList or {}
        usingInv = true
    end
    if Config.Inventory == "qs-inventory" then
        list = exports['qs-inventory']:GetItemList()
        usingInv = true
    end
    if Config.Framework == "qb" and not usingInv then
        list = Core.Shared and Core.Shared.Items or {}
    end
    if list and next(list) then
        for name, item in pairs(list) do
            itemList = itemList or {}
            itemList[#itemList+1] = {
                value = name and tostring(name) or "unknown",
                label = item.label and tostring(item.label) or name,
            }
        end
    end
    return itemList
end

function getItemCount(inventory, item)
    if Config.Inventory == "ox_inventory" then
        local count = exports['ox_inventory']:GetItemCount(inventory, item)
        dbug(Config.Inventory, "getItemCount(inventory, item)", inventory, item, count)
        return count or 0
    end
    if Config.Inventory == "qs-inventory" then
        local count = exports['qs-inventory']:GetItemTotalAmount(inventory, item)
        dbug(Config.Inventory, "getItemCount(inventory, item)", inventory, item, count)
        return count or 0
    end
    if Config.Inventory == "tgiann-inventory" then
        local count = exports["tgiann-inventory"]:GetItemCount(inventory, item)
        dbug(Config.Inventory, "getItemCount(inventory, item)", inventory, item, count)
        return count or 0
    end
    if Config.Inventory == "origen_inventory" then
        local count = exports['origen_inventory']:getItemCount(inventory, item)
        dbug(Config.Inventory, "getItemCount(inventory, item)", inventory, item, count)
        return count or 0
    end
    if Config.Inventory == "jaksam_inventory" then
        local count = exports['jaksam_inventory']:getTotalItemAmount(inventory, item)
        dbug(Config.Inventory, "getItemCount(inventory, item)", inventory, item, count)
        return count or 0
    end
    if Config.Inventory == "codem-inventory" then
        local count = exports['codem-inventory']:GetItemsTotalAmount(inventory, item)
        dbug(Config.Inventory, "getItemCount(inventory, item)", inventory, item, count)
        return count or 0
    end
    if Config.Inventory == "qb-inventory" then
        local count = exports['qb-inventory']:GetItemCount(inventory, item)
        dbug(Config.Inventory, "getItemCount(inventory, item)", inventory, item, count)
        return count or 0
    end
    warn("getItemCount(inventory, item) does not support the current inventory (?)", inventory, item, Config.Inventory)
    return 0
end

function lockStash(name, state)
    if not name then return end
    GlobalState["stash_"..name] = state
end

function isStashLocked(name)
    if not name then return end
    return GlobalState["stash_"..name] == true
end

-- Export List
exports('getSourceByIdentifier', getSourceByIdentifier)
exports('getPlayerByIdentifier', getPlayerByIdentifier)
exports('getPermission', getPermission)
exports('getIdentifier', getIdentifier)
exports('lockStash', lockStash)
exports('isStashLocked', isStashLocked)
exports('getPlayer', getPlayer)
exports('savePlayer', savePlayer)
exports('registerItem', registerItem)
exports('addItem', addItem)
exports('removeItem', removeItem)
exports('getMoney', getMoney)
exports('addMoney', addMoney)
exports('addMoneyOffline', addMoneyOffline)
exports('getMoneyOffline', getMoneyOffline)
exports('getMoneyOfflineBatch', getMoneyOfflineBatch)
exports('removeMoney', removeMoney)
exports('hasItem', hasItem)
exports('getJob', getJob)
exports('hasJob', hasJob)
exports('getName', getName)
exports('getMetadata', getMetadata)
exports('getItem', getInventoryItem)
exports('getInventoryItem', getInventoryItem)
exports('getJobPlayers', getJobPlayers)
exports('setJob', setJob)
exports('setJobGrade', setJobGrade)
exports('toggleDuty', toggleDuty)
exports('setOfflineJob', setOfflineJob)
exports('Discord', Discord)
exports('getPhone', getPhone)
exports('canCarryItem', canCarryItem)
exports('addToStash', addToStash)
exports('getStashItems', getStashItems)
exports('wipeStash', wipeStash)
exports('removeStashItem', removeStashItem)
exports('registerStash', registerStash)
exports('isBoss', isBoss)
exports('getJobData', getJobData)
exports('getJobGrades', getJobGrades)
exports('newSociety', newSociety)
exports('removeSociety', removeSociety)
exports('addSociety', addSociety)
exports('getSociety', getSociety)
exports('getAllJobs', getAllJobs)
exports('itemExists', itemExists)
exports('getItemBySlot', getItemBySlot)
exports('getCore', getCore)
exports('setItemMetadata', setItemMetadata)
exports('getNumPlayersFromJob', getNumPlayersFromJob)
exports('getInventoryItems', GetInventoryItems)
exports('getItemLabel', getItemLabel)
exports('addRestricted', addRestricted)
exports('getAllItems', getAllItems)
exports('avBusiness', function() avBusiness = true end)
exports('getItemCount', getItemCount)