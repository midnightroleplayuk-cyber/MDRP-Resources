if not GetResourceState('es_extended'):find('start') then return end

lib.print.debug('[wasabi_mdt] ESX framework detected, initializing bridge')

local ESX = exports['es_extended']:getSharedObject()

---@type Bridge
local bridge = {}

bridge.framework = 'esx'

local function convertDate(dateStr)
    if not dateStr or dateStr == '' then return 'Unknown' end
    local d, m, y = dateStr:match('(%d+)/(%d+)/(%d+)')
    if d then return ('%02d/%02d/%04d'):format(tonumber(m), tonumber(d), tonumber(y)) end
    local y2, m2, d2 = dateStr:match('(%d+)-(%d+)-(%d+)')
    if y2 then return ('%02d/%02d/%04d'):format(tonumber(m2), tonumber(d2), tonumber(y2)) end
    return dateStr
end

function bridge.getIdentifier(source)
    local xPlayer = ESX.GetPlayerFromId(source)
    return xPlayer and xPlayer.getIdentifier() or nil
end

function bridge.getName(source)
    local xPlayer = ESX.GetPlayerFromId(source)
    if not xPlayer then return GetPlayerName(source) or 'Unknown' end
    return (xPlayer.get('firstName') or '') .. ' ' .. (xPlayer.get('lastName') or '')
end

function bridge.getJob(source)
    local xPlayer = ESX.GetPlayerFromId(source)
    if not xPlayer then return nil end
    local job = xPlayer.getJob()
    return {
        name = job.name,
        label = job.label or job.name,
        grade = job.grade,
        gradeLabel = job.grade_label or job.grade_name or ('Grade ' .. job.grade),
        onDuty = job.onDuty ~= false,
    }
end

function bridge.getPlayer(source)
    return ESX.GetPlayerFromId(source)
end

function bridge.getPlayerIdFromIdentifier(identifier)
    local xPlayer = ESX.GetPlayerFromIdentifier(identifier)
    return xPlayer and xPlayer.source or nil
end

function bridge.hasPermission(source, group)
    return IsPlayerAceAllowed(source, 'group.' .. group) or IsPlayerAceAllowed(source, group)
end

function bridge.registerUsableItem(item, cb)
    ESX.RegisterUsableItem(item, function(source)
        cb(source)
    end)
end

-- esx doesn't expose duty/callsign — mdt tracks its own
function bridge.setDuty(_, _)
    return true
end

function bridge.setCallsign(_, _)
    return true
end

