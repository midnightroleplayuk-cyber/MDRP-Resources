if Sky.Config.banking ~= "bablo" then return end
if not IsDuplicityVersion() then return end

local RESOURCE = "bablo-banking"

local function mutation_succeeded(result)
    if type(result) == "table" then return result.success == true end
    return result == true
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
    end,
    create = function(name, label)
        local result = exports[RESOURCE]:RegisterSociety(name, { label = label or name })
        return mutation_succeeded(result)
    end
}

function Sky.FW.GetSharedAccountBalance(name, options)
    local account_name = name:gsub("^society_", "")
    local balance = exports[RESOURCE]:GetSocietyBalance(account_name)
    if type(balance) == "number" then return balance end
    if options and options.strict then
        error("[banking/bablo] Society balance unavailable: " .. account_name)
    end
    return 0
end

function Sky.FW.AddSharedAccountBalance(name, amount, options)
    local account_name = name:gsub("^society_", "")
    return mutation_succeeded(exports[RESOURCE]:AddSocietyMoney(account_name, amount, "sky_base"))
end

function Sky.FW.RemoveSharedAccountBalance(name, amount, options)
    local account_name = name:gsub("^society_", "")
    return mutation_succeeded(exports[RESOURCE]:RemoveSocietyMoney(account_name, amount, { description = "sky_base" }))
end
