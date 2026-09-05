if Config.Framework ~= 'qb' then return end

QBCore = exports['qb-core']:GetCoreObject()

function TriggerCallback(name, ...)
    local p = promise.new()
    QBCore.Functions.TriggerCallback(name, function(data)
        p:resolve(data)
    end, ...)
    return Citizen.Await(p)
end

function ShowNotification(text, notifyType)
    if notifyType == 'inform' then notifyType = 'primary' end
    QBCore.Functions.Notify(text, notifyType)
end

function GetIdentifier()
    return QBCore.PlayerData.citizenid
end

function GetCharName()
    return ('%s %s'):format(QBCore?.PlayerData?.charinfo?.firstname , QBCore?.PlayerData?.charinfo?.lastname)
end

function GetDateOfBirth()
    return QBCore?.PlayerData?.charinfo?.birthdate
end

function GetGender()
    return QBCore?.PlayerData?.charinfo?.gender == 1 and _U('female') or _U('male')
end

function GetJobName()
    return QBCore.PlayerData.job.name
end

function GetGrade()
    return QBCore.PlayerData.job.grade.level
end

function GetGradeLabel()
    return QBCore.PlayerData.job.grade.name
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

    item = string.lower(item)
    return QBCore.Shared.Items?[item]?.label or item
end

function GetItemAmount(item)
    if Config.Inventory == 'ox' then
        return exports.ox_inventory:Search('count', item)
    end

    if Config.Inventory == 'qs' then
        return exports['qs-inventory']:Search(item)
    end

    for _,v in pairs(QBCore.Functions.GetPlayerData().items) do
        if v.name == item then
            return v.count or v.amount or 0
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

    for _,v in pairs(QBCore.Functions.GetPlayerData().items) do
        counts[v.name] = (counts[v.name] or 0) + (v.count or v.amount or 0)
    end

    return counts
end

function GetClosestPlayer()
    return QBCore.Functions.GetClosestPlayer()
end

function OpenDialog(label, inputType)
    local input = exports['qb-input']:ShowInput({
        header = label,
        inputs = {
            {
                text = label,
                name = 'value',
                type = inputType,
                isRequired = true,
            },
        }
    })

    return input?.value
end

RegisterNetEvent('QBCore:Client:OnPlayerLoaded', function()
    QBCore.Functions.GetPlayerData(function(playerData)
        QBCore.PlayerData = playerData
        Main.PlayerLoaded()
    end)
end)

RegisterNetEvent('QBCore:Client:OnJobUpdate', function(job)
    QBCore.PlayerData.job = job
end)

CreateThread(function()
    while not QBCore?.PlayerData?.job do
        Wait(2000)
        QBCore.PlayerData = QBCore.Functions.GetPlayerData()
    end

    frameworkLoaded = true
end)