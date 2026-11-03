if Sky.Config.banking ~= "pc" then return end
if not IsDuplicityVersion() then return end

local RESOURCE = "pc-banking"
local OWNER = "system"
local REASON = "sky_base"
local ensured_accounts = {}

local function resolve_job_label(name)
    local normalized_name = name:gsub("^society_", "")
    local jobs = Sky.FW.GetJobs()

    if jobs[normalized_name] and jobs[normalized_name].label then
        return jobs[normalized_name].label
    end

    for _, job in pairs(jobs) do
        if job.name == normalized_name and job.label then
            return job.label
        end
    end

    return normalized_name
end

local function ensure_account(name)
    local society_name = name:gsub("^society_", "")

    if ensured_accounts[society_name] then
        return society_name
    end

    if GetResourceState(RESOURCE) ~= "started" then
        return society_name
    end

    local ok, created_or_exists = pcall(function()
        return exports[RESOURCE]:RegisterSociety(society_name, {
            label = resolve_job_label(society_name),
            type = "business",
            owner = OWNER
        })
    end)

    if ok then
        ensured_accounts[society_name] = true

        if created_or_exists then
            Sky.Debug("info", ("[banking/pc] account '%s' created"):format(society_name))
        end
    else
        Sky.Debug("warn", ("[banking/pc] RegisterSociety('%s') failed: %s"):format(society_name, tostring(created_or_exists)))
    end

    return society_name
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
        local balance = exports[RESOURCE]:GetSocietyBalance(name)
        if balance == nil or balance == false then
            result.status = "missing"
        elseif type(balance) == "number" and balance > -math.huge and balance < math.huge then
            result.status, result.persisted, result.loaded, result.id = "existing", true, true, name
        else
            error("Invalid provider account balance for '" .. name .. "': " .. tostring(balance))
        end
        return result
    end,
    create = function(name, label)
        return exports[RESOURCE]:RegisterSociety(name, { label = label or name, type = "business", owner = OWNER })
    end
}

function Sky.FW.GetSharedAccountBalance(name, options)
    local society_name = options and options.strict and name:gsub("^society_", "") or ensure_account(name)
    local balance = exports[RESOURCE]:GetSocietyBalance(society_name)
    if options and options.strict and type(balance) ~= "number" then
        error("[banking/pc] Society balance unavailable: " .. society_name)
    end
    return balance or 0
end

function Sky.FW.AddSharedAccountBalance(name, amount, options)
    local society_name = options and options.strict and name:gsub("^society_", "") or ensure_account(name)
    return exports[RESOURCE]:AddSocietyMoney(society_name, amount, options and options.reason or REASON)
end

function Sky.FW.RemoveSharedAccountBalance(name, amount, options)
    local society_name = options and options.strict and name:gsub("^society_", "") or ensure_account(name)
    return exports[RESOURCE]:RemoveSocietyMoney(society_name, amount, options and options.reason or REASON)
end

Sky.FW.BankInvestigationCapabilities = { accounts = true, statements = true, freeze = true }

function Sky.FW.DebitPlayerBank(source, amount, reason)
    if type(amount) ~= "number" or amount < 1 or amount % 1 ~= 0 then return false end
    return exports[RESOURCE]:RemoveMoney(source, amount, reason)
end

function Sky.FW.CreditPlayerBank(source, amount, reason)
    if type(amount) ~= "number" or amount < 1 or amount % 1 ~= 0 then return false end
    return exports[RESOURCE]:AddMoney(source, amount, reason)
end

function Sky.FW.GetBankAccounts(identifier)
    local rows = exports[RESOURCE]:GetAccountsByIdentifier(identifier)
    if type(rows) ~= "table" then error("[banking/pc] Invalid account response") end
    local accounts = {}
    for _, row in ipairs(rows) do
        if not tonumber(row.id) then error("[banking/pc] Account has no numeric ID") end
        accounts[#accounts + 1] = {
            id = tostring(row.id), number = tostring(row.accountNumber or row.id),
            label = row.bankName or row.accountType or tostring(row.id), balance = tonumber(row.balance),
            frozen = row.isFrozen == true or row.isFrozen == 1,
            primary = row.isPrimary == true or row.isPrimary == 1,
        }
    end
    return accounts
end

function Sky.FW.GetBankAccountTransactions(account_id, offset, limit)
    local rows = exports[RESOURCE]:ExportAccountTransactions(tonumber(account_id), { offset = offset, limit = limit })
    if type(rows) ~= "table" then error("[banking/pc] Invalid statement response") end
    local transactions = {}
    for _, row in ipairs(rows) do
        transactions[#transactions + 1] = {
            date = row.created_at, amount = tonumber(row.amount), description = row.description or "",
        }
    end
    return transactions
end

function Sky.FW.SetBankAccountFrozen(account_id, frozen, actor, reason)
    local account = exports[RESOURCE]:GetAccountInfo(tonumber(account_id))
    if not account then return false end
    if frozen then
        if exports[RESOURCE]:FreezeAccount(tonumber(account_id), actor, reason) ~= true then return false end
    elseif exports[RESOURCE]:UnfreezeAccount(tonumber(account_id), actor) ~= true then
        return false
    end
    return exports[RESOURCE]:IsAccountFrozen(tonumber(account_id)) == frozen
end
