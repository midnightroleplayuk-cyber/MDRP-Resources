--[[
    Apex Restaurant — Framework Bridge
    ────────────────────────────────────────────────────────────
    Auto-detects ESX | QBCore | QBX and exposes a single,
    framework-agnostic surface used by every other module.

    Public surface:
        Bridge.framework             ('esx' | 'qb' | 'qbx')
        Bridge.isESX, Bridge.isQB, Bridge.isQBX
        Bridge:GetCore()             returns the underlying core obj
        Bridge:GetPlayer(src)        SERVER — returns wrapped player
        Bridge:GetPlayerData()       CLIENT — returns wrapped player data
        Bridge:GetIdentifier(src)    SERVER
        Bridge:GetJob(src|nil)       SERVER or CLIENT
        Bridge:Notify(src|nil, ...)  works on both sides
]]

Bridge = Bridge or {}

local function detect()
    if GetResourceState('qbx_core')     == 'started' then return 'qbx' end
    if GetResourceState('qb-core')      == 'started' then return 'qb'  end
    if GetResourceState('es_extended')  == 'started' then return 'esx' end
    return 'esx' -- safe fallback
end

Bridge.framework = detect()
Bridge.isESX = Bridge.framework == 'esx'
Bridge.isQB  = Bridge.framework == 'qb' or Bridge.framework == 'qbx'
Bridge.isQBX = Bridge.framework == 'qbx'

-- ─── Lazy core ─────────────────────────────────────────────
local _core
function Bridge:GetCore()
    if _core then return _core end
    if self.isQBX then
        -- Qbox (qbx_core) has NO GetCoreObject export, and its player
        -- object `.Functions` table is DEPRECATED. We never use a
        -- monolithic core object on QBX — every call routes through
        -- exports['qbx_core'] directly (see the isQBX branches below).
        -- Return a harmless stub so any stray `core.*` lookup degrades
        -- gracefully instead of hard-crashing the whole resource.
        _core = { qbx = true, Functions = {}, Shared = { Jobs = {} } }
    elseif self.isQB then
        _core = exports['qb-core']:GetCoreObject()
    else
        _core = exports['es_extended']:getSharedObject()
    end
    return _core
end

-- Money-type normaliser. Internally the resource passes 'cash' | 'bank' |
-- 'money'. QB/QBX only know 'cash' | 'bank' | 'crypto', so 'money' → 'cash'.
local function moneyType(account)
    if account == 'money' or account == nil then return 'cash' end
    return account
end
Bridge._moneyType = moneyType

-- ─── Normalize a player data table to ESX-shape ─────────────
local function normalize(raw)
    if not raw then return {} end
    if Bridge.isQB then
        return {
            identifier  = raw.citizenid or raw.PlayerData and raw.PlayerData.citizenid or '',
            name        = raw.charinfo and (raw.charinfo.firstname .. ' ' .. raw.charinfo.lastname) or raw.name or '',
            sex         = raw.charinfo and raw.charinfo.gender or 0,
            job = {
                name        = raw.job and raw.job.name or 'unemployed',
                label       = raw.job and raw.job.label or 'Unemployed',
                grade       = raw.job and raw.job.grade and raw.job.grade.level or 0,
                grade_label = raw.job and raw.job.grade and raw.job.grade.name or '',
                onduty      = raw.job and raw.job.onduty or false,
            },
            source = raw.source,
        }
    end
    return raw
end
Bridge._normalize = normalize

-- ─── CLIENT helpers ────────────────────────────────────────
if not IsDuplicityVersion() then
    function Bridge:GetPlayerData()
        if self.isQBX then
            return normalize(exports['qbx_core']:GetPlayerData())
        end
        local core = self:GetCore()
        if self.isQB then
            return normalize(core.Functions.GetPlayerData())
        end
        return core.GetPlayerData()
    end

    function Bridge:GetJob()
        local pd = self:GetPlayerData() or {}
        return pd.job or { name = 'unemployed', grade = 0 }
    end
