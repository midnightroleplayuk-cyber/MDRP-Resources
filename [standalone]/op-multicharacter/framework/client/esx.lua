ESX = GetResourceState('es_extended') == 'started' and true or false
if not ESX then return end

loadEventsEnsured = false
Framework = nil

local ok, result = pcall(function()
    return exports["es_extended"]:getSharedObject()
end)

if ok and result then
    Framework = result
else
    local attempts = 0
    local maxAttempts = 70

    while Framework == nil and attempts < maxAttempts do
        attempts = attempts + 1

        TriggerEvent('esx:getSharedObject', function(obj)
            Framework = obj
        end)

        if Framework then
            break
        end

        Citizen.Wait(250)
    end
end

Fr.PlayerLoaded = 'esx:playerLoaded'

Fr.OnPlayerLoadEvents = function()
    if loadEventsEnsured then return end
    loadEventsEnsured = true
    TriggerServerEvent("esx:onPlayerSpawn")
    TriggerEvent("esx:onPlayerSpawn")
    TriggerEvent("esx:restoreLoadout")
end

Fr.OnPlayerConnected = function()
    ShutdownLoadingScreen()
    ShutdownLoadingScreenNui()
    if not Config.DisableBlackScreens then
        DoScreenFadeOut(0)
        SendNUIMessage({ action = "setloadervisible", data = true })
    end
    TriggerEvent("esx:loadingScreenOff")
end

Fr.GetPlayerData = function()
    return Framework.GetPlayerData()
end