-- ============================================================
-- QBox (qbx_core) — server bridge
-- ------------------------------------------------------------
-- This file only runs when qbx_core is started. We avoid loading
-- the QBCore bridge alongside this one because qbx_core itself
-- registers a `qb-core` proxy export for compatibility; the QB
-- bridge would attach in parallel and the last-loaded wins,
-- producing duplicate handlers. The Framework variable below
-- doubles as the gate other server files use to detect QBox.
-- ============================================================
if GetResourceState('qbx_core') ~= 'started' then return end

-- Some servers run BOTH qb-core (shim) and qbx_core; force QBox
-- to win when qbx_core is up.
QBX       = exports.qbx_core   -- short alias for downstream callers
-- Set the Framework string to `'qb'` so the rest of the codebase
-- (which already branches on `'qb'`) treats QBox identically to
-- QBCore. The dedicated detection lives in `IsQBox`.
Framework = 'qb'
IsQBox    = true

-- Provide a minimal QBCore-compatible shim so legacy code paths
-- that reference `QBCore` keep working. We expose only what the
-- panel actually uses: Functions.GetPlayer/GetPlayers/HasPermission
-- and Shared.Jobs.
QBCore = QBCore or {
    Functions = {
        GetPlayer  = function(src) return exports.qbx_core:GetPlayer(src) end,
        GetPlayers = function()
            local ok, list = pcall(function() return exports.qbx_core:GetPlayers() end)
            return (ok and list) or {}
        end,
        GetPlayerByCitizenId = function(id) return exports.qbx_core:GetPlayerByCitizenId(id) end,
        HasPermission = function(src, p)
            local ok, r = pcall(function() return exports.qbx_core:HasPermission(src, p) end)
            return ok and r or false
        end,
        AddJob = function(name, data)
            return pcall(function() exports.qbx_core:AddJob(name, data) end)
        end,
        RemoveJob = function(name)
            return pcall(function() exports.qbx_core:RemoveJob(name) end)
        end
    },
    Shared = {
        Jobs = (function()
            local ok, jobs = pcall(function() return exports.qbx_core:GetJobs() end)
            return ok and jobs or {}
        end)()
    }
}

-- Helpers ----------------------------------------------------
local function getPlayerObj(src)
    if not src or src == 0 then return nil end
    local ok, p = pcall(function() return exports.qbx_core:GetPlayer(src) end)
    if ok and p then return p end
    return nil
end

GetPlayer = function(source)
    return getPlayerObj(source)
end

GetPlayerFromIdentifier = function(identifier)
    if not identifier then return nil end
    local ok, p = pcall(function() return exports.qbx_core:GetPlayerByCitizenId(identifier) end)
    if ok and p then return p end
    -- Fallback: try license lookup.
    local ok2, p2 = pcall(function() return exports.qbx_core:GetPlayerByLicense(identifier) end)
    if ok2 and p2 then return p2 end
    return nil
end

-- Capture the native GetPlayers BEFORE we shadow the global, otherwise
-- the fallback below would reference this very wrapper (the old
-- `return GetPlayers and {} or {}` always returned an empty table, which
-- is exactly why the admin player list showed up empty on QBox).
local nativeGetPlayers = GetPlayers
GetPlayers = function()
    local ok, list = pcall(function() return exports.qbx_core:GetPlayers() end)
    if ok and type(list) == 'table' and #list > 0 then return list end
    -- Native fallback (returns player IDs as strings; callers tonumber()).
    return (nativeGetPlayers and nativeGetPlayers()) or {}
end

-- QBox doesn't use the legacy `CreateCallback` pattern, but the
-- panel code only uses `lib.callback.register` directly, so this
-- function is left as a no-op compatibility stub.
RegisterCallback = function(name, cb)
    -- Use ox_lib's callback system directly elsewhere.
    if lib and lib.callback and lib.callback.register then
        lib.callback.register(name, cb)
    end
end

KickPlayer = function(source, reason)
    DropPlayer(source, reason or 'Kicked')
end

-- ── Group / permission detection ────────────────────────────
-- QBox exposes admin perms through `IsPlayerAceAllowed` ace
-- permissions OR the legacy QBCore permission table. We support
-- both transparently.
HasPermission = function(source, group)
    if not source or not group then return false end
    if IsPlayerAceAllowed(source, 'command.' .. group) then return true end
    local ok, allowed = pcall(function()
        return exports.qbx_core:HasPermission(source, group)
    end)
    return ok and allowed or false
end

HasGroup = function(source, filter)
    local player = getPlayerObj(source)
    if not player or not player.PlayerData then return nil end
    local groups = { 'job', 'gang' }
    local t = type(filter)

    if t == 'string' then
        for i = 1, #groups do
            local data = player.PlayerData[groups[i]]
            if data and data.name == filter then
                return data.name, (data.grade and data.grade.level) or 0
            end
        end
    elseif t == 'table' then
        local tt = table.type and table.type(filter) or 'array'
        if tt == 'hash' then
            for i = 1, #groups do
                local data = player.PlayerData[groups[i]]
                if data then
                    local grade = filter[data.name]
                    if grade and grade <= ((data.grade and data.grade.level) or 0) then
                        return data.name, data.grade.level
                    end
                end
            end
        else
            for i = 1, #filter do
                local g = filter[i]
                for j = 1, #groups do
                    local data = player.PlayerData[groups[j]]
                    if data and data.name == g then
                        return data.name, (data.grade and data.grade.level) or 0
                    end
                end
            end
        end
    end
