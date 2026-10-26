-- =============================================================
--  SERVER-ONLY CONFIG
--  This file is never sent to clients, so secrets are safe here.
-- =============================================================

Config = Config or {}

Config.Fivemanage = {
    -- Paste your Fivemanage API token between the quotes.
    ApiKey = '',

    -- Leave these alone unless Fivemanage change their API.
    Endpoint = 'https://api.fivemanage.com/api/v3/file/base64'
}

-- Update check. Point Url at a plain-text file containing just the latest
-- version number (e.g. a raw GitHub gist or a file on your own site).
-- Leave Url empty to disable the check entirely.
Config.VersionCheck = {
    Enabled = true,
    Url = ''
}
