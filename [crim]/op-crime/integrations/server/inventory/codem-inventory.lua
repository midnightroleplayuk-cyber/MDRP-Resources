if Config.Inventory.inventoryScript ~= "codem-inventory" then return end

while Framework == nil do Wait(5) end

Fr.RegisterServerCallback('op-crime:searchPlayer', function(source, cb, target)
    if GlobalState.handcuffedPlayers[tostring(target)] or Fr.IsPlayerDead(target) then
        local xPlayer = Fr.getPlayerFromId(target)
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
end

function updateOrgStash(orgId, orgLabel, Capacity)
end

function registerStashFurniture(furnitureId, capacity, slots, label)
end

Fr.RegisterServerCallback('op-crime:codem:getStashCapacity', function(source, cb, jobId)
    local org = organisations[tostring(jobId)]
    if not org then 
        print('Target job id:', jobId)
        print("No org! Returning 0 capacity to client")
        cb(0) 
        return
    end

    local capacity = (org.upgrades.stashCapacity or 0) * 1000
    print('Stash capacity:', capacity, jobId)
    return cb(capacity)
end)

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
        exports['codem-inventory']:AddItem(playerId, reward.nameSpawn, reward.amount)
    elseif reward.type == "money" then
        addOrgMoney("balance", reward.amount, orgId)
    elseif reward.type == "black_money" then
        addOrgMoney("dirtymoney", reward.amount, orgId)
    elseif reward.type == "car" then
        insertCarToOrg(reward.nameSpawn, orgId)
    end
end