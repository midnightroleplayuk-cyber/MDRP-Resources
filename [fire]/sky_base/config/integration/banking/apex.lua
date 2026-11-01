if Sky.Config.banking ~= "apex" then return end
if not IsDuplicityVersion() then return end

local RESOURCE = "apex_banking"

local function normalize_amount(amount)
    local numeric_amount = tonumber(amount)
    assert(numeric_amount and numeric_amount > 0 and numeric_amount < math.huge,
        "Apex banking amount must be a positive finite number")
    return numeric_amount
end

Sky.FW.SharedAccountProvisioner = {
    resource = RESOURCE,
    probe = function(name, kind)
        local result = { accountName = name, accountType = "job", canCreate = false }
        if kind ~= "job" then
            result.status, result.error = "blocked", "account_creation_unsupported"
            return result
        end

        local balance = exports[RESOURCE]:GetBusinessBalance(name)
        if balance == nil or balance == false then
            result.status = "missing"
        elseif type(balance) == "number" and balance > -math.huge and balance < math.huge then
            result.status, result.persisted, result.loaded = "existing", true, true
            result.id = result.accountName
        else
            error("Invalid provider account balance for '" .. result.accountName .. "': " .. tostring(balance))
        end
        return result
    end
}

function Sky.FW.GetSharedAccountBalance(name, options)
    local job_name = name:gsub("^society_", "")
    local balance = tonumber(exports[RESOURCE]:GetBusinessBalance(job_name))
    assert(balance, ("Apex banking returned an invalid balance for '%s'"):format(job_name))
    return balance
end

function Sky.FW.AddSharedAccountBalance(name, amount, options)
    local job_name = name:gsub("^society_", "")
    local numeric_amount = normalize_amount(amount)
    return exports[RESOURCE]:AddBusinessMoney(job_name, numeric_amount, "sky_base")
end

function Sky.FW.RemoveSharedAccountBalance(name, amount, options)
    local numeric_amount = normalize_amount(amount)
    local balance = Sky.FW.GetSharedAccountBalance(name)
    if balance < numeric_amount then
        Sky.Debug("warn", "apex_banking: insufficient funds in '%s' (balance=%s, requested=%s)",
            name, balance, numeric_amount)
        return false
    end

    local job_name = name:gsub("^society_", "")
    return exports[RESOURCE]:RemoveBusinessMoney(job_name, numeric_amount, "sky_base")
end
