--- @return boolean @true if player is boss, false if not
tgiCore.isBoss = function(job)
    local jobData = tgiCore.GetJobData()
    if job and jobData.name ~= job then return false end

    return jobData.isBoss
end

--- Open boss menu for player job
tgiCore.OpenBossMenu = function()
    if not tgiCore.isBoss() then return end
    if config.tgiannServer then
        TriggerEvent('esx_society:openBossMenu', PlayerData.job.name, function(_, menu)
            menu.close()
        end, { wash = false })
    else
        if config.framework == "esx" then
            TriggerEvent('esx_society:openBossMenu', PlayerData.job.name, function() end, { wash = false })
        elseif config.framework == "qb" then
            TriggerEvent("qb-bossmenu:client:OpenMenu")
        end
    end
end
