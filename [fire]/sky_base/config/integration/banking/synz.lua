if Sky.Config.banking ~= "synz" then return end
if not IsDuplicityVersion() then return end

local RESOURCE = "synz_banking"

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
            result.id = name
        else
            error("Invalid provider account balance for '" .. result.accountName .. "': " .. tostring(balance))
        end
        return result
    end
}

function Sky.FW.GetSharedAccountBalance(name, options)
    local account_name = name:gsub("^society_", "")
    local balance = exports[RESOURCE]:GetSocietyBalance(account_name)
    if type(balance) ~= "number" then error("[banking/synz] Society balance unavailable: " .. account_name) end
    return balance
end

function Sky.FW.AddSharedAccountBalance(name, amount, options)
    return exports[RESOURCE]:AddSocietyMoney(name:gsub("^society_", ""), amount, "sky_base")
end

function Sky.FW.RemoveSharedAccountBalance(name, amount, options)
    return exports[RESOURCE]:RemoveSocietyMoney(name:gsub("^society_", ""), amount, "sky_base")
end
