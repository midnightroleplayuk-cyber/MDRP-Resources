CREATE TABLE IF NOT EXISTS `sky_jobs_business_documents` (
    `id` BIGINT UNSIGNED NOT NULL AUTO_INCREMENT,
    `job` VARCHAR(64) NOT NULL,
    `template_key` VARCHAR(64) NOT NULL,
    `title` VARCHAR(120) NOT NULL,
    `payload` LONGTEXT NOT NULL,
    `author_name` VARCHAR(120) NOT NULL,
    `author_identifier` VARCHAR(128) NOT NULL,
    `request_key` VARCHAR(64) NOT NULL,
    `revision` INT UNSIGNED NOT NULL DEFAULT 1,
    `created_at` TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    PRIMARY KEY (`id`),
    UNIQUE KEY `uq_job_document_request` (`job`, `author_identifier`, `request_key`),
    KEY `idx_job_document_list` (`job`, `template_key`, `id`)
) ENGINE=InnoDB;

CREATE TABLE IF NOT EXISTS `sky_jobs_service_card_settings` (
    `job` VARCHAR(64) NOT NULL,
    `settings_json` TEXT NULL,
    `revision` INT UNSIGNED NOT NULL DEFAULT 0,
    `next_number` BIGINT UNSIGNED NOT NULL DEFAULT 0,
    PRIMARY KEY (`job`)
) ENGINE=InnoDB;

CREATE TABLE IF NOT EXISTS `sky_jobs_service_numbers` (
    `id` BIGINT UNSIGNED NOT NULL AUTO_INCREMENT,
    `job` VARCHAR(64) NOT NULL,
    `identifier` VARCHAR(128) NOT NULL,
    `service_number` BIGINT UNSIGNED NOT NULL,
    PRIMARY KEY (`id`),
    UNIQUE KEY `uq_service_character` (`job`, `identifier`),
    UNIQUE KEY `uq_service_number` (`job`, `service_number`)
) ENGINE=InnoDB;

CREATE TABLE IF NOT EXISTS `sky_job_confiscations` (
    `id` INT NOT NULL AUTO_INCREMENT,
    `job_name` VARCHAR(64) NOT NULL,
    `officer_identifier` VARCHAR(80) NOT NULL,
    `officer_name` VARCHAR(120) NOT NULL,
    `citizen_identifier` VARCHAR(80) NOT NULL,
    `citizen_name` VARCHAR(120) NOT NULL,
    `item_name` VARCHAR(100) NOT NULL,
    `item_label` VARCHAR(120) NOT NULL,
    `amount` INT NOT NULL,
    `is_weapon` TINYINT(1) NOT NULL DEFAULT 0,
    `metadata` LONGTEXT NULL,
    `created_at` DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
    PRIMARY KEY (`id`),
    INDEX `idx_confiscations_job` (`job_name`, `id`)
);

CREATE TABLE
    IF NOT EXISTS `sky_jobs_locations` (
        `id` INT NOT NULL AUTO_INCREMENT,
        `creator_key` VARCHAR(64) NOT NULL,
        `entry_id` VARCHAR(64) NOT NULL,
        `name` VARCHAR(80) NOT NULL,
        `job_key` VARCHAR(64) NULL,
        `data` LONGTEXT NULL,
        `created_at` DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
        PRIMARY KEY (`id`),
        UNIQUE KEY `uniq_entry_id` (`entry_id`),
        INDEX `idx_creator_key` (`creator_key`),
        INDEX `idx_job_key` (`job_key`)
    );

CREATE TABLE
    IF NOT EXISTS `sky_jobs_creator_job_blips` (
        `id` INT NOT NULL AUTO_INCREMENT,
        `config_id` VARCHAR(160) NOT NULL,
        `creator_key` VARCHAR(64) NOT NULL,
        `job_key` VARCHAR(64) NOT NULL,
        `data` LONGTEXT NULL,
        `created_at` DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
        PRIMARY KEY (`id`),
        UNIQUE KEY `uniq_config_id` (`config_id`),
        UNIQUE KEY `uniq_creator_job` (`creator_key`, `job_key`),
        INDEX `idx_creator_key` (`creator_key`),
        INDEX `idx_job_key` (`job_key`)
    );

CREATE TABLE
    IF NOT EXISTS `sky_jobs_wardrobes` (
        `id` INT NOT NULL AUTO_INCREMENT,
        `job` VARCHAR(50) NOT NULL,
        `name` VARCHAR(60) NOT NULL,
        `components` LONGTEXT NOT NULL DEFAULT '{}',
        `allowed_grades` LONGTEXT NULL,
        PRIMARY KEY (`id`),
        UNIQUE KEY `uniq_job_name` (`job`, `name`)
    );

ALTER TABLE `sky_jobs_wardrobes` ADD COLUMN IF NOT EXISTS `allowed_grades` LONGTEXT NULL;

CREATE TABLE
    IF NOT EXISTS `sky_jobs_vehicles` (
        `id` INT NOT NULL AUTO_INCREMENT,
        `job` VARCHAR(50) NOT NULL,
        `station_id` VARCHAR(100) NOT NULL,
        `catalog_id` VARCHAR(100) NULL,
        `model` VARCHAR(60) NOT NULL,
        `plate` VARCHAR(12) NOT NULL,
        `name` VARCHAR(60) NOT NULL,
        `vehicle_type` VARCHAR(16) NOT NULL DEFAULT 'vehicle',
        `trunk_capacity` INT NOT NULL DEFAULT 0,
        `purchase_price` INT NOT NULL DEFAULT 0,
        `ownership_mode` VARCHAR(24) NOT NULL DEFAULT 'shared',
        `owner_identifier` VARCHAR(64) NULL,
        `payment_source` VARCHAR(16) NOT NULL DEFAULT 'job',
        `state` ENUM('stored', 'parked', 'impounded') NOT NULL DEFAULT 'stored',
        `last_driver` VARCHAR(64) NULL,
        `key_holder_identifier` VARCHAR(64) NULL,
        `repair_required` TINYINT(1) NOT NULL DEFAULT 0,
        `vehicle_mods` LONGTEXT NULL,
        `fuel` FLOAT NOT NULL DEFAULT 100.0,
        `fuel_type` VARCHAR(16) NOT NULL DEFAULT 'regular',
        `impound_reason` VARCHAR(255) NULL,
        `impound_fee` INT NOT NULL DEFAULT 0,
        `impounded_at` DATETIME NULL,
        `impounded_by` VARCHAR(120) NULL,
        `impounded_by_identifier` VARCHAR(64) NULL,
        `impound_authority_job` VARCHAR(64) NULL,
        `created_at` DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
        PRIMARY KEY (`id`),
        UNIQUE KEY `uniq_plate` (`plate`),
        INDEX `idx_job` (`job`),
        INDEX `idx_job_owner` (`job`, `owner_identifier`),
        INDEX `idx_job_state` (`job`, `state`)
    );

ALTER TABLE `sky_jobs_vehicles` ADD COLUMN IF NOT EXISTS `fuel` FLOAT NOT NULL DEFAULT 100.0;
ALTER TABLE `sky_jobs_vehicles` ADD COLUMN IF NOT EXISTS `fuel_type` VARCHAR(16) NOT NULL DEFAULT 'regular';
ALTER TABLE `sky_jobs_vehicles` ADD COLUMN IF NOT EXISTS `catalog_id` VARCHAR(100) NULL;
ALTER TABLE `sky_jobs_vehicles` ADD COLUMN IF NOT EXISTS `purchase_price` INT NOT NULL DEFAULT 0;
ALTER TABLE `sky_jobs_vehicles` ADD COLUMN IF NOT EXISTS `ownership_mode` VARCHAR(24) NOT NULL DEFAULT 'shared';
ALTER TABLE `sky_jobs_vehicles` ADD COLUMN IF NOT EXISTS `owner_identifier` VARCHAR(64) NULL;
ALTER TABLE `sky_jobs_vehicles` ADD COLUMN IF NOT EXISTS `payment_source` VARCHAR(16) NOT NULL DEFAULT 'job';
ALTER TABLE `sky_jobs_vehicles` ADD COLUMN IF NOT EXISTS `key_holder_identifier` VARCHAR(64) NULL;
ALTER TABLE `sky_jobs_vehicles` ADD COLUMN IF NOT EXISTS `repair_required` TINYINT(1) NOT NULL DEFAULT 0;
ALTER TABLE `sky_jobs_vehicles` ADD COLUMN IF NOT EXISTS `impound_reason` VARCHAR(255) NULL;
ALTER TABLE `sky_jobs_vehicles` ADD COLUMN IF NOT EXISTS `impound_fee` INT NOT NULL DEFAULT 0;
ALTER TABLE `sky_jobs_vehicles` ADD COLUMN IF NOT EXISTS `impounded_at` DATETIME NULL;
ALTER TABLE `sky_jobs_vehicles` ADD COLUMN IF NOT EXISTS `impounded_by` VARCHAR(120) NULL;
ALTER TABLE `sky_jobs_vehicles` ADD COLUMN IF NOT EXISTS `impounded_by_identifier` VARCHAR(64) NULL;
ALTER TABLE `sky_jobs_vehicles` ADD COLUMN IF NOT EXISTS `impound_authority_job` VARCHAR(64) NULL;
ALTER TABLE `sky_jobs_vehicles` MODIFY COLUMN `state` ENUM('stored', 'parked', 'impounded') NOT NULL DEFAULT 'stored';
ALTER TABLE `sky_jobs_vehicles` ADD INDEX IF NOT EXISTS `idx_job_owner` (`job`, `owner_identifier`);
ALTER TABLE `sky_jobs_vehicles` ADD INDEX IF NOT EXISTS `idx_job_state` (`job`, `state`);

CREATE TABLE
    IF NOT EXISTS `sky_jobs_vehicle_trunks` (
        `id` INT NOT NULL AUTO_INCREMENT,
        `plate` VARCHAR(16) NOT NULL,
        `name` VARCHAR(100) NOT NULL,
        `label` VARCHAR(120) NULL,
        `amount` INT NOT NULL,
        `metadata` LONGTEXT NULL,
        `metadata_key` VARCHAR(32) NOT NULL DEFAULT '__nil__',
        PRIMARY KEY (`id`),
        UNIQUE KEY `uniq_plate_item_metadata` (`plate`, `name`, `metadata_key`)
    );

ALTER TABLE `sky_jobs_vehicle_trunks` ADD COLUMN IF NOT EXISTS `metadata` LONGTEXT NULL;
ALTER TABLE `sky_jobs_vehicle_trunks` ADD COLUMN IF NOT EXISTS `metadata_key` VARCHAR(32) NOT NULL DEFAULT '__nil__';

CREATE TABLE
    IF NOT EXISTS `sky_jobs_wholesale_orders` (
        `id` VARCHAR(32) NOT NULL,
        `station_id` VARCHAR(100) NOT NULL,
        `job` VARCHAR(64) NOT NULL,
        `items` LONGTEXT NOT NULL,
        `total_price` DOUBLE NOT NULL DEFAULT 0,
        `status` VARCHAR(16) NOT NULL DEFAULT 'pending',
        `created_by_source` INT NOT NULL,
        `created_by_identifier` VARCHAR(100) NOT NULL,
        `created_by_name` VARCHAR(120) NOT NULL,
        `civilian_name` VARCHAR(120) NOT NULL DEFAULT '',
        `civilian_phone` VARCHAR(40) NOT NULL DEFAULT '',
        `rejection_reason` VARCHAR(255) NOT NULL DEFAULT '',
        `created_at` BIGINT NOT NULL,
        `updated_at` BIGINT NOT NULL,
        PRIMARY KEY (`id`),
        INDEX `idx_wholesale_job_status` (`job`, `status`, `created_at`),
        INDEX `idx_wholesale_status` (`status`, `created_at`)
    );

