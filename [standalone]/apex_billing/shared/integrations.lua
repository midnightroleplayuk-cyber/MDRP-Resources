--[[
    Apex Billing — Open-source Integration Points
    EDIT FREELY. This file stays open-source in the escrowed build.
]]

Integrations = Integrations or {}

-- ─── Notifications ──────────────────────────────────────────
local function _detectNotify()
    local pick = (Config and Config.providers and Config.providers.notify) or 'auto'
    if pick ~= 'auto' then return pick end
    if GetResourceState('apex_notify')   == 'started' then return 'apex_notify' end
    if GetResourceState('ox_lib')        == 'started' then return 'ox_lib'      end
    if GetResourceState('okokNotify')    == 'started' then return 'okok'        end
    if GetResourceState('mythic_notify') == 'started' then return 'mythic'      end
    if GetResourceState('qb-core')       == 'started' then return 'qb'          end
    if GetResourceState('es_extended')   == 'started' then return 'esx'         end
    return 'builtin'
end

local function _clientNotify(message, kind, title, duration)
    if Integrations.OnNotify and Integrations.OnNotify(message, kind, title, duration) then return end
    local p = _detectNotify()
    if p == 'apex_notify' then
        exports['apex_notify']:Notify(message, kind, title, duration)
    elseif p == 'ox_lib' then
        exports.ox_lib:notify({ title = title, description = message, type = kind, duration = duration })
    elseif p == 'okok' then
        exports['okokNotify']:Alert(title, message, duration, kind)
    elseif p == 'mythic' then
        exports['mythic_notify']:SendAlert(kind, message, duration)
    elseif p == 'qb' then
        TriggerEvent('QBCore:Notify', message, kind, duration)
    elseif p == 'esx' then
        local ESX = exports['es_extended']:getSharedObject()
        if ESX and ESX.ShowNotification then ESX.ShowNotification(message) end
    else
        TriggerEvent('apex_billing:notify', title, message, kind, duration)
    end
end

function Integrations.Notify(src, message, kind, duration)
    kind     = kind     or 'info'
    duration = duration or 5000
    local title = 'Billing'
    if IsDuplicityVersion() then
        if not src then return end
        TriggerClientEvent('apex_billing:notify', src, title, message, kind, duration)
    else
        _clientNotify(message, kind, title, duration)
    end
end

-- ─── Banking (payment routing) ──────────────────────────────
-- Prefer apex_banking exports when present so the payment is
-- logged in the bank's transaction history. Falls back to the
-- framework Bridge otherwise.
local function _useApexBanking()
    local pick = (Config and Config.providers and Config.providers.banking) or 'auto'
    if pick ~= 'auto' then return pick == 'apex_banking' end
    return GetResourceState('apex_banking') == 'started'
end

function Integrations.ChargePlayer(src, amount, reason)
    amount = math.floor(tonumber(amount) or 0)
    if not src or amount <= 0 then return false end

    if Integrations.OnCharge then
        local ok = Integrations.OnCharge(src, amount, reason)
        if ok ~= nil then return ok end
    end

    if _useApexBanking() then
        local ok, charged = pcall(function()
            return exports['apex_banking']:RemoveMoney(src, amount, reason)
        end)
        if ok and charged ~= nil then return charged == true end
        if Config and Config.debug then
            print(('[apex_billing] apex_banking RemoveMoney unavailable, using framework bank account: %s'):format(tostring(charged)))
        end
    end

    if (Bridge:GetMoney(src, 'bank') or 0) < amount then return false end
    return Bridge:RemoveMoney(src, 'bank', amount)
end

function Integrations.CreditPlayer(src, amount, reason)
    amount = math.floor(tonumber(amount) or 0)
    if not src or amount <= 0 then return false end

    if Integrations.OnCredit then
        local ok = Integrations.OnCredit(src, amount, reason)
        if ok ~= nil then return ok end
    end

    if _useApexBanking() then
        local ok, credited = pcall(function()
            return exports['apex_banking']:AddMoney(src, amount, reason)
        end)
        if ok and credited ~= nil then return credited == true end
        if Config and Config.debug then
            print(('[apex_billing] apex_banking AddMoney unavailable, using framework bank account: %s'):format(tostring(credited)))
        end
    end

    return Bridge:AddMoney(src, 'bank', amount)
end

