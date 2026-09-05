if Config.Inventory.inventoryScript ~= "old-qb-inventory" then return end

while Framework == nil do Wait(5) end

Fr.RegisterServerCallback('op-crime:searchPlayer', function(source, cb, target)
    if GlobalState.handcuffedPlayers[tostring(target)] or Fr.IsPlayerDead(target) then
        cb('ok')
    else    
        cb(false)
    end
end)

function registerStashes()
end

function registerNewOrgStash(orgId, orgLabel)
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
        local xPlayer = Fr.getPlayerFromId(playerId)
        if xPlayer then
            Fr.addItem(xPlayer, reward.nameSpawn, reward.amount)
        end
    elseif reward.type == "money" then
        addOrgMoney("balance", reward.amount, orgId)
    elseif reward.type == "black_money" then
        addOrgMoney("dirtymoney", reward.amount, orgId)
    elseif reward.type == "car" then
        insertCarToOrg(reward.nameSpawn, orgId)
    end
end