CREATE TABLE
    IF NOT EXISTS `sky_jobs_storageitems` (
        `name` TEXT NOT NULL,
        `amount` INT NOT NULL,
        `metadata` LONGTEXT NULL,
        `metadata_key` VARCHAR(32) NOT NULL DEFAULT '__nil__',
        `station_id` VARCHAR(100) NOT NULL,
        UNIQUE KEY `uniq_station_item_metadata` (`station_id`, `name`(100), `metadata_key`)
    );

CREATE TABLE
    IF NOT EXISTS `sky_jobs_lockeritems` (
        `name` TEXT NOT NULL,
        `amount` INT NOT NULL,
        `metadata` LONGTEXT NULL,
        `metadata_key` VARCHAR(32) NOT NULL DEFAULT '__nil__',
        `station_id` VARCHAR(100) NOT NULL,
        `player_identifier` VARCHAR(64) NOT NULL,
        UNIQUE KEY `uniq_station_player_item_metadata` (`station_id`, `player_identifier`, `name`(100), `metadata_key`)
    );

CREATE TABLE
    IF NOT EXISTS `sky_jobs_members` (
        `id` INT NOT NULL AUTO_INCREMENT,
        `job` VARCHAR(50) NOT NULL,
        `license` VARCHAR(64) NOT NULL,
        `last_online_timestamp` BIGINT NOT NULL DEFAULT 0,
        `actions_done` INT NOT NULL DEFAULT 0,
        `total_work_time_seconds` BIGINT NOT NULL DEFAULT 0,
        `last_salary_payout_seconds` BIGINT NOT NULL DEFAULT 0,
        `image_url` TEXT NULL,
        PRIMARY KEY (`id`),
        UNIQUE KEY `uniq_job_license` (`job`, `license`),
        INDEX `idx_job` (`job`)
    );

CREATE TABLE
    IF NOT EXISTS `sky_jobs_multijobs` (
        `id` INT NOT NULL AUTO_INCREMENT,
        `identifier` VARCHAR(64) NOT NULL,
        `job` VARCHAR(64) NOT NULL,
        `grade` INT NOT NULL DEFAULT 0,
        `job_label` VARCHAR(120) NULL,
        `grade_name` VARCHAR(80) NULL,
        `grade_label` VARCHAR(120) NULL,
        `added_by` LONGTEXT NULL,
        `last_used_at` DATETIME NULL,
        `created_at` DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
        `updated_at` DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
        PRIMARY KEY (`id`),
        UNIQUE KEY `uniq_identifier_job` (`identifier`, `job`),
        INDEX `idx_identifier` (`identifier`),
        INDEX `idx_job` (`job`)
    );

ALTER TABLE `sky_jobs_multijobs` ADD COLUMN IF NOT EXISTS `job_label` VARCHAR(120) NULL;
ALTER TABLE `sky_jobs_multijobs` ADD COLUMN IF NOT EXISTS `grade_name` VARCHAR(80) NULL;
ALTER TABLE `sky_jobs_multijobs` ADD COLUMN IF NOT EXISTS `grade_label` VARCHAR(120) NULL;

CREATE TABLE
    IF NOT EXISTS `sky_jobs_organization_memberships` (
        `id` INT NOT NULL AUTO_INCREMENT,
        `group_key` VARCHAR(64) NOT NULL,
        `identifier` VARCHAR(64) NOT NULL,
        `organization` VARCHAR(64) NOT NULL,
        `grade` INT NOT NULL DEFAULT 0,
        `added_by` VARCHAR(64) NULL,
        `created_at` DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
        `updated_at` DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
        PRIMARY KEY (`id`),
        UNIQUE KEY `uniq_group_identifier` (`group_key`, `identifier`),
        INDEX `idx_organization_membership` (`organization`)
    );

CREATE TABLE IF NOT EXISTS `sky_jobs_organization_roles` (
    `organization` VARCHAR(64) NOT NULL,
    `grades` LONGTEXT NOT NULL,
    PRIMARY KEY (`organization`)
) ENGINE=InnoDB;

CREATE TABLE
    IF NOT EXISTS `sky_jobs_organization_membership_modes` (
        `group_key` VARCHAR(64) NOT NULL,
        `mode` VARCHAR(24) NOT NULL DEFAULT 'framework',
        `updated_at` DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
        PRIMARY KEY (`group_key`)
    );

CREATE TABLE
    IF NOT EXISTS `sky_jobs_permissions` (
        `id` INT NOT NULL AUTO_INCREMENT,
        `job` VARCHAR(50) NOT NULL,
        `grade` INT NOT NULL,
        `permissions` LONGTEXT NOT NULL DEFAULT '{}',
        `payout_interval_minutes` INT NOT NULL DEFAULT 30,
        `salary_amount` INT NOT NULL DEFAULT 0,
        PRIMARY KEY (`id`),
        UNIQUE KEY `uniq_job_grade` (`job`, `grade`),
        INDEX `idx_job` (`job`)
    );

CREATE TABLE
    IF NOT EXISTS `sky_jobs_organization_units` (
        `id` INT NOT NULL AUTO_INCREMENT,
        `job` VARCHAR(64) NOT NULL,
        `unit_key` VARCHAR(48) NOT NULL,
        `name` VARCHAR(80) NOT NULL,
        `color` VARCHAR(9) NOT NULL DEFAULT '#64748b',
        `description` TEXT NULL,
        `is_default` TINYINT(1) NOT NULL DEFAULT 0,
        `permissions` LONGTEXT NOT NULL DEFAULT '[]',
        `vehicles` LONGTEXT NOT NULL DEFAULT '[]',
        `created_at` DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
        `updated_at` DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
        PRIMARY KEY (`id`),
        UNIQUE KEY `uniq_organization_unit` (`job`, `unit_key`),
        INDEX `idx_organization_units_job` (`job`)
    );

CREATE TABLE
    IF NOT EXISTS `sky_jobs_organization_unit_members` (
        `id` INT NOT NULL AUTO_INCREMENT,
        `unit_id` INT NOT NULL,
        `member_identifier` VARCHAR(80) NOT NULL,
        `assigned_by_identifier` VARCHAR(80) NOT NULL,
        `assigned_at` DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
        PRIMARY KEY (`id`),
        UNIQUE KEY `uniq_organization_unit_member` (`unit_id`, `member_identifier`),
        INDEX `idx_organization_unit_member_identifier` (`member_identifier`),
        CONSTRAINT `fk_organization_unit_member_unit`
            FOREIGN KEY (`unit_id`) REFERENCES `sky_jobs_organization_units` (`id`) ON DELETE CASCADE
    );

CREATE TABLE
    IF NOT EXISTS `sky_jobs_item_grade_restrictions` (
        `id` INT NOT NULL AUTO_INCREMENT,
        `job` VARCHAR(50) NOT NULL,
        `grade` INT NOT NULL,
        `item` VARCHAR(64) NOT NULL,
        PRIMARY KEY (`id`),
        UNIQUE KEY `uniq_job_grade_item` (`job`, `grade`, `item`),
        INDEX `idx_job` (`job`)
    );

CREATE TABLE
    IF NOT EXISTS `sky_jobs_weapon_grade_restrictions` (
        `id` INT NOT NULL AUTO_INCREMENT,
        `job` VARCHAR(50) NOT NULL,
        `grade` INT NOT NULL,
        `weapon` VARCHAR(64) NOT NULL,
        PRIMARY KEY (`id`),
        UNIQUE KEY `uniq_job_grade_weapon` (`job`, `grade`, `weapon`),
        INDEX `idx_job` (`job`)
    );

CREATE TABLE
    IF NOT EXISTS `sky_jobs_vehicle_grade_restrictions` (
        `id` INT NOT NULL AUTO_INCREMENT,
        `job` VARCHAR(50) NOT NULL,
        `grade` INT NOT NULL,
        `model` VARCHAR(64) NOT NULL,
        PRIMARY KEY (`id`),
        UNIQUE KEY `uniq_job_grade_model` (`job`, `grade`, `model`),
        INDEX `idx_job` (`job`)
    );

CREATE TABLE
    IF NOT EXISTS `sky_jobs_logs` (
        `id` INT NOT NULL AUTO_INCREMENT,
        `job` VARCHAR(50) NOT NULL,
        `timestamp` DATETIME NOT NULL,
        `name` VARCHAR(64) NOT NULL,
        `action` VARCHAR(64) NOT NULL,
        `content` TEXT NULL,
        `ledger` VARCHAR(24) NULL,
        `currency` VARCHAR(64) NULL,
        `amount` INT NULL,
        `payment_reference` VARBINARY(128) NULL,
        PRIMARY KEY (`id`),
        UNIQUE KEY `uniq_job_payment` (`job`, `payment_reference`),
        INDEX `idx_job` (`job`),
        INDEX `idx_timestamp` (`timestamp`)
    );

ALTER TABLE `sky_jobs_logs`
    ADD COLUMN IF NOT EXISTS `ledger` VARCHAR(24) NULL AFTER `content`,
    ADD COLUMN IF NOT EXISTS `currency` VARCHAR(64) NULL AFTER `ledger`,
    ADD COLUMN IF NOT EXISTS `amount` INT NULL AFTER `currency`,
    ADD COLUMN IF NOT EXISTS `payment_reference` VARBINARY(128) NULL AFTER `amount`,
    ADD UNIQUE INDEX IF NOT EXISTS `uniq_job_payment` (`job`, `payment_reference`);

CREATE TABLE
    IF NOT EXISTS `sky_jobs_finance_balances` (
        `id` INT NOT NULL AUTO_INCREMENT,
        `job` VARCHAR(50) NOT NULL,
        `ledger` VARCHAR(24) NOT NULL,
        `balance` BIGINT NOT NULL DEFAULT 0,
        `updated_at` DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
        PRIMARY KEY (`id`),
        UNIQUE KEY `uniq_job_ledger` (`job`, `ledger`)
    ) ENGINE=InnoDB;

CREATE TABLE
    IF NOT EXISTS `sky_jobs_billing_specs` (
        `id` INT NOT NULL AUTO_INCREMENT,
        `job` VARCHAR(50) NOT NULL,
        `reason` VARCHAR(120) NOT NULL,
        `label` VARCHAR(160) NULL,
        `amount` INT NOT NULL DEFAULT 0,
        `sort_order` INT NOT NULL DEFAULT 0,
        PRIMARY KEY (`id`),
        INDEX `idx_job` (`job`)
    );

CREATE TABLE
    IF NOT EXISTS `sky_jobs_tablet_app_restrictions` (
        `id` INT NOT NULL AUTO_INCREMENT,
        `job` VARCHAR(50) NOT NULL,
        `grade` INT NOT NULL,
        `app` VARCHAR(32) NOT NULL,
        PRIMARY KEY (`id`),
        UNIQUE KEY `uniq_job_grade_app` (`job`, `grade`, `app`),
        INDEX `idx_job` (`job`)
    );

CREATE TABLE
    IF NOT EXISTS `sky_jobs_document_classification_restrictions` (
        `id` INT NOT NULL AUTO_INCREMENT,
        `job` VARCHAR(50) NOT NULL,
        `grade` INT NOT NULL,
        `classification` VARCHAR(32) NOT NULL,
        PRIMARY KEY (`id`),
        UNIQUE KEY `uniq_job_grade_classification` (`job`, `grade`, `classification`),
        INDEX `idx_job` (`job`)
    );

