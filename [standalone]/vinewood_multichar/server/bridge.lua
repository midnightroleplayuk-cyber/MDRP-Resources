Bridge = {}

local function started(r) return GetResourceState(r) == 'started' end

local function decode(v)
    if type(v) == 'table' then return v end
    if type(v) ~= 'string' or v == '' then return {} end
    local ok, r = pcall(json.decode, v)
    return (ok and type(r) == 'table') and r or {}
end
Bridge.Decode = decode

local QBX_RES, QBCore, ESX

local function detect()
    if Config.Framework ~= 'auto' then return Config.Framework end
    if started('qbx_core') then return 'qbx' end
    if started('qb-core') then
        -- Qbox renamed to qb-core still exposes GetPlayer as an export, QBCore doesn't
        local ok = pcall(function() return exports['qb-core']:GetPlayer(0) end)
        return ok and 'qbx' or 'qb'
    end
    if started('es_extended') then return 'esx' end
    return 'none'
end

Bridge.Name = detect()

if Bridge.Name == 'qbx' then
    QBX_RES = started('qbx_core') and 'qbx_core' or 'qb-core'
elseif Bridge.Name == 'qb' then
    QBCore = exports['qb-core']:GetCoreObject()
elseif Bridge.Name == 'esx' then
    ESX = exports.es_extended:getSharedObject()
end

print(('^2[vinewood_multichar]^7 framework: ^5%s^7'):format(Bridge.Name))

