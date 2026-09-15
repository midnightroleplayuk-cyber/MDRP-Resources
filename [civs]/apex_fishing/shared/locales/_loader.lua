--[[
    Apex Fishing — Locale loader
    ────────────────────────────────────────────────────────────
    Every locale file adds to the global Locales table:
        Locales = Locales or {}
        Locales.en = { key = 'value', ... }

    The runtime resolver:
        L('greeting')              → looks up in active locale,
                                     then falls back to EN, then
                                     returns the key itself.
        L('caught', 'Sardine')     → printf-style substitution.

    Both server and client use the same Locales table because
    this file is shared.
]]

Locales = Locales or {}

local function pickLocale()
    return (Config and Config.locale) or 'en'
end

function L(key, ...)
    local lang  = pickLocale()
    local table = Locales[lang] or Locales.en or {}
    local entry = table[key] or (Locales.en and Locales.en[key]) or key
    if select('#', ...) > 0 then
        -- Use pcall around format so a missing % token in a key
        -- doesn't blow up the caller.
        local ok, formatted = pcall(string.format, entry, ...)
        if ok then return formatted end
    end
    return entry
end

-- Optional: expose all keys for a locale (used by NUI bootstrap
-- to ship strings to the browser side).
function GetLocaleTable(lang)
    lang = lang or pickLocale()
    return Locales[lang] or Locales.en or {}
end
