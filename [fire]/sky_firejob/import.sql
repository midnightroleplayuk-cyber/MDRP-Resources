-- sky_firejob import.sql


CREATE TABLE IF NOT EXISTS `sky_jobs` (
    `id` INT NOT NULL AUTO_INCREMENT,
    `job` VARCHAR(50) NULL DEFAULT NULL,
    PRIMARY KEY (`id`),
    UNIQUE KEY `job` (`job`)
);

CREATE TABLE IF NOT EXISTS `sky_fire_reports` (
    `id` INT NOT NULL AUTO_INCREMENT,
    `job_id` INT NULL,
    `report_id` VARCHAR(40) NOT NULL,
    `revision` INT NOT NULL DEFAULT 1,
    `share_revision` INT NOT NULL DEFAULT 1,
    `report_type` VARCHAR(80) NOT NULL,
    `owner_job` VARCHAR(50) NULL,
    `shared_with_jobs` TEXT NULL,
    `location` VARCHAR(160) NULL,
    `incident_status` VARCHAR(80) NULL,
    `description` TEXT NULL,
    `tags` TEXT NULL,
    `evidence` LONGTEXT NULL,
    `involved_firefighters` TEXT NULL,
    `involved_civilians` TEXT NULL,
    `hazards` TEXT NULL,
    `actions_taken` TEXT NULL,
    `equipment_used` TEXT NULL,
    `created_at` DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
    `updated_at` DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    PRIMARY KEY (`id`),
    UNIQUE KEY `uniq_job_report` (`job_id`, `report_id`),
    KEY `idx_job_updated` (`job_id`, `updated_at`),
    KEY `idx_owner_updated` (`owner_job`, `updated_at`),
    CONSTRAINT `fk_sky_fire_reports_job_id`
        FOREIGN KEY (`job_id`) REFERENCES `sky_jobs` (`id`)
);

ALTER TABLE `sky_fire_reports`
    ADD COLUMN IF NOT EXISTS `owner_job` VARCHAR(50) NULL AFTER `report_type`,
    ADD COLUMN IF NOT EXISTS `shared_with_jobs` TEXT NULL AFTER `owner_job`,
    ADD INDEX IF NOT EXISTS `idx_owner_updated` (`owner_job`, `updated_at`);

UPDATE `sky_fire_reports` reports
INNER JOIN `sky_jobs` jobs ON jobs.id = reports.job_id
SET reports.owner_job = jobs.job
WHERE reports.owner_job IS NULL OR reports.owner_job = '';

CREATE TABLE IF NOT EXISTS `sky_fire_oil_spills` (
    `spill_id` VARCHAR(64) NOT NULL,
    `x` DOUBLE NOT NULL DEFAULT 0,
    `y` DOUBLE NOT NULL DEFAULT 0,
    `z` DOUBLE NOT NULL DEFAULT 0,
    `radius` DOUBLE NOT NULL DEFAULT 1.25,
    `intensity` DOUBLE NOT NULL DEFAULT 1,
    `state` VARCHAR(24) NOT NULL DEFAULT 'fresh',
    `source` VARCHAR(32) NOT NULL DEFAULT 'vehicle',
    `source_part` VARCHAR(64) NOT NULL DEFAULT 'engine_oil',
    `source_vehicle_net_id` INT NOT NULL DEFAULT 0,
    `source_plate` VARCHAR(64) NULL,
    `can_spread` TINYINT(1) NOT NULL DEFAULT 1,
    `bound_by` INT NULL DEFAULT NULL,
    `created_at` DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
    PRIMARY KEY (`spill_id`),
    KEY `idx_created_at` (`created_at`)
);

ALTER TABLE `sky_fire_oil_spills`
    MODIFY COLUMN `source_plate` VARCHAR(64) NULL;

