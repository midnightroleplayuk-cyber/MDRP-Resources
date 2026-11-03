if Sky.Config.banking ~= "kartik" then return end
if not IsDuplicityVersion() then return end

local RESOURCE = "kartik-banking"

local function resolve_job_label(name)
    local jobs = Sky.FW.GetJobs()
    return jobs[name] and jobs[name].label or name
end

local function ensure_account(name)
    if GetResourceState(RESOURCE) ~= "started" then
        Sky.Debug("warn", "[banking/kartik] kartik-banking is not started.")
        return false
    end

    local ok, balance = pcall(function()
        return exports[RESOURCE]:GetAccountMoney(name)
    end)
    if not ok then
        Sky.Debug("warn", ("[banking/kartik] GetAccountMoney('%s') failed: %s"):format(name, tostring(balance)))
        return false
    end
    if balance ~= nil then
        return true, balance
    end

    local created = false
    local create_ok, err = pcall(function()
        created = exports[RESOURCE]:CreateJobAccount({
            name = name,
            label = resolve_job_label(name),
            bankType = "fleeca"
        }, 0)
    end)

    if create_ok and created then
        Sky.Debug("info", ("[banking/kartik] account '%s' created"):format(name))
        return true, 0
    elseif create_ok then
        Sky.Debug("warn", ("[banking/kartik] CreateJobAccount('%s') returned false"):format(name))
    else
        Sky.Debug("warn", ("[banking/kartik] CreateJobAccount('%s') failed: %s"):format(name, tostring(err)))
    end
    return false
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
        local balance = exports[RESOURCE]:GetAccountMoney(name)
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
        return exports[RESOURCE]:CreateJobAccount({ name = name, label = label or name, bankType = "fleeca" }, 0)
    end
}

function Sky.FW.GetSharedAccountBalance(name, options)
    name = name:gsub("^society_", "")
    if options and options.strict then
        local balance = exports[RESOURCE]:GetAccountMoney(name)
        if type(balance) ~= "number" then error("[banking/kartik] Society balance unavailable: " .. name) end
        return balance
    end
    local ok, balance = ensure_account(name)
    if not ok then
        error(("[banking/kartik] Could not read job account '%s'."):format(name))
    end
    return balance
end

function Sky.FW.AddSharedAccountBalance(name, amount, options)
    name = name:gsub("^society_", "")
    if not (options and options.strict) and not ensure_account(name) then return false end
    return exports[RESOURCE]:AddAccountMoney(name, amount, "sky_base")
end

function Sky.FW.RemoveSharedAccountBalance(name, amount, options)
    name = name:gsub("^society_", "")
    if not (options and options.strict) and not ensure_account(name) then return false end
    return exports[RESOURCE]:RemoveAccountMoney(name, amount, "sky_base")
end
