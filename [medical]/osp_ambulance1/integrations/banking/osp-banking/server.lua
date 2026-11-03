Banking = Banking or {}

Banking['osp-banking'] = {
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

        local account = exports['osp-banking']:GetAccount(playerIdentifier)

        if not account or not account.balance then
            return false
        end

        if tonumber(account.balance) < amount then
            return false
        end

        local removed = exports['osp-banking']:RemoveMoney(
            playerIdentifier,
            amount,
            source
        )

        if not removed then
            return false
        end

        exports['osp-banking']:AddMoney(
            'ambulance',
            amount
        )

        return true
    end
}