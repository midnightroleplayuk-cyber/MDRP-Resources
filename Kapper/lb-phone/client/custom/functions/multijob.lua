---@class MultiJobJob
---@field job string
---@field label string
---@field icon? string
---@field [string] any

---@class MultiJobData
---@field jobs MultiJobJob[]
---@field activeJob string
---@field canLeave boolean

---@return MultiJobData | nil
function GetMultiJobs()
    if GetResourceState("ps-multijob") == "started" then
        if not QB then
            return
        end

        local jobsPromise = promise.new()

        QB.Functions.TriggerCallback('ps-multijob:getJobs', function(result)
            jobsPromise:resolve(result)
        end)

        ---@type MultiJobJob[]
        local formattedJobs = {}
        local allJobs = Citizen.Await(jobsPromise)

        for _, jobs in pairs(allJobs) do
            for i = 1, #jobs do
                local job = jobs[i]

                formattedJobs[#formattedJobs+1] = {
                    icon = job.icon,
                    job = job.name,
                    label = job.label,
                    grade = job.grade
                }
            end
        end

        return {
            jobs = formattedJobs,
            activeJob = GetJob(),
            canLeave = true
        }
    end
end

---@param job MultiJobJob
---@return boolean
function SetActiveJob(job)
    if GetResourceState("ps-multijob") == "started" then
        TriggerServerEvent("ps-multijob:changeJob", job.job, job.grade)

        return true
    end

    return false
end

---@param job MultiJobJob
---@return boolean
function LeaveJob(job)
    if GetResourceState("ps-multijob") == "started" then
        TriggerServerEvent("ps-multijob:removeJob", job.job, job.grade)

        return true
    end

    return false
end

---@param data MultiJobData?
function SetMultiJobData(data)
    SendNUIAction("services:setJobs", data)
end

function RefreshMultiJobs()
    local data = GetMultiJobs()

    SetMultiJobData(data)
end
