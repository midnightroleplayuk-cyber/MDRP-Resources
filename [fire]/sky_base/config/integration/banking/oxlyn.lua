if Sky.Config.banking ~= "oxlyn" then return end
if not IsDuplicityVersion() then return end

local RESOURCE = "oxlyn-banking"

local function get_business_balance(job_name)
    if not exports[RESOURCE]:IsBusinessEnabled() then
        error("[banking/oxlyn] Company accounts are disabled; enable Config.Business.enabled in oxlyn-banking")
    end
    -- The native getter also returns zero for unknown jobs, so check the framework catalog first.
    if not Sky.FW.GetJobs()[job_name] then return nil end
    local balance = exports[RESOURCE]:GetBusinessBalance(job_name)
    if type(balance) ~= "number" or not (balance > -math.huge and balance < math.huge) then
        error(("[banking/oxlyn] Invalid company balance for '%s': %s"):format(job_name, tostring(balance)))
    end
    return balance
end

Sky.FW.SharedAccountProvisioner = {
    resource = RESOURCE,
    probe = function(name, kind)
        local result = { accountName = name, accountType = "job", canCreate = false }
        if kind ~= "job" then
            result.status, result.error = "blocked", "account_creation_unsupported"
            return result
        end
        local balance = get_business_balance(name)
        if balance == nil then
            result.status = "missing"
        else
            result.status, result.persisted, result.loaded, result.id = "existing", true, true, name
        end
        return result
    end
}

function Sky.FW.GetSharedAccountBalance(name, options)
    local job_name = name:gsub("^society_", "")
    local balance = get_business_balance(job_name)
    if balance == nil then
        error("[banking/oxlyn] Unknown framework job: " .. job_name)
    end
    return balance
end

function Sky.FW.AddSharedAccountBalance(name, amount, options)
    local job_name = name:gsub("^society_", "")
    local reason = options and options.reason or "sky_base"
    return exports[RESOURCE]:CreditBusiness(job_name, amount, reason)
end

function Sky.FW.RemoveSharedAccountBalance(name, amount, options)
    local job_name = name:gsub("^society_", "")
    local reason = options and options.reason or "sky_base"
    return exports[RESOURCE]:ChargeBusiness(job_name, amount, reason)
end

function Sky.FW.DebitPlayerBank(source, amount, reason)
    return exports[RESOURCE]:Charge(source, amount, reason or "sky_base", "bank")
end

function Sky.FW.CreditPlayerBank(source, amount, reason)
    return exports[RESOURCE]:Credit(source, amount, reason or "sky_base", "bank")
end