CREATE TABLE IF NOT EXISTS `sky_fire_extinguishers` (
    `extinguisher_id` VARCHAR(96) NOT NULL,
    `model` VARCHAR(80) NOT NULL,
    `x` DOUBLE NOT NULL DEFAULT 0,
    `y` DOUBLE NOT NULL DEFAULT 0,
    `z` DOUBLE NOT NULL DEFAULT 0,
    `rx` DOUBLE NULL DEFAULT NULL,
    `ry` DOUBLE NULL DEFAULT NULL,
    `rz` DOUBLE NULL DEFAULT NULL,
    `fill_level` DOUBLE NOT NULL DEFAULT 100,
    `item_metadata` LONGTEXT NULL,
    `condition_status` VARCHAR(16) NOT NULL DEFAULT 'checked',
    `is_taken` TINYINT(1) NOT NULL DEFAULT 1,
    `is_custom` TINYINT(1) NOT NULL DEFAULT 0,
    `taken_by` INT NULL DEFAULT NULL,
    `taken_at` DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
    `last_inspected_by` INT NULL DEFAULT NULL,
    `last_inspected_at` DATETIME NULL DEFAULT NULL,
    PRIMARY KEY (`extinguisher_id`),
    KEY `idx_model_coords` (`model`, `x`, `y`, `z`),
    KEY `idx_inspection_due` (`is_taken`, `last_inspected_at`)
);

ALTER TABLE `sky_fire_extinguishers`
    ADD COLUMN IF NOT EXISTS `rx` DOUBLE NULL DEFAULT NULL,
    ADD COLUMN IF NOT EXISTS `ry` DOUBLE NULL DEFAULT NULL,
    ADD COLUMN IF NOT EXISTS `rz` DOUBLE NULL DEFAULT NULL,
    ADD COLUMN IF NOT EXISTS `fill_level` DOUBLE NOT NULL DEFAULT 100,
    ADD COLUMN IF NOT EXISTS `item_metadata` LONGTEXT NULL,
    ADD COLUMN IF NOT EXISTS `condition_status` VARCHAR(16) NOT NULL DEFAULT 'checked',
    ADD COLUMN IF NOT EXISTS `is_taken` TINYINT(1) NOT NULL DEFAULT 1,
    ADD COLUMN IF NOT EXISTS `is_custom` TINYINT(1) NOT NULL DEFAULT 0 AFTER `is_taken`,
    ADD COLUMN IF NOT EXISTS `last_inspected_by` INT NULL DEFAULT NULL,
    ADD COLUMN IF NOT EXISTS `last_inspected_at` DATETIME NULL DEFAULT NULL;

ALTER TABLE `sky_fire_extinguishers`
    ADD INDEX IF NOT EXISTS `idx_inspection_due` (`is_taken`, `last_inspected_at`);

CREATE TABLE IF NOT EXISTS `sky_firejob_scenarios` (
    `id` INT NOT NULL AUTO_INCREMENT,
    `scenario_key` VARCHAR(64) NOT NULL,
    `label` VARCHAR(120) NOT NULL,
    `data` LONGTEXT NOT NULL,
    `draft` TINYINT(1) NOT NULL DEFAULT 1,
    `enabled` TINYINT(1) NOT NULL DEFAULT 1,
    `created_at` DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
    `updated_at` DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    PRIMARY KEY (`id`),
    UNIQUE KEY `uniq_scenario_key` (`scenario_key`),
    KEY `idx_enabled` (`enabled`)
);

CREATE TABLE IF NOT EXISTS `sky_firejob_scenario_hub` (
    `id` INT NOT NULL AUTO_INCREMENT,
    `public_id` VARCHAR(64) NOT NULL,
    `scenario_key` VARCHAR(64) NOT NULL,
    `label` VARCHAR(120) NOT NULL,
    `description` TEXT NULL,
    `author` VARCHAR(120) NULL,
    `version` INT NOT NULL DEFAULT 1,
    `tags` TEXT NULL,
    `data` LONGTEXT NOT NULL,
    `downloads` INT NOT NULL DEFAULT 0,
    `likes` INT NOT NULL DEFAULT 0,
    `dislikes` INT NOT NULL DEFAULT 0,
    `thumbnail` TEXT NULL,
    `published_at` DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
    `updated_at` DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    PRIMARY KEY (`id`),
    UNIQUE KEY `uniq_public_id` (`public_id`),
    KEY `idx_scenario_key` (`scenario_key`),
    KEY `idx_updated_at` (`updated_at`)
);

