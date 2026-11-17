-- ------------------------------------------------------------
-- Google Gemini API key for the Vera Chat assistant. SERVER SIDE ONLY.
--
-- How to set it (pick one):
--   1. Recommended: in server.cfg add
--          set apex_phone_gemini_key "YOUR_KEY_HERE"
--      (use `set`, never `setr`: `setr` replicates the value to every player).
--   2. Or paste the key between the quotes of the fallback below.
-- The server.cfg convar always wins over this file.
-- Get a key at https://aistudio.google.com/app/apikey
--
-- Never put the key in config.lua: it is a shared script and every player downloads it.
-- Without a key the phone works normally; only Vera Chat requests fail with a "no key" error.
-- ------------------------------------------------------------
Config.AI = Config.AI or {}
local fromCfg = GetConvar('apex_phone_gemini_key', '')
Config.AI.ApiKey = fromCfg ~= '' and fromCfg or ''
