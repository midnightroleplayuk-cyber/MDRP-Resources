-- =====================================================================
--  apex_dealerships — database schema
--
--  IMPORTING THIS FILE IS OPTIONAL. Every table below is created (and
--  migrated) automatically on first start. It is shipped so you can review
--  the schema, or pre-create it on a locked-down database user.
--
--  Generated from build/server/database.lua — do not hand-edit.
-- =====================================================================

CREATE TABLE IF NOT EXISTS `apex_dealerships_catalog` (
        `model`      VARCHAR(60)  NOT NULL PRIMARY KEY,
        `brand`      VARCHAR(60)  NOT NULL DEFAULT '',
        `name`       VARCHAR(80)  NOT NULL,
        `category`   VARCHAR(40)  NOT NULL,
        `price`      BIGINT       NOT NULL DEFAULT 0,
        `created_at` TIMESTAMP    DEFAULT CURRENT_TIMESTAMP
    ) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

CREATE TABLE IF NOT EXISTS `apex_dealerships_business` (
        `id`          VARCHAR(60) NOT NULL PRIMARY KEY,
        `balance`     BIGINT      NOT NULL DEFAULT 0,
        `commission`  INT         NOT NULL DEFAULT 10,
        `lifetime_revenue` BIGINT NOT NULL DEFAULT 0
    ) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

CREATE TABLE IF NOT EXISTS `apex_dealerships_stock` (
        `dealership` VARCHAR(60) NOT NULL,
        `model`      VARCHAR(60) NOT NULL,
        `stock`      INT         NOT NULL DEFAULT 0,
        `price`      BIGINT      DEFAULT NULL,
        PRIMARY KEY (`dealership`, `model`)
    ) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

CREATE TABLE IF NOT EXISTS `apex_dealerships_sales` (
        `id`         INT AUTO_INCREMENT PRIMARY KEY,
        `dealership` VARCHAR(60)  NOT NULL,
        `model`      VARCHAR(60)  NOT NULL,
        `plate`      VARCHAR(12)  NOT NULL,
        `buyer`      VARCHAR(60)  NOT NULL,
        `buyer_name` VARCHAR(80)  NOT NULL DEFAULT '',
        `seller`     VARCHAR(60)  DEFAULT NULL,
        `seller_name` VARCHAR(80) DEFAULT NULL,
        `kind`       VARCHAR(20)  NOT NULL,
        `amount`     BIGINT       NOT NULL DEFAULT 0,
        `commission` BIGINT       NOT NULL DEFAULT 0,
        `created_at` TIMESTAMP    DEFAULT CURRENT_TIMESTAMP,
        INDEX `idx_dealer` (`dealership`, `created_at`),
        INDEX `idx_buyer`  (`buyer`)
    ) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

CREATE TABLE IF NOT EXISTS `apex_dealerships_orders` (
        `id`         INT AUTO_INCREMENT PRIMARY KEY,
        `dealership` VARCHAR(60) NOT NULL,
        `model`      VARCHAR(60) NOT NULL,
        `quantity`   INT         NOT NULL,
        `cost`       BIGINT      NOT NULL,
        `ordered_by` VARCHAR(80) NOT NULL DEFAULT '',
        `deliver_at` BIGINT      NOT NULL,
        `fulfilled`  TINYINT(1)  NOT NULL DEFAULT 0,
        `created_at` TIMESTAMP   DEFAULT CURRENT_TIMESTAMP,
        INDEX `idx_due` (`fulfilled`, `deliver_at`),
        INDEX `idx_dealer` (`dealership`)
    ) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

CREATE TABLE IF NOT EXISTS `apex_dealerships_employees` (
        `id`         INT AUTO_INCREMENT PRIMARY KEY,
        `identifier` VARCHAR(60) NOT NULL,
        `name`       VARCHAR(80) NOT NULL DEFAULT '',
        `dealership` VARCHAR(60) NOT NULL,
        `role`       VARCHAR(40) NOT NULL,
        `hired_at`   TIMESTAMP   DEFAULT CURRENT_TIMESTAMP,
        UNIQUE KEY `uq_emp` (`identifier`, `dealership`),
        INDEX `idx_dealer` (`dealership`)
    ) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

CREATE TABLE IF NOT EXISTS `apex_dealerships_coupons` (
        `id`            INT AUTO_INCREMENT PRIMARY KEY,
        `code`          VARCHAR(40)  NOT NULL,
        `dealership`    VARCHAR(60)  NOT NULL,
        `discount_type` ENUM('amount','percent') NOT NULL,
        `discount_value` BIGINT      NOT NULL,
        `max_uses`      INT          DEFAULT NULL,
        `current_uses`  INT          NOT NULL DEFAULT 0,
        `per_player`    INT          DEFAULT NULL,
        `expires_at`    BIGINT       DEFAULT NULL,
        `allow_finance` TINYINT(1)   NOT NULL DEFAULT 1,
        `active`        TINYINT(1)   NOT NULL DEFAULT 1,
        `created_by`    VARCHAR(80)  NOT NULL DEFAULT '',
        `created_at`    TIMESTAMP    DEFAULT CURRENT_TIMESTAMP,
        UNIQUE KEY `uq_code` (`code`, `dealership`)
    ) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

