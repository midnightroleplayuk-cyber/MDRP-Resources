if Config.Framework ~= 'qb' then return end
if GetResourceState('qbx_core') == 'started' then return end

CreateThread(function()
    while not Framework do
        local ok, obj = pcall(function()
            return exports['qb-core']:GetCoreObject()
        end)
        if ok and obj then
            Framework = obj
        end
        Wait(100)
    end
end)

function Fr.GetPlayer(src)
    if not Framework then return nil end
    return Framework.Functions.GetPlayer(src)
end

function Fr.GetJob(src)
    local player = Fr.GetPlayer(src)
    if not player then return { name = 'unemployed', grade = 0, onduty = false } end
    local job = player.PlayerData.job
    return {
        name = job.name,
        grade = job.grade and job.grade.level or 0,
        label = job.label,
        gradeLabel = job.grade and (job.grade.name or job.grade.label) or nil,
        onduty = job.onduty == true,
    }
end

function Fr.GetMoney(src, account)
    local player = Fr.GetPlayer(src)
    if not player then return 0 end
    account = account or 'bank'
    return player.Functions.GetMoney(account) or 0
end

function Fr.RemoveMoney(src, account, amount, reason)
    local player = Fr.GetPlayer(src)
    if not player then return false end
    return player.Functions.RemoveMoney(account or 'bank', amount, reason or 'op-mechanic')
end

function Fr.Notify(src, message, nType, time)
    TriggerClientEvent(OPM.Net.ClientNotify or 'opm:client:notify', src, message, nType, time)
end

function Fr.GetIdentifier(src)
    local player = Fr.GetPlayer(src)
    return player and player.PlayerData and player.PlayerData.citizenid or nil
end

---@param src number
---@return string|table|nil
function Fr.GetGroup(src)
    if not Framework or not Framework.Functions or not Framework.Functions.GetPermission then
        return nil
    end
    return Framework.Functions.GetPermission(src)
end

--- Character profile for online player (invoice target).
---@param src number
---@return table|nil
function Fr.GetCharacterProfile(src)
    local player = Fr.GetPlayer(src)
    if not player or not player.PlayerData then
        return nil
    end
    local info = player.PlayerData.charinfo or {}
    local first = info.firstname or ''
    local last = info.lastname or ''
    local name = (tostring(first) .. ' ' .. tostring(last)):gsub('^%s+', ''):gsub('%s+$', '')
    if name == '' then
        name = GetPlayerName(src) or ('Player %s'):format(src)
    end
    return {
        identifier = player.PlayerData.citizenid,
        name = name,
        firstname = first,
        lastname = last,
        serverId = src,
    }
end

