if Sky.Config.banking ~= "devmosaic" then return end
if not IsDuplicityVersion() then return end

local RESOURCE = "dm-banking"

Sky.FW.SharedAccountProvisioner = {
    resource = RESOURCE,
    probe = function(name, kind)
        local account_name = "job:" .. name
        local result = { accountName = account_name, accountType = "job", canCreate = false }
        if kind ~= "job" then
            result.status, result.error = "blocked", "account_creation_unsupported"
            return result
        end
        local balance = exports[RESOURCE]:getAccountMoney(account_name)
        if balance == nil or balance == false then
            result.status = "missing"
        elseif type(balance) == "number" and balance > -math.huge and balance < math.huge then
            result.status, result.persisted, result.loaded = "existing", true, true
            result.id = account_name
        else
            error("[banking/devmosaic] Invalid provider account balance for '" .. account_name .. "': " .. tostring(balance))
        end
        return result
    end
}

function Sky.FW.GetSharedAccountBalance(name, options)
    local account_name = "job:" .. name:gsub("^society_", "")
    local balance = exports[RESOURCE]:getAccountMoney(account_name)
    if type(balance) ~= "number" or not (balance > -math.huge and balance < math.huge) then
        error("[banking/devmosaic] Society balance unavailable: " .. account_name)
    end
    return balance
end

function Sky.FW.AddSharedAccountBalance(name, amount, options)
    local account_name = "job:" .. name:gsub("^society_", "")
    local before = Sky.FW.GetSharedAccountBalance(name, { strict = true })
    if exports[RESOURCE]:addAccountMoney(account_name, amount) == false then return false end
    if Sky.FW.GetSharedAccountBalance(name, { strict = true }) == before + amount then return true end
    Sky.Debug("error", "[banking/devmosaic] Deposit outcome uncertain for '%s'; reconcile before retrying", account_name)
    return nil
end

function Sky.FW.RemoveSharedAccountBalance(name, amount, options)
    local account_name = "job:" .. name:gsub("^society_", "")
    local before = Sky.FW.GetSharedAccountBalance(name, { strict = true })
    if before < amount then
        return false
    end

    if exports[RESOURCE]:removeAccountMoney(account_name, amount) == false then return false end
    if Sky.FW.GetSharedAccountBalance(name, { strict = true }) == before - amount then return true end
    Sky.Debug("error", "[banking/devmosaic] Withdrawal outcome uncertain for '%s'; reconcile before retrying", account_name)
    return nil
end

-- Native exports address the primary personal account; shared memberships are not enumerable.
Sky.FW.BankInvestigationCapabilities = { accounts = true, statements = false, freeze = false }

function Sky.FW.GetBankAccounts(identifier)
    local account_name = "personal:" .. identifier
    local balance = exports[RESOURCE]:getAccountMoney(account_name)
    if balance == false then return {} end
    if type(balance) ~= "number" or not (balance > -math.huge and balance < math.huge) then
        error("[banking/devmosaic] Personal account balance unavailable")
    end
    return { { id = account_name, number = account_name, label = account_name,
        balance = balance, frozen = false, primary = true } }
end