-- ─── Inventory: invoice paper + printer ─────────────────────
function Integrations.GivePaper(src, invoiceId)
    if Integrations.OnGivePaper then
        local ok = Integrations.OnGivePaper(src, invoiceId)
        if ok ~= nil then return ok end
    end
    local item = (Config.items.invoicePaper and Config.items.invoicePaper.name) or 'apex_invoice'
    if GetResourceState('ox_inventory') == 'started' then
        return exports.ox_inventory:AddItem(src, item, 1, { invoiceId = invoiceId, description = ('Invoice #%s'):format(invoiceId) })
    end
    -- Other inventories: drop the metadata link, expect the player
    -- to open the panel and find the invoice in History. The paper
    -- item is still given so the action feels real.
    local xp = Bridge:GetPlayer(src); if not xp then return false end
    if Bridge.isQB then xp.Functions.AddItem(item, 1) else xp.addInventoryItem(item, 1) end
    return true
end

local function _hasItem(src, item)
    if not item or item == '' then return true end
    if GetResourceState('ox_inventory') == 'started' then
        local has = exports.ox_inventory:Search(src, 'count', item) or 0
        return has > 0
    end
    local xp = Bridge:GetPlayer(src); if not xp then return false end
    if Bridge.isQB then
        local got = xp.Functions.GetItemByName(item)
        return got and got.amount > 0 or false
    end
    local got = xp.getInventoryItem(item)
    return got and got.count > 0 or false
end

-- Per-society "required to issue" item. Each society sets its
-- own item via Config.societies[job].requiredItem ('' = none).
function Integrations.HasIssueItem(src, jobName)
    if Integrations.OnHasIssueItem then
        local ok = Integrations.OnHasIssueItem(src, jobName)
        if ok ~= nil then return ok end
    end
    local cfg = (Config.societies or {})[jobName or '']
    return _hasItem(src, cfg and cfg.requiredItem)
end

-- Personal invoices: Config.personal.requiredItem ('' = none).
-- jobName is nil here so an OnHasIssueItem override can tell
-- personal billing apart from society billing.
function Integrations.HasPersonalItem(src)
    if Integrations.OnHasIssueItem then
        local ok = Integrations.OnHasIssueItem(src, nil)
        if ok ~= nil then return ok end
    end
    return _hasItem(src, Config.personal and Config.personal.requiredItem)
end

-- ─── Access control ─────────────────────────────────────────
function Integrations.CanUseBilling(src, identifier)
    return true
end

-- Player → player billing (Config.features.personalInvoices).
-- Default rule: on for everyone, or only for Config.personal.jobs
-- when that list is not empty.
function Integrations.CanPersonalIssue(src)
    if not (Config.features and Config.features.personalInvoices) then return false end
    local jobs = Config.personal and Config.personal.jobs
    if type(jobs) ~= 'table' or #jobs == 0 then return true end
    local job = Bridge:GetJob(src) or {}
    for _, name in ipairs(jobs) do
        if name == job.name then return true end
    end
    return false
end

function Integrations.CanSocietyIssue(src, jobName, grade)
    -- Config.features.societyInvoices = false switches society billing off.
    if Config.features and Config.features.societyInvoices == false then return false end
    -- Default rule: Config.societies[jobName].issueGrades must contain grade.
    local cfg = (Config.societies or {})[jobName]
    if not cfg or not cfg.enabled then return false end
    for _, g in ipairs(cfg.issueGrades or {}) do
        if g == grade then return true end
    end
    return false
end

-- Full override for the /billingadmin gate. Return true/false to
-- decide it yourself, or nil to fall back to the default checks
-- (Config.adminAce → Config.adminGroups → Config.adminIdentifiers).
--
--   function Integrations.IsAdmin(src)
--       return exports['my_admin']:IsStaff(src)
--   end
Integrations.IsAdmin = nil

function Integrations.IsSocietyBoss(src, jobName, grade)
    local cfg = (Config.societies or {})[jobName]
    if not cfg then return false end
    for _, g in ipairs(cfg.bossGrades or {}) do
        if g == grade then return true end
    end
    return false
end

-- ─── Lifecycle ──────────────────────────────────────────────
function Integrations.OnInvoiceIssued(invoice)
    -- invoice = { id, number, issuer, recipient, total, … }
end

function Integrations.OnInvoicePaid(invoice, payerSrc, method)
end

function Integrations.OnInvoiceDeclined(invoice, payerSrc)
end

function Integrations.OnLog(payload)
    -- payload = { channel, title, fields = { … }, color, ts }
end
