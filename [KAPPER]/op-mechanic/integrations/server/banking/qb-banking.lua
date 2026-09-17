if Config.Banking ~= 'qb-banking' then return end

function getAccountMoney(jobName)
    local money = exports['qb-banking']:GetAccountBalance(jobName)
    return tonumber(money) or 0
end

function addAccountMoney(jobName, amount)
    exports['qb-banking']:AddMoney(jobName, amount, '')
end

function removeAccountMoney(jobName, amount)
    exports['qb-banking']:RemoveMoney(jobName, amount, '')
end