CREATE TABLE
    IF NOT EXISTS `sky_jobs_calendar_events` (
        `id` INT NOT NULL AUTO_INCREMENT,
        `job` VARCHAR(50) NOT NULL,
        `event_timestamp` DATETIME NOT NULL,
        `event_end_timestamp` DATETIME NULL,
        `title` VARCHAR(120) NOT NULL,
        `color` VARCHAR(12) NULL,
        `location_key` VARCHAR(64) NULL,
        `source_type` VARCHAR(32) NULL,
        `source_id` VARCHAR(64) NULL,
        `public_visibility` TINYINT(1) NOT NULL DEFAULT 0,
        `created_by` LONGTEXT NULL,
        `created_at` DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
        PRIMARY KEY (`id`),
        INDEX `idx_calendar_job_date` (`job`, `event_timestamp`),
        INDEX `idx_calendar_location_range` (`job`, `location_key`, `event_timestamp`, `event_end_timestamp`),
        INDEX `idx_calendar_source` (`source_type`, `source_id`)
    );

CREATE TABLE IF NOT EXISTS `sky_jobs_tablet_notices` (
    `id` BIGINT UNSIGNED NOT NULL AUTO_INCREMENT,
    `character_identifier` VARCHAR(128) NOT NULL,
    `notice_key` VARCHAR(64) NOT NULL,
    `acknowledged_at` DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
    PRIMARY KEY (`id`),
    UNIQUE KEY `uniq_character_notice` (`character_identifier`, `notice_key`)
) ENGINE=InnoDB;

CREATE TABLE
    IF NOT EXISTS `sky_jobs_personal_notes` (
        `id` BIGINT NOT NULL AUTO_INCREMENT,
        `character_identifier` VARCHAR(64) NOT NULL,
        `job_name` VARCHAR(64) NULL,
        `title` VARCHAR(120) NOT NULL,
        `content` LONGTEXT NOT NULL,
        `is_pinned` TINYINT(1) NOT NULL DEFAULT 0,
        `created_at` DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
        `updated_at` DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
        PRIMARY KEY (`id`),
        INDEX `idx_personal_notes_owner_job_sort` (`character_identifier`, `job_name`, `is_pinned`, `updated_at`, `id`)
    );

CREATE TABLE
    IF NOT EXISTS `sky_jobs_drug_test_records` (
        `id` BIGINT NOT NULL AUTO_INCREMENT,
        `record_uid` VARCHAR(40) NOT NULL,
        `owner_group` VARCHAR(32) NOT NULL,
        `created_by_identifier` VARCHAR(64) NOT NULL,
        `subject_name` VARCHAR(120) NULL,
        `test_mode` VARCHAR(16) NOT NULL,
        `positive` TINYINT(1) NOT NULL DEFAULT 0,
        `drug_details` LONGTEXT NOT NULL DEFAULT '[]',
        `shared_groups` LONGTEXT NOT NULL DEFAULT '[]',
        `created_at` DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
        `updated_at` DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
        PRIMARY KEY (`id`),
        UNIQUE KEY `uniq_drug_test_record_uid` (`record_uid`),
        INDEX `idx_drug_test_owner_created` (`owner_group`, `created_at`, `id`),
        INDEX `idx_drug_test_creator` (`created_by_identifier`, `created_at`)
    );

-- Legacy notes remain unassigned until their original job is explicitly identified.
ALTER TABLE `sky_jobs_personal_notes`
    ADD COLUMN IF NOT EXISTS `job_name` VARCHAR(64) NULL AFTER `character_identifier`,
    ADD INDEX IF NOT EXISTS `idx_personal_notes_owner_job_sort` (`character_identifier`, `job_name`, `is_pinned`, `updated_at`, `id`);

ALTER TABLE `sky_jobs_calendar_events`
    ADD COLUMN IF NOT EXISTS `event_end_timestamp` DATETIME NULL AFTER `event_timestamp`,
    ADD COLUMN IF NOT EXISTS `location_key` VARCHAR(64) NULL AFTER `color`,
    ADD COLUMN IF NOT EXISTS `source_type` VARCHAR(32) NULL AFTER `location_key`,
    ADD COLUMN IF NOT EXISTS `source_id` VARCHAR(64) NULL AFTER `source_type`,
    ADD COLUMN IF NOT EXISTS `public_visibility` TINYINT(1) NOT NULL DEFAULT 0 AFTER `source_id`;

ALTER TABLE `sky_jobs_calendar_events`
    ADD INDEX IF NOT EXISTS `idx_calendar_location_range` (`job`, `location_key`, `event_timestamp`, `event_end_timestamp`),
    ADD INDEX IF NOT EXISTS `idx_calendar_source` (`source_type`, `source_id`);

CREATE TABLE
    IF NOT EXISTS `sky_jobs_chat_messages` (
        `id` INT NOT NULL AUTO_INCREMENT,
        `network` VARCHAR(16) NOT NULL DEFAULT 'normal',
        `job` VARCHAR(50) NOT NULL,
        `scope` VARCHAR(16) NULL,
        `group_id` INT NULL,
        `sender_identifier` VARCHAR(64) NULL,
        `recipient_identifier` VARCHAR(64) NULL,
        `author` LONGTEXT NULL,
        `event_type` VARCHAR(32) NULL,
        `target_identifier` VARCHAR(64) NULL,
        `message` TEXT NULL,
        `image_url` TEXT NULL,
        `is_read` TINYINT(1) NOT NULL DEFAULT 0,
        `read_at` DATETIME NULL,
        `created_at` DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
        PRIMARY KEY (`id`),
        INDEX `idx_job` (`job`),
        INDEX `idx_chat_network` (`network`),
        INDEX `idx_group` (`group_id`),
        INDEX `idx_private_unread` (`scope`, `recipient_identifier`, `is_read`)
    );

ALTER TABLE `sky_jobs_chat_messages`
    ADD COLUMN IF NOT EXISTS `network` VARCHAR(16) NOT NULL DEFAULT 'normal',
    ADD COLUMN IF NOT EXISTS `event_type` VARCHAR(32) NULL,
    ADD COLUMN IF NOT EXISTS `target_identifier` VARCHAR(64) NULL;

ALTER TABLE `sky_jobs_chat_messages`
    ADD INDEX IF NOT EXISTS `idx_chat_network` (`network`);

CREATE TABLE
    IF NOT EXISTS `sky_jobs_chat_groups` (
        `id` INT NOT NULL AUTO_INCREMENT,
        `network` VARCHAR(16) NOT NULL DEFAULT 'normal',
        `name` VARCHAR(80) NOT NULL,
        `image_url` TEXT NULL,
        `created_by` LONGTEXT NULL,
        `created_at` DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
        PRIMARY KEY (`id`),
        INDEX `idx_chat_group_network` (`network`)
    );

ALTER TABLE `sky_jobs_chat_groups`
    ADD COLUMN IF NOT EXISTS `network` VARCHAR(16) NOT NULL DEFAULT 'normal';

ALTER TABLE `sky_jobs_chat_groups`
    ADD INDEX IF NOT EXISTS `idx_chat_group_network` (`network`);

CREATE TABLE
    IF NOT EXISTS `sky_jobs_dark_chat_accounts` (
        `id` INT NOT NULL AUTO_INCREMENT,
        `character_identifier` VARCHAR(64) NOT NULL,
        `username` VARCHAR(24) NOT NULL,
        `normalized_username` VARCHAR(24) NOT NULL,
        `image_url` TEXT NULL,
        `created_at` DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
        `updated_at` DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
        PRIMARY KEY (`id`),
        UNIQUE KEY `uniq_dark_character` (`character_identifier`),
        UNIQUE KEY `uniq_dark_username` (`normalized_username`)
    );

CREATE TABLE
    IF NOT EXISTS `sky_jobs_chat_group_members` (
        `id` INT NOT NULL AUTO_INCREMENT,
        `group_id` INT NOT NULL,
        `member_identifier` VARCHAR(64) NOT NULL,
        `is_admin` TINYINT(1) NOT NULL DEFAULT 0,
        PRIMARY KEY (`id`),
        UNIQUE KEY `uniq_group_member` (`group_id`, `member_identifier`),
        INDEX `idx_group` (`group_id`),
        INDEX `idx_member` (`member_identifier`),
        INDEX `idx_group_admin` (`group_id`, `is_admin`)
    );

CREATE TABLE
    IF NOT EXISTS `sky_jobs_gallery` (
        `id` INT NOT NULL AUTO_INCREMENT,
        `job` VARCHAR(50) NOT NULL,
        `url` TEXT NOT NULL,
        `image_id` VARCHAR(64) NULL,
        `taken_by` LONGTEXT NULL,
        `folder` VARCHAR(32) NOT NULL DEFAULT 'camera',
        `is_deleted` TINYINT(1) NOT NULL DEFAULT 0,
        `created_at` DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
        PRIMARY KEY (`id`),
        INDEX `idx_job` (`job`)
    );

CREATE TABLE
    IF NOT EXISTS `sky_jobs_cctvcams` (
        `id` INT NOT NULL AUTO_INCREMENT,
        `job` VARCHAR(50) NOT NULL,
        `name` VARCHAR(64) NOT NULL,
        `x` FLOAT NOT NULL,
        `y` FLOAT NOT NULL,
        `z` FLOAT NOT NULL,
        `heading` FLOAT NOT NULL DEFAULT 0,
        `pitch` FLOAT NOT NULL DEFAULT 0,
        `durability` INT NOT NULL DEFAULT 100,
        `created_by` LONGTEXT NULL,
        `created_at` DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
        PRIMARY KEY (`id`),
        INDEX `idx_job` (`job`)
    );

CREATE TABLE
    IF NOT EXISTS `sky_jobs_public_forms` (
        `id` INT NOT NULL AUTO_INCREMENT,
        `job` VARCHAR(50) NOT NULL,
        `station_id` VARCHAR(100) NULL,
        `form_id` VARCHAR(32) NOT NULL,
        `form_type` VARCHAR(24) NOT NULL,
        `citizen_identifier` LONGTEXT NULL,
        `citizen_name` VARCHAR(120) NULL,
        `contact_phone` VARCHAR(40) NULL,
        `contact_email` VARCHAR(120) NULL,
        `status` VARCHAR(24) NOT NULL DEFAULT 'new',
        `payload` LONGTEXT NULL,
        `created_at` DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
        `updated_at` DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
        PRIMARY KEY (`id`),
        UNIQUE KEY `uniq_job_form` (`job`, `form_id`),
        INDEX `idx_job_form_type` (`job`, `form_type`),
        INDEX `idx_job_form_status` (`job`, `status`),
        INDEX `idx_job_form_page` (`job`, `status`, `created_at`, `id`),
        INDEX `idx_job_form_station` (`job`, `station_id`)
    );

ALTER TABLE `sky_jobs_public_forms`
    ADD INDEX IF NOT EXISTS `idx_job_form_page` (`job`, `status`, `created_at`, `id`);

CREATE TABLE
    IF NOT EXISTS `sky_jobs_public_form_notes` (
        `id` INT NOT NULL AUTO_INCREMENT,
        `job` VARCHAR(50) NOT NULL,
        `form_id` VARCHAR(32) NOT NULL,
        `author_name` VARCHAR(120) NOT NULL,
        `author_identifier` LONGTEXT NOT NULL,
        `content` TEXT NOT NULL,
        `visible_to_citizen` TINYINT(1) NOT NULL DEFAULT 0,
        `created_at` DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
        PRIMARY KEY (`id`),
        INDEX `idx_form` (`job`, `form_id`)
    );

