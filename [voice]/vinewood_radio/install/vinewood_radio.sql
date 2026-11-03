-- vinewood_radio: Septra terminal records (one row per character)
-- The resource also creates this table automatically on first start.
CREATE TABLE IF NOT EXISTS `vinewood_radio` (
    `identifier` VARCHAR(64) NOT NULL,
    `issi` VARCHAR(8) NOT NULL,
    `service` VARCHAR(32) NOT NULL,
    `callsign` VARCHAR(32) NOT NULL,
    `last_tg` VARCHAR(64) DEFAULT NULL,
    `volume` TINYINT UNSIGNED NOT NULL DEFAULT 60,
    `updated_at` TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    PRIMARY KEY (`identifier`),
    UNIQUE KEY `uq_issi` (`issi`)
);
