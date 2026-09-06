if Config.Framework ~= "qb" then
    return
end

while not QB do
    Wait(500)
    debugprint("Services: Waiting for QB to load")
end

RegisterNetEvent("QBCore:Client:OnJobUpdate", function(jobInfo)
    local oldJob = PlayerData.job

    PlayerData.job = jobInfo

    if not oldJob or (oldJob.name ~= PlayerData.job.name or oldJob.grade?.level ~= PlayerData.job.grade?.level) then
        SendNUIAction("services:setCompany", GetCompanyData())
    else
        SendNUIAction("services:setDuty", jobInfo.onduty)
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
    if PlayerData.job.name == "unemployed" then
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

    if GetResourceState("qb-management") ~= "started" then
        QB.Functions.TriggerCallback("qb-bossmenu:server:GetAccount", function(money)
            jobData.balance = money
        end, jobData.job)
    else
        jobData.balance = AwaitCallback("services:getAccount")
    end

    QB.Functions.TriggerCallback("qb-bossmenu:server:GetEmployees", function(employees)
        for i = 1, #employees do
            local employee = employees[i]

            employees[i] = {
                name = employee.name,
                id = employee.empSource,

                gradeLabel = employee.grade.name,
                grade = employee.grade.level,

                canInteract = not employee.isboss
            }
        end

        jobData.employees = employees
    end, jobData.job)

    local timeout = GetGameTimer() + 2000

    while not jobData.balance or not jobData.employees do
        Wait(0)

        if GetGameTimer() > timeout then
            infoprint("error", "Failed to get company data (timed out after 2s)")
            print("balance: " .. tostring(jobData.balance))
            print("employees: " .. tostring(jobData.employees))

            jobData.employees = jobData.employees or {}
            jobData.balance = jobData.balance or 0
            break
        end
    end

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

function DepositMoney(amount, cb)
    if GetResourceState("qb-management") == "started" then
        return AwaitCallback("services:addMoney", amount)
    end

    TriggerServerEvent("qb-bossmenu:server:depositMoney", amount)
    Wait(500) -- Wait for the server to update the balance

    QB.Functions.TriggerCallback("qb-bossmenu:server:GetAccount", cb, PlayerData.job.name)
end

function WithdrawMoney(amount, cb)
    if GetResourceState("qb-management") == "started" then
        return AwaitCallback("services:removeMoney", amount)
    end

    TriggerServerEvent("qb-bossmenu:server:withdrawMoney", amount)
    Wait(500) -- Wait for the server to update the balance

    QB.Functions.TriggerCallback("qb-bossmenu:server:GetAccount", cb, PlayerData.job.name)
end

function HireEmployee(source)
    TriggerServerEvent("qb-bossmenu:server:HireEmployee", source)

    return AwaitCallback("services:getPlayerData", source)
end

function FireEmployee(source)
    TriggerServerEvent("qb-bossmenu:server:FireEmployee", source)

    return PlayerData.job.isboss or false
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

    TriggerServerEvent("qb-bossmenu:server:GradeUpdate", {
        cid = identifier,
        grade = newGrade,
        gradename = QB.Shared.Jobs[PlayerData.job.name].grades[tostring(newGrade)].name
    })

    return true
end

function ToggleDuty()
    TriggerServerEvent("QBCore:ToggleDuty")
end
