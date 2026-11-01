--[[
    Apex Gangs — Locale loader (shared). Defines the global L(key, ...)
    resolver used everywhere, with active-locale → en fallback → key.
]]

Locales = Locales or {}

function L(key, ...)
    local lang = (Config and Config.locale) or 'en'
    local tbl = Locales[lang] or Locales['en'] or {}
    local str = tbl[key]
    if str == nil and lang ~= 'en' then str = (Locales['en'] or {})[key] end
    if str == nil then return key end
    if select('#', ...) > 0 then
        local ok, res = pcall(string.format, str, ...)
        if ok then return res end
    end
    return str
end

function GetLocaleTable(lang)
    return Locales[lang or (Config and Config.locale) or 'en'] or Locales['en'] or {}
end
