local LocaleData = {}
local FallbackData = {}
local currentLocale = Config.Locale or 'en'

function LoadLocale(locale)
    local resourceName = GetCurrentResourceName()
    local data = LoadResourceFile(resourceName, ('locales/%s.json'):format(locale))
    if not data then return nil end

    local success, result = pcall(json.decode, data)
    if not success then return nil end

    return result
end

local function LoadFallback()
    local data = LoadLocale('en')
    if data then FallbackData = data end
end
LoadFallback()

function SetLocale(locale)
    local data = LoadLocale(locale)
    if data then
        LocaleData = data
        currentLocale = locale
        return true
    end
    local fallback = Config.Locale or 'en'
    if locale ~= fallback then
        data = LoadLocale(fallback)
        if data then
            LocaleData = data
            currentLocale = fallback
        end
    end
    return false
end

local function lookup(root, keys)
    local value = root
    for _i, key in ipairs(keys) do
        if type(value) == 'table' and value[key] ~= nil then
            value = value[key]
        else
            return nil
        end
    end
    return value
end

function _(path, params)
    local keys = {}
    for key in string.gmatch(path, '([^.]+)') do
        keys[#keys + 1] = key
    end

    local value = lookup(LocaleData, keys)
    if value == nil then
        value = lookup(FallbackData, keys)
    end
    if value == nil then
        return path
    end

    if type(value) == 'string' and params then
        for k, v in pairs(params) do
            value = string.gsub(value, '{' .. k .. '}', tostring(v))
        end
    end

    return type(value) == 'string' and value or path
end

function GetLocaleData()
    return LocaleData
end

function GetCurrentLocale()
    return currentLocale
end

SetLocale(Config.Locale or 'en')

-- ═══════════════════════════════════════════════════════
-- Server-side Config.Jobs locale injection
-- ═══════════════════════════════════════════════════════
local function ResolveServerJobLocales()
    if not Config or not Config.Jobs then return end
    local jobsLocale = LocaleData and LocaleData.jobs
    if not jobsLocale then return end

    for jobId, job in pairs(Config.Jobs) do
        local jl = jobsLocale[jobId]
        if jl then
            if jl.name then job.name = jl.name end
            if jl.subtitle then job.subtitle = jl.subtitle end
            if jl.description then job.description = jl.description end
            if jl.interactionText and job.npc and job.npc.interaction then
                job.npc.interaction.text = jl.interactionText
            end
            if jl.blipLabel and job.npc and job.npc.blip then
                job.npc.blip.label = jl.blipLabel
            end
        end
    end
end
ResolveServerJobLocales()

exports('SetLocale', SetLocale)
exports('GetLocale', _)
exports('GetCurrentLocale', GetCurrentLocale)
exports('GetLocaleData', GetLocaleData)
