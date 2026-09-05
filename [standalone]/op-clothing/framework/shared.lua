-- ------------------------------------------------------------------------------
-- Framework / Shared
-- ------------------------------------------------------------------------------

local function detectFramework()
    if GetResourceState then
        if GetResourceState('qbx_core') == 'started' then return 'qbox' end
        if GetResourceState('es_extended') == 'started' then return 'esx' end
        if GetResourceState('qb-core') == 'started' then return 'qb' end
    end
    return nil
end

local function resolveFramework()
    local cfg = Config and Config.Framework
    if type(cfg) == 'string' and cfg ~= '' and cfg ~= 'auto' then
        return cfg
    end
    return detectFramework()
end

Config = Config or {}
-- Keep 'auto' when the core framework is not up yet so adapters can wait and bind later.
Config.Framework = resolveFramework() or (Config.Framework == 'auto' and 'auto') or 'auto'

if not detectFramework() then
    print('^3 Waiting for framework (es_extended / qb-core / qbx_core)...^0')
end

--- Re-run detection (called by deferred adapters after a core resource starts).
function OPC_ResolveFramework()
    local pinned = Config and Config.Framework
    if type(pinned) == 'string' and pinned ~= '' and pinned ~= 'auto' then
        return pinned
    end
    local detected = detectFramework()
    if detected then
        Config.Framework = detected
        return detected
    end
    return nil
end

-- ------------------------------------------------------------------------------
-- Locale loader
-- ------------------------------------------------------------------------------
Locales = Locales or {}

local function loadLocaleFromJson(loc)
    if type(loc) ~= 'string' or loc == '' then return nil end
    loc = string.lower(loc)
    if Locales[loc] then return Locales[loc] end

    local resource = (GetCurrentResourceName and GetCurrentResourceName()) or 'op-clothing'
    local raw      = LoadResourceFile and LoadResourceFile(resource, ('locales/%s.json'):format(loc)) or nil
    if not raw or raw == '' then return nil end

    local ok, decoded = pcall(json.decode, raw)
    if not ok or type(decoded) ~= 'table' then
        print(('^1[i18n] failed to parse locales/%s.json^7'):format(loc))
        return nil
    end
    Locales[loc] = decoded
    return decoded
end

function OPC_LoadLocale(loc)
    if type(loc) ~= 'string' or loc == '' then return nil end
    Locales[string.lower(loc)] = nil
    return loadLocaleFromJson(loc)
end

loadLocaleFromJson('en')
if Config.Locale then loadLocaleFromJson(Config.Locale) end

function trim(s)
    if s then
        return (s:gsub('^%s*(.-)%s*$', '%1'))
    else
        return nil
    end
end

function Translate(str, ...)
    if not str then
        print(('[^1ERROR^7] Resource ^5%s^7 You did not specify a parameter for the Translate function or the value is nil!'):format(GetCurrentResourceName()))
        return 'Given translate function parameter is nil!'
    end
    local loc = string.lower(Config and Config.Locale or 'en')
    if Locales[loc] then
        if Locales[loc][str] then
            return string.format(Locales[loc][str], ...)
        elseif loc ~= 'en' and Locales['en'] and Locales['en'][str] then
            return string.format(Locales['en'][str], ...)
        else
            return ('Translation [%s][%s] does not exist'):format(loc, str)
        end
    elseif loc ~= 'en' and Locales['en'] and Locales['en'][str] then
        return string.format(Locales['en'][str], ...)
    else
        return ('Locale [%s] does not exist'):format(loc)
    end
end

TranslateIt = Translate

function tableContains(tbl, element)
    if type(tbl) ~= 'table' then return false end
    for _, v in pairs(tbl) do
        if v == element then return true end
    end
    return false
end

function debugPrint(...)
    if not (Config and Config.Debug) then return end
    local args <const> = { ... }
    local appendStr = ''
    for _, v in ipairs(args) do
        appendStr = appendStr .. ' ' .. tostring(v)
    end
    print(('^3[opc-debug]^0%s'):format(appendStr))
end

function DeepCopyShared(original, seen)
    if type(original) ~= 'table' then return original end
    if seen and seen[original] then return seen[original] end

    local copy = {}
    seen = seen or {}
    seen[original] = copy
    for k, v in pairs(original) do
        copy[DeepCopyShared(k, seen)] = DeepCopyShared(v, seen)
    end
    return setmetatable(copy, getmetatable(original))
end