CREATE TABLE
    IF NOT EXISTS `sky_jobs_configurator_jobs` (
        `id` INT NOT NULL AUTO_INCREMENT,
        `config_key` VARCHAR(64) NOT NULL,
        `group_key` VARCHAR(64) NOT NULL,
        `job_name` VARCHAR(64) NOT NULL,
        `color` VARCHAR(16) NOT NULL DEFAULT '#6B6B6B',
        `off_duty_enabled` TINYINT(1) NOT NULL DEFAULT 0,
        `off_duty_job` VARCHAR(64) NULL,
        `shop` LONGTEXT NULL,
        `props` LONGTEXT NULL,
        `vehicles` LONGTEXT NULL,
        `payload` LONGTEXT NULL,
        `enabled` TINYINT(1) NOT NULL DEFAULT 1,
        `sort_order` INT NOT NULL DEFAULT 0,
        `created_at` DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
        `updated_at` DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
        PRIMARY KEY (`id`),
        UNIQUE KEY `uniq_configurator_config_job` (`config_key`, `job_name`),
        INDEX `idx_configurator_group` (`group_key`),
        INDEX `idx_configurator_enabled_order` (`config_key`, `enabled`, `sort_order`)
    );

CREATE TABLE
    IF NOT EXISTS `sky_jobs_placed_props` (
        `persistence_key` VARCHAR(96) NOT NULL,
        `owner_resource` VARCHAR(64) NULL,
        `payload` LONGTEXT NOT NULL,
        `created_at` DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
        `updated_at` DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
        PRIMARY KEY (`persistence_key`),
        INDEX `idx_placed_props_owner_resource` (`owner_resource`)
    );

CREATE TABLE
    IF NOT EXISTS `sky_jobs_configurator_settings` (
        `config_key` VARCHAR(64) NOT NULL,
        `features` LONGTEXT NULL,
        `settings` LONGTEXT NULL,
        `jobs_initialized` TINYINT(1) NOT NULL DEFAULT 0,
        `dispatch_defaults_migrated` TINYINT(1) NOT NULL DEFAULT 0,
        `registry_catalog_migrated` TINYINT(1) NOT NULL DEFAULT 0,
        `revision` BIGINT NOT NULL DEFAULT 0,
        `updated_at` DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
        PRIMARY KEY (`config_key`)
    ) ENGINE=InnoDB;

CREATE TABLE
    IF NOT EXISTS `sky_jobs_configurator_deleted_jobs` (
        `job_name` VARCHAR(64) NOT NULL,
        `deleted_at` DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
        PRIMARY KEY (`job_name`)
    );

CREATE TABLE
    IF NOT EXISTS `sky_jobs_configurator_history` (
        `id` BIGINT NOT NULL AUTO_INCREMENT,
        `config_key` VARCHAR(64) NOT NULL,
        `revision` BIGINT NOT NULL,
        `action` VARCHAR(64) NOT NULL,
        `scope` VARCHAR(64) NOT NULL DEFAULT 'config',
        `actor_identifier` VARCHAR(128) NULL,
        `actor_name` VARCHAR(120) NOT NULL,
        `diff` LONGTEXT NOT NULL,
        `snapshot` LONGTEXT NOT NULL,
        `metadata` LONGTEXT NULL,
        `created_at` DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
        PRIMARY KEY (`id`),
        UNIQUE KEY `uniq_configurator_history_revision` (`config_key`, `revision`),
        INDEX `idx_configurator_history_created` (`config_key`, `created_at`),
        INDEX `idx_configurator_history_action` (`config_key`, `action`)
    );

ALTER TABLE `sky_jobs_configurator_settings` ADD COLUMN IF NOT EXISTS `settings` LONGTEXT NULL;
ALTER TABLE `sky_jobs_configurator_settings` ADD COLUMN IF NOT EXISTS `jobs_initialized` TINYINT(1) NOT NULL DEFAULT 0;
ALTER TABLE `sky_jobs_configurator_settings` ADD COLUMN IF NOT EXISTS `dispatch_defaults_migrated` TINYINT(1) NOT NULL DEFAULT 0;
ALTER TABLE `sky_jobs_configurator_settings` ADD COLUMN IF NOT EXISTS `revision` BIGINT NOT NULL DEFAULT 0;

UPDATE `sky_jobs_configurator_settings`
SET `settings` = '{}'
WHERE TRIM(`settings`) = '[]';

CREATE TABLE IF NOT EXISTS `sky_jobs_dispatch_incidents` (
    `id` BIGINT NOT NULL AUTO_INCREMENT,
    `incident_number` VARCHAR(32) NOT NULL,
    `creation_token` VARCHAR(96) NULL,
    `reporter_name` VARCHAR(120) NULL,
    `reporter_phone` VARCHAR(40) NULL,
    `status` VARCHAR(24) NOT NULL DEFAULT 'active',
    `priority` TINYINT NOT NULL DEFAULT 3,
    `center_id` VARCHAR(64) NULL,
    `origin_center_id` VARCHAR(64) NULL,
    `forwarded_from_center_id` VARCHAR(64) NULL,
    `forwarded_centers` LONGTEXT NULL,
    `commander_unit_id` VARCHAR(160) NULL,
    `commander_callsign` VARCHAR(80) NULL,
    `call_id` BIGINT NULL,
    `source_key` VARCHAR(120) NULL,
    `source_id` VARCHAR(160) NULL,
    `origin_source_key` VARCHAR(120) NULL,
    `origin_source_id` VARCHAR(160) NULL,
    `close_requested` TINYINT(1) NOT NULL DEFAULT 0,
    `dispatcher` VARCHAR(64) NULL,
    `dispatcher_name` VARCHAR(120) NULL,
    `location` LONGTEXT NOT NULL,
    `destination` LONGTEXT NULL,
    `keyword_job` VARCHAR(80) NULL,
    `keyword_code` VARCHAR(64) NULL,
    `message` TEXT NOT NULL,
    `jobs` LONGTEXT NOT NULL,
    `silent` TINYINT(1) NOT NULL DEFAULT 0,
    `created_at` DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
    `closed_at` DATETIME NULL,
    PRIMARY KEY (`id`),
    UNIQUE KEY `uniq_dispatch_incident_number` (`incident_number`),
    UNIQUE KEY `uniq_dispatch_incident_creation` (`creation_token`),
    UNIQUE KEY `uniq_dispatch_incident_source` (`source_key`, `source_id`),
    UNIQUE KEY `uniq_dispatch_incident_call` (`call_id`),
    INDEX `idx_dispatch_incident_status` (`status`, `created_at`)
) ENGINE=InnoDB;

ALTER TABLE `sky_jobs_dispatch_incidents` ADD COLUMN IF NOT EXISTS `details` LONGTEXT NULL AFTER `message`;
ALTER TABLE `sky_jobs_dispatch_incidents` ADD COLUMN IF NOT EXISTS `creation_token` VARCHAR(96) NULL AFTER `incident_number`;
ALTER TABLE `sky_jobs_dispatch_incidents` ADD COLUMN IF NOT EXISTS `priority` TINYINT NOT NULL DEFAULT 3 AFTER `status`;
ALTER TABLE `sky_jobs_dispatch_incidents` ADD COLUMN IF NOT EXISTS `center_id` VARCHAR(64) NULL AFTER `priority`;
ALTER TABLE `sky_jobs_dispatch_incidents` ADD COLUMN IF NOT EXISTS `origin_center_id` VARCHAR(64) NULL AFTER `center_id`;
ALTER TABLE `sky_jobs_dispatch_incidents` ADD COLUMN IF NOT EXISTS `forwarded_from_center_id` VARCHAR(64) NULL AFTER `origin_center_id`;
ALTER TABLE `sky_jobs_dispatch_incidents` ADD COLUMN IF NOT EXISTS `forwarded_centers` LONGTEXT NULL AFTER `forwarded_from_center_id`;
ALTER TABLE `sky_jobs_dispatch_incidents` ADD COLUMN IF NOT EXISTS `commander_unit_id` VARCHAR(160) NULL AFTER `forwarded_centers`;
ALTER TABLE `sky_jobs_dispatch_incidents` ADD COLUMN IF NOT EXISTS `commander_callsign` VARCHAR(80) NULL AFTER `commander_unit_id`;
ALTER TABLE `sky_jobs_dispatch_incidents` ADD COLUMN IF NOT EXISTS `call_id` BIGINT NULL AFTER `center_id`;
ALTER TABLE `sky_jobs_dispatch_incidents` ADD COLUMN IF NOT EXISTS `source_key` VARCHAR(120) NULL AFTER `call_id`;
ALTER TABLE `sky_jobs_dispatch_incidents` ADD COLUMN IF NOT EXISTS `source_id` VARCHAR(160) NULL AFTER `source_key`;
ALTER TABLE `sky_jobs_dispatch_incidents` ADD COLUMN IF NOT EXISTS `origin_source_key` VARCHAR(120) NULL AFTER `source_id`;
ALTER TABLE `sky_jobs_dispatch_incidents` ADD COLUMN IF NOT EXISTS `origin_source_id` VARCHAR(160) NULL AFTER `origin_source_key`;
ALTER TABLE `sky_jobs_dispatch_incidents` ADD COLUMN IF NOT EXISTS `close_requested` TINYINT(1) NOT NULL DEFAULT 0 AFTER `origin_source_id`;
ALTER TABLE `sky_jobs_dispatch_incidents` ADD COLUMN IF NOT EXISTS `silent` TINYINT(1) NOT NULL DEFAULT 0 AFTER `jobs`;
ALTER TABLE `sky_jobs_dispatch_incidents` ADD COLUMN IF NOT EXISTS `keyword_job` VARCHAR(80) NULL AFTER `destination`;

SET @dispatch_incident_add_source = IF(
    EXISTS(SELECT 1 FROM INFORMATION_SCHEMA.STATISTICS
        WHERE TABLE_SCHEMA = DATABASE() AND TABLE_NAME = 'sky_jobs_dispatch_incidents'
            AND INDEX_NAME = 'uniq_dispatch_incident_source'),
    'SELECT 1',
    'ALTER TABLE `sky_jobs_dispatch_incidents` ADD UNIQUE KEY `uniq_dispatch_incident_source` (`source_key`, `source_id`)'
);
PREPARE dispatch_incident_add_source FROM @dispatch_incident_add_source;
EXECUTE dispatch_incident_add_source;
DEALLOCATE PREPARE dispatch_incident_add_source;

SET @dispatch_incident_add_creation = IF(
    EXISTS(SELECT 1 FROM INFORMATION_SCHEMA.STATISTICS
        WHERE TABLE_SCHEMA = DATABASE() AND TABLE_NAME = 'sky_jobs_dispatch_incidents'
            AND INDEX_NAME = 'uniq_dispatch_incident_creation'),
    'SELECT 1',
    'ALTER TABLE `sky_jobs_dispatch_incidents` ADD UNIQUE KEY `uniq_dispatch_incident_creation` (`creation_token`)'
);
PREPARE dispatch_incident_add_creation FROM @dispatch_incident_add_creation;
EXECUTE dispatch_incident_add_creation;
DEALLOCATE PREPARE dispatch_incident_add_creation;

CREATE TABLE IF NOT EXISTS `sky_jobs_dispatch_incident_log` (
    `id` BIGINT NOT NULL AUTO_INCREMENT,
    `incident_id` BIGINT NOT NULL,
    `type` VARCHAR(24) NOT NULL,
    `text` TEXT NOT NULL,
    `author` VARCHAR(120) NOT NULL,
    `created_at` DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
    PRIMARY KEY (`id`),
    INDEX `idx_dispatch_log_incident` (`incident_id`, `created_at`)
) ENGINE=InnoDB;

