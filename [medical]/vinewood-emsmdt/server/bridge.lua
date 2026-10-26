Bridge = {}

local fw = Config.Framework
if fw == 'auto' then
    if GetResourceState('qbx_core') == 'started' then fw = 'qbx'
    elseif GetResourceState('qb-core') == 'started' then fw = 'qb'
    elseif GetResourceState('es_extended') == 'started' then fw = 'esx'
    else fw = 'none' end
end
Bridge.Name = fw

local QBCore, ESX
if fw == 'qb' then QBCore = exports['qb-core']:GetCoreObject() end
if fw == 'esx' then ESX = exports.es_extended:getSharedObject() end

local function qbPlayer(src)
    if fw == 'qbx' then return exports.qbx_core:GetPlayer(src) end
    return QBCore.Functions.GetPlayer(src)
end

-- Returns { cid, name, job, grade, onduty } or nil
function Bridge.GetMe(src)
    if fw == 'qbx' or fw == 'qb' then
        local p = qbPlayer(src); if not p then return nil end
        local pd = p.PlayerData
        local ci = pd.charinfo or {}
        local g = pd.job.grade
        local level = type(g) == 'table' and g.level or g
        local gname = type(g) == 'table' and g.name or nil
        return {
            cid = pd.citizenid,
            name = ('%s %s'):format(ci.firstname or '', ci.lastname or ''),
            job = pd.job.name, grade = tonumber(level) or 0,
            gradeLabel = gname, gradeName = gname,
            onduty = pd.job.onduty ~= false,
        }
    elseif fw == 'esx' then
        local x = ESX.GetPlayerFromId(src); if not x then return nil end
        return {
            cid = x.identifier, name = x.getName(),
            job = x.job.name, grade = tonumber(x.job.grade) or 0, onduty = true,
            gradeLabel = x.job.grade_label, gradeName = x.job.grade_name,
        }
    end
    return nil
end

function Bridge.GetSourceByCid(cid)
    for _, id in ipairs(GetPlayers()) do
        local me = Bridge.GetMe(tonumber(id))
        if me and me.cid == cid then return tonumber(id) end
    end
end

local function qbRow(r)
    local ci = r.charinfo and json.decode(r.charinfo) or {}
    return {
        cid = r.citizenid,
        name = ('%s %s'):format(ci.firstname or '', ci.lastname or ''),
        dob = ci.birthdate, sex = (ci.gender == 1 or ci.gender == '1') and 'Female' or 'Male',
        phone = ci.phone,
    }
end

local function esxRow(r)
    return {
        cid = r.identifier,
        name = ('%s %s'):format(r.firstname or '', r.lastname or ''),
        dob = r.dateofbirth, sex = (r.sex == 'f' or r.sex == 'F') and 'Female' or 'Male',
        phone = r.phone_number,
    }
end

