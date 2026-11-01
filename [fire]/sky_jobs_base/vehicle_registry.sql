CREATE TABLE IF NOT EXISTS `sky_jobs_vehicle_registry` (
    `vehicle_id` CHAR(36) NOT NULL,
    `provider` VARCHAR(32) NOT NULL,
    `current_plate` VARCHAR(24) NOT NULL,
    `model` VARCHAR(80) NOT NULL,
    `owner_identifier` VARCHAR(128) NOT NULL,
    `owner_name` VARCHAR(120) NOT NULL,
    `revision` INT UNSIGNED NOT NULL DEFAULT 0,
    `inspection_id` CHAR(36) NULL,
    `inspection_state` VARCHAR(24) NOT NULL DEFAULT 'missing',
    `registration_id` CHAR(36) NULL,
    `registration_state` VARCHAR(24) NOT NULL DEFAULT 'unregistered',
    `updated_at` BIGINT UNSIGNED NOT NULL,
    PRIMARY KEY (`vehicle_id`),
    INDEX `idx_registry_plate` (`current_plate`)
) ENGINE=InnoDB;

CREATE TABLE IF NOT EXISTS `sky_jobs_vehicle_temporary_registrations` (
    `vehicle_id` CHAR(36) NOT NULL,
    `holder_identifier` VARCHAR(128) NOT NULL,
    `remaining_seconds` INT UNSIGNED NOT NULL,
    `playtime_seconds` BIGINT UNSIGNED NOT NULL,
    `document_id` CHAR(36) NOT NULL,
    `document_version` INT UNSIGNED NOT NULL DEFAULT 1,
    `issued_at` BIGINT UNSIGNED NOT NULL,
    PRIMARY KEY (`vehicle_id`),
    UNIQUE KEY `uniq_temporary_document` (`document_id`)
) ENGINE=InnoDB;

CREATE TABLE IF NOT EXISTS `sky_jobs_vehicle_registration_payments` (
    `operation_id` CHAR(36) NOT NULL,
    `holder_identifier` VARCHAR(128) NOT NULL,
    `amount` INT UNSIGNED NOT NULL,
    `state` VARCHAR(24) NOT NULL,
    `updated_at` BIGINT UNSIGNED NOT NULL,
    PRIMARY KEY (`operation_id`)
) ENGINE=InnoDB;

CREATE TABLE IF NOT EXISTS `sky_jobs_vehicle_inspections` (
    `id` CHAR(36) NOT NULL,
    `vehicle_id` CHAR(36) NOT NULL,
    `result` VARCHAR(24) NOT NULL,
    `report` LONGTEXT NOT NULL,
    `snapshot` LONGTEXT NOT NULL,
    `actor_identifier` VARCHAR(128) NOT NULL,
    `actor_name` VARCHAR(120) NOT NULL,
    `actor_job` VARCHAR(64) NOT NULL,
    `issued_at` BIGINT UNSIGNED NOT NULL,
    `valid_until` BIGINT UNSIGNED NULL,
    PRIMARY KEY (`id`),
    INDEX `idx_inspection_vehicle` (`vehicle_id`, `issued_at`)
) ENGINE=InnoDB;

CREATE TABLE IF NOT EXISTS `sky_jobs_vehicle_registrations` (
    `id` CHAR(36) NOT NULL,
    `vehicle_id` CHAR(36) NOT NULL,
    `holder_identifier` VARCHAR(128) NOT NULL,
    `holder_name` VARCHAR(120) NOT NULL,
    `snapshot` LONGTEXT NOT NULL,
    `actor_identifier` VARCHAR(128) NOT NULL,
    `actor_name` VARCHAR(120) NOT NULL,
    `actor_job` VARCHAR(64) NOT NULL,
    `issued_at` BIGINT UNSIGNED NOT NULL,
    PRIMARY KEY (`id`),
    INDEX `idx_registration_vehicle` (`vehicle_id`, `issued_at`)
) ENGINE=InnoDB;

CREATE TABLE IF NOT EXISTS `sky_jobs_vehicle_registry_history` (
    `operation_id` CHAR(36) NOT NULL,
    `vehicle_id` CHAR(36) NOT NULL,
    `kind` VARCHAR(32) NOT NULL,
    `document_id` CHAR(36) NULL,
    `actor_identifier` VARCHAR(128) NOT NULL,
    `actor_name` VARCHAR(120) NOT NULL,
    `actor_job` VARCHAR(64) NOT NULL,
    `occurred_at` BIGINT UNSIGNED NOT NULL,
    `payload` LONGTEXT NOT NULL,
    `fee` INT UNSIGNED NOT NULL DEFAULT 0,
    `billing_state` VARCHAR(24) NOT NULL DEFAULT 'not_required',
    `invoice_id` INT NULL,
    PRIMARY KEY (`operation_id`),
    INDEX `idx_registry_history_vehicle` (`vehicle_id`, `occurred_at`),
    INDEX `idx_registry_billing` (`billing_state`, `actor_job`)
) ENGINE=InnoDB;
