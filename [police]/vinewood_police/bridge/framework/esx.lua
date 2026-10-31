-- ESX Legacy adapter.
if VPO.Bridge.Name ~= 'esx' then return end

local Bridge, RES = VPO.Bridge, VPO.Bridge.Resource
local ESX = exports[RES]:getSharedObject()

local function player(src)
    if not src then return nil end
    return ESX.GetPlayerFromId(tonumber(src))
end

function Bridge.GetIdentifier(src)
    local x = player(src)
    return x and x.identifier or nil
end

function Bridge.GetSource(identifier)
    if type(identifier) ~= 'string' then return nil end
    local x = ESX.GetPlayerFromIdentifier(identifier)
    return x and x.source or nil
end

function Bridge.GetName(src)
    local x = player(src)
    if not x then return nil end
    local ok, n = pcall(function() return x.getName() end)
    return ok and n or GetPlayerName(src)
end

-- ESX has no duty flag. vinewood_police's own sign-on (drop 2) is the duty state on ESX.
function Bridge.GetJob(src)
    local x = player(src)
    if not x or not x.job then return nil end
    return {
        name = x.job.name,
        label = x.job.label,
        grade = tonumber(x.job.grade) or 0,
        gradeLabel = x.job.grade_label or tostring(x.job.grade),
        onduty = nil,
    }
end

function Bridge.SetFrameworkDuty() end

function Bridge.GetVehicleByPlate(plate)
    local key = tostring(plate or ''):upper():gsub('[^%w]', '')
    if key == '' then return nil end
    local r = MySQL.single.await("SELECT plate, vehicle, owner FROM owned_vehicles WHERE REPLACE(UPPER(plate), ' ', '') = ? LIMIT 1", { key })
    if not r then return nil end
    local ok, v = pcall(json.decode, r.vehicle or '')
    return { plate = r.plate, model = ok and type(v) == 'table' and v.model or nil, owner = r.owner }
end

function Bridge.GetNameByIdentifier(identifier)
    local src = Bridge.GetSource(identifier)
    if src then return Bridge.GetName(src) end
    local r = MySQL.single.await('SELECT firstname, lastname FROM users WHERE identifier = ?', { identifier })
    return r and ((r.firstname or '') .. ' ' .. (r.lastname or '')) or nil
end

function Bridge.IsFrameworkAdmin(src)
    local x = player(src)
    if not x then return false end
    local ok, g = pcall(function() return x.getGroup() end)
    return ok and (g == 'admin' or g == 'superadmin')
end

function Bridge.JobMembers(job)
    local out = {}
    for _, r in ipairs(MySQL.query.await('SELECT identifier, firstname, lastname, job_grade FROM users WHERE job = ?', { job }) or {}) do
        out[#out + 1] = { identifier = r.identifier, name = ((r.firstname or '') .. ' ' .. (r.lastname or '')), grade = tonumber(r.job_grade) or 0 }
    end
    return out
end

function Bridge.SetJob(identifier, job, grade)
    local x = ESX.GetPlayerFromIdentifier(identifier)
    if x then x.setJob(job, grade) return true end
    return (MySQL.update.await('UPDATE users SET job = ?, job_grade = ? WHERE identifier = ?', { job, grade, identifier }) or 0) > 0
end

local function account(a) return (a == 'cash' or a == 'money') and 'money' or 'bank' end

function Bridge.AddMoney(src, acc, amount, reason)
    local x = player(src)
    if not x or not amount or amount <= 0 then return false end
    x.addAccountMoney(account(acc), math.floor(amount), reason)
    return true
end

function Bridge.RemoveMoney(src, acc, amount, reason)
    local x = player(src)
    if not x or not amount or amount <= 0 then return false end
    local a = x.getAccount(account(acc))
    if not a or a.money < amount then return false end
    x.removeAccountMoney(account(acc), math.floor(amount), reason)
    return true
end

AddEventHandler('esx:playerLoaded', function(playerId) Bridge._Loaded(playerId) end)
AddEventHandler('esx:playerLogout', function(playerId) Bridge._Unloaded(playerId) end)
