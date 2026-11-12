-- Optional: the resource creates these tables itself on first start.
CREATE TABLE IF NOT EXISTS `vinewood_multichar_scenes` (
    `id` INT NOT NULL AUTO_INCREMENT,
    `name` VARCHAR(64) NOT NULL,
    `enabled` TINYINT(1) NOT NULL DEFAULT 1,
    `weight` INT NOT NULL DEFAULT 1,
    `data` LONGTEXT NOT NULL,
    `updated_by` VARCHAR(64) DEFAULT NULL,
    `updated_at` TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

CREATE TABLE IF NOT EXISTS `vinewood_multichar_slots` (
    `identifier` VARCHAR(80) NOT NULL,
    `mode` VARCHAR(8) NOT NULL DEFAULT 'add',
    `slots` INT NOT NULL DEFAULT 0,
    `note` VARCHAR(128) DEFAULT NULL,
    `name` VARCHAR(64) DEFAULT NULL,
    `set_by` VARCHAR(64) DEFAULT NULL,
    `updated_at` TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    PRIMARY KEY (`identifier`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

CREATE TABLE IF NOT EXISTS `vinewood_multichar_settings` (
    `k` VARCHAR(64) NOT NULL,
    `v` LONGTEXT NOT NULL,
    PRIMARY KEY (`k`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;