end

-- Returns `true` or `false, reason`. The callers show that reason to the
-- admin, so "nothing happened and nobody said why" stops being a possible
-- outcome of a job change on any of the three frameworks.
SetJob = function(source, job, grade)
    local player = getPlayerObj(source)
    if not player then return false, 'Player not loaded' end

    grade = tonumber(grade) or 0

    -- qbx_core validates against its own job registry; check it first so the
    -- refusal carries a reason instead of a bare false.
    local ok, pool = pcall(function() return exports.qbx_core:GetJobs() end)
    if ok and type(pool) == 'table' and next(pool) ~= nil then
        local def = pool[job]
        if not def then
            return false, ('QBox has no job named "%s".'):format(tostring(job))
        end
        local grades = def.grades or {}
        if grades[tostring(grade)] == nil and grades[grade] == nil then
            local have = {}
            for g in pairs(grades) do have[#have + 1] = tostring(g) end
            table.sort(have)
            return false, ('Job "%s" has no grade %d. Available: %s'):format(
                tostring(job), grade, #have > 0 and table.concat(have, ', ') or '(none)')
        end
    end

    if player.Functions and player.Functions.SetJob then
        local res = player.Functions.SetJob(job, grade)
        if res == false then
            return false, ('QBox refused the job change to "%s" (grade %d).'):format(tostring(job), grade)
        end
        return true
    end

    -- QBox export form.
    local sent, err = pcall(function()
        exports.qbx_core:SetPlayerPrimaryJob(source, job, grade)
    end)
    if not sent then return false, tostring(err) end
    return true
end

GetIdentifier = function(source)
    local player = getPlayerObj(source)
    if not player or not player.PlayerData then return nil end
    return player.PlayerData.citizenid or player.PlayerData.license
end

GetName = function(source)
    local player = getPlayerObj(source)
    if not player or not player.PlayerData or not player.PlayerData.charinfo then
        return GetPlayerName(source) or 'Unknown'
    end
    local ci = player.PlayerData.charinfo
    return ((ci.firstname or '') .. ' ' .. (ci.lastname or '')):gsub('^%s+', ''):gsub('%s+$', '')
end

-- ── Items ──────────────────────────────────────────────────
-- QBox ships with ox_inventory by default. If that isn't started
-- we degrade to the QBCore-compatible Player.Functions API.
local function usingOx()
    return GetResourceState('ox_inventory') == 'started'
end

HasItem = function(source, item)
    if usingOx() then
        local count = exports.ox_inventory:GetItemCount(source, item)
        return count or 0
    end
    local player = getPlayerObj(source)
    if not player or not player.Functions or not player.Functions.GetItemByName then return 0 end
    local it = player.Functions.GetItemByName(item)
    return (it and (it.count or it.amount)) or 0
end

AddItem = function(source, item, count, slot, metadata)
    if usingOx() then
        return exports.ox_inventory:AddItem(source, item, count or 1, metadata, slot)
    end
    local player = getPlayerObj(source)
    if not player or not player.Functions then return false end
    return player.Functions.AddItem(item, count or 1, slot, metadata)
end

AddWeapon = function(source, weapon, ammo)
    if usingOx() then
        return exports.ox_inventory:AddItem(source, weapon, 1, { ammo = ammo or 100 })
    end
    local player = getPlayerObj(source)
    if not player or not player.Functions then return false end
    return player.Functions.AddItem(weapon, 1)
end

RemoveItem = function(source, item, count, slot, metadata)
    if usingOx() then
        return exports.ox_inventory:RemoveItem(source, item, count or 1, metadata, slot)
    end
    local player = getPlayerObj(source)
    if not player or not player.Functions then return false end
    player.Functions.RemoveItem(item, count or 1, slot)
end

-- ── Money ──────────────────────────────────────────────────
AddMoney = function(source, account, amount)
    if account == 'money' then account = 'cash' end
    local player = getPlayerObj(source)
    if not player or not player.Functions then return false end
    return player.Functions.AddMoney(account, amount)
end

RemoveMoney = function(source, account, amount)
    if account == 'money' then account = 'cash' end
    local player = getPlayerObj(source)
    if not player or not player.Functions then return false end
    return player.Functions.RemoveMoney(account, amount)
end

GetPlayerAccountFunds = function(source, account)
    if account == 'money' then account = 'cash' end
    local player = getPlayerObj(source)
    if not player or not player.PlayerData then return 0 end
    return (player.PlayerData.money and player.PlayerData.money[account]) or 0
end
