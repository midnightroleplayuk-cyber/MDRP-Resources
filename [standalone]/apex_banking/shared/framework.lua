--[[
    Apex Banking — Framework Bridge
    ────────────────────────────────────────────────────────────
    Auto-detects ESX | QBCore | QBX and exposes a single,
    framework-agnostic surface used by every other module.

    Public surface (relevant subset for a banking module):
        Bridge.framework          ('esx' | 'qb' | 'qbx')
        Bridge.isESX, Bridge.isQB, Bridge.isQBX
        Bridge:GetCore()                      → core obj
        Bridge:GetPlayer(src)                 SERVER
        Bridge:GetPlayerData()                CLIENT
        Bridge:GetIdentifier(src)             SERVER
        Bridge:GetCharName(src|nil)           friendly char name
        Bridge:GetJob(src|nil)
        Bridge:AddMoney(src, account, n)      'bank' | 'cash'
        Bridge:RemoveMoney(src, account, n)
        Bridge:GetMoney(src, account)
        Bridge:GetAllPlayers()
        Bridge:GetPlayerFromIdentifier(id)    SERVER (offline-safe-ish)
]]

Bridge = Bridge or {}

-- A resource that is still booting reports 'starting', NOT 'started'. If this
-- resource loads before the core has finished booting — which the folder order
-- alone can decide — checking only for 'started' skips the real framework and
-- falls through to the next candidate. That is how an ESX server ended up on
-- the QBox path and blew up with "No such export GetCoreObject in resource
-- qbx_core": es_extended was merely 'starting' at that moment.
local function present(res)
    local state = GetResourceState(res)
    return state == 'started' or state == 'starting'
end
Bridge.present = present

local function detect()
    -- Explicit override always wins (Config.framework = 'esx'|'qb'|'qbx'),
    -- but only if the core it names is actually installed — a typo in the
    -- config must not send every call to a resource that does not exist.
    local forced = Config and Config.framework
    if forced == 'esx' and present('es_extended') then return 'esx' end
    if forced == 'qbx' and present('qbx_core')    then return 'qbx' end
    if forced == 'qb'  and present('qb-core')     then return 'qb'  end
    if forced and forced ~= 'auto' and forced ~= '' then
        print(('^3[apex_banking]^0 Config.framework = "%s" but that core is not running — falling back to auto-detection'):format(forced))
    end

    -- es_extended is checked FIRST on purpose. A QBox/QBCore server never runs
    -- it, so finding it means this is an ESX server — even if a stray/stub
    -- qbx_core is also present, which would otherwise hijack detection.
    if present('es_extended') then return 'esx' end
    if present('qbx_core')    then return 'qbx' end
    if present('qb-core')     then return 'qb'  end
    return 'esx' -- safe fallback
end

Bridge.framework = detect()
Bridge.isESX = Bridge.framework == 'esx'
Bridge.isQB  = Bridge.framework == 'qb' or Bridge.framework == 'qbx'
Bridge.isQBX = Bridge.framework == 'qbx'

