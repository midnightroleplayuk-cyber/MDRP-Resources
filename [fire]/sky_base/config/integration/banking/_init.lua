if not IsDuplicityVersion() then return end

local function noop() return false end

Sky.FW.GetSharedAccountBalance    = Sky.FW.GetSharedAccountBalance    or function() return 0 end
Sky.FW.AddSharedAccountBalance    = Sky.FW.AddSharedAccountBalance    or noop
Sky.FW.RemoveSharedAccountBalance = Sky.FW.RemoveSharedAccountBalance or noop

-- Adapters supply account observation and optional creation separately.
Sky.FW.SharedAccountCreationSupported = false
Sky.FW.SharedAccountCreationAwaited = false
-- Adapter-owned reads must not call an auto-creating balance getter.
Sky.FW.SharedAccountProvisioner = {
    renameSupported = false,
    probe = function()
        return { status = "blocked", error = "account_creation_unsupported", canCreate = false }
    end
}
local account_locks = {}

function Sky.FW.ProbeSharedAccount(name, kind)
    kind = kind or "job"
    local adapter = Sky.FW.SharedAccountProvisioner
    local probe = {
        provider = Sky.Config.banking, resource = adapter.resource,
        name = name, kind = kind, accountName = name,
        status = "blocked", persisted = false, loaded = false, canCreate = false
    }
    if type(name) ~= "string" or #name > 64 or not name:match("^[a-z][a-z0-9_]*$") then
        probe.error = "invalid_society_account"
        Sky.Debug("error", "[banking] Account probe received invalid account name '%s'", tostring(name))
        return probe
    end
    name = name:gsub("^society_", "")
    probe.name, probe.accountName = name, name
    if name == "" then
        probe.error = "invalid_society_account"
        Sky.Debug("error", "[banking] Account probe received an empty canonical account name")
        return probe
    end
    if kind ~= "job" and kind ~= "gang" then
        probe.error = "invalid_group_kind"
        Sky.Debug("error", "[banking] Account probe received invalid group kind '%s'", tostring(kind))
        return probe
    end
    if adapter.resource then
        probe.version = GetResourceMetadata(adapter.resource, "version", 0)
        if GetResourceState(adapter.resource) ~= "started" then
            probe.error = "account_provider_unavailable"
            return probe
        end
    end
    local ok, observation = pcall(adapter.probe, name, kind)
    if Sky.Config.banking ~= probe.provider or Sky.FW.SharedAccountProvisioner ~= adapter then
        probe.error = "account_provider_changed"
        return probe
    end
    if not ok then
        Sky.Debug("error", "[banking] Provider '%s' account probe failed for '%s': %s", probe.provider, name, tostring(observation))
        probe.error = "account_provider_error"
        return probe
    end
    for key, value in pairs(observation) do probe[key] = value end
    return probe
end
function Sky.FW.PrepareSharedAccountRename(old_name, new_name, kind, authorize, recovery_state)
    if kind ~= "job" and kind ~= "gang" then return nil, "invalid_group_kind" end
    local names = { old_name, new_name }
    for index = 1, 2 do
        local name = names[index]
        if type(name) ~= "string" or #name > 64 or not name:match("^[a-z][a-z0-9_]*$") then
            Sky.Debug("error", "[banking] Account rename preparation received an invalid account name.")
            return nil, "invalid_society_account"
        end
    end
    old_name, new_name = old_name:gsub("^society_", ""), new_name:gsub("^society_", "")
    if old_name == "" or new_name == "" then return nil, "invalid_society_account" end
    if old_name == new_name then return nil, "invalid_account_rename" end

    local adapter, facade = Sky.FW.SharedAccountProvisioner, Sky.FW
    local provider, framework, sql = Sky.Config.banking, Sky.Config.framework, Sky.Config.sql
    if not adapter.renameSupported then return nil, "account_rename_unsupported" end
    if adapter.provider ~= provider then return nil, "account_provider_changed" end
    local resource, version = adapter.resource, adapter.resource and GetResourceMetadata(adapter.resource, "version", 0)
    if recovery_state ~= nil and (type(recovery_state) ~= "table" or recovery_state.provider ~= provider
        or recovery_state.resource ~= resource or recovery_state.resourceVersion ~= version
        or recovery_state.framework ~= framework or recovery_state.kind ~= kind or recovery_state.sql ~= sql) then
        return nil, "account_provider_changed"
    end
    local function admit()
        local allowed, error_code = authorize()
        if Sky.FW ~= facade or Sky.FW.SharedAccountProvisioner ~= adapter or Sky.Config.banking ~= provider
            or Sky.Config.framework ~= framework or Sky.Config.sql ~= sql then
            return false, "account_provider_changed"
        end
        if resource then
            if GetResourceState(resource) ~= "started" then return false, "account_provider_unavailable" end
            if GetResourceMetadata(resource, "version", 0) ~= version then return false, "account_provider_changed" end
        end
        if not allowed then return false, error_code or "forbidden" end
        return true
    end
    local ok, plan, error_code = pcall(function()
        local allowed, admission_error = admit()
        if not allowed then return nil, admission_error end
        local prepared, prepare_error = adapter.prepareRename(old_name, new_name, kind, admit, recovery_state)
        allowed, admission_error = admit()
        if not allowed then return nil, admission_error end
        if not prepared then return nil, prepare_error end
        prepared.provider, prepared.resource, prepared.version = provider, resource, version
        prepared.framework, prepared.kind = framework, kind
        prepared.state.provider, prepared.state.resource, prepared.state.resourceVersion = provider, resource, version
        prepared.state.framework, prepared.state.kind, prepared.state.sql = framework, kind, sql
        prepared.state.requestOldName, prepared.state.requestNewName = names[1], names[2]
        return prepared
    end)
    if not ok then
        Sky.Debug("error", "[banking] Provider '%s' account rename preparation failed: %s", tostring(provider), tostring(plan))
        return nil, "account_provider_error"
    end
    return plan, error_code
