Locales = Locales or {}
JobConfigLocales = JobConfigLocales or {}
Config = Config or {}

-- Load English and the configured language on both sides; other languages are loaded on demand.
do
    local resource = GetCurrentResourceName()
    local loaded_languages = {}

    local function runLocaleFile(path)
        local content = LoadResourceFile(resource, path)
        if not content then
            return false
        end
        local chunk, err = load(content, "@" .. resource .. "/" .. path)
        if not chunk then
            print(("[sky_jobs_base] failed to parse locale file %s: %s"):format(path, err))
            return false
        end
        chunk()
        return true
    end

    local function ensureLocaleLoaded(lang)
        if type(lang) ~= "string" or not lang:match("^[a-z][a-z]$") then
            print("[sky_jobs_base] rejected an invalid locale code; expected two lowercase letters")
            return false
        end
        if loaded_languages[lang] then
            return true
        end

        local hadLocale = Locales[lang] ~= nil
        if not runLocaleFile(("config/locales/%s.lua"):format(lang)) and lang ~= "en" then
            print(("[sky_jobs_base] locale '%s' not found, falling back to en"):format(lang))
            return hadLocale
        end

        if Locales[lang] then
            for _, job in ipairs({ "sky_ambulancejob", "sky_policejob", "sky_mechanicjob", "sky_firejob", "sky_crimesystem", "sky_dojjob", "sky_jobs_base", "sky_jobcreator", "sky_restaurants" }) do
                runLocaleFile(("config/locales/jobconfigurator/%s/%s.lua"):format(job, lang))
            end
            runLocaleFile("source/shared/locale_loader.lua")
            loaded_languages[lang] = true
        end

        return Locales[lang] ~= nil
    end

    _G.SkyJobsEnsureLocaleLoaded = ensureLocaleLoaded

    local languages = { "en" }
    if type(Sky.Config.locale) == "string" and Sky.Config.locale ~= "en" then
        languages[#languages + 1] = Sky.Config.locale
    end

    for _, lang in ipairs(languages) do
        ensureLocaleLoaded(lang)
    end

    if not IsDuplicityVersion() then
        CreateThread(function()
            local attempts = 0
            while attempts < 50 do
                local configuredLocale = Sky and Sky.Config and Sky.Config.locale or nil
                if type(configuredLocale) == "string" and configuredLocale ~= "" then
                    if not Locales[configuredLocale] then
                        ensureLocaleLoaded(configuredLocale)
                    end
                    break
                end
                attempts = attempts + 1
                Wait(100)
            end
            local configuredLocale = Sky and Sky.Config and Sky.Config.locale or nil
            if type(configuredLocale) == "string" and configuredLocale ~= "" and not Locales[configuredLocale] then
                ensureLocaleLoaded(configuredLocale)
            end
        end)
    end
end
