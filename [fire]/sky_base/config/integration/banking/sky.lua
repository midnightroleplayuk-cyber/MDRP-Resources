if Sky.Config.banking ~= "sky" then return end
if not IsDuplicityVersion() then return end

local RESOURCE = "sky_base"

local function validate_input(action, name, amount)
    if type(name) ~= "string" or name == "" then
        Sky.Debug("error", "[sky banking] Sky.FW.%s received invalid job/account name '%s' (type: %s).", action, tostring(name), type(name))
        return false
    end

    if amount ~= nil then
        local numeric_amount = tonumber(amount)
        if numeric_amount == nil or numeric_amount <= 0 then
            Sky.Debug("error", "[sky banking] Sky.FW.%s received invalid amount for '%s': '%s' (type: %s).", action, tostring(name), tostring(amount), type(amount))
            return false
        end
    end

    return true
end

Sky.FW.SharedAccountCreationSupported = true
Sky.FW.SharedAccountCreationAwaited = true
Sky.FW.SharedAccountProvisioner = {
    provider = "sky",
    resource = RESOURCE,
    freshCreationSupported = true,
    renameSupported = true,
    prepareRename = function(old_name, new_name, kind, authorize, recovery_state)
        local function admit()
            local allowed, error_code = authorize()
            if not allowed then return false, error_code end
            local other_groups = kind == "gang" and Sky.FW.GetJobs()
                or (Sky.Config.framework == "qb" or Sky.Config.framework == "qbox") and Sky.FW.GetGangs() or {}
            allowed, error_code = authorize()
            if not allowed then return false, error_code end
            if other_groups[old_name] or other_groups[new_name] then return false, "account_type_collision" end
            return true
        end
        local allowed, error_code = admit()
        if not allowed then return nil, error_code end
        return Sky.InternalBanking.PrepareAccountRename(old_name, new_name, admit, recovery_state)
    end,
    probe = function(name, kind)
        local result = { accountType = "organization", canCreate = true }
        local saved = Sky.DB.Select("SELECT job FROM sky_job_accounts WHERE job = ?", { name })
        if not saved then
            result.status, result.error = "blocked", "account_storage_unavailable"
            return result
        end
        result.persisted, result.loaded = saved[1] ~= nil, saved[1] ~= nil
        result.id = saved[1] and saved[1].job
        local other_group = kind == "gang" and Sky.FW.GetJobs()[name]
            or Sky.Config.framework ~= "esx" and kind == "job" and Sky.FW.GetGangs()[name]
        if #saved > 1 or other_group then
            result.status, result.error = "blocked", "account_type_collision"
        else
            result.status = saved[1] and "existing" or "missing"
        end
        return result
    end,
    create = function(name, label, kind, options)
        local account, error_code, attempted = Sky.InternalBanking.EnsureAccount(name, options)
        if options and options.requireNew then return account ~= nil, account, attempted end
        return account ~= nil
    end
}

function Sky.FW.GetSharedAccountBalance(name, options)
    if not validate_input("GetSharedAccountBalance", name) then return 0 end
    return Sky.InternalBanking.GetBalance(name)
end

function Sky.FW.AddSharedAccountBalance(name, amount, options)
    if not validate_input("AddSharedAccountBalance", name, amount) then return false end
    return Sky.InternalBanking.AddBalance(name, amount)
end

function Sky.FW.RemoveSharedAccountBalance(name, amount, options)
    if not validate_input("RemoveSharedAccountBalance", name, amount) then return false end
    return Sky.InternalBanking.RemoveBalance(name, amount)
end
