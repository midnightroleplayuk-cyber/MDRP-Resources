-- ------------------------------------------------------------
-- INTEGRATIONS / SOCIETY (INTEG2): company / job accounts ("conta da empresa"). Used wherever the phone pays a
-- company: bills issued on behalf of a job (Bills app, the billing module of the job apps, police fines through
-- the CreateBill export) when they are paid, Eats restaurant payouts, and any other caller of FW.AddSocietyMoney.
--
--   provider: balance(job) -> number | nil (nil = unknown, the builtin answers)
--             add(job, amount, reason)    -> true | false, why
--             remove(job, amount, reason) -> true | false, why   (must refuse when the account has not enough money)
--   why: 'noaccount' / 'unavailable' = NOTHING moved and the account does not exist there: the builtin is tried
--        anything else ('funds', 'failed', 'error', ...) = no fallback (an error inside another resource may have
--        moved the money already: a second attempt elsewhere could pay twice)
--   A provider that THROWS (missing export, stopped resource) has not moved anything either: builtin + 1 warning.
--
-- builtin = what the phone did before this layer: the ORIGINAL FW.GetSocietyMoney / FW.AddSocietyMoney from
-- server/framework.lua (Config.SocietyProvider: qb-banking, qb-management, Renewed-Banking, esx_addonaccount).
-- This file then re-points FW.GetSocietyMoney / FW.AddSocietyMoney (same signature and return) and adds
-- FW.RemoveSocietyMoney, so every existing caller goes through the dispatcher without being edited.
--
-- Exact amounts: the phone only moves whole euros (amount is an integer > 0 here).
-- verified = false: written from the vendor's docs (encrypted resource), not run against the real resource.
-- ------------------------------------------------------------
local PI = PhoneIntegrations
if not PI then return end   -- server/integrations.lua did not load: server/integrations/escrow_check.lua says why in the console

-- the originals from server/framework.lua (loaded before this file). Kept once, even if this chunk ran twice.
PI.fwSociety = PI.fwSociety or { get = FW.GetSocietyMoney, add = FW.AddSocietyMoney }
local ORIG = PI.fwSociety

local SAFE = { noaccount = true, unavailable = true }

-- Call an export of another resource in two steps. The INDEX is checked first: a missing export (old/renamed
-- version) or a stopped resource RAISES here, before anything happened, so the dispatcher may safely use the
-- builtin. An error INSIDE the export returns false, 'error' (it may have moved money: never retried elsewhere).
-- Returns true, ret1, ret2, ... on success.
local function ex(res, name, ...)
    if not PI.started(res) then error(('%s is not started'):format(res), 0) end
    local okI, fn = pcall(function() return exports[res][name] end)
    if not okI or fn == nil then error(('%s has no export %s'):format(res, name), 0) end
    local args = table.pack(...)
    local r = table.pack(pcall(function() return fn(exports[res], table.unpack(args, 1, args.n)) end))
    if not r[1] then
        PI.warnOnce('soc_ex_' .. res .. name, ('society: %s:%s raised (%s)'):format(res, name, tostring(r[2])))
        return false, 'error'
    end
    return true, table.unpack(r, 2, r.n)
end

local function hasExport(res, name)
    if not PI.started(res) then return false end
    local ok, fn = pcall(function() return exports[res][name] end)
    return ok and fn ~= nil
end

local function major(res)
    local v = GetResourceMetadata(res, 'version', 0)
    return type(v) == 'string' and tonumber(v:match('^%s*v?(%d+)')) or nil
end

local function int(n) n = PI.num(n) return n and math.floor(n) or nil end

