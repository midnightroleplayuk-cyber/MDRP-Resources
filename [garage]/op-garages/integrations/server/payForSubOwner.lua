function payForSubOwner(moneyToRemove, xPlayer)
    local bank_money = Fr.GetMoney(xPlayer, 'bank')
    local cash = Fr.GetMoney(xPlayer, 'money')

    if moneyToRemove <= cash then
        Fr.ManageMoney(xPlayer, "money", "remove", moneyToRemove)
        return true
    elseif moneyToRemove <= bank_money then
        Fr.ManageMoney(xPlayer, "bank", "remove", moneyToRemove)
        return true
    end

    return false
end