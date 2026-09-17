local fallbackDuty = {}

local function readFrameworkDuty(src)
    local job = Fr.GetJob and Fr.GetJob(src) or nil
    if job and job.onduty ~= nil then
        return job.onduty == true
    end
    return nil
end

function Fr.IsOnDuty(src)
    src = tonumber(src)
    if not src then
        return false
    end
    local frameworkDuty = readFrameworkDuty(src)
    if frameworkDuty ~= nil then
        return frameworkDuty
    end
    if fallbackDuty[src] ~= nil then
        return fallbackDuty[src] == true
    end
    -- Default: off duty until the player clocks in.
    return false
end

function Fr.SetOnDuty(src, onDuty)
    src = tonumber(src)
    if not src then
        return false
    end
    onDuty = onDuty == true

    local player = Fr.GetPlayer and Fr.GetPlayer(src) or nil
    if player then
        if player.Functions and player.Functions.SetJobDuty then
            player.Functions.SetJobDuty(onDuty)
            fallbackDuty[src] = nil
            return true
        end
        if type(player.setDuty) == 'function' then
            player.setDuty(onDuty)
            fallbackDuty[src] = nil
            return true
        end
        if type(player.setJobDuty) == 'function' then
            player.setJobDuty(onDuty)
            fallbackDuty[src] = nil
            return true
        end
    end

    fallbackDuty[src] = onDuty
    return true
end

AddEventHandler('playerDropped', function()
    fallbackDuty[source] = nil
end)