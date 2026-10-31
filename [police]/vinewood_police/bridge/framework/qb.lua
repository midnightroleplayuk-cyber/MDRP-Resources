-- Qbox and QBCore share a player object, so one adapter covers both.
local name = VPO.Bridge.Name
if name ~= 'qbox' and name ~= 'qbcore' then return end

local Bridge, RES = VPO.Bridge, VPO.Bridge.Resource
local getPlayer, getByCid

if name == 'qbox' then
    getPlayer = function(src) return exports[RES]:GetPlayer(src) end
    getByCid = function(cid) return exports[RES]:GetPlayerByCitizenId(cid) end
else
    local QBCore = exports[RES]:GetCoreObject()
    getPlayer = function(src) return QBCore.Functions.GetPlayer(src) end
    getByCid = function(cid) return QBCore.Functions.GetPlayerByCitizenId(cid) end
end

local function player(src)
    if not src then return nil end
    local ok, p = pcall(getPlayer, tonumber(src))
    return ok and p or nil
end

function Bridge.GetIdentifier(src)
    local p = player(src)
    return p and p.PlayerData and p.PlayerData.citizenid or nil
end

function Bridge.GetSource(identifier)
    if type(identifier) ~= 'string' then return nil end
    local ok, p = pcall(getByCid, identifier)
    return ok and p and p.PlayerData and p.PlayerData.source or nil
end

function Bridge.GetName(src)
    local p = player(src)
    if not p then return nil end
    local c = p.PlayerData.charinfo or {}
    local n = ((c.firstname or '') .. ' ' .. (c.lastname or '')):gsub('^%s+', ''):gsub('%s+$', '')
    return n ~= '' and n or GetPlayerName(src)
end

function Bridge.GetJob(src)
    local p = player(src)
    if not p then return nil end
    local j = p.PlayerData.job or {}
    local grade = type(j.grade) == 'table' and (tonumber(j.grade.level) or 0) or (tonumber(j.grade) or 0)
    return {
        name = j.name,
        label = j.label,
        grade = grade,
        gradeLabel = type(j.grade) == 'table' and j.grade.name or tostring(grade),
        onduty = j.onduty == true,
    }
end

function Bridge.SetFrameworkDuty(src, on)
    local p = player(src)
    if p and p.Functions and p.Functions.SetJobDuty then
        pcall(p.Functions.SetJobDuty, on and true or false)
    end
end

--- metadata.callsign, which qb-style scripts read. Only used when vinewood-dispatch isn't running
--- (it writes the same field itself).
function Bridge.SetCallsignMetadata(src, callsign)
    local value = callsign or 'NO CALLSIGN'
    if name == 'qbox' then
        pcall(function() exports[RES]:SetMetadata(src, 'callsign', value) end)
    else
        local p = player(src)
        if p and p.Functions and p.Functions.SetMetaData then pcall(p.Functions.SetMetaData, 'callsign', value) end
    end
end

--- Registered vehicle by plate: { plate, model, owner } or nil.
function Bridge.GetVehicleByPlate(plate)
    local key = tostring(plate or ''):upper():gsub('[^%w]', '')
    if key == '' then return nil end
    local r = MySQL.single.await("SELECT plate, vehicle, citizenid FROM player_vehicles WHERE REPLACE(UPPER(plate), ' ', '') = ? LIMIT 1", { key })
    return r and { plate = r.plate, model = r.vehicle, owner = r.citizenid } or nil
end

--- Character name by identifier, online or not.
function Bridge.GetNameByIdentifier(identifier)
    local src = Bridge.GetSource(identifier)
    if src then return Bridge.GetName(src) end
    local raw = MySQL.scalar.await('SELECT charinfo FROM players WHERE citizenid = ?', { identifier })
    local ok, c = pcall(json.decode, raw or '')
    if ok and type(c) == 'table' then return ((c.firstname or '') .. ' ' .. (c.lastname or '')):gsub('^%s+', ''):gsub('%s+$', '') end
    return nil
end

