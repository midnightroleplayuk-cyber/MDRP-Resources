if Sky.Config.banking ~= "crm" then return end
if not IsDuplicityVersion() then return end

local RESOURCE = "crm-banking"

Sky.FW.SharedAccountCreationSupported = true
Sky.FW.SharedAccountProvisioner = {
    resource = RESOURCE,
    probe = function(name, kind)
        local result = { accountName = name, accountType = "job", canCreate = true }
        if kind ~= "job" then
            result.status, result.error, result.canCreate = "blocked", "account_creation_unsupported", false
            return result
        end

        local account = exports[RESOURCE]:getSocietyAccount(name)
        if not account then
            result.status = "missing"
            return result
        end

        local balance = account.crm_balance
        if balance == nil or balance == false then
            result.status = "missing"
        elseif type(balance) == "number" and balance > -math.huge and balance < math.huge then
            result.status, result.persisted, result.loaded = "existing", true, true
            result.id = account.crm_iban or result.accountName
        else
            error("Invalid provider account balance for '" .. result.accountName .. "': " .. tostring(balance))
        end
        return result
    end,
    create = function(name, label)
        exports[RESOURCE]:createSocietyAccount(name, label or name, 0)
    end
}

function Sky.FW.GetSharedAccountBalance(name, options)
    local account_name = name:gsub("^society_", "")
    local balance = exports[RESOURCE]:getSocietyMoney(account_name)
    if type(balance) == "number" then return balance end
    if options and options.strict then
        error("[banking/crm] Society balance unavailable: " .. account_name)
    end
    return 0
end

function Sky.FW.AddSharedAccountBalance(name, amount, options)
    local account_name = name:gsub("^society_", "")
    return exports[RESOURCE]:addSocietyMoney(account_name, amount)
end

function Sky.FW.RemoveSharedAccountBalance(name, amount, options)
    local account_name = name:gsub("^society_", "")
    return exports[RESOURCE]:removeSocietyMoney(account_name, amount)
end

Sky.FW.BankInvestigationCapabilities = { accounts = true, statements = false, freeze = true }
-- CRM documents IBAN freezes, but no personal debit/credit export to enforce them.
Sky.FW.BankPlayerPaymentsSupported = false

function Sky.FW.GetBankAccounts(identifier)
    local rows = exports[RESOURCE]:getPlayerAccounts(identifier)
    if type(rows) ~= "table" then error("[banking/crm] Invalid player account response") end

    local accounts = {}
    for _, row in ipairs(rows) do
        if type(row) ~= "table" or type(row.crm_iban) ~= "string" or row.crm_iban == "" then
            error("[banking/crm] Player account has no documented IBAN")
        end
        local balance = tonumber(row.crm_balance)
        if balance == nil then
            error("[banking/crm] Player account has no numeric balance: " .. row.crm_iban)
        end
        local frozen = exports[RESOURCE]:isAccountFrozen(row.crm_iban)
        if type(frozen) ~= "boolean" then
            error("[banking/crm] Account freeze state is unavailable: " .. row.crm_iban)
        end
        accounts[#accounts + 1] = {
            id = row.crm_iban,
            number = row.crm_iban,
            label = tostring(row.crm_type or row.crm_iban),
            balance = balance,
            frozen = frozen,
            primary = false,
        }
    end
    return accounts
end

function Sky.FW.SetBankAccountFrozen(account_id, frozen, actor, reason)
    local accepted
    if frozen then
        accepted = exports[RESOURCE]:freezeAccount(account_id)
    else
        accepted = exports[RESOURCE]:unfreezeAccount(account_id)
    end
    if accepted ~= true then return false end
    return exports[RESOURCE]:isAccountFrozen(account_id) == frozen
end
