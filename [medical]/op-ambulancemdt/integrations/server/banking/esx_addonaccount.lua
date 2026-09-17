if Config.Banking ~= "esx_addonaccount" then return end

function getAccountMoney(jobName)
    local account = exports['esx_addonaccount']:GetSharedAccount('society_' .. jobName)
    if not account then return 0 end
    
    return account.money
end

function addAccountMoney(jobName, amount) 
    local account = exports['esx_addonaccount']:GetSharedAccount('society_' .. jobName)
    if not account then return end

    account.addMoney(amount)
end

function removeAccountMoney(jobName, amount)
    local account = exports['esx_addonaccount']:GetSharedAccount('society_' .. jobName)
    if not account then return end
    
    account.removeMoney(amount)
end