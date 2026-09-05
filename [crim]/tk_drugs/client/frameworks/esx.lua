if Config.Framework ~= 'esx' then return end

ESX = exports["es_extended"]:getSharedObject()

function TriggerCallback(name, ...)
    local p = promise.new()
    ESX.TriggerServerCallback(name, function(data)
        p:resolve(data)
    end, ...)
    return Citizen.Await(p)
end

function ShowNotification(text)
    ESX.ShowNotification(text)
end

function GetIdentifier()
    return ESX.PlayerData.identifier
end

function GetCharName()
    return ('%s %s'):format(ESX?.PlayerData?.firstName, ESX?.PlayerData?.lastName)
end

function GetDateOfBirth()
    return ESX?.PlayerData?.dateofbirth
end

function GetGender()
    return ESX?.PlayerData?.sex == 1 and _U('female') or _U('male')
end

function GetJobName()
    return ESX.PlayerData.job.name
end

function GetGrade()
    return ESX.PlayerData.job.grade
end

function GetGradeLabel()
    return ESX.PlayerData.job.grade_label
end

local labels = {}

if Config.Inventory == 'ox' then
    for item,v in pairs(exports.ox_inventory:Items()) do
        local name = v.hash or item
        labels[name] = v.label
    end
end

function GetItemLabel(item)
    if Config.Inventory == 'ox' then
        return labels[item] or item
    end

    return TriggerCallback('tk_drugs:getItemLabel', item)
end

function GetItemAmount(item)
    if Config.Inventory == 'ox' then
        return exports.ox_inventory:Search('count', item)
    end

    if Config.Inventory == 'qs' then
        return exports['qs-inventory']:Search(item)
    end

    for _,v in pairs(ESX.GetPlayerData().inventory) do
        if v.name == item then
            return v.count or v.amount
        end
    end

    return 0
end

function GetAllItemAmounts()
    local counts = {}

    if Config.Inventory == 'qs' then
        local inventory = exports['qs-inventory']:getUserInventory() or {}
        for itemName, itemData in pairs(inventory) do
            counts[itemName] = (counts[itemName] or 0) + (itemData.amount or itemData.count or 0)
        end

        return counts
    end

    for _,v in pairs(ESX.GetPlayerData().inventory) do
        counts[v.name] = (counts[v.name] or 0) + (v.count or v.amount or 0)
    end

    return counts
end

function GetClosestPlayer()
    return ESX.Game.GetClosestPlayer()
end

function OpenDialog(label)
    local p = promise.new()
    ESX.UI.Menu.Open('dialog', GetCurrentResourceName(), 'dialog', {
        title = label,
    }, function (data, menu)
        p:resolve(data.value)
        menu.close()
    end, function (data, menu)
        p:resolve(nil)
        menu.close()
    end)
    return Citizen.Await(p)
end

RegisterNetEvent('esx:playerLoaded', function(playerData)
    ESX.PlayerData = playerData
    Main.PlayerLoaded()
end)

RegisterNetEvent('esx:setJob', function(job)
    Wait(500)
    ESX.PlayerData.job = job
end)

CreateThread(function()
    repeat Wait(2000) until ESX?.PlayerData?.job

    frameworkLoaded = true
end)