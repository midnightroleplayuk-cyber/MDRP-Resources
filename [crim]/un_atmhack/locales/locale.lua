Locales = {}
LocalLang = {}

local function loadLocaleFile(lang)
    local file = LoadResourceFile(GetCurrentResourceName(), ('locales/%s.json'):format(lang))
    if not file then
        return nil
    end

    local decoded = json.decode(file)
    if type(decoded) ~= 'table' then
        return nil
    end

    return decoded
end

function LoadLocale(lang)
    local selected = loadLocaleFile(lang)
    local fallback = loadLocaleFile('en') or {}

    LocalLang = fallback

    if selected then
        for key, value in pairs(selected) do
            LocalLang[key] = value
        end
    else
        print(('[Locale] Missing locale "%s", falling back to "en".'):format(lang))
    end
end

function Locale(key, ...)
    local value = LocalLang[key] or key
    local args = { ... }

    if #args > 0 then
        return value:format(table.unpack(args))
    end

    return value
end

LoadLocale(Config.Locale)
