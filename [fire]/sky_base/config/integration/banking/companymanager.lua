if Sky.Config.banking ~= "companymanager" then return end
if not IsDuplicityVersion() then return end

local RESOURCE = "bcs_companymanager"
local ACCOUNT = "money"
local IDENTIFIER = "sky_base"
local REASON = "sky_base"

Sky.FW.SharedAccountProvisioner = {
    resource = RESOURCE,
    probe = function(name, kind)
        local result = { accountName = name, accountType = "job", canCreate = false }
        if kind ~= "job" then
            result.status, result.error = "blocked", "account_creation_unsupported"
            return result
        end

        local company = exports[RESOURCE]:GetCompany(name)
        if not company then
            result.status = "missing"
            return result
        end

        local balance = exports[RESOURCE]:GetCompanyMoney(name, ACCOUNT)
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
    local company_name = name:gsub("^society_", "")
    if not exports[RESOURCE]:GetCompany(company_name) then
        error("[banking/companymanager] Company account unavailable: " .. company_name)
    end
    local balance = exports[RESOURCE]:GetCompanyMoney(company_name, ACCOUNT)
    if type(balance) ~= "number" then error("[banking/companymanager] Invalid balance: " .. company_name) end
    return balance
end

function Sky.FW.AddSharedAccountBalance(name, amount, options)
    local company_name = name:gsub("^society_", "")
    local before = Sky.FW.GetSharedAccountBalance(name, { strict = true })
    if exports[RESOURCE]:AddCompanyMoney(company_name, ACCOUNT, amount, IDENTIFIER, REASON, false) == false then return false end
    if Sky.FW.GetSharedAccountBalance(name, { strict = true }) == before + amount then return true end
    Sky.Debug("error", "[banking/companymanager] Deposit outcome uncertain for '%s'; reconcile before retrying", company_name)
    return nil
end

function Sky.FW.RemoveSharedAccountBalance(name, amount, options)
    local company_name = name:gsub("^society_", "")

    local before = Sky.FW.GetSharedAccountBalance(name, { strict = true })
    if before < amount then
        return false
    end

    if exports[RESOURCE]:RemoveCompanyMoney(company_name, ACCOUNT, amount, IDENTIFIER, REASON, false) == false then return false end
    if Sky.FW.GetSharedAccountBalance(name, { strict = true }) == before - amount then return true end
    Sky.Debug("error", "[banking/companymanager] Withdrawal outcome uncertain for '%s'; reconcile before retrying", company_name)
    return nil
end
