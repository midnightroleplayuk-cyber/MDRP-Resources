function GetFlashValue(value)
    if value == "off" then
        return 0
    elseif value == "low" then
        return 10
    elseif value == "high" then
        return 2
    end
end

function GetFlashString(value)
    if value == 0 then
        return "off"
    elseif value == 10 then
        return "low"
    elseif value == 2 then
        return "high"
    end
    return "off" -- default
end

function GetSpeedValue(value)
    if value == "slow" then
        return 0.5
    elseif value == "normal" then
        return 2.0
    elseif value == "fast" then
        return 5.0
    end
    return 2.0 -- default to normal
end

function GetSpeedString(value)
    if value <= 1.0 then
        return "slow"
    elseif value <= 3.5 then
        return "normal"
    else
        return "fast"
    end
end