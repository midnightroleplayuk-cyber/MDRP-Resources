if Config.Inventory.inventoryScript ~= "one_inventory" then return end

while Framework == nil do Wait(5) end

Fr.RegisterServerCallback('op-crime:searchPlayer', function(source, cb, target)
    if GlobalState.handcuffedPlayers[tostring(target)] or Fr.IsPlayerDead(target) then
        exports.one_inventory:OpenInventory(source, 'player', tonumber(target))
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

local function openOneOrgStash(src, orgJobId, label, capacity)
    exports["one_inventory"]:OpenInventory(src, "stash", {
        id = "organisation_" .. orgJobId,
        owner = false,
        maxWeight = capacity,
        slots = 50
    })
end

RegisterNetEvent('op-crime:openOneStash', function()
    local src = source
    local identifier = trim(Fr.GetIndentifier(src))

    local playerObject = playersJobs[identifier]
    if playerObject then
        local org = organisations[tostring(playerObject.jobId)]
        if not org then return end

        local capacity = (org.upgrades.stashCapacity or 0) * 1000
        return openOneOrgStash(src, playerObject.jobId, org.label, capacity)
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
    return openOneOrgStash(src, gangJobId, org.label, capacity)
end)

RegisterNetEvent('op-crime:openOneStash_furniture', function(stashName, capacity, slots, label)
    local src = source
    local identifier = trim(Fr.GetIndentifier(src))

    local playerObject = playersJobs[identifier]
    if playerObject then
        local org = organisations[tostring(playerObject.jobId)]
        if not org then return end

        exports["one_inventory"]:OpenInventory(src, "stash", {
            id = stashName,
            owner = false,
            maxWeight = capacity,
            slots = slots
        })
        return 
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

    exports["one_inventory"]:OpenInventory(src, "stash", {
        id = stashName,
        owner = false,
        maxWeight = capacity,
        slots = slots
    })
end)
