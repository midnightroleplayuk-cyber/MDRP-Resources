repeat Wait(0) until statsInited

-- Create categories
for _, category in pairs(PublicSharedRCoreStatsConfig.categories) do
    TriggerEvent('rcore_stats:api:ensureCategory', category.id, category.label, nil)
end

-- Create player stats
for _, stat in pairs(PublicSharedRCoreStatsConfig.playerStats) do
    TriggerEvent('rcore_stats:api:ensureStatType', stat.id, stat.label, "player", nil, stat.category, true, nil)
end

-- Create server stats
for _, stat in pairs(PublicSharedRCoreStatsConfig.serverStats) do
    TriggerEvent('rcore_stats:api:ensureStatType', stat.id, stat.label, "server", nil, stat.category, true, stat.playerStatId)
end

-- Create player achievements
for _, achievement in pairs(PublicSharedRCoreStatsConfig.playerAchievements) do
    TriggerEvent('rcore_stats:api:ensureAchievement', achievement.id, achievement.label, achievement.description, achievement.icon, achievement.playerStatId, achievement.threshold)
end