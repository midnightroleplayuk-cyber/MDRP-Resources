inJobZone = false

function onEnterZone(data)
    if not isJobZone(data) then
        return
    end
    dbug("onEnterZone()")
    inJobZone = data and data['job'] or true
end

function onExitZone(data)
    if not isJobZone(data) then
        return
    end
    dbug("onExitZone()")
    inJobZone = false
    -- EXAMPLE clock out player when leaving the zone
--    TriggerServerEvent("av_business:duty", false)
end

function isJobZone(data)
    local result = false
    if not myJob then
        myJob = exports['av_laptop']:getJob()
    end
    dbug("isJobZone() myJob:", myJob and myJob.name or "nil", "zoneJob:", data and data['job'] or "nil")
    if not myJob then return result end
    local zoneJob = data['job'] or ""
    if zoneJob ~= "" and myJob.name ~= zoneJob then
        return result
    end
    return true
end