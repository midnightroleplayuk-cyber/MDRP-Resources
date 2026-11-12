Ledger = {}

local ACCOUNTS = { clean = true, dirty = true }

function Ledger.GetBalance(gangId, account)
    return MySQL.scalar.await('SELECT balance FROM vg_accounts WHERE gang_id = ? AND account = ?', { gangId, account }) or 0
end

---Atomic credit (positive) or debit (negative). Debits fail rather than going below zero.
---@param opts? { citizenid?:string, refType?:string, refId?:string|number, note?:string }
---@return boolean ok, number|string balanceOrError
function Ledger.Transact(gangId, account, amount, txType, opts)
    opts = opts or {}
    amount = math.floor(tonumber(amount) or 0)
    if amount == 0 or not ACCOUNTS[account] or not Gangs.Get(gangId) then
        return false, 'invalid'
    end

    local affected = MySQL.update.await(
        'UPDATE vg_accounts SET balance = balance + ? WHERE gang_id = ? AND account = ? AND balance + ? >= 0',
        { amount, gangId, account, amount }
    )
    if affected == 0 then return false, 'insufficient_funds' end

    local balance = Ledger.GetBalance(gangId, account)
    local flagged = math.abs(amount) >= Config.Ledger.flagThreshold

    -- NULLIF('', ...) is used instead of passing nil, which can leave holes in the parameter array
    local txId = MySQL.insert.await([[
        INSERT INTO vg_transactions
            (gang_id, account, amount, balance_after, type, citizenid, reference_type, reference_id, note, flagged)
        VALUES (?, ?, ?, ?, ?, NULLIF(?, ''), NULLIF(?, ''), NULLIF(?, ''), NULLIF(?, ''), ?)
    ]], {
        gangId, account, amount, balance, txType,
        opts.citizenid or '', opts.refType or '', tostring(opts.refId or ''), opts.note or '',
        flagged and 1 or 0,
    })

    if flagged then
        TriggerEvent('vinewood_gangs:server:transactionFlagged', gangId, txId, account, amount, txType)
        local g = Gangs and Gangs.Get and Gangs.Get(gangId)
        Logger.Log(nil, 'ledger_flagged', ('Large %s movement for %s: %s%s (%s)'):format(account, g and g.label or ('gang ' .. tostring(gangId)),
            amount < 0 and '-' or '+', Utils.FormatMoney(math.abs(amount)), tostring(txType)))
    end

    return true, balance
end

-- TODO (phase 1): history paging for the tablet, wage payouts
-- TODO (phase 2): debts, laundering through front businesses

local function validAmount(amount)
    amount = math.floor(tonumber(amount) or 0)
    if amount <= 0 or amount > Config.Ledger.maxTransaction then return nil end
    return amount
end

function Ledger.Deposit(src, amount)
    local gang, _, cid = Gangs.GetPlayerGang(src)
    if not gang then return false, 'not_in_gang' end
    if not Gangs.HasPermission(cid, 'treasury_deposit') then return false, 'no_permission' end
    amount = validAmount(amount)
    if not amount then return false, 'invalid_amount' end

    if not Bridge.RemoveMoney(src, 'cash', amount, 'gang-deposit') then return false, 'insufficient_funds' end
    local ok, res = Ledger.Transact(gang.id, 'clean', amount, 'deposit', { citizenid = cid })
    if not ok then
        Bridge.AddMoney(src, 'cash', amount, 'gang-deposit-refund')
        return false, res
    end
    Logger.Log(src, 'treasury_deposit', ('%s deposited %d to gang %d'):format(cid, amount, gang.id))
    return true
end

function Ledger.Withdraw(src, amount)
    local gang, _, cid = Gangs.GetPlayerGang(src)
    if not gang then return false, 'not_in_gang' end
    if not Gangs.HasPermission(cid, 'treasury_withdraw') then return false, 'no_permission' end
    amount = validAmount(amount)
    if not amount then return false, 'invalid_amount' end

    -- Debit the treasury first so two members can't withdraw the same money
    local ok, res = Ledger.Transact(gang.id, 'clean', -amount, 'withdrawal', { citizenid = cid })
    if not ok then return false, res end
    if not Bridge.AddMoney(src, 'cash', amount, 'gang-withdrawal') then
        Ledger.Transact(gang.id, 'clean', amount, 'withdrawal_reversed', { citizenid = cid })
        return false, 'failed'
    end
    Logger.Log(src, 'treasury_withdraw', ('%s withdrew %d from gang %d'):format(cid, amount, gang.id))
    return true
end

---Dirty money from a member's pockets (drug sales and so on) into the dirty treasury.
function Ledger.DepositDirty(src, amount)
    local gang, _, cid = Gangs.GetPlayerGang(src)
    if not gang then return false, 'not_in_gang' end
    if not Gangs.HasPermission(cid, 'treasury_deposit') then return false, 'no_permission' end
    amount = validAmount(amount)
    if not amount then return false, 'invalid_amount' end
    if not Bridge.RemoveDirtyMoney(src, amount, 'gang-deposit') then return false, 'insufficient_dirty' end
    local ok, res = Ledger.Transact(gang.id, 'dirty', amount, 'deposit', { citizenid = cid })
    if not ok then
        Bridge.AddDirtyMoney(src, amount, 'gang-deposit-refund')
        return false, res
    end
    Logger.Log(src, 'treasury_deposit_dirty', ('%s deposited %d dirty to gang %d'):format(cid, amount, gang.id))
    return true
end

---Dirty money out of the treasury into a member's pockets (as dirty money).
function Ledger.WithdrawDirty(src, amount)
    local gang, _, cid = Gangs.GetPlayerGang(src)
    if not gang then return false, 'not_in_gang' end
    if not Gangs.HasPermission(cid, 'treasury_withdraw') then return false, 'no_permission' end
    amount = validAmount(amount)
    if not amount then return false, 'invalid_amount' end
    local ok, res = Ledger.Transact(gang.id, 'dirty', -amount, 'withdrawal', { citizenid = cid })
    if not ok then return false, res end
    if not Bridge.AddDirtyMoney(src, amount, 'gang-withdrawal') then
        Ledger.Transact(gang.id, 'dirty', amount, 'withdrawal_reversed', { citizenid = cid })
        return false, 'drugs_pockets_full'
    end
    Logger.Log(src, 'treasury_withdraw_dirty', ('%s withdrew %d dirty from gang %d'):format(cid, amount, gang.id))
    return true
end

---What the member carrying it has, for the Treasury screen.
function Ledger.PocketDirty(src) return Bridge.GetDirtyMoney(src) or 0 end

function Ledger.History(gangId, limit)
    return MySQL.query.await([[
        SELECT t.id, t.account, t.amount, t.type, UNIX_TIMESTAMP(t.created_at) AS ts,
            CASE WHEN t.citizenid IS NULL THEN NULL ELSE COALESCE(m.name, 'Former member') END AS name
        FROM vg_transactions t
        LEFT JOIN vg_members m ON m.citizenid = t.citizenid
        WHERE t.gang_id = ?
        ORDER BY t.id DESC
        LIMIT ?
    ]], { gangId, limit or 25 }) or {}
end
