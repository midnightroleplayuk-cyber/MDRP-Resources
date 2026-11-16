-- ------------------------------------------------------------
-- INTEGRATIONS / BANK: known banking resources for the Wallet app (server/integrations.lua has the
-- dispatcher and the interface). In all of them the PERSONAL balance is the framework bank money, so the
-- phone keeps moving money through the framework and the bank only adds IBAN, history and the record of
-- the phone's transfers. Everything is pcall + GetResourceState: a missing or renamed export only drops
-- that piece of information, the Wallet keeps working.
--   history row = { id, description, amount (signed: negative = money out), created (ms or s) }
--   record(cid, description, amount, src) -> true when the bank stored it (the phone then does not store it twice)
-- verified = false: written from the resource's public docs, not run against the real resource.
-- ------------------------------------------------------------
local PI = PhoneIntegrations
if not PI then return end   -- server/integrations.lua did not load: server/integrations/escrow_check.lua says why in the console

-- a failing query RAISES: the dispatcher catches it, warns once and uses the phone's built-in behaviour
-- (swallowing it here would look like "this player has nothing")
local function q(sql, args)
    local rows = MySQL.query.await(sql, args)
    return type(rows) == 'table' and rows or {}
end

local function online(src) return src and FW.GetPlayer(src) or nil end

-- charinfo.account (QBCore / QBox) of an online player, used as "IBAN" by okokBanking on QB and as the
-- account number that qb-core generates
local function qbAccount(src)
    local p = online(src)
    local ok, acc = pcall(function() return p.raw.PlayerData.charinfo.account end)
    if ok and type(acc) == 'string' and acc ~= '' then return acc end
    return nil
end

-- ------------------------------------------------------------
-- apex_banking: the builtin already speaks to it (IBAN, savings, frozen, Transfer export)
-- ------------------------------------------------------------
PI.define('bank', 'apex_banking', { label = 'apex_banking', resources = { 'apex_banking' }, aliasBuiltin = true })

-- ------------------------------------------------------------
-- Renewed-Banking (VERIFIED against Renewed-Banking v2.1.4 source)
--   personal history = player_transactions.transactions (JSON array, newest first, time in SECONDS)
--   export handleTransaction(account, title, amount, message, issuer, receiver, 'deposit'|'withdraw')
--   only persists for players in its cache (online); offline = read-modify-write of the row
-- ------------------------------------------------------------
local function renewedRows(cid)
    local ok, list = PI.callExport('Renewed-Banking', 'getAccountTransactions', cid)
    if ok and type(list) == 'table' then return list, true end
    local row = q('SELECT transactions FROM player_transactions WHERE id = ? LIMIT 1', { cid })[1]
    return row and PI.decode(row.transactions) or {}, false
end