-- ─── Lazy core ─────────────────────────────────────────────
-- QBox deliberately DROPPED the GetCoreObject export that QBCore
-- ships (calling it throws "No such export GetCoreObject in resource
-- qbx_core"). Its replacement is a set of flat exports on qbx_core.
-- So for QBX we synthesise a QBCore-shaped core object backed by
-- those exports — every `core.Functions.*` call site in this resource
-- then keeps working unchanged on all three frameworks.
local function qbxShim()
    local qbx = exports['qbx_core']
    local F = {}

    F.GetPlayer           = function(src) return qbx:GetPlayer(src) end
    F.GetPlayerByCitizenId= function(cid) return qbx:GetPlayerByCitizenId(cid) end
    F.GetPlayerData       = function()    return qbx:GetPlayerData() end
    F.GetPlayers          = function()
        -- qbx_core hands back a map keyed by source; the rest of the
        -- bridge expects a plain array of sources. GetQBPlayers is the
        -- deprecated name and reading it THROWS once qbx drops it (the
        -- exports metatable errors on index, not on call), so it is
        -- probed under pcall with GetPlayers as the replacement.
        local ok, players = pcall(function() return qbx:GetQBPlayers() end)
        if not ok or type(players) ~= 'table' then
            ok, players = pcall(function() return qbx:GetPlayers() end)
        end
        local out = {}
        for k, v in pairs((ok and players) or {}) do
            out[#out + 1] = tonumber(k) or tonumber(v)
        end
        return out
    end

    -- QBCore exposes admin checks as core.Functions.HasPermission. Without
    -- this, Config.adminGroups never matched on QBox and a qbx god/admin
    -- was refused by /bankadmin, /placeatm and /atmcard.
    F.HasPermission       = function(src, group)
        local ok, res = pcall(function() return qbx:HasPermission(src, group) end)
        return ok and res or false
    end

    -- QBCore keeps the job/gang tables on core.Shared; qbx moved them to
    -- flat exports. Business discovery, wages and payroll all read
    -- core.Shared.Jobs, so without this shim a QBox server seeds ZERO
    -- businesses and never pays a single salary — silently.
    local Shared = setmetatable({}, {
        __index = function(t, k)
            local getter = (k == 'Jobs' and 'GetJobs') or (k == 'Gangs' and 'GetGangs')
            if not getter then return nil end
            local ok, res = pcall(function() return qbx[getter](qbx) end)
            if not ok or type(res) ~= 'table' or next(res) == nil then
                -- Do NOT cache an empty answer: qbx_core may simply not
                -- have finished loading its job table yet, and caching {}
                -- here would leave the server with no businesses for the
                -- rest of its uptime.
                return {}
            end
            rawset(t, k, res)
            return res
        end,
    })

    return { Functions = F, Shared = Shared }
end

local _core
local _warned = false

-- Resolving the core must never throw: a wrong guess (or a core that is not
-- installed at all) used to surface as "No such export ..." on EVERY callback,
-- with no hint of what actually went wrong. Instead we try the detected core,
-- then fall back to whichever one is really running, and say so once.
local function buildCore(fw)
    if fw == 'qbx' then
        -- QBox deliberately DROPPED GetCoreObject; qbxShim() rebuilds a
        -- QBCore-shaped object from its flat exports.
        if not present('qbx_core') then return nil end
        local ok, core = pcall(qbxShim)
        return ok and core or nil
    elseif fw == 'qb' then
        if not present('qb-core') then return nil end
        local ok, core = pcall(function() return exports['qb-core']:GetCoreObject() end)
        return ok and core or nil
    else
        if not present('es_extended') then return nil end
        local ok, core = pcall(function() return exports['es_extended']:getSharedObject() end)
        return ok and core or nil
    end
end

function Bridge:GetCore()
    if _core then return _core end

    _core = buildCore(self.framework)
    if _core then return _core end

    -- the detected framework did not answer: re-resolve against what is really
    -- running instead of throwing on every single call
    for _, fw in ipairs({ 'esx', 'qbx', 'qb' }) do
        if fw ~= self.framework then
            local core = buildCore(fw)
            if core then
                if not _warned then
                    _warned = true
                    print(('^3[apex_banking]^0 detected "%s" but only "%s" is running — switching. Set Config.framework to silence this.')
                        :format(self.framework, fw))
                end
                self.framework = fw
                self.isESX = fw == 'esx'
                self.isQB  = fw == 'qb' or fw == 'qbx'
                self.isQBX = fw == 'qbx'
                _core = core
                return _core
            end
        end
    end

    if not _warned then
        _warned = true
        print('^1[apex_banking]^0 no supported framework found (es_extended / qb-core / qbx_core). The resource cannot work.')
    end
    return nil
end

-- ─── CLIENT helpers ────────────────────────────────────────
if not IsDuplicityVersion() then
    function Bridge:GetPlayerData()
        local core = self:GetCore()
        if self.isQB or self.isQBX then
            return core.Functions.GetPlayerData()
        end
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

-- ─── SERVER helpers ────────────────────────────────────────
if IsDuplicityVersion() then
    function Bridge:GetPlayer(src)
        local core = self:GetCore()
        if self.isQBX then
            return core.Functions.GetPlayer(src)
        elseif self.isQB then
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

    -- The server id of an already-resolved player object. This used to be
    -- written inline as `Bridge.isQB and p.PlayerData.source or p.source`
    -- in seven places, which is the classic and/or trap: the moment the
    -- middle value is nil the expression falls through to the ESX field,
    -- which is nil on QB, and the caller then moves money for source nil —
    -- a transfer that credits nobody, with no error. Returns nil, never a
    -- wrong number, so callers can check it.
    function Bridge:SourceOf(player)
        if type(player) ~= 'table' then return nil end
        if self.isQB then
            local pd = player.PlayerData
            return (pd and tonumber(pd.source)) or tonumber(player.source)
        end
        return tonumber(player.source)
    end

    function Bridge:GetCharName(src)
        local p = self:GetPlayer(src)
        if not p then return 'Unknown' end
        if self.isQB then
            local ci = p.PlayerData.charinfo or {}
            return ((ci.firstname or '') .. ' ' .. (ci.lastname or '')):match('^%s*(.-)%s*$')
        end
        return p.getName and p.getName() or (p.name or 'Citizen')
    end

    -- One shape on all three frameworks: { name, label, grade, grade_label,
    -- onduty }. Nothing here may index a sub-table without a guard — a job
    -- written straight into the database, or a job deleted from shared/jobs
    -- while someone still holds it, leaves `job` or `job.grade` nil, and an
    -- unguarded `j.grade.level` then threw inside payroll and every
    -- business callback.
    local UNEMPLOYED = { name = 'unemployed', label = 'Unemployed', grade = 0, grade_label = '', onduty = true }

    function Bridge:GetJob(src)
        local p = self:GetPlayer(src)
        if not p then return UNEMPLOYED end
        if self.isQB then
            local j = (p.PlayerData and p.PlayerData.job) or {}
            local g = j.grade or {}
            return {
                name        = j.name or 'unemployed',
                label       = j.label or '',
                grade       = tonumber(g.level) or 0,
                grade_label = g.name or '',
                onduty      = j.onduty ~= false,
            }
        end
        local j = (p.getJob and p.getJob()) or {}
        return {
            name        = j.name or 'unemployed',
            label       = j.label or '',
            grade       = tonumber(j.grade) or 0,
            grade_label = j.grade_label or '',
            onduty      = j.onduty ~= false,
        }
    end

    -- ESX helper: set-money path that bypasses the noisy
    -- addAccountMoney/removeAccountMoney internals. Some ESX
    -- builds spam "event esx:setAccountMoney was not safe for net"
    -- when using add*; calling setAccountMoney with the new total
    -- gives us the same outcome with a single safe code path.
    -- A withdrawal that cannot be covered must FAIL, not silently take
    -- whatever is there. Clamping to zero and still returning true let the
    -- caller credit the full amount to the bank while debiting less than
    -- the full amount from cash — that mints money on ESX under any race.
    -- QBCore's RemoveMoney already returns false here, so this is the
    -- behaviour the rest of the resource is written against.
    local function esxApplyDelta(p, account, delta)
        if account == 'bank' then
            local acc = p.getAccount('bank') or { money = 0 }
            local cur = tonumber(acc.money) or 0
            if delta < 0 and cur + delta < 0 then return false end
            local new = math.max(0, cur + delta)
            if p.setAccountMoney then
                p.setAccountMoney('bank', new)
            else
                -- Legacy fallback when setAccountMoney isn't exposed.
                if delta > 0 then p.addAccountMoney('bank', delta)
                else              p.removeAccountMoney('bank', -delta) end
            end
            return true
        end
        -- cash
        local cur = (p.getMoney and tonumber(p.getMoney())) or 0
        if delta < 0 and cur + delta < 0 then return false end
        local new = math.max(0, cur + delta)
        if p.setMoney then
            p.setMoney(new)
        else
            if delta > 0 then p.addMoney(delta)
            else              p.removeMoney(-delta) end
        end
        return true
    end

    function Bridge:AddMoney(src, account, amount)
        local p = self:GetPlayer(src); if not p then return false end
        amount = math.floor(tonumber(amount) or 0)
        if amount <= 0 then return false end
        if self.isQB then return p.Functions.AddMoney(account, amount, 'apex_banking') end
        return esxApplyDelta(p, account, amount)
    end

    function Bridge:RemoveMoney(src, account, amount)
        local p = self:GetPlayer(src); if not p then return false end
        amount = math.floor(tonumber(amount) or 0)
        if amount <= 0 then return false end
        if self.isQB then return p.Functions.RemoveMoney(account, amount, 'apex_banking') end
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

    function Bridge:GetAllPlayers()
        local core = self:GetCore()
        if self.isQB or self.isQBX then return core.Functions.GetPlayers() end
        return core.GetPlayers()
    end

    function Bridge:GetPlayerFromIdentifier(identifier)
        local core = self:GetCore()
        if self.isQB then
            return core.Functions.GetPlayerByCitizenId(identifier)
        end
        for _, src in ipairs(self:GetAllPlayers()) do
            local xp = core.GetPlayerFromId(src)
            if xp and xp.identifier == identifier then return xp end
        end
        return nil
    end
end
