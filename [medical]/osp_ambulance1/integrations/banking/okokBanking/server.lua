Banking = Banking or {}

Banking['okokBanking'] = {
    charge = function(source, amount, reason)
        amount = tonumber(amount) or 0
        if amount <= 0 then
            return true
        end

        local sourcePlayer = GetPlayer(source)
        local playerIdentifier = GetIdentifier(source)

        if not sourcePlayer then
            return false
        end

        if CheckMoney(source) < amount then
            return false
        end

        local playerName = GetPlayerName(source) or 'Unknown'

        local transactionData = {
            sender_identifier = playerIdentifier,
            sender_name = playerName,
            receiver_identifier = 'society_ambulance',
            receiver_name = 'Ambulance Society',
            value = amount,
            type = 'payment',
            reason = reason or 'Ambulance Service'
        }

        RemoveMoney(source, amount)

        exports['okokBanking']:AddMoney('society_ambulance', amount)
        exports['okokBanking']:AddTransaction(playerIdentifier, transactionData, source)

        return true
    end
}
