if Sky.Config.banking ~= "tgg" then return end
if not IsDuplicityVersion() then return end

local RESOURCE = "tgg-banking"
local ensured_accounts = {}

local function ensure_account(name)
    if ensured_accounts[name] then return end

    local result = exports[RESOURCE]:CreateBusinessAccount(name, 0)
    if result.success then
        ensured_accounts[name] = true
        return
    end

    Sky.Debug("warn", ("[banking/tgg] CreateBusinessAccount('%s') failed: %s"):format(name, result.error or result.message or "unknown error"))
end

Sky.FW.SharedAccountCreationSupported = true
Sky.FW.SharedAccountProvisioner = {
    resource = RESOURCE,
    probe = function(name, kind)
        local result = { accountName = name, accountType = "job", canCreate = true }
        if kind ~= "job" then
            result.status, result.error, result.canCreate = "blocked", "account_creation_unsupported", false
            return result
        end

        local account = exports[RESOURCE]:GetSocietyAccount(name)
        local balance = account and account.balance
        if balance == nil or balance == false then
            result.status = "missing"
        elseif type(balance) == "number" and balance > -math.huge and balance < math.huge then
            result.status, result.persisted, result.loaded = "existing", true, true
            result.id = account.id or name
        else
            error("Invalid provider account balance for '" .. result.accountName .. "': " .. tostring(balance))
        end
        return result
    end,
    create = function(name, label)
        local result = exports[RESOURCE]:CreateBusinessAccount(name, 0, label)
        return result.success
    end
}

function Sky.FW.GetSharedAccountBalance(name, options)
    name = name:gsub("^society_", "")
    if not (options and options.strict) then ensure_account(name) end
    local balance = exports[RESOURCE]:GetSocietyAccountMoney(name)
    if options and options.strict and type(balance) ~= "number" then
        error("[banking/tgg] Society balance unavailable: " .. name)
    end
    return balance or 0
end

function Sky.FW.AddSharedAccountBalance(name, amount, options)
    name = name:gsub("^society_", "")
    if not (options and options.strict) then ensure_account(name) end
    return exports[RESOURCE]:AddSocietyMoney(name, amount)
end

function Sky.FW.RemoveSharedAccountBalance(name, amount, options)
    name = name:gsub("^society_", "")
    if not (options and options.strict) then ensure_account(name) end
    return exports[RESOURCE]:RemoveSocietyMoney(name, amount)
end

Sky.FW.BankInvestigationCapabilities = { accounts = true, statements = false, freeze = true }
Sky.FW.BankPlayerPaymentsSupported = false -- No documented personal debit/credit export.

function Sky.FW.GetBankAccounts(identifier)
    local account = exports[RESOURCE]:GetPersonalAccountByPlayerIdentifier(identifier)
    if not account then return {} end
    if not tonumber(account.iban) then error("[banking/tgg] Personal account has no numeric IBAN") end
    return { { id = tostring(account.iban), number = tostring(account.iban), label = tostring(account.iban),
        balance = tonumber(account.balance), primary = true,
        frozen = exports[RESOURCE]:IsAccountFrozen(tonumber(account.iban)) } }
end

function Sky.FW.SetBankAccountFrozen(account_id, frozen, actor, reason)
    local accepted
    if frozen then
        accepted = exports[RESOURCE]:FreezeAccount(tonumber(account_id))
    else
        accepted = exports[RESOURCE]:UnfreezeAccount(tonumber(account_id))
    end
    if accepted ~= true then return accepted end
    return exports[RESOURCE]:IsAccountFrozen(tonumber(account_id)) == frozen
end