-- ------------------------------------------------------------
-- builtin: the phone's behaviour before this layer (server/framework.lua, Config.SocietyProvider)
-- ------------------------------------------------------------
PI.defineBuiltin('society', {
    label = 'Config.SocietyProvider (qb-banking / qb-management / Renewed-Banking / esx_addonaccount)',
    balance = function(job)
        if not ORIG.get then return 0 end
        return int(ORIG.get(job)) or 0
    end,
    add = function(job, amount, reason)
        if not ORIG.add then return false, 'unavailable' end
        return ORIG.add(job, amount, reason) == true
    end,
    remove = function(job, amount, reason)
        if not (ORIG.add and ORIG.get) then return false, 'unavailable' end
        -- esx_addonaccount and qb-banking 2.x do not check the balance themselves: checked here, and nothing
        -- yields between this read and the debit (both are synchronous calls)
        if (int(ORIG.get(job)) or 0) < amount then return false, 'funds' end
        return ORIG.add(job, -amount, reason) == true
    end,
})

-- ------------------------------------------------------------
-- apex_bossmenu (VERIFIED against apex_bossmenu 2.5.0, build/server/exports.lua + modules/treasury.lua)
--   GetTreasury(job) -> number · AddTreasury(job, amount) -> balance | false · RemoveTreasury(job, amount) -> balance | false
--   With Config.treasury.societyIsSourceOfTruth the treasury IS the framework society account (it re-reads it and
--   verifies every move); otherwise its own pool (mirrored to the society). RemoveTreasury refuses without funds.
--   The move is written to its treasury history (Log export, category 'treasury') so the boss sees it.
-- ------------------------------------------------------------
local function bossLog(job, action, amount, reason)
    pcall(ex, 'apex_bossmenu', 'Log', 'treasury', { job = job, action = action, actor = 'Phone', amount = amount,
        details = { reason = tostring(reason or 'apex_phone'), via = 'apex_phone' } })
end

PI.define('society', 'apex_bossmenu', {
    label = 'apex_bossmenu (treasury)', resources = { 'apex_bossmenu' },
    balance = function(job)
        local ok, v = ex('apex_bossmenu', 'GetTreasury', job)
        return ok and int(v) or nil
    end,
    add = function(job, amount, reason)
        local ok, r = ex('apex_bossmenu', 'AddTreasury', job, amount)
        if not ok then return false, 'error' end
        if r == false or r == nil then return false, 'failed' end
        bossLog(job, 'deposit', amount, reason)
        return true
    end,
    remove = function(job, amount, reason)
        local ok, r = ex('apex_bossmenu', 'RemoveTreasury', job, amount)
        if not ok then return false, 'error' end
        if r == false or r == nil then return false, 'funds' end
        bossLog(job, 'withdraw', amount, reason)
        return true
    end,
})

-- ------------------------------------------------------------
-- Renewed-Banking (VERIFIED against Renewed-Banking main, server/main.lua)
--   getAccountMoney(account) -> amount | false (no such account) · addAccountMoney(account, amount) -> true | false
--   removeAccountMoney(account, amount) -> false when the account is missing OR has not enough money
--   handleTransaction(account, title, amount, message, issuer, receiver, 'deposit'|'withdraw') = the account history.
--   Job and gang accounts are created by Renewed-Banking itself for every framework job/gang at start.
-- ------------------------------------------------------------
local function renewedLog(job, amount, reason, kind)
    pcall(ex, 'Renewed-Banking', 'handleTransaction', job, 'Phone', amount + 0.0, tostring(reason or 'apex_phone'),
        kind == 'deposit' and 'Phone' or job, kind == 'deposit' and job or 'Phone', kind)
end

PI.define('society', 'Renewed-Banking', {
    label = 'Renewed-Banking (job accounts)', resources = { 'Renewed-Banking' },
    balance = function(job)
        local ok, v = ex('Renewed-Banking', 'getAccountMoney', job)
        if not ok or v == false then return nil end
        return int(v)
    end,
    add = function(job, amount, reason)
        local okB, v = ex('Renewed-Banking', 'getAccountMoney', job)
        if okB and v == false then return false, 'noaccount' end
        local ok, r = ex('Renewed-Banking', 'addAccountMoney', job, amount)
        if not ok then return false, 'error' end
        if r ~= true then return false, 'failed' end
        renewedLog(job, amount, reason, 'deposit')
        return true
    end,
    remove = function(job, amount, reason)
        local okB, v = ex('Renewed-Banking', 'getAccountMoney', job)
        if okB and v == false then return false, 'noaccount' end
        if okB and (int(v) or 0) < amount then return false, 'funds' end
        local ok, r = ex('Renewed-Banking', 'removeAccountMoney', job, amount)
        if not ok then return false, 'error' end
        if r ~= true then return false, 'funds' end
        renewedLog(job, amount, reason, 'withdraw')
        return true
    end,
})

