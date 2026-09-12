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
    return QBCore.PlayerData.charinfo.gender == 1 and _U('female') or _U('male')
end

function GetJobName()
    return QBCore.PlayerData.job.name
end

function GetGradeId()
    return QBCore.PlayerData.job.grade.level
end

function GetGradeLabel()
    return QBCore.PlayerData.grade.name
end

function GetItemLabel(item)
    return QBCore.Shared.Items?[string.lower(item)]?.label or item
end

function GetWeaponLabel(weapon)
    return QBCore.Shared.Weapons?[weapon]?.label or weapon
end

function GetItemAmount(item)
    if Config.Inventory == 'ox' then
        return exports.ox_inventory:Search('count', item) or 0
    end

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
    QBCore.Functions.GetPlayerData(function(PlayerData)
        QBCore.PlayerData = PlayerData
        PlayerLoaded()
    end)
end)

RegisterNetEvent('QBCore:Client:OnJobUpdate', function(Job)
    QBCore.PlayerData.job = Job
    JobUpdated()
end)

CreateThread(function()
    while not QBCore?.PlayerData?.job do
        Wait(2000)
        QBCore.PlayerData = QBCore.Functions.GetPlayerData()
    end

    frameworkLoaded = true
end)