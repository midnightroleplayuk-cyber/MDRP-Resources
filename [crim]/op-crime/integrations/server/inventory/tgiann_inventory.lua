if Config.Inventory.inventoryScript ~= "tgiann_inventory" then return end

while Framework == nil do Wait(5) end

Fr.RegisterServerCallback('op-crime:searchPlayer', function(source, cb, target)
    if GlobalState.handcuffedPlayers[tostring(target)] or Fr.IsPlayerDead(target) then
        local playerId = tonumber(target)
        exports["tgiann-inventory"]:OpenInventoryById(source, playerId, true)
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

        exports["tgiann-inventory"]:RegisterStash(stashName, orgLabel, 500, capacity * 1000)
    end
end

function registerNewOrgStash(orgId, orgLabel)
    exports["tgiann-inventory"]:RegisterStash("organisation_" .. orgId, orgLabel, 500, Config.Misc.defaultStashWeight * 1000)
end

function updateOrgStash(orgId, orgLabel, Capacity)
    local Inv = exports["tgiann-inventory"]:GetInventory("organisation_" .. orgId, "stash")
    if not Inv then return end
    local lvlData = config.stash[lvl]
    Inv.Functions.UpdateInventoryData({
        MaxWeight = Capacity * 1000,
        MaxSlots = 500
    })
end

function registerStashFurniture(furnitureId, capacity, slots, label)
    exports["tgiann-inventory"]:RegisterStash("furniture_storage_" .. furnitureId, label, slots, capacity)
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
        --exports["tgiann-inventory"]:AddItemToSecondaryInventory("stash", 'organisation_' .. orgId, reward.nameSpawn, reward.amount)
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

local function openTgiannOrgStash(src, orgJobId, label, capacity)
    exports["tgiann-inventory"]:OpenInventory(src, "stash", ("organisation_%s"):format(orgJobId), {
        label = label,         
        maxweight = capacity,
        slots = 50,             
    })
end

RegisterNetEvent('op-crime:openTgiannStash', function()
    local src = source
    local identifier = trim(Fr.GetIndentifier(src))

    local playerObject = playersJobs[identifier]
    if playerObject then
        local org = organisations[tostring(playerObject.jobId)]
        if not org then return end

        local capacity = (org.upgrades.stashCapacity or 0) * 1000
        return openTgiannOrgStash(src, playerObject.jobId, org.label, capacity)
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
    return openTgiannOrgStash(src, gangJobId, org.label, capacity)
end)

RegisterNetEvent('op-crime:openTgiannStash_furniture', function(stashName, capacity, slots, label)
    local src = source
    local identifier = trim(Fr.GetIndentifier(src))

    local playerObject = playersJobs[identifier]
    if playerObject then
        local org = organisations[tostring(playerObject.jobId)]
        if not org then return end

        exports["tgiann-inventory"]:OpenInventory(src, "stash", stashName, {
            label = label,         
            maxweight = capacity,
            slots = slots,             
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

    exports["tgiann-inventory"]:OpenInventory(src, "stash", stashName, {
        label = label,         
        maxweight = capacity,
        slots = slots,             
    })
end)
