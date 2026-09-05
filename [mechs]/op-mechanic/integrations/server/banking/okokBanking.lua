if Config.Banking ~= 'okokBanking' then return end

function getAccountMoney(jobName)
    local account = exports['okokBanking']:GetAccount(jobName)
    if type(account) == 'table' then
        return account.money or 0
    end
    return tonumber(account) or 0
end

function addAccountMoney(jobName, amount)
    exports['okokBanking']:AddMoney(jobName, amount)
end

function removeAccountMoney(jobName, amount)
    exports['okokBanking']:RemoveMoney(jobName, amount)
end