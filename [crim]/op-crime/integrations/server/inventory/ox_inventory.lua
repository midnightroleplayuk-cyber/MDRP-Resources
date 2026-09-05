if Config.Inventory.inventoryScript ~= "ox_inventory" then return end

while Framework == nil do Wait(5) end

Fr.RegisterServerCallback('op-crime:searchPlayer', function(source, cb, target)
    if GlobalState.handcuffedPlayers[tostring(target)] or Fr.IsPlayerDead(target) then
        exports.ox_inventory:forceOpenInventory(source, 'player', tonumber(target))
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

        exports.ox_inventory:RegisterStash(stashName, orgLabel, 500, capacity * 1000)
    end
end

function registerNewOrgStash(orgId, orgLabel)
    exports.ox_inventory:RegisterStash("organisation_" .. orgId, orgLabel, 500, Config.Misc.defaultStashWeight * 1000)
end

function updateOrgStash(orgId, orgLabel, Capacity)
    exports.ox_inventory:RegisterStash("organisation_" .. orgId, orgLabel, 500, Capacity * 1000)
end

function registerStashFurniture(furnitureId, capacity, slots, label)
    exports.ox_inventory:RegisterStash("furniture_storage_" .. furnitureId, label, slots, capacity)
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
        --exports.ox_inventory:AddItem('organisation_' .. orgId, reward.nameSpawn, reward.amount, reward.metadata or {})
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