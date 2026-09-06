if Config.Framework ~= "qbox" then
    return
end

debugprint("Loading Qbox")

QB = exports["qb-core"]:GetCoreObject()

PlayerData = {}

while not LocalPlayer.state.isLoggedIn do
    Wait(500)
end

FrameworkLoaded = true

debugprint("Qbox loaded")

PlayerData = QB.Functions.GetPlayerData()

RegisterNetEvent("QBCore:Client:OnPlayerLoaded", function()
    PlayerData = QB.Functions.GetPlayerData()

    FetchPhone()
end)

RegisterNetEvent("QBCore:Client:OnPlayerUnload", function()
    PlayerData = {}

    LogOut()
end)

RegisterNetEvent("QBCore:Player:SetPlayerData", function(newData)
    PlayerData = newData

    local metadata = newData.metadata or {}

    if (metadata.ishandcuffed or metadata.isdead or metadata.inlaststand) and phoneOpen then
        OnDeath()
    end

    if not Config.Item.Require or Config.Item.Unique then
        return
    end

    Wait(500)

    if currentPhone and not HasPhoneItem() then
        OnDeath()
    end
end)

RegisterNetEvent("QBCore:Client:OnMoneyChange", function(moneyType)
    if moneyType ~= "bank" then
        return
    end

    SendNUIAction("wallet:setBalance", math.floor(PlayerData.money.bank))
end)

AddCheck("openPhone", function()
    local metadata = PlayerData.metadata or {}

    if metadata.ishandcuffed or metadata.isdead or metadata.inlaststand then
        return false
    end

    return true
end)
