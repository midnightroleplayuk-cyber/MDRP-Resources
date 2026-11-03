-- NPC used to start mission, only available if Config.UseNPC = true
npcLocations = {
    {model = `a_m_m_eastsa_01`, x = 259.8798, y = -16.4995, z = 73.6469, heading = 75.2282},
    {model = `a_m_m_salton_01`, x = -1465.1339, y = -396.9443, z = 38.5440, heading = 32.3199},
}

function payMission(playerId)
    local paid = false
    dbug('payMission(playerId)',playerId)
    local playerIdentifier = getIdentifier(playerId)
    if Config.UsingAVGangs and Config.GangCooldown and GetResourceState('av_gangs') == "started" then
        dbug("Checking for player gang")
        local playerGang = exports['av_gangs']:getGang(playerId)
        if playerGang and playerGang['name'] then
            playerIdentifier = playerGang['name']
        else
            dbug("Player doesn't belong to a gang, using player identifier for cooldown")
        end
    end
    if inCooldown(playerIdentifier) then
        TriggerClientEvent('av_warehouse:notification',playerId, Lang['title'], Lang['in_cooldown'], 'error')
        dbug("Identifier on cooldown", playerIdentifier)
        return false
    end
    if Config.MissionPrice and tonumber(Config.MissionPrice) then
        local playerMoney = getMoney(playerId, Config.AccountMoney)
        dbug('account,money', Config.AccountMoney, playerMoney)
        if playerMoney and tonumber(playerMoney) >= Config.MissionPrice then
            local cops = getCops()
            dbug("currentCops, neededCops", cops, Config.MinCops)
            if cops and tonumber(cops) >= Config.MinCops then
                removeMoney(playerId, Config.AccountMoney, Config.MissionPrice)
                paid = true
            else
                TriggerClientEvent('av_warehouse:notification', playerId, Lang['title'], Lang['no_cops'], 'error')
            end
        else
            TriggerClientEvent('av_warehouse:notification',playerId, Lang['title'], Lang['no_money'], 'error')
        end
    else
        dbug("Mission price is set to false, we will not charge player.")
        paid = true
    end
    return paid
end