PI.define('bank', 'Renewed-Banking', {
    label = 'Renewed-Banking', resources = { 'Renewed-Banking' },
    info = function(src, cid)
        local row = q('SELECT isFrozen FROM player_transactions WHERE id = ? LIMIT 1', { cid })[1]
        return { iban = cid, frozen = row and tonumber(row.isFrozen) == 1 or false }
    end,
    history = function(src, cid)
        local out = {}
        local list = renewedRows(cid)
        for i, t in ipairs(list) do
            if i > 60 then break end
            local amt = PI.num(t.amount) or 0
            local out_ = tostring(t.trans_type or ''):lower() == 'withdraw'
            local msg = (type(t.message) == 'string' and t.message ~= '') and (' · ' .. t.message) or ''
            out[#out + 1] = { id = t.trans_id or i, description = tostring(t.title or 'Banco') .. msg, amount = out_ and -math.abs(amt) or math.abs(amt), created = t.time }
        end
        return out
    end,
    record = function(cid, description, amount, src)
        local kind = amount < 0 and 'withdraw' or 'deposit'
        local who = PI.nameOf(cid) or tostring(cid)
        local _, cached = renewedRows(cid)
        if cached then
            local ok = PI.callExport('Renewed-Banking', 'handleTransaction', tostring(cid), 'Phone', math.abs(amount) + 0.0, tostring(description), who, who, kind)
            return ok == true
        end
        -- INTEG2: not in Renewed's cache (offline, never opened the bank this session): handleTransaction would only
        -- print "invalid account", and player_transactions is NEVER written by the phone (Renewed keeps the whole
        -- list in memory and rewrites the row from it). false = the phone keeps its own row for this side.
        return false
    end,
})

-- ------------------------------------------------------------
-- okokBanking (DOCS: okokBanking v2 exports AddTransaction / GetPlayerTransactions; v1 table
-- okokbanking_transactions). IBAN: ESX users.iban, QB charinfo.account. verified = false.
-- ------------------------------------------------------------
-- INTEG2: wasabi_banking and lwk_bank can `provide 'okokBanking'` and answer its exports: then they are the real bank
-- (wasabi has its own provider below), never okokBanking. PI.okokReal is shared with society.lua.
function PI.okokReal()
    return PI.started('okokBanking') and not PI.started('wasabi_banking') and not PI.started('lwk_bank')
end

PI.define('bank', 'okokBanking', {
    label = 'okokBanking', detect = function() return PI.okokReal() end, verified = false,
    info = function(src, cid)
        local iban
        if FW.name == 'esx' then
            local row = q('SELECT iban FROM users WHERE identifier = ? LIMIT 1', { cid })[1]
            iban = row and row.iban or nil
        else
            iban = qbAccount(src)
        end
        return { iban = (type(iban) == 'string' and iban ~= '') and iban or nil }
    end,
    history = function(src, cid)
        local rows
        local ok, list = PI.callExport('okokBanking', 'GetPlayerTransactions', cid, 60)
        if ok and type(list) == 'table' then rows = list
        else rows = q('SELECT * FROM okokbanking_transactions WHERE sender_identifier = ? OR receiver_identifier = ? ORDER BY id DESC LIMIT 60', { cid, cid }) end
        local out = {}
        for i, t in ipairs(rows) do
            local amt = math.abs(PI.num(t.value or t.amount) or 0)
            local incoming = t.receiver_identifier == cid
            local other = incoming and (t.sender_name or t.sender_identifier) or (t.receiver_name or t.receiver_identifier)
            local label = tostring(t.reason or t.type or 'Banco') .. ((other ~= nil and tostring(other) ~= '') and (' · ' .. tostring(other)) or '')
            out[#out + 1] = { id = t.id or i, description = label, amount = incoming and amt or -amt, created = t.date or t.created_at }
        end
        return out
    end,
    record = function(cid, description, amount, src)
        local who = PI.nameOf(cid) or tostring(cid)
        local data = amount < 0
            and { sender_identifier = cid, sender_name = who, receiver_identifier = 'phone', receiver_name = 'Phone', value = math.abs(amount), type = 'transfer', reason = description }
            or { sender_identifier = 'phone', sender_name = 'Phone', receiver_identifier = cid, receiver_name = who, value = math.abs(amount), type = 'transfer', reason = description }
        local ok = PI.callExport('okokBanking', 'AddTransaction', cid, data, src)
        return ok == true   -- v1 has no export: the phone keeps the row itself
    end,
})

-- ------------------------------------------------------------
-- tgg-banking (DOCS: GetPersonalAccountByPlayerId / GetPersonalAccountByPlayerIdentifier). No documented
-- history export, so the Wallet shows the account (IBAN, balance, frozen) and the phone's own rows.
-- verified = false.
-- ------------------------------------------------------------
local function tggAccount(src, cid)
    local ok, acc
    if src then ok, acc = PI.callExport('tgg-banking', 'GetPersonalAccountByPlayerId', src) end
    if not (ok and type(acc) == 'table') then ok, acc = PI.callExport('tgg-banking', 'GetPersonalAccountByPlayerIdentifier', cid) end
    return (ok and type(acc) == 'table') and acc or nil
end

PI.define('bank', 'tgg-banking', {
    label = 'tgg-banking', resources = { 'tgg-banking' }, verified = false,
    balance = function(src, cid)
        local a = tggAccount(src, cid)
        return a and PI.num(a.balance) or nil   -- nil = framework bank money
    end,
    info = function(src, cid)
        local a = tggAccount(src, cid)
        if not a then return { noAccount = true } end
        return { iban = a.iban ~= nil and tostring(a.iban) or nil, frozen = a.frozen == true or a.closed == true }
    end,
    -- INTEG2: AddTransaction(toIban, fromIban, type, amount, description) -> transaction id | nil (DOCS). The Wallet has
    -- no tgg statement to read, so the phone keeps its own row too (record only adds the line to tgg's statement).
    record = function(cid, description, amount, src)
        local a = tggAccount(src, cid)
        if not (a and a.iban) then return false end
        local ok, id
        if amount < 0 then
            ok, id = PI.callExport('tgg-banking', 'AddTransaction', nil, a.iban, 'withdraw', math.abs(amount), tostring(description))
        else
            ok, id = PI.callExport('tgg-banking', 'AddTransaction', a.iban, nil, 'deposit', math.abs(amount), tostring(description))
        end
        return ok == true and id ~= nil
    end,
})

-- ------------------------------------------------------------
-- ps-banking (VERIFIED against ps-banking v1.0.4 source): ps_banking_transactions (amount ABS + isIncome,
-- date = DATE). It already logs every bank change of an ONLINE player by itself (client event), so record
-- only writes for offline players.
-- ------------------------------------------------------------
PI.define('bank', 'ps-banking', {
    label = 'ps-banking', resources = { 'ps-banking' },
    history = function(src, cid)
        local out = {}
        for i, t in ipairs(q('SELECT id, description, type, amount, date, isIncome FROM ps_banking_transactions WHERE identifier = ? ORDER BY date DESC, id DESC LIMIT 60', { cid })) do
            local amt = math.abs(PI.num(t.amount) or 0)
            local inc = t.isIncome == true or tonumber(t.isIncome) == 1
            out[#out + 1] = { id = t.id or i, description = tostring(t.description or t.type or 'Banco'), amount = inc and amt or -amt, created = t.date }
        end
        return out
    end,
    record = function(cid, description, amount, src)
        if FW.GetPlayerByCid(cid) then return true end   -- online: ps-banking logged it already
        local ok = pcall(function()
            MySQL.insert.await('INSERT INTO ps_banking_transactions (identifier, description, type, amount, date, isIncome) VALUES (?, ?, ?, ?, NOW(), ?)',
                { cid, tostring(description):sub(1, 255), 'bank', math.abs(amount), amount > 0 })
        end)
        return ok
    end,
})

-- ------------------------------------------------------------
-- qb-banking 2.x (VERIFIED against qb-banking 2.0.0, the 2024 rewrite): personal account 'checking',
-- bank_statements (amount ABS + statement_type, reason VARCHAR(50)). The 1.x API is different: only 2.x.
-- ------------------------------------------------------------
PI.define('bank', 'qb-banking', {
    label = 'qb-banking 2.x',
    detect = function()
        if not PI.started('qb-banking') then return false end
        local v = GetResourceMetadata('qb-banking', 'version', 0)
        return type(v) == 'string' and (tonumber(v:match('^(%d+)')) or 0) >= 2
    end,
    info = function(src, cid) return { iban = qbAccount(src) } end,
    history = function(src, cid)
        local out = {}
        for i, t in ipairs(q("SELECT id, amount, reason, statement_type, date FROM bank_statements WHERE citizenid = ? AND account_name = 'checking' ORDER BY id DESC LIMIT 60", { cid })) do
            local amt = math.abs(PI.num(t.amount) or 0)
            out[#out + 1] = { id = t.id or i, description = tostring(t.reason or 'Banco'), amount = (t.statement_type == 'withdraw') and -amt or amt, created = t.date }
        end
        return out
    end,
    record = function(cid, description, amount, src)
        local kind = amount < 0 and 'withdraw' or 'deposit'
        local reason = tostring(description):sub(1, 50)
        if src and FW.GetPlayer(src) then
            local ok, r = PI.callExport('qb-banking', 'CreateBankStatement', src, 'checking', math.abs(amount), reason, kind, 'player')
            return ok and r ~= false
        end
        local ok = pcall(function()
            MySQL.insert.await("INSERT INTO bank_statements (citizenid, account_name, amount, reason, statement_type) VALUES (?, 'checking', ?, ?, ?)", { cid, math.abs(amount), reason, kind })
        end)
        return ok
    end,
})

-- ============================================================
-- INTEG2 (5 Oct 2026): more banks
-- ============================================================

-- ------------------------------------------------------------
-- pefcl (VERIFIED against project-error/pefcl source: Sequelize models pefcl_accounts / pefcl_transactions,
-- account.controller exports, and the qb-pefcl / pefcl-esx framework bridges)
--   pefcl_accounts(id, number, accountName, isDefault, ownerIdentifier, role, balance, type, createdAt, deletedAt)
--   pefcl_transactions(id, message, amount ABS, type 'Outgoing'|'Incoming'|'Transfer', toAccountId, fromAccountId, createdAt)
--   With its framework bridge the framework BANK money IS the default pefcl account: every AddMoney/RemoveMoney
--   ('bank') of an ONLINE player is routed to addBankBalance/removeBankBalance, which writes the transaction itself
--   (message = the phone's reason). So: balance = framework bank money (synced by the bridge), record = true for
--   online players (already logged, no second line), false for offline ones (the phone keeps its own row).
--   ownerIdentifier = citizenid (QBCore bridge) / xPlayer.identifier (ESX bridge) = the phone's cid.
-- ------------------------------------------------------------
local function pefclDefault(cid)
    return q('SELECT id, number, balance FROM pefcl_accounts WHERE ownerIdentifier = ? AND isDefault = 1 AND deletedAt IS NULL LIMIT 1', { cid })[1]
end

PI.define('bank', 'pefcl', {
    label = 'pefcl', resources = { 'pefcl' },
    info = function(src, cid)
        local a = pefclDefault(cid)
        if not a then return { noAccount = true } end
        return { iban = a.number ~= nil and tostring(a.number) or nil }
    end,
    history = function(src, cid)
        local a = pefclDefault(cid)
        if not a then return {} end
        local mine = tonumber(a.id)
        local out = {}
        for i, t in ipairs(q('SELECT id, message, amount, type, toAccountId, fromAccountId, createdAt FROM pefcl_transactions WHERE toAccountId = ? OR fromAccountId = ? ORDER BY id DESC LIMIT 60', { mine, mine })) do
            local amt = math.abs(PI.num(t.amount) or 0)
            local outgoing = tonumber(t.fromAccountId) == mine
            out[#out + 1] = { id = t.id or i, description = tostring(t.message or t.type or 'Banco'), amount = outgoing and -amt or amt, created = t.createdAt }
        end
        return out
    end,
    record = function(cid, description, amount, src)
        return FW.GetPlayerByCid(cid) ~= nil   -- online: pefcl logged it through the framework bridge
    end,
})

-- ------------------------------------------------------------
-- Paid / encrypted banks, all verified = false (written from the vendor's public docs). In all of them the personal
-- balance stays the framework bank money; none documents a statement query, so the phone keeps its own rows and
-- record() only adds the phone's movement to the bank's own statement (true = written there too).
-- ------------------------------------------------------------
-- read-only calls: a failing / missing export RAISES, so the dispatcher drops just that piece (one warning) instead
-- of the Wallet showing "no account"
local function call(res, name, ...)
    local ok, a, b = PI.callExport(res, name, ...)
    if not ok then error(('%s:%s failed (%s)'):format(res, name, tostring(a)), 0) end
    return a, b
end

-- fd_banking (docs.felis.gg/banking/exports): getPersonalAccount(citizenid) -> { id, iban, balance, is_frozen, ... }
PI.define('bank', 'fd_banking', {
    label = 'fd_banking', resources = { 'fd_banking' }, verified = false,
    info = function(src, cid)
        local a = call('fd_banking', 'getPersonalAccount', cid)
        if type(a) ~= 'table' then return { noAccount = true } end
        return { iban = a.iban ~= nil and tostring(a.iban) or nil, frozen = a.is_frozen == true or tonumber(a.is_frozen) == 1 }
    end,
})

-- qs-banking (Quasar Banking Creator developer API): AddTransaction(identifier, title, icon, text) writes a line in
-- the player's feed (no amount field: the amount goes in the text). No public account/IBAN export.
PI.define('bank', 'qs-banking', {
    label = 'qs-banking', resources = { 'qs-banking' }, verified = false,
    record = function(cid, description, amount, src)
        local text = ('%s%d'):format(amount < 0 and '-' or '+', math.abs(amount))
        local ok = PI.callExport('qs-banking', 'AddTransaction', cid, tostring(description):sub(1, 60), 'fa-solid fa-mobile-screen', text)
        return ok == true
    end,
})

-- kartik-banking (kartik-scripts docs): GetAccountDataByOwner(citizenid, 'personal') -> { accountNumber, status, ... } |
-- false · LogBankTransaction({ account_number, type 'deposit'|'withdraw', amount, memo }) (statement + stats only)
local function kartikAcc(cid)
    local a = call('kartik-banking', 'GetAccountDataByOwner', cid, 'personal')
    return type(a) == 'table' and a or nil
end
PI.define('bank', 'kartik-banking', {
    label = 'kartik-banking', resources = { 'kartik-banking' }, verified = false,
    info = function(src, cid)
        local a = kartikAcc(cid)
        if not a then return { noAccount = true } end
        return { iban = a.accountNumber ~= nil and tostring(a.accountNumber) or nil, frozen = tostring(a.status or ''):lower() == 'frozen' }
    end,
    record = function(cid, description, amount, src)
        local a = kartikAcc(cid)
        if not (a and a.accountNumber) then return false end
        local ok = PI.callExport('kartik-banking', 'LogBankTransaction', { account_number = a.accountNumber,
            type = amount < 0 and 'withdraw' or 'deposit', amount = math.abs(amount), memo = tostring(description) })
        return ok == true
    end,
})

-- wasabi_banking (docs.wasabiscripts): GetAccountsByPlayer(identifier) rows (type 'bank' = personal) ·
-- IsAccountFrozen('bank', citizenid) · Transaction(identifier, reason, amount, 'deposit'|'sent', 'personal') = statement line
PI.define('bank', 'wasabi_banking', {
    label = 'wasabi_banking', resources = { 'wasabi_banking' }, verified = false,
    info = function(src, cid)
        local iban
        local rows = call('wasabi_banking', 'GetAccountsByPlayer', cid)
        if type(rows) == 'table' then
            for _, r in ipairs(rows) do
                if type(r) == 'table' and tostring(r.type or r.accountType or ''):lower() == 'bank' and r.iban ~= nil then iban = tostring(r.iban) break end
            end
        end
        return { iban = iban, frozen = call('wasabi_banking', 'IsAccountFrozen', 'bank', cid) == true }
    end,
    record = function(cid, description, amount, src)
        local ok = PI.callExport('wasabi_banking', 'Transaction', cid, tostring(description), math.abs(amount), amount < 0 and 'sent' or 'deposit', 'personal')
        return ok == true
    end,
})

-- crm-banking (crm-scripts docs): getPlayerAccounts(owner) -> rows { crm_iban, crm_type, crm_balance, ... } ·
-- isAccountFrozen(iban) · addTransaction({ crm_sender, crm_receiver, crm_amount, crm_type, crm_description })
local function crmPersonal(cid)
    local rows = call('crm-banking', 'getPlayerAccounts', cid)
    if type(rows) ~= 'table' then return nil end
    local pick
    for _, r in ipairs(rows) do
        if type(r) == 'table' and r.crm_iban ~= nil then
            local t = tostring(r.crm_type or ''):lower()
            if t:find('saving', 1, true) == nil and t:find('shared', 1, true) == nil then return r end
            pick = pick or r
        end
    end
    return pick
end
PI.define('bank', 'crm-banking', {
    label = 'crm-banking', resources = { 'crm-banking' }, verified = false,
    info = function(src, cid)
        local a = crmPersonal(cid)
        if not a then return { noAccount = true } end
        return { iban = tostring(a.crm_iban), frozen = call('crm-banking', 'isAccountFrozen', a.crm_iban) == true }
    end,
    record = function(cid, description, amount, src)
        local a = crmPersonal(cid)
        if not a then return false end
        local ok, r = PI.callExport('crm-banking', 'addTransaction', {
            crm_sender = amount < 0 and a.crm_iban or nil, crm_receiver = amount > 0 and a.crm_iban or nil,
            crm_amount = math.abs(amount), crm_type = amount < 0 and 'crm-withdraw' or 'crm-deposit', crm_description = tostring(description),
        })
        return ok == true and r ~= false
    end,
})

-- snipe-banking (docs): IsAccountFrozenForIdentifier(identifier) · CreatePersonalTransactions(identifier, amount, memo,
-- 'deposit'|'withdraw'|'transfer', otherIdentifier, isJob) = statement line (its money exports do not log)
PI.define('bank', 'snipe-banking', {
    label = 'snipe-banking', resources = { 'snipe-banking' }, verified = false,
    info = function(src, cid)
        return { frozen = call('snipe-banking', 'IsAccountFrozenForIdentifier', cid) == true }
    end,
    record = function(cid, description, amount, src)
        local ok = PI.callExport('snipe-banking', 'CreatePersonalTransactions', cid, math.abs(amount), tostring(description), amount < 0 and 'withdraw' or 'deposit', nil, false)
        return ok == true
    end,
})

-- nfs-banking (docs.nfs: banking-script configuration, server exports): getPlayerMainCardIban(source | cid) -> iban | nil
-- · getCardByIban(iban) -> { iban, balance, freeze, ... } · registerTransaction(iban, amount, note, 'receive'|'send', name)
-- (statement line only). Its card balance is not documented as the framework money, so it is not used as the balance.
PI.define('bank', 'nfs-banking', {
    label = 'nfs-banking', resources = { 'nfs-banking' }, verified = false,
    info = function(src, cid)
        local iban = call('nfs-banking', 'getPlayerMainCardIban', cid)
        if type(iban) ~= 'string' or iban == '' then return { noAccount = true } end
        local card = call('nfs-banking', 'getCardByIban', iban)
        return { iban = iban, frozen = type(card) == 'table' and card.freeze == true }
    end,
    record = function(cid, description, amount, src)
        local iban = call('nfs-banking', 'getPlayerMainCardIban', cid)
        if type(iban) ~= 'string' or iban == '' then return false end
        local ok = PI.callExport('nfs-banking', 'registerTransaction', iban, math.abs(amount), tostring(description),
            amount < 0 and 'send' or 'receive', PI.nameOf(cid) or tostring(cid))
        return ok == true
    end,
})

-- ------------------------------------------------------------
-- esx_banking (VERIFIED against esx-framework ESX-Legacy-Addons esx_banking, server/main.lua + banking.sql)
--   table banking(ID, identifier, type, amount ABS, time BIGINT ms, balance, label); its UI reads it straight from the
--   DB (no cache), newest first. Types it writes: DEPOSIT / WITHDRAW / TRANSFER (out) / TRANSFER_RECEIVE (in).
--   export logTransaction(playerSource, label, TYPE, amount): online players only (it needs the xPlayer); for an
--   offline player the row is written with the same columns. No IBAN in esx_banking.
-- ------------------------------------------------------------
local ESXB_IN = { DEPOSIT = true, TRANSFER_RECEIVE = true, PAYCHECK = true, SALARY = true, INCOME = true, RECEIVE = true, REFUND = true }
local function esxbIncoming(kind)
    kind = tostring(kind or ''):upper()
    if ESXB_IN[kind] then return true end
    return kind:find('RECEIVE', 1, true) ~= nil or kind:find('_IN', -3, true) ~= nil
end

PI.define('bank', 'esx_banking', {
    label = 'esx_banking',
    -- the official one has the logTransaction export; the unrelated "esx_banking 2.0.0" (HiHowdy) has no export and
    -- no `banking` table: it is not taken (the Wallet stays on builtin = framework balance only)
    detect = function()
        if FW.name ~= 'esx' or not PI.started('esx_banking') then return false end
        local ok, fn = pcall(function() return exports['esx_banking'].logTransaction end)
        return ok and fn ~= nil
    end,
    history = function(src, cid)
        local out = {}
        for i, t in ipairs(q('SELECT ID, label, type, amount, time FROM banking WHERE identifier = ? ORDER BY time DESC LIMIT 60', { cid })) do
            local amt = math.abs(PI.num(t.amount) or 0)
            local label = (t.label ~= nil and tostring(t.label) ~= '' and tostring(t.label):upper() ~= tostring(t.type or ''):upper()) and tostring(t.label) or tostring(t.type or 'Banco')
            out[#out + 1] = { id = t.ID or i, description = label, amount = esxbIncoming(t.type) and amt or -amt, created = t.time }
        end
        return out
    end,
    record = function(cid, description, amount, src)
        local kind = amount < 0 and 'TRANSFER' or 'TRANSFER_RECEIVE'
        local label = tostring(description):gsub('[%c\r\n]', ' '):sub(1, 80)
        local p = src and FW.GetPlayer(src) or nil
        if p and p.cid == cid then
            local ok = PI.callExport('esx_banking', 'logTransaction', src, label, kind, math.abs(amount))
            return ok == true
        end
        local bal = 0
        pcall(function()
            local row = MySQL.single.await('SELECT accounts FROM users WHERE identifier = ? LIMIT 1', { cid })
            bal = math.floor(PI.num(PI.decode(row and row.accounts).bank) or 0)
        end)
        local ok = pcall(function()
            MySQL.insert.await('INSERT INTO banking (identifier, label, type, amount, time, balance) VALUES (?, ?, ?, ?, ?, ?)',
                { cid, label, kind, math.abs(amount), os.time() * 1000, bal })
        end)
        return ok
    end,
})
