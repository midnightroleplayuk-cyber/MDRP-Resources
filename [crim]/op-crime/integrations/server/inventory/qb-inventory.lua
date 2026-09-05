if Config.Inventory.inventoryScript ~= "qb-inventory" then return end

while Framework == nil do Wait(5) end

Fr.RegisterServerCallback('op-crime:searchPlayer', function(source, cb, target)
    if GlobalState.handcuffedPlayers[tostring(target)] or Fr.IsPlayerDead(target) then
        exports['qb-inventory']:OpenInventoryById(source, playerId)
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
        --exports['qb-inventory']:AddItem('organisation_' .. orgId, reward.nameSpawn, reward.amount, nil, false, "")
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

local function openQBOrgStash(src, orgJobId, label, capacity)
    local data = {
        label = label,
        maxweight = capacity,
        slots = 500
    }

    exports['qb-inventory']:OpenInventory(src, ("organisation_%s"):format(orgJobId), data)
end

RegisterNetEvent('op-crime:openQBStash', function()
    local src = source
    local identifier = trim(Fr.GetIndentifier(src))

    local playerObject = playersJobs[identifier]
    if playerObject then
        local org = organisations[tostring(playerObject.jobId)]
        if not org then return end

        local capacity = (org.upgrades.stashCapacity or 0) * 1000
        return openQBOrgStash(src, playerObject.jobId, org.label, capacity)
    end

    local xPlayer = Fr.getPlayerFromId(src)
    if not xPlayer then return end

    local jobData = Fr.GetPlayerJob(xPlayer)
    if not jobData or not jobData.name then return end

    if not (Config.Raids and Config.Raids.allowedJobs and Config.Raids.allowedJobs[jobData.name]) then return end
    if not (Config.Raids.raidableElements and Config.Raids.raidableElements.stash) then return end

    local raid = CurrentRaids and CurrentRaids[jobData.name]
    if not raid or not raid.gangDetails or not raid.gangDetails.jobId then return end

    local gangJobId = raid.gangDetails.jobId
    local org = organisations[tostring(gangJobId)]
    if not org then return end

    local capacity = (org.upgrades.stashCapacity or 0) * 1000
    return openQBOrgStash(src, gangJobId, org.label, capacity)
end)

RegisterNetEvent('op-crime:openQBStash_furniture', function(stashName, capacity, slots, label)
    local src = source
    local identifier = trim(Fr.GetIndentifier(src))

     local data = {
        label = label,
        maxweight = capacity,
        slots = slots
    }

    local playerObject = playersJobs[identifier]
    if playerObject then
        local org = organisations[tostring(playerObject.jobId)]
        if not org then return end
       
        return exports['qb-inventory']:OpenInventory(src, stashName, data)
    end

    local xPlayer = Fr.getPlayerFromId(src)
    if not xPlayer then return end

    local jobData = Fr.GetPlayerJob(xPlayer)
    if not jobData or not jobData.name then return end

    if not (Config.Raids and Config.Raids.allowedJobs and Config.Raids.allowedJobs[jobData.name]) then return end
    if not (Config.Raids.raidableElements and Config.Raids.raidableElements.stash) then return end

    local raid = CurrentRaids and CurrentRaids[jobData.name]
    if not raid or not raid.gangDetails or not raid.gangDetails.jobId then return end

    local gangJobId = raid.gangDetails.jobId
    local org = organisations[tostring(gangJobId)]
    if not org then return end

    return exports['qb-inventory']:OpenInventory(src, stashName, data)
end)
