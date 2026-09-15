--[[
    Apex Laundry — Framework Bridge
    ────────────────────────────────────────────────────────────
    Auto-detects ESX | QBCore | QBX and exposes a single,
    framework-agnostic surface used by every other module. QBox
    uses the same object as QBCore (qbx_core).

    Public surface:
        Bridge.framework               ('esx' | 'qb' | 'qbx')
        Bridge.isESX, Bridge.isQB, Bridge.isQBX
        Bridge:GetCore()
        Bridge:GetPlayerData()                CLIENT
        Bridge:GetPlayer(src)                 SERVER
        Bridge:GetIdentifier(src)             SERVER
        Bridge:GetCharName(src)
        Bridge:GetJob(src)                    SERVER
        Bridge:GetGroup(src)                  SERVER (perm group)
        Bridge:HasPermission(src, group)      SERVER
        Bridge:GetMoney(src, account)         SERVER  'cash'|'bank'
        Bridge:AddMoney(src, account, n)      SERVER
        Bridge:RemoveMoney(src, account, n)   SERVER
        Bridge:GetItemCount(src, item)        SERVER
        Bridge:AddItem(src, item, n)          SERVER
        Bridge:RemoveItem(src, item, n)       SERVER -> bool
        Bridge:RegisterUsableItem(item, fn)   SERVER
]]

Bridge = Bridge or {}

local function detect()
    local forced = (Config and Config.framework) or 'auto'
    if forced ~= 'auto' then return forced end
    if GetResourceState('qbx_core')    == 'started' then return 'qbx' end
    if GetResourceState('qb-core')     == 'started' then return 'qb'  end
    if GetResourceState('es_extended') == 'started' then return 'esx' end
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
        -- qbx_core ships no GetCoreObject export of its own — it only
        -- `provide`s qb-core. Try the qbx export first (some forks add
        -- a shim), then fall back to the provided qb-core interface.
        local ok, core = pcall(function() return exports['qbx_core']:GetCoreObject() end)
        if ok and core then _core = core
        else _core = exports['qb-core']:GetCoreObject() end
    elseif self.isQB then
        _core = exports['qb-core']:GetCoreObject()
    else
        _core = exports['es_extended']:getSharedObject()
    end
    return _core
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
end

