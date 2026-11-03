if Sky.Config.banking ~= "retro" then return end
if not IsDuplicityVersion() then return end

local RESOURCE = "rs_bank"

local function resolve_business_name(name)
    assert(type(name) == "string", "Retro banking account name must be a string")

    local business_name = name:gsub("^society_", "")
    assert(business_name ~= "", "Retro banking account name must not be empty")
    return business_name
end

local function normalize_amount(amount)
    local numeric_amount = tonumber(amount)
    assert(numeric_amount and numeric_amount > 0 and numeric_amount < math.huge,
        "Retro banking amount must be a positive finite number")
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

        local balance = exports[RESOURCE]:GetBusinessMoney(name)
        if balance == nil or balance == false then
            result.status = "missing"
        elseif type(balance) == "number" and balance > -math.huge and balance < math.huge then
            result.status, result.persisted, result.loaded = "existing", true, true
            result.id = name
        else
            error("Invalid provider account balance for '" .. result.accountName .. "': " .. tostring(balance))
        end
        return result
    end
}

function Sky.FW.GetSharedAccountBalance(name, options)
    local balance = exports[RESOURCE]:GetBusinessMoney(resolve_business_name(name))
    if type(balance) ~= "number" then error("[banking/retro] Business balance unavailable: " .. name) end
    return balance
end

function Sky.FW.AddSharedAccountBalance(name, amount, options)
    local numeric_amount = normalize_amount(amount)
    local before = Sky.FW.GetSharedAccountBalance(name, { strict = true })
    local result = exports[RESOURCE]:AddBusinessMoney(
        resolve_business_name(name),
        numeric_amount,
        "Sky business deposit"
    )
    if result == false then return false end
    if Sky.FW.GetSharedAccountBalance(name, { strict = true }) == before + numeric_amount then return true end
    Sky.Debug("error", "[banking/retro] Deposit outcome uncertain for '%s'; reconcile before retrying", name)
    return nil
end

function Sky.FW.RemoveSharedAccountBalance(name, amount, options)
    local business_name = resolve_business_name(name)
    local numeric_amount = normalize_amount(amount)
    local before = Sky.FW.GetSharedAccountBalance(name, { strict = true })
    if before < numeric_amount then
        return false
    end

    local result = exports[RESOURCE]:RemoveBusinessMoney(
        business_name,
        numeric_amount,
        "Sky business withdrawal"
    )
    if result == false then return false end
    if Sky.FW.GetSharedAccountBalance(name, { strict = true }) == before - numeric_amount then return true end
    Sky.Debug("error", "[banking/retro] Withdrawal outcome uncertain for '%s'; reconcile before retrying", name)
    return nil
end