function Bridge.IsFrameworkAdmin(src)
    if name == 'qbox' then
        -- Qbox uses aces for admins (covered by Config.AdminAce)
        return false
    end
    local ok, yes = pcall(function()
        local QBCore = exports[RES]:GetCoreObject()
        return QBCore.Functions.HasPermission(src, 'admin') or QBCore.Functions.HasPermission(src, 'god')
    end)
    return ok and yes == true
end

local function nameFromCharinfo(raw)
    local ok, c = pcall(json.decode, raw or '')
    if ok and type(c) == 'table' then return ((c.firstname or '') .. ' ' .. (c.lastname or '')):gsub('^%s+', ''):gsub('%s+$', '') end
    return nil
end

--- Everyone with this job, online or not.
function Bridge.JobMembers(job)
    local out = {}
    if name == 'qbox' then
        for _, r in ipairs(MySQL.query.await([[SELECT pg.citizenid, pg.grade, p.charinfo FROM player_groups pg
            LEFT JOIN players p ON p.citizenid = pg.citizenid WHERE pg.type = 'job' AND pg.`group` = ?]], { job }) or {}) do
            out[#out + 1] = { identifier = r.citizenid, name = (nameFromCharinfo(r.charinfo)), grade = tonumber(r.grade) or 0 }
        end
        return out
    end
    for _, r in ipairs(MySQL.query.await('SELECT citizenid, charinfo, job FROM players WHERE job LIKE ?', { '%"name":"' .. job .. '"%' }) or {}) do
        local ok, j = pcall(json.decode, r.job or '')
        if ok and type(j) == 'table' and j.name == job then
            local g = type(j.grade) == 'table' and tonumber(j.grade.level) or tonumber(j.grade) or 0
            out[#out + 1] = { identifier = r.citizenid, name = (nameFromCharinfo(r.charinfo)), grade = g }
        end
    end
    return out
end

--- Sets someone's job and grade, online or offline. Dismissal: job = Config.Management.UnemployedJob.
function Bridge.SetJob(identifier, job, grade, fromJob)
    local unemployed = job == Config.Management.UnemployedJob
    if name == 'qbox' then
        local ok, err
        if unemployed then
            ok, err = pcall(function() return exports[RES]:RemovePlayerFromJob(identifier, fromJob) end)
        else
            ok, err = pcall(function()
                exports[RES]:AddPlayerToJob(identifier, job, grade)
                exports[RES]:SetPlayerPrimaryJob(identifier, job)
            end)
        end
        if not ok then VPO.Log.error('Qbox job change failed: %s', tostring(err)) end
        return ok
    end
    local src = Bridge.GetSource(identifier)
    local p = src and player(src)
    if p then return p.Functions.SetJob(job, grade) ~= false end
    -- Offline QBCore: write the job straight to the players table
    local QBCore = exports[RES]:GetCoreObject()
    local j = QBCore.Shared.Jobs[job]
    if not j then return false end
    local g = j.grades[tostring(grade)] or j.grades[grade] or {}
    local data = { name = job, label = j.label, payment = g.payment or 0, onduty = false, isboss = g.isboss or false, type = j.type,
        grade = { name = g.name or tostring(grade), level = grade } }
    return (MySQL.update.await('UPDATE players SET job = ? WHERE citizenid = ?', { json.encode(data), identifier }) or 0) > 0
end

local function account(a) return (a == 'cash' or a == 'money') and 'cash' or 'bank' end

function Bridge.AddMoney(src, acc, amount, reason)
    local p = player(src)
    if not p or not amount or amount <= 0 then return false end
    return p.Functions.AddMoney(account(acc), math.floor(amount), reason or 'vinewood_police') ~= false
end

function Bridge.RemoveMoney(src, acc, amount, reason)
    local p = player(src)
    if not p or not amount or amount <= 0 then return false end
    return p.Functions.RemoveMoney(account(acc), math.floor(amount), reason or 'vinewood_police') ~= false
end

AddEventHandler('QBCore:Server:PlayerLoaded', function(p)
    local src = p and p.PlayerData and p.PlayerData.source
    if src then Bridge._Loaded(src) end
end)

AddEventHandler('QBCore:Server:OnPlayerUnload', function(src)
    Bridge._Unloaded(src)
end)
