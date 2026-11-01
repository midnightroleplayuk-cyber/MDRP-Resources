Core = nil

CreateThread(function()
    while not Config.Framework or not Config.Inventory do Wait(1) end
    Wait(500)
    print("^2Framework: ^7"..Config.Framework, "^2Inventory: ^7"..Config.Inventory, "^2Target?: ^7", Config.Target, "^2Phone?: ^7", Config.UsingPhone)
    Core = getCore()
    registerItem(Config.LaptopItem)
    ready = true -- Framework is loaded and laptop is now ready :)
end)

-- Event handlers to get when a player is fully loaded into server
RegisterServerEvent("av_laptop:loaded")
AddEventHandler("QBCore:Server:PlayerLoaded", function(Player)
    TriggerEvent("av_laptop:loaded", Player.PlayerData.source)
end)

RegisterServerEvent("esx:onPlayerJoined")
AddEventHandler("esx:onPlayerJoined", function(Player)
    local src = Player
    if not src then src = source end
    TriggerEvent("av_laptop:loaded", src)
end)

-- Add Player Metadata
local metadataFields = {
    ['hunger'] = true,
    ['thirst'] = true,
    ['stress'] = true,
}

RegisterServerEvent("av_laptop:addMetadata", function(field, amount) -- used to add thirst/hunger, ESX uses client events for esx_status
    dbug("addMetadata(field,amount)", field, amount)
    if not metadataFields[field] then return end
    local src = source
    if Config.Framework == "qb" then
        local Player = getPlayer(src)
        if Player then
            local value = Player.Functions.GetMetaData(field)
            if field == "stress" then
                value -= amount
            else
                value += amount
            end
            if value < 0 then value = 0 end
            if value > 100 then value = 100 end
            Player.Functions.SetMetaData(field, value)
            dbug("Trigger hud:client:UpdateNeeds...")
            if field == "hunger" then
                dbug("Hunger?", value)
                TriggerClientEvent('hud:client:UpdateNeeds', src, value, Player.PlayerData.metadata.thirst)
            else
                dbug("Thirst?", value)
                TriggerClientEvent('hud:client:UpdateNeeds', src, Player.PlayerData.metadata.hunger, value)
            end
        end
    end
    if Config.Framework == "qbox" then
        local value = Player(src).state[field] or 0
        if field == "stress" then
            value -= amount
        else
            value += amount
        end
        Player(src).state[field] = value
        local player = getPlayer(src)
        if player then
            player.Functions.SetMetaData(field, value)
        end
    end
end)

RegisterServerEvent("av_laptop:openStash", function(name,data) -- used for new qb-inventory stash system
    local src = source
    exports[Config.Inventory]:OpenInventory(src, name, data)
end)