-- Identifiers -------------------------------------------------------------------
function Bridge.GetIdentifiers(src)
    local list = {}
    for _, id in ipairs(GetPlayerIdentifiers(src)) do list[#list + 1] = id end
    return list
end

function Bridge.GetLicense(src)
    return GetPlayerIdentifierByType(src, 'license') or GetPlayerIdentifierByType(src, 'license2')
end

function Bridge.GetDiscord(src)
    local d = GetPlayerIdentifierByType(src, 'discord')
    return d and d:gsub('discord:', '') or nil
end

local function esxLicense(src)
    local l = GetPlayerIdentifierByType(src, 'license')
    return l and l:gsub('license:', '') or ''
end

-- Characters ----------------------------------------------------------------------
local function qbStyleCharacters(src)
    local l2 = GetPlayerIdentifierByType(src, 'license2') or '-'
    local l = GetPlayerIdentifierByType(src, 'license') or '-'
    local rows = MySQL.query.await('SELECT * FROM players WHERE license = ? OR license = ? ORDER BY cid ASC', { l2, l }) or {}
    local chars, ids = {}, {}
    for _, r in ipairs(rows) do
        local ci, money, job, gang = decode(r.charinfo), decode(r.money), decode(r.job), decode(r.gang)
        chars[#chars + 1] = {
            gang = gang.name ~= 'none' and (gang.label or gang.name) or nil,
            gangRank = type(gang.grade) == 'table' and gang.grade.name or nil,
            id = r.citizenid,
            slot = tonumber(r.cid) or 0,
            firstname = ci.firstname or 'Unknown',
            lastname = ci.lastname or '',
            dob = ci.birthdate,
            gender = tonumber(ci.gender) == 1 and 'female' or 'male',
            nationality = ci.nationality,
            phone = ci.phone,
            job = job.label or job.name or 'Unemployed',
            grade = type(job.grade) == 'table' and job.grade.name or nil,
            cash = tonumber(money.cash) or 0,
            bank = tonumber(money.bank) or 0,
            lastPlayed = r.last_updated or r.last_logged_out,
            position = decode(r.position),
        }
        ids[#ids + 1] = r.citizenid
    end
    return chars
end

local function esxCharacters(src)
    local rows = MySQL.query.await('SELECT * FROM users WHERE identifier LIKE ?', { 'char%:' .. esxLicense(src) }) or {}
    local jobs = {}
    pcall(function() jobs = ESX.GetJobs() or {} end)
    local chars = {}
    for _, r in ipairs(rows) do
        local slot = tonumber((r.identifier or ''):match('^char(%d+):')) or 0
        local acc = decode(r.accounts)
        local job = jobs[r.job or ''] or {}
        local grade = job.grades and job.grades[tostring(r.job_grade)] or {}
        local skin = decode(r.skin)
        chars[#chars + 1] = {
            id = r.identifier,
            slot = slot,
            firstname = r.firstname or 'Unknown',
            lastname = r.lastname or '',
            dob = r.dateofbirth,
            gender = r.sex == 'f' and 'female' or 'male',
            nationality = r.nationality,
            phone = r.phone_number,
            job = job.label or r.job or 'Unemployed',
            grade = grade.label,
            cash = tonumber(acc.money) or 0,
            bank = tonumber(acc.bank) or 0,
            lastPlayed = r.last_seen or r.updated_at,
            position = decode(r.position),
            skin = skin, -- users.skin: skinchanger, illenium, fivem-appearance or op-clothing format
        }
    end
    table.sort(chars, function(a, b) return a.slot < b.slot end)
    return chars
end

function Bridge.GetCharacters(src)
    local list
    if Bridge.Name == 'esx' then list = esxCharacters(src) else list = qbStyleCharacters(src) end

    -- Normalise slots: no zeros, no duplicates
    local used = {}
    for _, c in ipairs(list) do
        if c.slot < 1 or used[c.slot] then c.slot = nil else used[c.slot] = true end
    end
    for _, c in ipairs(list) do
        if not c.slot then
            local n = 1
            while used[n] do n = n + 1 end
            c.slot = n
            used[n] = true
        end
    end
    table.sort(list, function(a, b) return a.slot < b.slot end)
    Clothing.Attach(list)
    Gangs.Attach(list)
    return list
end

function Bridge.OwnsCharacter(src, id)
    for _, c in ipairs(Bridge.GetCharacters(src)) do
        if c.id == id then return c end
    end
    return nil
end

-- Login / create / delete -------------------------------------------------------
local function waitFor(fn, timeout)
    local t = GetGameTimer() + (timeout or 10000)
    while GetGameTimer() < t do
        local r = fn()
        if r then return r end
        Wait(50)
    end
    return nil
end

function Bridge.Login(src, id)
    if Bridge.Name == 'qbx' then
        return exports[QBX_RES]:Login(src, id) and true or false
    elseif Bridge.Name == 'qb' then
        local ok = QBCore.Player.Login(src, id)
        if ok then QBCore.Commands.Refresh(src) end
        return ok and true or false
    elseif Bridge.Name == 'esx' then
        local slot = tonumber(id:match('^char(%d+):'))
        if not slot then return false end
        TriggerEvent('esx:onPlayerJoined', src, 'char' .. slot)
        return waitFor(function() return ESX.GetPlayerFromId(src) end) and true or false
    end
    return false
end

-- data: firstname, lastname, dob (YYYY-MM-DD), gender ('male'/'female'), nationality
function Bridge.CreateCharacter(src, slot, data)
    if Bridge.Name == 'qbx' or Bridge.Name == 'qb' then
        local newData = {
            cid = slot,
            charinfo = {
                firstname = data.firstname,
                lastname = data.lastname,
                birthdate = data.dob,
                gender = data.gender == 'female' and 1 or 0,
                nationality = data.nationality,
            },
        }
        local ok
        if Bridge.Name == 'qbx' then
            ok = exports[QBX_RES]:Login(src, nil, newData)
        else
            ok = QBCore.Player.Login(src, false, newData)
            if ok then QBCore.Commands.Refresh(src) end
        end
        if not ok then return false end
        local cid
        if Bridge.Name == 'qbx' then
            local p = exports[QBX_RES]:GetPlayer(src)
            cid = p and p.PlayerData.citizenid
        else
            local p = QBCore.Functions.GetPlayer(src)
            cid = p and p.PlayerData.citizenid
        end
        return true, cid
    elseif Bridge.Name == 'esx' then
        local y, m, d = data.dob:match('^(%d+)-(%d+)-(%d+)$')
        TriggerEvent('esx:onPlayerJoined', src, 'char' .. slot, {
            firstname = data.firstname,
            lastname = data.lastname,
            dateofbirth = ('%s/%s/%s'):format(d, m, y),
            sex = data.gender == 'female' and 'f' or 'm',
            height = 180,
        })
        local xPlayer = waitFor(function() return ESX.GetPlayerFromId(src) end)
        return xPlayer and true or false, xPlayer and xPlayer.identifier
    end
    return false
end

function Bridge.DeleteCharacter(src, id)
    if Bridge.Name == 'qbx' then
        local ok = pcall(function() exports[QBX_RES]:DeleteCharacter(src, id) end)
        if not ok then ok = pcall(function() exports[QBX_RES]:ForceDeleteCharacter(id) end) end
        if not ok then
            MySQL.query.await('DELETE FROM players WHERE citizenid = ?', { id })
            pcall(MySQL.query.await, 'DELETE FROM playerskins WHERE citizenid = ?', { id })
        end
        return true
    elseif Bridge.Name == 'qb' then
        QBCore.Player.DeleteCharacter(src, id)
        return true
    elseif Bridge.Name == 'esx' then
        MySQL.query.await('DELETE FROM users WHERE identifier = ?', { id })
        pcall(MySQL.query.await, 'DELETE FROM owned_vehicles WHERE owner = ?', { id })
        pcall(MySQL.query.await, 'DELETE FROM user_licenses WHERE owner = ?', { id })
        return true
    end
    return false
end

function Bridge.Logout(src)
    if Bridge.Name == 'qbx' then
        exports[QBX_RES]:Logout(src)
    elseif Bridge.Name == 'qb' then
        QBCore.Player.Logout(src)
    elseif Bridge.Name == 'esx' then
        local done = false
        TriggerEvent('esx:playerLogout', src, function() done = true end)
        local t = GetGameTimer() + 3000
        while not done and GetGameTimer() < t do Wait(50) end
    end
end

function Bridge.IsLoggedIn(src)
    if Bridge.Name == 'qbx' then return exports[QBX_RES]:GetPlayer(src) ~= nil end
    if Bridge.Name == 'qb' then return QBCore.Functions.GetPlayer(src) ~= nil end
    if Bridge.Name == 'esx' then return ESX.GetPlayerFromId(src) ~= nil end
    return false
end

function Bridge.GiveStarterItems(src)
    if #Config.StarterItems == 0 or not started('ox_inventory') then return end
    for _, item in ipairs(Config.StarterItems) do
        exports.ox_inventory:AddItem(src, item.name, item.count or 1, item.metadata)
    end
end
