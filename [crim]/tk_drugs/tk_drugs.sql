CREATE TABLE IF NOT EXISTS `tk_drugs_equipment` (
    `id` INT UNSIGNED NOT NULL AUTO_INCREMENT PRIMARY KEY,
    `configIndex` VARCHAR(64) NOT NULL,
    `coords` VARCHAR(96) NOT NULL,
    `rotation` VARCHAR(96) NOT NULL,
    `bucket` BIGINT NOT NULL DEFAULT 0,
    `metadata` TEXT NULL,
    `fixedId` VARCHAR(64) NULL DEFAULT NULL,
    UNIQUE KEY `idx_fixed` (`fixedId`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

CREATE TABLE IF NOT EXISTS `tk_drugs_plants` (
    `id` INT UNSIGNED NOT NULL AUTO_INCREMENT PRIMARY KEY,
    `coords` VARCHAR(96) NOT NULL,
    `rotation` VARCHAR(96) NOT NULL,
    `water` TINYINT UNSIGNED NOT NULL DEFAULT 50,
    `fertilizer` TINYINT UNSIGNED NOT NULL DEFAULT 50,
    `configIndex` VARCHAR(64) NOT NULL,
    `placeTime` BIGINT NOT NULL,
    `lastResourceUpdate` BIGINT NOT NULL,
    `bucket` BIGINT NOT NULL DEFAULT 0,
    `owner` VARCHAR(100) NULL DEFAULT NULL,
    `pausedElapsed` BIGINT NOT NULL DEFAULT 0,
    `pausedAt` BIGINT NULL DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

CREATE TABLE IF NOT EXISTS `tk_drugs_boosters` (
    `id` INT UNSIGNED NOT NULL AUTO_INCREMENT PRIMARY KEY,
    `coords` VARCHAR(96) NOT NULL,
    `rotation` VARCHAR(96) NOT NULL,
    `configIndex` VARCHAR(64) NOT NULL,
    `bucket` BIGINT NOT NULL DEFAULT 0,
    INDEX `idx_bucket` (`bucket`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

CREATE TABLE IF NOT EXISTS `tk_drugs_labs` (
    `id` INT UNSIGNED NOT NULL PRIMARY KEY,
    `owner` VARCHAR(100) NULL DEFAULT NULL,
    `permissions` TEXT NULL,
    INDEX `idx_owner` (`owner`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

CREATE TABLE IF NOT EXISTS `tk_drugs_workers` (
    `id` INT UNSIGNED NOT NULL AUTO_INCREMENT PRIMARY KEY,
    `labId` INT UNSIGNED NULL DEFAULT NULL,
    `name` VARCHAR(100) NOT NULL,
    `equipmentId` INT UNSIGNED NULL DEFAULT NULL,
    `recipeIndex` INT UNSIGNED NOT NULL DEFAULT 1,
    `gathered` TEXT NULL,
    `holding` TEXT NULL,
    `speed` TINYINT UNSIGNED NOT NULL DEFAULT 1,
    `pedModel` VARCHAR(100) NULL DEFAULT NULL,
    `owner` VARCHAR(100) NULL DEFAULT NULL,
    INDEX `idx_lab` (`labId`),
    INDEX `idx_equipment` (`equipmentId`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

CREATE TABLE IF NOT EXISTS `tk_drugs_available_workers` (
    `id` INT UNSIGNED NOT NULL AUTO_INCREMENT PRIMARY KEY,
    `name` VARCHAR(100) NOT NULL,
    `speed` TINYINT UNSIGNED NOT NULL DEFAULT 1,
    `price` INT UNSIGNED NOT NULL DEFAULT 0,
    `generatedAt` INT UNSIGNED NOT NULL DEFAULT 0
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

CREATE TABLE IF NOT EXISTS `tk_drugs_plug_customers` (
    `id` INT UNSIGNED NOT NULL AUTO_INCREMENT PRIMARY KEY,
    `owner` VARCHAR(100) NOT NULL,
    `name` VARCHAR(100) NOT NULL,
    `pedModel` VARCHAR(100) NOT NULL,
    `rep` INT NOT NULL DEFAULT 0,
    `lastInteraction` BIGINT NULL DEFAULT NULL,
    `createdAt` BIGINT NOT NULL,
    INDEX `idx_owner` (`owner`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

CREATE TABLE IF NOT EXISTS `tk_drugs_addictions` (
    `identifier` VARCHAR(100) NOT NULL,
    `drug` VARCHAR(100) NOT NULL,
    `level` SMALLINT UNSIGNED NOT NULL DEFAULT 0,
    `lastUse` BIGINT NULL DEFAULT NULL,
    PRIMARY KEY (`identifier`, `drug`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
