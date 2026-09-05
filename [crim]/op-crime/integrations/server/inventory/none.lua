if Config.Inventory.inventoryScript ~= "none" then return end

while Framework == nil do Wait(5) end

Fr.RegisterServerCallback('op-crime:searchPlayer', function(source, cb, target)
    if GlobalState.handcuffedPlayers[tostring(target)] or Fr.IsPlayerDead(target) then
        local xPlayer = Fr.getPlayerFromId(playerId)
        if xPlayer then
            local inventory = Fr.getInventory(xPlayer)
            cb(inventory)
        else
            cb(false)
        end
    else    
        cb(false)
    end
end)

RegisterServerEvent('op-crime:confiscatePlayerItem', function(playerId, amount, itemName)
    if GlobalState.handcuffedPlayers[tostring(playerId)] or Fr.IsPlayerDead(playerId) then
        local xPlayer = Fr.getPlayerFromId(playerId)
        if not xPlayer then return end

        local inventory = Fr.getInventory(xPlayer)

        local canProceed = false
        for k, v in pairs(inventory) do
            if v.name == itemName then
                local count = v.amount or v.count
                if count >= amount then
                    canProceed = true
                    Fr.removeItem(xPlayer, itemName, amount)
                    break;
                end
            end
        end

        if canProceed then 
            local xRemover = Fr.getPlayerFromId(source)
            if not xRemover then return end

            Fr.addItem(xRemover, itemName, amount)
        end
    end
end)


function registerStashes()
end

function registerNewOrgStash(orgId, orgLabel)
    Stashes[tostring(orgId)] = {}
end

function updateOrgStash(orgId, orgLabel, Capacity)
end

function registerStashFurniture(furnitureId, capacity, slots, label)
end

-----------------------------------------------
-- ASSIGN REWARD TO ORG
-----------------------------------------------

function assignReward(reward, orgId, playerId)
    if not orgId then
        print('[ERROR] - Unable to assign reward by Player:', playerId)
        print('reward.nameSpawn', reward.nameSpawn)
        return
    end

    if reward.type == "item" or reward.type == "weapon" then
        local TempThisStash = Stashes[tostring(orgId)]

        if TempThisStash then
            if TempThisStash[reward.nameSpawn] then
                TempThisStash[reward.nameSpawn].quantity = TempThisStash[reward.nameSpawn].quantity + reward.amount
                MySQL.Async.execute("UPDATE `opcrime_stashes` SET `quantity` = @quantity WHERE `jobId` = @jobId AND `itemName` = @itemName", {
                    ['@quantity'] = TempThisStash[reward.nameSpawn].quantity,
                    ['@jobId'] = orgId,
                    ['@itemName'] = reward.nameSpawn,
                })
            else
                local itemData = Fr.getItemInfo(reward.nameSpawn)

                if not itemData then
                    itemData = {
                        weight = 5,
                        label = reward.nameSpawn
                    }
                end

                TempThisStash[reward.nameSpawn] = {
                    weight = itemData.weight,
                    itemName = reward.nameSpawn,
                    quantity = reward.amount, 
                    jobId = orgId,
                    label = itemData.label,
                }
                MySQL.Async.execute("INSERT INTO `opcrime_stashes`(`jobId`, `itemName`, `quantity`, `weight`, `label`) VALUES (?, ?, ?, ?, ?)", 
                {orgId, reward.nameSpawn, reward.amount, itemData.weight, itemData.label})
            end

            Stashes[tostring(orgId)] = TempThisStash
        end
    elseif reward.type == "money" then
        addOrgMoney("balance", reward.amount, orgId)
    elseif reward.type == "black_money" then
        addOrgMoney("dirtymoney", reward.amount, orgId)
    elseif reward.type == "car" then
        insertCarToOrg(reward.nameSpawn, orgId)
    end
end