-- ------------------------------------------------------------
-- qb-banking 2.x (VERIFIED against qb-banking 2.0.0, server.lua): job accounts live in its in-memory Accounts
--   (bank_accounts, account_type 'job'). GetAccount(name) -> table | nil · GetAccountBalance(name) -> number (0 when
--   missing) · AddMoney(name, amount, reason) / RemoveMoney(name, amount, reason) -> false when the account is missing.
--   RemoveMoney does NOT check the balance: checked here first (no yield between the read and the debit).
--   Both write the account statement themselves (bank_statements).
-- ------------------------------------------------------------
local function qbbAccount(job)
    local ok, acc = ex('qb-banking', 'GetAccount', job)
    if not ok then return nil, 'error' end
    if type(acc) ~= 'table' then return nil, 'noaccount' end
    return acc
end

PI.define('society', 'qb-banking', {
    label = 'qb-banking 2.x (job accounts)',
    detect = function() return PI.started('qb-banking') and (major('qb-banking') or 0) >= 2 end,
    balance = function(job)
        local acc = qbbAccount(job)
        return acc and int(acc.account_balance) or nil
    end,
    add = function(job, amount, reason)
        local acc, why = qbbAccount(job)
        if not acc then return false, why end
        local ok, r = ex('qb-banking', 'AddMoney', job, amount, tostring(reason or 'apex_phone'):sub(1, 50))
        if not ok then return false, 'error' end
        if r == false or r == nil then return false, 'failed' end
        return true
    end,
    remove = function(job, amount, reason)
        local acc, why = qbbAccount(job)
        if not acc then return false, why end
        if (int(acc.account_balance) or 0) < amount then return false, 'funds' end
        local ok, r = ex('qb-banking', 'RemoveMoney', job, amount, tostring(reason or 'apex_phone'):sub(1, 50))
        if not ok then return false, 'error' end
        if r == false or r == nil then return false, 'failed' end
        return true
    end,
})

-- ------------------------------------------------------------
-- qb-management with money (VERIFIED against qb-management 2.1.2, the last version before the money moved to
-- qb-banking 2.x; fxmanifest server_exports GetAccount / AddMoney / RemoveMoney). Detected by the EXPORT, not the
-- version: qb-management 2.2+ has no money exports at all (then qb-banking 2.x holds the society money).
--   GetAccount(job) -> number (0 when unknown) · AddMoney(job, amount) -> nothing (creates the account)
--   RemoveMoney(job, amount) -> true | false (refuses without funds). Cached in memory, saved to management_funds.
-- ------------------------------------------------------------
PI.define('society', 'qb-management', {
    label = 'qb-management (management_funds)',
    detect = function() return hasExport('qb-management', 'GetAccount') and hasExport('qb-management', 'AddMoney') end,
    balance = function(job)
        local ok, v = ex('qb-management', 'GetAccount', job)
        return ok and int(v) or nil
    end,
    add = function(job, amount, reason)
        local ok, r = ex('qb-management', 'AddMoney', job, amount)
        if not ok then return false, 'error' end
        return r ~= false
    end,
    remove = function(job, amount, reason)
        local ok, r = ex('qb-management', 'RemoveMoney', job, amount)
        if not ok then return false, 'error' end
        if r ~= true then return false, 'funds' end
        return true
    end,
})

