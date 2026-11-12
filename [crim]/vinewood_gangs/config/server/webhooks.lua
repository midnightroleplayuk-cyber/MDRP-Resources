-- Discord webhooks. SERVER ONLY: this file is never sent to players' games, so your webhook URLs stay private.
--
-- Paste a webhook URL into any channel below (Discord: channel settings > Integrations > Webhooks > New Webhook >
-- Copy Webhook URL). Leave a channel '' to switch it off. To keep URLs out of this file altogether, write
-- 'convar:my_convar_name' and put  set my_convar_name "https://discord.com/api/webhooks/..."  in server.cfg.

Config.Webhooks = {
    enabled = true,

    -- How the messages look in Discord
    username = 'Vinewood Gangs',
    avatar   = '',            -- an image URL for the bot's picture, or '' for Discord's default

    channels = {
        staff   = '',   -- everything done in /gangadmin: items and packages given, turf given, settings, heists edited
        gangs   = '',   -- gangs created and disbanded, members joining, leaving, promoted, ranks, diplomacy deals
        money   = '',   -- treasury deposits and withdrawals (clean and dirty), shop purchases, washing money
        turf    = '',   -- hexes bought, taken by a racket, or lost; tags sprayed, cleaned, designs reviewed
        rackets = '',   -- shops agreeing to pay, collections, takeovers; businesses and supply runs
        heists  = '',   -- heists started, finished or failed, and the loot taken
        events  = '',   -- air drops, black market auctions, city events, contracts
        police  = '',   -- safehouse raids and searches, informants, undercover busts, leaks
    },

    -- Optional: one more webhook that gets EVERYTHING (on top of the channels above)
    everything = '',

    -- Show the player's Discord and licence identifiers in each message (IP addresses are never sent)
    showIdentifiers = true,

    -- Events you don't want sent at all, by name (as in the logs), e.g. { 'tag_cleaned', 'auction_bid' }
    ignore = { 'auction_bid' },

    -- Colours per channel (decimal)
    colours = {
        staff = 5793266, gangs = 7317951, money = 5763719, turf = 15105570,
        rackets = 15844367, heists = 15548997, events = 3447003, police = 2123412,
    },
}
