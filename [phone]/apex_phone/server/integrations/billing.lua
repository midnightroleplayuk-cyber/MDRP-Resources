-- ------------------------------------------------------------
-- INTEGRATIONS / BILLING: known billing resources for the Bills app (dispatcher: server/integrations.lua,
-- RPCs: server/billing.lua). Their bills are shown NEXT TO the phone's own bills with id 'x:<id>'.
--   list(src, cid)  -> { { id, sender_name, society?, amount, reason?, status, created? } }
--   pay(src, cid, id) -> true | false, 'funds' | 'invalid'
--   create(src, cid, toCid, amount, reason, opts{ society, senderName, toSrc }) -> true | false, err | nil (= phone bill)
--   sent(src, cid) -> { { id, toCid, amount, reason, status, created? } } · refuse / cancel (src, cid, id) -> bool
-- Paying always takes the money from the BANK (the Bills app says "débito na conta"), with an atomic claim
-- of the row first so two taps can never charge twice, and the money goes back if anything after fails.
-- (INTEG2: resources with a pay export are paid through it, under a per-bill lock; peleg-billing charges
-- the account written on the bill, cash or bank.)
-- The known providers here do NOT define create on purpose: bills issued in the app stay phone bills (the
-- phone's own flow pays the issuer even when he is offline, esx_billing/qb-phone do not). Their bills, from
-- police, mechanics and every other script, show up in the app and can be paid there. A buyer adapter
-- (integrations/custom.lua) can define create to send the app's bills to its own system.
-- verified = false: written from the public docs, not run against the real resource.
-- ------------------------------------------------------------
local PI = PhoneIntegrations
if not PI then return end   -- server/integrations.lua did not load: server/integrations/escrow_check.lua says why in the console

-- a failing query RAISES: the dispatcher catches it, warns once and uses the phone's built-in behaviour
-- (swallowing it here would look like "this player has nothing")
local function q(sql, args)
    local rows = MySQL.query.await(sql, args)
    return type(rows) == 'table' and rows or {}
end
local function upd(sql, args)
    local ok, n = pcall(function() return MySQL.update.await(sql, args) end)
    return ok and (tonumber(n) or 0) or 0
end

local function jobLabel(job)
    job = tostring(job or '')
    if job == '' then return 'Empresa' end
    return (job:gsub('^%l', string.upper))
end

-- money for a bill: society account first, else the sender's bank (online or offline). true = delivered
local function deliver(society, senderCid, amount, reason)
    if society and society ~= '' and FW.AddSocietyMoney(society, amount, reason or 'apex_phone bill') then return true end
    if senderCid and senderCid ~= '' then return GiveBank(senderCid, amount, reason or 'bill-paid') == true end
    return false
end

-- generic pay with an atomic claim (claimSql removes/flags the row and must affect exactly 1 row)
local function payClaimed(src, amount, claimSql, claimArgs, undoSql, undoArgs, society, senderCid, label)
    local p = FW.GetPlayer(src); if not p then return false, 'invalid' end
    amount = math.floor(tonumber(amount) or 0)
    if amount <= 0 then return false, 'invalid' end
    if p.GetMoney('bank') < amount then return false, 'funds' end
    if upd(claimSql, claimArgs) ~= 1 then return false, 'invalid' end
    if not p.RemoveMoney('bank', amount, 'bill-' .. tostring(label or 'bill')) then
        if undoSql then pcall(function() MySQL.query.await(undoSql, undoArgs) end) end
        return false, 'funds'
    end
    -- (a bill with neither society nor issuer, e.g. from the server, is paid to nobody, like the phone's system bills)
    if not deliver(society, senderCid, amount, 'bill-paid') and ((society and society ~= '') or (senderCid and senderCid ~= '')) then
        print(('^3[apex_phone]^0 integrations: bill of %d paid by %s but neither the society (%s) nor the sender (%s) could receive it'):format(amount, tostring(p.cid), tostring(society), tostring(senderCid)))
    end
    if AddTransaction then AddTransaction(p.cid, 'Fatura: ' .. tostring(label or ''), -amount) end
    return true
end

-- ------------------------------------------------------------
-- esx_billing (VERIFIED against esx_billing 1.0 / ESX Legacy 1.13.4 source; INTEG2: same table in
-- ESX-Legacy-Addons 1.15.0)
--   table billing (id, identifier, sender, target_type 'player'|'society', target, label, amount);
--   a paid bill is DELETED (no history); export BillPlayerByIdentifier(target, sender, sharedAccount, label, amount)
--   INTEG2: not taken while jaksam's billing_ui runs (it uses a table also called `billing`, with other
--   columns and an in-memory cache). sender = 'server' (bills from the server) has no player to pay.
-- ------------------------------------------------------------
PI.define('billing', 'esx_billing', {
    label = 'esx_billing',
    detect = function() return PI.started('esx_billing') and not PI.started('billing_ui') end,
    list = function(src, cid)
        local out = {}
        for _, b in ipairs(q('SELECT id, sender, target_type, target, label, amount FROM billing WHERE identifier = ? ORDER BY id DESC LIMIT 100', { cid }) or {}) do
            local society = b.target_type == 'society' and tostring(b.target or ''):gsub('^society_', '') or nil
            out[#out + 1] = { id = b.id, sender = b.sender, sender_name = society and jobLabel(society) or (PI.nameOf(b.sender) or 'Fatura'),
                society = society, amount = b.amount, reason = b.label, status = 'pending' }
        end
        return out
    end,
    pay = function(src, cid, id)
        local b = (q('SELECT * FROM billing WHERE id = ? AND identifier = ? LIMIT 1', { id, cid }) or {})[1]
        if not b then return false, 'invalid' end
        local society = b.target_type == 'society' and tostring(b.target or ''):gsub('^society_', '') or nil
        local ok, why = payClaimed(src, b.amount, 'DELETE FROM billing WHERE id = ? AND identifier = ?', { b.id, cid },
            'INSERT INTO billing (id, identifier, sender, target_type, target, label, amount) VALUES (?, ?, ?, ?, ?, ?, ?)',
            { b.id, b.identifier, b.sender, b.target_type, b.target, b.label, b.amount },
            society, b.sender ~= 'server' and b.sender or nil, b.label)   -- society account first; the issuer only if it cannot receive (as the phone bills)
        if ok then TriggerEvent('esx_billing:paidBill', src, b.id) end   -- esx_billing 1.15 fires it for every bill
        return ok, why
    end,
    sent = function(src, cid)
        local out = {}
        for _, b in ipairs(q('SELECT id, identifier, target_type, target, label, amount FROM billing WHERE sender = ? ORDER BY id DESC LIMIT 100', { cid }) or {}) do
            out[#out + 1] = { id = b.id, toCid = b.identifier, amount = b.amount, reason = b.label, status = 'pending',
                society = b.target_type == 'society' and tostring(b.target or ''):gsub('^society_', '') or nil }
        end
        return out
    end,
    cancel = function(src, cid, id)
        return upd('DELETE FROM billing WHERE id = ? AND sender = ?', { id, cid }) == 1
    end,
})

-- ------------------------------------------------------------
-- phone_invoices: the QBCore billing table (qb-phone and the scripts that bill through it, jim-payments
-- among them). VERIFIED against the local qb-phone (phone_invoices: id, citizenid, amount, society,
-- sender, sendercitizenid, candecline, reason; paid/declined invoices are DELETED).
-- ------------------------------------------------------------
local invoicesTable = { at = 0, ok = false }
local function hasInvoicesTable()
    if os.time() - invoicesTable.at < 600 then return invoicesTable.ok end
    invoicesTable.at = os.time()
    local rows = q("SHOW TABLES LIKE 'phone_invoices'")
    invoicesTable.ok = rows ~= nil and #rows > 0
    return invoicesTable.ok
end

local Invoices = {
    list = function(src, cid)
        local out = {}
        for _, b in ipairs(q('SELECT * FROM phone_invoices WHERE citizenid = ? ORDER BY id DESC LIMIT 100', { cid }) or {}) do
            local society = (type(b.society) == 'string' and b.society ~= '') and b.society or nil
            out[#out + 1] = { id = b.id, sender = b.sendercitizenid, sender_name = b.sender or (society and jobLabel(society)) or 'Fatura',
                society = society, amount = b.amount, reason = b.reason, status = 'pending' }
        end
        return out
    end,
    pay = function(src, cid, id)
        local b = (q('SELECT * FROM phone_invoices WHERE id = ? AND citizenid = ? LIMIT 1', { id, cid }) or {})[1]
        if not b then return false, 'invalid' end
        local society = (type(b.society) == 'string' and b.society ~= '') and b.society or nil
        local ok, why = payClaimed(src, b.amount, 'DELETE FROM phone_invoices WHERE id = ? AND citizenid = ?', { b.id, cid },
            'INSERT INTO phone_invoices (id, citizenid, amount, society, sender, sendercitizenid, candecline) VALUES (?, ?, ?, ?, ?, ?, ?)',
            { b.id, b.citizenid, b.amount, b.society, b.sender, b.sendercitizenid, b.candecline or 1 },
            society, b.sendercitizenid, b.sender)
        if ok then TriggerEvent('qb-phone:server:paidInvoice', src, b.id) end
        return ok, why
    end,
    refuse = function(src, cid, id)
        if upd('DELETE FROM phone_invoices WHERE id = ? AND citizenid = ? AND candecline = 1', { id, cid }) ~= 1 then return false end
        TriggerEvent('qb-phone:server:declinedInvoice', src, id)
        return true
    end,
    sent = function(src, cid)
        local out = {}
        for _, b in ipairs(q('SELECT * FROM phone_invoices WHERE sendercitizenid = ? ORDER BY id DESC LIMIT 100', { cid }) or {}) do
            out[#out + 1] = { id = b.id, toCid = b.citizenid, amount = b.amount, reason = b.reason, status = 'pending', society = b.society, sender_name = b.sender }
        end
        return out
    end,
    cancel = function(src, cid, id)
        return upd('DELETE FROM phone_invoices WHERE id = ? AND sendercitizenid = ?', { id, cid }) == 1
    end,
}

local function invoicesDef(extra)
    local d = {}
    for k, v in pairs(Invoices) do d[k] = v end
    for k, v in pairs(extra) do d[k] = v end
    return d
end

-- jim-payments bills through phone_invoices on QBCore. INTEG2 (VERIFIED against jim_bridge shared/phones.lua):
-- it has no bill table of its own; it only writes phone_invoices (when a resource named qb-phone runs), so
-- it is taken only when that table exists (else its charges are instant and leave no bill to show).
PI.define('billing', 'jim-payments', invoicesDef({ label = 'jim-payments (phone_invoices)',
    detect = function() return PI.started('jim-payments') and hasInvoicesTable() end }))

-- qb-phone itself, or any QBCore server where the phone_invoices table exists (left by qb-phone)
PI.define('billing', 'qb-phone', invoicesDef({
    label = 'qb-phone invoices (phone_invoices)',
    detect = function()
        if PI.started('qb-phone') then return true end
        return (FW.name == 'qb' or FW.name == 'qbx') and hasInvoicesTable()
    end,
}))

-- ------------------------------------------------------------
-- okokBilling (DOCS + the old open v1 source, verified = false): table okokbilling (id, receiver_identifier,
-- author_identifier, author_name, society, society_name, item, invoice_value, fees_amount, status
-- 'unpaid'|'paid'|'autopaid'|'cancelled', notes, sent_date). There is no server export to create or pay:
-- paying is done here (claim the row as paid first, money to the society, else to the author). Bills issued
-- in the app stay phone bills (no create: the date and reference formats of the current version are not public).
-- ------------------------------------------------------------
local OKOK_STATUS = { unpaid = 'pending', paid = 'paid', autopaid = 'paid', cancelled = 'cancelled' }
local function okokSociety(s)
    if type(s) ~= 'string' or s == '' then return nil end
    return (s:gsub('^society_', ''))
end

PI.define('billing', 'okokBilling', {
    label = 'okokBilling', resources = { 'okokBilling' }, verified = false,
    list = function(src, cid)
        local out = {}
        for _, b in ipairs(q('SELECT * FROM okokbilling WHERE receiver_identifier = ? ORDER BY id DESC LIMIT 100', { cid }) or {}) do
            local amount = (tonumber(b.invoice_value) or 0) + (tonumber(b.fees_amount) or 0)
            out[#out + 1] = { id = b.id, sender = b.author_identifier, sender_name = b.society_name or b.author_name or 'Fatura',
                society = okokSociety(b.society), amount = amount, reason = b.item or b.notes,
                status = OKOK_STATUS[tostring(b.status or ''):lower()] or 'pending', created = b.sent_date, paid_at = b.paid_date }
        end
        return out
    end,
    pay = function(src, cid, id)
        local b = (q("SELECT * FROM okokbilling WHERE id = ? AND receiver_identifier = ? AND status = 'unpaid' LIMIT 1", { id, cid }) or {})[1]
        if not b then return false, 'invalid' end
        local amount = (tonumber(b.invoice_value) or 0) + (tonumber(b.fees_amount) or 0)
        return payClaimed(src, amount,
            "UPDATE okokbilling SET status = 'paid', paid_date = ? WHERE id = ? AND receiver_identifier = ? AND status = 'unpaid'", { os.date('%Y-%m-%d %H:%M:%S'), b.id, cid },
            "UPDATE okokbilling SET status = 'unpaid', paid_date = NULL WHERE id = ?", { b.id },
            okokSociety(b.society), b.author_identifier, b.society_name or b.author_name)
    end,
    sent = function(src, cid)
        local out = {}
        for _, b in ipairs(q('SELECT * FROM okokbilling WHERE author_identifier = ? ORDER BY id DESC LIMIT 100', { cid }) or {}) do
            out[#out + 1] = { id = b.id, toCid = b.receiver_identifier, to_name = b.receiver_name, amount = (tonumber(b.invoice_value) or 0) + (tonumber(b.fees_amount) or 0),
                reason = b.item or b.notes, status = OKOK_STATUS[tostring(b.status or ''):lower()] or 'pending', society = okokSociety(b.society), created = b.sent_date, paid_at = b.paid_date }
        end
        return out
    end,
    cancel = function(src, cid, id)
        return upd("UPDATE okokbilling SET status = 'cancelled' WHERE id = ? AND author_identifier = ? AND status = 'unpaid'", { id, cid }) == 1
    end,
})

-- =========================================================================================
-- INTEG2: more billing resources. The ones with a server pay export are paid THROUGH it (their own
-- society/issuer payout, commissions and logs stay right); a per-bill lock in the phone stops a double tap
-- from calling it twice while the first call is still running. Ownership and status are checked first.
-- =========================================================================================
local busy = {}
-- runs fn while holding the lock of one bill; nil, 'invalid' when the bill is already being paid
local function locked(key, fn)
    if busy[key] then return false, 'invalid' end
    busy[key] = true
    local r = table.pack(pcall(fn))
    busy[key] = nil
    if not r[1] then error(r[2], 0) end
    return table.unpack(r, 2, r.n)
end

-- export call that RAISES on failure (the dispatcher warns once and falls back to the phone bills)
local function ex(res, name, ...)
    local r = table.pack(PI.callExport(res, name, ...))
    if not r[1] then error(('%s:%s %s'):format(res, name, tostring(r[2])), 0) end
    return table.unpack(r, 2, r.n)
end

local function bankOf(src)
    local p = FW.GetPlayer(src)
    return p, p and p.GetMoney('bank') or 0
end

-- the phone statement gets the payment unless apex_banking already logs it (its statement is merged in)
local function logPaid(cid, label, amount)
    if AddTransaction and not PI.started('apex_banking') then AddTransaction(cid, 'Fatura: ' .. tostring(label or ''), -math.floor(amount)) end
end

local FUNDS_WHY = { no_funds = true, insufficient_funds = true, ['insufficient funds'] = true, funds = true, no_money = true }

-- ------------------------------------------------------------
-- apex_billing / elevate_billing (VERIFIED against the local apex_billing build/server/exports.lua +
-- modules/invoices.lua; elevate_billing is the same code under another name)
--   table <res>_invoices: status 'draft'|'sent'|'paid'|'declined'|'expired'|'cancelled', total (VAT included),
--   recipient_id / issued_by_id = framework identifier (ESX identifier, QB citizenid) = the phone cid.
--   exports ListReceivedFor(src), GetInvoice(id), PayInvoice(src, id, 'bank') -> ok, why,
--   DeclineInvoice(src, id), CancelInvoice(src, id) (society members with issue rights).
--   Bills are issued only by societies there, so the app's own bills stay phone bills (no create).
-- ------------------------------------------------------------
local APEX_STATUS = { sent = 'pending', paid = 'paid', declined = 'refused', cancelled = 'cancelled', expired = 'cancelled' }

local function apexBillingDef(res)
    local tbl = res .. '_invoices'
    local function row(b)
        local st = APEX_STATUS[tostring(b.status or '')]
        if not st then return nil end   -- drafts
        local paid = tonumber(b.paid_at)
        return { id = b.id, sender = b.issued_by_id, sender_name = b.issuer_name or 'Fatura',
            society = b.issuer_type == 'society' and b.issuer_job or nil, amount = tonumber(b.total) or 0,
            reason = b.title, status = st, created = b.created_at, paid_at = (paid and paid > 0) and paid or nil,
            toCid = b.recipient_id, to_name = b.recipient_name }
    end
    return {
        label = res, resources = { res },
        list = function(src, cid)
            local out = {}
            for _, b in ipairs(ex(res, 'ListReceivedFor', src) or {}) do
                if type(b) == 'table' and b.recipient_type ~= 'society' then
                    local r = row(b)
                    if r then out[#out + 1] = r end
                end
            end
            return out
        end,
        pay = function(src, cid, id)
            id = tonumber(id); if not id then return false, 'invalid' end
            return locked(res .. id, function()
                local b = ex(res, 'GetInvoice', id)
                if type(b) ~= 'table' or b.status ~= 'sent' or b.recipient_type == 'society' or tostring(b.recipient_id) ~= tostring(cid) then return false, 'invalid' end
                local total = tonumber(b.total) or 0
                local p, bank = bankOf(src)
                if not p then return false, 'invalid' end
                if bank < total then return false, 'funds' end
                local ok, why = ex(res, 'PayInvoice', src, id, 'bank')
                if not ok then return false, FUNDS_WHY[tostring(why)] and 'funds' or 'invalid' end
                logPaid(cid, b.issuer_name or b.title, total)
                return true
            end)
        end,
        refuse = function(src, cid, id)
            id = tonumber(id); if not id then return false end
            return ex(res, 'DeclineInvoice', src, id) == true
        end,
        -- read only (the export ListSentBy only covers personal bills, which this resource never issues)
        sent = function(src, cid)
            local out = {}
            for _, b in ipairs(q(('SELECT * FROM %s WHERE issued_by_id = ? ORDER BY id DESC LIMIT 100'):format(tbl), { cid })) do
                local r = row(b)
                if r and b.recipient_type ~= 'society' then out[#out + 1] = r end
            end
            return out
        end,
        cancel = function(src, cid, id)
            id = tonumber(id); if not id then return false end
            return ex(res, 'CancelInvoice', src, id) == true
        end,
    }
end
PI.define('billing', 'apex_billing', apexBillingDef('apex_billing'))
PI.define('billing', 'elevate_billing', apexBillingDef('elevate_billing'))

-- ------------------------------------------------------------
-- wasabi_billing (DOCS: docs.wasabiscripts.com wasabi-billing exports, verified = false). Its manifest also
-- `provide`s okokBilling, esx_billing and codem-billing, so it is checked FIRST.
--   GetInvoicesByIdentifier(identifier) (receiver OR author OR issuer, 200 newest), GetInvoice(ref),
--   PayInvoiceByReference(src, ref, 'bank') -> bool (any payer can pay a personal bill: ownership checked
--   here), CancelInvoice(src, ref). Ids are the reference_id. Status 'unpaid'|'overdue'|'paid'|'cancelled'.
-- ------------------------------------------------------------
local WASABI_STATUS = { unpaid = 'pending', overdue = 'pending', paid = 'paid', cancelled = 'cancelled' }
local function wasabiRow(b)
    return { id = b.reference_id, sender = b.author_identifier, sender_name = b.author_name or 'Fatura',
        amount = tonumber(b.total_amount) or tonumber(b.amount) or 0,
        reason = b.reason, status = WASABI_STATUS[tostring(b.status or ''):lower()] or 'pending', created = b.sent_date,
        paid_at = b.paid_date, toCid = b.receiver_identifier, to_name = b.receiver_name }
end

PI.define('billing', 'wasabi_billing', {
    label = 'wasabi_billing', resources = { 'wasabi_billing' }, verified = false,
    list = function(src, cid)
        local out = {}
        for _, b in ipairs(ex('wasabi_billing', 'GetInvoicesByIdentifier', cid) or {}) do
            if type(b) == 'table' and b.reference_id and tostring(b.receiver_identifier) == tostring(cid) then out[#out + 1] = wasabiRow(b) end
        end
        return out
    end,
    pay = function(src, cid, ref)
        ref = tostring(ref or '')
        return locked('wasabi' .. ref, function()
            local b = ex('wasabi_billing', 'GetInvoice', ref)
            if type(b) ~= 'table' or tostring(b.receiver_identifier) ~= tostring(cid) then return false, 'invalid' end
            local st = tostring(b.status or ''):lower()
            if st ~= 'unpaid' and st ~= 'overdue' then return false, 'invalid' end
            local total = tonumber(b.total_amount) or tonumber(b.amount) or 0
            local p, bank = bankOf(src)
            if not p then return false, 'invalid' end
            if bank < total then return false, 'funds' end
            if ex('wasabi_billing', 'PayInvoiceByReference', src, ref, 'bank') ~= true then return false, 'invalid' end
            logPaid(cid, b.author_name or b.reason, total)
            return true
        end)
    end,
    sent = function(src, cid)
        local out = {}
        for _, b in ipairs(ex('wasabi_billing', 'GetInvoicesByIdentifier', cid) or {}) do
            if type(b) == 'table' and b.reference_id and tostring(b.receiver_identifier) ~= tostring(cid)
                and (tostring(b.author_identifier) == tostring(cid) or tostring(b.invoicer_identifier) == tostring(cid)) then
                out[#out + 1] = wasabiRow(b)
            end
        end
        return out
    end,
    cancel = function(src, cid, ref)
        return ex('wasabi_billing', 'CancelInvoice', src, tostring(ref or '')) == true
    end,
})

-- ------------------------------------------------------------
-- bs_billing (VERIFIED against BeetleStudios/bs_billing server/main.lua + bills.lua): exports answer
-- { success, data, error }. Table bs_billing_invoices, status 'outstanding'|'paid'|'cancelled'.
--   GetBillHistoryBySource(src, limit, offset), GetIssuedBillHistoryBySource(src, limit, offset),
--   GetBillById(id), PayBill(src, id) (claims the row atomically, pays the business/issuer itself),
--   CancelBill(id, actorSrc) (no issuer check there: the phone only cancels bills from my own sent list).
-- ------------------------------------------------------------
local BS_STATUS = { outstanding = 'pending', paid = 'paid', cancelled = 'cancelled' }
local function bsData(r)
    if type(r) ~= 'table' or r.success ~= true then return nil end
    return r.data
end
local function bsRow(b)
    return { id = b.id, sender = b.issuer_id, sender_name = b.issuer_name_snapshot or 'Fatura',
        society = b.issuer_type == 'business' and b.issuer_job or nil, amount = tonumber(b.amount) or 0, reason = b.reason,
        status = BS_STATUS[tostring(b.status or '')] or 'pending', created = b.created_at, paid_at = b.paid_at,
        toCid = b.recipient_id, to_name = b.recipient_name_snapshot }
end

PI.define('billing', 'bs_billing', {
    label = 'bs_billing', resources = { 'bs_billing' },
    list = function(src, cid)
        local out = {}
        for _, b in ipairs(bsData(ex('bs_billing', 'GetBillHistoryBySource', src, 100, 0)) or {}) do
            if type(b) == 'table' and b.id then out[#out + 1] = bsRow(b) end
        end
        return out
    end,
    pay = function(src, cid, id)
        id = tonumber(id); if not id then return false, 'invalid' end
        return locked('bs' .. id, function()
            local b = bsData(ex('bs_billing', 'GetBillById', id))
            if type(b) ~= 'table' or b.status ~= 'outstanding' or tostring(b.recipient_id) ~= tostring(cid) then return false, 'invalid' end
            local r = ex('bs_billing', 'PayBill', src, id)
            if type(r) ~= 'table' or r.success ~= true then
                return false, (type(r) == 'table' and FUNDS_WHY[tostring(r.error)]) and 'funds' or 'invalid'
            end
            logPaid(cid, b.issuer_name_snapshot or b.reason, tonumber(b.amount) or 0)
            return true
        end)
    end,
    sent = function(src, cid)
        local out = {}
        for _, b in ipairs(bsData(ex('bs_billing', 'GetIssuedBillHistoryBySource', src, 100, 0)) or {}) do
            if type(b) == 'table' and b.id then out[#out + 1] = bsRow(b) end
        end
        return out
    end,
    cancel = function(src, cid, id)
        id = tonumber(id); if not id then return false end
        local r = ex('bs_billing', 'CancelBill', id, src)
        return type(r) == 'table' and r.success == true
    end,
})

-- ------------------------------------------------------------
-- peleg-billing (VERIFIED against peleg-development/peleg-billing server/server.lua + bridge.lua): table
-- billing_bills (cid = QB citizenid / ESX identifier), status 'unpaid'|'paid'|'refunded'|'cancelled'.
--   GetBillsByCid(cid, limit), PayBill(id, src) -> true | false, reason (charges the bill's own account,
--   cash or bank, pays the issuer cut + the boss account; its UPDATE has no status guard, hence the lock).
--   No cancel / decline export.
-- ------------------------------------------------------------
local PELEG_STATUS = { unpaid = 'pending', paid = 'paid', refunded = 'cancelled', cancelled = 'cancelled' }
local function pelegRow(b)
    return { id = b.id, sender = b.issuer_cid, sender_name = b.issuer_name or 'Fatura', society = b.job,
        amount = tonumber(b.amount) or 0, reason = b.description, status = PELEG_STATUS[tostring(b.status or '')] or 'pending',
        created = b.created_at, paid_at = b.paid_at, toCid = b.cid, to_name = b.receiver_name }
end

PI.define('billing', 'peleg-billing', {
    label = 'peleg-billing', resources = { 'peleg-billing' },
    list = function(src, cid)
        local out = {}
        for _, b in ipairs(ex('peleg-billing', 'GetBillsByCid', cid, 100) or {}) do
            if type(b) == 'table' and b.id then out[#out + 1] = pelegRow(b) end
        end
        return out
    end,
    pay = function(src, cid, id)
        id = tonumber(id); if not id then return false, 'invalid' end
        return locked('peleg' .. id, function()
            local b = (q("SELECT * FROM billing_bills WHERE id = ? AND cid = ? AND status = 'unpaid' LIMIT 1", { id, cid }))[1]
            if not b then return false, 'invalid' end
            local amount = tonumber(b.amount) or 0
            local p = FW.GetPlayer(src); if not p then return false, 'invalid' end
            if p.GetMoney(b.account == 'cash' and 'cash' or 'bank') < amount then return false, 'funds' end
            local ok, why = ex('peleg-billing', 'PayBill', id, src)
            if not ok then return false, FUNDS_WHY[tostring(why)] and 'funds' or 'invalid' end
            if b.account ~= 'cash' then logPaid(cid, b.issuer_name or b.description, amount) end
            return true
        end)
    end,
    -- read only
    sent = function(src, cid)
        local out = {}
        for _, b in ipairs(q('SELECT * FROM billing_bills WHERE issuer_cid = ? ORDER BY created_at DESC LIMIT 100', { cid })) do
            out[#out + 1] = pelegRow(b)
        end
        return out
    end,
})

-- ------------------------------------------------------------
-- qs-billing (Quasar, DOCS only: quasar-store.com/docs/billing; verified = false). Table qs_billing is the
-- okokbilling layout without ref_id; no server exports are documented, so it is paid like okokBilling:
-- atomic claim of the 'unpaid' row, money to the society, else to the author. The folder name is not in the
-- docs: 'qs-billing' (Quasar's naming) or 'qs_billing'.
-- ------------------------------------------------------------
local QS_STATUS = { unpaid = 'pending', paid = 'paid', autopaid = 'paid', cancelled = 'cancelled' }
local function qsRow(b)
    return { id = b.id, sender = b.author_identifier, sender_name = b.society_name or b.author_name or 'Fatura',
        society = okokSociety(b.society), amount = (tonumber(b.invoice_value) or 0) + (tonumber(b.fees_amount) or 0),
        reason = b.item or b.notes, status = QS_STATUS[tostring(b.status or ''):lower()] or 'pending',
        created = b.sent_date, paid_at = b.paid_date, toCid = b.receiver_identifier, to_name = b.receiver_name }
end

PI.define('billing', 'qs-billing', {
    label = 'qs-billing (qs_billing table)', verified = false,
    detect = function() return PI.started('qs-billing') or PI.started('qs_billing') end,
    list = function(src, cid)
        local out = {}
        for _, b in ipairs(q('SELECT * FROM qs_billing WHERE receiver_identifier = ? ORDER BY id DESC LIMIT 100', { cid })) do out[#out + 1] = qsRow(b) end
        return out
    end,
    pay = function(src, cid, id)
        local b = (q("SELECT * FROM qs_billing WHERE id = ? AND receiver_identifier = ? AND status = 'unpaid' LIMIT 1", { id, cid }))[1]
        if not b then return false, 'invalid' end
        local amount = (tonumber(b.invoice_value) or 0) + (tonumber(b.fees_amount) or 0)
        return payClaimed(src, amount,
            "UPDATE qs_billing SET status = 'paid', paid_date = ? WHERE id = ? AND receiver_identifier = ? AND status = 'unpaid'", { os.date('%Y-%m-%d %H:%M:%S'), b.id, cid },
            "UPDATE qs_billing SET status = 'unpaid', paid_date = NULL WHERE id = ?", { b.id },
            okokSociety(b.society), b.author_identifier, b.society_name or b.author_name)
    end,
    sent = function(src, cid)
        local out = {}
        for _, b in ipairs(q('SELECT * FROM qs_billing WHERE author_identifier = ? ORDER BY id DESC LIMIT 100', { cid })) do out[#out + 1] = qsRow(b) end
        return out
    end,
    cancel = function(src, cid, id)
        return upd("UPDATE qs_billing SET status = 'cancelled' WHERE id = ? AND author_identifier = ? AND status = 'unpaid'", { id, cid }) == 1
    end,
})

-- 'auto' order: wasabi_billing first (it impersonates okokBilling / esx_billing), then the owner's billing,
-- the export based ones, then the table based ones
PI.order.billing = { 'wasabi_billing', 'apex_billing', 'elevate_billing', 'bs_billing', 'peleg-billing', 'okokBilling', 'qs-billing',
    'esx_billing', 'jim-payments', 'qb-phone' }