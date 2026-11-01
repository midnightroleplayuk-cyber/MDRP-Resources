if Sky.Config.banking ~= "rx" then return end
if not IsDuplicityVersion() then return end

local RESOURCE = "RxBanking"

Sky.FW.SharedAccountProvisioner = {
    resource = RESOURCE,
    probe = function(name, kind)
        local result = { accountName = name, accountType = "job", canCreate = false }
        if kind ~= "job" then
            result.status, result.error = "blocked", "account_creation_unsupported"
            return result
        end

        local account = exports[RESOURCE]:GetSocietyAccount(name)
        local balance = account and account.balance
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
    local account = exports[RESOURCE]:GetSocietyAccount(account_name)
    if not account or type(account.balance) ~= "number" then
        error("[banking/rx] Society balance unavailable: " .. account_name)
    end
    return account.balance
end

function Sky.FW.AddSharedAccountBalance(name, amount, options)
    return exports[RESOURCE]:AddSocietyMoney(name:gsub("^society_", ""), amount, "deposit", "sky_base")
end

function Sky.FW.RemoveSharedAccountBalance(name, amount, options)
    return exports[RESOURCE]:RemoveSocietyMoney(name:gsub("^society_", ""), amount, "withdraw", "sky_base")
end
