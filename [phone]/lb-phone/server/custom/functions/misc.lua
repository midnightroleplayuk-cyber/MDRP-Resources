---Function to check if an instagram user / source can go live
---@param source number
---@param username string
---@return boolean allowed Wheter or not the user can go live
---@return string | nil message The message to show to the user for why they can't go live
function CanGoLive(source, username)
    -- implement your own logic here. by default, everyone can go live
    return true
end

function CanCreateStory(source, username)
    -- implement your own logic here. by default, everyone can go live
    return true
end

AddEventHandler("ox_inventory:usedItem", function(source, itemName)
    if Config.Item.Unique then
        return
    end

    if Config.Item.Name and itemName == Config.Item.Name then
        TriggerClientEvent("phone:toggleOpen", source)
    elseif Config.Item.Names and IsItemAPhone(itemName) then
        for i = 1, #Config.Item.Names do
            if itemName == Config.Item.Names[i].name then
                TriggerClientEvent("phone:usedPhoneVariation", source, i)
            end
        end
    end
end)

SetTimeout(100, function()
    if Config.Item.Unique or not CreateUsableItem then
        return
    end

    if GetResourceState("ox_inventory") == "started" then
        debugprint("ox_inventory detected, not calling CreateUsableItem")
        return
    end

    if Config.Item.Name then
        CreateUsableItem(Config.Item.Name, function(src)
            TriggerClientEvent("phone:toggleOpen", src)
        end)
    elseif Config.Item.Names then
        for i = 1, #Config.Item.Names do
            CreateUsableItem(Config.Item.Names[i].name, function(src)
                TriggerClientEvent("phone:usedPhoneVariation", src, i)
            end)
        end
    end
end)
