if Config.Banking ~= "fd_banking" then return end

function getAccountMoney(jobName)
    local account = exports.fd_banking:GetAccount(jobName)
    debugPrint("getAccountMoney", json.encode(account))
    return account.money
end

function addAccountMoney(jobName, amount) 
    exports.fd_banking:AddMoney(jobName, amount)
end

function removeAccountMoney(jobName, amount)
    exports.fd_banking:RemoveMoney(jobName, amount, "")
end