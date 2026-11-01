-- Don't modify anything from this file...
-- Count online police and update external resources like boosting
local policeJobs = {}
alreadyCounted = {}
CreateThread(function()
    while true do
        alreadyCounted = {}
        for k, v in pairs(policeJobs) do
            local total = getNumPlayersFromJob(v)
            TriggerClientEvent(k..":SetCopCount", -1, total)
            TriggerEvent(k..":SetCopCount", total)
        end
        Wait(2 * 60 * 1000)
    end
end)

exports("addPoliceJobs", function(resource,jobs)
    if not jobs or not resource then return end
    policeJobs[resource] = jobs
end)