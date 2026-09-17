-- relay framework playerLoaded / setJob into MDT events

AddEventHandler('wasabi_mdt:playerLoaded', function()
    TriggerEvent('wasabi_mdt:jobUpdated')
    TriggerServerEvent('wasabi_mdt:server:playerReady')
end)

AddEventHandler('wasabi_mdt:setJob', function(job)
    TriggerEvent('wasabi_mdt:jobUpdated', job)
    TriggerServerEvent('wasabi_mdt:server:jobChanged', job)
end)

-- re-announce if resource restarted mid-session
CreateThread(function()
    while not NetworkIsPlayerActive(PlayerId()) do Wait(200) end
    TriggerServerEvent('wasabi_mdt:server:playerReady')
end)
