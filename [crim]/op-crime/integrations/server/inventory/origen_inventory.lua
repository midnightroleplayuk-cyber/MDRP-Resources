if Config.Inventory.inventoryScript ~= "origen_inventory" then return end

while Framework == nil do Wait(5) end

Fr.RegisterServerCallback('op-crime:searchPlayer', function(source, cb, target)
    if GlobalState.handcuffedPlayers[tostring(target)] or Fr.IsPlayerDead(target) then
        cb('ok')
    else    
        cb(false)
    end
end)

function registerStashes()
    for k, v in pairs(organisations) do
        local stashName = "organisation_" .. v.id
        local orgLabel = v.label
        local capacity = getOrgStashCapacityKg(v.upgrades)
        exports.origen_inventory:registerStash(stashName, orgLabel, 500, capacity * 1000)
    end
end

function registerNewOrgStash(orgId, orgLabel)
    exports.origen_inventory:registerStash("organisation_" .. orgId, orgLabel, 500, Config.Misc.defaultStashWeight * 1000)
end

function updateOrgStash(orgId, orgLabel, Capacity)
    exports.origen_inventory:registerStash("organisation_" .. orgId, orgLabel, 500, Capacity * 1000)
end

function registerStashFurniture(furnitureId, capacity, slots, label)
    exports.origen_inventory:registerStash("furniture_storage_" .. furnitureId, label, slots, capacity)
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
        --local success, msgOrItem = exports.origen_inventory:addItem('organisation_' .. orgId, reward.nameSpawn, reward.amount, false, false, true)
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