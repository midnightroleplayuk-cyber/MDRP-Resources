-- Rex Darts - optional: these tables are created automatically on start (oxmysql).
CREATE TABLE IF NOT EXISTS `rex_darts_stats` (
    `identifier` VARCHAR(64) NOT NULL,
    `name` VARCHAR(64) NOT NULL DEFAULT '',
    `games` INT NOT NULL DEFAULT 0,
    `wins` INT NOT NULL DEFAULT 0,
    `losses` INT NOT NULL DEFAULT 0,
    `darts` INT NOT NULL DEFAULT 0,
    `x01_darts` INT NOT NULL DEFAULT 0,
    `x01_scored` INT NOT NULL DEFAULT 0,
    `tons` INT NOT NULL DEFAULT 0,
    `max180` INT NOT NULL DEFAULT 0,
    `best_visit` INT NOT NULL DEFAULT 0,
    `best_checkout` INT NOT NULL DEFAULT 0,
    `earnings` BIGINT NOT NULL DEFAULT 0,
    `updated_at` TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    PRIMARY KEY (`identifier`),
    KEY `wins_idx` (`wins`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

CREATE TABLE IF NOT EXISTS `rex_darts_boards` (
    `id` INT NOT NULL AUTO_INCREMENT,
    `owner` VARCHAR(64) NOT NULL DEFAULT '',
    `model` VARCHAR(64) NOT NULL,
    `x` FLOAT NOT NULL,
    `y` FLOAT NOT NULL,
    `z` FLOAT NOT NULL,
    `heading` FLOAT NOT NULL DEFAULT 0,
    `created_at` TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;
