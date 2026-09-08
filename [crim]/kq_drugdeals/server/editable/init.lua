local tables = {
    ['kq_drugdeals_drugs'] = [[
CREATE TABLE IF NOT EXISTS `kq_drugdeals_drugs` (
    `id` int(11) NOT NULL AUTO_INCREMENT,
    `drug_id` varchar(100) NOT NULL,
    `item` varchar(100) NOT NULL,
    `label` varchar(100) NOT NULL DEFAULT '',
    `base_price` int(11) NOT NULL DEFAULT 100,
    `use_meta_pricing` tinyint(1) NOT NULL DEFAULT 0,
    `meta_key` varchar(50) NOT NULL DEFAULT 'purity',
    `meta_kind` varchar(10) NOT NULL DEFAULT 'range',
    `meta_steps` longtext DEFAULT NULL,
    `prop` varchar(100) NOT NULL DEFAULT '',
    `street_chance` float NOT NULL DEFAULT 1,
    `street_min_quantity` int(11) NOT NULL DEFAULT 1,
    `street_max_quantity` int(11) NOT NULL DEFAULT 4,
    `app_min_quantity` int(11) NOT NULL DEFAULT 1,
    `app_max_quantity` int(11) NOT NULL DEFAULT 25,
    `app_min_rating` float NOT NULL DEFAULT 0,
    `street` tinyint(1) NOT NULL DEFAULT 1,
    `app` tinyint(1) NOT NULL DEFAULT 1,
    `active` tinyint(1) NOT NULL DEFAULT 1,
    `created_by` varchar(255) NOT NULL DEFAULT '',
    `created_at` datetime NOT NULL DEFAULT current_timestamp(),
    `updated_at` datetime NOT NULL DEFAULT current_timestamp() ON UPDATE current_timestamp(),
    PRIMARY KEY (`id`),
    UNIQUE KEY `drug_id_unique` (`drug_id`)
) ENGINE=InnoDB AUTO_INCREMENT=1 DEFAULT CHARSET=utf8;
    ]],

    ['kq_drugdeals_hotspots'] = [[
CREATE TABLE IF NOT EXISTS `kq_drugdeals_hotspots` (
    `id` int(11) NOT NULL AUTO_INCREMENT,
    `hotspot_id` varchar(100) NOT NULL,
    `name` varchar(100) NOT NULL DEFAULT '',
    `x` float NOT NULL DEFAULT 0,
    `y` float NOT NULL DEFAULT 0,
    `z` float NOT NULL DEFAULT 0,
    `radius` float NOT NULL DEFAULT 75,
    `points` longtext DEFAULT NULL,
    `drugs` longtext DEFAULT NULL,
    `accept_multiplier` float NOT NULL DEFAULT -1,
    `active` tinyint(1) NOT NULL DEFAULT 1,
    `created_by` varchar(255) NOT NULL DEFAULT '',
    `created_at` datetime NOT NULL DEFAULT current_timestamp(),
    `updated_at` datetime NOT NULL DEFAULT current_timestamp() ON UPDATE current_timestamp(),
    PRIMARY KEY (`id`),
    UNIQUE KEY `hotspot_id_unique` (`hotspot_id`)
) ENGINE=InnoDB AUTO_INCREMENT=1 DEFAULT CHARSET=utf8;
    ]],

    ['kq_drugdeals_organizations'] = [[
CREATE TABLE IF NOT EXISTS `kq_drugdeals_organizations` (
    `id` int(11) NOT NULL AUTO_INCREMENT,
    `org_id` varchar(100) NOT NULL,
    `name` varchar(100) NOT NULL DEFAULT '',
    `sell_spots` longtext DEFAULT NULL,
    `unlock_mode` varchar(10) NOT NULL DEFAULT 'hidden',
    `buyin_cash` int(11) NOT NULL DEFAULT 0,
    `buyin_drug_id` varchar(100) NOT NULL DEFAULT '',
    `buyin_drug_amount` int(11) NOT NULL DEFAULT 0,
    `buy_prices` longtext DEFAULT NULL,
    `fixer_spots` longtext DEFAULT NULL,
    `description` varchar(300) NOT NULL DEFAULT '',
    `enemies` longtext DEFAULT NULL,
    `boss_model` varchar(100) NOT NULL DEFAULT '',
    `member_models` longtext DEFAULT NULL,
    `jobs` longtext DEFAULT NULL,
    `jobs_enabled` tinyint(1) NOT NULL DEFAULT 0,
    `metadata` longtext DEFAULT NULL,
    `active` tinyint(1) NOT NULL DEFAULT 1,
    `created_by` varchar(255) NOT NULL DEFAULT '',
    `created_at` datetime NOT NULL DEFAULT current_timestamp(),
    `updated_at` datetime NOT NULL DEFAULT current_timestamp() ON UPDATE current_timestamp(),
    PRIMARY KEY (`id`),
    UNIQUE KEY `org_id_unique` (`org_id`)
) ENGINE=InnoDB AUTO_INCREMENT=1 DEFAULT CHARSET=utf8;
    ]],

    ['kq_drugdeals_delivery_locations'] = [[
CREATE TABLE IF NOT EXISTS `kq_drugdeals_delivery_locations` (
    `id` int(11) NOT NULL AUTO_INCREMENT,
    `delivery_id` varchar(100) NOT NULL,
    `name` varchar(100) NOT NULL DEFAULT '',
    `x` float NOT NULL DEFAULT 0,
    `y` float NOT NULL DEFAULT 0,
    `z` float NOT NULL DEFAULT 0,
    `h` float NOT NULL DEFAULT 0,
    `allow_npc` tinyint(1) NOT NULL DEFAULT 1,
    `allow_deaddrop` tinyint(1) NOT NULL DEFAULT 1,
    `allow_favour` tinyint(1) NOT NULL DEFAULT 1,
    `active` tinyint(1) NOT NULL DEFAULT 1,
    `created_by` varchar(255) NOT NULL DEFAULT '',
    `created_at` datetime NOT NULL DEFAULT current_timestamp(),
    `updated_at` datetime NOT NULL DEFAULT current_timestamp() ON UPDATE current_timestamp(),
    PRIMARY KEY (`id`),
    UNIQUE KEY `delivery_id_unique` (`delivery_id`)
) ENGINE=InnoDB AUTO_INCREMENT=1 DEFAULT CHARSET=utf8;
    ]],

    ['kq_drugdeals_vehicle_locations'] = [[
CREATE TABLE IF NOT EXISTS `kq_drugdeals_vehicle_locations` (
    `id` int(11) NOT NULL AUTO_INCREMENT,
    `vehicle_id` varchar(100) NOT NULL,
    `name` varchar(100) NOT NULL DEFAULT '',
    `x` float NOT NULL DEFAULT 0,
    `y` float NOT NULL DEFAULT 0,
    `z` float NOT NULL DEFAULT 0,
    `h` float NOT NULL DEFAULT 0,
    `active` tinyint(1) NOT NULL DEFAULT 1,
    `created_by` varchar(255) NOT NULL DEFAULT '',
    `created_at` datetime NOT NULL DEFAULT current_timestamp(),
    `updated_at` datetime NOT NULL DEFAULT current_timestamp() ON UPDATE current_timestamp(),
    PRIMARY KEY (`id`),
    UNIQUE KEY `vehicle_id_unique` (`vehicle_id`)
) ENGINE=InnoDB AUTO_INCREMENT=1 DEFAULT CHARSET=utf8;
    ]],

    ['kq_drugdeals_corners'] = [[
CREATE TABLE IF NOT EXISTS `kq_drugdeals_corners` (
    `id` int(11) NOT NULL AUTO_INCREMENT,
    `corner_id` varchar(100) NOT NULL,
    `name` varchar(100) NOT NULL DEFAULT '',
    `x` float NOT NULL DEFAULT 0,
    `y` float NOT NULL DEFAULT 0,
    `z` float NOT NULL DEFAULT 0,
    `radius` float NOT NULL DEFAULT 8,
    `drugs` longtext DEFAULT NULL,
    `max_players` int(11) NOT NULL DEFAULT 2,
    `buyer_interval` int(11) NOT NULL DEFAULT 45,
    `different_drug_chance` float NOT NULL DEFAULT 0.5,
    `allow_vehicle` tinyint(1) NOT NULL DEFAULT 0,
    `jobs` longtext DEFAULT NULL,
    `jobs_enabled` tinyint(1) NOT NULL DEFAULT 0,
    `active` tinyint(1) NOT NULL DEFAULT 1,
    `created_by` varchar(255) NOT NULL DEFAULT '',
    `created_at` datetime NOT NULL DEFAULT current_timestamp(),
    `updated_at` datetime NOT NULL DEFAULT current_timestamp() ON UPDATE current_timestamp(),
    PRIMARY KEY (`id`),
    UNIQUE KEY `corner_id_unique` (`corner_id`)
) ENGINE=InnoDB AUTO_INCREMENT=1 DEFAULT CHARSET=utf8;
    ]],

    ['kq_drugdeals_player_rep'] = [[
CREATE TABLE IF NOT EXISTS `kq_drugdeals_player_rep` (
    `id` int(11) NOT NULL AUTO_INCREMENT,
    `character_id` varchar(100) NOT NULL,
    `stars` float NOT NULL DEFAULT 1.0,
    `deals_completed` int(11) NOT NULL DEFAULT 0,
    `updated_at` datetime NOT NULL DEFAULT current_timestamp() ON UPDATE current_timestamp(),
    PRIMARY KEY (`id`),
    UNIQUE KEY `character_id_unique` (`character_id`)
) ENGINE=InnoDB AUTO_INCREMENT=1 DEFAULT CHARSET=utf8;
    ]],

    ['kq_drugdeals_market'] = [[
CREATE TABLE IF NOT EXISTS `kq_drugdeals_market` (
    `id` int(11) NOT NULL AUTO_INCREMENT,
    `drug_id` varchar(100) NOT NULL,
    `drift` float NOT NULL DEFAULT 0,
    `updated_at` datetime NOT NULL DEFAULT current_timestamp() ON UPDATE current_timestamp(),
    PRIMARY KEY (`id`),
    UNIQUE KEY `drug_id_unique` (`drug_id`)
) ENGINE=InnoDB AUTO_INCREMENT=1 DEFAULT CHARSET=utf8;
    ]],

    ['kq_drugdeals_player_orgs'] = [[
CREATE TABLE IF NOT EXISTS `kq_drugdeals_player_orgs` (
    `id` int(11) NOT NULL AUTO_INCREMENT,
    `character_id` varchar(100) NOT NULL,
    `org_id` varchar(100) NOT NULL,
    `unlocked` tinyint(1) NOT NULL DEFAULT 0,
    `standing` float NOT NULL DEFAULT 50,
    `standing_updated_at` datetime NOT NULL DEFAULT current_timestamp(),
    `created_at` datetime NOT NULL DEFAULT current_timestamp(),
    PRIMARY KEY (`id`),
    UNIQUE KEY `character_org_unique` (`character_id`, `org_id`)
) ENGINE=InnoDB AUTO_INCREMENT=1 DEFAULT CHARSET=utf8;
    ]],

    ['kq_drugdeals_contacts'] = [[
CREATE TABLE IF NOT EXISTS `kq_drugdeals_contacts` (
    `id` int(11) NOT NULL AUTO_INCREMENT,
    `contact_id` varchar(100) NOT NULL,
    `character_id` varchar(100) NOT NULL,
    `name` varchar(100) NOT NULL DEFAULT '',
    `avatar` varchar(10) NOT NULL DEFAULT '',
    `persona` varchar(30) NOT NULL DEFAULT 'regular',
    `delivery_method` varchar(10) NOT NULL DEFAULT 'deaddrop',
    `ped_model` varchar(100) NOT NULL DEFAULT '',
    `drugs` longtext DEFAULT NULL,
    `standing` float NOT NULL DEFAULT 40,
    `deals` int(11) NOT NULL DEFAULT 0,
    `never_buys` tinyint(1) NOT NULL DEFAULT 0,
    `status` varchar(10) NOT NULL DEFAULT 'active',
    `farewell_sent` tinyint(1) NOT NULL DEFAULT 0,
    `home_x` float DEFAULT NULL,
    `home_y` float DEFAULT NULL,
    `expires_at` datetime NOT NULL DEFAULT current_timestamp(),
    `created_at` datetime NOT NULL DEFAULT current_timestamp(),
    PRIMARY KEY (`id`),
    UNIQUE KEY `contact_id_unique` (`contact_id`),
    KEY `character_id_index` (`character_id`)
) ENGINE=InnoDB AUTO_INCREMENT=1 DEFAULT CHARSET=utf8;
    ]],

}

local migrations = {
    {
        table = 'kq_drugdeals_organizations',
        column = 'metadata',
        apply = 'ALTER TABLE `kq_drugdeals_organizations` ADD COLUMN `metadata` longtext DEFAULT NULL AFTER `jobs_enabled`;',
    },
}

local function EnsureTablesExists()
    for _, createQuery in pairs(tables) do
        DB.SqlMutate(createQuery)
    end
end

local function RunMigrations()
    for _, migration in ipairs(migrations) do
        local rows = DB.SqlQuery([[
            SELECT COUNT(*) AS present FROM information_schema.COLUMNS
            WHERE TABLE_SCHEMA = DATABASE() AND TABLE_NAME = @table AND COLUMN_NAME = @column;
        ]], { ['@table'] = migration.table, ['@column'] = migration.column })

        if rows and rows[1] and tonumber(rows[1].present) == 0 then
            DB.SqlMutate(migration.apply)
        end
    end
end

DbTablesReady = false

Citizen.CreateThread(function()
    Citizen.Wait(50)

    EnsureTablesExists()
    RunMigrations()
    DbTablesReady = true
end)
