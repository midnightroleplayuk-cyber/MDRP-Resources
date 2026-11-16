--[[
    Apex Billing — Framework Bridge
    Auto-detects ESX | QBCore | QBX and exposes the subset of
    framework calls the billing module needs.
]]

Bridge = Bridge or {}

local function detect()
    local force = Config and Config.framework
    if force and force ~= 'auto' then return force end
    -- es_extended is checked FIRST on purpose. A QBox/QBCore server
    -- never runs it, so finding it means this is an ESX server — even
    -- if a stray/stub qbx_core resource is also started, which would
    -- otherwise hijack detection and send every call down the QBox
    -- path on an ESX box.
    if GetResourceState('es_extended')  == 'started' then return 'esx' end
    if GetResourceState('qbx_core')     == 'started' then return 'qbx' end
    if GetResourceState('qb-core')      == 'started' then return 'qb'  end
    return 'esx'
end

Bridge.framework = detect()
Bridge.isESX = Bridge.framework == 'esx'
Bridge.isQB  = Bridge.framework == 'qb' or Bridge.framework == 'qbx'
Bridge.isQBX = Bridge.framework == 'qbx'

-- QBox deliberately DROPPED the GetCoreObject export that QBCore
-- ships (calling it throws "No such export GetCoreObject in resource
-- qbx_core"). It exposes flat exports instead, so for QBX we
-- synthesise a QBCore-shaped core object backed by them — every
-- `core.Functions.*` call site below then works on all three
-- frameworks unchanged.
local function qbxShim()
    local qbx = exports['qbx_core']
    return { Functions = {
        GetPlayer            = function(src) return qbx:GetPlayer(src) end,
        GetPlayerByCitizenId = function(cid) return qbx:GetPlayerByCitizenId(cid) end,
        GetPlayerData        = function()    return qbx:GetPlayerData() end,
        GetPlayers           = function()
            -- qbx_core returns a map keyed by source; callers here
            -- expect a plain array of sources.
            local out, players = {}, qbx:GetQBPlayers()
            for src in pairs(players or {}) do out[#out + 1] = tonumber(src) end
            return out
        end,
    } }
end

local _core
function Bridge:GetCore()
    if _core then return _core end
    if self.isQBX then _core = qbxShim()
    elseif self.isQB then _core = exports['qb-core']:GetCoreObject()
    else _core = exports['es_extended']:getSharedObject() end
    return _core
end

-- ─── CLIENT ─────────────────────────────────────────────────
if not IsDuplicityVersion() then
    function Bridge:GetPlayerData()
        local core = self:GetCore()
        if self.isQB or self.isQBX then return core.Functions.GetPlayerData() end
        return core.GetPlayerData()
    end
    function Bridge:GetCharName()
        local pd = self:GetPlayerData() or {}
        if self.isQB then
            local ci = pd.charinfo or {}
            return ((ci.firstname or '') .. ' ' .. (ci.lastname or '')):match('^%s*(.-)%s*$')
        end
        return (pd.firstName and (pd.firstName .. ' ' .. (pd.lastName or '')))
            or pd.name or 'Citizen'
    end
    function Bridge:GetJob()
        local pd = self:GetPlayerData() or {}
        if self.isQB then
            local j = pd.job or {}
            return {
                name        = j.name or 'unemployed',
                label       = j.label or 'Unemployed',
                grade       = j.grade and j.grade.level or 0,
                grade_label = j.grade and j.grade.name or '',
                onduty      = j.onduty or false,
            }
        end
        return pd.job or { name = 'unemployed', grade = 0, label = 'Unemployed' }
    end
end

-- ─── SERVER ─────────────────────────────────────────────────
if IsDuplicityVersion() then
    function Bridge:GetPlayer(src)
        local core = self:GetCore()
        if self.isQB or self.isQBX then return core.Functions.GetPlayer(src) end
        return core.GetPlayerFromId(src)
    end
    function Bridge:GetIdentifier(src)
        local p = self:GetPlayer(src); if not p then return nil end
        if self.isQB then return p.PlayerData.citizenid end
        return p.identifier
    end
    function Bridge:GetCharName(src)
        local p = self:GetPlayer(src); if not p then return 'Unknown' end
        if self.isQB then
            local ci = p.PlayerData.charinfo or {}
            return ((ci.firstname or '') .. ' ' .. (ci.lastname or '')):match('^%s*(.-)%s*$')
        end
        return p.getName and p.getName() or (p.name or 'Citizen')
    end
    function Bridge:GetJob(src)
        local p = self:GetPlayer(src); if not p then return { name = 'unemployed', grade = 0 } end
        if self.isQB then
            local j = p.PlayerData.job
            return { name = j.name, grade = j.grade.level, onduty = j.onduty, label = j.label }
        end
        local j = p.getJob()
        return { name = j.name, grade = j.grade, label = j.label }
    end
    function Bridge:GetAllPlayers()
        local core = self:GetCore()
        if self.isQB or self.isQBX then return core.Functions.GetPlayers() end
        return core.GetPlayers()
    end
    function Bridge:GetPlayerFromIdentifier(identifier)
        local core = self:GetCore()
        if self.isQB then return core.Functions.GetPlayerByCitizenId(identifier) end
        for _, src in ipairs(self:GetAllPlayers()) do
            local xp = core.GetPlayerFromId(src)
            if xp and xp.identifier == identifier then return xp end
        end
        return nil
    end

    -- ─── Money helpers (bank-first, cash fallback) ─────────
    local function esxApplyDelta(p, account, delta)
        if account == 'bank' then
            local acc = p.getAccount('bank') or { money = 0 }
            local new = math.max(0, (tonumber(acc.money) or 0) + delta)
            if p.setAccountMoney then p.setAccountMoney('bank', new)
            elseif delta > 0 then p.addAccountMoney('bank', delta)
            else p.removeAccountMoney('bank', -delta) end
            return true
        end
        local cur = p.getMoney and p.getMoney() or 0
        local new = math.max(0, cur + delta)
        if p.setMoney then p.setMoney(new)
        elseif delta > 0 then p.addMoney(delta)
        else p.removeMoney(-delta) end
        return true
    end

    function Bridge:AddMoney(src, account, amount)
        local p = self:GetPlayer(src); if not p then return false end
        amount = math.floor(tonumber(amount) or 0); if amount <= 0 then return false end
        if self.isQB then return p.Functions.AddMoney(account, amount, 'apex_billing') end
        return esxApplyDelta(p, account, amount)
    end
    function Bridge:RemoveMoney(src, account, amount)
        local p = self:GetPlayer(src); if not p then return false end
        amount = math.floor(tonumber(amount) or 0); if amount <= 0 then return false end
        if self.isQB then return p.Functions.RemoveMoney(account, amount, 'apex_billing') end
        return esxApplyDelta(p, account, -amount)
    end
    function Bridge:GetMoney(src, account)
        local p = self:GetPlayer(src); if not p then return 0 end
        if self.isQB then return p.Functions.GetMoney(account) end
        if account == 'bank' then
            local a = p.getAccount('bank'); return a and a.money or 0
        end
        return p.getMoney()
    end

    -- ─── Society money (ESX addonaccount / QB banking) ─────
    --
    -- ⚠ Calling an export a resource does not define THROWS:
    --     "No such export GetAccount in resource qb-management"
    -- and a throw inside a server callback means reply() never runs,
    -- so the player's client waits on Citizen.Await forever and the
    -- UI silently never opens. That is exactly what happened with
    -- qb-management builds that ship only the boss-menu exports and
    -- keep the money in qb-banking.
    --
    -- So: never assume, always probe. `started` is not the same as
    -- `has the export`, and a failed provider must fall through to
    -- the next one instead of aborting the whole call.
    local function tryExport(resource, fnName, ...)
        if GetResourceState(resource) ~= 'started' then return false end
        local res = exports[resource]
        if not res then return false end
        local args = table.pack(...)
        local ok, ret = pcall(function()
            return res[fnName](res, table.unpack(args, 1, args.n))
        end)
        if not ok then
            if Config and Config.debug then
                print(('^3[apex_billing]^7 %s:%s unavailable — %s'):format(resource, fnName, tostring(ret)))
            end
            return false
        end
        return true, ret
    end
    Bridge.TryExport = function(_, ...) return tryExport(...) end

    local function esxAccount(jobName)
        local ok, addon = tryExport('esx_addonaccount', 'GetSharedAccount', 'society_' .. tostring(jobName))
        if ok and addon then return addon end
        return nil
    end

    function Bridge:GetSocietyMoney(jobName)
        if not jobName then return 0 end
        if self.isESX then
            local addon = esxAccount(jobName)
            if addon then return tonumber(addon.money) or 0 end
        end
        if self.isQB then
            -- qb-banking is the modern home of job accounts; the
            -- qb-management export only exists on older builds.
            local ok, v = tryExport('qb-banking', 'GetAccountBalance', jobName)
            if ok and v ~= nil then return tonumber(v) or 0 end
            ok, v = tryExport('qb-management', 'GetAccount', jobName)
            if ok and v ~= nil then
                -- Older qb-management returns a number, some forks a table.
                if type(v) == 'table' then return tonumber(v.account_balance or v.money) or 0 end
                return tonumber(v) or 0
            end
        end
        return 0
    end

    function Bridge:AddSocietyMoney(jobName, amount, reason)
        amount = math.floor(tonumber(amount) or 0)
        if not jobName or amount <= 0 then return false end
        if self.isESX then
            local addon = esxAccount(jobName)
            if addon and addon.addMoney then
                local ok = pcall(addon.addMoney, amount)
                if ok then return true end
            end
        end
        if self.isQB then
            if (tryExport('qb-banking', 'AddMoney', jobName, amount, reason or 'apex_billing')) then return true end
            if (tryExport('qb-management', 'AddMoney', jobName, amount)) then return true end
        end
        Utils.Warn(('could not credit society "%s" with %d — no working banking provider')
            :format(tostring(jobName), amount))
        return false
    end

    function Bridge:RemoveSocietyMoney(jobName, amount, reason)
        amount = math.floor(tonumber(amount) or 0)
        if not jobName or amount <= 0 then return false end
        if self.isESX then
            local addon = esxAccount(jobName)
            if addon and addon.removeMoney then
                local ok = pcall(addon.removeMoney, amount)
                if ok then return true end
            end
        end
        if self.isQB then
            if (tryExport('qb-banking', 'RemoveMoney', jobName, amount, reason or 'apex_billing')) then return true end
            if (tryExport('qb-management', 'RemoveMoney', jobName, amount)) then return true end
        end
        Utils.Warn(('could not debit society "%s" by %d — no working banking provider')
            :format(tostring(jobName), amount))
        return false
    end
end
