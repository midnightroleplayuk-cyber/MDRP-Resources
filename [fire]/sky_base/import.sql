-- Optional manual mirror of the automatically migrated durable framework registry.
-- Inherit the active database character set and collation; retain existing definitions.
-- Common ESX-shaped definition projection for QBCore/Qbox. These are the existing
-- native tables on ESX; never replace rows belonging to another creator.
CREATE TABLE IF NOT EXISTS `jobs` (
    `name` VARCHAR(50) NOT NULL,
    `label` VARCHAR(100) NULL,
    PRIMARY KEY (`name`)
) ENGINE=InnoDB;

CREATE TABLE IF NOT EXISTS `job_grades` (
    `id` INT NOT NULL AUTO_INCREMENT,
    `job_name` VARCHAR(50) NULL,
    `grade` INT NOT NULL,
    `name` VARCHAR(50) NOT NULL,
    `label` VARCHAR(100) NOT NULL,
    `salary` INT NOT NULL,
    `skin_male` LONGTEXT NULL,
    `skin_female` LONGTEXT NULL,
    PRIMARY KEY (`id`),
    INDEX `idx_sky_job_grades_level` (`job_name`,`grade`)
) ENGINE=InnoDB;

SET @sky_managed_migration = IF(
    (SELECT COUNT(*) FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_SCHEMA = DATABASE()
        AND TABLE_NAME = 'job_grades' AND COLUMN_NAME = 'skin_male') = 0,
    'ALTER TABLE `job_grades` ADD COLUMN `skin_male` LONGTEXT NULL', 'SELECT 1');
PREPARE sky_managed_migration FROM @sky_managed_migration;
EXECUTE sky_managed_migration;
DEALLOCATE PREPARE sky_managed_migration;

SET @sky_managed_migration = IF(
    (SELECT COUNT(*) FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_SCHEMA = DATABASE()
        AND TABLE_NAME = 'job_grades' AND COLUMN_NAME = 'skin_female') = 0,
    'ALTER TABLE `job_grades` ADD COLUMN `skin_female` LONGTEXT NULL', 'SELECT 1');
PREPARE sky_managed_migration FROM @sky_managed_migration;
EXECUTE sky_managed_migration;
DEALLOCATE PREPARE sky_managed_migration;

CREATE TABLE IF NOT EXISTS `sky_managed_job_definitions` (
    `job_name` VARCHAR(64) NOT NULL,
    `owner` VARCHAR(64) NOT NULL,
    `origin` VARCHAR(16) NOT NULL,
    `definition` LONGTEXT NOT NULL,
    `baseline` LONGTEXT NOT NULL,
    `status` VARCHAR(16) NOT NULL DEFAULT 'pending',
    `last_error` TEXT NULL,
    `activation_stage` VARCHAR(32) NULL,
    `error_code` VARCHAR(64) NULL,
    `account_attempted` TINYINT(1) NULL,
    `member_updates` LONGTEXT NULL,
    `rename_state` LONGTEXT NULL,
    `updated_at` TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    PRIMARY KEY (`job_name`),
    INDEX `idx_managed_owner` (`owner`)
) ENGINE=InnoDB;

SET @sky_managed_migration = IF(
    (SELECT DATA_TYPE = 'varchar' AND CHARACTER_MAXIMUM_LENGTH = 50 FROM INFORMATION_SCHEMA.COLUMNS
        WHERE TABLE_SCHEMA = DATABASE() AND TABLE_NAME = 'sky_managed_job_definitions' AND COLUMN_NAME = 'job_name'),
    'ALTER TABLE `sky_managed_job_definitions` MODIFY `job_name` VARCHAR(64) NOT NULL', 'SELECT 1');
PREPARE sky_managed_migration FROM @sky_managed_migration;
EXECUTE sky_managed_migration;
DEALLOCATE PREPARE sky_managed_migration;

-- Private server-only override for the existing Creator audit route.
CREATE TABLE IF NOT EXISTS `sky_creator_log_settings` (
    `channel` VARCHAR(64) NOT NULL,
    `revision` BIGINT UNSIGNED NOT NULL DEFAULT 0,
    `enabled` TINYINT(1) NOT NULL DEFAULT 1,
    `webhook_mode` VARCHAR(8) NOT NULL DEFAULT 'default',
    `webhook_url` VARCHAR(2048) NOT NULL DEFAULT '',
    `routes` LONGTEXT NULL,
    PRIMARY KEY (`channel`)
) ENGINE=InnoDB;