-- Case-insensitive search by name or ID
function Bridge.SearchPeople(term)
    term = ('%%%s%%'):format(tostring(term or ''):lower())
    if fw == 'qbx' or fw == 'qb' then
        local rows = MySQL.query.await([[
            SELECT citizenid, charinfo FROM players
            WHERE LOWER(citizenid) LIKE ?
               OR LOWER(CONCAT(JSON_UNQUOTE(JSON_EXTRACT(charinfo,'$.firstname')),' ',JSON_UNQUOTE(JSON_EXTRACT(charinfo,'$.lastname')))) LIKE ?
            LIMIT 25]], { term, term }) or {}
        local out = {}
        for _, r in ipairs(rows) do out[#out + 1] = qbRow(r) end
        return out
    elseif fw == 'esx' then
        local rows = MySQL.query.await([[
            SELECT identifier, firstname, lastname, dateofbirth, sex, phone_number FROM users
            WHERE LOWER(identifier) LIKE ? OR LOWER(CONCAT(firstname,' ',lastname)) LIKE ?
            LIMIT 25]], { term, term }) or {}
        local out = {}
        for _, r in ipairs(rows) do out[#out + 1] = esxRow(r) end
        return out
    end
    return {}
end

function Bridge.GetPerson(cid)
    if fw == 'qbx' or fw == 'qb' then
        local r = MySQL.single.await('SELECT citizenid, charinfo FROM players WHERE citizenid = ?', { cid })
        return r and qbRow(r)
    elseif fw == 'esx' then
        local r = MySQL.single.await('SELECT identifier, firstname, lastname, dateofbirth, sex, phone_number FROM users WHERE identifier = ?', { cid })
        return r and esxRow(r)
    end
end

function Bridge.Notify(src, msg, typ)
    TriggerClientEvent('ox_lib:notify', src, { title = Config.Branding.short, description = msg, type = typ or 'inform' })
end

---------------------------------------------------------------------
-- Inventory
---------------------------------------------------------------------
local function ox() return GetResourceState('ox_inventory') == 'started' end

-- Gives an item. Returns true, or false and a reason.
function Bridge.AddItem(src, item, count, description)
    count = count or 1
    if ox() then
        local meta = description and { description = description } or nil
        if not exports.ox_inventory:CanCarryItem(src, item, count, meta) then return false, 'full' end
        local ok = exports.ox_inventory:AddItem(src, item, count, meta)
        return ok and true or false, ok and nil or 'failed'
    end
    if GetResourceState('qs-inventory') == 'started' then
        local ok = exports['qs-inventory']:AddItem(src, item, count, nil, description and { description = description } or nil)
        return ok and true or false, ok and nil or 'failed'
    end
    if fw == 'qb' or fw == 'qbx' then
        local p = qbPlayer(src); if not p then return false, 'offline' end
        local ok = p.Functions.AddItem(item, count, nil, description and { description = description } or nil)
        if ok and QBCore and QBCore.Shared.Items[item] then
            TriggerClientEvent('inventory:client:ItemBox', src, QBCore.Shared.Items[item], 'add', count)
        end
        return ok and true or false, ok and nil or 'full'
    elseif fw == 'esx' then
        local x = ESX.GetPlayerFromId(src); if not x then return false, 'offline' end
        if x.canCarryItem and not x.canCarryItem(item, count) then return false, 'full' end
        x.addInventoryItem(item, count)
        return true
    end
    return false, 'no inventory'
end

-- Item names that don't exist in the inventory (ox_inventory and qb shared items only).
function Bridge.MissingItems(names)
    local known
    if ox() then
        known = exports.ox_inventory:Items() or {}
    elseif QBCore then
        known = QBCore.Shared.Items or {}
    end
    if not known then return {} end
    local out = {}
    for _, n in ipairs(names) do if not known[n] then out[#out + 1] = n end end
    return out
end

---------------------------------------------------------------------
-- Jobs and grades
---------------------------------------------------------------------
local function jobDef(name)
    if fw == 'qbx' then
        local ok, j = pcall(function() return exports.qbx_core:GetJob(name) end)
        return ok and j or nil
    elseif fw == 'qb' then
        return QBCore.Shared.Jobs and QBCore.Shared.Jobs[name]
    end
end

-- Is this job marked as EMS by the framework (QBCore / Qbox type = 'ems')?
function Bridge.IsEmsJob(name)
    local j = name and jobDef(name)
    return j and j.type == 'ems' or false
end

-- All EMS-type job names known to the framework
function Bridge.EmsJobs()
    local out = {}
    local all
    if fw == 'qbx' then
        local ok, jobs = pcall(function() return exports.qbx_core:GetJobs() end)
        all = ok and jobs or nil
    elseif fw == 'qb' then
        all = QBCore.Shared.Jobs
    end
    for name, j in pairs(all or {}) do if j.type == 'ems' then out[#out + 1] = name end end
    table.sort(out)
    return out
end

-- { { level, name, label } ... } sorted by level
function Bridge.GetJobGrades(name)
    local out = {}
    if fw == 'qbx' or fw == 'qb' then
        local j = jobDef(name)
        for lvl, g in pairs(j and j.grades or {}) do
            out[#out + 1] = { level = tonumber(lvl) or 0, name = g.name, label = g.name }
        end
    elseif fw == 'esx' then
        local rows = MySQL.query.await('SELECT grade, name, label FROM job_grades WHERE job_name = ? ORDER BY grade', { name }) or {}
        for _, r in ipairs(rows) do out[#out + 1] = { level = tonumber(r.grade) or 0, name = r.name, label = r.label } end
    end
    table.sort(out, function(a, b) return a.level < b.level end)
    return out
end

function Bridge.GradeLabel(job, level)
    for _, g in ipairs(Bridge.GetJobGrades(job)) do if g.level == tonumber(level) then return g.label end end
end
