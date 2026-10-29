if GetResourceState('qb-core') ~= 'started' then return end

QBCore = exports['qb-core']:GetCoreObject()

function ServerCallback(name, cb, ...)
    QBCore.Functions.TriggerCallback(name, cb,  ...)
end

function ShowNotification(text)
	QBCore.Functions.Notify(text)
end

function GetPlayersInArea(coords, radius)
    local coords = coords or GetEntityCoords(PlayerPedId())
    local radius = radius or 3.0
    local list = QBCore.Functions.GetPlayersFromCoords(coords, radius)
    local players = {}
    for _, player in pairs(list) do 
        if player ~= PlayerId() then
            players[#players + 1] = player
        end
    end
    return players
end

function OpenBossMenu(index)
    TriggerEvent('qb-bossmenu:client:OpenMenu')
end

RegisterNetEvent(GetCurrentResourceName()..":showNotification", function(text)
    ShowNotification(text)
end)

RegisterNetEvent('QBCore:Client:OnPlayerLoaded', function()
    TriggerServerEvent("pickle_firefighterjob:initializePlayer")
end)

function ToggleOutfit(onduty)
    if onduty then 
        local dept = Config.Departments[Department.index]
        local outfits = dept.outfit or Config.Default.outfit
        local gender = QBCore.Functions.GetPlayerData().charinfo.gender
        local outfit = gender == 1 and outfits.female or outfits.male
        if not outfit then return end 
        TriggerEvent('qb-clothing:client:loadOutfit', {outfitData = outfit})
    else
        TriggerServerEvent("qb-clothes:loadPlayerSkin")
    end
end

function GetConvertedClothes(oldClothes)
    local clothes = {}
    local components = {
        ['arms'] = "arms",
        ['tshirt_1'] = "t-shirt", 
        ['torso_1'] = "torso2", 
        ['bproof_1'] = "vest",
        ['decals_1'] = "decals", 
        ['pants_1'] = "pants", 
        ['shoes_1'] = "shoes", 
        ['helmet_1'] = "hat", 
        ['chain_1'] = "accessory", 
    }
    local textures = {
        ['tshirt_1'] = 'tshirt_2', 
        ['torso_1'] = 'torso_2',
        ['bproof_1'] = 'bproof_2',
        ['decals_1'] = 'decals_2',
        ['pants_1'] = 'pants_2',
        ['shoes_1'] = 'shoes_2',
        ['helmet_1'] = 'helmet_2',
        ['chain_1'] = 'chain_2',
    }
    for k,v in pairs(oldClothes) do 
        local component = components[k]
        if component then 
            local texture = textures[k] and (oldClothes[textures[k]] or 0) or 0
            clothes[component] = {item = v, texture = texture}
        end
    end
    return clothes
end

CreateThread(function()
    for i=1, #Config.Departments do
        local dept = Config.Departments[i]
        local outfits = dept.outfit or Config.Default.outfit
        if not Config.Departments[i].outfit then 
            Config.Departments[i].outfit = {}
        end
        Config.Departments[i].outfit.male = GetConvertedClothes(outfits.male)
        Config.Departments[i].outfit.female = GetConvertedClothes(outfits.female)
    end
end)

-- Inventory Fallback

CreateThread(function()
    Wait(100)
    
    if InitializeInventory then return InitializeInventory() end -- Already loaded through inventory folder.

    Inventory = {}

    Inventory.Items = {}
    
    Inventory.Ready = false
    
    RegisterNetEvent("pickle_firefighterjob:setupInventory", function(data)
        Inventory.Items = data.items
        Inventory.Ready = true
    end)
end)
