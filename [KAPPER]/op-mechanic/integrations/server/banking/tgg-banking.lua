if Config.Banking ~= 'tgg-banking' then return end

function getAccountMoney(jobName)
    local money = exports['tgg-banking']:GetSocietyAccountMoney(jobName)
    return tonumber(money) or 0
end

function addAccountMoney(jobName, amount)
    exports['tgg-banking']:AddSocietyMoney(jobName, amount)
end

function removeAccountMoney(jobName, amount)
    exports['tgg-banking']:RemoveSocietyMoney(jobName, amount)
end