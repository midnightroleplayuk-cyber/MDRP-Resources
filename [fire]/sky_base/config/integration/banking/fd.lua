if Sky.Config.banking ~= "fd" then return end
if not IsDuplicityVersion() then return end

local RESOURCE = "fd_banking"

local function read_balance(account)
    if type(account) == "number" then
        return account
    elseif type(account) == "table" then
        return tonumber(account.balance)
    end
    return nil
end

Sky.FW.SharedAccountProvisioner = {
    resource = RESOURCE,
    probe = function(name, kind)
        local result = { accountName = name, accountType = "job", canCreate = false }
        if kind ~= "job" then
            result.status, result.error = "blocked", "account_creation_unsupported"
            return result
        end
        local account = exports[RESOURCE]:getBusinessAccount(name)
        if not account then
            result.status = "missing"
            return result
        end
        local balance = read_balance(exports[RESOURCE]:GetAccount(name))
        if balance == nil or balance == false then
            result.status = "missing"
        elseif type(balance) == "number" and balance > -math.huge and balance < math.huge then
            result.status, result.persisted, result.loaded, result.id = "existing", true, true, name
        else
            error("Invalid provider account balance for '" .. name .. "': " .. tostring(balance))
        end
        return result
    end
}

function Sky.FW.GetSharedAccountBalance(name, options)
    local account_name = name:gsub("^society_", "")
    local balance = read_balance(exports[RESOURCE]:GetAccount(account_name))
    if options and options.strict and type(balance) ~= "number" then
        error("[banking/fd] Society balance unavailable: " .. account_name)
    end
    return balance or 0
end

function Sky.FW.AddSharedAccountBalance(name, amount, options)
    local account_name = name:gsub("^society_", "")
    return exports[RESOURCE]:AddMoney(account_name, amount, "sky_base")
end

function Sky.FW.RemoveSharedAccountBalance(name, amount, options)
    local account_name = name:gsub("^society_", "")
    return exports[RESOURCE]:RemoveMoney(account_name, amount, "sky_base")
end
