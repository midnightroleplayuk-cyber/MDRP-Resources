if Config.Banking ~= "qb-banking" then return end

function getAccountMoney(jobName)
    local accountMoney = exports['qb-banking']:GetAccountBalance(jobName)
    return accountMoney
end

function addAccountMoney(jobName, amount) 
    exports['qb-banking']:AddMoney(jobName, amount, '')
end

function removeAccountMoney(jobName, amount)
    exports['qb-banking']:RemoveMoney(jobName, amount, '')
end