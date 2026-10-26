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
        local grade = pd.job.grade
        if type(grade) == 'table' then grade = grade.level end
        return {
            cid = pd.citizenid,
            name = ('%s %s'):format(ci.firstname or '', ci.lastname or ''),
            job = pd.job.name, grade = tonumber(grade) or 0,
            onduty = pd.job.onduty ~= false,
        }
    elseif fw == 'esx' then
        local x = ESX.GetPlayerFromId(src); if not x then return nil end
        return {
            cid = x.identifier, name = x.getName(),
            job = x.job.name, grade = tonumber(x.job.grade) or 0, onduty = true,
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
