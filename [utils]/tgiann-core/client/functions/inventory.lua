-- client

-- Support for inventory scripts:
-- qb-inventory
-- tgiann-inventory
-- ox_inventory
-- qs-inventory
-- codem-inventory
-- origen_inventory
-- core_inventory

--- @param data table {stashName: string, slots: number, maxWeight: number, label: string, blacklist: table, whitelist: table, isPlayer: boolean}
--- @diagnostic disable-next-line dublicate-function
tgiCore.OpenStash = function(data)
    if next(data) then data.maxWeight = data.maxweight or data.maxWeight end
    if config["qs-inventory"] then
        local stashName = ("Stash_%s"):format(data.stashName)
        --exports["qs-inventory"]:RegisterStash(stashName, data.slots, data.maxWeight) -- Probably not needed
        TriggerServerEvent("inventory:server:OpenInventory", "stash", stashName, {
            maxweight = data.maxWeight,
            slots = data.slots,
        })
        TriggerEvent("inventory:client:SetCurrentStash", stashName)
    elseif config["codem-inventory"] then
        TriggerServerEvent('inventory:server:OpenInventory', 'stash', data.stashName, { maxweight = data.maxWeight, slots = data.slots })
    else
        assert(false, "There is no open stash event in the client for the inventory you are using!")
    end
end

RegisterNetEvent("tgiann-core:client:openInventory")
AddEventHandler("tgiann-core:client:openInventory", tgiCore.OpenStash)

-- SHOP

--- @param data  table { shopName: string, items: table }
--- @diagnostic disable-next-line dublicate-function
tgiCore.OpenShop = function(data)
    if config.ox_inventory then
        exports.ox_inventory:openInventory("shop", { type = data.shopName, id = 1 })
    elseif config["qs-inventory"] then
        local Items = {
            label = data.shopName,
            items = data.items
        }
        TriggerServerEvent("inventory:server:OpenInventory", "shop", "Itemshop_" .. data.shopName, Items)
    elseif config["codem-inventory"] then
        TriggerEvent('codem-inventory:openshop', data.shopName)
    else
        assert(false, "There is no open shop event in the client for the inventory you are using!")
    end
end

RegisterNetEvent("tgiann-core:client:openShop")
AddEventHandler("tgiann-core:client:openShop", tgiCore.OpenShop)

-- TARGET PLAYER

--- @param targetSrc number
--- @diagnostic disable-next-line dublicate-function
tgiCore.OpenTargetPlayerInventory = function(targetSrc)
    if config.core_inventory then
        TriggerServerEvent('core_inventory:server:openInventory', targetSrc, 'otherplayer', nil, nil, true)
    elseif config.ox_inventory then
        exports.ox_inventory:openInventory("player", targetSrc)
    elseif config["qs-inventory"] then
        TriggerServerEvent("inventory:server:OpenInventory", "otherplayer", targetSrc)
    elseif config["codem-inventory"] then
        TriggerEvent('codem-inventory:client:robplayer', targetSrc)
    else
        assert(false, "There is no open target player inventory event in the client for the inventory you are using!")
    end
end

RegisterNetEvent("tgiann-core:client:OpenTargetPlayerInventory")
AddEventHandler("tgiann-core:client:OpenTargetPlayerInventory", tgiCore.OpenTargetPlayerInventory)
