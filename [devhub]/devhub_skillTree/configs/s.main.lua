-- update 2.0.0

-- REMEMBER your framework is not available here, to use it you have to register it in this file
-- you can use devhub_lib functions
Config.CategoryVisibilityHandler = {
    ['personal'] = function(source)
        -- this is triggered server side
        -- return false to hide the category
        return true
    end,
}

-- update 2.0.1

-- Here you can define your logs settings for each action
-- If value is set to false, log will not be sent
-- DISABLE EXAMPLE
-- Config.Logs = {
--     ['addXp'] = false,  -- LOG WILL NOT BE SENDED
-- }
-- If you are using database logs set it to your table name and configure it in devhub_lib
Config.Logs = {
    ['addXp'] = "https://discord.com/api/webhooks/00000000000000000", 
    ['addPoints'] = "https://discord.com/api/webhooks/00000000000000000",
    ['removePoints'] = "https://discord.com/api/webhooks/00000000000000000",
    ['removeXp'] = "https://discord.com/api/webhooks/00000000000000000",
    ['levelUp'] = "https://discord.com/api/webhooks/00000000000000000",
    ['unlockSkill'] = "https://discord.com/api/webhooks/00000000000000000",
    ['skillReset'] = "https://discord.com/api/webhooks/00000000000000000",
    -- security logs
    ['suspiciousActivityLowPriority'] = "https://discord.com/api/webhooks/00000000000000000",  -- this can also detect lag spikes and connection issues
    ['suspiciousActivityHighPriority'] = "https://discord.com/api/webhooks/00000000000000000", -- most likely a cheater
}

--------------------
-- Security settings
--------------------

-- This setting will disable following client exports and connected events:
-- client export addXp
-- client export addPoints

-- Note: It is highly advised to keep this option enabled and transition scripts to utilize server-side exports only. !!!

Config.DisableSensitiveClientExports = true

-- Function that will be triggered when a suspected cheater is detected

Config.SuspiciousActivity = function(source, privateReason, priority)
    -- privateReason is the reason with exact details do not show it to player
    -- keep in mind that there is a small chance that it can return false positive for example when player got long lag spike or lost internet connection

    if priority == 'high' then
        -- most likely a cheater
        -- DropPlayer(source, 'Skill Tree: Suspicious activity detected')
    elseif priority == 'low' then
        -- this can also detect lag spikes and connection issues
    end
end

-- update 2.2.0

-- Use it with caution! It might be used in a malicious way or cause script to not work properly if you are not careful.
-- Try unlocking only skills that have active connection to other unlocked skills.
Config.TurnOnUnlockSkillExport = false -- bool | Turn on export for unlocking skills, this will allow you to unlock skills from other scripts, it will skip all requirements.

AddEventHandler('txAdmin:events:scheduledRestart', function(eventData)
    local secondsRemaining = eventData.secondsRemaining
    if tostring(secondsRemaining) == "120" then
        TriggerClientEvent('devhub_skillTree:client:forceSyncOfCachedXp', -1)
    end
end)

RegisterCommand('addXp', function(source, args)
    if not Core.IsPlayerAdmin(source) then
        print("You do not have permission to use this command.")
        return
    end
    -- Example command to add xp for testing
    -- Usage: /addXp [category] [amount]
    local category = args[1]
    local amount = tonumber(args[2])
    if amount then
        exports['devhub_skillTree']:addXp(category, amount, source)
    else
        print("Invalid amount")
    end
end, false)

RegisterCommand('addPoints', function(source, args)
    if not Core.IsPlayerAdmin(source) then
        print("You do not have permission to use this command.")
        return
    end
    -- Example command to add points for testing
    -- Usage: /addPoints [category] [amount]
    local category = args[1]
    local amount = tonumber(args[2])
    if amount then
        exports['devhub_skillTree']:addPoints(category, amount, source)
    else
        print("Invalid amount")
    end
end, false)