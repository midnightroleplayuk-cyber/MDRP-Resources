if Sky.Config.banking ~= "ak47" then return end
if not IsDuplicityVersion() then return end

local RESOURCE = "ak47_banking"
local REASON = "Sky Systems"

Sky.FW.SharedAccountProvisioner = {
    resource = RESOURCE,
    probe = function(name, kind)
        local result = { accountName = name, accountType = "job", canCreate = false }
        if kind ~= "job" then
            result.status, result.error = "blocked", "account_creation_unsupported"
            return result
        end

        local balance = exports[RESOURCE]:GetAccountBalance(name)
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
    local account_name = name:gsub("^society_", "")
    local balance = exports[RESOURCE]:GetAccountBalance(account_name)
    if type(balance) ~= "number" then error("[banking/ak47] Society balance unavailable: " .. account_name) end
    return balance
end

function Sky.FW.AddSharedAccountBalance(name, amount, options)
    return exports[RESOURCE]:AddMoney(name:gsub("^society_", ""), amount, REASON)
end

function Sky.FW.RemoveSharedAccountBalance(name, amount, options)
    return exports[RESOURCE]:RemoveMoney(name:gsub("^society_", ""), amount, REASON)
end

function Sky.FW.DebitPlayerBank(source, amount, reason)
    return exports[RESOURCE]:RemovePlayerBankMoney(source, amount, reason or REASON)
end

function Sky.FW.CreditPlayerBank(source, amount, reason)
    return exports[RESOURCE]:AddPlayerBankMoney(source, amount, reason or REASON)
end
