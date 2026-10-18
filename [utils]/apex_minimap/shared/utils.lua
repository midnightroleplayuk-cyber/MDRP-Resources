--[[
    Apex Minimap Studio — Shared Utils
    ────────────────────────────────────────────────────────────
    Logging helpers + the L() locale resolver used on both sides.
]]

Utils = Utils or {}

local PREFIX = '^5[apex_minimap]^7'

function Utils.Log(...)
    if not (Config and Config.debug) then return end
    local parts = {}
    for i = 1, select('#', ...) do parts[#parts + 1] = tostring(select(i, ...)) end
    print(PREFIX .. ' ' .. table.concat(parts, ' '))
end

function Utils.Warn(...)
    local parts = {}
    for i = 1, select('#', ...) do parts[#parts + 1] = tostring(select(i, ...)) end
    print('^3[apex_minimap]^7 ' .. table.concat(parts, ' '))
end

function Utils.Err(...)
    local parts = {}
    for i = 1, select('#', ...) do parts[#parts + 1] = tostring(select(i, ...)) end
    print('^1[apex_minimap]^7 ' .. table.concat(parts, ' '))
end

function Utils.Trim(s)
    return (tostring(s or ''):gsub('^%s*(.-)%s*$', '%1'))
end

-- ─── Locale ─────────────────────────────────────────────────
-- L('key', 'fallback %s', arg1, ...) — looks the key up in the
-- active locale, falls back to English, then to the fallback
-- string. Extra args are string.format'ed in.

Locales = Locales or {}

function L(key, fallback, ...)
    local msg
    local active = Locales[Config and Config.locale or 'en']
    if active and active[key] then
        msg = active[key]
    elseif Locales.en and Locales.en[key] then
        msg = Locales.en[key]
    else
        msg = fallback or key
    end
    if select('#', ...) > 0 then
        local ok, formatted = pcall(string.format, msg, ...)
        if ok then return formatted end
    end
    return msg
end
