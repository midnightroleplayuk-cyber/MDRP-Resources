if Config.Framework ~= 'qb' then return end

QBCore = exports['qb-core']:GetCoreObject()

TriggerCallback = QBCore.Functions.TriggerCallback

local isPlayerLoaded = false

function IsPlayerLoaded()
    return isPlayerLoaded
end

function ShowNotification(text, notifyType)
    if notifyType == 'inform' then notifyType = 'primary' end
    QBCore.Functions.Notify(text, notifyType)
end

function GetIdentifier()
    return QBCore.PlayerData.citizenid
end

function GetCharName()
    return ('%s %s'):format(QBCore.PlayerData.charinfo.firstname, QBCore.PlayerData.charinfo.lastname)
end

function GetDateOfBirth()
    return QBCore.PlayerData.charinfo.birthdate
end

function GetGender()
    return QBCore.PlayerData.charinfo.gender == 1 and 'female' or 'male'
end

function GetJobName()
    return QBCore.PlayerData?.job?.name
end

function GetGradeId()
    return QBCore.PlayerData?.job?.grade?.level
end

function GetGradeLabel()
    return QBCore.PlayerData?.job?.grade?.name
end

function IsBoss()
    return QBCore.PlayerData?.job?.grade?.isboss
end

function IsOnDuty()
    return true
end

function IsDead(targetId)
    local player = targetId and Player(targetId) or LocalPlayer
    return player.state.isDead or player.state.isInLastStand
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

function GetWeaponLabel(weapon)
    if Config.Inventory == 'ox' then
        return labels[weapon] or weapon
    end

    return QBCore.Shared.Weapons?[weapon]?.label or weapon
end

function GetItemAmount(item)
    if Config.Inventory == 'qs' then
        return exports['qs-inventory']:Search(item) or 0
    end

    for _,v in pairs(QBCore.Functions.GetPlayerData().items) do
        if v.name == item then
            return v.count or v.amount or 0
        end
    end

    return 0
end

function SetIsDead(isDead)

end

RegisterNetEvent('QBCore:Client:OnPlayerLoaded', function()
    QBCore.Functions.GetPlayerData(function(PlayerData)
        QBCore.PlayerData = PlayerData
        PlayerLoaded()

        Wait(3000)
        isPlayerLoaded = true
    end)
end)

RegisterNetEvent('QBCore:Client:OnJobUpdate', function(Job)
    QBCore.PlayerData.job = Job
    JobChanged()
end)

CreateThread(function()
    while not QBCore?.PlayerData?.job do
        Wait(2000)
        QBCore.PlayerData = QBCore.Functions.GetPlayerData()
    end

    frameworkLoaded = true
end)