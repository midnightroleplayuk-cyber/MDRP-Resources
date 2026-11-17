
TwSecrets = TwSecrets or {}

TwSecrets.Discord = {
    botToken = "",

    webhooks = {
        default   = "https://discord.com/api/webhooks/1546200335050080299/wWjKZ8E2gAvTh7pvscDcqDJcOY6FXh_BOnHv2EPtGRa6yDNEeP2dlsfRoKDMSjxoA4Us",
        jobstart  = "",
        jobfinish = "",
        lobby     = "",
        economy   = "",
        admin     = "",
        security  = "",
        error     = "",
    },
}

CreateThread(function()
    local tok = GetConvar('tw_builder_discord_token', '')
    if tok ~= '' then TwSecrets.Discord.botToken = tok end

    for cat in pairs(TwSecrets.Discord.webhooks) do
        local v = GetConvar('tw_builder_webhook_' .. cat, '')
        if v ~= '' then TwSecrets.Discord.webhooks[cat] = v end
    end
end)
