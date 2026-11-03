local updated = {}
local cooldownTime = 1 -- in minutes, read docs > av_business > blips if u opened this file and u have 0 idea what this does...

RegisterServerEvent("av_business:toggleBlip", function(job,state)
    dbug('toggleBlip(jobm, isOpen?)', job, state)
    if Config.Blips and Config.Blips[job] then
        Config.Blips[job]['online'] = state
        if not inCooldown(job) then
            -- Here YOU can add a TriggerClientEvent that notifies everyone in sv the business is open/closed (is optional)
            local label = Config.Blips[job]['label']
            if Config.Blips[job]['online'] then -- business is open

            else -- business closed

            end
        end
        updated[job] = os.time() + cooldownTime * 60
        TriggerClientEvent("av_business:refreshBlips", -1, Config.Blips)
    else
        dbug("Ooops, this job doesn't have any pre made blip in Config.Blips :(")
    end
end)

function inCooldown(job)
    local now = os.time()
    if updated[job] and updated[job] > now then
        return true
    end
    return false
end