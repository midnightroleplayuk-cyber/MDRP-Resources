Banking = Banking or {}

Banking['default'] = {
    charge = function(source, amount, reason)
        amount = tonumber(amount) or 0
        if amount <= 0 then
            return true
        end

        local sourcePlayer = GetPlayer(source)
        if not sourcePlayer then
            return false
        end

        if CheckMoney(source) < amount then
            return false
        end

        RemoveMoney(source, amount)

        if GetActiveFramework() == 'qb' or GetActiveFramework() == 'qbox' then
            if GetResourceState('qb-banking') == 'started' then
                exports['qb-banking']:AddMoney('ambulance', amount, reason or 'Hospital bill')
            end
        else
            if GetResourceState('esx_society') == 'started' then
                TriggerServerEvent('esx_society:depositMoney', 'society_ambulance', amount)
            end
        end

        return true
    end
}
