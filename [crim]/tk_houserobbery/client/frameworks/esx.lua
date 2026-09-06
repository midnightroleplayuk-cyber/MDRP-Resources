if Config.Framework ~= 'esx' then return end

ESX = exports["es_extended"]:getSharedObject()

TriggerCallback = ESX.TriggerServerCallback

function ShowNotification(text)
    ESX.ShowNotification(text)
end

function GetIdentifier()
    return ESX.PlayerData.identifier
end

function GetCharName()
    return ('%s %s'):format(ESX.PlayerData.firstName, ESX.PlayerData.lastName)
end

function GetDateOfBirth()
    return ESX.PlayerData.dateofbirth
end

function GetGender()
    return ESX?.PlayerData?.sex == 1 and _U('female') or _U('male')
end

function GetJobName()
    return ESX.PlayerData.job.name
end

function GetGradeId()
    return ESX.PlayerData.job.grade
end

function GetGradeLabel()
    return ESX.PlayerData.job.grade_label
end

function GetItemLabel(item)
    local p = promise.new()
    TriggerCallback('tk:getItemLabel', function(label)
        p:resolve(label)
    end, item)
    return Citizen.Await(p)
end

function GetItemAmount(item)
    if Config.Inventory == 'qs' then
        return exports['qs-inventory']:Search(item)
    end

    for _,v in pairs(ESX.GetPlayerData().inventory) do
        if v.name == item then
            return v.count or v.amount or 0
        end
    end

    return 0
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
end)

RegisterNetEvent('esx:setJob', function(job)
    Wait(500)
    ESX.PlayerData.job = job
end)

CreateThread(function()
    repeat Wait(2000) until ESX?.PlayerData?.job

    frameworkLoaded = true
end)