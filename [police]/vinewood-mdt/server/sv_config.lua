-- Server-only settings. This file is a server_script, so it is never sent to players.
SvConfig = {}

-- Custody photos are uploaded to Fivemanage. Paste a media API key here.
-- (Falls back to the "fivemanage_key" convar if left empty, same as citydriving.)
SvConfig.Fivemanage = {
    ApiKey = 'SwMM3lrxnKw7NLKKc6nuqFudyV1jmr8L',
    Endpoint = 'https://api.fivemanage.com/api/v3/file/base64',
}

-- Discord webhooks. Leave a channel empty to switch it off.
SvConfig.Webhooks = {
    Username = 'PNC / MDT',
    Avatar = '',              -- image URL, optional
    Channels = {
        audit = '',           -- record views, searches and sensitive changes
        custody = '',         -- booked in, outcomes, bail, NFA, reviews, extensions, photos
        warrants = '',        -- recorded, executed, cancelled
        cps = '',             -- submitted, decisions
        fines = '',           -- issued, paid, traffic offence reports, court results
        statements = '',      -- taken, signed, refused
        stopsearch = '',
        anpr = '',            -- ANPR hits
    },
    -- Searches are noisy. true = every search goes to the audit channel too.
    AuditSearches = false,
}
