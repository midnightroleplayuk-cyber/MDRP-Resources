-- You can either use this tables to grant permission OR run your own check in every function
-- You can find some examples for item check inside each functions..... E X A M P L E S
local createTracks = { -- Table with citizen id / character identifier OR player rockstar license
    ['abc123'] = true,
    ['license:abc1234567890'] = true,
}

local createEvents = { -- Table with citizen id / character identifier OR player rockstar license
    ['abc123'] = true,
    ['license:abc1234567890'] = true,
}

function CanCreateTracks(playerId,laptopSerial) -- Player can create new tracks, return true/false
    dbug("CanCreateTracks(playerId, laptopSerial)", playerId, laptopSerial)
    local res = isAdmin(playerId) -- run the default admin check
    if res then return true end -- if player is admin return true, no need to run any extra code

    local characterIdentifier = exports['av_laptop']:getIdentifier(playerId) -- Character Framework identifier
    local license = GetPlayerIdentifierByType(playerId, "license") -- Player rockstar license
    if createTracks[characterIdentifier] or createTracks[license] then
        return true
    end
    -- EXAMPLE CHECKING IF PLAYER HAVE X ITEM
    -- Will return true/false if player have item gold_dongle with him
    --[[
        return exports['av_laptop']:hasItem(playerId, "gold_dongle")
    ]]--

    -- EXAMPLE CHECKING IF LAPTOP CONTAINER HAVE X ITEM, ONLY WORKS WITH ox and origen inventory !
    --[[
        return exports['av_laptop']:hasDevice(laptopSerial, "gold_dongle")
    ]]--
    return false
end

function CanCreateRaces(playerId,laptopSerial) -- Player can create new events (races), return true/false
    dbug("CanCreateRaces(playerId, laptopSerial)", playerId, laptopSerial)
    local res = isAdmin(playerId) -- run the default admin check
    if res then return true end -- if player is admin return true, no need to run any extra code
    local characterIdentifier = exports['av_laptop']:getIdentifier(playerId) -- Character Framework identifier
    local license = GetPlayerIdentifierByType(playerId, "license") -- Player rockstar license
    if createEvents[characterIdentifier] or createEvents[license] then
        return true
    end
    -- EXAMPLE CHECKING IF PLAYER HAVE X ITEM
    -- Will return true/false if player have item gold_dongle with him
    --[[
        return exports['av_laptop']:hasItem(playerId, "gold_dongle")
    ]]--

    -- EXAMPLE CHECKING IF LAPTOP CONTAINER HAVE X ITEM, ONLY WORKS WITH ox and origen inventory !
    --[[
        return exports['av_laptop']:hasDevice(laptopSerial, "gold_dongle")
    ]]--
    return false
end

function isAdmin(playerId) -- Used for admin panel actions
    local result = IsPlayerAceAllowed(playerId, ('command.%s'):format(Config.AdminCommand)) -- run the default admin check
    dbug("isAdmin(result)", result)
    return result
end