CREATE TABLE IF NOT EXISTS `sky_jobs_dispatch_incident_units` (
    `id` BIGINT NOT NULL AUTO_INCREMENT,
    `incident_id` BIGINT NOT NULL,
    `plate` VARCHAR(160) NOT NULL,
    `callsign` VARCHAR(80) NOT NULL,
    `assigned_at` DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
    `released_at` DATETIME NULL,
    PRIMARY KEY (`id`),
    INDEX `idx_dispatch_unit_incident` (`incident_id`, `released_at`),
    INDEX `idx_dispatch_unit_plate` (`plate`, `released_at`)
) ENGINE=InnoDB;

CREATE TABLE IF NOT EXISTS `sky_jobs_dispatch_unit_state` (
    `plate` VARCHAR(16) NOT NULL,
    `callsign` VARCHAR(80) NOT NULL,
    `job` VARCHAR(64) NOT NULL,
    `crew` LONGTEXT NOT NULL,
    `status_code` INT NOT NULL DEFAULT 1,
    `channel` VARCHAR(80) NULL,
    `updated_at` DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    PRIMARY KEY (`plate`),
    INDEX `idx_dispatch_unit_job` (`job`, `status_code`)
) ENGINE=InnoDB;

ALTER TABLE `sky_jobs_dispatch_incident_units` MODIFY COLUMN `plate` VARCHAR(160) NOT NULL;

CREATE TABLE IF NOT EXISTS `sky_jobs_dispatch_units` (
    `unit_id` VARCHAR(160) NOT NULL,
    `callsign` VARCHAR(80) NOT NULL,
    `job` VARCHAR(64) NOT NULL,
    `unit_type` VARCHAR(32) NOT NULL DEFAULT 'OTHER',
    `status_code` INT NULL,
    `channel` VARCHAR(80) NULL,
    `incident_id` BIGINT NULL,
    `pending_incident_id` BIGINT NULL,
    `station_id` VARCHAR(80) NULL,
    `crew_capacity` INT NULL,
    `join_locked` TINYINT(1) NOT NULL DEFAULT 0,
    `resource_type` VARCHAR(32) NOT NULL DEFAULT 'vehicle',
    `updated_at` DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    PRIMARY KEY (`unit_id`),
    INDEX `idx_dispatch_units_job_status` (`job`, `status_code`),
    INDEX `idx_dispatch_units_incident` (`incident_id`),
    INDEX `idx_dispatch_units_pending` (`pending_incident_id`)
) ENGINE=InnoDB;

CREATE TABLE IF NOT EXISTS `sky_jobs_dispatch_unit_members` (
    `unit_id` VARCHAR(160) NOT NULL,
    `player_identifier` VARCHAR(64) NOT NULL,
    `player_name` VARCHAR(120) NOT NULL,
    `joined_at` DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
    PRIMARY KEY (`player_identifier`),
    INDEX `idx_dispatch_unit_members_unit` (`unit_id`)
) ENGINE=InnoDB;

CREATE TABLE IF NOT EXISTS `sky_jobs_dispatch_unit_assignments` (
    `unit_id` VARCHAR(160) NOT NULL,
    `incident_id` BIGINT NOT NULL,
    `callsign` VARCHAR(80) NOT NULL,
    `state` VARCHAR(16) NOT NULL DEFAULT 'accepted',
    `assigned_at` DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
    PRIMARY KEY (`unit_id`),
    INDEX `idx_dispatch_active_assignment_incident` (`incident_id`)
) ENGINE=InnoDB;

ALTER TABLE `sky_jobs_dispatch_unit_assignments` ADD COLUMN IF NOT EXISTS `state` VARCHAR(16) NOT NULL DEFAULT 'accepted' AFTER `callsign`;

CREATE TABLE IF NOT EXISTS `sky_jobs_dispatch_alarm_attempts` (
    `id` BIGINT NOT NULL AUTO_INCREMENT,
    `incident_id` BIGINT NOT NULL,
    `unit_id` VARCHAR(160) NOT NULL,
    `center_id` VARCHAR(64) NULL,
    `delivery_token` VARCHAR(255) NULL,
    `status` VARCHAR(24) NOT NULL DEFAULT 'offered',
    `methods` LONGTEXT NOT NULL,
    `results` LONGTEXT NULL,
    `created_at` DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
    `updated_at` DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    PRIMARY KEY (`id`),
    UNIQUE KEY `uniq_dispatch_alarm_delivery_token` (`delivery_token`),
    INDEX `idx_dispatch_alarm_status` (`status`, `updated_at`)
) ENGINE=InnoDB;

ALTER TABLE `sky_jobs_dispatch_alarm_attempts` ADD COLUMN IF NOT EXISTS `delivery_token` VARCHAR(255) NULL AFTER `center_id`;
UPDATE `sky_jobs_dispatch_alarm_attempts`
SET `delivery_token` = CONCAT('LEGACY-', `id`)
WHERE `delivery_token` IS NULL OR `delivery_token` = '';

SET @dispatch_alarm_drop_old = IF(
    EXISTS(SELECT 1 FROM INFORMATION_SCHEMA.STATISTICS
        WHERE TABLE_SCHEMA = DATABASE() AND TABLE_NAME = 'sky_jobs_dispatch_alarm_attempts'
            AND INDEX_NAME = 'uniq_dispatch_alarm_incident_unit'),
    'ALTER TABLE `sky_jobs_dispatch_alarm_attempts` DROP INDEX `uniq_dispatch_alarm_incident_unit`',
    'SELECT 1'
);
PREPARE dispatch_alarm_drop_old FROM @dispatch_alarm_drop_old;
EXECUTE dispatch_alarm_drop_old;
DEALLOCATE PREPARE dispatch_alarm_drop_old;

SET @dispatch_alarm_add_token = IF(
    EXISTS(SELECT 1 FROM INFORMATION_SCHEMA.STATISTICS
        WHERE TABLE_SCHEMA = DATABASE() AND TABLE_NAME = 'sky_jobs_dispatch_alarm_attempts'
            AND INDEX_NAME = 'uniq_dispatch_alarm_delivery_token'),
    'SELECT 1',
    'ALTER TABLE `sky_jobs_dispatch_alarm_attempts` ADD UNIQUE KEY `uniq_dispatch_alarm_delivery_token` (`delivery_token`)'
);
PREPARE dispatch_alarm_add_token FROM @dispatch_alarm_add_token;
EXECUTE dispatch_alarm_add_token;
DEALLOCATE PREPARE dispatch_alarm_add_token;

CREATE TABLE IF NOT EXISTS `sky_jobs_dispatch_audit` (
    `id` BIGINT NOT NULL AUTO_INCREMENT,
    `center_id` VARCHAR(64) NULL,
    `job` VARCHAR(80) NULL,
    `action` VARCHAR(64) NOT NULL,
    `object_type` VARCHAR(32) NOT NULL,
    `object_id` VARCHAR(160) NULL,
    `author` VARCHAR(120) NOT NULL,
    `created_at` DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
    PRIMARY KEY (`id`),
    INDEX `idx_dispatch_audit_created` (`created_at`),
    INDEX `idx_dispatch_audit_object` (`object_type`, `object_id`)
) ENGINE=InnoDB;

ALTER TABLE `sky_jobs_dispatch_audit` ADD COLUMN IF NOT EXISTS `center_id` VARCHAR(64) NULL AFTER `id`;
ALTER TABLE `sky_jobs_dispatch_audit` ADD COLUMN IF NOT EXISTS `job` VARCHAR(80) NULL AFTER `center_id`;
ALTER TABLE `sky_jobs_dispatch_audit` MODIFY COLUMN `object_id` VARCHAR(160) NULL;

CREATE TABLE IF NOT EXISTS `sky_jobs_dispatch_map_features` (
    `id` BIGINT NOT NULL AUTO_INCREMENT,
    `feature_key` VARCHAR(96) NOT NULL,
    `center_id` VARCHAR(64) NOT NULL,
    `job` VARCHAR(80) NULL,
    `incident_id` BIGINT NULL,
    `feature_type` VARCHAR(32) NOT NULL,
    `label` VARCHAR(160) NULL,
    `color` VARCHAR(24) NULL,
    `geometry` LONGTEXT NOT NULL,
    `author` VARCHAR(120) NOT NULL,
    `author_identifier` VARCHAR(128) NOT NULL,
    `created_at` DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
    `updated_at` DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    PRIMARY KEY (`id`),
    UNIQUE KEY `uniq_dispatch_map_feature_key` (`feature_key`),
    INDEX `idx_dispatch_map_center` (`center_id`, `updated_at`),
    INDEX `idx_dispatch_map_incident` (`incident_id`, `updated_at`)
) ENGINE=InnoDB;

ALTER TABLE `sky_jobs_dispatch_map_features` ADD COLUMN IF NOT EXISTS `job` VARCHAR(80) NULL AFTER `center_id`;

CREATE TABLE IF NOT EXISTS `sky_jobs_dispatch_broadcasts` (
  `id` BIGINT NOT NULL AUTO_INCREMENT,
  `creation_token` VARCHAR(96) NULL,
    `center_id` VARCHAR(64) NOT NULL,
    `incident_id` BIGINT NULL,
    `broadcast_type` VARCHAR(32) NOT NULL,
    `message` TEXT NOT NULL,
    `jobs` LONGTEXT NOT NULL,
    `provider` VARCHAR(64) NULL,
    `author` VARCHAR(120) NOT NULL,
    `author_identifier` VARCHAR(64) NOT NULL,
  `created_at` DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  UNIQUE KEY `uniq_dispatch_broadcast_creation` (`creation_token`),
    INDEX `idx_dispatch_broadcast_center` (`center_id`, `created_at`),
    INDEX `idx_dispatch_broadcast_incident` (`incident_id`, `created_at`)
) ENGINE=InnoDB;

CREATE TABLE IF NOT EXISTS `sky_jobs_dispatch_sds` (
  `id` BIGINT NOT NULL AUTO_INCREMENT,
  `batch_token` VARCHAR(96) NOT NULL,
    `center_id` VARCHAR(64) NOT NULL,
    `incident_id` BIGINT NULL,
    `unit_id` VARCHAR(160) NOT NULL,
    `message` VARCHAR(1000) NOT NULL,
    `author` VARCHAR(120) NOT NULL,
    `author_identifier` VARCHAR(64) NOT NULL,
  `created_at` DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  UNIQUE KEY `uniq_dispatch_sds_batch_unit` (`batch_token`, `unit_id`),
  KEY `idx_dispatch_sds_batch` (`batch_token`),
    INDEX `idx_dispatch_sds_unit` (`unit_id`, `created_at`),
    INDEX `idx_dispatch_sds_center` (`center_id`, `created_at`)
) ENGINE=InnoDB;

CREATE TABLE IF NOT EXISTS `sky_jobs_dispatch_calls` (
    `id` BIGINT NOT NULL AUTO_INCREMENT,
    `call_number` VARCHAR(32) NOT NULL,
    `creation_token` VARCHAR(96) NULL,
    `center_id` VARCHAR(64) NOT NULL,
    `job` VARCHAR(80) NULL,
    `direction` VARCHAR(16) NOT NULL DEFAULT 'incoming',
    `reporter_name` VARCHAR(120) NULL,
    `reporter_phone` VARCHAR(40) NULL,
    `status` VARCHAR(24) NOT NULL DEFAULT 'waiting',
    `adapter` VARCHAR(64) NOT NULL DEFAULT 'manual',
    `capabilities` LONGTEXT NULL,
    `dispatcher` VARCHAR(64) NULL,
    `dispatcher_name` VARCHAR(120) NULL,
    `incident_id` BIGINT NULL,
    `notes` TEXT NULL,
    `started_at` DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
    `answered_at` DATETIME NULL,
    `ended_at` DATETIME NULL,
    `cleared_at` DATETIME NULL,
    PRIMARY KEY (`id`),
    UNIQUE KEY `uniq_dispatch_call_number` (`call_number`),
    UNIQUE KEY `uniq_dispatch_call_creation` (`creation_token`),
    UNIQUE KEY `uniq_dispatch_call_incident` (`incident_id`),
    INDEX `idx_dispatch_calls_center_status` (`center_id`, `status`, `started_at`)
) ENGINE=InnoDB;

