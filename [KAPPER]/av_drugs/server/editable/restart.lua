globalCooking = true -- Everyone can set tables/labs to cook unless is set to false

AddEventHandler('txAdmin:events:scheduledRestart', function(eventData)
    if (Config.PreventCooking and globalCooking) and (eventData and eventData.secondsRemaining <= (Config.PreventCooking * 60)) then
        globalCooking = false
        dbug("^3TxAdmin is about to restart, globalCooking set to False^7")
    end
end)