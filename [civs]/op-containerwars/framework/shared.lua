Locales = {}

Citizen.CreateThread(function()

    function trim(s)
        if s then
         return (s:gsub("^%s*(.-)%s*$", "%1"))
        else
            return nil
        end
    end
    
    function capitalizeWords(str)
        return str:gsub("(%a)(%w*)", function(first, rest)
            return first:upper() .. rest:lower()
        end)
    end

    TranslateIt = function(...)
        return Translate(...)
    end

    function Translate(str, ...) -- Translate string
        if not str then
            print(("[^1ERROR^7] Resource ^5%s^7 You did not specify a parameter for the Translate function or the value is nil!"):format(GetInvokingResource() or GetCurrentResourceName()))
            return "Given translate function parameter is nil!"
        end
        local loc = string.lower(Config.Locale)
        if Locales[loc] then
            if Locales[loc][str] then
                return string.format(Locales[loc][str], ...)
            elseif loc ~= "en" and Locales["en"] and Locales["en"][str] then
                return string.format(Locales["en"][str], ...)
            else
                return "Translation [" .. loc .. "][" .. str .. "] does not exist"
            end
        elseif loc ~= "en" and Locales["en"] and Locales["en"][str] then
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

end)