ALTER TABLE `sky_jobs_dispatch_calls` ADD COLUMN IF NOT EXISTS `creation_token` VARCHAR(96) NULL AFTER `call_number`;
ALTER TABLE `sky_jobs_dispatch_calls` ADD COLUMN IF NOT EXISTS `job` VARCHAR(80) NULL AFTER `center_id`;
ALTER TABLE `sky_jobs_dispatch_calls` ADD COLUMN IF NOT EXISTS `cleared_at` DATETIME NULL AFTER `ended_at`;

SET @dispatch_call_add_creation = IF(
    EXISTS(SELECT 1 FROM INFORMATION_SCHEMA.STATISTICS
        WHERE TABLE_SCHEMA = DATABASE() AND TABLE_NAME = 'sky_jobs_dispatch_calls'
            AND INDEX_NAME = 'uniq_dispatch_call_creation'),
    'SELECT 1',
    'ALTER TABLE `sky_jobs_dispatch_calls` ADD UNIQUE KEY `uniq_dispatch_call_creation` (`creation_token`)'
);
PREPARE dispatch_call_add_creation FROM @dispatch_call_add_creation;
EXECUTE dispatch_call_add_creation;
DEALLOCATE PREPARE dispatch_call_add_creation;

UPDATE `sky_jobs_dispatch_incidents` incident
INNER JOIN `sky_jobs_dispatch_calls` call_record ON call_record.id = incident.call_id
SET incident.call_id = NULL
WHERE call_record.incident_id IS NOT NULL AND call_record.incident_id <> incident.id;

UPDATE `sky_jobs_dispatch_incidents` incident
INNER JOIN (
    SELECT call_id, MIN(id) AS keep_id FROM `sky_jobs_dispatch_incidents`
    WHERE call_id IS NOT NULL GROUP BY call_id HAVING COUNT(*) > 1
) duplicate ON duplicate.call_id = incident.call_id
SET incident.call_id = NULL WHERE incident.id <> duplicate.keep_id;

UPDATE `sky_jobs_dispatch_calls` call_record
INNER JOIN (
    SELECT incident_id, MIN(id) AS keep_id FROM `sky_jobs_dispatch_calls`
    WHERE incident_id IS NOT NULL GROUP BY incident_id HAVING COUNT(*) > 1
) duplicate ON duplicate.incident_id = call_record.incident_id
SET call_record.incident_id = NULL WHERE call_record.id <> duplicate.keep_id;

UPDATE `sky_jobs_dispatch_calls` call_record
INNER JOIN `sky_jobs_dispatch_incidents` incident ON incident.call_id = call_record.id
SET call_record.incident_id = incident.id WHERE call_record.incident_id IS NULL;

UPDATE `sky_jobs_dispatch_incidents` incident
INNER JOIN `sky_jobs_dispatch_calls` call_record ON call_record.incident_id = incident.id
SET incident.call_id = call_record.id WHERE incident.call_id IS NULL;

SET @dispatch_incident_add_call = IF(
    EXISTS(SELECT 1 FROM INFORMATION_SCHEMA.STATISTICS
        WHERE TABLE_SCHEMA = DATABASE() AND TABLE_NAME = 'sky_jobs_dispatch_incidents'
            AND INDEX_NAME = 'uniq_dispatch_incident_call'),
    'SELECT 1',
    'ALTER TABLE `sky_jobs_dispatch_incidents` ADD UNIQUE KEY `uniq_dispatch_incident_call` (`call_id`)'
);
PREPARE dispatch_incident_add_call FROM @dispatch_incident_add_call;
EXECUTE dispatch_incident_add_call;
DEALLOCATE PREPARE dispatch_incident_add_call;

SET @dispatch_call_add_incident = IF(
    EXISTS(SELECT 1 FROM INFORMATION_SCHEMA.STATISTICS
        WHERE TABLE_SCHEMA = DATABASE() AND TABLE_NAME = 'sky_jobs_dispatch_calls'
            AND INDEX_NAME = 'uniq_dispatch_call_incident'),
    'SELECT 1',
    'ALTER TABLE `sky_jobs_dispatch_calls` ADD UNIQUE KEY `uniq_dispatch_call_incident` (`incident_id`)'
);
PREPARE dispatch_call_add_incident FROM @dispatch_call_add_incident;
EXECUTE dispatch_call_add_incident;
DEALLOCATE PREPARE dispatch_call_add_incident;

CREATE TABLE IF NOT EXISTS `sky_jobs_dispatch_center_chat` (
    `id` BIGINT NOT NULL AUTO_INCREMENT,
    `message_token` VARCHAR(64) NULL,
    `center_id` VARCHAR(64) NOT NULL,
    `job` VARCHAR(80) NULL,
    `incident_id` BIGINT NULL,
    `author` VARCHAR(120) NOT NULL,
    `author_identifier` VARCHAR(64) NOT NULL,
    `message` VARCHAR(1000) NOT NULL,
    `created_at` DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
    PRIMARY KEY (`id`),
    UNIQUE KEY `uniq_dispatch_chat_token` (`message_token`),
    INDEX `idx_dispatch_chat_center` (`center_id`, `created_at`)
) ENGINE=InnoDB;

ALTER TABLE `sky_jobs_dispatch_center_chat` ADD COLUMN IF NOT EXISTS `message_token` VARCHAR(64) NULL AFTER `id`;
ALTER TABLE `sky_jobs_dispatch_center_chat` ADD COLUMN IF NOT EXISTS `job` VARCHAR(80) NULL AFTER `center_id`;

SET @dispatch_engine_upgrade = IF(
    (SELECT UPPER(ENGINE) FROM INFORMATION_SCHEMA.TABLES
        WHERE TABLE_SCHEMA = DATABASE() AND TABLE_NAME = 'sky_jobs_dispatch_incidents') = 'INNODB',
    'SELECT 1',
    'ALTER TABLE `sky_jobs_dispatch_incidents` ENGINE=InnoDB'
);
PREPARE dispatch_engine_upgrade FROM @dispatch_engine_upgrade;
EXECUTE dispatch_engine_upgrade;
DEALLOCATE PREPARE dispatch_engine_upgrade;

SET @dispatch_engine_upgrade = IF(
    (SELECT UPPER(ENGINE) FROM INFORMATION_SCHEMA.TABLES
        WHERE TABLE_SCHEMA = DATABASE() AND TABLE_NAME = 'sky_jobs_dispatch_incident_log') = 'INNODB',
    'SELECT 1',
    'ALTER TABLE `sky_jobs_dispatch_incident_log` ENGINE=InnoDB'
);
PREPARE dispatch_engine_upgrade FROM @dispatch_engine_upgrade;
EXECUTE dispatch_engine_upgrade;
DEALLOCATE PREPARE dispatch_engine_upgrade;

SET @dispatch_engine_upgrade = IF(
    (SELECT UPPER(ENGINE) FROM INFORMATION_SCHEMA.TABLES
        WHERE TABLE_SCHEMA = DATABASE() AND TABLE_NAME = 'sky_jobs_dispatch_incident_units') = 'INNODB',
    'SELECT 1',
    'ALTER TABLE `sky_jobs_dispatch_incident_units` ENGINE=InnoDB'
);
PREPARE dispatch_engine_upgrade FROM @dispatch_engine_upgrade;
EXECUTE dispatch_engine_upgrade;
DEALLOCATE PREPARE dispatch_engine_upgrade;

SET @dispatch_engine_upgrade = IF(
    (SELECT UPPER(ENGINE) FROM INFORMATION_SCHEMA.TABLES
        WHERE TABLE_SCHEMA = DATABASE() AND TABLE_NAME = 'sky_jobs_dispatch_unit_state') = 'INNODB',
    'SELECT 1',
    'ALTER TABLE `sky_jobs_dispatch_unit_state` ENGINE=InnoDB'
);
PREPARE dispatch_engine_upgrade FROM @dispatch_engine_upgrade;
EXECUTE dispatch_engine_upgrade;
DEALLOCATE PREPARE dispatch_engine_upgrade;

SET @dispatch_engine_upgrade = IF(
    (SELECT UPPER(ENGINE) FROM INFORMATION_SCHEMA.TABLES
        WHERE TABLE_SCHEMA = DATABASE() AND TABLE_NAME = 'sky_jobs_dispatch_units') = 'INNODB',
    'SELECT 1',
    'ALTER TABLE `sky_jobs_dispatch_units` ENGINE=InnoDB'
);
PREPARE dispatch_engine_upgrade FROM @dispatch_engine_upgrade;
EXECUTE dispatch_engine_upgrade;
DEALLOCATE PREPARE dispatch_engine_upgrade;

SET @dispatch_engine_upgrade = IF(
    (SELECT UPPER(ENGINE) FROM INFORMATION_SCHEMA.TABLES
        WHERE TABLE_SCHEMA = DATABASE() AND TABLE_NAME = 'sky_jobs_dispatch_unit_members') = 'INNODB',
    'SELECT 1',
    'ALTER TABLE `sky_jobs_dispatch_unit_members` ENGINE=InnoDB'
);
PREPARE dispatch_engine_upgrade FROM @dispatch_engine_upgrade;
EXECUTE dispatch_engine_upgrade;
DEALLOCATE PREPARE dispatch_engine_upgrade;

SET @dispatch_engine_upgrade = IF(
    (SELECT UPPER(ENGINE) FROM INFORMATION_SCHEMA.TABLES
        WHERE TABLE_SCHEMA = DATABASE() AND TABLE_NAME = 'sky_jobs_dispatch_unit_assignments') = 'INNODB',
    'SELECT 1',
    'ALTER TABLE `sky_jobs_dispatch_unit_assignments` ENGINE=InnoDB'
);
PREPARE dispatch_engine_upgrade FROM @dispatch_engine_upgrade;
EXECUTE dispatch_engine_upgrade;
DEALLOCATE PREPARE dispatch_engine_upgrade;

SET @dispatch_engine_upgrade = IF(
    (SELECT UPPER(ENGINE) FROM INFORMATION_SCHEMA.TABLES
        WHERE TABLE_SCHEMA = DATABASE() AND TABLE_NAME = 'sky_jobs_dispatch_alarm_attempts') = 'INNODB',
    'SELECT 1',
    'ALTER TABLE `sky_jobs_dispatch_alarm_attempts` ENGINE=InnoDB'
);
PREPARE dispatch_engine_upgrade FROM @dispatch_engine_upgrade;
EXECUTE dispatch_engine_upgrade;
DEALLOCATE PREPARE dispatch_engine_upgrade;

SET @dispatch_engine_upgrade = IF(
    (SELECT UPPER(ENGINE) FROM INFORMATION_SCHEMA.TABLES
        WHERE TABLE_SCHEMA = DATABASE() AND TABLE_NAME = 'sky_jobs_dispatch_audit') = 'INNODB',
    'SELECT 1',
    'ALTER TABLE `sky_jobs_dispatch_audit` ENGINE=InnoDB'
);
PREPARE dispatch_engine_upgrade FROM @dispatch_engine_upgrade;
EXECUTE dispatch_engine_upgrade;
DEALLOCATE PREPARE dispatch_engine_upgrade;