CREATE TABLE IF NOT EXISTS `apex_dealerships_coupon_usage` (
        `id`         INT AUTO_INCREMENT PRIMARY KEY,
        `coupon_id`  INT          NOT NULL,
        `identifier` VARCHAR(60)  NOT NULL,
        `model`      VARCHAR(60)  NOT NULL,
        `discount`   BIGINT       NOT NULL,
        `used_at`    TIMESTAMP    DEFAULT CURRENT_TIMESTAMP,
        INDEX `idx_coupon` (`coupon_id`, `identifier`)
    ) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

CREATE TABLE IF NOT EXISTS `apex_dealerships_showcase` (
        `id`         INT AUTO_INCREMENT PRIMARY KEY,
        `dealership` VARCHAR(60) NOT NULL,
        `model`      VARCHAR(60) NOT NULL,
        `props`      LONGTEXT    DEFAULT NULL,
        `coords`     VARCHAR(120) NOT NULL,
        INDEX `idx_dealer` (`dealership`)
    ) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

CREATE TABLE IF NOT EXISTS `apex_dealerships_stands` (
        `id`         VARCHAR(60)  NOT NULL PRIMARY KEY,
        `label`      VARCHAR(80)  NOT NULL,
        `data`       LONGTEXT     NOT NULL,
        `enabled`    TINYINT(1)   NOT NULL DEFAULT 1,
        `created_at` TIMESTAMP    DEFAULT CURRENT_TIMESTAMP,
        `updated_at` TIMESTAMP    DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
    ) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

CREATE TABLE IF NOT EXISTS `apex_dealerships_listings` (
        `id`         INT AUTO_INCREMENT PRIMARY KEY,
        `name`       VARCHAR(60)  NOT NULL,
        `vehicles`   LONGTEXT     NOT NULL,
        `created_at` TIMESTAMP    DEFAULT CURRENT_TIMESTAMP
    ) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

CREATE TABLE IF NOT EXISTS `apex_dealerships_categories` (
        `key`    VARCHAR(40) NOT NULL PRIMARY KEY,
        `label`  VARCHAR(60) NOT NULL,
        `domain` ENUM('land','air','sea') NOT NULL DEFAULT 'land',
        `sort`   INT         NOT NULL DEFAULT 100
    ) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

CREATE TABLE IF NOT EXISTS `apex_dealerships_settings` (
        `k`          VARCHAR(40) NOT NULL PRIMARY KEY,
        `v`          LONGTEXT    NOT NULL,
        `updated_at` TIMESTAMP   DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
    ) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- ---------------------------------------------------------------------
--  Migrations for installs created by an older version. They are applied
--  automatically at boot; they are listed here for completeness and are
--  safe to skip on a fresh install (the CREATEs above already include
--  every column except these).
-- ---------------------------------------------------------------------
ALTER TABLE `apex_dealerships_business` ADD COLUMN `settings`   TEXT        NULL;
ALTER TABLE `apex_dealerships_business` ADD COLUMN `owner`      VARCHAR(64) NULL;
ALTER TABLE `apex_dealerships_business` ADD COLUMN `owner_name` VARCHAR(80) NULL;
ALTER TABLE `apex_dealerships_business` ADD COLUMN `for_sale`   BIGINT      NULL;

ALTER TABLE `apex_dealerships_orders` ADD COLUMN `delivered`       INT         NOT NULL DEFAULT 0;
ALTER TABLE `apex_dealerships_orders` ADD COLUMN `size_category`   VARCHAR(10) NOT NULL DEFAULT 'medium';
ALTER TABLE `apex_dealerships_orders` ADD COLUMN `delivered_by`    VARCHAR(80) NULL;
ALTER TABLE `apex_dealerships_orders` ADD COLUMN `pickup_location` VARCHAR(80) NULL;

ALTER TABLE `apex_dealerships_catalog` ADD COLUMN `min_price` BIGINT NULL;
ALTER TABLE `apex_dealerships_catalog` ADD COLUMN `max_price` BIGINT NULL;

ALTER TABLE `apex_dealerships_coupons` ADD COLUMN `vehicle_restrictions`  TEXT NULL;
ALTER TABLE `apex_dealerships_coupons` ADD COLUMN `category_restrictions` TEXT NULL;

-- Financing is tracked on YOUR framework's vehicle table:
--   ESX  -> owned_vehicles      QBCore/QBox -> player_vehicles
-- Run the pair that matches your framework (the resource does this for you).
-- ALTER TABLE `owned_vehicles`  ADD COLUMN `financed` TINYINT(1) NOT NULL DEFAULT 0;
-- ALTER TABLE `owned_vehicles`  ADD COLUMN `finance_data` LONGTEXT DEFAULT NULL;
-- ALTER TABLE `player_vehicles` ADD COLUMN `financed` TINYINT(1) NOT NULL DEFAULT 0;
-- ALTER TABLE `player_vehicles` ADD COLUMN `finance_data` LONGTEXT DEFAULT NULL;
