gg.util = gg.util or {}

gg.util.loadModel = function(model)
    if not IsModelValid(model) then
        return false
    end

    RequestModel(model)
    local timeout = GetGameTimer() + 5000
    while not HasModelLoaded(model) do
        Wait(100)
        if GetGameTimer() > timeout then
            return false
        end
    end

    return true
end

gg.util.loadAnimDict = function(animDict)
    RequestAnimDict(animDict)
    local timeout = GetGameTimer() + 5000
    while not HasAnimDictLoaded(animDict) do
        Wait(100)
        if GetGameTimer() > timeout then
            print("^1[ERROR]^7 Animation dictionary load timed out: " .. tostring(animDict))
            return false
        end
    end

    return true
end

gg.util.formatNumber = function(number)
    local formatted = tostring(math.floor(number)):reverse():gsub("(%d%d%d)", "%1,"):reverse()
    if formatted:sub(1, 1) == "," then
        formatted = formatted:sub(2)
    end
    return formatted
end

gg.util.round = function(num, numDecimalPlaces)
    local multiplier = 10^(numDecimalPlaces or 0)
    return math.floor(num * multiplier + 0.5) / multiplier
end

gg.util.clamp = function(num, min, max)
    if num < min then return min end
    if num > max then return max end
    return num
end

gg.util.getOrdinal = function(num)
    local suffixes = {"th", "st", "nd", "rd"}
    local last_digit = num % 10
    local last_two_digits = num % 100

    if last_two_digits >= 11 and last_two_digits <= 13 then
        return tostring(num) .. "th"
    end

    if last_digit == 1 then
        return tostring(num) .. suffixes[2]  -- "st"
    elseif last_digit == 2 then
        return tostring(num) .. suffixes[3]  -- "nd"
    elseif last_digit == 3 then
        return tostring(num) .. suffixes[4]  -- "rd"
    else
        return tostring(num) .. suffixes[1]  -- "th"
    end
end

gg.util.getEntityFromNet = function(netid)
    if not netid or not NetworkDoesNetworkIdExist(netid) then return false, nil end

    for i = 1, 25 do
        if NetworkDoesEntityExistWithNetworkId(netid) then
            local entity = NetworkGetEntityFromNetworkId(netid)
            if entity and DoesEntityExist(entity) then return true, entity end
        end
        Wait(0)
    end

    return false, nil
end

gg.util.ensureEntityControl = function(netid)
    if not netid then return false, nil end

    local entity = nil
    local hasControl = false
    for i = 1, 50 do
        if NetworkDoesNetworkIdExist(netid) and NetworkDoesEntityExistWithNetworkId(netid) then
            entity = NetworkGetEntityFromNetworkId(netid)
            if NetworkHasControlOfNetworkId(netid) then
                hasControl = true
                break
            end
            NetworkRequestControlOfNetworkId(netid)
        end
        Wait(0)
    end

    if not hasControl and entity then
        hasControl = NetworkHasControlOfNetworkId(netid)
    end

    return hasControl and entity ~= nil, entity
end
