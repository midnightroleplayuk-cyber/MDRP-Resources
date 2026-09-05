function Notify(src, text, notifyType)
    if Config.NotificationType == 'mythic' then
        TriggerClientEvent('mythic_notify:client:SendAlert', src, { type = notifyType, text = text})
    elseif Config.NotificationType == 'ox' then
        lib.notify(src, {
            title = 'Drugs',
            description = text,
            type = notifyType
        })
    else
        ShowNotification(src, text, notifyType)
    end
end

function Webhook(message)
    --[[ local webhookLink = '' -- place your webhook link here on this line inside the quotes
    if not webhookLink or webhookLink == '' then return end

    local msg = {{["color"] = Config.WebhookColor, ["title"] = "**".. _U('webhook_title') .."**", ["description"] = message, ["footer"] = { ["text"] = os.date("%d.%m.%y Time: %X")}}}
    PerformHttpRequest(webhookLink, function(err, text, headers) end, 'POST', json.encode({embeds = msg}), { ['Content-Type'] = 'application/json' }) ]]
end

---Checks whether a drug can be used
---@param xPlayer table The player object
---@param drugName string The name of the drug
---@return boolean canUse Whether the drug can be used
function CanUseDrug(xPlayer, drugName)
    return true
end

---Awards recipe output items to the player after completing an equipment recipe
---@param xPlayer table The player object
---@param recipe table The recipe data
---@param amount number The total amount of items that were made
---@param equipmentData table The equipment data from Config.EquipmentItems
function GiveRecipeItems(xPlayer, recipe, amount, equipmentData)
    for _, item in pairs(recipe.get) do
        AddItem(xPlayer, item.name, item.amount * amount)
    end
end

---Called when a player successfully purchases items from a shop
---@param playerId number The ID of the player who made the purchase
---@param shopIndex number The index of the shop from which the items were purchased
---@param items table A table containing the items that were purchased
function PurchasedShopItems(playerId, shopIndex, items)

end

---Called when a player successfully sells drugs to a ped
---@param xPlayer table The player object
---@param drugName string The name of the drug that was sold
---@param amount number The amount of the drug that was sold
---@param price number The total price for the sold drugs
function SoldDrugs(xPlayer, drugName, amount, price)
    AddAccountMoney(xPlayer, Config.Selling.moneyType, price)
end

---Waters a plant and returns the resulting water level
---@param playerId number The ID of the player who watered the plant
---@param plantData table The data of the plant that was watered
---@param item string The item that was used to water the plant
---@param amount number The amount of the item that was used to water the plant
---@return number waterAmount The water level after watering (0-100)
function WaterPlant(playerId, plantData, item, amount)
    local xPlayer = GetPlayerFromId(playerId)
    RemoveItem(xPlayer, item, amount)

    return 100
end

---Fertilizes a plant and returns the resulting fertilizer level
---@param playerId number The ID of the player who fertilized the plant
---@param plantData table The data of the plant that was fertilized
---@param item string The item that was used to fertilize the plant
---@param amount number The amount of the item that was used to fertilize the plant
---@return number fertilizerAmount The fertilizer level after fertilizing (0-100)
function FertilizePlant(playerId, plantData, item, amount)
    local xPlayer = GetPlayerFromId(playerId)
    RemoveItem(xPlayer, item, amount)

    return 100
end

---Harvests a plant and gives items to the player
---@param xPlayer table The player object
---@param plantConfig table The data of the plant being harvested
---@param firstYieldAmount? number Amount cut by the player in the harvest minigame
function HarvestPlant(xPlayer, plantConfig, firstYieldAmount)
    for k, v in ipairs(plantConfig.yield) do
        if k == 1 and firstYieldAmount then
            if firstYieldAmount > 0 then
                AddItem(xPlayer, v.item, firstYieldAmount)
            end
        else
            if math.random(1, 100) <= v.chance then
                local amount = math.random(v.amount.min, v.amount.max)
                if amount > 0 then
                    AddItem(xPlayer, v.item, amount)
                end
            end
        end
    end
end

---Returns the amount of police online
---@return number policeAmount The amount of police currently online
function GetPoliceAmount()
    local amount = 0

    for _,playerId in pairs(GetPlayers()) do
        playerId = tonumber(playerId)
        local xPlayer = GetPlayerFromId(playerId)
        if xPlayer then
            local job = GetJobName(xPlayer)
            if Config.PoliceJobs[job] then
                amount += 1
            end
        end
    end

    return amount
end

---Returns the routing bucket for a player
---@param playerId number The ID of the player
---@return number bucket The routing bucket of the player
function GetRoutingBucket(playerId)
    return GetPlayerRoutingBucket(playerId)
end

---Called when a worker completes a recipe and produces item
---@param worker table The worker data {id, labId, name, equipmentId}
---@param produced table {name, amount}
---@param shelfId number Where the item was deposited
function OnWorkerProduced(worker, produced, shelfId)

end