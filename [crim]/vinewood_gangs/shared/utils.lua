Utils = {}

function Utils.Round(n, places)
    local m = 10 ^ (places or 0)
    return math.floor(n * m + 0.5) / m
end

function Utils.FormatMoney(amount)
    local formatted = tostring(math.floor(amount or 0))
    local k
    repeat
        formatted, k = formatted:gsub('^(-?%d+)(%d%d%d)', '%1,%2')
    until k == 0
    return Config.Currency .. formatted
end

function Utils.Debug(...)
    if Config.Debug then lib.print.debug(...) end
end
