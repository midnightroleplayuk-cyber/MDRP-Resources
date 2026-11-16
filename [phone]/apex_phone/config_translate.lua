-- ------------------------------------------------------------
-- TRANSLATE ("Tradutor"): translates text between the 15 phone languages with Google Gemini,
-- using the SAME key and models as Vera Chat (Config.AI in config.lua, key in server/ai_key.lua
-- or the convar apex_phone_gemini_key). Without a key the app still works with its built in
-- offline phrasebook; only live translation is unavailable.
--
-- Results are cached on the server (same text + same language pair = no second API request).
-- ------------------------------------------------------------
Config.Translate = {
    enabled = true,
    perDay = 150,          -- live translations per character per day (UTC day)
    maxChars = 1000,       -- longest text accepted
    cacheHours = 24,       -- how long a translation stays cached (memory + apex_phone_translate_cache)
    cacheRows = 20000,     -- rows kept in the cache table (oldest go first)
    -- models tried in order; nil = Config.AI.models
    models = nil,
    -- conversation mode (two people, two languages) uses the same limits; each side is one request
}
