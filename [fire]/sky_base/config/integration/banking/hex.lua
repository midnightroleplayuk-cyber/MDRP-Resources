if Sky.Config.banking ~= "hex" then return end
if not IsDuplicityVersion() then return end

local RESOURCE = "hex_jobscreator"

Sky.FW.SharedAccountProvisioner = {
    resource = RESOURCE,
    probe = function(name, kind)
        local result = { accountName = name, accountType = "job", canCreate = false }
        if kind ~= "job" then
            result.status, result.error = "blocked", "account_creation_unsupported"
            return result
        end
        local balance, reason = exports[RESOURCE]:getSocietyMoney(name, "legal")
        if balance == nil and reason ~= "unknown_job" then
            error("hex_jobscreator: society account unavailable (" .. tostring(reason) .. ")")
        end
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
    local job_name = name:gsub("^society_", "")
    local balance, reason = exports[RESOURCE]:getSocietyMoney(job_name, "legal")
    if type(balance) ~= "number" then
        error(("hex_jobscreator: society balance unavailable for '%s' (%s)"):format(job_name, tostring(reason)))
    end
    return balance
end

function Sky.FW.AddSharedAccountBalance(name, amount, options)
    local job_name = name:gsub("^society_", "")
    local success, reason = exports[RESOURCE]:addSocietyMoney(job_name, amount, "legal")
    if not success then
        Sky.Debug("error", "hex_jobscreator: society deposit failed for '%s' (%s)", job_name, tostring(reason))
        return false, reason
    end
    return true
end

function Sky.FW.RemoveSharedAccountBalance(name, amount, options)
    local job_name = name:gsub("^society_", "")
    local success, reason = exports[RESOURCE]:removeSocietyMoney(job_name, amount, "legal")
    if not success then
        Sky.Debug("error", "hex_jobscreator: society withdrawal failed for '%s' (%s)", job_name, tostring(reason))
        return false, reason
    end
    return true
end
