--[[
    Apex Handling Studio: shared utilities (client + server)
]]

Utils = Utils or {}
Locale = Locale or {}

function Utils.Log(...)
    if not Config.debug then return end
    local parts = {}
    for i = 1, select('#', ...) do
        parts[#parts + 1] = tostring(select(i, ...))
    end
    print(('^5[apex_handling]^7 %s'):format(table.concat(parts, ' ')))
end

function Utils.Err(...)
    local parts = {}
    for i = 1, select('#', ...) do
        parts[#parts + 1] = tostring(select(i, ...))
    end
    print(('^1[apex_handling ERROR]^7 %s'):format(table.concat(parts, ' ')))
end

-- ─── Locale ─────────────────────────────────────────────────

Locales = Locales or {}

--- The active locale table, falling back to English when Config.locale
--- names a language nobody shipped a file for.
function Locale.Active()
    return Locales[Config.locale] or Locales.en or {}
end

function L(key, fallback, ...)
    local lang = Locale.Active()
    local str = lang[key] or (Locales.en or {})[key] or fallback or key
    if select('#', ...) > 0 then
        local ok, formatted = pcall(string.format, str, ...)
        if ok then return formatted end
    end
    return str
end

--- Every string the NUI renders, resolved for the active language with a
--- PER-KEY English fallback: a half-translated file shows its translated
--- keys and English for the rest, instead of falling back wholesale.
--- This is what the boot payload carries, so adding a language is just
--- adding a file in locales/ and pointing Config.locale at it.
function Locale.UI()
    local base = (Locales.en or {}).ui or {}
    local lang = Locale.Active().ui or {}
    local out = {}
    for k, v in pairs(base) do out[k] = v end
    for k, v in pairs(lang) do
        if type(v) == 'string' and v ~= '' then out[k] = v end
    end
    return out
end

--- The tutorial steps for the active language. Falls back step by step,
--- so a locale that translated only the first two still shows them.
function Locale.Help()
    local base = (Locales.en or {}).help or {}
    local lang = Locale.Active().help or {}
    local out = {}
    for i, step in ipairs(base) do
        local tr = lang[i]
        out[i] = {
            icon  = step.icon,
            title = (tr and tr.title) or step.title,
            body  = (tr and tr.body) or step.body,
            list  = (tr and tr.list) or step.list,
        }
    end
    return out
end

--- Which languages this install actually ships (for logging/diagnostics).
function Locale.Available()
    local out = {}
    for code, tbl in pairs(Locales) do
        if type(tbl) == 'table' then out[#out + 1] = code end
    end
    table.sort(out)
    return out
end

-- ─── Table helpers ──────────────────────────────────────────

function Utils.DeepCopy(t)
    if type(t) ~= 'table' then return t end
    local out = {}
    for k, v in pairs(t) do
        out[k] = type(v) == 'table' and Utils.DeepCopy(v) or v
    end
    return out
end

function Utils.Count(t)
    local n = 0
    for _ in pairs(t or {}) do n = n + 1 end
    return n
end

function Utils.Trim(s)
    return (tostring(s or ''):gsub('^%s+', ''):gsub('%s+$', ''))
end

-- Round to a sensible number of decimals for handling floats.
function Utils.Round(v, decimals)
    local mult = 10 ^ (decimals or 6)
    return math.floor(v * mult + 0.5) / mult
end

-- Format a float the way handling.meta files expect it.
function Utils.MetaFloat(v)
    return string.format('%.6f', v)
end

-- Sanitize a profile / model name for storage keys. Parenthesised: a bare
-- gsub also returns its replacement COUNT, and this feeds string.format
-- and table constructors where a stray second value is a latent bug.
function Utils.SafeName(s, maxLen)
    s = Utils.Trim(s):sub(1, maxLen or 48)
    return (s:gsub('[%c<>]', ''))
end
