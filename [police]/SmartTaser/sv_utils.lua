webhookLink = ""

if main.framework.vRP then
    local Tunnel = module('vrp', 'lib/Tunnel')
    local Proxy = module('vrp', 'lib/Proxy')
    vRP = Proxy.getInterface('vRP')
    vRPclient = Tunnel.getInterface('vRP','vRP')
end

ESX = nil
if main.framework.ESX or (main.framework.tgiannInventory.enabled and main.framework.tgiannInventory.ESX) then
    ESX = exports["es_extended"]:getSharedObject()
end

QBCore = nil
if main.framework.QBCore or (main.framework.tgiannInventory.enabled and main.framework.tgiannInventory.QBCore) then
    QBCore = exports['qb-core']:GetCoreObject()
end

if main.framework.QBCore and not main.framework.oxInv or (main.framework.tgiannInventory.enabled and main.framework.tgiannInventory.QBCore) then
    Citizen.CreateThread(function()
        Wait(3000)
    
        QBCore.Functions.CreateUseableItem(main.framework.cartridgeItemName, function(source, item)
            local src = source
            TriggerClientEvent("TaserFramework:ReloadTaser", src)
        end)
    end)
end

if main.framework.ESX and not main.framework.oxInv or (main.framework.tgiannInventory.enabled and main.framework.tgiannInventory.ESX) then
    Citizen.CreateThread(function ()
        Wait(3000)
        ESX.RegisterUsableItem(main.framework.cartridgeItemName, function(source, item)
            local src = source
            TriggerClientEvent("TaserFramework:ReloadTaser", src)
        end)   
    end)
end

if main.framework.oxInv then
    exports('OxUseTaserCart', function(event, _, inventory)
        if event == 'usingItem' then
            TriggerClientEvent("TaserFramework:ReloadTaser", inventory.player.source)
            return false
        end
    end)
end

if main.framework.jaksamInventory then
    exports['jaksam_inventory']:registerUsableItem(main.framework.cartridgeItemName, function(playerId)
        TriggerClientEvent("TaserFramework:ReloadTaser", playerId)
    end)
end

RegisterNetEvent("TaserFramework:ReloadTaser")
AddEventHandler("TaserFramework:ReloadTaser", function(src)
    if main.framework.oxInv then
        
        local itemCount = exports.ox_inventory:GetItem(src, main.framework.cartridgeItemName, nil, true)
        if itemCount >= 1 then
            exports.ox_inventory:RemoveItem(src, main.framework.cartridgeItemName, 1)
            TriggerClientEvent("TaserFramework:ClientReloadTaser", src)
            for k, v in pairs(existingCartridges) do
                if v.player then
                    TriggerClientEvent("TaserFramework:StopWhileLoop", k, v.shooter)
                elseif v.shooter == src then
                    TriggerClientEvent("TaserFramework:StopWhileLoop", v.shooter, k)
                    existingCartridges[k] = nil
                    Wait(1000)
                end
            end
        end
    elseif main.framework.vRP then
        local userID = vRP.getUserId({src})
        if vRP.tryGetInventoryItem({userID, main.framework.cartridgeItemName, 1, false}) then
            TriggerClientEvent("TaserFramework:ClientReloadTaser", src)
            for k, v in pairs(existingCartridges) do
                if v.player then
                    TriggerClientEvent("TaserFramework:StopWhileLoop", k, v.shooter)
                elseif v.shooter == src then
                    TriggerClientEvent("TaserFramework:StopWhileLoop", v.shooter, k)
                    existingCartridges[k] = nil
                    Wait(1000)
                end
            end
        end
    elseif main.framework.tgiannInventory.enabled then
        local itemData = exports["tgiann-inventory"]:GetItemByName(src, main.framework.cartridgeItemName)
        if itemData.amount > 0 then
            TriggerClientEvent("TaserFramework:ClientReloadTaser", src)
            local success = exports["tgiann-inventory"]:RemoveItem(src, main.framework.cartridgeItemName, 1)
            for k, v in pairs(existingCartridges) do
                if v.player then
                    TriggerClientEvent("TaserFramework:StopWhileLoop", k, v.shooter)
                elseif v.shooter == src then
                    TriggerClientEvent("TaserFramework:StopWhileLoop", v.shooter, k)
                    existingCartridges[k] = nil
                    Wait(1000)
                end
            end
            print("Item Removed")
        end
    elseif main.framework.QBCore then
        local Player = QBCore.Functions.GetPlayer(src)
        local item = Player.Functions.GetItemByName(main.framework.cartridgeItemName)
        if item ~= nil then
            if item.amount > 0 then
                TriggerClientEvent("TaserFramework:ClientReloadTaser", src)
                if main.framework.alternativeQBCoreItemRemoval.enabled then
                    TriggerServerEvent(main.framework.alternativeQBCoreItemRemoval.eventToTrigger, main.framework.cartridgeItemName, 1, src)
                else
                    Player.Functions.RemoveItem(main.framework.cartridgeItemName, 1)   
                end
                for k, v in pairs(existingCartridges) do
                    if v.player then
                        TriggerClientEvent("TaserFramework:StopWhileLoop", k, v.shooter)
                    elseif v.shooter == src then
                        TriggerClientEvent("TaserFramework:StopWhileLoop", v.shooter, k)
                        existingCartridges[k] = nil
                        Wait(1000)
                    end
                end
            end
        end
    elseif main.framework.jaksamInventory then
        local successful = exports['jaksam_inventory']:removeItem(src, main.framework.cartridgeItemName, 1)
        if successful then
            TriggerClientEvent("TaserFramework:ClientReloadTaser", src)
            for k, v in pairs(existingCartridges) do
                if v.player then
                    TriggerClientEvent("TaserFramework:StopWhileLoop", k, v.shooter)
                elseif v.shooter == src then
                    TriggerClientEvent("TaserFramework:StopWhileLoop", v.shooter, k)
                    existingCartridges[k] = nil
                    Wait(1000)
                end
            end
        end
    elseif main.framework.ESX then
        local xPlayer = ESX.GetPlayerFromId(src)
        local item = xPlayer.getInventoryItem(main.framework.cartridgeItemName)
        if item.count > 0 then
            xPlayer.removeInventoryItem(main.framework.cartridgeItemName, 1)
            TriggerClientEvent("TaserFramework:ClientReloadTaser", src)
            for k, v in pairs(existingCartridges) do
                if v.player then
                    TriggerClientEvent("TaserFramework:StopWhileLoop", k, v.shooter)
                elseif v.shooter == src then
                    TriggerClientEvent("TaserFramework:StopWhileLoop", v.shooter, k)
                    existingCartridges[k] = nil
                    Wait(1000)
                end
            end
        end
    elseif main.framework.standalone then
        TriggerClientEvent("TaserFramework:ClientReloadTaser", src)
        for k, v in pairs(existingCartridges) do
            if v.player then
                TriggerClientEvent("TaserFramework:StopWhileLoop", k, v.shooter)
            elseif v.shooter == src then
                TriggerClientEvent("TaserFramework:StopWhileLoop", v.shooter, k)
                existingCartridges[k] = nil
                Wait(1000)
            end
        end
    end
end)