SET @sky_creator_log_migration = IF(
    (SELECT COUNT(*) FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_SCHEMA = DATABASE()
        AND TABLE_NAME = 'sky_creator_log_settings' AND COLUMN_NAME = 'routes') = 0,
    'ALTER TABLE `sky_creator_log_settings` ADD COLUMN `routes` LONGTEXT NULL', 'SELECT 1');
PREPARE sky_creator_log_migration FROM @sky_creator_log_migration;
EXECUTE sky_creator_log_migration;
DEALLOCATE PREPARE sky_creator_log_migration;

SET @sky_managed_migration = IF(
    (SELECT COUNT(*) FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_SCHEMA = DATABASE()
        AND TABLE_NAME = 'sky_managed_job_definitions' AND COLUMN_NAME = 'activation_stage') = 0,
    'ALTER TABLE `sky_managed_job_definitions` ADD COLUMN `activation_stage` VARCHAR(32) NULL', 'SELECT 1');
PREPARE sky_managed_migration FROM @sky_managed_migration;
EXECUTE sky_managed_migration;
DEALLOCATE PREPARE sky_managed_migration;

SET @sky_managed_migration = IF(
    (SELECT COUNT(*) FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_SCHEMA = DATABASE()
        AND TABLE_NAME = 'sky_managed_job_definitions' AND COLUMN_NAME = 'error_code') = 0,
    'ALTER TABLE `sky_managed_job_definitions` ADD COLUMN `error_code` VARCHAR(64) NULL', 'SELECT 1');
PREPARE sky_managed_migration FROM @sky_managed_migration;
EXECUTE sky_managed_migration;
DEALLOCATE PREPARE sky_managed_migration;

SET @sky_managed_migration = IF(
    (SELECT COUNT(*) FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_SCHEMA = DATABASE()
        AND TABLE_NAME = 'sky_managed_job_definitions' AND COLUMN_NAME = 'account_attempted') = 0,
    'ALTER TABLE `sky_managed_job_definitions` ADD COLUMN `account_attempted` TINYINT(1) NULL', 'SELECT 1');
PREPARE sky_managed_migration FROM @sky_managed_migration;
EXECUTE sky_managed_migration;
DEALLOCATE PREPARE sky_managed_migration;

SET @sky_managed_migration = IF(
    (SELECT COUNT(*) FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_SCHEMA = DATABASE()
        AND TABLE_NAME = 'sky_managed_job_definitions' AND COLUMN_NAME = 'member_updates') = 0,
    'ALTER TABLE `sky_managed_job_definitions` ADD COLUMN `member_updates` LONGTEXT NULL', 'SELECT 1');
PREPARE sky_managed_migration FROM @sky_managed_migration;
EXECUTE sky_managed_migration;
DEALLOCATE PREPARE sky_managed_migration;

SET @sky_managed_migration = IF(
    (SELECT COUNT(*) FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_SCHEMA = DATABASE()
        AND TABLE_NAME = 'sky_managed_job_definitions' AND COLUMN_NAME = 'rename_state') = 0,
    'ALTER TABLE `sky_managed_job_definitions` ADD COLUMN `rename_state` LONGTEXT NULL', 'SELECT 1');
PREPARE sky_managed_migration FROM @sky_managed_migration;
EXECUTE sky_managed_migration;
DEALLOCATE PREPARE sky_managed_migration;

SET @sky_managed_migration = IF(
    (SELECT ENGINE FROM INFORMATION_SCHEMA.TABLES WHERE TABLE_SCHEMA = DATABASE()
        AND TABLE_NAME = 'sky_managed_job_definitions') <> 'InnoDB',
    'ALTER TABLE `sky_managed_job_definitions` ENGINE=InnoDB', 'SELECT 1');
PREPARE sky_managed_migration FROM @sky_managed_migration;
EXECUTE sky_managed_migration;
DEALLOCATE PREPARE sky_managed_migration;
