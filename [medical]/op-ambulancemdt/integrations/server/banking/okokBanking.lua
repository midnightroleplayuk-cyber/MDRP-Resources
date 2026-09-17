if Config.Banking ~= "okokBanking" then return end

function getAccountMoney(jobName)
    local account = exports['okokBanking']:GetAccount(jobName)
    debugPrint("getAccountMoney", json.encode(account))
    return account.money
end

function addAccountMoney(jobName, amount) 
    exports['okokBanking']:AddMoney(jobName, amount)
end

function removeAccountMoney(jobName, amount)
    exports['okokBanking']:RemoveMoney(jobName, amount)
end