function logToDiscord(event, device, carrier, cartridgesRemaining, cartID)

    local name = GetPlayerName(carrier)
    local serialNumber = "X" .. math.random(10000000, 99999999)
    local embed
    local deviceName = tasers[device].name
    local battery = math.random(10, 100)
    local time = os.date("*t")
    local day = os.date("%A")
    local color = main.webhookOptions.colour
    local useCartID
    if cartID ~= nil then
        useCartID = true
    end
    if time.month < 10 then
        time.month = "0" .. time.month
    end

    if useCartID then
        embed = {
            {
                ["fields"] = {
                    {
                        ["name"] = "**"..main.translations.event.."**",
                        ["value"] = event,
                        ["inline"] = true
                    },
                    {
                        ["name"] = "**"..main.translations.device.."**",
                        ["value"] = deviceName,
                        ["inline"] = true
                    },
                    {
                        ["name"] = "**"..main.translations.carrier.."**",
                        ["value"] = name,
                        ["inline"] = true
                    },
                    {
                        ["name"] = "**"..main.translations.cartridgeID.."**",
                        ["value"] = cartID,
                        ["inline"] = true
                    },
                    {
                        ["name"] = "**"..main.translations.cartridgesRemaining.."**",
                        ["value"] = cartridgesRemaining,
                        ["inline"] = true
                    },
                    {
                        ["name"] = "**"..main.translations.serialNumber.."**",
                        ["value"] = serialNumber,
                        ["inline"] = true
                    },
                    
                    {
                        ["name"] = "**"..main.translations.battery.."**",
                        ["value"] = battery .. "%",
                        ["inline"] = true
                    },
                },
                ["color"] = color,
                ["title"] = "**"..main.translations.embedTitle.."**",
                ["description"] = "",
                ["footer"] = {
                    ["text"] = main.translations.timestamp.. " " .. day .. " " .. time.day .. "/" .. time.month .. "/" .. time.year
                },
                ["thumbnail"] = {
                    ["url"] = main.webhookOptions.webhookImage,
                },
            }
        }
    else
        embed = {
            {
                ["fields"] = {
                    {
                        ["name"] = "**"..main.translations.event.."**",
                        ["value"] = event,
                        ["inline"] = true
                    },
                    {
                        ["name"] = "**"..main.translations.device.."**",
                        ["value"] = deviceName,
                        ["inline"] = true
                    },
                    {
                        ["name"] = "**"..main.translations.carrier.."**",
                        ["value"] = name,
                        ["inline"] = true
                    },
                    {
                        ["name"] = "**"..main.translations.cartridgesRemaining.."**",
                        ["value"] = cartridgesRemaining,
                        ["inline"] = true
                    },
                    {
                        ["name"] = "**"..main.translations.serialNumber.."**",
                        ["value"] = serialNumber,
                        ["inline"] = true
                    },
                    
                    {
                        ["name"] = "**"..main.translations.battery.."**",
                        ["value"] = battery .. "%",
                        ["inline"] = true
                    },
                },
                ["color"] = color,
                ["title"] = "**"..main.translations.embedTitle.."**",
                ["description"] = "",
                ["footer"] = {
                    ["text"] = main.translations.timestamp.. " " .. day .. " " .. time.day .. "/" .. time.month .. "/" .. time.year
                },
                ["thumbnail"] = {
                    ["url"] = main.webhookOptions.webhookImage,
                },
            }
        }



    end
    PerformHttpRequest(webhookLink, function(err, text, headers) end, 'POST', json.encode({username = main.webhookOptions.webHookName, embeds = embed}), { ['Content-Type'] = 'application/json' })
end