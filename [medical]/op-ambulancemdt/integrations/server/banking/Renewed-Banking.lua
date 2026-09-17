if Config.Banking ~= "Renewed-Banking" then return end

function getAccountMoney(jobName)
    local accountMoney = exports['Renewed-Banking']:getAccountMoney(jobName)
    return accountMoney
end

function addAccountMoney(jobName, amount) 
    exports['Renewed-Banking']:addAccountMoney(jobName, amount, '')
end

function removeAccountMoney(jobName, amount)
    exports['Renewed-Banking']:removeAccountMoney(jobName, amount, '')
end