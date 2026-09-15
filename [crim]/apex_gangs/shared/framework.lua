--[[
    Apex Gangs — Framework bridge (ESX Legacy / QBCore / QBox)
    ────────────────────────────────────────────────────────────
    Auto-detects the running framework and exposes a single, stable
    API the rest of the resource uses. EVERY framework export goes
    through Framework.CallExport (GetResourceState gate + pcall) so a
    missing/renamed/stopped export degrades to nil instead of raising
    a hard Lua error (this is what made naive `exports.x.y` checks
    crash on modern QBox).
]]

Framework = Framework or {}

local detected = (Config and Config.framework) or 'auto'
local function present(name) return GetResourceState(name) == 'started' end

local function detectFramework()
    if detected ~= 'auto' then return detected end
    if present('qbx_core')      then return 'qbx'
    elseif present('qb-core')   then return 'qb'
    elseif present('es_extended') then return 'esx'
    end
    return nil
end

local function applyFramework(name)
    Framework.Name  = name
    Framework.IsESX = name == 'esx'
    Framework.IsQB  = name == 'qb'
    Framework.IsQBX = name == 'qbx'
end
applyFramework(detectFramework() or 'esx')

-- ─── Safe export invocation (the single most important helper) ──
function Framework.CallExport(resource, method, ...)
    if GetResourceState(resource) ~= 'started' then return nil end
    local n, packed = select('#', ...), { ... }
    local ok, res = pcall(function()
        local r = exports[resource]
        local fn = r and r[method]
        if type(fn) ~= 'function' then return nil end
        return fn(r, table.unpack(packed, 1, n))
    end)
    if ok then return res end
    return nil
end

-- ─── Lazy core handles ────────────────────────────────────
local ESX, QBCore
local function resolveCore()
    if Framework.IsESX then
        if not ESX then
            ESX = Framework.CallExport('es_extended', 'getSharedObject') or _G.ESX
            if not ESX then pcall(function() TriggerEvent('esx:getSharedObject', function(o) ESX = o end) end) end
        end
        return
    end
    if QBCore then return end
    QBCore = Framework.CallExport('qbx_core', 'GetCoreObject')
          or Framework.CallExport('qb-core', 'GetCoreObject')
          or _G.QBCore
end
resolveCore()

-- ─── Self-healing detection (start-order independent) ─────
if detected == 'auto' then
    CreateThread(function()
        local tries = 0
        while tries < 120 do
            local real = detectFramework()
            if real then
                if real ~= Framework.Name then applyFramework(real); ESX, QBCore = nil, nil end
                resolveCore()
                if not Framework.IsESX or ESX then return end
            end
            tries = tries + 1
            Wait(500)
        end
    end)
end

