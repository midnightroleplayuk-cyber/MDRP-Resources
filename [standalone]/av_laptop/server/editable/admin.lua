function IsAdmin(playerId)
    if not playerId or playerId <= 0 then return false end
    local result = IsPlayerAceAllowed(playerId, ("command.%s"):format(Config.AdminCommand))
    dbug("IsAdmin(result)", result)
    return result
end
