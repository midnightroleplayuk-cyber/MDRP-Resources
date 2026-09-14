Config = {}

-- @param MoneyType - "cash" or "bank"
Config.MoneyType = "cash" -- Player will receive money to cash or bank for finishing the job.
-- @param MoneyTypeQuest - "cash" or "bank"
Config.MoneyTypeQuest = "cash" -- Player will receive money to cash or bank for finishing the quest.
-- @param MoneyTypeVehicle - "cash" or "bank"
Config.MoneyTypeVehicle = "bank" -- Player will pay and receive money to/from cash or bank for vehicle transactions.
 
Config.Webhook = "https://discord.com/api/webhooks/890000000000000000/"

Config.ItemReward = {
    -- {
    --     name = "wood",
    --     amount = 1,
    -- },
}

function SuspiciousActivity(source, threatLevel)
    -- You can use all Core functions from devhub_lib like Core.GetIdentifier(source) 
    -- threatLevel ['low', 'high']
    -- 'low' - can also be triggered when player have issues with internet connection or spammed sell option, cheaters will also be shown here
    -- 'high' - 99% sure that player is cheating, or player who ended job in less then a min
end

function CustomReward(source, level)
    -- You can use all Core functions from devhub_lib like Core.GetIdentifier(source) 
    -- This function will be called when player finishes the job
    TriggerClientEvent('dh_guidebook:client:questProgress', source, 'dh_jobs:poolcleaner:completedJob')
end