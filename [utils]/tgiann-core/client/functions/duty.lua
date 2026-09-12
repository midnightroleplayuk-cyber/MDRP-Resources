---@return boolean
function tgiCore.IsOnDuty()
    local jobData = tgiCore.GetJobData()
    return jobData.onDuty
end

---Toggle on/off duty
---@return "dutyFull" | "onDuty" | "offDuty" | nil
function tgiCore.ToggleDuty()
    local onDuty = tgiCore.IsOnDuty()
    if onDuty == nil then return end

    if config.framework == "qb" then
        TriggerServerEvent("QBCore:ToggleDuty")
        return onDuty and "offDuty" or "onDuty"
    end

    return "onDuty"
end
