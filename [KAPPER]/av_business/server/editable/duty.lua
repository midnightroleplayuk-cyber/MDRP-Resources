local onDuty = {}

RegisterServerEvent("av_business:duty", function(state)
    local src = source
    if type(state) == "boolean" then
        onDuty[src] = state
        toggleDuty(src, state)
        return
    end
    local currentState = onDuty[src] and true or false
    toggleDuty(src, not currentState)
end)

function toggleDuty(playerId, state, multijob)
    local name = exports['av_laptop']:getName(playerId)
    local currentJob = exports['av_laptop']:getJob(playerId).name
    onDuty[playerId] = onDuty[playerId] or {}
    if not state then
        if onDuty[playerId]['clockIn'] then
            local now = os.time()
            local v = onDuty[playerId]
            local identifier = v['identifier']
            local savedJob = v['job']
            local clockIn = v['clockIn']
            local worked = getTodaysWorked(identifier, savedJob)
            local diff = hoursWorked(worked, now, clockIn)
            if (diff and worked) and (diff > worked) then
                setHoursWorked(savedJob, identifier, diff)
            end
        end
        onDuty[playerId] = nil
        if not multijob then
            exports['av_laptop']:toggleDuty(playerId, false)
            TriggerClientEvent("av_laptop:notification", playerId, Lang['app_title'], Lang['duty_off'], "inform")
        end
        local identifier = exports['av_laptop']:getIdentifier(playerId)
        sendLog("duty", playerId, currentJob, {identifier = identifier, name = name, duty = false})
    else
        today[currentJob] = today[currentJob] or {}
        today[currentJob]['employees'] = today[currentJob]['employees'] or {}
        if not onDuty[playerId]['identifier'] then
            onDuty[playerId]['identifier'] = exports['av_laptop']:getIdentifier(playerId)
        end
        if not onDuty[playerId]['clockIn'] then
            onDuty[playerId]['clockIn'] = os.time()
        end
        if not onDuty[playerId]['job'] then
            onDuty[playerId]['job'] = currentJob
        end
        local identifier = onDuty[playerId]['identifier']
        if not allBusiness[currentJob] then
            newBusiness(currentJob)
        end
        local business = allBusiness[currentJob] or {}
        business['employees'] = business['employees'] or {}
        business['employees'][identifier] = business['employees'][identifier] or {}
        business['employees'][identifier]['lastSeen'] = os.date("%m/%d/%y %H:%M", os.time())
        if not today[currentJob]['employees'][identifier] then
            today[currentJob]['employees'][identifier] = {
                name = name,
                hours = 0,
                image = business['employees'][identifier]['image'] or ""
            }
        end
        if not multijob then
            exports['av_laptop']:toggleDuty(playerId, true)
            TriggerClientEvent("av_laptop:notification", playerId, Lang['app_title'], Lang['duty_on'], "success")
        end
        sendLog("duty", playerId, currentJob, {identifier = identifier, name = name, duty = true})
    end
end

CreateThread(function()
    while true do
        for k, v in pairs(onDuty) do
            local now = os.time()
            local exists = GetPlayerPed(k)
            if exists then
                local identifier = v['identifier']
                local job = v['job']
                local clockIn = v['clockIn']
                local worked = getTodaysWorked(identifier,job)
                local diff = hoursWorked(worked, now, clockIn)
                if (diff and worked) and (diff > worked) then
                    setHoursWorked(job, identifier, diff)
                end
            else
                onDuty[k] = nil
            end
        end
        Wait(1 * 60 * 1000)
    end
end)

AddEventHandler('playerDropped', function()
    if not source then return end
    local playerId = tostring(source)
    if playerId and onDuty[playerId] then
        local now = os.time()
        local v = onDuty[playerId]
        local identifier = v['identifier']
        local job = v['job']
        local clockIn = v['clockIn']
        local worked = getTodaysWorked(identifier,job)
        local diff = hoursWorked(worked, now, clockIn)
        if (diff and worked) and (diff > worked) then
            setHoursWorked(job, identifier, diff)
        end
        onDuty[playerId] = nil
    end
end)

exports("toggleDuty", toggleDuty)