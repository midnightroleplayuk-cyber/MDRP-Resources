Stats = {}

MySQL.ready(function()
    MySQL.query([[
        CREATE TABLE IF NOT EXISTS `rsvx_bowling_stats` (
            `citizenid` VARCHAR(64) NOT NULL,
            `name` VARCHAR(100) NOT NULL,
            `games` INT NOT NULL DEFAULT 0,
            `best` INT NOT NULL DEFAULT 0,
            `total` INT NOT NULL DEFAULT 0,
            `strikes` INT NOT NULL DEFAULT 0,
            `perfect` INT NOT NULL DEFAULT 0,
            `updated` TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
            PRIMARY KEY (`citizenid`)
        )
    ]])
end)

function Stats.record(citizenid, name, score, strikes)
    MySQL.insert([[
        INSERT INTO rsvx_bowling_stats (citizenid, name, games, best, total, strikes, perfect)
        VALUES (?, ?, 1, ?, ?, ?, ?)
        ON DUPLICATE KEY UPDATE
            name = VALUES(name),
            games = games + 1,
            best = GREATEST(best, VALUES(best)),
            total = total + VALUES(total),
            strikes = strikes + VALUES(strikes),
            perfect = perfect + VALUES(perfect)
    ]], { citizenid, name, score, score, strikes, score == 300 and 1 or 0 })
end

lib.callback.register('rsvx_bowling:leaderboard', function()
    return MySQL.query.await('SELECT name, games, best, strikes FROM rsvx_bowling_stats ORDER BY best DESC, games ASC LIMIT 10') or {}
end)
