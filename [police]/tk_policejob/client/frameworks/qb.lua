if Config.Framework ~= 'qb' then return end

QBCore = exports['qb-core']:GetCoreObject()

TriggerCallback = QBCore.Functions.TriggerCallback

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
    if targetId then
        local playerIndex = GetPlayerFromServerId(targetId)
        local targetPed = GetPlayerPed(playerIndex)
        local dead = IsEntityDead(targetPed)
        Utils.Debug('IsDead', targetId, dead)
        return dead
    end

    local dead = QBCore.Functions.GetPlayerData()?.metadata?.isdead
    Utils.Debug('IsDead local player', dead)
    return dead
end

function IsWeapon(item)
    return item and string.upper(string.sub(item, 0, 7)) == 'WEAPON_'
end

function GetItemLabel(item)
    item = string.lower(item)
    return QBCore.Shared.Items?[item]?.label or item
end

function GetWeaponLabel(weapon)
    weapon = string.lower(weapon)
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

RegisterNetEvent('QBCore:Client:OnPlayerLoaded', function()
    QBCore.Functions.GetPlayerData(function(PlayerData)
        QBCore.PlayerData = PlayerData
        PlayerLoaded()
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