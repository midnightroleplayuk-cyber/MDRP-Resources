-- worm_pawnshop schema. Created automatically on start when config/server.lua autoSql = true.

CREATE TABLE IF NOT EXISTS `worm_pawnshop_orders` (
    `id` VARCHAR(16) NOT NULL,
    `citizenid` VARCHAR(64) NOT NULL,
    `offer_id` VARCHAR(32) NOT NULL,
    `cycle_id` INT NOT NULL,
    `type` VARCHAR(32) NOT NULL,
    `legal` TINYINT(1) NOT NULL DEFAULT 1,
    `title` VARCHAR(64) NOT NULL,
    `items` LONGTEXT NOT NULL,
    `payout` INT NOT NULL,
    `fee` INT NOT NULL,
    `state` VARCHAR(16) NOT NULL,
    `accepted_at` INT NOT NULL,
    `deadline_at` INT NOT NULL,
    `prepare_started_at` INT NULL,
    `prepare_ends_at` INT NULL,
    `load_ends_at` INT NULL,
    `shipped_at` INT NULL,
    `placed_at` INT NULL,
    `closed_at` INT NULL,
    `data` LONGTEXT NULL,
    PRIMARY KEY (`id`),
    KEY `citizenid` (`citizenid`),
    KEY `state` (`state`)
);

CREATE TABLE IF NOT EXISTS `worm_pawnshop_deliveries` (
    `id` INT NOT NULL AUTO_INCREMENT,
    `order_id` VARCHAR(16) NOT NULL,
    `citizenid` VARCHAR(64) NOT NULL,
    `name` VARCHAR(64) NOT NULL,
    `type` VARCHAR(32) NOT NULL,
    `legal` TINYINT(1) NOT NULL DEFAULT 1,
    `boxes` INT NOT NULL DEFAULT 1,
    `payout` INT NOT NULL,
    `laundered` INT NOT NULL DEFAULT 0,
    `driver_cut` INT NOT NULL DEFAULT 0,
    `delivered_at` INT NOT NULL,
    PRIMARY KEY (`id`),
    KEY `citizenid` (`citizenid`),
    KEY `delivered_at` (`delivered_at`)
);
