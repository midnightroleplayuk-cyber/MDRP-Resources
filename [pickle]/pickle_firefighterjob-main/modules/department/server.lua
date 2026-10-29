Firefighters = {}

function GetFirefighters()
    local list = {}
    for k,v in pairs(Firefighters) do 
        if GetPlayerName(k) then 
            list[#list + 1] = k
        end
    end
    return list
end

function CheckRequired(source, required)
    if not required or #required < 1 then return true end
    local success = true
    local missingItems = {}
    for i=1, #required do 
        local part = required[i]
        if (not part.type or part.type == "item") then
            local remaining = Inventory.GetItemCount(source, part.name) - (part.amount)
            if remaining < 0 then 
                success = false
                missingItems[#missingItems + 1] = {index = i, name = part.name, count = remaining * -1}
            end
        elseif (Config.XPEnabled and part.type == "xp") then
            local remaining = GetPlayerLevel(source, part.name) - part.amount
            if remaining < 0 then 
                success = false
                missingItems[#missingItems + 1] = {index = i, name = Config.XPCategories[part.name], count = part.amount}
            end
        elseif (part.type == "cash") then
            local remaining = GetMoney(source) - part.amount
            if remaining < 0 then 
                success = false
                missingItems[#missingItems + 1] = {index = i, name = "cash", count = remaining * -1}
            end
        elseif (part.type == "weapon" and not Inventory.HasWeapon(source, part.name)) then
            success = false
            missingItems[#missingItems + 1] = {index = i, name = part.name, count = 1}
        end
    end
    return success, missingItems
end

function TakeRequired(source, required)
    if not required or #required < 1 then return true end
    for i=1, #required do 
        local part = required[i]
        if (not part.type or part.type == "item") then
            Inventory.RemoveItem(source, part.name, part.amount)
        elseif (part.type == "cash") then
            RemoveMoney(source, part.amount)
        elseif (part.type == "weapon" and not Inventory.HasWeapon(source, part.name)) then
            Inventory.RemoveWeapon(source, part.name, 1)
        end
    end
end

function GiveRewards(source, rewards)
    for i=1, #rewards do 
        local reward = rewards[i]
        if not reward.type or reward.type == "item" then
            Inventory.AddItem(source, reward.name, reward.amount, reward.createItem and reward.createItem(craftingData) or nil)
        elseif reward.type == "cash" then
            AddMoney(source, reward.amount)
        elseif reward.type == "weapon" then
            Inventory.AddWeapon(source, reward.name, reward.amount, reward.createItem and reward.createItem(craftingData) or nil)
        elseif Config.XPEnabled and reward.type == "xp" then 
            AddPlayerXP(source, reward.name, reward.amount)
        end
    end
end

function SetDuty(source, index, disableNotify)
    if index then 
        Firefighters[source] = {index = index}
    else
        Firefighters[source] = nil
    end
    if not disableNotify then 
        if index then 
            local dept = Config.Departments[index]
            ShowNotification(source, _L("onduty", dept.label))
        else
            ShowNotification(source, _L("offduty"))
        end
    end
    TriggerClientEvent("pickle_firefighterjob:setDuty", source, index)
end

RegisterNetEvent("pickle_firefighterjob:setDuty", function(index, bool) 
    local source = source
    local dept = Config.Departments[index]
    if not dept then return end
    local permissions = dept.permissions or Config.Default.permissions
    if not bool then -- Off-duty
        SetDuty(source) 
    elseif not CheckPermission(source, permissions.duty) then 
        ShowNotification(source, _L("no_permission"))
    else -- Onduty
        SetDuty(source, index)
    end
end)

RegisterNetEvent("pickle_firefighterjob:storeTransaction", function(index, itemIndex)
    local store = Config.Departments[index].store
    local item = store.catalog[itemIndex]
    local required = item.required
    local rewards = item.rewards or {}
    local success, missingItems = CheckRequired(source, required)
    if not success then 
        for i=1, #missingItems do 
            ShowNotification(source, _L("missing_item", missingItems[i].name, missingItems[i].count))
        end
        return
    end
    rewards[#rewards + 1] = {
        type = "item",
        name = item.name,
        amount = item.amount
    }
    TakeRequired(source, required)
    GiveRewards(source, rewards)
end)

RegisterCallback("pickle_firefighterjob:vehicleTransaction", function(source, cb, index, vehicleIndex)
    local vehicles = Config.Departments[index].vehicles
    local vehicle = vehicles.catalog[vehicleIndex]
    local required = vehicle.required
    local rewards = vehicle.rewards or {}
    local success, missingItems = CheckRequired(source, required)
    if not success then 
        for i=1, #missingItems do 
            ShowNotification(source, _L("missing_item", missingItems[i].name, missingItems[i].count))
        end
        return cb(false)
    end
    TakeRequired(source, required)
    cb(true)
end)

RegisterNetEvent("pickle_firefighterjob:initializePlayer", function()
    local source = source
    local identifier = GetIdentifier(source)
    TriggerClientEvent("pickle_firefighterjob:setupInventory", source, {items = Inventory.Items})
    TriggerClientEvent("pickle_firefighterjob:syncFires", source, Fires)
end)