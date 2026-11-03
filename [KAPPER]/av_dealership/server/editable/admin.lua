function IsAdmin(playerId) -- Used for admin panel actions
	local result = IsPlayerAceAllowed(playerId, ("command.%s"):format(Config.AdminCommand)) -- run the default admin check
	dbug("IsAdmin(result)", result)
	return result
end
