--[[
    Apex MDT - Locale loader (shared client + server)
    ────────────────────────────────────────────────────────────
        L('saved')            → active locale, then EN fallback, then key
        L('status_set', code) → printf-style substitution
        GetLocaleTable(lang)  → whole table (shipped to the NUI on open)
]]

Locales = Locales or {}

local function pickLocale()
    return (Config and Config.locale) or 'en'
end

function L(key, ...)
    local lang  = pickLocale()
    local tbl   = Locales[lang] or Locales.en or {}
    local entry = tbl[key] or (Locales.en and Locales.en[key]) or key
    if select('#', ...) > 0 then
        local ok, formatted = pcall(string.format, entry, ...)
        if ok then return formatted end
    end
    return entry
end

function GetLocaleTable(lang)
    lang = lang or pickLocale()
    return Locales[lang] or Locales.en or {}
end
