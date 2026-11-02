if Config.BillingCommand then
    lib.addCommand(Config.BillingCommand, {
        help = 'Player Invoices',
        params = {},
    }, function(source)
        TriggerClientEvent('av_business:openBilling', source)
    end)
end

if Config.JobBillCommand then
    lib.addCommand(Config.JobBillCommand, {
        help = 'Job Billing Menu',
        params = {},
    }, function(source)
        openBillMenu(source)
    end)
end

lib.addCommand(Config.Command, {
    help = 'Business Admin',
    params = {},
    restricted = Config.AdminLevel
}, function(source)
    TriggerClientEvent('av_business:openAdmin', source)
end)

function isAdmin(playerId) -- Used for admin panel actions
    local result = IsPlayerAceAllowed(playerId, ('command.%s'):format(Config.Command)) -- run the default admin check
    dbug("isAdmin(result)", result)
    return result
end