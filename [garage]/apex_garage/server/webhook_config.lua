--[[============================================================================
    apex_garage — server/webhook_config.lua   (open source, edit freely)
    ----------------------------------------------------------------------------
    DISCORD WEBHOOKS — leave every URL empty to disable logging completely.

    WHY THIS IS NOT IN shared/config.lua
        shared/config.lua is a shared_script: every connected player downloads
        it. A webhook URL is a password — anyone holding it can post anything
        into your channel or delete the webhook outright. So the URLs live here,
        in a server_script, and never leave your machine. Everything else about
        this feature is still configured in this one file, exactly like the rest
        of the config.

    HOW TO USE ONE WEBHOOK FOR EVERYTHING
        Paste your URL into Config.webhooks.url and leave every category empty:

            Config.webhooks.url = 'https://discord.com/api/webhooks/123/abc'

        Everything the resource logs then lands in that one channel.

    HOW TO SPLIT BY CATEGORY
        Fill in the category you want somewhere else. A category URL always
        wins over the global one:

            Config.webhooks.url    = 'https://.../everything'
            Config.webhooks.admin  = 'https://.../staff-only'   -- admin lines go here instead

    HOW TO SWITCH ONE CATEGORY OFF
        Set Config.webhooks.enabled['<category>'] = false. That category then
        does nothing at all — no HTTP request, no work, no error. Deleting the
        category URL while the global URL is set would otherwise still send it
        to the global channel, so `enabled` is the real per-category switch.

    A NOTE ON DISCORD RATE LIMITS
        A webhook accepts roughly 5 requests/second. 'garage' and 'parking' are
        the high-volume categories on a busy server; 'security', 'economy' and
        'admin' are rare but are the ones you must not lose. If you only use the
        global URL, a burst of take-outs can silently drop an admin line. Giving
        'security' / 'economy' / 'admin' their own URL costs nothing and removes
        the problem entirely. This is the recommended setup.
============================================================================]]

Config = Config or {}

Config.webhooks = {

    -- The catch-all. Used by any category that has no URL of its own.
    url = '',

    -- ------------------------------------------------------------------------
    -- Per-category overrides. Empty = fall back to Config.webhooks.url above.
    -- ------------------------------------------------------------------------

    -- Vehicles moving in and out of storage: take-out, recovery (tow fee),
    -- store, transfer between garages, transfer to another player.
    -- HIGH VOLUME — this is most of your traffic.
    garage           = '',

    -- Refused actions and tampering: impound-gate refusals, a client sending a
    -- model that does not match the stored row, forged impound props.
    -- Low volume, high value. Give this its own channel.
    security         = '',

    -- Money: instant sells, failed sell payouts, impound fee refunds.
    economy          = '',

    -- Impounds: officer impounds, collections, officer releases, and impounds
    -- performed by other resources through the export.
    impound          = '',

    -- Persistent parking: park, unpark, release, tow-away, failed/rolled back
    -- parks. Medium-to-high volume on a server that parks a lot.
    parking          = '',

    -- Admin actions: /vreturn, /vplate, /dvdb, parking settings and
    -- permissions, no-parking zones, theme changes, the return export.
    admin            = '',

    -- Garages created, edited or deleted in-game, and job-garage vehicle
    -- management done by a boss.
    ['garage-admin'] = '',

    -- Private garages created and deleted.
    private          = '',

    -- ------------------------------------------------------------------------
    -- Per-category on/off. false = that category never sends, even if the
    -- global URL is set. All true by default: with no URLs configured nothing
    -- is sent anyway, so an upgrading server gains nothing it did not ask for.
    -- ------------------------------------------------------------------------
    enabled = {
        garage           = true,
        security         = true,
        economy          = true,
        impound          = true,
        parking          = true,
        admin            = true,
        ['garage-admin'] = true,
        private          = true,
    },

    -- Name shown as the author of every embed in Discord.
    username = 'Apex Garage',
}