--- Search characters in QB players table by charinfo name / citizenid.
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
    local like = '%' .. string.lower(q) .. '%'
    local rows = MySQL.query.await([[
        SELECT citizenid, charinfo
        FROM players
        WHERE
            LOWER(TRIM(JSON_UNQUOTE(JSON_EXTRACT(charinfo, '$.firstname')))) LIKE ?
            OR LOWER(TRIM(JSON_UNQUOTE(JSON_EXTRACT(charinfo, '$.lastname')))) LIKE ?
            OR LOWER(citizenid) LIKE ?
            OR LOWER(CONCAT(
                TRIM(JSON_UNQUOTE(JSON_EXTRACT(charinfo, '$.firstname'))),
                ' ',
                TRIM(JSON_UNQUOTE(JSON_EXTRACT(charinfo, '$.lastname')))
            )) LIKE ?
        LIMIT ?
    ]], { like, like, like, like, limit }) or {}

    local out = {}
    for i = 1, #rows do
        local row = rows[i]
        local info = {}
        if type(row.charinfo) == 'string' and row.charinfo ~= '' then
            local ok, decoded = pcall(json.decode, row.charinfo)
            if ok and type(decoded) == 'table' then
                info = decoded
            end
        elseif type(row.charinfo) == 'table' then
            info = row.charinfo
        end
        local first = info.firstname or ''
        local last = info.lastname or ''
        local name = (first .. ' ' .. last):gsub('^%s+', ''):gsub('%s+$', '')
        if name == '' then
            name = row.citizenid or 'Unknown'
        end
        out[#out + 1] = {
            identifier = row.citizenid,
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
    local entry = player.Functions.GetItemByName(item)
    local amount = entry and (entry.amount or entry.count or 0) or 0
    return amount >= count
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
    return player.Functions.RemoveItem(item, count) and true or false
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
    return player.Functions.AddItem(item, count) and true or false
end

function Fr.AddMoney(src, account, amount, reason)
    local player = Fr.GetPlayer(src)
    if not player then
        return false
    end
    amount = math.floor(tonumber(amount) or 0)
    if amount <= 0 then
        return true
    end
    if account == 'money' then
        account = 'cash'
    end
    return player.Functions.AddMoney(account or 'cash', amount, reason or 'op-mechanic') and true or false
end

function Fr.GetPlayerByIdentifier(identifier)
    if not Framework or not identifier then
        return nil
    end
    return Framework.Functions.GetPlayerByCitizenId(identifier)
end

function Fr.GetJobGrades(jobName)
    jobName = jobName or 'mechanic'
    if not Framework or not Framework.Shared or not Framework.Shared.Jobs then
        return {}
    end
    local job = Framework.Shared.Jobs[jobName]
    if not job or type(job.grades) ~= 'table' then
        return {}
    end
    local out = {}
    for key, grade in pairs(job.grades) do
        local g = tonumber(key) or tonumber(grade.level) or 0
        out[#out + 1] = {
            grade = g,
            label = grade.name or grade.label or tostring(g),
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
    local grades = {}
    for _, g in ipairs(Fr.GetJobGrades(jobName)) do
        grades[tostring(g.grade)] = g.label
    end

    if Framework and Framework.Functions.GetQBPlayers then
        local players = Framework.Functions.GetQBPlayers() or {}
        for _, player in pairs(players) do
            local job = player.PlayerData and player.PlayerData.job
            if job and job.name == jobName then
                local cid = player.PlayerData.citizenid
                onlineIds[cid] = true
                local level = job.grade and (job.grade.level or job.grade) or 0
                local info = player.PlayerData.charinfo or {}
                local name = ((info.firstname or '') .. ' ' .. (info.lastname or '')):gsub('^%s+', ''):gsub('%s+$', '')
                out[#out + 1] = {
                    identifier = cid,
                    name = name ~= '' and name or cid,
                    grade = tonumber(level) or 0,
                    gradeLabel = (job.grade and job.grade.name) or grades[tostring(level)] or tostring(level),
                    online = true,
                    onduty = job.onduty == true,
                    serverId = player.PlayerData.source,
                }
            end
        end
    end

    if MySQL then
        -- Filter by job name in SQL — never SELECT the whole players table.
        local rows = MySQL.query.await([[
            SELECT citizenid, charinfo, job FROM players
            WHERE JSON_UNQUOTE(JSON_EXTRACT(job, '$.name')) = ?
        ]], { jobName }) or {}
        for i = 1, #rows do
            local row = rows[i]
            if not onlineIds[row.citizenid] then
                local jobData = row.job
                if type(jobData) == 'string' then
                    local ok, decoded = pcall(json.decode, jobData)
                    if ok then
                        jobData = decoded
                    end
                end
                local info = {}
                if type(row.charinfo) == 'string' then
                    local ok, decoded = pcall(json.decode, row.charinfo)
                    if ok then
                        info = decoded
                    end
                elseif type(row.charinfo) == 'table' then
                    info = row.charinfo
                end
                local level = 0
                if type(jobData) == 'table' then
                    if type(jobData.grade) == 'table' then
                        level = tonumber(jobData.grade.level) or 0
                    else
                        level = tonumber(jobData.grade) or 0
                    end
                end
                local name = ((info.firstname or '') .. ' ' .. (info.lastname or '')):gsub('^%s+', ''):gsub('%s+$', '')
                out[#out + 1] = {
                    identifier = row.citizenid,
                    name = name ~= '' and name or row.citizenid,
                    grade = level,
                    gradeLabel = grades[tostring(level)] or tostring(level),
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
    local src = nil
    local citizenid = nil

    if type(target) == 'number' then
        src = target
        player = Fr.GetPlayer(src)
    elseif type(target) == 'string' then
        citizenid = target
        player = Fr.GetPlayerByIdentifier(target)
    elseif type(target) == 'table' then
        player = target
    end

    if player and player.PlayerData then
        src = src or tonumber(player.PlayerData.source)
        citizenid = citizenid or player.PlayerData.citizenid
    end

    if player and player.Functions and player.Functions.SetJob then
        local ok, success = pcall(function()
            return player.Functions.SetJob(jobName, grade)
        end)
        if ok and success ~= false then
            return true
        end
    end

    if citizenid and MySQL and Framework and Framework.Shared and Framework.Shared.Jobs then
        local job = Framework.Shared.Jobs[jobName]
        if not job then
            return false
        end
        local gradeInfo = job.grades and (job.grades[tostring(grade)] or job.grades[grade])
        local jobPayload = {
            name = jobName,
            label = job.label or jobName,
            payment = gradeInfo and gradeInfo.payment or 0,
            onduty = false,
            isboss = gradeInfo and gradeInfo.isboss or false,
            grade = {
                name = gradeInfo and gradeInfo.name or tostring(grade),
                level = grade,
            },
        }
        MySQL.update.await('UPDATE players SET job = ? WHERE citizenid = ?', {
            json.encode(jobPayload),
            citizenid,
        })
        return true
    end
    return false
end