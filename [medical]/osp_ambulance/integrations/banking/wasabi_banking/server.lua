Banking = Banking or {}

Banking['wasabi_banking'] = {
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

        local cash = exports['wasabi_banking']:GetAccountBalance(playerIdentifier, 'cash') or 0
        local bank = exports['wasabi_banking']:GetAccountBalance(playerIdentifier, 'bank') or 0

        if (cash + bank) < amount then
            return false
        end

        if cash >= amount then
            local removedCash = exports['wasabi_banking']:RemoveMoney(
                'cash',
                playerIdentifier,
                amount,
                source
            )

            if not removedCash then
                return false
            end
        else
            local removedBank = exports['wasabi_banking']:RemoveMoney(
                'bank',
                playerIdentifier,
                amount,
                source
            )

            if not removedBank then
                return false
            end
        end

        exports['wasabi_banking']:AddMoney(
            'society',
            'society_ambulance',
            amount
        )

        local transactionReason = reason or 'Ambulance Service'

        exports['wasabi_banking']:Transaction(
            playerIdentifier,
            transactionReason,
            amount,
            'sent',
            'personal'
        )

        return true
    end
}
