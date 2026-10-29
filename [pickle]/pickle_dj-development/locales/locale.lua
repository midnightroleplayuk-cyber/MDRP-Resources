Language = {}

function _L(name, ...)
    if name then 
        local str = Language[Config.Language][name]
        if str then 
            if (type(str) == "table") then
                return str[1]
            end
            -- Check if string has format specifiers and if arguments are provided
            local hasFormatSpecifiers = string.find(str, "%%") ~= nil
            local args = {...}
            local argCount = #args
            
            if hasFormatSpecifiers and argCount > 0 then
                return string.format(str, ...)
            elseif hasFormatSpecifiers and argCount == 0 then
                -- Return string as-is if format specifiers exist but no arguments provided
                return str
            else
                -- No format specifiers, return string as-is
                return str
            end
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