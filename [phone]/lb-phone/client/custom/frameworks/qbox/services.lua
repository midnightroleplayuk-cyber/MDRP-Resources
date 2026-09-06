if Config.Framework ~= "qbox" then
    return
end

while not QB do
    Wait(500)
    debugprint("Services: Waiting for QBox to load")
end

RegisterNetEvent("QBCore:Client:SetDuty", function(onDuty)
    PlayerData.job.onduty = onDuty

    SendNUIAction("services:setDuty", onDuty)
end)

RegisterNetEvent("QBCore:Client:OnJobUpdate", function(jobInfo)
    local oldJob = PlayerData.job

    PlayerData.job = jobInfo

    if not oldJob or (oldJob.name ~= PlayerData.job.name or oldJob.grade?.level ~= PlayerData.job.grade?.level) then
        SendNUIAction("services:setCompany", GetCompanyData())
    end

    TriggerEvent("lb-phone:jobUpdated", {
        job = PlayerData.job.name,
        grade = PlayerData.job.grade.level
    })

    if RefreshMultiJobs then
        RefreshMultiJobs()
    end
end)

---@return string
function GetJob()
    return PlayerData?.job?.name or "unemployed"
end

---@return number
function GetJobGrade()
    return PlayerData?.job?.grade?.level or 0
end

function GetCompanyData()
    if GetJob() == "unemployed" then
        return
    end

    local jobData = {
        job = PlayerData.job.name,
        jobLabel = PlayerData.job.label,
        isBoss = PlayerData.job.isboss,
        duty = PlayerData.job.onduty
    }

    if not jobData.isBoss then
        return jobData
    end

    jobData.balance = AwaitCallback("qbx:services:getAccount")
    jobData.employees = AwaitCallback("qbx:services:getEmployees")
    jobData.grades = {}

    for k, v in pairs(QB.Shared.Jobs[jobData.job].grades) do
        jobData.grades[#jobData.grades + 1] = {
            label = v.name,
            grade = tonumber(k)
        }
    end

    table.sort(jobData.grades, function(a, b)
        return a.grade < b.grade
    end)

    return jobData
end

function DepositMoney(amount)
    return AwaitCallback("qbx:services:addMoney", amount)
end

function WithdrawMoney(amount)
    return AwaitCallback("qbx:services:removeMoney", amount)
end

function HireEmployee(source)
    if not AwaitCallback("qbx:services:hireEmployee", source) then
        return false
    end

    return AwaitCallback("services:getPlayerData", source)
end

function FireEmployee(citizenid)
    return AwaitCallback("qbx:services:fireEmployee", citizenid)
end

function SetGrade(identifier, newGrade)
    local maxGrade = 0

    for grade, _ in pairs(QB.Shared.Jobs[PlayerData.job.name].grades) do
        grade = tonumber(grade)

        if grade and grade > maxGrade then
            maxGrade = grade
        end
    end

    if newGrade > maxGrade then
        return false
    end

    return AwaitCallback("qbx:services:setGrade", identifier, newGrade)
end

function ToggleDuty()
    TriggerServerEvent("QBCore:ToggleDuty")
end
