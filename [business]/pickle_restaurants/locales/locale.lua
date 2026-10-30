Language = {}

function _L(name, ...)
    if name then 
        local str = Language[Config.Language][name]
        if str then 
            if (type(str) == "table") then
                return str[1]
            end
            return string.format(str, ...)
        else    
            return "ERR_TRANSLATE_"..(name).."_404"
        end
    else
        return "ERR_TRANSLATE_404"
    end
end

function toupper(str)
    return str:upper()
end

-- The ACTIVE language table, whole. This is what makes `locales/translations/*.lua`
-- the single source of truth for every user-facing string in the resource: the NUI
-- used to carry its own parallel copy (web/src/lib/strings.en.json), which meant two
-- files to keep in step and two places a translator had to be told about. The front
-- end now pulls this table at boot and localizes against it (see modules/locale and
-- web/src/lib/locale.ts), so a string exists in exactly one place.
function LocaleTable()
    return Language[Config.Language] or Language["en"] or {}
end