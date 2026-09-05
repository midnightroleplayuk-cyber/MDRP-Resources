if Config.Framework ~= 'esx' then return end

ESX = exports["es_extended"]:getSharedObject()

TriggerCallback = ESX.TriggerServerCallback

function IsPlayerLoaded()
    return ESX.GetPlayerData()?.job?.name ~= nil
end

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
    return (ESX.PlayerData.sex == 1 or ESX.PlayerData.sex == 'f') and 'female' or 'male'
end

function GetJobName()
    return ESX.PlayerData?.job?.name
end

function GetGradeId()
    return ESX.PlayerData?.job?.grade
end

function GetGradeLabel()
    return ESX.PlayerData?.job?.grade_label
end

function IsBoss()
    return ESX.PlayerData.job.grade >= 3
end

function IsOnDuty()
    return true
end

function IsDead(targetId)
    local player = targetId and Player(targetId) or LocalPlayer
    return player.state.isDead or player.state.isInLastStand
end

function GetItemLabel(item)
    local p = promise.new()
    TriggerCallback('tk_ambulancejob:getItemLabel', function(label)
        p:resolve(label)
    end, item)
    return Citizen.Await(p)
end

local weaponLabels = {}

if Config.Inventory == 'ox' then
    for _,v in pairs(exports.ox_inventory:Items()) do
        if v.hash and v.label then
            weaponLabels[v.hash] = v.label
        end
    end
end

function GetWeaponLabel(weapon)
    if Config.Inventory == 'ox' then
        return weaponLabels[weapon] or weapon
    end

    return ESX.GetWeaponFromHash(weapon)?.label or weapon
end

function GetItemAmount(item)
    if Config.Inventory == 'qs' then
        return exports['qs-inventory']:Search(item) or 0
    end

    for _,v in pairs(ESX.GetPlayerData().inventory) do
        if v.name == item then
            return v.count or v.amount or 0
        end
    end

    return 0
end

function SetIsDead(isDead)
    ESX.SetPlayerData('dead', isDead)
end

RegisterNetEvent('esx:playerLoaded', function(playerData)
    ESX.PlayerData = playerData
    PlayerLoaded()
end)

RegisterNetEvent('esx:setJob', function(job)
    Wait(500)
    ESX.PlayerData.job = job
    JobChanged()
end)

CreateThread(function()
    repeat Wait(2000) until ESX?.PlayerData?.job

    frameworkLoaded = true
end)