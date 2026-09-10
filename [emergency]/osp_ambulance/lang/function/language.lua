lang = lang or {}

function deepCopyWithoutFunctions(orig)
    local orig_type = type(orig)
    local copy
    if orig_type == 'table' then
        copy = {}
        for orig_key, orig_value in next, orig, nil do
            if type(orig_value) ~= 'function' then
                copy[orig_key] = deepCopyWithoutFunctions(orig_value)
            end
        end
    else
        copy = orig
    end
    return copy
end

function GetLang()
    local locale = lib.getLocaleKey() or 'en'
    return lang[locale] or lang['en']
end

--- Only client side

if not IsDuplicityVersion() then
    function initLanguages() -- Initilizes the ui language
        if lang == nil then
            while true do
                Wait(10)
            end
        end
        SendNUIMessage({
            type = "lang",
            translations = json.encode(GetLang())
        })
    end
end