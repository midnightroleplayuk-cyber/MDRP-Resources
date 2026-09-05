QBox = GetResourceState('qbx_core') == 'started' and true or false

loadEventsEnsured = false
if not QBox then return end

Framework = exports['qb-core']:GetCoreObject()
Fr.PlayerLoaded = 'op-multicharacter:charInitialized'

Fr.OnPlayerLoadEvents = function()
    if loadEventsEnsured then return end
    loadEventsEnsured = true
    TriggerEvent('QBCore:Client:OnPlayerLoaded')
    TriggerServerEvent('QBCore:Server:OnPlayerLoaded')
    --TriggerEvent('qb-weathersync:client:EnableSync')
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