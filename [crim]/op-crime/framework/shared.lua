Locales = Locales or {}

function trim(s)
    if s then
        return (s:gsub("^%s*(.-)%s*$", "%1"))
    else
        return nil
    end
end

-- ──────────────────────────────────────────────────────────────────────────────
-- Lazy locale loader
-- Previously fxmanifest loaded ALL ~21 locale files on every client and on the
-- server (each ~85 KB → ~3-5 MiB of heap per side after parsing). Now the
-- locales/*.lua entry is removed from fxmanifest and we load only the locale
-- selected in Config.Locale plus `en` as a fallback. The locales/ folder is
-- escrow_ignored so the raw files are available via LoadResourceFile.
--
-- Important: do NOT pass `_G` as the chunk environment. In FiveM each resource
-- has its own sandbox; writing Locales['xx'] into `_G` never fills this
-- resource's Locales table and Translate() ends up with
-- "Locale [en] does not exist".
-- ──────────────────────────────────────────────────────────────────────────────
local function normalizeLocaleCode(code)
    if type(code) ~= "string" then return nil end
    code = string.lower(trim(code) or "")
    if code == "" then return nil end
    return code
end

local function loadLocaleFile(code)
    code = normalizeLocaleCode(code)
    if not code then return false end
    if type(Locales[code]) == "table" then return true end

    local resName = GetCurrentResourceName()
    local relativePath = "locales/" .. code .. ".lua"
    local content = LoadResourceFile(resName, relativePath)
    if not content or content == "" then
        print(("[^1locales^7] file not found: %s/%s"):format(resName, relativePath))
        return false
    end

    -- Use this resource's sandbox (_ENV), never `_G` (FiveM isolation).
    local chunk, err = load(content, "@" .. relativePath, "t", _ENV)
    if not chunk then
        print(("[^1locales^7] failed to compile %s: %s"):format(relativePath, tostring(err)))
        return false
    end

    local ok, runErr = pcall(chunk)
    if not ok then
        print(("[^1locales^7] failed to execute %s: %s"):format(relativePath, tostring(runErr)))
        return false
    end

    if type(Locales[code]) ~= "table" then
        print(("[^1locales^7] %s executed but did not set Locales['%s']"):format(relativePath, code))
        return false
    end

    return true
end

local function ensureLocalesLoaded()
    local loc = normalizeLocaleCode(Config and Config.Locale) or "en"
    loadLocaleFile(loc)
    if loc ~= "en" then
        loadLocaleFile("en")
    end
    return loc
end

ensureLocalesLoaded()

TranslateIt = function(...)
    return Translate(...)
end

function Translate(str, ...) -- Translate string
    if not str then
        print(("[^1ERROR^7] Resource ^5%s^7 You did not specify a parameter for the Translate function or the value is nil!"):format(GetInvokingResource() or GetCurrentResourceName()))
        return "Given translate function parameter is nil!"
    end

    local loc = ensureLocalesLoaded()

    if Locales[loc] then
        if Locales[loc][str] then
            return string.format(Locales[loc][str], ...)
        elseif loc ~= "en" and Locales["en"] and Locales["en"][str] then
            return string.format(Locales["en"][str], ...)
        else
            return "Translation [" .. loc .. "][" .. str .. "] does not exist"
        end
    elseif Locales["en"] and Locales["en"][str] then
        return string.format(Locales["en"][str], ...)
    else
        return "Locale [" .. loc .. "] does not exist"
    end
end

function tableContains(tbl, element)
    for _, value in pairs(tbl) do
        if value == element then
            return true
        end
    end
    return false
end

function debugPrint(...)
    if not Config.Debug then return end
    local args <const> = { ... }

    local appendStr = ''
    for _, v in ipairs(args) do
        appendStr = appendStr .. ' ' .. tostring(v)
    end
    local msgTemplate = '^3[debuglog]^0%s'
    local finalMsg = msgTemplate:format(appendStr)
    print(finalMsg)
end

function DeepCopyShared(original, seen)
    if type(original) ~= "table" then
        return original
    end

    if seen and seen[original] then
        return seen[original]
    end

    local copy = {}
    seen = seen or {}
    seen[original] = copy

    for k, v in pairs(original) do
        copy[DeepCopyShared(k, seen)] = DeepCopyShared(v, seen)
    end

    return setmetatable(copy, getmetatable(original))
end