Logging = {
    Provider = "discord",

    Discord = {
        ProfanityWebhook = "YOUR_WEBHOOK_URL",
        ReportWebhook    = "YOUR_WEBHOOK_URL",
        BotName          = "CX Chat Protection & Report System",
        BotIcon          = "https://cxsper.dev/assets/branding/logo.png"
    },

    Fivemanage = {
        Token = "YOUR_TOKEN",
        LogId = "YOUR_LOG_ID"
    },

    Fivemerr = {
        ApiKey = "YOUR_API_KEY"
    }
}

function CXLog(type, data)
    local provider = Logging.Provider
    if provider == "none" then return end

    if provider == "discord" then
        local url = (type == "report") and Logging.Discord.ReportWebhook or Logging.Discord.ProfanityWebhook
        if not url or url == "" then return end
        PerformHttpRequest(url, function() end, 'POST', json.encode({
            username   = Logging.Discord.BotName,
            avatar_url = Logging.Discord.BotIcon,
            embeds     = { data.embed }
        }), { ['Content-Type'] = 'application/json' })

    elseif provider == "ox_lib" and GetResourceState('ox_lib') == 'started' then
        lib.logger(-1, type, data.description)

    elseif provider == "fivemanage" then
        PerformHttpRequest("https://api.fivemanage.com/v1/logs", function() end, 'POST', json.encode({
            token    = Logging.Fivemanage.Token,
            logId    = Logging.Fivemanage.LogId,
            message  = data.description,
            metadata = data.metadata
        }), { ['Content-Type'] = 'application/json' })

    elseif provider == "fivemerr" then
        PerformHttpRequest("https://api.fivemerr.com/v1/logs", function() end, 'POST', json.encode({
            source   = "cx-chat",
            message  = data.description,
            metadata = data.metadata
        }), { ['Content-Type'] = 'application/json', ['Authorization'] = Logging.Fivemerr.ApiKey })
    end
end
