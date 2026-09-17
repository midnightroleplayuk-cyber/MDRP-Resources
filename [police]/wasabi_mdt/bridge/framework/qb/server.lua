if not GetResourceState('qb-core'):find('start') then return end
if GetResourceState('qbx_core'):find('start') then return end -- QBX uses its own bridge file

lib.print.debug('[wasabi_mdt] QB framework detected, initializing bridge')

local QBCore = exports['qb-core']:GetCoreObject()

---@type Bridge
local bridge = {}

bridge.framework = 'qb'

local function convertDate(dateStr)
    if not dateStr or dateStr == '' then return 'Unknown' end
    local y, m, d = dateStr:match('(%d+)-(%d+)-(%d+)')
    if y and tonumber(y) > 1900 then return ('%02d/%02d/%04d'):format(tonumber(m), tonumber(d), tonumber(y)) end
    local mm, dd, yy = dateStr:match('(%d+)/(%d+)/(%d+)')
    if mm then return ('%02d/%02d/%04d'):format(tonumber(mm), tonumber(dd), tonumber(yy)) end
    return dateStr
end

function bridge.getIdentifier(source)
    local player = QBCore.Functions.GetPlayer(source)
    return player and player.PlayerData.citizenid or nil
end

function bridge.getName(source)
    local player = QBCore.Functions.GetPlayer(source)
    if not player then return GetPlayerName(source) or 'Unknown' end
    local ci = player.PlayerData.charinfo
    return (ci.firstname or '') .. ' ' .. (ci.lastname or '')
end

function bridge.getJob(source)
    local player = QBCore.Functions.GetPlayer(source)
    if not player then return nil end
    local job = player.PlayerData.job
    return {
        name = job.name,
        label = job.label or job.name,
        grade = job.grade.level,
        gradeLabel = job.grade.name or ('Grade ' .. job.grade.level),
        onDuty = job.onduty,
    }
end

function bridge.getPlayer(source)
    return QBCore.Functions.GetPlayer(source)
end

function bridge.getPlayerIdFromIdentifier(identifier)
    local player = QBCore.Functions.GetPlayerByCitizenId(identifier)
    return player and player.PlayerData.source or nil
end

function bridge.hasPermission(source, group)
    if QBCore.Functions.HasPermission(source, group) then return true end
    return IsPlayerAceAllowed(source, 'group.' .. group) or IsPlayerAceAllowed(source, group)
end

function bridge.registerUsableItem(item, cb)
    QBCore.Functions.CreateUseableItem(item, function(source)
        cb(source)
    end)
end

function bridge.setDuty(source, onDuty)
    local player = QBCore.Functions.GetPlayer(source)
    if not player then return false end
    player.Functions.SetJobDuty(onDuty)
    return true
end

function bridge.setCallsign(source, callsign)
    local player = QBCore.Functions.GetPlayer(source)
    if not player then return false end
    player.Functions.SetMetaData('callsign', callsign)
    return true
end

