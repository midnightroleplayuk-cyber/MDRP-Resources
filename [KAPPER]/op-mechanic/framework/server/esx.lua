if Config.Framework ~= 'esx' then return end

CreateThread(function()
    while not Framework do
        local ok, obj = pcall(function()
            return exports['es_extended']:getSharedObject()
        end)
        if ok and obj then
            Framework = obj
        end
        Wait(100)
    end
end)

function Fr.GetPlayer(src)
    if not Framework then return nil end
    return Framework.GetPlayerFromId(src)
end

function Fr.GetJob(src)
    local player = Fr.GetPlayer(src)
    if not player then return { name = 'unemployed', grade = 0 } end
    local job = player.getJob and player.getJob() or player.job
    return {
        name = job.name,
        grade = job.grade,
        label = job.label,
        gradeLabel = job.grade_label or job.grade_name or nil,
    }
end

function Fr.GetMoney(src, account)
    local player = Fr.GetPlayer(src)
    if not player then return 0 end
    account = account or 'bank'
    if account == 'cash' or account == 'money' then
        return player.getMoney and player.getMoney() or 0
    end
    local acc = player.getAccount and player.getAccount(account)
    return acc and acc.money or 0
end

function Fr.RemoveMoney(src, account, amount, _reason)
    local player = Fr.GetPlayer(src)
    if not player then return false end
    account = account or 'bank'
    if account == 'cash' or account == 'money' then
        if player.getMoney() < amount then return false end
        player.removeMoney(amount)
        return true
    end
    local acc = player.getAccount(account)
    if not acc or acc.money < amount then return false end
    player.removeAccountMoney(account, amount)
    return true
end

function Fr.Notify(src, message, nType, time)
    TriggerClientEvent(OPM.Net.ClientNotify or 'opm:client:notify', src, message, nType, time)
end

function Fr.GetIdentifier(src)
    local player = Fr.GetPlayer(src)
    return player and player.identifier or nil
end

---@param src number
---@return string|nil
function Fr.GetGroup(src)
    local player = Fr.GetPlayer(src)
    if not player or not player.getGroup then
        return nil
    end
    return player.getGroup()
end

--- Character profile for online player (invoice target).
---@param src number
---@return table|nil
function Fr.GetCharacterProfile(src)
    local player = Fr.GetPlayer(src)
    if not player then
        return nil
    end
    local first, last = '', ''
    if player.get then
        first = player.get('firstName') or ''
        last = player.get('lastName') or ''
    end
    local name = (tostring(first) .. ' ' .. tostring(last)):gsub('^%s+', ''):gsub('%s+$', '')
    if name == '' and player.getName then
        name = player.getName() or ''
    end
    if name == '' then
        name = GetPlayerName(src) or ('Player %s'):format(src)
    end
    return {
        identifier = player.identifier,
        name = name,
        firstname = first,
        lastname = last,
        serverId = src,
    }
end

--- Search characters in ESX users table by name / identifier.
---@param query string
---@param opts table|nil
---@return table[]
function Fr.SearchPlayers(query, opts)
    opts = opts or {}
    local q = tostring(query or ''):gsub('^%s+', ''):gsub('%s+$', '')
    if #q < 2 then
        return {}
    end
    if MySQL == nil then
        return {}
    end

    local limit = math.min(tonumber(opts.limit) or 8, 20)
    local like = '%' .. q .. '%'
    local rows = MySQL.query.await([[
        SELECT identifier, firstname, lastname
        FROM users
        WHERE firstname LIKE ? OR lastname LIKE ? OR identifier LIKE ?
           OR CONCAT(firstname, ' ', lastname) LIKE ?
        LIMIT ?
    ]], { like, like, like, like, limit }) or {}

    local out = {}
    for i = 1, #rows do
        local row = rows[i]
        local first = row.firstname or ''
        local last = row.lastname or ''
        local name = (first .. ' ' .. last):gsub('^%s+', ''):gsub('%s+$', '')
        if name == '' then
            name = row.identifier or 'Unknown'
        end
        out[#out + 1] = {
            identifier = row.identifier,
            name = name,
            firstname = first,
            lastname = last,
        }
    end
    return out
end

function Fr.HasItem(src, item, count)
    local player = Fr.GetPlayer(src)
    if not player or not item then
        return false
    end
    count = math.floor(tonumber(count) or 1)
    if count <= 0 then
        return true
    end
    if player.getInventoryItem then
        local entry = player.getInventoryItem(item)
        local amount = entry and (entry.count or entry.amount or 0) or 0
        return amount >= count
    end
    return false
end

function Fr.RemoveItem(src, item, count)
    local player = Fr.GetPlayer(src)
    if not player or not item then
        return false
    end
    count = math.floor(tonumber(count) or 1)
    if count <= 0 then
        return true
    end
    if player.removeInventoryItem then
        player.removeInventoryItem(item, count)
        return true
    end
    return false