SET @dispatch_engine_upgrade = IF(
    (SELECT UPPER(ENGINE) FROM INFORMATION_SCHEMA.TABLES
        WHERE TABLE_SCHEMA = DATABASE() AND TABLE_NAME = 'sky_jobs_dispatch_map_features') = 'INNODB',
    'SELECT 1',
    'ALTER TABLE `sky_jobs_dispatch_map_features` ENGINE=InnoDB'
);
PREPARE dispatch_engine_upgrade FROM @dispatch_engine_upgrade;
EXECUTE dispatch_engine_upgrade;
DEALLOCATE PREPARE dispatch_engine_upgrade;

SET @dispatch_engine_upgrade = IF(
    (SELECT UPPER(ENGINE) FROM INFORMATION_SCHEMA.TABLES
        WHERE TABLE_SCHEMA = DATABASE() AND TABLE_NAME = 'sky_jobs_dispatch_calls') = 'INNODB',
    'SELECT 1',
    'ALTER TABLE `sky_jobs_dispatch_calls` ENGINE=InnoDB'
);
PREPARE dispatch_engine_upgrade FROM @dispatch_engine_upgrade;
EXECUTE dispatch_engine_upgrade;
DEALLOCATE PREPARE dispatch_engine_upgrade;

SET @dispatch_engine_upgrade = IF(
    (SELECT UPPER(ENGINE) FROM INFORMATION_SCHEMA.TABLES
        WHERE TABLE_SCHEMA = DATABASE() AND TABLE_NAME = 'sky_jobs_dispatch_broadcasts') = 'INNODB',
    'SELECT 1',
    'ALTER TABLE `sky_jobs_dispatch_broadcasts` ENGINE=InnoDB'
);
PREPARE dispatch_engine_upgrade FROM @dispatch_engine_upgrade;
EXECUTE dispatch_engine_upgrade;
DEALLOCATE PREPARE dispatch_engine_upgrade;

SET @dispatch_engine_upgrade = IF(
    (SELECT UPPER(ENGINE) FROM INFORMATION_SCHEMA.TABLES
        WHERE TABLE_SCHEMA = DATABASE() AND TABLE_NAME = 'sky_jobs_dispatch_sds') = 'INNODB',
    'SELECT 1',
    'ALTER TABLE `sky_jobs_dispatch_sds` ENGINE=InnoDB'
);
PREPARE dispatch_engine_upgrade FROM @dispatch_engine_upgrade;
EXECUTE dispatch_engine_upgrade;
DEALLOCATE PREPARE dispatch_engine_upgrade;

SET @dispatch_engine_upgrade = IF(
    (SELECT UPPER(ENGINE) FROM INFORMATION_SCHEMA.TABLES
        WHERE TABLE_SCHEMA = DATABASE() AND TABLE_NAME = 'sky_jobs_dispatch_center_chat') = 'INNODB',
    'SELECT 1',
    'ALTER TABLE `sky_jobs_dispatch_center_chat` ENGINE=InnoDB'
);
PREPARE dispatch_engine_upgrade FROM @dispatch_engine_upgrade;
EXECUTE dispatch_engine_upgrade;
DEALLOCATE PREPARE dispatch_engine_upgrade;

CREATE TABLE IF NOT EXISTS `sky_jobs_training_courses` (
    `id` BIGINT NOT NULL AUTO_INCREMENT,
    `job` VARCHAR(50) NOT NULL,
    `course_uid` VARCHAR(40) NOT NULL,
    `code` VARCHAR(32) NOT NULL,
    `title` VARCHAR(160) NOT NULL,
    `description` TEXT NULL,
    `learning_content` LONGTEXT NULL,
    `catalog_visible` TINYINT(1) NOT NULL DEFAULT 0,
    `category` VARCHAR(80) NULL,
    `duration_minutes` INT NOT NULL DEFAULT 60,
    `default_capacity` INT NOT NULL DEFAULT 12,
    `min_grade` INT NOT NULL DEFAULT 0,
    `prerequisites` LONGTEXT NULL,
    `trainer_grades` LONGTEXT NULL,
    `qualification_code` VARCHAR(64) NULL,
    `qualification_label` VARCHAR(160) NULL,
    `validity_days` INT NOT NULL DEFAULT 0,
    `active` TINYINT(1) NOT NULL DEFAULT 1,
    `sort_order` INT NOT NULL DEFAULT 0,
    `created_by_identifier` VARCHAR(64) NULL,
    `created_by_name` VARCHAR(120) NULL,
    `created_at` DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
    `updated_at` DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    PRIMARY KEY (`id`),
    UNIQUE KEY `uniq_training_course_uid` (`job`, `course_uid`),
    UNIQUE KEY `uniq_training_course_code` (`job`, `code`),
    INDEX `idx_training_courses_active` (`job`, `active`, `sort_order`),
    INDEX `idx_training_courses_qualification` (`job`, `qualification_code`)
);

ALTER TABLE `sky_jobs_training_courses`
    ADD COLUMN IF NOT EXISTS `learning_content` LONGTEXT NULL AFTER `description`,
    ADD COLUMN IF NOT EXISTS `catalog_visible` TINYINT(1) NOT NULL DEFAULT 0 AFTER `learning_content`;

CREATE TABLE IF NOT EXISTS `sky_jobs_training_sessions` (
    `id` BIGINT NOT NULL AUTO_INCREMENT,
    `job` VARCHAR(50) NOT NULL,
    `session_uid` VARCHAR(40) NOT NULL,
    `course_uid` VARCHAR(40) NOT NULL,
    `starts_at` DATETIME NOT NULL,
    `location` VARCHAR(180) NULL,
    `capacity` INT NOT NULL DEFAULT 12,
    `status` VARCHAR(24) NOT NULL DEFAULT 'scheduled',
    `notes` TEXT NULL,
    `instructor_identifier` VARCHAR(64) NULL,
    `instructor_name` VARCHAR(120) NULL,
    `created_at` DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
    `updated_at` DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    PRIMARY KEY (`id`),
    UNIQUE KEY `uniq_training_session_uid` (`job`, `session_uid`),
    INDEX `idx_training_sessions_status` (`job`, `status`, `starts_at`),
    INDEX `idx_training_sessions_course` (`job`, `course_uid`, `starts_at`),
    INDEX `idx_training_sessions_instructor` (`job`, `instructor_identifier`, `starts_at`)
);

CREATE TABLE IF NOT EXISTS `sky_jobs_training_enrollments` (
    `id` BIGINT NOT NULL AUTO_INCREMENT,
    `job` VARCHAR(50) NOT NULL,
    `session_uid` VARCHAR(40) NOT NULL,
    `employee_identifier` VARCHAR(64) NOT NULL,
    `employee_name` VARCHAR(120) NOT NULL,
    `status` VARCHAR(24) NOT NULL DEFAULT 'pending',
    `application_note` TEXT NULL,
    `result_note` TEXT NULL,
    `score` DECIMAL(6,2) NULL,
    `reviewed_by_identifier` VARCHAR(64) NULL,
    `reviewed_by_name` VARCHAR(120) NULL,
    `created_at` DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
    `updated_at` DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    PRIMARY KEY (`id`),
    UNIQUE KEY `uniq_training_enrollment` (`job`, `session_uid`, `employee_identifier`),
    INDEX `idx_training_enrollments_session` (`job`, `session_uid`, `status`),
    INDEX `idx_training_enrollments_employee` (`job`, `employee_identifier`, `status`, `created_at`)
);

CREATE TABLE IF NOT EXISTS `sky_jobs_training_qualifications` (
    `id` BIGINT NOT NULL AUTO_INCREMENT,
    `job` VARCHAR(50) NOT NULL,
    `employee_identifier` VARCHAR(64) NOT NULL,
    `employee_name` VARCHAR(120) NOT NULL,
    `course_uid` VARCHAR(40) NULL,
    `qualification_code` VARCHAR(64) NOT NULL,
    `qualification_label` VARCHAR(160) NOT NULL,
    `status` VARCHAR(24) NOT NULL DEFAULT 'active',
    `note` TEXT NULL,
    `issued_by_identifier` VARCHAR(64) NULL,
    `issued_by_name` VARCHAR(120) NULL,
    `issued_at` DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
    `expires_at` DATETIME NULL,
    `revoked_by_identifier` VARCHAR(64) NULL,
    `revoked_by_name` VARCHAR(120) NULL,
    `revoked_at` DATETIME NULL,
    `revoke_reason` TEXT NULL,
    `updated_at` DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    PRIMARY KEY (`id`),
    UNIQUE KEY `uniq_training_qualification` (`job`, `employee_identifier`, `qualification_code`),
    INDEX `idx_training_qualifications_employee` (`job`, `employee_identifier`, `status`),
    INDEX `idx_training_qualifications_expiry` (`job`, `status`, `expires_at`),
    INDEX `idx_training_qualifications_code` (`job`, `qualification_code`, `status`)
);

CREATE TABLE IF NOT EXISTS `sky_jobs_training_audit` (
    `id` BIGINT NOT NULL AUTO_INCREMENT,
    `job` VARCHAR(50) NOT NULL,
    `action` VARCHAR(64) NOT NULL,
    `entity_type` VARCHAR(32) NOT NULL,
    `entity_id` VARCHAR(64) NULL,
    `actor_identifier` VARCHAR(64) NULL,
    `actor_name` VARCHAR(120) NULL,
    `subject_identifier` VARCHAR(64) NULL,
    `subject_name` VARCHAR(120) NULL,
    `details` LONGTEXT NULL,
    `created_at` DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
    PRIMARY KEY (`id`),
    INDEX `idx_training_audit_created` (`job`, `created_at`),
    INDEX `idx_training_audit_entity` (`job`, `entity_type`, `entity_id`),
    INDEX `idx_training_audit_subject` (`job`, `subject_identifier`, `created_at`)
);
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
-- Custom RP registers. Definitions and access settings are managed in /jobconfig.
CREATE TABLE IF NOT EXISTS `sky_jobs_registry_records` (
    `id` BIGINT UNSIGNED NOT NULL AUTO_INCREMENT,
    `job` VARCHAR(64) NOT NULL,
    `registry_key` VARCHAR(48) NOT NULL,
    `title` VARCHAR(160) NOT NULL,
    `clearance_level` SMALLINT UNSIGNED NOT NULL DEFAULT 1,
    `fields_json` LONGTEXT NOT NULL,
    `revision` INT UNSIGNED NOT NULL DEFAULT 1,
    `archived` TINYINT NOT NULL DEFAULT 0,
    `created_by_identifier` VARCHAR(128) NOT NULL,
    `created_by_name` VARCHAR(120) NOT NULL,
    `created_at` DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
    `updated_at` DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
    PRIMARY KEY (`id`),
    INDEX `idx_registry_scope` (`job`, `registry_key`, `archived`, `clearance_level`)
) ENGINE=InnoDB;

CREATE TABLE IF NOT EXISTS `sky_jobs_registry_audit` (
    `id` BIGINT UNSIGNED NOT NULL AUTO_INCREMENT,
    `record_id` BIGINT UNSIGNED NOT NULL,
    `job` VARCHAR(64) NOT NULL,
    `registry_key` VARCHAR(48) NOT NULL,
    `action` VARCHAR(24) NOT NULL,
    `actor_identifier` VARCHAR(128) NOT NULL,
    `actor_name` VARCHAR(120) NOT NULL,
    `details_json` LONGTEXT NOT NULL,
    `created_at` DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
    PRIMARY KEY (`id`),
    INDEX `idx_registry_audit_record` (`record_id`, `id`)
) ENGINE=InnoDB;

