Config = Config or {}
Config.BillingCommand = "billing" -- Open the user panel where player can see all his bills and pay them or false to open it from your own menu/script
Config.JobBillCommand = "billjob" -- Open the job billing menu (the same from business app but without laptop) or false
Config.BillingDistance = 20.0 -- Distance between the customer and the employee, we don't want players sending invoices to random ppl all around the map...
Config.MaxDaysLimit = 5 -- After X days, the amount will be automatically deducted from the player's bank account
Config.RemovePaid = 3 -- Remove paid invoices after X days, we don't want the DB to be full or unused data
Config.AvailableAccounts = { -- Available payment options for player, the canUse function is server side NOT client
    {value = "bank", label = "Bank Account", canUse = function(source) return true end},
    {value = "cash", label = "Cash", canUse = function(source) return true end}, -- change value to money if using ESX
    {value = "society", label = "Society Funds", canUse = function(source) return exports['av_laptop']:isBoss(source) end},
}
-- Jobs authorized to bypass customer confirmation for billing
-- Useful if your players refuse to accept/pay the EMS bill after being revived
Config.DirectBillJobs = {
    -- ['ambulance'] = true,
    -- ['job2'] = true,
    -- ['job3'] = true,
    -- ['job4'] = true,
    -- ['job5'] = true,
}
-- Max amount for direct billing; amounts above this value require customer approval
-- Only works for jobs in the Config.DirectJobs table
Config.DirectBillMax = 100

-- The following events are triggered when a player receives money
-- The script will verify if the player have some expired bill and remove the money automatically to pay it

local identifiers = {}

AddEventHandler('QBCore:Player:SetPlayerData', function(Player)
    if Player then
        runExpired(Player.source,Player.citizenid)
    end
end)

AddEventHandler('esx:addAccountMoney', function(src, account)
    local cid = identifiers[src] or exports['av_laptop']:getIdentifier(src)
    identifiers[src] = cid
    if account == Config.BankAccount then
        runExpired(src,cid)
    end
end)

AddEventHandler('esx:setAccountMoney', function(src, account)
    local cid = identifiers[src] or exports['av_laptop']:getIdentifier(src)
    identifiers[src] = cid
    if account == Config.BankAccount then
        runExpired(src,cid)
    end
end)