if Sky.Config.banking ~= "wasabi" then return end
if not IsDuplicityVersion() then return end

local RESOURCE = "wasabi_banking"

local ACCOUNT_TYPES = { bank = true, savings = true, shared = true }

local function normalize_account_type(account_type)
    if account_type == "personal" then return "bank" end
    if not ACCOUNT_TYPES[account_type] then
        error("[banking/wasabi] Unsupported account type: " .. tostring(account_type))
    end
    return account_type
end

local function provider_account_key(account_type, account_id)
    if account_id == nil or tostring(account_id) == "" then
        error("[banking/wasabi] Account has no provider ID")
    end
    return normalize_account_type(account_type) .. ":" .. tostring(account_id)
end

local function parse_account_key(account_key)
    local account_type, account_id = tostring(account_key):match("^([^:]+):(.+)$")
    if not account_type or not account_id then
        error("[banking/wasabi] Invalid account key: " .. tostring(account_key))
    end
    return normalize_account_type(account_type), account_id
end

Sky.FW.SharedAccountCreationSupported = true
-- Completion is confirmed through Wasabi's public readback, not an assumed SQL layout.
-- Its exports do not provide an awaited insert or a unique fresh-creation receipt.
Sky.FW.SharedAccountCreationAwaited = false
Sky.FW.SharedAccountProvisioner = {
    resource = RESOURCE,
    freshCreationSupported = false,
    probe = function(name, kind)
        local result = { accountName = name, accountType = "society", canCreate = kind == "job" }
        if kind ~= "job" then
            result.status, result.error = "blocked", "account_creation_unsupported"
            return result
        end
        if Sky.Config.framework ~= "esx" and Sky.FW.GetGangs()[name] then
            result.status, result.error = "blocked", "account_type_collision"
            return result
        end
        local balance = exports[RESOURCE]:GetAccountBalance(name, "society")
        if balance == false then
            result.status = "missing"
        elseif type(balance) == "number" and balance > -math.huge and balance < math.huge then
            -- Wasabi documents false for absence; zero is an existing empty account.
            result.status, result.id = "existing", name
            result.persisted, result.loaded = true, true
        else
            result.status, result.error = "blocked", "account_provider_error"
            Sky.Debug("error", "[banking/wasabi] Account probe for '%s' returned an invalid balance: %s", name, tostring(balance))
        end
        return result
    end,
    create = function(name)
        local created = exports[RESOURCE]:CreateJobAccount(name, 0)
        if created ~= true then
            Sky.Debug("error", "[banking/wasabi] CreateJobAccount('%s') did not confirm creation: %s", name, tostring(created))
        end
        return created == true
    end
}

function Sky.FW.GetSharedAccountBalance(name, options)
    name = name:gsub("^society_", "")
    local balance = exports[RESOURCE]:GetAccountBalance(name, "society")
    if options and options.strict and type(balance) ~= "number" then
        error("[banking/wasabi] Society balance unavailable: " .. tostring(name))
    end
    return balance or 0
end

function Sky.FW.AddSharedAccountBalance(name, amount, options)
    name = name:gsub("^society_", "")
    return exports[RESOURCE]:AddMoney("society", name, amount)
end

function Sky.FW.RemoveSharedAccountBalance(name, amount, options)
    name = name:gsub("^society_", "")
    return exports[RESOURCE]:RemoveMoney("society", name, amount)
end

Sky.FW.BankInvestigationCapabilities = { accounts = true, statements = false, freeze = true }
Sky.FW.BankPlayerPaymentsSupported = true

function Sky.FW.DebitPlayerBank(source, amount, reason)
    if type(amount) ~= "number" or amount < 1 or amount % 1 ~= 0 then return false end
    return exports[RESOURCE]:RemoveMoney("bank", source, amount)
end

function Sky.FW.CreditPlayerBank(source, amount, reason)
    if type(amount) ~= "number" or amount < 1 or amount % 1 ~= 0 then return false end
    return exports[RESOURCE]:AddMoney("bank", source, amount)
end

function Sky.FW.GetBankAccounts(identifier)
    local rows = exports[RESOURCE]:GetAccountsByPlayer(identifier)
    if type(rows) ~= "table" then error("[banking/wasabi] Invalid account response") end

    local accounts = {}
    for _, row in ipairs(rows) do
        if type(row) ~= "table" then error("[banking/wasabi] Account row is invalid") end
        local account_type = normalize_account_type(row.type)
        local account_id = row.id
        local account_key = provider_account_key(account_type, account_id)
        local frozen = row.frozen
        if frozen ~= true and frozen ~= false then
            frozen = exports[RESOURCE]:IsAccountFrozen(account_type, account_id)
        end
        if frozen ~= true and frozen ~= false then
            error("[banking/wasabi] Account freeze state is invalid: " .. account_key)
        end

        accounts[#accounts + 1] = {
            id = account_key,
            number = tostring(row.iban or row.accountNumber or row.number or account_id),
            label = tostring(row.label or row.name or account_type),
            balance = tonumber(row.balance),
            frozen = frozen,
            primary = account_type == "bank",
        }
    end
    return accounts
end

function Sky.FW.SetBankAccountFrozen(account_key, frozen, actor, reason)
    local account_type, account_id = parse_account_key(account_key)
    local accepted
    if frozen then
        accepted = exports[RESOURCE]:FreezeAccount(account_type, account_id, actor)
    else
        accepted = exports[RESOURCE]:UnfreezeAccount(account_type, account_id)
    end
    if accepted ~= true then return false end
    return exports[RESOURCE]:IsAccountFrozen(account_type, account_id) == frozen
end
