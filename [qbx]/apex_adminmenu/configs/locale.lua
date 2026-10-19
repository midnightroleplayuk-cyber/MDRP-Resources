-- ============================================================
-- LOCALE RESOLUTION
-- ------------------------------------------------------------
-- Load order (see fxmanifest shared_scripts):
--   1. configs/strings.lua  → `Strings`, the canonical ENGLISH set
--   2. locales/*.lua        → `Locales[code]`, per-language overlays
--   3. configs/config.lua   → `Config.Locale`
--   4. this file            → merges the chosen overlay onto `Strings`
--
-- Overlay, not replacement: a locale only needs the keys it actually
-- translates. Anything missing keeps the English text instead of
-- rendering as nil and blowing up a :format() call downstream — which
-- is exactly how half-finished translations usually break a resource.
--
-- Everything downstream keeps reading the same `Strings` global, so no
-- call site changed.
-- ============================================================

Locales = Locales or {}

local function resolveLocale()
    local want = Config and Config.Locale
    if type(want) ~= 'string' or want == '' then return 'en' end
    want = want:lower()
    if Locales[want] then return want end

    -- Accept 'pt-PT' / 'pt_BR' style codes by falling back to the base
    -- language before giving up.
    local base = want:match('^(%a+)')
    if base and Locales[base] then return base end

    print(('^3[apex_adminmenu] Unknown locale "%s" — falling back to English. '
        .. 'Available: %s^0'):format(tostring(Config and Config.Locale),
        (function()
            local names = {}
            for k in pairs(Locales) do names[#names + 1] = k end
            table.sort(names)
            return table.concat(names, ', ')
        end)()))
    return 'en'
end

local active = resolveLocale()
local overlay = Locales[active]

if type(overlay) == 'table' then
    local applied, skipped = 0, {}
    for key, value in pairs(overlay) do
        if Strings[key] == nil then
            -- A key that exists in the translation but not in the English
            -- source is almost always a typo in the locale file. Keep it
            -- (it may be intentional) but say so, because a mistyped key
            -- silently does nothing otherwise.
            skipped[#skipped + 1] = key
        end
        Strings[key] = value
        applied = applied + 1
    end

    if #skipped > 0 and Config and Config.Debug then
        print(('^3[apex_adminmenu] locale "%s" defines %d key(s) with no English '
            .. 'counterpart: %s^0'):format(active, #skipped, table.concat(skipped, ', ')))
    end
end

-- Exposed so other resources (and the admin panel bootstrap) can tell
-- which language is live.
Config = Config or {}
Config.ActiveLocale = active
