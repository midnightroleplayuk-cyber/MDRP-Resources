-- Job locale files contain data only. Apply them in the same order on both sides.
local packs = {}
for name in pairs(JobConfigLocales) do
    packs[#packs + 1] = name
end
table.sort(packs)

local function apply(target, entries)
    for key, value in pairs(entries) do
        if type(value) == "table" then
            if type(target[key]) ~= "table" then
                target[key] = {}
            end
            apply(target[key], value)
        else
            target[key] = value
        end
    end
end

for _, name in ipairs(packs) do
    local language = name:match(":([a-z]+)$")
    local locale = language and Locales[language]
    -- Vendor packs such as sky_mechanicjob:hu have no matching base locale.
    -- Skip them instead of aborting the resource on server start.
    if locale then
        apply(locale, JobConfigLocales[name])
    else
        print(("[sky_jobs_base] skipped job locale '%s' (no base locale)"):format(name))
    end
end

-- The client can load another language later without applying earlier packs again.
JobConfigLocales = {}
