Dispatch = Dispatch or {}

Dispatch['lb-phone'] = {
    alert = function(coords, message)
        local jobs = Config.AmbulanceJobs
        if type(jobs) ~= 'table' or #jobs == 0 then
            jobs = { 'ambulance' }
        end

        for _, job in pairs(jobs) do
            exports['lb-phone']:SendCompanyMessage(job, message, true)
            exports['lb-phone']:SendCompanyCoords(job, coords, true)
        end
    end
}
