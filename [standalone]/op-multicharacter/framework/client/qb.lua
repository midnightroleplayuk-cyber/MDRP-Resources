QBCore = GetResourceState('qb-core') == 'started' and true or false
local tryQBox = GetResourceState('qbx_core') == 'started' and true or false

if not QBCore then return end
if tryQBox then return end 

loadEventsEnsured = false
Framework = exports['qb-core']:GetCoreObject()
Fr.PlayerLoaded = 'op-multicharacter:charInitialized'

Fr.OnPlayerLoadEvents = function()
    if loadEventsEnsured then return end
    loadEventsEnsured = true
    TriggerServerEvent('QBCore:Server:OnPlayerLoaded')
    TriggerEvent('QBCore:Client:OnPlayerLoaded')
    TriggerEvent('qb-weathersync:client:EnableSync')
end

Fr.OnPlayerConnected = function()
    ShutdownLoadingScreen()
    ShutdownLoadingScreenNui()
    if not Config.DisableBlackScreens then
        DoScreenFadeOut(0)
        SendNUIMessage({ action = "setloadervisible", data = true })
    end
end

Fr.GetPlayerData = function()
    return Framework.Functions.GetPlayerData()
end