-- Preserve saved hydrant overrides when Jobs Base has already created its settings table.
-- A fresh Fire import may run before Jobs Base; shared schema remains owned by Jobs Base.
SET @sky_firejob_has_settings = EXISTS (
    SELECT 1 FROM information_schema.tables
    WHERE table_schema = DATABASE() AND table_name = 'sky_jobs_configurator_settings'
);

SET @sky_firejob_hydrant_migration = IF(@sky_firejob_has_settings,
    'UPDATE `sky_jobs_configurator_settings`
SET `settings` = JSON_REMOVE(
        JSON_SET(
            `settings`,
            ''$.hoseVehiclePumpHydraulicsHydrantSupplyLitersPerSecond'',
            CAST(JSON_UNQUOTE(JSON_EXTRACT(
                `settings`,
                ''$.hoseVehiclePumpHydraulicsHydrantSupplyGpm''
            )) AS DECIMAL(20, 6)) * 0.0630902
        ),
        ''$.hoseVehiclePumpHydraulicsHydrantSupplyGpm''
    ),
    `revision` = `revision` + 1
WHERE `config_key` = ''sky_firejob''
    AND JSON_VALID(`settings`)
    AND JSON_CONTAINS_PATH(`settings`, ''one'', ''$.hoseVehiclePumpHydraulicsHydrantSupplyGpm'')
    AND NOT JSON_CONTAINS_PATH(`settings`, ''one'', ''$.hoseVehiclePumpHydraulicsHydrantSupplyLitersPerSecond'')
    AND JSON_UNQUOTE(JSON_EXTRACT(
        `settings`,
        ''$.hoseVehiclePumpHydraulicsHydrantSupplyGpm''
    )) REGEXP ''^-?[0-9]+([.][0-9]+)?$''',
    'DO 0'
);
PREPARE sky_firejob_hydrant_migration FROM @sky_firejob_hydrant_migration;
EXECUTE sky_firejob_hydrant_migration;
DEALLOCATE PREPARE sky_firejob_hydrant_migration;

SET @sky_firejob_hydrant_migration = IF(@sky_firejob_has_settings,
    'UPDATE `sky_jobs_configurator_settings`
SET `settings` = JSON_REMOVE(`settings`, ''$.hoseVehiclePumpHydraulicsHydrantSupplyGpm''),
    `revision` = `revision` + 1
WHERE `config_key` = ''sky_firejob''
    AND JSON_VALID(`settings`)
    AND JSON_CONTAINS_PATH(`settings`, ''one'', ''$.hoseVehiclePumpHydraulicsHydrantSupplyGpm'')
    AND JSON_CONTAINS_PATH(`settings`, ''one'', ''$.hoseVehiclePumpHydraulicsHydrantSupplyLitersPerSecond'')',
    'DO 0'
);
PREPARE sky_firejob_hydrant_migration FROM @sky_firejob_hydrant_migration;
EXECUTE sky_firejob_hydrant_migration;
DEALLOCATE PREPARE sky_firejob_hydrant_migration;

SET @sky_firejob_has_settings = NULL;
SET @sky_firejob_hydrant_migration = NULL;

-- Record editor concurrency; preserve existing records and grants.
ALTER TABLE `sky_fire_reports`
    MODIFY `report_id` VARCHAR(40) NOT NULL,
    ADD COLUMN IF NOT EXISTS `revision` INT NOT NULL DEFAULT 1,
    ADD COLUMN IF NOT EXISTS `share_revision` INT NOT NULL DEFAULT 1;

-- Persistent vehicle air bottle slots, keyed by the normalized vehicle plate.
CREATE TABLE IF NOT EXISTS `sky_fire_air_storage` (
    `plate` VARCHAR(64) NOT NULL,
    `slots` LONGTEXT NOT NULL,
    PRIMARY KEY (`plate`)
) ENGINE=InnoDB;