-- ------------------------------------------------------------
-- okokBanking (DOCS: docs.okokscripts.io okokBankingV2 exports GetAccount(society) / AddMoney(society, value) /
-- RemoveMoney(society, value); table okokbanking_societies(society, society_name, value, iban, ...)). verified = false.
-- Its society key is read from okokbanking_societies (the job name, or 'society_<job>' on servers that kept the
-- addon-account names). Not there = okokBanking is configured to keep societies elsewhere (Config.SocietyResource =
-- esx_addonaccount / qb-banking / qb-management): 'noaccount', so the builtin (that same resource) is used.
-- ------------------------------------------------------------
local function okokSociety(job)
    local rows = MySQL.query.await('SELECT society, value FROM okokbanking_societies WHERE society = ? OR society = ? LIMIT 2', { job, 'society_' .. job })
    if type(rows) ~= 'table' then return nil end
    local pick
    for _, r in ipairs(rows) do
        if r.society == job then pick = r break end
        pick = pick or r
    end
    return pick and pick.society or nil
end

local function okokBalance(name)
    local ok, v = ex('okokBanking', 'GetAccount', name)
    if not ok then return nil end
    if type(v) == 'table' then v = v.value or v.balance or v.money end
    return int(v)
end

PI.define('society', 'okokBanking', {
    label = 'okokBanking (okokbanking_societies)', verified = false,
    -- wasabi_banking / lwk_bank can `provide 'okokBanking'`: then they are the real bank (bank.lua PI.okokReal)
    detect = function()
        if PI.okokReal then return PI.okokReal() end
        return PI.started('okokBanking') and not PI.started('wasabi_banking') and not PI.started('lwk_bank')
    end,
    balance = function(job)
        local name = okokSociety(job)
        return name and okokBalance(name) or nil
    end,
    add = function(job, amount, reason)
        local name = okokSociety(job)
        if not name then return false, 'noaccount' end
        local ok, r = ex('okokBanking', 'AddMoney', name, amount)
        if not ok then return false, 'error' end
        return r ~= false
    end,
    remove = function(job, amount, reason)
        local name = okokSociety(job)
        if not name then return false, 'noaccount' end
        if (okokBalance(name) or 0) < amount then return false, 'funds' end
        local ok, r = ex('okokBanking', 'RemoveMoney', name, amount)
        if not ok then return false, 'error' end
        if r == false then return false, 'funds' end
        return true
    end,
})

-- ------------------------------------------------------------
-- tgg-banking (DOCS: GetSocietyAccountMoney(society) -> number | nil (no account), AddSocietyMoney(society, amount)
-- -> boolean, RemoveSocietyMoney(society, amount) -> boolean, AddTransaction(toIban|society, fromIban|society,
-- type, amount, description) for the account history). verified = false.
-- ------------------------------------------------------------
local function tggLog(job, amount, reason, kind)
    if kind == 'deposit' then
        pcall(ex, 'tgg-banking', 'AddTransaction', job, nil, 'deposit', amount, tostring(reason or 'apex_phone'))
    else
        pcall(ex, 'tgg-banking', 'AddTransaction', nil, job, 'withdraw', amount, tostring(reason or 'apex_phone'))
    end
end

PI.define('society', 'tgg-banking', {
    label = 'tgg-banking (society accounts)', resources = { 'tgg-banking' }, verified = false,
    balance = function(job)
        local ok, v = ex('tgg-banking', 'GetSocietyAccountMoney', job)
        return ok and int(v) or nil
    end,
    add = function(job, amount, reason)
        local okB, v = ex('tgg-banking', 'GetSocietyAccountMoney', job)
        if okB and v == nil then return false, 'noaccount' end
        local ok, r = ex('tgg-banking', 'AddSocietyMoney', job, amount)
        if not ok then return false, 'error' end
        if r ~= true then return false, 'failed' end
        tggLog(job, amount, reason, 'deposit')
        return true
    end,
    remove = function(job, amount, reason)
        local okB, v = ex('tgg-banking', 'GetSocietyAccountMoney', job)
        if okB and v == nil then return false, 'noaccount' end
        if okB and (int(v) or 0) < amount then return false, 'funds' end
        local ok, r = ex('tgg-banking', 'RemoveSocietyMoney', job, amount)
        if not ok then return false, 'error' end
        if r ~= true then return false, 'funds' end
        tggLog(job, amount, reason, 'withdraw')
        return true
    end,
})