end

function Fr.AddItem(src, item, count)
    local player = Fr.GetPlayer(src)
    if not player or not item then
        return false
    end
    count = math.floor(tonumber(count) or 1)
    if count <= 0 then
        return false
    end
    if player.addInventoryItem then
        player.addInventoryItem(item, count)
        return true
    end
    return false
end

function Fr.AddMoney(src, account, amount, _reason)
    local player = Fr.GetPlayer(src)
    if not player then
        return false
    end
    amount = math.floor(tonumber(amount) or 0)
    if amount <= 0 then
        return true
    end
    account = account or 'bank'
    if account == 'cash' or account == 'money' then
        if player.addMoney then
            player.addMoney(amount)
            return true
        end
        return false
    end
    if player.addAccountMoney then
        player.addAccountMoney(account, amount)
        return true
    end
    return false
end

function Fr.GetPlayerByIdentifier(identifier)
    if not Framework or not identifier then
        return nil
    end
    if Framework.GetPlayerFromIdentifier then
        return Framework.GetPlayerFromIdentifier(identifier)
    end
    return nil
end

function Fr.GetJobGrades(jobName)
    jobName = jobName or 'mechanic'
    if not Framework then
        return {}
    end
    local jobs = Framework.GetJobs and Framework.GetJobs() or {}
    local job = jobs[jobName]
    if not job or type(job.grades) ~= 'table' then
        return {}
    end
    local out = {}
    for key, grade in pairs(job.grades) do
        local g = tonumber(grade.grade or key) or 0
        out[#out + 1] = {
            grade = g,
            label = grade.label or grade.name or tostring(g),
            name = grade.name or grade.label or tostring(g),
        }
    end
    table.sort(out, function(a, b)
        return a.grade < b.grade
    end)
    return out
end

function Fr.GetEmployees(jobName)
    jobName = jobName or 'mechanic'
    local out = {}
    local onlineIds = {}

    if Framework and Framework.GetExtendedPlayers then
        local players = Framework.GetExtendedPlayers('job', jobName) or {}
        for i = 1, #players do
            local xPlayer = players[i]
            local job = xPlayer.getJob and xPlayer.getJob() or xPlayer.job
            local first = xPlayer.get and (xPlayer.get('firstName') or '') or ''
            local last = xPlayer.get and (xPlayer.get('lastName') or '') or ''
            local name = (tostring(first) .. ' ' .. tostring(last)):gsub('^%s+', ''):gsub('%s+$', '')
            if name == '' and xPlayer.getName then
                name = xPlayer.getName() or ''
            end
            local src = xPlayer.source
            onlineIds[xPlayer.identifier] = true
            out[#out + 1] = {
                identifier = xPlayer.identifier,
                name = name ~= '' and name or (GetPlayerName(src) or xPlayer.identifier),
                grade = job and (job.grade or 0) or 0,
                gradeLabel = job and (job.grade_label or job.label or '') or '',
                online = true,
                onduty = Fr.IsOnDuty and Fr.IsOnDuty(src) or false,
                serverId = src,
            }
        end
    end

    if MySQL then
        local rows = MySQL.query.await(
            'SELECT identifier, job_grade, firstname, lastname FROM users WHERE job = ?',
            { jobName }
        ) or {}
        local grades = {}
        for _, g in ipairs(Fr.GetJobGrades(jobName)) do
            grades[tostring(g.grade)] = g.label
        end
        for i = 1, #rows do
            local row = rows[i]
            if not onlineIds[row.identifier] then
                local first = row.firstname or ''
                local last = row.lastname or ''
                local name = (first .. ' ' .. last):gsub('^%s+', ''):gsub('%s+$', '')
                local g = tonumber(row.job_grade) or 0
                out[#out + 1] = {
                    identifier = row.identifier,
                    name = name ~= '' and name or row.identifier,
                    grade = g,
                    gradeLabel = grades[tostring(g)] or tostring(g),
                    online = false,
                    onduty = false,
                    serverId = nil,
                }
            end
        end
    end

    table.sort(out, function(a, b)
        if a.grade ~= b.grade then
            return a.grade > b.grade
        end
        return tostring(a.name) < tostring(b.name)
    end)
    return out
end

function Fr.SetJob(target, jobName, grade)
    grade = tonumber(grade) or 0
    jobName = jobName or 'mechanic'
    local player = nil
    if type(target) == 'number' then
        player = Fr.GetPlayer(target)
    elseif type(target) == 'string' then
        player = Fr.GetPlayerByIdentifier(target)
    elseif type(target) == 'table' then
        player = target
    end

    if player and player.setJob then
        player.setJob(jobName, grade)
        return true
    end

    if type(target) == 'string' and MySQL then
        MySQL.update.await(
            'UPDATE users SET job = ?, job_grade = ? WHERE identifier = ?',
            { jobName, grade, target }
        )
        return true
    end
    return false
end