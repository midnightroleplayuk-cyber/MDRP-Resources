local robCooldowns = {}

RegisterServerEvent('av_gangs:getMoney', function(netId, gang, zone, data) -- triggered when u rob a gang npc
    dbug("robNPC(netId, gang)", netId, gang)
    local src = source
    local now = os.time()
    local player = GetPlayerPed(src)
    local coords = GetEntityCoords(player)
    local npc = NetworkGetEntityFromNetworkId(netId)
    if npc and DoesEntityExist(npc) then
        local state = Entity(npc).state
        if not state['robbed'] then
            state['robbed'] = true
        else
            dbug("Already robbed, cancel process.")
            return
        end
    else
        dbug("Entity doesn't exist, cancel process.")
        return
    end
    local npcCoords = GetEntityCoords(npc)
    if #(coords - npcCoords) > 7.0 then
        warn("Player too far from NPC, possible exploit. src:", src, "dist:", #(coords - npcCoords))
        return
    end
    if robCooldowns[src] and now - robCooldowns[src] < 30 then
        dbug("Rate limit hit. src:", src)
        return
    end
    robCooldowns[src] = now
    local myGang = getGang(src)
    if not myGang or not myGang['name'] then
        dbug("Player has no gang, can't rob NPC.")
        return
    end
    local members = getMembers(gang)
    local count = 0
    if members and next(members) then
        for _, v in pairs(members) do
            local Player = exports['av_laptop']:getSourceByIdentifier(v['identifier'])
            if Player then
                TriggerClientEvent('av_gangs:alertMember', Player, coords, Lang['robbery_alert'])
                count += 1
            end
        end
    end
    if Config.MinOnlineForNPC and count < Config.MinOnlineForNPC then
        dbug('Not enough players online (online,required)', count, Config.MinOnlineForNPC)
        TriggerClientEvent('av_laptop:notification', src, Lang['app_title'], Lang['not_enough_enemies'], 'warning')
        return
    end
    local total = math.random(Config.RobMoney['min'], Config.RobMoney['max'])
    exports['av_laptop']:addMoney(src,Config.RobAccount,total)
    if Config.GangWinsXP and Config.GangWinsXP > 0 then
        if myGang and myGang['name'] then
            addXP(myGang['name'],Config.GangWinsXP)
        end
    end
    local settings = Config.RobNPC
    if not settings or not settings['enabled'] then return end
    if settings['toAdd'] and tonumber(settings['toAdd']) > 0 then
        if myGang and myGang['name'] then
            addZoneXP(myGang['name'],zone,settings['toAdd'], "robbed an npc in "..zone)
        end
    end
    if settings['toRemove'] and tonumber(settings['toRemove']) > 0 then
        removeZoneXP(gang,zone,settings['toRemove'], "robbed by "..(myGang and myGang['name'] or "unknown").." in "..zone)
    end
    if Config.RobNPCReputation and Config.RobNPCReputation['enabled'] then
        addReputation(src, Config.RobNPCReputation['points'] or 1)
    end
    sendLog(src, myGang and myGang['name'] or "unknown", "Robbed an NPC in "..(zone or "unknown"), gang)
    TriggerClientEvent('av_gangs:targetStash', src, data)
end)