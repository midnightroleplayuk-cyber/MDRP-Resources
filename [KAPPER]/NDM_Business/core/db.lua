NDM.DB = {}

local TABLES = {
    ndm_business_venues = [[
        CREATE TABLE IF NOT EXISTS `ndm_business_venues` (
            `id` INT UNSIGNED NOT NULL AUTO_INCREMENT,
            `type` VARCHAR(16) NOT NULL,
            `label` VARCHAR(64) NOT NULL,
            `job` VARCHAR(64) NOT NULL,
            `owner_citizenid` VARCHAR(64) DEFAULT NULL,
            `ranks` LONGTEXT NOT NULL,
            `metadata` LONGTEXT NOT NULL,
            `created_at` TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
            PRIMARY KEY (`id`),
            KEY `idx_ndm_business_venues_job` (`job`)
        ) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4
    ]],
    ndm_business_points = [[
        CREATE TABLE IF NOT EXISTS `ndm_business_points` (
            `id` INT UNSIGNED NOT NULL AUTO_INCREMENT,
            `venue_id` INT UNSIGNED NOT NULL,
            `type` VARCHAR(24) NOT NULL,
            `label` VARCHAR(40) NOT NULL,
            `x` DOUBLE NOT NULL,
            `y` DOUBLE NOT NULL,
            `z` DOUBLE NOT NULL,
            `heading` DOUBLE NOT NULL DEFAULT 0,
            `created_at` TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
            PRIMARY KEY (`id`),
            KEY `idx_ndm_business_points_venue` (`venue_id`)
        ) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4
    ]],
    ndm_business_stock = [[
        CREATE TABLE IF NOT EXISTS `ndm_business_stock` (
            `venue_id` INT UNSIGNED NOT NULL,
            `item` VARCHAR(64) NOT NULL,
            `quantity` INT UNSIGNED NOT NULL DEFAULT 0,
            PRIMARY KEY (`venue_id`, `item`)
        ) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4
    ]],
    ndm_business_prices = [[
        CREATE TABLE IF NOT EXISTS `ndm_business_prices` (
            `venue_id` INT UNSIGNED NOT NULL,
            `item` VARCHAR(64) NOT NULL,
            `price` INT UNSIGNED NOT NULL,
            PRIMARY KEY (`venue_id`, `item`)
        ) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4
    ]],
    ndm_business_club_passes = [[
        CREATE TABLE IF NOT EXISTS `ndm_business_club_passes` (
            `venue_id` INT UNSIGNED NOT NULL,
            `citizenid` VARCHAR(64) NOT NULL,
            `type` VARCHAR(8) NOT NULL,
            `expires_at` INT UNSIGNED NOT NULL,
            PRIMARY KEY (`venue_id`, `citizenid`)
        ) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4
    ]],
    ndm_business_club_bans = [[
        CREATE TABLE IF NOT EXISTS `ndm_business_club_bans` (
            `venue_id` INT UNSIGNED NOT NULL,
            `citizenid` VARCHAR(64) NOT NULL,
            `name` VARCHAR(100) NOT NULL DEFAULT '',
            `created_at` TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
            PRIMARY KEY (`venue_id`, `citizenid`)
        ) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4
    ]],
    ndm_business_depots = [[
        CREATE TABLE IF NOT EXISTS `ndm_business_depots` (
            `id` INT UNSIGNED NOT NULL AUTO_INCREMENT,
            `label` VARCHAR(40) NOT NULL,
            `x` DOUBLE NOT NULL,
            `y` DOUBLE NOT NULL,
            `z` DOUBLE NOT NULL,
            `heading` DOUBLE NOT NULL DEFAULT 0,
            PRIMARY KEY (`id`)
        ) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4
    ]],
    ndm_business_supply_orders = [[
        CREATE TABLE IF NOT EXISTS `ndm_business_supply_orders` (
            `id` INT UNSIGNED NOT NULL AUTO_INCREMENT,
            `venue_id` INT UNSIGNED NOT NULL,
            `depot_id` INT UNSIGNED NOT NULL,
            `lines` LONGTEXT NOT NULL,
            `boxes` INT UNSIGNED NOT NULL,
            `delivered` INT UNSIGNED NOT NULL DEFAULT 0,
            `cost` INT UNSIGNED NOT NULL,
            `status` VARCHAR(16) NOT NULL DEFAULT 'open',
            `citizenid` VARCHAR(64) DEFAULT NULL,
            `created_at` TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
            PRIMARY KEY (`id`),
            KEY `idx_ndm_business_supply_open` (`venue_id`, `status`)
        ) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4
    ]],
    ndm_business_ledger = [[
        CREATE TABLE IF NOT EXISTS `ndm_business_ledger` (
            `id` BIGINT UNSIGNED NOT NULL AUTO_INCREMENT,
            `venue_id` INT UNSIGNED NOT NULL,
            `kind` VARCHAR(24) NOT NULL,
            `amount` INT NOT NULL,
            `citizenid` VARCHAR(64) DEFAULT NULL,
            `description` VARCHAR(255) NOT NULL DEFAULT '',
            `created_at` TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
            PRIMARY KEY (`id`),
            KEY `idx_ndm_business_ledger_venue` (`venue_id`, `created_at`)
        ) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4
    ]],
}

function NDM.DB.Init()
    local expected = 0
    for _, statement in pairs(TABLES) do
        expected = expected + 1
        MySQL.query.await(statement)
    end

    -- A failed CREATE may not raise, so confirm the tables really exist before booting.
    local found = MySQL.scalar.await([[
        SELECT COUNT(*) FROM information_schema.tables
        WHERE table_schema = DATABASE()
          AND table_name IN (
              'ndm_business_venues', 'ndm_business_points', 'ndm_business_stock',
              'ndm_business_prices', 'ndm_business_club_passes', 'ndm_business_club_bans',
              'ndm_business_depots', 'ndm_business_supply_orders', 'ndm_business_ledger'
          )
    ]])
    return tonumber(found) == expected
end
