if Config.Framework ~= "esx" then
    return
end

debugprint("Loading ESX")

local export, obj = pcall(function()
    return exports.es_extended:getSharedObject()
end)

if export then
    ESX = obj
else
    while not ESX do
        TriggerEvent("esx:getSharedObject", function(obj)
            ESX = obj
        end)

        Wait(500)
    end
end

local isFirstPlayerLoaded = true

RegisterNetEvent("esx:playerLoaded", function(playerData)
    ESX.PlayerData = playerData
    ESX.PlayerLoaded = true

    if not isFirstPlayerLoaded then
        FetchPhone()
    end

    isFirstPlayerLoaded = false
end)

AddEventHandler("esx:setPlayerData", function(key, val, last)
    if GetInvokingResource() == "es_extended" and ESX.PlayerData then
        ESX.PlayerData[key] = val
    end
end)

RegisterNetEvent("esx:onPlayerLogout", function()
    LogOut()
end)

while not ESX.PlayerLoaded do
    Wait(500)
end

FrameworkLoaded = true

debugprint("ESX loaded")

RegisterNetEvent("esx:setAccountMoney", function(account)
    if account.name ~= "bank" then
        return
    end

    SendNUIAction("wallet:setBalance", math.floor(account.money))
end)

local isHandcuffed = false

RegisterNetEvent("esx_policejob:handcuff", function()
	isHandcuffed = not isHandcuffed

    if isHandcuffed and phoneOpen then
        ToggleOpen(false)
    end
end)

AddCheck("openPhone", function()
    if ESX.PlayerData.dead or isHandcuffed then
        return false
    end

    return true
end)
