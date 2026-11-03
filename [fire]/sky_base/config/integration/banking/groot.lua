if Sky.Config.banking ~= "groot" then return end
if not IsDuplicityVersion() then return end

local RESOURCE = "g-banking"

Sky.FW.SharedAccountCreationSupported = true
Sky.FW.SharedAccountProvisioner = {
    resource = RESOURCE,
    probe = function(name, kind)
        local result = { accountName = name, accountType = "job", canCreate = true }
        if kind ~= "job" then
            result.status, result.error, result.canCreate = "blocked", "account_creation_unsupported", false
            return result
        end
        local account = exports[RESOURCE]:GetAccount(name)
        if not account then
            result.status = "missing"
            return result
        end
        local balance = account.balance
        if balance == nil or balance == false then
            result.status = "missing"
        elseif type(balance) == "number" and balance > -math.huge and balance < math.huge then
            result.status, result.persisted, result.loaded = "existing", true, true
            result.id = account.account_id or name
        else
            error("Invalid provider account balance for '" .. name .. "': " .. tostring(balance))
        end
        return result
    end,
    create = function(name)
        return exports[RESOURCE]:CreateJobAccount(name, 0)
    end
}

function Sky.FW.GetSharedAccountBalance(name, options)
    local account_name = name:gsub("^society_", "")
    local account = exports[RESOURCE]:GetAccount(account_name)
    if not account or type(account.balance) ~= "number" then
        error("[banking/groot] Society balance unavailable: " .. account_name)
    end
    return account.balance
end

function Sky.FW.AddSharedAccountBalance(name, amount, options)
    return exports[RESOURCE]:AddMoney(name:gsub("^society_", ""), amount)
end

function Sky.FW.RemoveSharedAccountBalance(name, amount, options)
    return exports[RESOURCE]:RemoveMoney(name:gsub("^society_", ""), amount)
end

Sky.FW.BankInvestigationCapabilities = { accounts = true, statements = false, freeze = false }

function Sky.FW.GetBankAccounts(identifier)
    local rows = exports[RESOURCE]:GetPlayerAccounts(identifier)
    if type(rows) ~= "table" then error("[banking/groot] Invalid player account response") end
    local accounts = {}
    for _, row in ipairs(rows) do
        if not row.account_id or type(row.balance) ~= "number" then
            error("[banking/groot] Player account has no provider ID or numeric balance")
        end
        accounts[#accounts + 1] = {
            id = tostring(row.account_id), number = tostring(row.account_id),
            label = row.label or tostring(row.account_id), balance = row.balance,
            frozen = false, primary = false,
        }
    end
    return accounts
end
