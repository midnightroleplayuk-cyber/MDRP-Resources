-- The only file that talks directly to Qbox and apex_banking.
Bridge = {}

local qbx = exports.qbx_core

function Bridge.GetPlayer(src)
    src = tonumber(src)
    if not src or src <= 0 then return nil end
    return qbx:GetPlayer(src)
end

function Bridge.GetCitizenId(src)
    local player = Bridge.GetPlayer(src)
    return player and player.PlayerData.citizenid or nil
end

function Bridge.GetCharacterName(src)
    local player = Bridge.GetPlayer(src)
    local info = player and player.PlayerData.charinfo
    if not info then return nil end
    return ('%s %s'):format(info.firstname or '', info.lastname or '')
end

function Bridge.GetJobInfo(src)
    local player = Bridge.GetPlayer(src)
    local job = player and player.PlayerData.job
    if not job or not job.name then return nil end
    return {
        name = job.name,
        grade = tonumber(job.grade and job.grade.level) or 0,
        isBoss = job.isboss == true,
    }
end

function Bridge.JobExists(jobName)
    return type(jobName) == 'string' and qbx:GetJob(jobName) ~= nil
end

function Bridge.GetJobGrades(jobName)
    local job = qbx:GetJob(jobName)
    local grades = {}
    for level, grade in pairs(job and job.grades or {}) do
        local number = tonumber(level)
        if number then
            grades[#grades + 1] = {
                grade = number,
                label = grade.name or ('Grade %d'):format(number),
                isBoss = grade.isboss == true,
            }
        end
    end
    table.sort(grades, function(a, b) return a.grade < b.grade end)
    return grades
end

function Bridge.GetJobs()
    local jobs = {}
    for name, job in pairs(qbx:GetJobs() or {}) do
        if name ~= 'unemployed' then
            jobs[#jobs + 1] = { name = name, label = job.label or name }
        end
    end
    table.sort(jobs, function(a, b) return a.label < b.label end)
    return jobs
end

-- Works for offline characters too. Returns nil when the character no longer exists.
function Bridge.GetNameByCitizenId(citizenId)
    local player = qbx:GetPlayerByCitizenId(citizenId) or qbx:GetOfflinePlayer(citizenId)
    local info = player and player.PlayerData and player.PlayerData.charinfo
    if not info then return nil end
    return ('%s %s'):format(info.firstname or '', info.lastname or '')
end

function Bridge.GetJobLabel(jobName)
    local job = qbx:GetJob(jobName)
    return job and job.label or jobName
end

-- Includes offline employees, because Qbox stores job membership in the database.
function Bridge.GetJobMembers(jobName)
    local members = {}
    for _, row in ipairs(qbx:GetGroupMembers(jobName, 'job') or {}) do
        local player = qbx:GetPlayerByCitizenId(row.citizenid) or qbx:GetOfflinePlayer(row.citizenid)
        local data = player and player.PlayerData
        if data then
            local info = data.charinfo or {}
            members[#members + 1] = {
                citizenid = row.citizenid,
                grade = tonumber(row.grade) or 0,
                name = ('%s %s'):format(info.firstname or 'Unknown', info.lastname or ''),
                online = not player.Offline and data.source ~= nil,
            }
        end
    end
    table.sort(members, function(a, b)
        if a.grade ~= b.grade then return a.grade > b.grade end
        return a.name < b.name
    end)
    return members
end

function Bridge.HireToJob(citizenId, jobName, grade)
    local added, err = qbx:AddPlayerToJob(citizenId, jobName, grade)
    if not added then return false, err and err.message or 'job_update_failed' end
    local primary, primaryErr = qbx:SetPlayerPrimaryJob(citizenId, jobName)
    if not primary then return false, primaryErr and primaryErr.message or 'job_update_failed' end
    return true
end

function Bridge.SetJobGrade(citizenId, jobName, grade)
    local updated, err = qbx:AddPlayerToJob(citizenId, jobName, grade)
    if not updated then return false, err and err.message or 'job_update_failed' end
    return true
end

function Bridge.RemoveFromJob(citizenId, jobName)
    local removed, err = qbx:RemovePlayerFromJob(citizenId, jobName)
    if not removed then return false, err and err.message or 'job_update_failed' end
    return true
end

-- The highest boss grade, or the highest grade when the job defines no boss.
function Bridge.GetTopJobGrade(jobName)
    local top, topBoss
    for _, grade in ipairs(Bridge.GetJobGrades(jobName)) do
        top = grade.grade
        if grade.isBoss then topBoss = grade.grade end
    end
    return topBoss or top or 0
end

function Bridge.IsAdmin(src)
    src = tonumber(src)
    if src == 0 then return true end
    return src ~= nil and IsPlayerAceAllowed(src, 'command')
end

function Bridge.Notify(src, message, notifyType)
    if tonumber(src) == 0 then
        print(('[%s] %s'):format(NDM.Resource, message))
        return
    end
    qbx:Notify(src, message, notifyType or 'inform')
end

function Bridge.GetMoney(src, account)
    return tonumber(qbx:GetMoney(src, account))
end

function Bridge.AddMoney(src, account, amount, reason)
    return qbx:AddMoney(src, account, amount, reason) == true
end

function Bridge.RemoveMoney(src, account, amount, reason)
    return qbx:RemoveMoney(src, account, amount, reason) == true
end

function Bridge.GetItemLabel(item)
    local definition = exports.ox_inventory:Items(item)
    return definition and definition.label or nil
end

function Bridge.GetItemCount(src, item)
    return tonumber(exports.ox_inventory:GetItemCount(src, item)) or 0
end

function Bridge.CanCarryItem(src, item, count)
    return exports.ox_inventory:CanCarryItem(src, item, count) and true or false
end

function Bridge.GiveItem(src, item, count)
    local success = exports.ox_inventory:AddItem(src, item, count)
    return success and true or false
end

function Bridge.TakeItem(src, item, count)
    local success = exports.ox_inventory:RemoveItem(src, item, count)
    return success and true or false
end

-- Indexing a stopped resource's export raises, so the index stays inside pcall.
local function apex(name, ...)
    local ok, result, reason = pcall(function(...)
        return exports.apex_banking[name](nil, ...)
    end, ...)
    if not ok then return nil, tostring(result) end
    return result, reason
end

function Bridge.GetSocietyBalance(job)
    return tonumber((apex('GetBusinessBalance', job)))
end

-- apex_banking returns the new balance on success, or false plus a reason.
function Bridge.AddSocietyMoney(job, amount, reason, actor)
    local result, err = apex('AddBusinessMoney', job, amount, reason, actor)
    if result == nil or result == false then return false, err or 'society_refused' end
    return true
end

function Bridge.RemoveSocietyMoney(job, amount, reason, actor)
    local result, err = apex('RemoveBusinessMoney', job, amount, reason, actor)
    if result == nil or result == false then return false, err or 'society_refused' end
    return true
end
