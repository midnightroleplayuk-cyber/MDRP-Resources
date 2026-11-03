-- Returns gang level
function getLevel(playerId)
    dbug('getLevel(playerId)', playerId)
    local level = 999
    if Config.UsingAVGangs and GetResourceState('av_gangs') == "started" then
        local playerGang = exports['av_gangs']:getGang(playerId)
        if playerGang and playerGang['name'] then
            local influence = exports['av_gangs']:getGangXP(playerGang['name'])
            level = math.floor((influence / 2500))
        end
    end
    return level
end