-- Receives player identifier (just in case u need it), table drug, input formula and xp
function calculatePurity(identifier, drug, input, xp)
    dbug('calculatePurity()', identifier, drug)

    local sum = 0
    local xp = xp or 0
    local maxPurity = 100
    local maxSum = 10  -- Max sum allowed for inputs
    local requiredLevel = 5 -- min level needed to get 100%

    -- Sum the values from the inputs, with a cap of 10
    if input and next(input) then
        for k, v in pairs(input) do
            dbug(v['key'], v['value'])
            sum = sum + (v['value'] or 0)
        end
    end

    -- Ensure the sum does not exceed 10
    sum = math.min(sum, maxSum)
    dbug("input sum: " .. sum)

    -- Calculate player's level (XP divided by 100), min level is 1
    local level = math.min(math.floor(xp / 100), requiredLevel) -- Capped at level 5 (lowering this number will allow the player to get 100% purity in a lower level)
    dbug("player/lab level: " .. level)

    -- Scale purity based on the player/lab level (higher levels allow higher purity)
    -- Inputs alone won't give max purity; they are adjusted by player/lab level.
    local scaledPurity = (sum / maxSum) * (level / requiredLevel) * maxPurity

    -- Ensure the final purity stays between 1 and 100
    local finalPurity = math.max(1, math.min(math.floor(scaledPurity), maxPurity))
    print(finalPurity, level, requiredLevel)
    if finalPurity >= 80 and level >= requiredLevel then
        finalPurity = 100
    end
    dbug("calculated purity: " .. finalPurity)

    return finalPurity
end