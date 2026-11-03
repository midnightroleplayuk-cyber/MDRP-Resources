Banking = Banking or {}

Banking['qs-banking'] = {
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

        RemoveMoney(source, amount)

        exports['qs-banking']:AddSocietyMoney('ambulance', amount, reason or 'Ambulance Service')
        exports['qs-banking']:AddTransaction(playerIdentifier, reason or 'Ambulance Service', 'fa-solid fa-hospital', 'Payment of: ' .. amount)

        return true
    end
}
