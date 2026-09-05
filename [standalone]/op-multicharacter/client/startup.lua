while Framework == nil do Wait(5) end

local scriptName = GetCurrentResourceName()
if scriptName ~= "op-multicharacter" then return print('[OTHERPLANET.DEV] Required resource name: op-multicharacter (needed for proper functionality)') end

-- NOT USED ANYMORE
--if ESX then
--    CreateThread(function()
--        while not Framework.PlayerLoaded do
--            Wait(100)
--            if NetworkIsPlayerActive(Framework.playerId) then
--                Framework.DisableSpawnManager()
--                setupCharacterSelection()
--                break
--            end
--        end
--    end)
--end

CreateThread(function()
    debugPrint('Starting init loop')
    while true do
        -- Cover BEFORE the FiveM loading screen dies. Session start and
        -- ShutdownLoadingScreen often happen in the same window; a 100ms
        -- wait here is enough to flash the world between the two overlays.
        if not Config.DisableBlackScreens then
            DoScreenFadeOut(0)
            SendNUIMessage({ action = "setloadervisible", data = true })
        end
        if NetworkIsSessionStarted() then
            debugPrint("setupCharacterSelection called")
            setupCharacterSelection()
            return
        end
        Wait(0)
    end
end)
