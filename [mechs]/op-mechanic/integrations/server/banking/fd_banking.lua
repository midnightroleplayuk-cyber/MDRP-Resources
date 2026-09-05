if Config.Banking ~= 'fd_banking' then return end

function getAccountMoney(jobName)
    local account = exports.fd_banking:GetAccount(jobName)
    if type(account) == 'table' then
        return account.money or 0
    end
    return tonumber(account) or 0
end

function addAccountMoney(jobName, amount)
    exports.fd_banking:AddMoney(jobName, amount)
end

function removeAccountMoney(jobName, amount)
    exports.fd_banking:RemoveMoney(jobName, amount, '')
end