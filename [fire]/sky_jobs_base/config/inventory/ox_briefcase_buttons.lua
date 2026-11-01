-- Loaded by ox_inventory's item catalog on either side, even before Jobs Base starts.
-- Only the button callbacks call runtime exports; labels use the inventory language.
local language = GetConvar("ox:locale", "en")
local languages = {
    ar = "ar", cn = "cn", ["zh-cn"] = "cn", ["zh-tw"] = "cn", zh = "cn",
    cz = "cz", cs = "cz", de = "de", en = "en", es = "es", fi = "fi",
    fr = "fr", hu = "hu", it = "it", nl = "nl", pl = "pl", pt = "pt", ["pt-br"] = "pt",
    rs = "rs", sr = "rs", ru = "ru", se = "se", sv = "se", sl = "sl",
}
language = languages[language:lower()] or "en"
local locale_env = { Locales = {} }
lib.load("@sky_jobs_base.config.locales." .. language, locale_env)
local labels = locale_env.Locales[language].ItemContainers

return {
    {
        label = labels.ShowBriefcase,
        action = function()
            exports["sky_jobs_base"]:showPedItem("sky_briefcase")
        end,
    },
    {
        label = labels.HideBriefcase,
        action = function()
            exports["sky_jobs_base"]:hidePedItem("sky_briefcase")
        end,
    },
}
