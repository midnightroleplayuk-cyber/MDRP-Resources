if Sky.Config.banking ~= "okok" then return end
if not IsDuplicityVersion() then return end

local RESOURCE = "okokBanking"

local function resolve_account(name, required)
    name = name:gsub("^society_", "")
    local prefixed_name = "society_" .. name
    local saved = Sky.DB.Select("SELECT society FROM okokbanking_societies WHERE society IN (?, ?) LIMIT 2", { name, prefixed_name })
    local account_name = saved and saved[1] and saved[1].society
    local account_error
    if not saved then
        account_error = "account_storage_unavailable"
    elseif #saved > 1 or account_name and account_name ~= name and account_name ~= prefixed_name then
        account_error = "account_type_collision"
    end
    if required and (account_error or not account_name) then
        error(("[banking/okok] Society account '%s' unavailable: %s"):format(name, account_error or "account_missing"))
    end
    return account_name, account_error
end

local function read_balance(account_name)
    local balance = exports[RESOURCE]:GetAccount(account_name)
    if type(balance) ~= "number" or not (balance > -math.huge and balance < math.huge) then
        error(("[banking/okok] Society balance unavailable for '%s': returned %s. Configure the account in okokBanking first.")
            :format(account_name, tostring(balance)))
    end
    return balance
end

-- This adapter owns okok society accounts. For okok's ESX addonaccount mode, select banking = "esx".

Sky.FW.SharedAccountProvisioner = {
    resource = RESOURCE,
    probe = function(name, kind)
        local result = { accountType = "job", canCreate = false }
        if kind ~= "job" then
            result.status, result.error = "blocked", "account_creation_unsupported"
            return result
        end
        local account_name, account_error = resolve_account(name)
        result.persisted, result.id = account_name ~= nil, account_name
        if account_error then
            result.status, result.error = "blocked", account_error
        elseif not account_name then
            result.status = "missing"
        else
            result.accountName = account_name
            local balance = exports[RESOURCE]:GetAccount(account_name)
            result.loaded = type(balance) == "number" and balance > -math.huge and balance < math.huge
            if result.loaded then
                result.status = "existing"
            else
                result.status = "blocked"
                result.error = (balance == nil or balance == false) and "account_not_loaded" or "account_provider_error"
            end
        end
        return result
    end
}

function Sky.FW.GetSharedAccountBalance(name, options)
    local account_name = resolve_account(name, true)
    return read_balance(account_name)
end

function Sky.FW.AddSharedAccountBalance(name, amount, options)
    name = name:gsub("^society_", "")
    if type(amount) ~= "number" or not (amount > 0 and amount < math.huge) then
        Sky.Debug("error", "[banking/okok] Deposit rejected for '%s': invalid amount %s", name, tostring(amount))
        return false
    end
    local account_name = resolve_account(name, true)
    local before = read_balance(account_name)
    if exports[RESOURCE]:AddMoney(account_name, amount) == false then return false end
    if read_balance(account_name) == before + amount then return true end
    Sky.Debug("error", "[banking/okok] Deposit outcome uncertain for '%s': amount=%s; reconcile before retrying", name, amount)
    return nil
end

function Sky.FW.RemoveSharedAccountBalance(name, amount, options)
    name = name:gsub("^society_", "")
    if type(amount) ~= "number" or not (amount > 0 and amount < math.huge) then
        Sky.Debug("error", "[banking/okok] Withdrawal rejected for '%s': invalid amount %s", name, tostring(amount))
        return false
    end
    local account_name = resolve_account(name, true)
    local before = read_balance(account_name)
    if before < amount then
        Sky.Debug("warn", "[banking/okok] Withdrawal rejected for '%s': amount=%s balance=%s", name, amount, before)
        return false
    end
    if exports[RESOURCE]:RemoveMoney(account_name, amount) == false then return false end
    if read_balance(account_name) == before - amount then return true end
    Sky.Debug("error", "[banking/okok] Withdrawal outcome uncertain for '%s': amount=%s; reconcile before retrying", name, amount)
    return nil
end
