if Config.Banking ~= 'p_banking' then return end

function getAccountMoney(jobName)
    return exports['p_banking']:getAccountMoney(jobName)
end

function addAccountMoney(jobName, amount)
    exports['p_banking']:addAccountMoney(jobName, amount)
end

function removeAccountMoney(jobName, amount)
    exports['p_banking']:removeAccountMoney(jobName, amount)
end