-- Rex Pool - optional: tables are created automatically on start when oxmysql is running.
CREATE TABLE IF NOT EXISTS `rex_pool_stats` (
    `identifier` VARCHAR(64) NOT NULL,
    `name` VARCHAR(64) NOT NULL DEFAULT '',
    `games` INT NOT NULL DEFAULT 0,
    `wins` INT NOT NULL DEFAULT 0,
    `losses` INT NOT NULL DEFAULT 0,
    `potted` INT NOT NULL DEFAULT 0,
    `fouls` INT NOT NULL DEFAULT 0,
    `best_break` INT NOT NULL DEFAULT 0,
    `best_run` INT NOT NULL DEFAULT 0,
    `earnings` BIGINT NOT NULL DEFAULT 0,
    `updated_at` TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    PRIMARY KEY (`identifier`),
    KEY `wins_idx` (`wins`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

CREATE TABLE IF NOT EXISTS `rex_pool_matches` (
    `id` INT NOT NULL AUTO_INCREMENT,
    `mode` VARCHAR(16) NOT NULL,
    `location` VARCHAR(64) NOT NULL DEFAULT '',
    `winner_team` CHAR(1) NULL,
    `players` LONGTEXT NOT NULL,
    `wager` INT NOT NULL DEFAULT 0,
    `pot` INT NOT NULL DEFAULT 0,
    `shots` INT NOT NULL DEFAULT 0,
    `created_at` TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;
