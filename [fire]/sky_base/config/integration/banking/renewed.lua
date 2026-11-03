if Sky.Config.banking ~= "renewed" then return end
if not IsDuplicityVersion() then return end

local RESOURCE = "Renewed-Banking"
local ensured_accounts = {}

local function ensure_account(name)
    if Sky.ManagedJobs.OwnsAccount(name) then return end
    if ensured_accounts[name] then return end
    if GetResourceState(RESOURCE) ~= "started" then return end

    if exports[RESOURCE]:getAccountMoney(name) ~= false then
        ensured_accounts[name] = true
        return
    end

    local jobs = Sky.FW.GetJobs()
    local label = jobs[name] and jobs[name].label or name

    local ok, err = pcall(function()
        exports[RESOURCE]:CreateJobAccount({ name = name, label = label }, 0)
    end)
    if ok then
        ensured_accounts[name] = true
        Sky.Debug("info", ("[banking/renewed] account '%s' created"):format(name))
    else
        Sky.Debug("warn", ("[banking/renewed] CreateJobAccount('%s') failed: %s"):format(name, tostring(err)))
    end
end

Sky.FW.SharedAccountCreationSupported = true
Sky.FW.SharedAccountCreationAwaited = false
Sky.FW.SharedAccountProvisioner = {
    resource = RESOURCE,
    probe = function(name, kind)
        local result = { accountType = "organization", canCreate = true }
        if #name > 50 then
            result.status, result.error = "blocked", "invalid_society_account"
            return result
        end
        local saved = Sky.DB.Select("SELECT id, creator FROM bank_accounts_new WHERE id = ?", { name })
        if not saved then
            result.status, result.error = "blocked", "account_storage_unavailable"
            return result
        end
        local loaded = exports[RESOURCE]:GetJobAccount(name)
        result.persisted, result.loaded = saved[1] ~= nil, loaded ~= nil
        result.id = saved[1] and saved[1].id
        local other_group = kind == "gang" and Sky.FW.GetJobs()[name]
            or Sky.Config.framework ~= "esx" and kind == "job" and Sky.FW.GetGangs()[name]
        if #saved > 1 or saved[1] and saved[1].creator ~= nil
            or loaded and (loaded.id ~= name or loaded.creator ~= nil) or other_group then
            result.status, result.error = "blocked", "account_type_collision"
        elseif saved[1] and not loaded then
            result.status, result.error = "blocked", "account_not_loaded"
        elseif loaded and not saved[1] then
            result.status, result.error = "blocked", "account_persistence_pending"
        else
            result.status = saved[1] and "existing" or "missing"
        end
        return result
    end,
    create = function(name, label)
        local account = exports[RESOURCE]:CreateJobAccount({ name = name, label = label }, 0)
        return account ~= nil
    end
}

function Sky.FW.GetSharedAccountBalance(name, options)
    name = name:gsub("^society_", "")
    ensure_account(name)
    if Sky.ManagedJobs.OwnsAccount(name) and not exports[RESOURCE]:GetJobAccount(name) then
        error("[banking/renewed] Managed account is not loaded: " .. name)
    end
    return exports[RESOURCE]:getAccountMoney(name) or 0
end

function Sky.FW.AddSharedAccountBalance(name, amount, options)
    name = name:gsub("^society_", "")
    ensure_account(name)
    return exports[RESOURCE]:addAccountMoney(name, amount)
end

function Sky.FW.RemoveSharedAccountBalance(name, amount, options)
    name = name:gsub("^society_", "")
    ensure_account(name)
    return exports[RESOURCE]:removeAccountMoney(name, amount)
end