-- ------------------------------------------------------------
-- Banking resources with a plain "society = job name" API, all verified = false (encrypted / paid; written from the
-- vendor's public docs, and for kartik / wasabi / tgiann from the open community_bridge banking adapters). Their
-- return values and insufficient-funds rules are not documented, so the phone is defensive:
--   balance nil / false = no account there ('noaccount': nothing moved, the builtin is used)
--   remove: the balance is checked FIRST; add/remove succeed unless the export raises or returns false
--   fd_banking  (docs.felis.gg/banking/exports, "qb-management equivalent exports"):
--               GetAccount(society) · AddMoney(society, amount, reason) · RemoveMoney(society, amount, reason)
--   qs-banking  (Quasar Banking Creator developer API): GetSocietyMoney(job) · AddSocietyMoney(job, amount, reason)
--               · RemoveSocietyMoney(job, amount, reason)   (own table, accounts auto-created on first use)
--   kartik-banking: GetAccountMoney(account) · AddAccountMoney(account, amount, reason) · RemoveAccountMoney(...)
--   wasabi_banking: GetAccountBalance(account, 'society') · AddMoney('society', account, amount) · RemoveMoney('society', account, amount)
--   tgiann-bank : GetJobAccountBalance(job) · AddJobMoney(job, amount) · RemoveJobMoney(job, amount)
-- ------------------------------------------------------------
--   crm-banking (docs.crm-scripts): getSocietyMoney(job) -> number | nil · addSocietyMoney / removeSocietyMoney(job, amount)
--               -> boolean · addSocietyTransaction(job, amount, type, description) for its history
--   snipe-banking (docs): GetAccountBalance(job) · AddMoneyToAccount(job, amount) · RemoveMoneyFromAccount(job, amount)
--               (they do NOT write a statement line: CreateJobTransactions(job, amount, memo, type, identifier) does)
local function simpleSociety(id, label, get, add, rem, log)
    PI.define('society', id, {
        label = label, resources = { id }, verified = false,
        balance = function(job)
            local ok, v = get(job)
            if not ok or v == nil or v == false then return nil end
            if type(v) == 'table' then v = v.balance or v.amount or v.money or v.value end
            return int(v)
        end,
        add = function(job, amount, reason)
            local okB, v = get(job)
            if okB and (v == nil or v == false) then return false, 'noaccount' end
            local ok, r = add(job, amount, tostring(reason or 'apex_phone'))
            if not ok then return false, 'error' end
            if r == false then return false, 'failed' end
            if log then pcall(log, job, amount, tostring(reason or 'apex_phone'), 'deposit') end
            return true
        end,
        remove = function(job, amount, reason)
            local okB, v = get(job)
            if okB and (v == nil or v == false) then return false, 'noaccount' end
            if type(v) == 'table' then v = v.balance or v.amount or v.money or v.value end
            if not okB or (int(v) or 0) < amount then return false, 'funds' end
            local ok, r = rem(job, amount, tostring(reason or 'apex_phone'))
            if not ok then return false, 'error' end
            if r == false then return false, 'funds' end
            if log then pcall(log, job, amount, tostring(reason or 'apex_phone'), 'withdraw') end
            return true
        end,
    })
end

simpleSociety('fd_banking', 'fd_banking (society accounts)',
    function(job) return ex('fd_banking', 'GetAccount', job) end,
    function(job, n, why) return ex('fd_banking', 'AddMoney', job, n, why) end,
    function(job, n, why) return ex('fd_banking', 'RemoveMoney', job, n, why) end)

simpleSociety('qs-banking', 'qs-banking (society accounts)',
    function(job) return ex('qs-banking', 'GetSocietyMoney', job) end,
    function(job, n, why) return ex('qs-banking', 'AddSocietyMoney', job, n, why) end,
    function(job, n, why) return ex('qs-banking', 'RemoveSocietyMoney', job, n, why) end)

simpleSociety('kartik-banking', 'kartik-banking (society accounts)',
    function(job) return ex('kartik-banking', 'GetAccountMoney', job) end,
    function(job, n, why) return ex('kartik-banking', 'AddAccountMoney', job, n, why) end,
    function(job, n, why) return ex('kartik-banking', 'RemoveAccountMoney', job, n, why) end)

simpleSociety('wasabi_banking', 'wasabi_banking (society accounts)',
    function(job) return ex('wasabi_banking', 'GetAccountBalance', job, 'society') end,
    function(job, n) return ex('wasabi_banking', 'AddMoney', 'society', job, n) end,
    function(job, n) return ex('wasabi_banking', 'RemoveMoney', 'society', job, n) end)

simpleSociety('tgiann-bank', 'tgiann-bank (job accounts)',
    function(job) return ex('tgiann-bank', 'GetJobAccountBalance', job) end,
    function(job, n) return ex('tgiann-bank', 'AddJobMoney', job, n) end,
    function(job, n) return ex('tgiann-bank', 'RemoveJobMoney', job, n) end)

simpleSociety('crm-banking', 'crm-banking (society accounts)',
    function(job) return ex('crm-banking', 'getSocietyMoney', job) end,
    function(job, n) return ex('crm-banking', 'addSocietyMoney', job, n) end,
    function(job, n) return ex('crm-banking', 'removeSocietyMoney', job, n) end,
    function(job, n, why, kind) return ex('crm-banking', 'addSocietyTransaction', job, n, kind == 'deposit' and 'crm-deposit' or 'crm-withdraw', why) end)

simpleSociety('snipe-banking', 'snipe-banking (job accounts)',
    function(job) return ex('snipe-banking', 'GetAccountBalance', job) end,
    function(job, n) return ex('snipe-banking', 'AddMoneyToAccount', job, n) end,
    function(job, n) return ex('snipe-banking', 'RemoveMoneyFromAccount', job, n) end,
    function(job, n, why, kind) return ex('snipe-banking', 'CreateJobTransactions', job, n, why, kind, job, nil, true) end)

-- ------------------------------------------------------------
-- esx_addonaccount (+ esx_society) (VERIFIED against the esx_addonaccount / esx_society shipped with ESX Legacy)
--   The money is the shared addon account 'society_<job>' (esx_society registers each society with its .account
--   name: read through its GetSociety export when it is started). getSharedAccount(name, cb) answers synchronously
--   with the cached account; addMoney / removeMoney save it at once. removeMoney does NOT check the balance:
--   checked here, in the same synchronous callback (nothing can run between the check and the debit).
-- ------------------------------------------------------------
local function esxAccountName(job)
    if hasExport('esx_society', 'GetSociety') then
        local ok, s = ex('esx_society', 'GetSociety', job)
        if ok and type(s) == 'table' and type(s.account) == 'string' and s.account ~= '' then return s.account end
    end
    return 'society_' .. job
end

local function esxShared(job, fn)
    local name = esxAccountName(job)
    local found, res, why = false, false, nil
    TriggerEvent('esx_addonaccount:getSharedAccount', name, function(acc)
        if type(acc) ~= 'table' then return end
        found = true
        res, why = fn(acc)
    end)
    if not found then return false, 'noaccount' end
    return res, why
end

PI.define('society', 'esx_addonaccount', {
    label = 'esx_society / esx_addonaccount (society_<job>)', resources = { 'esx_addonaccount' },
    balance = function(job)
        local v
        local ok = esxShared(job, function(acc) v = int(acc.money) return true end)
        return ok and v or nil
    end,
    add = function(job, amount, reason)
        return esxShared(job, function(acc)
            if not PI.isCallable(acc.addMoney) then return false, 'unavailable' end
            acc.addMoney(amount)
            return true
        end)
    end,
    remove = function(job, amount, reason)
        return esxShared(job, function(acc)
            if not PI.isCallable(acc.removeMoney) then return false, 'unavailable' end
            if (int(acc.money) or 0) < amount then return false, 'funds' end
            acc.removeMoney(amount)
            return true
        end)
    end,
})

-- ------------------------------------------------------------
-- Dispatcher entry points + the FW society functions re-pointed to them
-- ------------------------------------------------------------
PhoneSociety = PhoneSociety or {}
local S = PhoneSociety

local function jobName(job)
    if job == nil then return nil end
    job = tostring(job)
    if job == '' or job == 'unemployed' then return nil end
    return job
end

local function posInt(v)
    local n = PI.num(v)
    if not n then return nil end
    n = math.floor(n)
    if n <= 0 then return nil end
    return math.tointeger(n) or n
end

-- runs fnName on the active provider; builtin when there is none, when it throws, or when it says the account
-- does not exist there (SAFE reasons). Any other failure is final.
local function run(fnName, job, amount, reason)
    local def, id = Integration('society')
    local B = PI.builtin.society
    if id ~= 'builtin' and def and PI.isCallable(def[fnName]) then
        local ok, r, why = IntegrationTry('society', fnName, job, amount, reason)
        if ok then
            if fnName == 'balance' then
                local n = PI.num(r)
                if n then return math.floor(n) end
            elseif r ~= nil and r ~= false then
                PI.dbg('society %s %s %s %s -> ok', id, fnName, job, tostring(amount))
                return true
            elseif not SAFE[tostring(why)] then
                PI.dbg('society %s %s %s %s -> %s', id, fnName, job, tostring(amount), tostring(why))
                return false, (why ~= nil) and tostring(why) or 'failed'
            else
                PI.warnOnce('soc_fb_' .. id .. fnName .. tostring(why), ("society provider '%s' has no account for this job (%s): using the phone's built-in society behaviour for it"):format(id, tostring(why)))
            end
        end
    end
    local f = B and B[fnName]
    if not PI.isCallable(f) then return fnName == 'balance' and 0 or false end
    local okB, r, why = pcall(f, job, amount, reason)
    if not okB then
        PI.warnOnce('soc_builtin_' .. fnName, ('society builtin failed in %s (%s)'):format(fnName, tostring(r)))
        return fnName == 'balance' and 0 or false, 'error'
    end
    if fnName == 'balance' then return int(r) or 0 end
    if r ~= nil and r ~= false then return true end
    return false, why or 'failed'
end

function S.balance(job)
    job = jobName(job)
    if not job then return 0 end
    return run('balance', job)
end

function S.add(job, amount, reason)
    job, amount = jobName(job), posInt(amount)
    if not job or not amount then return false, 'invalid' end
    return run('add', job, amount, reason ~= nil and tostring(reason) or 'apex_phone')
end

function S.remove(job, amount, reason)
    job, amount = jobName(job), posInt(amount)
    if not job or not amount then return false, 'invalid' end
    return run('remove', job, amount, reason ~= nil and tostring(reason) or 'apex_phone')
end

-- Same contract as server/framework.lua: GetSocietyMoney(job) -> number; AddSocietyMoney(job, amount, reason):
-- amount > 0 deposits, < 0 withdraws, returns true/false. RemoveSocietyMoney(job, amount, reason) -> true/false.
function FW.GetSocietyMoney(job) return S.balance(job) end
function FW.AddSocietyMoney(job, amount, reason)
    local n = PI.num(amount)
    n = n and ((n < 0) and -math.floor(-n) or math.floor(n)) or 0
    if n > 0 then return (S.add(job, n, reason)) == true end
    if n < 0 then return (S.remove(job, -n, reason)) == true end
    return false
end
function FW.RemoveSocietyMoney(job, amount, reason) return (S.remove(job, amount, reason)) == true end

-- Config.SocietyProvider (older key, top of config.lua) forced to one resource or 'none': keep that exact
-- behaviour (= builtin) while Config.Integrations.society is left on 'auto'
do
    local legacy = rawget(Config, 'SocietyProvider')
    if type(Config.Integrations) == 'table' and type(legacy) == 'string' and legacy ~= '' and legacy ~= 'auto'
        and (Config.Integrations.society == nil or Config.Integrations.society == 'auto') then
        Config.Integrations.society = 'builtin'
    end
end