-- Immutable paper copies of job records; no dependency on DOJ tables.
CREATE TABLE IF NOT EXISTS `sky_jobs_record_shares` (
    `id` BIGINT UNSIGNED NOT NULL AUTO_INCREMENT,
    `provider` VARCHAR(64) NOT NULL,
    `owner_job` VARCHAR(64) NOT NULL,
    `record_id` VARCHAR(128) NOT NULL,
    `source_key` VARCHAR(191) NOT NULL,
    `recipient_job` VARCHAR(64) NOT NULL,
    `title` VARCHAR(255) NOT NULL,
    `reference` VARCHAR(128) NOT NULL,
    `citizen_ids` LONGTEXT NOT NULL,
    `vehicle_plates` LONGTEXT NOT NULL,
    `updated_at` DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
    PRIMARY KEY (`id`),
    UNIQUE KEY `uniq_record_share` (`provider`, `owner_job`, `record_id`, `recipient_job`),
    KEY `idx_record_share_recipient` (`recipient_job`, `provider`, `owner_job`)
) ENGINE=InnoDB;

CREATE TABLE IF NOT EXISTS `sky_jobs_record_share_state` (
    `id` BIGINT UNSIGNED NOT NULL AUTO_INCREMENT,
    `provider` VARCHAR(64) NOT NULL,
    `owner_job` VARCHAR(64) NOT NULL,
    `record_id` VARCHAR(128) NOT NULL,
    `source_key` VARCHAR(191) NOT NULL,
    `revision` BIGINT UNSIGNED NOT NULL DEFAULT 0,
    `mutation_id` CHAR(36) NULL,
    PRIMARY KEY (`id`),
    UNIQUE KEY `uniq_record_share_state` (`provider`, `owner_job`, `record_id`, `source_key`)
) ENGINE=InnoDB;

CREATE TABLE IF NOT EXISTS `sky_jobs_printed_documents` (
    `id` CHAR(36) NOT NULL,
    `printer_id` VARCHAR(191) NOT NULL,
    `issued_by_identifier` VARCHAR(128) NOT NULL,
    `snapshot_json` LONGTEXT NOT NULL,
    `metadata_json` LONGTEXT NOT NULL,
    `pickup_state` VARCHAR(16) NOT NULL DEFAULT 'printing',
    `created_at` DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
    PRIMARY KEY (`id`),
    KEY `idx_job_document_output` (`printer_id`, `issued_by_identifier`, `pickup_state`, `created_at`, `id`)
) ENGINE=InnoDB;
CREATE TABLE IF NOT EXISTS `sky_jobs_invoices` (
    `id` BIGINT UNSIGNED NOT NULL AUTO_INCREMENT,
    `reference` VARCHAR(128) NOT NULL,
    `issuer_type` VARCHAR(16) NOT NULL,
    `job_name` VARCHAR(64) NOT NULL DEFAULT '',
    `job_label` VARCHAR(120) NOT NULL,
    `account` VARCHAR(128) NOT NULL DEFAULT '',
    `issuer_identifier` VARCHAR(128) NOT NULL DEFAULT '',
    `issuer_name` VARCHAR(120) NOT NULL,
    `actor_name` VARCHAR(120) NOT NULL,
    `actor_identifier` VARCHAR(128) NOT NULL DEFAULT '',
    `employee_share_percent` TINYINT UNSIGNED NOT NULL DEFAULT 0,
    `employee_share_paid` INT UNSIGNED NOT NULL DEFAULT 0,
    `employee_share_phase` VARCHAR(24) NULL,
    `employee_share_pending` INT UNSIGNED NULL,
    `employee_share_next_attempt_at_ts` BIGINT NOT NULL DEFAULT 0,
    `payment_mode` VARCHAR(16) NOT NULL DEFAULT 'later',
    `due_at_ts` BIGINT NOT NULL DEFAULT 0,
    `installment_count` TINYINT UNSIGNED NOT NULL DEFAULT 1,
    `installment_interval_days` SMALLINT UNSIGNED NOT NULL DEFAULT 0,
    `installment_start_at_ts` BIGINT NOT NULL DEFAULT 0,
    `next_attempt_at_ts` BIGINT NOT NULL DEFAULT 0,
    `collection_failure_code` VARCHAR(32) NOT NULL DEFAULT '',
    `collection_failed_at_ts` BIGINT NOT NULL DEFAULT 0,
    `reminder_at_ts` BIGINT NOT NULL DEFAULT 0,
    `recipient_type` VARCHAR(16) NOT NULL,
    `recipient_job` VARCHAR(64) NOT NULL DEFAULT '',
    `recipient_identifier` VARCHAR(128) NOT NULL DEFAULT '',
    `recipient_name` VARCHAR(120) NOT NULL,
    `reason` TEXT NOT NULL,
    `amount` INT UNSIGNED NOT NULL,
    `amount_paid` INT UNSIGNED NOT NULL DEFAULT 0,
    `currency` VARCHAR(64) NOT NULL,
    `deposit_to_society` TINYINT NOT NULL DEFAULT 1,
    `source_type` VARCHAR(64) NOT NULL,
    `status` VARCHAR(24) NOT NULL DEFAULT 'open',
    `payment_phase` VARCHAR(24) NULL,
    `pending_amount` INT UNSIGNED NULL,
    `pending_currency` VARCHAR(64) NULL,
    `payer_identifier` VARCHAR(128) NULL,
    `payer_job` VARCHAR(64) NULL,
    `created_at` DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
    `updated_at` DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
    `paid_at` DATETIME NULL,
    PRIMARY KEY (`id`),
    UNIQUE KEY `uq_sky_invoice_reference` (`reference`),
    KEY `idx_sky_invoice_recipient` (`recipient_identifier`, `id`),
    KEY `idx_sky_invoice_sender` (`job_name`, `id`),
    KEY `idx_sky_invoice_society` (`recipient_job`, `id`),
    KEY `idx_sky_invoice_due` (`payment_mode`, `status`, `next_attempt_at_ts`, `due_at_ts`),
    KEY `idx_sky_invoice_employee` (`employee_share_phase`, `employee_share_next_attempt_at_ts`, `actor_identifier`)
) ENGINE=InnoDB;

-- Shared supply orders retain the legacy Mechanic table name and rows.
CREATE TABLE IF NOT EXISTS `sky_mechanic_part_deliveries` (
    `id` INT NOT NULL AUTO_INCREMENT,
    `order_uid` VARCHAR(32) NOT NULL,
    `request_key` VARCHAR(64) NULL,
    `request_payload` LONGTEXT NULL,
    `ordered_by_identifier` VARCHAR(120) NULL,
    `ordered_by_name` VARCHAR(120) NULL,
    `job_name` VARCHAR(64) NULL,
    `payment_method` VARCHAR(16) NOT NULL,
    `total_price` INT NOT NULL DEFAULT 0,
    `items` LONGTEXT NULL,
    `claim_reservations` LONGTEXT NULL,
    `delivery_point_key` VARCHAR(160) NULL,
    `delivery_label` VARCHAR(120) NULL,
    `delivery_x` DOUBLE NULL,
    `delivery_y` DOUBLE NULL,
    `delivery_z` DOUBLE NULL,
    `delivery_heading` DOUBLE NULL,
    `status` VARCHAR(24) NOT NULL DEFAULT 'pending',
    `arrives_at` DATETIME NOT NULL,
    `claimed_by_identifier` VARCHAR(120) NULL,
    `claimed_by_name` VARCHAR(120) NULL,
    `claimed_at` DATETIME NULL,
    `created_at` DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
    `updated_at` DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    PRIMARY KEY (`id`),
    UNIQUE KEY `uniq_mechanic_part_delivery_uid` (`order_uid`),
    UNIQUE KEY `uq_supply_order_request` (`job_name`, `ordered_by_identifier`, `request_key`),
    INDEX `idx_mechanic_part_deliveries_status_arrival` (`status`, `arrives_at`),
    INDEX `idx_mechanic_part_deliveries_point` (`delivery_point_key`)
);

ALTER TABLE `sky_mechanic_part_deliveries` ADD COLUMN IF NOT EXISTS `ordered_by_identifier` VARCHAR(120) NULL;
ALTER TABLE `sky_mechanic_part_deliveries` ADD COLUMN IF NOT EXISTS `ordered_by_name` VARCHAR(120) NULL;
ALTER TABLE `sky_mechanic_part_deliveries` ADD COLUMN IF NOT EXISTS `job_name` VARCHAR(64) NULL;
ALTER TABLE `sky_mechanic_part_deliveries` ADD COLUMN IF NOT EXISTS `payment_method` VARCHAR(16) NOT NULL;
ALTER TABLE `sky_mechanic_part_deliveries` ADD COLUMN IF NOT EXISTS `total_price` INT NOT NULL DEFAULT 0;
ALTER TABLE `sky_mechanic_part_deliveries` ADD COLUMN IF NOT EXISTS `items` LONGTEXT NULL;
ALTER TABLE `sky_mechanic_part_deliveries` ADD COLUMN IF NOT EXISTS `claim_reservations` LONGTEXT NULL;
ALTER TABLE `sky_mechanic_part_deliveries` ADD COLUMN IF NOT EXISTS `delivery_point_key` VARCHAR(160) NULL;
ALTER TABLE `sky_mechanic_part_deliveries` ADD COLUMN IF NOT EXISTS `delivery_label` VARCHAR(120) NULL;
ALTER TABLE `sky_mechanic_part_deliveries` ADD COLUMN IF NOT EXISTS `delivery_x` DOUBLE NULL;
ALTER TABLE `sky_mechanic_part_deliveries` ADD COLUMN IF NOT EXISTS `delivery_y` DOUBLE NULL;
ALTER TABLE `sky_mechanic_part_deliveries` ADD COLUMN IF NOT EXISTS `delivery_z` DOUBLE NULL;
ALTER TABLE `sky_mechanic_part_deliveries` ADD COLUMN IF NOT EXISTS `delivery_heading` DOUBLE NULL;
ALTER TABLE `sky_mechanic_part_deliveries` ADD COLUMN IF NOT EXISTS `status` VARCHAR(24) NOT NULL DEFAULT 'pending';
ALTER TABLE `sky_mechanic_part_deliveries` ADD COLUMN IF NOT EXISTS `arrives_at` DATETIME NOT NULL;
ALTER TABLE `sky_mechanic_part_deliveries` ADD COLUMN IF NOT EXISTS `claimed_by_identifier` VARCHAR(120) NULL;
ALTER TABLE `sky_mechanic_part_deliveries` ADD COLUMN IF NOT EXISTS `claimed_by_name` VARCHAR(120) NULL;
ALTER TABLE `sky_mechanic_part_deliveries` ADD COLUMN IF NOT EXISTS `claimed_at` DATETIME NULL;
ALTER TABLE `sky_mechanic_part_deliveries` ADD COLUMN IF NOT EXISTS `created_at` DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP;
ALTER TABLE `sky_mechanic_part_deliveries` ADD COLUMN IF NOT EXISTS `updated_at` DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP;

ALTER TABLE `sky_mechanic_part_deliveries` ADD COLUMN IF NOT EXISTS `request_key` VARCHAR(64) NULL;
ALTER TABLE `sky_mechanic_part_deliveries` ADD COLUMN IF NOT EXISTS `request_payload` LONGTEXT NULL;

-- Existing installations: add the idempotency index only once.
SET @supply_index_sql = IF(
    EXISTS(SELECT 1 FROM information_schema.STATISTICS WHERE TABLE_SCHEMA = DATABASE() AND TABLE_NAME = 'sky_mechanic_part_deliveries' AND INDEX_NAME = 'uq_supply_order_request'),
    'SELECT 1',
    'ALTER TABLE `sky_mechanic_part_deliveries` ADD UNIQUE KEY `uq_supply_order_request` (`job_name`, `ordered_by_identifier`, `request_key`)'
);
PREPARE supply_index_statement FROM @supply_index_sql;
EXECUTE supply_index_statement;
DEALLOCATE PREPARE supply_index_statement;