end

-- ─── SERVER helpers ────────────────────────────────────────
if IsDuplicityVersion() then
    function Bridge:GetPlayer(src)
        if self.isQBX then
            return exports['qbx_core']:GetPlayer(src)
        end
        local core = self:GetCore()
        if self.isQB then
            return core.Functions.GetPlayer(src)
        end
        return core.GetPlayerFromId(src)
    end

    function Bridge:GetIdentifier(src)
        local p = self:GetPlayer(src)
        if not p then return nil end
        if self.isQB then return p.PlayerData.citizenid end
        return p.identifier
    end

    function Bridge:GetJob(src)
        local p = self:GetPlayer(src)
        if not p then return { name = 'unemployed', grade = 0 } end
        if self.isQB then
            local j = p.PlayerData.job
            return { name = j.name, grade = j.grade.level, onduty = j.onduty, label = j.label }
        end
        local j = p.getJob()
        return { name = j.name, grade = j.grade, label = j.label }
    end

    function Bridge:AddMoney(src, account, amount)
        if self.isQBX then
            return exports['qbx_core']:AddMoney(src, moneyType(account), amount, 'apex_restaurant') and true or false
        end
        local p = self:GetPlayer(src); if not p then return false end
        if self.isQB then return p.Functions.AddMoney(moneyType(account), amount) end
        if account == 'bank' then return p.addAccountMoney('bank', amount) end
        return p.addMoney(amount)
    end

    function Bridge:RemoveMoney(src, account, amount)
        if self.isQBX then
            return exports['qbx_core']:RemoveMoney(src, moneyType(account), amount, 'apex_restaurant') and true or false
        end
        local p = self:GetPlayer(src); if not p then return false end
        if self.isQB then return p.Functions.RemoveMoney(moneyType(account), amount) end
        if account == 'bank' then return p.removeAccountMoney('bank', amount) end
        return p.removeMoney(amount)
    end

    function Bridge:GetMoney(src, account)
        if self.isQBX then
            return exports['qbx_core']:GetMoney(src, moneyType(account)) or 0
        end
        local p = self:GetPlayer(src); if not p then return 0 end
        if self.isQB then return p.Functions.GetMoney(moneyType(account)) end
        if account == 'bank' then
            local a = p.getAccount('bank'); return a and a.money or 0
        end
        return p.getMoney()
    end

    function Bridge:GetAllPlayers()
        if self.isQBX then
            -- qbx_core has no QBCore-style GetPlayers(); GetQBPlayers()
            -- returns a source→player map, so collect its keys.
            local map = exports['qbx_core']:GetQBPlayers() or {}
            local out = {}
            for sid in pairs(map) do out[#out+1] = sid end
            return out
        end
        local core = self:GetCore()
        if self.isQB then return core.Functions.GetPlayers() end
        return core.GetPlayers()
    end

    -- ─── Set a player's job (framework-agnostic) ───────────
    function Bridge:SetJob(src, jobName, grade)
        grade = tonumber(grade) or 0
        if self.isQBX then
            local ok = pcall(function() exports['qbx_core']:SetJob(src, jobName, grade) end)
            return ok
        end
        local p = self:GetPlayer(src); if not p then return false end
        if self.isQB then
            if p.Functions and p.Functions.SetJob then p.Functions.SetJob(jobName, grade); return true end
            return false
        end
        if p.setJob then p.setJob(jobName, grade); return true end
        return false
    end

    -- ─── All jobs + grade definitions (for the boss ranks UI) ──
    function Bridge:GetJobs()
        if self.isESX then
            local core = self:GetCore()
            return (core.GetJobs and core.GetJobs()) or {}
        end
        if self.isQBX then
            -- qbx_core has no single GetJobs() in every version — try it,
            -- otherwise return {} (the boss UI falls back to live grades).
            local ok, jobs = pcall(function() return exports['qbx_core']:GetJobs() end)
            if ok and type(jobs) == 'table' then return jobs end
            return {}
        end
        local core = self:GetCore()
        return (core.Shared and core.Shared.Jobs) or {}
    end

    -- ─── Register a usable (edible) item across inventories ──
    function Bridge:RegisterUsableItem(name, cb)
        if self.isQBX then
            return exports['qbx_core']:CreateUseableItem(name, cb)
        end
        local core = self:GetCore()
        if self.isQB then
            return core.Functions.CreateUseableItem(name, cb)
        end
        if core.RegisterUsableItem then
            return core.RegisterUsableItem(name, cb)
        end
    end

    -- ─── Group / permission membership (for creator access) ──
    -- Checks the framework-native group AND the matching ACE principal
    -- (`group.<name>`), so it works whether admins are set via the
    -- framework or via server.cfg ACE — on ESX, QBCore and Qbox.
    function Bridge:HasGroup(src, group)
        if not group or group == '' then return false end
        if IsPlayerAceAllowed(src, 'group.' .. group) then return true end
        if self.isQBX then
            local ok, res = pcall(function() return exports['qbx_core']:HasGroup(src, group) end)
            if ok and res == true then return true end
            return false
        end
        local p = self:GetPlayer(src); if not p then return false end
        if self.isQB then
            local perm = p.PlayerData and (p.PlayerData.permission
                or (p.PlayerData.metadata and p.PlayerData.metadata.permission))
            return perm == group
        end
        local g = p.getGroup and p.getGroup()
        return g == group
    end

    -- ─── Hunger / thirst ───────────────────────────────────
    -- `delta` is in 0-100 percentage points. We normalize to each
    -- framework's native scale and bump the player's status.
    --
    --   ESX (esx_status):  status uses a 0..1,000,000 scale, so we
    --                      multiply by 10 000.
    --   QB / QBX:          metadata uses 0..100 directly. We read +
    --                      clamp + write + push to the HUD.
    local function bumpQbStatus(self, src, key, delta)
        local p = self:GetPlayer(src); if not p then return end
        local cur = (p.PlayerData and p.PlayerData.metadata and p.PlayerData.metadata[key]) or 0
        local new = math.max(0, math.min(100, cur + delta))
        if self.isQBX then
            -- Qbox: player.Functions.SetMetaData is deprecated → use the export.
            exports['qbx_core']:SetMetadata(src, key, new)
        elseif p.Functions and p.Functions.SetMetaData then
            p.Functions.SetMetaData(key, new)
        end
        local h = key == 'hunger' and new or (p.PlayerData.metadata.hunger or 0)
        local t = key == 'thirst' and new or (p.PlayerData.metadata.thirst or 0)
        TriggerClientEvent('hud:client:UpdateNeeds', src, h, t)
    end

    function Bridge:AddHunger(src, delta)
        delta = tonumber(delta) or 0
        if delta == 0 then return end
        if self.isQB then return bumpQbStatus(self, src, 'hunger', delta) end
        TriggerClientEvent('esx_status:add', src, 'hunger', math.floor(delta * 10000))
    end

    function Bridge:AddThirst(src, delta)
        delta = tonumber(delta) or 0
        if delta == 0 then return end
        if self.isQB then return bumpQbStatus(self, src, 'thirst', delta) end
        TriggerClientEvent('esx_status:add', src, 'thirst', math.floor(delta * 10000))
    end
end

-- ─── Cross-side notify (Apex Notify pipe) ──────────────────
function Bridge:Notify(src, message, type, duration)
    type     = type or 'info'
    duration = duration or 5000
    if IsDuplicityVersion() then
        if not src then return end
        TriggerClientEvent('apex_restaurant:notify', src, message, type, duration)
    else
        TriggerEvent('apex_restaurant:notify', message, type, duration)
    end
end
