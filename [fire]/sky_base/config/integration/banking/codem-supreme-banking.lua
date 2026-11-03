if Sky.Config.banking ~= "codem-supreme-banking" then return end
if not IsDuplicityVersion() then return end

local RESOURCE = "codem-supreme-banking"

Sky.FW.SharedAccountProvisioner = {
    resource = RESOURCE,
    probe = function(name, kind)
        local result = { accountName = name, accountType = "job", canCreate = false }
        if kind ~= "job" then
            result.status, result.error = "blocked", "account_creation_unsupported"
            return result
        end

        local balance = exports[RESOURCE]:GetSocietyBalance(name)
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
    local balance = exports[RESOURCE]:GetSocietyBalance(job_name)
    if type(balance) ~= "number" then
        error(("codem-supreme-banking: society balance unavailable for '%s'"):format(job_name))
    end
    return balance
end

function Sky.FW.AddSharedAccountBalance(name, amount, options)
    local job_name = name:gsub("^society_", "")
    local reason = options and options.reason or "sky_base"
    return exports[RESOURCE]:AddSocietyMoney(job_name, amount, reason)
end

function Sky.FW.RemoveSharedAccountBalance(name, amount, options)
    local job_name = name:gsub("^society_", "")
    local reason = options and options.reason or "sky_base"
    return exports[RESOURCE]:RemoveSocietyMoney(job_name, amount, reason)
end