function bridge.getJobsAndGrades()
    local jobs = {}
    for jobName, jobData in pairs(QBCore.Shared.Jobs) do
        if not lib.table.contains(Config.IgnoredJobs, jobName) then
            local grades = {}
            for gradeNum, gradeData in pairs(jobData.grades) do
                grades[#grades + 1] = { label = gradeData.name, value = tonumber(gradeNum) }
            end
            table.sort(grades, function(a, b) return a.value < b.value end)
            jobs[jobName] = { label = jobData.label, name = jobName, grades = grades }
        end
    end
    return jobs
end

function bridge.getJobLabel(jobName)
    if not jobName then return nil end
    local job = QBCore.Shared.Jobs[jobName]
    return job and job.label or jobName
end

function bridge.getJobGradeLabel(jobName, grade)
    if not jobName or not grade then return nil end
    local job = QBCore.Shared.Jobs[jobName]
    if job and job.grades and job.grades[tostring(grade)] then
        return job.grades[tostring(grade)].name
    end
    return 'Grade ' .. tostring(grade)
end

function bridge.searchPlayers(query)
    local results = {}
    local players = MySQL.query.await([[
        SELECT citizenid, charinfo, job FROM players
        WHERE LOWER(CONCAT(
            JSON_UNQUOTE(JSON_EXTRACT(charinfo, '$.firstname')), ' ',
            JSON_UNQUOTE(JSON_EXTRACT(charinfo, '$.lastname'))
        )) LIKE ? OR LOWER(citizenid) LIKE ? LIMIT 10
    ]], { '%' .. query:lower() .. '%', '%' .. query:lower() .. '%' })
    if players then
        for _, p in ipairs(players) do
            local ci = p.charinfo and json.decode(p.charinfo) or {}
            local job = p.job and json.decode(p.job) or {}
            results[#results + 1] = {
                identifier = p.citizenid,
                firstname = ci.firstname or 'Unknown',
                lastname = ci.lastname or 'Unknown',
                name = (ci.firstname or '') .. ' ' .. (ci.lastname or ''),
                dob = convertDate(ci.birthdate),
                phone = ci.phone or 'Unknown',
                gender = ci.gender == 1 and 'female' or 'male',
                job = job.name,
                job_grade = (job.grade and job.grade.level) or 0,
            }
        end
    end
    return results
end

function bridge.searchVehicles(query)
    local results = {}
    local normalized = query:gsub('%s+', ''):upper()
    local vehicles = MySQL.query.await([[
        SELECT plate, vehicle, citizenid FROM player_vehicles
        WHERE UPPER(REPLACE(plate, ' ', '')) LIKE ? LIMIT 10
    ]], { '%' .. normalized .. '%' })
    if vehicles then
        for _, v in ipairs(vehicles) do
            results[#results + 1] = {
                plate = v.plate,
                model = v.vehicle or 'Unknown',
                owner = v.citizenid,
            }
        end
    end
    return results
end

-- live citizens/vehicles from players / player_vehicles

local function mapPlayerRow(p)
    local job = p.job_name
    if job and lib.table.contains(Config.IgnoredJobs, job) then job = Config.IgnoredJobDisplay end
    local gender = (p.gender == '0' and 'male') or (p.gender == '1' and 'female') or 'other'
    return {
        identifier = p.citizenid,
        firstname  = p.firstname or 'Unknown',
        lastname   = p.lastname or 'Unknown',
        name       = ((p.firstname or '') .. ' ' .. (p.lastname or '')):gsub('^%s+', ''),
        dob        = convertDate(p.birthdate),
        phone      = p.phone or 'Unknown',
        gender     = gender,
        job        = job,
        job_grade  = tonumber(p.job_grade) or 0,
    }
end

local PLAYER_SELECT = [[
    citizenid,
    JSON_UNQUOTE(JSON_EXTRACT(charinfo, '$.firstname')) AS firstname,
    JSON_UNQUOTE(JSON_EXTRACT(charinfo, '$.lastname')) AS lastname,
    JSON_UNQUOTE(JSON_EXTRACT(charinfo, '$.birthdate')) AS birthdate,
    JSON_UNQUOTE(JSON_EXTRACT(charinfo, '$.phone')) AS phone,
    JSON_UNQUOTE(JSON_EXTRACT(charinfo, '$.gender')) AS gender,
    JSON_UNQUOTE(JSON_EXTRACT(job, '$.name')) AS job_name,
    JSON_UNQUOTE(JSON_EXTRACT(job, '$.grade.level')) AS job_grade
]]

function bridge.getCitizen(identifier)
    local p = MySQL.single.await(('SELECT %s FROM players WHERE citizenid = ?'):format(PLAYER_SELECT), { identifier })
    return p and mapPlayerRow(p) or nil
end

function bridge.getCitizens(offset, limit, query)
    local where, params = '', {}
    if query and query ~= '' then
        local like = '%' .. query:lower() .. '%'
        where = [[ WHERE LOWER(CONCAT(COALESCE(JSON_UNQUOTE(JSON_EXTRACT(charinfo,'$.firstname')),''),' ',COALESCE(JSON_UNQUOTE(JSON_EXTRACT(charinfo,'$.lastname')),''))) LIKE ?
                     OR LOWER(citizenid) LIKE ?
                     OR LOWER(COALESCE(JSON_UNQUOTE(JSON_EXTRACT(charinfo,'$.phone')),'')) LIKE ? ]]
        params = { like, like, like }
    end
    local total = MySQL.scalar.await('SELECT COUNT(*) FROM players' .. where, params) or 0
    local pageParams = {}
    for i = 1, #params do pageParams[i] = params[i] end
    pageParams[#pageParams + 1] = limit
    pageParams[#pageParams + 1] = offset
    local rows = MySQL.query.await(
        ('SELECT %s FROM players %s ORDER BY firstname, lastname LIMIT ? OFFSET ?'):format(PLAYER_SELECT, where), pageParams) or {}
    local items = {}
    for i = 1, #rows do items[i] = mapPlayerRow(rows[i]) end
    return { items = items, total = total }
end

local VEHICLE_SELECT = [[
    pv.plate AS plate, pv.vehicle AS model, pv.citizenid AS owner_id,
    CONCAT(COALESCE(JSON_UNQUOTE(JSON_EXTRACT(p.charinfo,'$.firstname')),''),' ',COALESCE(JSON_UNQUOTE(JSON_EXTRACT(p.charinfo,'$.lastname')),'')) AS ownerName
]]
local VEHICLE_JOIN = 'FROM player_vehicles pv LEFT JOIN players p ON p.citizenid = pv.citizenid'

local function mapVehicleRow(v)
    local owner = v.ownerName and v.ownerName:gsub('^%s+', ''):gsub('%s+$', '') or ''
    return {
        id           = v.plate,
        plate        = v.plate,
        model        = v.model or 'Unknown',
        vehicle_type = v.vehicle_type or 'car',
        owner_id     = v.owner_id,
        ownerName    = (owner ~= '' and owner) or nil,
    }
end

function bridge.getVehicle(plate)
    plate = plate:gsub('%s+', ''):upper()
    local v = MySQL.single.await(
        ("SELECT %s %s WHERE UPPER(REPLACE(pv.plate,' ','')) = ?"):format(VEHICLE_SELECT, VEHICLE_JOIN), { plate })
    return v and mapVehicleRow(v) or nil
end

function bridge.getVehicles(offset, limit, query)
    local where, params = '', {}
    if query and query ~= '' then
        local like = '%' .. query:lower() .. '%'
        where = [[ WHERE UPPER(REPLACE(pv.plate,' ','')) LIKE ?
                     OR LOWER(pv.vehicle) LIKE ?
                     OR LOWER(CONCAT(COALESCE(JSON_UNQUOTE(JSON_EXTRACT(p.charinfo,'$.firstname')),''),' ',COALESCE(JSON_UNQUOTE(JSON_EXTRACT(p.charinfo,'$.lastname')),''))) LIKE ? ]]
        params = { '%' .. query:gsub('%s+', ''):upper() .. '%', like, like }
    end
    local total = MySQL.scalar.await(('SELECT COUNT(*) %s %s'):format(VEHICLE_JOIN, where), params) or 0
    local pageParams = {}
    for i = 1, #params do pageParams[i] = params[i] end
    pageParams[#pageParams + 1] = limit
    pageParams[#pageParams + 1] = offset
    local rows = MySQL.query.await(
        ('SELECT %s %s %s ORDER BY pv.plate LIMIT ? OFFSET ?'):format(VEHICLE_SELECT, VEHICLE_JOIN, where), pageParams) or {}
    local items = {}
    for i = 1, #rows do items[i] = mapVehicleRow(rows[i]) end
    return { items = items, total = total }
end

function bridge.getVehiclesByOwner(identifier)
    local rows = MySQL.query.await(
        ('SELECT %s %s WHERE pv.citizenid = ? ORDER BY pv.plate'):format(VEHICLE_SELECT, VEHICLE_JOIN), { identifier }) or {}
    local items = {}
    for i = 1, #rows do items[i] = mapVehicleRow(rows[i]) end
    return items
end

Modules.register('bridge', bridge)
