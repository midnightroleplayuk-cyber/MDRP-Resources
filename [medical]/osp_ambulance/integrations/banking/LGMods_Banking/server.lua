Banking = Banking or {}

Banking['LGMods_Banking'] = {
    charge = function(source, amount, reason)
        amount = tonumber(amount) or 0

        if amount <= 0 then
            return true
        end

        local sourcePlayer = GetPlayer(source)
        local playerIdentifier = GetIdentifier(source)

        if not sourcePlayer or not playerIdentifier then
            return false
        end

        local account = exports["LGMods_Banking"]:GetAccountDetails(
            playerId, 
            accountType, 
            businessName, 
            callback)

        if not account or not account.balance then
            return false
        end

        if tonumber(account.balance) < amount then
            return false
        end

        local removed = exports["LGMods_Banking"]:RemoveMoney(
            playerId, 
            amount, 
            accountType, 
            businessName)

        if not removed then
            return false
        end

        exports["LGMods_Banking"]:AddMoney(
            playerId, 
            amount, 
            accountType, 
            businessName)

        return true
    end
}