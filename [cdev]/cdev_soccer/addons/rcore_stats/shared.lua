statsInited = false

AddEventHandler('rcore_stats:api:ready', setupStats)

CreateThread(function()
    if GetResourceState("rcore_stats") == "started" or GetResourceState("rcore_stats") == "starting" then
        while not statsInited do
            TriggerEvent('rcore_stats:api:isReady', function(isReady)
                if isReady then
                    statsInited = true
                end
            end)
            Wait(1000)
        end
    end
end)
