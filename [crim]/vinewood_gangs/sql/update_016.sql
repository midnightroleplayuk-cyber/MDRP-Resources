-- 16: settings staff change in game (e.g. which drugs can be sold on the street)
CREATE TABLE IF NOT EXISTS `vg_settings` (
    `key`        VARCHAR(48) NOT NULL,
    `value`      LONGTEXT    NOT NULL,
    `updated_by` VARCHAR(64) NULL DEFAULT NULL,
    `updated_at` TIMESTAMP   NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    PRIMARY KEY (`key`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
