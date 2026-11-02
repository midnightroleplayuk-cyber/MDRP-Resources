CreateThread(function()
    while true do
        local cops = exports['av_laptop']:getNumPlayersFromJob(Config.PoliceJobs)
        TriggerClientEvent('av_drugs:setCopsCount', -1, cops)
        dbug('copsCount()', cops)
        Wait(5 * 60 * 100) -- Count cops every 5 minutes
    end
end)