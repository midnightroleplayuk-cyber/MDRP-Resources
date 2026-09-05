Framework = nil
Fr = {}

function Fr.GetPlayerJob()
    return { name = 'unemployed', grade = 0, label = 'Unemployed' }
end

function Fr.HasJob(jobName, minGrade)
    local job = Fr.GetPlayerJob and Fr.GetPlayerJob() or nil
    if not job or job.name ~= jobName then
        return false
    end
    return (job.grade or 0) >= (minGrade or 0)
end

function Fr.Notify(message, nType, time)
    if type(sendNotify) == 'function' then
        sendNotify(message, nType, time)
        return
    end
    if SetNotificationTextEntry and DrawNotification then
        SetNotificationTextEntry('STRING')
        AddTextComponentSubstringPlayerName(tostring(message or ''))
        DrawNotification(false, true)
        return
    end
    print(('[op-mechanic] %s'):format(tostring(message or '')))
end

--- Open a mechanic stash. Inventory-specific files override this.
---@param stashId string
---@param data table|nil { label, slots, weight }
function Fr.OpenStash(stashId, data)
    if type(stashId) ~= 'string' or stashId == '' then
        return
    end
    TriggerServerEvent('opm:server:inventory:openStash', stashId, data or {})
end

RegisterNetEvent('opm:client:inventory:openStash', function(stashId, data)
    if Fr.OpenStashDirect then
        Fr.OpenStashDirect(stashId, data or {})
    end
end)

--- Progress bar. Prefers ox_lib at call-time (not only at resource boot).
---@param opts table { duration, label?, canCancel?, style?, position?, disable?, useWhileDead? }
---@return boolean
function Fr.Progress(opts)
    opts = type(opts) == 'table' and opts or {}
    local duration = tonumber(opts.duration) or 4000
    if duration < 0 then
        duration = 0
    end

    local pref = Config.ProgressBar or 'ox_lib'
    local wantOx = pref ~= 'none'
    if wantOx and GetResourceState('ox_lib') == 'started' and lib then
        local label = opts.label or 'Working...'
        local canCancel = opts.canCancel ~= false
        local disable = opts.disable or { move = true, car = true, combat = true }
        local useWhileDead = opts.useWhileDead == true
        local style = opts.style or 'circle'

        if style == 'bar' and lib.progressBar then
            return lib.progressBar({
                duration = duration,
                label = label,
                useWhileDead = useWhileDead,
                canCancel = canCancel,
                disable = disable,
            }) == true
        end

        if lib.progressCircle then
            return lib.progressCircle({
                duration = duration,
                label = label,
                position = opts.position or 'bottom',
                useWhileDead = useWhileDead,
                canCancel = canCancel,
                disable = disable,
            }) == true
        end

        if lib.progressBar then
            return lib.progressBar({
                duration = duration,
                label = label,
                useWhileDead = useWhileDead,
                canCancel = canCancel,
                disable = disable,
            }) == true
        end
    end

    if duration > 0 then
        Wait(duration)
    end
    return true
end