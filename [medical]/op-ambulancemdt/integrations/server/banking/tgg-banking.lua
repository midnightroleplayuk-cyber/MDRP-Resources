if Config.Banking ~= "tgg-banking" then return end

function getAccountMoney(jobName)
    local accountMoney = exports['tgg-banking']:GetSocietyAccountMoney(jobName)
    return accountMoney
end

function addAccountMoney(jobName, amount) 
    exports['tgg-banking']:AddSocietyMoney(jobName, amount)
end

function removeAccountMoney(jobName, amount)
    exports['tgg-banking']:RemoveSocietyMoney(jobName, amount)
end