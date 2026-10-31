-- vinewood_police 010_locations: places set in game with the location editor (override the config).

CREATE TABLE IF NOT EXISTS `vpo_locations` (
    `key`        VARCHAR(32)  NOT NULL,
    `data`       MEDIUMTEXT   NOT NULL,
    `updated_at` INT UNSIGNED NOT NULL,
    `updated_by` VARCHAR(120) DEFAULT NULL,
    PRIMARY KEY (`key`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;