end
-- Investigation APIs are separate from society balance/money APIs.
Sky.FW.BankInvestigationCapabilities = { accounts = false, statements = false, freeze = false }
Sky.FW.BankPlayerPaymentsSupported = true
function Sky.FW.DebitPlayerBank(source, amount, reason)
    -- Providers owning player accounts override this to enforce their own freeze rules.
    if Sky.FW.BankInvestigationCapabilities.freeze then
        error("Selected bank has no integrated player-debit API")
    end
    return Sky.FW.RemoveAccountMoney(source, "bank", amount, { reason = reason })
end
function Sky.FW.CreditPlayerBank(source, amount, reason)
    if Sky.FW.BankInvestigationCapabilities.freeze then
        error("Selected bank has no integrated player-credit API")
    end
    local before = Sky.FW.GetAccountMoney(source, "bank")
    local result = Sky.FW.AddAccountMoney(source, "bank", amount)
    if result == false then return false end
    -- ESX's account credit is a synchronous void write; verify it before confirming a refund.
    return Sky.FW.GetAccountMoney(source, "bank") == before + amount
end
function Sky.FW.GetBankAccounts(identifier)
    error("Bank account lookup is unsupported by " .. tostring(Sky.Config.banking))
end
function Sky.FW.GetBankAccountTransactions(account_id, offset, limit)
    error("Bank statements are unsupported by " .. tostring(Sky.Config.banking))
end
function Sky.FW.SetBankAccountFrozen(account_id, frozen, actor, reason)
    error("Bank account freezing is unsupported by " .. tostring(Sky.Config.banking))
end
function Sky.FW.EnsureSharedAccount(name, label, kind, options)
    local account_key = tostring(name):gsub("^society_", "")
    if account_locks[account_key] then
        return false, "account_provisioning_busy", { creationAttempted = false, provider = Sky.Config.banking,
            name = account_key, accountName = account_key, kind = kind, status = "blocked", error = "account_provisioning_busy" }
    end
    account_locks[account_key] = true
    local ok, success, error_code, probe = pcall(function()
        local provider, provisioner = Sky.Config.banking, Sky.FW.SharedAccountProvisioner
        local before = Sky.FW.ProbeSharedAccount(name, kind)
        before.creationAttempted = false
        if options and options.authorize and not options.authorize() then return false, "forbidden", before end
        if Sky.Config.banking ~= provider or Sky.FW.SharedAccountProvisioner ~= provisioner then return false, "account_provider_changed", before end
        if before.status == "existing" then
            if options and options.requireNew and (not options.creationReceipt or before.id ~= options.creationReceipt) then
                return false, "account_type_collision", before
            end
            if options and options.requireNew then before.creationReceipt = options.creationReceipt end
            return true, nil, before
        end
        if before.status == "blocked" then return false, before.error, before end
        if options and options.existingOnly then return false, "account_persistence_pending", before end
        if not before.canCreate or options and options.requireNew and not Sky.FW.SharedAccountProvisioner.freshCreationSupported then return false, "account_creation_unsupported", before end
        if options and options.authorize and not options.authorize() then return false, "forbidden", before end
        if Sky.Config.banking ~= provider or Sky.FW.SharedAccountProvisioner ~= provisioner then return false, "account_provider_changed", before end
        before.creationAttempted = true
        local created, result, receipt, attempted = pcall(provisioner.create, before.name, label, before.kind, options)
        if created and attempted == false then before.creationAttempted = false end
        if options and options.requireNew and created and result == true and receipt then before.creationReceipt = receipt end
        if options and options.authorize and not options.authorize() then return false, "forbidden", before end
        if Sky.Config.banking ~= provider or Sky.FW.SharedAccountProvisioner ~= provisioner then return false, "account_provider_changed", before end
        if not created then
            Sky.Debug("error", "[banking] Provider '%s' account creation failed for '%s': %s", before.provider, before.name, tostring(result))
        end
        local after = Sky.FW.ProbeSharedAccount(before.name, before.kind)
        after.creationAttempted = before.creationAttempted
        if before.creationReceipt then after.creationReceipt = before.creationReceipt end
        if options and options.authorize and not options.authorize() then return false, "forbidden", after end
        if Sky.Config.banking ~= provider or Sky.FW.SharedAccountProvisioner ~= provisioner then return false, "account_provider_changed", after end
        if options and options.requireNew then
            if not created or result ~= true or not receipt or after.id ~= receipt or after.status ~= "existing" then
                return false, after.error or "account_persistence_pending", after
            end
            after.creationReceipt = receipt
        end
        if after.status == "existing" then return true, nil, after end
        return false, after.error or "account_persistence_pending", after
    end)
    account_locks[account_key] = nil
    if not ok then
        Sky.Debug("error", "[banking] Account ensure failed for '%s': %s", tostring(name), tostring(success))
        return false, "account_provider_error"
    end
    return success, error_code, probe
end