-- ─── SERVER helpers ────────────────────────────────────────
if IsDuplicityVersion() then
    function Bridge:GetPlayer(src)
        local core = self:GetCore()
        if self.isQB or self.isQBX then
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

    function Bridge:GetCharName(src)
        local p = self:GetPlayer(src)
        if not p then return 'Unknown' end
        if self.isQB then
            local ci = p.PlayerData.charinfo or {}
            return ((ci.firstname or '') .. ' ' .. (ci.lastname or '')):match('^%s*(.-)%s*$')
        end
        return (p.getName and p.getName()) or p.name or 'Citizen'
    end

    function Bridge:GetJob(src)
        local p = self:GetPlayer(src)
        if not p then return { name = 'unemployed', grade = 0 } end
        if self.isQB then
            local j = p.PlayerData.job
            return { name = j.name, grade = j.grade and j.grade.level or 0, onduty = j.onduty, label = j.label }
        end
        local j = p.getJob()
        return { name = j.name, grade = j.grade, label = j.label }
    end

    -- Best-effort permission group.
    function Bridge:GetGroup(src)
        local p = self:GetPlayer(src)
        if not p then return 'user' end
        if self.isQB then
            -- QB stores admin status as ACE/permission rather than a
            -- single group string; fall back to 'user' and let the
            -- ACE path in HasPermission do the real work.
            local pd = p.PlayerData or {}
            return (pd.metadata and pd.metadata.group)
                or (p.PlayerData and p.PlayerData.permission)
                or 'user'
        end
        -- ESX exposes the group via getGroup(); some builds only have
        -- the .group field or get('group'). Try them all.
        local g = (p.getGroup and p.getGroup()) or p.group
        if (not g or g == '') and p.get then
            local ok, v = pcall(p.get, 'group'); if ok then g = v end
        end
        return g or 'user'
    end

    -- True when `src` belongs to permission `group`. Checks the
    -- framework group AND the universal ACE path (group.<g>), so
    -- it works regardless of how your server maps staff perms.
    function Bridge:HasPermission(src, group)
        if not src or src == 0 then return true end
        if not group or group == '' then return true end

        local g = self:GetGroup(src)
        -- ACE: covers QB/QBX (add_ace group.admin), txAdmin principals,
        -- and any server that maps groups to aces.
        local allowed = IsPlayerAceAllowed(src, group)
            or IsPlayerAceAllowed(src, 'group.' .. group)
            or g == group
            -- ESX treats superadmin as the top tier.
            or (self.isESX and group == 'admin' and (g == 'admin' or g == 'superadmin'))
            or (self.isESX and group == 'god'   and g == 'superadmin')

        if not allowed and self.isQB then
            local p = self:GetPlayer(src)
            if p and p.PlayerData and p.PlayerData.job and p.PlayerData.job.name == group then
                allowed = true
            end
        end

        if Config and Config.debug then
            print(('^3[apex_laundry]^7 HasPermission src=%s group="%s" | fw=%s getGroup="%s" ace=%s group.ace=%s -> %s')
                :format(tostring(src), tostring(group), tostring(self.framework),
                        tostring(g), tostring(IsPlayerAceAllowed(src, group)),
                        tostring(IsPlayerAceAllowed(src, 'group.' .. group)), tostring(allowed)))
        end
        return allowed
    end

    -- ─── Money (cash / bank accounts) ──────────────────────
    local function esxApplyDelta(p, account, delta)
        if account == 'bank' then
            local acc = p.getAccount('bank') or { money = 0 }
            local new = math.max(0, (tonumber(acc.money) or 0) + delta)
            if p.setAccountMoney then p.setAccountMoney('bank', new)
            elseif delta > 0 then p.addAccountMoney('bank', delta)
            else p.removeAccountMoney('bank', -delta) end
            return true
        end
        local cur = (p.getMoney and p.getMoney()) or 0
        local new = math.max(0, cur + delta)
        if p.setMoney then p.setMoney(new)
        elseif delta > 0 then p.addMoney(delta)
        else p.removeMoney(-delta) end
        return true
    end

    function Bridge:GetMoney(src, account)
        local p = self:GetPlayer(src); if not p then return 0 end
        account = account or 'cash'
        if self.isQB then return p.Functions.GetMoney(account == 'cash' and 'cash' or account) end
        if account == 'bank' then
            local a = p.getAccount('bank'); return (a and a.money) or 0
        end
        return (p.getMoney and p.getMoney()) or 0
    end

    function Bridge:AddMoney(src, account, amount)
        local p = self:GetPlayer(src); if not p then return false end
        amount = math.floor(tonumber(amount) or 0)
        -- reject NaN / ±Inf (all comparisons with NaN are false)
        if amount ~= amount or amount == math.huge or amount == -math.huge then return false end
        if amount <= 0 then return false end
        if self.isQB then return p.Functions.AddMoney(account, amount, 'apex_laundry') end
        return esxApplyDelta(p, account, amount)
    end

    function Bridge:RemoveMoney(src, account, amount)
        local p = self:GetPlayer(src); if not p then return false end
        amount = math.floor(tonumber(amount) or 0)
        -- reject NaN / ±Inf (all comparisons with NaN are false)
        if amount ~= amount or amount == math.huge or amount == -math.huge then return false end
        if amount <= 0 then return false end
        if self.isQB then
            if (self:GetMoney(src, account) or 0) < amount then return false end
            return p.Functions.RemoveMoney(account, amount, 'apex_laundry')
        end
        if (self:GetMoney(src, account) or 0) < amount then return false end
        return esxApplyDelta(p, account, -amount)
    end

    -- ─── Inventory items ───────────────────────────────────
    local function oxInv() return GetResourceState('ox_inventory') == 'started' end

    function Bridge:GetItemCount(src, item)
        if not item then return 0 end
        if oxInv() then
            return exports.ox_inventory:GetItemCount(src, item) or 0
        end
        local p = self:GetPlayer(src); if not p then return 0 end
        if self.isQB then
            local it = p.Functions.GetItemByName(item)
            return (it and it.amount) or 0
        end
        local it = p.getInventoryItem(item)
        return (it and it.count) or 0
    end

    function Bridge:AddItem(src, item, amount, metadata)
        if not item then return false end
        amount = math.floor(tonumber(amount) or 0)
        -- reject NaN / ±Inf (all comparisons with NaN are false)
        if amount ~= amount or amount == math.huge or amount == -math.huge then return false end
        if amount <= 0 then return false end
        if oxInv() then
            return exports.ox_inventory:AddItem(src, item, amount, metadata) and true or false
        end
        local p = self:GetPlayer(src); if not p then return false end
        if self.isQB then
            local ok = p.Functions.AddItem(item, amount, false, metadata)
            if ok and GetResourceState('qb-inventory') == 'started' then
                local core = self:GetCore()
                TriggerClientEvent('inventory:client:ItemBox', src,
                    core.Shared.Items[item], 'add', amount)
            end
            return ok and true or false
        end
        p.addInventoryItem(item, amount)
        return true
    end

    function Bridge:RemoveItem(src, item, amount)
        if not item then return false end
        amount = math.floor(tonumber(amount) or 0)
        -- reject NaN / ±Inf (all comparisons with NaN are false)
        if amount ~= amount or amount == math.huge or amount == -math.huge then return false end
        if amount <= 0 then return false end
        if (self:GetItemCount(src, item) or 0) < amount then return false end
        if oxInv() then
            return exports.ox_inventory:RemoveItem(src, item, amount) and true or false
        end
        local p = self:GetPlayer(src); if not p then return false end
        if self.isQB then
            local ok = p.Functions.RemoveItem(item, amount)
            if ok and GetResourceState('qb-inventory') == 'started' then
                local core = self:GetCore()
                TriggerClientEvent('inventory:client:ItemBox', src,
                    core.Shared.Items[item], 'remove', amount)
            end
            return ok and true or false
        end
        p.removeInventoryItem(item, amount)
        return true
    end

    function Bridge:RegisterUsableItem(item, fn)
        if not item then return end
        if self.isQB then
            self:GetCore().Functions.CreateUseableItem(item, fn)
        else
            self:GetCore().RegisterUsableItem(item, fn)
        end
    end

    function Bridge:GetAllPlayers()
        local core = self:GetCore()
        if self.isQB or self.isQBX then return core.Functions.GetPlayers() end
        return core.GetPlayers()
    end

    -- One-time boot log so a wrong auto-detection (e.g. a leftover
    -- qb-core on an ESX box) is obvious in the server console.
    CreateThread(function()
        Wait(1500)
        print(('^2[apex_laundry]^7 framework detected: ^5%s^7 (set Config.framework to force)')
            :format(Bridge.framework))
    end)
end