function bridge.getJobsAndGrades()
    local jobs = {}
    for jobName, jobData in pairs(ESX.GetJobs()) do
        if not lib.table.contains(Config.IgnoredJobs, jobName) then
            local grades = {}
            for gradeNum, gradeData in pairs(jobData.grades) do
                grades[#grades + 1] = { label = gradeData.label, value = tonumber(gradeNum) }
            end
            table.sort(grades, function(a, b) return a.value < b.value end)
            jobs[jobName] = { label = jobData.label, name = jobName, grades = grades }
        end
    end
    return jobs
end

function bridge.getJobLabel(jobName)
    if not jobName then return nil end
    local job = ESX.GetJobs()[jobName]
    return job and job.label or jobName
end

function bridge.getJobGradeLabel(jobName, grade)
    if not jobName or not grade then return nil end
    local job = ESX.GetJobs()[jobName]
    if job and job.grades and job.grades[tostring(grade)] then
        return job.grades[tostring(grade)].label
    end
    return 'Grade ' .. tostring(grade)
end

function bridge.searchPlayers(query)
    local results = {}
    local players = MySQL.query.await([[
        SELECT identifier, firstname, lastname, dateofbirth, phone_number, sex, job, job_grade
        FROM users
        WHERE LOWER(CONCAT(firstname, ' ', lastname)) LIKE ?
           OR LOWER(identifier) LIKE ?
        LIMIT 10
    ]], { '%' .. query:lower() .. '%', '%' .. query:lower() .. '%' })
    if players then
        for _, p in ipairs(players) do
            results[#results + 1] = {
                identifier = p.identifier,
                firstname = p.firstname,
                lastname = p.lastname,
                name = (p.firstname or '') .. ' ' .. (p.lastname or ''),
                dob = convertDate(p.dateofbirth),
                phone = p.phone_number or 'Unknown',
                job = p.job,
                job_grade = p.job_grade or 0,
                gender = p.sex == 'm' and 'male' or p.sex == 'f' and 'female' or 'other',
            }
        end
    end
    return results
end

function bridge.searchVehicles(query)
    local results = {}
    local normalized = query:gsub('%s+', ''):upper()
    local vehicles = MySQL.query.await([[
        SELECT plate, vehicle, owner FROM owned_vehicles
        WHERE UPPER(REPLACE(plate, ' ', '')) LIKE ? LIMIT 10
    ]], { '%' .. normalized .. '%' })
    if vehicles then
        for _, v in ipairs(vehicles) do
            local data = v.vehicle and json.decode(v.vehicle) or {}
            results[#results + 1] = {
                plate = v.plate,
                model = (data and data.model) or 'Unknown',
                owner = v.owner,
            }
        end
    end
    return results
end

-- live citizens/vehicles from users / owned_vehicles

local function mapUserRow(u)
    local job = u.job
    if job and lib.table.contains(Config.IgnoredJobs, job) then job = Config.IgnoredJobDisplay end
    return {
        identifier = u.identifier,
        firstname  = u.firstname or 'Unknown',
        lastname   = u.lastname or 'Unknown',
        name       = ((u.firstname or '') .. ' ' .. (u.lastname or '')):gsub('^%s+', ''),
        dob        = convertDate(u.dateofbirth),
        phone      = u.phone_number or 'Unknown',
        gender     = (u.sex == 'm' and 'male') or (u.sex == 'f' and 'female') or 'other',
        job        = job,
        job_grade  = u.job_grade or 0,
    }
end

local USER_SELECT = 'identifier, firstname, lastname, dateofbirth, phone_number, sex, job, job_grade'

function bridge.getCitizen(identifier)
    local u = MySQL.single.await(('SELECT %s FROM users WHERE identifier = ?'):format(USER_SELECT), { identifier })
    return u and mapUserRow(u) or nil
end

function bridge.getCitizens(offset, limit, query)
    local where, params = '', {}
    if query and query ~= '' then
        local like = '%' .. query:lower() .. '%'
        where = [[ WHERE LOWER(CONCAT(COALESCE(firstname,''),' ',COALESCE(lastname,''))) LIKE ?
                     OR LOWER(COALESCE(identifier,'')) LIKE ?
                     OR LOWER(COALESCE(phone_number,'')) LIKE ? ]]
        params = { like, like, like }
    end
    local total = MySQL.scalar.await('SELECT COUNT(*) FROM users' .. where, params) or 0
    local pageParams = {}
    for i = 1, #params do pageParams[i] = params[i] end
    pageParams[#pageParams + 1] = limit
    pageParams[#pageParams + 1] = offset
    local rows = MySQL.query.await(
        ('SELECT %s FROM users %s ORDER BY firstname, lastname LIMIT ? OFFSET ?'):format(USER_SELECT, where), pageParams) or {}
    local items = {}
    for i = 1, #rows do items[i] = mapUserRow(rows[i]) end
    return { items = items, total = total }
end

local VEHICLE_SELECT = [[
    ov.plate AS plate, ov.vehicle AS vehicle, ov.owner AS owner_id, ov.type AS vehicle_type,
    CONCAT(COALESCE(u.firstname,''),' ',COALESCE(u.lastname,'')) AS ownerName
]]
local VEHICLE_JOIN = 'FROM owned_vehicles ov LEFT JOIN users u ON u.identifier = ov.owner'

local function mapVehicleRow(v)
    local data = v.vehicle and json.decode(v.vehicle) or {}
    local owner = v.ownerName and v.ownerName:gsub('^%s+', ''):gsub('%s+$', '') or ''
    return {
        id           = v.plate,
        plate        = v.plate,
        model        = (data and data.model and tostring(data.model)) or 'Unknown',
        vehicle_type = v.vehicle_type or 'car',
        owner_id     = v.owner_id,
        ownerName    = (owner ~= '' and owner) or nil,
    }
end

function bridge.getVehicle(plate)
    plate = plate:gsub('%s+', ''):upper()
    local v = MySQL.single.await(
        ("SELECT %s %s WHERE UPPER(REPLACE(ov.plate,' ','')) = ?"):format(VEHICLE_SELECT, VEHICLE_JOIN), { plate })
    return v and mapVehicleRow(v) or nil
end

function bridge.getVehicles(offset, limit, query)
    local where, params = '', {}
    if query and query ~= '' then
        local like = '%' .. query:lower() .. '%'
        where = [[ WHERE UPPER(REPLACE(ov.plate,' ','')) LIKE ?
                     OR LOWER(CONCAT(COALESCE(u.firstname,''),' ',COALESCE(u.lastname,''))) LIKE ? ]]
        params = { '%' .. query:gsub('%s+', ''):upper() .. '%', like }
    end
    local total = MySQL.scalar.await(('SELECT COUNT(*) %s %s'):format(VEHICLE_JOIN, where), params) or 0
    local pageParams = {}
    for i = 1, #params do pageParams[i] = params[i] end
    pageParams[#pageParams + 1] = limit
    pageParams[#pageParams + 1] = offset
    local rows = MySQL.query.await(
        ('SELECT %s %s %s ORDER BY ov.plate LIMIT ? OFFSET ?'):format(VEHICLE_SELECT, VEHICLE_JOIN, where), pageParams) or {}
    local items = {}
    for i = 1, #rows do items[i] = mapVehicleRow(rows[i]) end
    return { items = items, total = total }
end

function bridge.getVehiclesByOwner(identifier)
    local rows = MySQL.query.await(
        ('SELECT %s %s WHERE ov.owner = ? ORDER BY ov.plate'):format(VEHICLE_SELECT, VEHICLE_JOIN), { identifier }) or {}
    local items = {}
    for i = 1, #rows do items[i] = mapVehicleRow(rows[i]) end
    return items
end

Modules.register('bridge', bridge)