-- ════════════════════════════════════════════════════════════
-- SERVER-ONLY player helpers
-- ════════════════════════════════════════════════════════════
if IsDuplicityVersion() then

    local function getESXPlayer(src) resolveCore(); return ESX and ESX.GetPlayerFromId(src) end
    local function getQBPlayer(src)
        resolveCore()
        if QBCore and QBCore.Functions and QBCore.Functions.GetPlayer then
            local p = QBCore.Functions.GetPlayer(src); if p then return p end
        end
        if Framework.IsQBX then
            local p = Framework.CallExport('qbx_core', 'GetPlayer', src); if p then return p end
        end
        return nil
    end
    Framework.GetESXPlayer = getESXPlayer
    Framework.GetQBPlayer  = getQBPlayer

    function Framework.PlayerIdentifier(src)
        if Framework.IsESX then
            local p = getESXPlayer(src); return p and p.identifier or nil
        else
            local p = getQBPlayer(src); return p and p.PlayerData and p.PlayerData.citizenid or nil
        end
    end

    function Framework.GetPlayerName(src)
        if Framework.IsESX then
            local p = getESXPlayer(src)
            return p and (p.getName and p.getName() or p.name) or ('Player ' .. tostring(src))
        else
            local p = getQBPlayer(src)
            if p and p.PlayerData and p.PlayerData.charinfo then
                return ('%s %s'):format(p.PlayerData.charinfo.firstname, p.PlayerData.charinfo.lastname)
            end
        end
        return GetPlayerName(src) or ('Player ' .. tostring(src))
    end

    -- ── Money (player wallet) ──
    function Framework.GetPlayerCash(src)
        if Framework.IsESX then
            local p = getESXPlayer(src); if not p then return 0 end
            if p.getMoney then local ok, v = pcall(function() return p.getMoney() end); if ok and type(v) == 'number' then return v end end
            if p.getAccount then local ok, acc = pcall(function() return p.getAccount('money') end); if ok and type(acc) == 'table' then return tonumber(acc.money) or 0 end end
            if type(p.accounts) == 'table' then for _, acc in pairs(p.accounts) do if acc.name == 'money' then return tonumber(acc.money) or 0 end end end
            return 0
        else
            local p = getQBPlayer(src); if not p or not p.PlayerData then return 0 end
            return (p.PlayerData.money and p.PlayerData.money.cash) or 0
        end
    end

    function Framework.AddPlayerCash(src, amount)
        amount = math.floor(tonumber(amount) or 0); if amount <= 0 then return false end
        if Framework.IsESX then
            local p = getESXPlayer(src); if not p then return false end
            if p.getMoney and p.setMoney then local ok = pcall(function() p.setMoney((tonumber(p.getMoney()) or 0) + amount) end); if ok then return true end end
            if p.addMoney then local ok = pcall(function() p.addMoney(amount, 'apex_gangs') end); if ok then return true end end
            if p.addAccountMoney then local ok = pcall(function() p.addAccountMoney('money', amount, 'apex_gangs') end); if ok then return true end end
            return false
        else
            local p = getQBPlayer(src); if not p then return false end
            if p.Functions and p.Functions.AddMoney then return p.Functions.AddMoney('cash', amount, 'apex_gangs') and true or false end
            if Framework.IsQBX then local r = Framework.CallExport('qbx_core', 'AddMoney', src, 'cash', amount, 'apex_gangs'); if r ~= nil then return r ~= false end end
            return false
        end
    end

    function Framework.RemovePlayerCash(src, amount)
        amount = math.floor(tonumber(amount) or 0); if amount <= 0 then return false end
        local cur = Framework.GetPlayerCash(src); if cur < amount then return false end
        if Framework.IsESX then
            local p = getESXPlayer(src); if not p then return false end
            if p.getMoney and p.setMoney then
                local ok, removed = pcall(function()
                    local cur = tonumber(p.getMoney()) or 0
                    if cur < amount then return false end
                    p.setMoney(cur - amount); return true
                end)
                if ok and removed then return true end
            end
            if p.removeMoney then local ok = pcall(function() p.removeMoney(amount, 'apex_gangs') end); if ok then return true end end
            if p.removeAccountMoney then local ok = pcall(function() p.removeAccountMoney('money', amount, 'apex_gangs') end); if ok then return true end end
            return false
        else
            local p = getQBPlayer(src); if not p then return false end
            if p.Functions and p.Functions.RemoveMoney then return p.Functions.RemoveMoney('cash', amount, 'apex_gangs') and true or false end
            if Framework.IsQBX then local r = Framework.CallExport('qbx_core', 'RemoveMoney', src, 'cash', amount, 'apex_gangs'); if r ~= nil then return r ~= false end end
            return false
        end
    end

    -- ── Items ──
    function Framework.GetItemCount(src, item)
        if GetResourceState('ox_inventory') == 'started' then return exports.ox_inventory:GetItemCount(src, item) or 0 end
        if Framework.IsESX then
            local p = getESXPlayer(src); if not p then return 0 end
            local it = p.getInventoryItem and p.getInventoryItem(item); return it and (it.count or it.amount) or 0
        else
            local p = getQBPlayer(src); if not p then return 0 end
            local fn = p.Functions and p.Functions.GetItemByName
            local it = fn and fn(item); return it and it.amount or 0
        end
    end
    function Framework.AddItem(src, item, count, meta)
        count = count or 1
        if GetResourceState('ox_inventory') == 'started' then return exports.ox_inventory:AddItem(src, item, count, meta) ~= false end
        if Framework.IsESX then
            local p = getESXPlayer(src); if not p or not p.addInventoryItem then return false end
            local ok = pcall(function() p.addInventoryItem(item, count) end); return ok
        else
            local p = getQBPlayer(src); if not p then return false end
            local fn = p.Functions and p.Functions.AddItem; if not fn then return false end
            local res = fn(item, count, false, meta); return res ~= false and res ~= nil
        end
    end
    function Framework.RemoveItem(src, item, count)
        count = count or 1
        if GetResourceState('ox_inventory') == 'started' then return exports.ox_inventory:RemoveItem(src, item, count) ~= false end
        if Framework.IsESX then
            local p = getESXPlayer(src); if not p or not p.removeInventoryItem then return false end
            local ok = pcall(function() p.removeInventoryItem(item, count) end); return ok
        else
            local p = getQBPlayer(src); if not p then return false end
            local fn = p.Functions and p.Functions.RemoveItem; if not fn then return false end
            local res = fn(item, count); return res ~= false and res ~= nil
        end
    end

    -- ── Job (read) ──
    function Framework.GetPlayerJob(src)
        if Framework.IsESX then
            local p = getESXPlayer(src); if not p then return nil end
            local g = p.job and p.job.grade or 0
            return { job = p.job and p.job.name or 'unemployed', label = p.job and p.job.label or 'Unemployed',
                     grade = tonumber(g) or 0, gradeLabel = p.job and p.job.grade_label or ('Grade '..tostring(g)) }
        else
            local p = getQBPlayer(src); if not p or not p.PlayerData then return nil end
            local j = p.PlayerData.job or {}; local grade = j.grade or {}
            return { job = j.name, label = j.label, grade = tonumber(grade.level) or 0,
                     gradeLabel = grade.name or '', isBoss = (j.isboss == true) or (grade.isboss == true) }
        end
    end

    -- ── GANG (read) ──
    -- Returns { gang, label, grade } based on Config.gangStore.
    -- 'native' reads QB/QBX p.PlayerData.gang; ESX falls back to 'job'.
    function Framework.GetPlayerGangRaw(src)
        local store = (Config and Config.gangStore) or 'native'
        if store == 'native' and (Framework.IsQB or Framework.IsQBX) then
            local p = getQBPlayer(src); if not p or not p.PlayerData then return nil end
            local g = p.PlayerData.gang
            if g and g.name and g.name ~= 'none' and g.name ~= '' then
                local grade = g.grade or {}
                return { gang = g.name, label = g.label or g.name, grade = tonumber(grade.level) or 0 }
            end
            return nil
        end
        -- ESX has no native gang system → a gang IS a job (and the creator's
        -- owner dropdown lists jobs). 'job' mode does the same on any framework.
        if store == 'job' or (store == 'native' and Framework.IsESX) then
            local j = Framework.GetPlayerJob(src)
            if j and j.job and j.job ~= 'unemployed' and j.job ~= '' then
                return { gang = j.job, label = j.label, grade = j.grade }
            end
        end
        -- 'standalone' resolves from apex_gangs_members (in Apex.getGang)
        return nil
    end

    -- ── Job (write) ──
    function Framework.SetPlayerJob(src, job, grade)
        grade = tonumber(grade) or 0
        if Framework.IsESX then
            local p = getESXPlayer(src); if not p then return false end
            p.setJob(job, grade); return true
        else
            if Framework.IsQBX then local r = Framework.CallExport('qbx_core', 'SetJob', src, job, grade); if r ~= nil then return r ~= false end end
            local p = getQBPlayer(src); if not p then return false end
            if p.Functions and p.Functions.SetJob then return p.Functions.SetJob(job, grade) and true or false end
            return false
        end
    end

    -- ── GANG (write, online) ──
    function Framework.SetPlayerGang(src, gang, grade)
        grade = tonumber(grade) or 0
        local store = (Config and Config.gangStore) or 'native'
        if (Framework.IsQB or Framework.IsQBX) and store == 'native' then
            if Framework.IsQBX then local r = Framework.CallExport('qbx_core', 'SetGang', src, gang, grade); if r ~= nil then return r ~= false end end
            local p = getQBPlayer(src); if not p then return false end
            if p.Functions and p.Functions.SetGang then return p.Functions.SetGang(gang, grade) and true or false end
            return false
        end
        if store == 'job' or (store == 'native' and Framework.IsESX) then return Framework.SetPlayerJob(src, gang, grade) end
        -- standalone: membership lives purely in the apex_gangs DB.
        return true
    end

    -- ── GANG (write, offline / DB) ──
    function Framework.SetGangOffline(identifier, gang, grade)
        if not identifier then return false end
        grade = tonumber(grade) or 0
        local store = (Config and Config.gangStore) or 'native'
        if (Framework.IsQB or Framework.IsQBX) and store == 'native' then
            local ok = pcall(function()
                local row = MySQL.query.await('SELECT gang FROM players WHERE citizenid = ?', { identifier })
                local def = (Framework.GetSharedGangs() or {})[gang]
                local gradeLabel = ('Grade %d'):format(grade)
                if def then for _, g in ipairs(def.grades or {}) do if g.grade == grade then gradeLabel = g.label or gradeLabel end end end
                local newGang = { name = gang, label = (def and def.label) or gang, isboss = false, grade = { name = gradeLabel, level = grade } }
                if gang == 'none' then newGang = { name = 'none', label = 'No Gang', isboss = false, grade = { name = 'none', level = 0 } } end
                MySQL.query.await('UPDATE players SET gang = ? WHERE citizenid = ?', { json.encode(newGang), identifier })
            end)
            return ok
        end
        -- 'job' mode (and ESX, which has no native gangs) persists to users.job.
        if store == 'job' or (store == 'native' and Framework.IsESX) then
            if Framework.IsESX then
                return pcall(function() MySQL.query.await('UPDATE users SET job = ?, job_grade = ? WHERE identifier = ?', { gang, grade, identifier }) end)
            end
            return true
        end
        -- standalone → membership lives in apex_gangs_members only.
        return true
    end

    -- ── Shared gang/job definitions (for the creator owner dropdown etc.) ──
    -- ESX → returns the JOBS table (gangs are jobs on ESX). QB/QBX native →
    -- returns the gangs table. The creator merges these with apex-created gangs.
    function Framework.GetSharedGangs()
        resolveCore()
        local out = {}
        if Framework.IsESX and ESX then
            local jobs = (ESX.GetJobs and ESX.GetJobs()) or {}
            for name, j in pairs(jobs) do
                local grades = {}
                for gid, g in pairs(j.grades or {}) do
                    grades[#grades+1] = { grade = tonumber(gid) or 0, label = g.label or g.name or ('Grade '..tostring(gid)), isLeader = (tonumber(gid) or 0) >= ((Config.gangs and Config.gangs.defaultLeaderGradeMin) or 4) }
                end
                table.sort(grades, function(a,b) return a.grade < b.grade end)
                out[name] = { name = name, label = j.label or name, grades = grades }
            end
        elseif (Framework.IsQB or Framework.IsQBX) and (Config.gangStore == 'native') then
            local gangs = QBCore and QBCore.Shared and QBCore.Shared.Gangs
            if (not gangs or next(gangs) == nil) and Framework.IsQBX then
                local g = Framework.CallExport('qbx_core', 'GetGangs'); if type(g) == 'table' then gangs = g end
            end
            for name, j in pairs(gangs or {}) do
                local grades = {}
                for gid, g in pairs(j.grades or {}) do
                    grades[#grades+1] = { grade = tonumber(gid) or 0, label = g.name or g.label or ('Grade '..tostring(gid)), isLeader = g.isboss == true }
                end
                table.sort(grades, function(a,b) return a.grade < b.grade end)
                out[name] = { name = name, label = j.label or name, grades = grades }
            end
        end
        return out
    end
    Framework.GetSharedJobs = Framework.GetSharedGangs

    -- ── Vehicle ownership (framework owned_vehicles / player_vehicles) ──
    -- True if `plate` is a PERSONAL vehicle owned by this player. Lets gangs
    -- accept only members' own cars into the shared garage (anti-theft).
    function Framework.PlayerOwnsVehicle(src, plate)
        if not plate or plate == '' then return false end
        local id = Framework.PlayerIdentifier(src); if not id then return false end
        local bare = (tostring(plate):gsub('%s+', ''))
        local ok, res = pcall(function()
            if Framework.IsESX then
                return MySQL.scalar.await("SELECT 1 FROM owned_vehicles WHERE owner = ? AND REPLACE(plate,' ','') = ? LIMIT 1", { id, bare })
            else
                return MySQL.scalar.await("SELECT 1 FROM player_vehicles WHERE citizenid = ? AND REPLACE(plate,' ','') = ? LIMIT 1", { id, bare })
            end
        end)
        return ok and res ~= nil
    end

    -- ── Online roster + offline directory ──
    function Framework.FindSrcByIdentifier(identifier)
        for _, id in ipairs(GetPlayers()) do
            local pid = tonumber(id)
            if Framework.PlayerIdentifier(pid) == identifier then return pid end
        end
        return nil
    end

    -- ── Society / gang account money ──
    local function societyName(gang) return 'society_' .. gang end
    function Framework.GetSocietyMoney(gang)
        if not gang or gang == '' then return 0 end
        if Framework.IsESX and present('esx_addonaccount') then
            local ok, money = pcall(function()
                local p = promise.new()
                TriggerEvent('esx_addonaccount:getSharedAccount', societyName(gang), function(acc) p:resolve(acc and acc.money or 0) end)
                return Citizen.Await(p)
            end)
            if ok then return tonumber(money) or 0 end
        elseif (Framework.IsQB or Framework.IsQBX) and present('qb-banking') then
            return tonumber(Framework.CallExport('qb-banking', 'GetAccountBalance', gang)) or 0
        elseif (Framework.IsQB or Framework.IsQBX) and present('qb-management') then
            return tonumber(Framework.CallExport('qb-management', 'GetAccount', gang)) or 0
        elseif present('Renewed-Banking') then
            return tonumber(Framework.CallExport('Renewed-Banking', 'getAccountMoney', gang)) or 0
        end
        -- Direct SQL fallback (esx addon_account_data) — ESX only.
        -- QB/QBX with no banking resource: nothing to read → return 0 cleanly.
        if Framework.IsESX then
            local ok, row = pcall(function()
                return MySQL.single and MySQL.single.await('SELECT money FROM addon_account_data WHERE account_name = ? LIMIT 1', { societyName(gang) })
            end)
            if ok and row then return tonumber(row.money) or 0 end
        end
        return 0
    end
    function Framework.AddSocietyMoney(gang, amount)
        amount = math.floor(tonumber(amount) or 0)
        if not gang or gang == '' or amount <= 0 then return false end
        if Framework.IsESX and present('esx_addonaccount') then
            return pcall(function() TriggerEvent('esx_addonaccount:getSharedAccount', societyName(gang), function(acc) if acc then acc.addMoney(amount) end end) end)
        elseif present('qb-banking') then Framework.CallExport('qb-banking', 'AddMoney', gang, amount, 'apex_gangs'); return true
        elseif present('qb-management') then Framework.CallExport('qb-management', 'AddMoney', gang, amount); return true
        elseif present('Renewed-Banking') then Framework.CallExport('Renewed-Banking', 'addAccountMoney', gang, amount); return true
        end
        return pcall(function() MySQL.update.await('UPDATE addon_account_data SET money = money + ? WHERE account_name = ?', { amount, societyName(gang) }) end)
    end
    function Framework.RemoveSocietyMoney(gang, amount)
        amount = math.floor(tonumber(amount) or 0)
        if not gang or gang == '' or amount <= 0 then return false end
        if Framework.IsESX and present('esx_addonaccount') then
            return pcall(function() TriggerEvent('esx_addonaccount:getSharedAccount', societyName(gang), function(acc) if acc then acc.removeMoney(amount) end end) end)
        elseif present('qb-banking') then Framework.CallExport('qb-banking', 'RemoveMoney', gang, amount, 'apex_gangs'); return true
        elseif present('qb-management') then Framework.CallExport('qb-management', 'RemoveMoney', gang, amount); return true
        elseif present('Renewed-Banking') then Framework.CallExport('Renewed-Banking', 'removeAccountMoney', gang, amount); return true
        end
        return pcall(function() MySQL.update.await('UPDATE addon_account_data SET money = money - ? WHERE account_name = ? AND money >= ?', { amount, societyName(gang), amount }) end)
    end

    function Framework.NotifyClient(src, msg, type, title, duration)
        TriggerClientEvent('apex_gangs:notify', src, msg, type or 'info', title, duration)
    end
end
