if Sky.Config.banking ~= "jaksam" then return end
if not IsDuplicityVersion() then return end

local RESOURCE = "jobs_creator"

local function normalize_amount(amount)
    local numeric_amount = tonumber(amount)
    if not numeric_amount or not (numeric_amount > 0 and numeric_amount < math.huge)
        or numeric_amount % 1 ~= 0 then
        Sky.Debug("error", "[banking/jaksam] Invalid amount: %s", tostring(amount))
        return nil
    end
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
        local balance = exports[RESOURCE]:getJobAccountMoney(name)
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
    local balance = exports[RESOURCE]:getJobAccountMoney(account_name)
    if type(balance) ~= "number" or not (balance > -math.huge and balance < math.huge) then
        error("[banking/jaksam] Society balance unavailable: " .. account_name)
    end
    return balance
end

function Sky.FW.AddSharedAccountBalance(name, amount, options)
    local numeric_amount = normalize_amount(amount)
    if not numeric_amount then return false end
    local account_name = name:gsub("^society_", "")
    local before = Sky.FW.GetSharedAccountBalance(name, { strict = true })
    if exports[RESOURCE]:addSocietyMoney(account_name, numeric_amount) == false then return false end
    if Sky.FW.GetSharedAccountBalance(name, { strict = true }) == before + numeric_amount then return true end
    Sky.Debug("error", "[banking/jaksam] Deposit outcome uncertain for '%s'; reconcile before retrying", account_name)
    return nil
end

function Sky.FW.RemoveSharedAccountBalance(name, amount, options)
    local numeric_amount = normalize_amount(amount)
    if not numeric_amount then return false end
    local account_name = name:gsub("^society_", "")
    local before = Sky.FW.GetSharedAccountBalance(name, { strict = true })
    if before < numeric_amount then return false end
    if exports[RESOURCE]:removeSocietyMoney(account_name, numeric_amount) == false then return false end
    if Sky.FW.GetSharedAccountBalance(name, { strict = true }) == before - numeric_amount then return true end
    Sky.Debug("error", "[banking/jaksam] Withdrawal outcome uncertain for '%s'; reconcile before retrying", account_name)
    return nil
end
