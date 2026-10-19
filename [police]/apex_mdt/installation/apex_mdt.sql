-- ============================================================
-- Apex MDT - database tables
-- ------------------------------------------------------------
-- OPTIONAL. apex_mdt creates every one of these tables by itself the
-- first time it starts (and adds any column a newer version needs),
-- as long as oxmysql is started before it. Import this file only if
-- your database user is not allowed to CREATE / ALTER tables, or if
-- you prefer to create them by hand.
--
-- Safe to run more than once: every statement is IF NOT EXISTS and
-- nothing here deletes or changes existing rows.
--
-- Run it on the same database as your framework (the one in
-- mysql_connection_string). Citizens and vehicles are read from your
-- framework's own tables (users / owned_vehicles on ESX,
-- players / player_vehicles on QBCore and QBox) - nothing to add there.
-- ============================================================

-- Officer / medic profile, one row per (character, job) so the POLICE
-- and HOSPITAL registrations of the same character stay separate.
CREATE TABLE IF NOT EXISTS `apex_mdt_staff` (
    `identifier` VARCHAR(60) NOT NULL,
    `job` VARCHAR(40) NOT NULL DEFAULT '',
    `callsign` VARCHAR(20) DEFAULT NULL,
    `division` VARCHAR(40) DEFAULT NULL,
    `status` VARCHAR(20) DEFAULT NULL,
    `stats` TEXT DEFAULT NULL,
    `duty_seconds` INT UNSIGNED NOT NULL DEFAULT 0,
    `notes` TEXT DEFAULT NULL,
    `updated_at` TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    `setup_done` TINYINT(1) NOT NULL DEFAULT 0,
    `fingerprint` VARCHAR(24) DEFAULT NULL,
    `blood` VARCHAR(5) DEFAULT NULL,
    `phone` VARCHAR(20) DEFAULT NULL,
    `photo` LONGTEXT DEFAULT NULL,
    `bodycam_installed` TINYINT(1) NOT NULL DEFAULT 0,
    PRIMARY KEY (`identifier`, `job`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- ─── Police ────────────────────────────────────────────────

CREATE TABLE IF NOT EXISTS `apex_mdt_reports` (
    `id` INT UNSIGNED NOT NULL AUTO_INCREMENT,
    `mode` VARCHAR(10) DEFAULT 'police',
    `type` VARCHAR(30) DEFAULT NULL,
    `title` VARCHAR(160) DEFAULT NULL,
    `author` VARCHAR(60) DEFAULT NULL,
    `author_name` VARCHAR(80) DEFAULT NULL,
    `involved` TEXT DEFAULT NULL,
    `charges` TEXT DEFAULT NULL,
    `narrative` MEDIUMTEXT DEFAULT NULL,
    `tags` VARCHAR(255) DEFAULT NULL,
    `status` VARCHAR(20) DEFAULT 'draft',
    `approved_by` VARCHAR(80) DEFAULT NULL,
    `created_at` TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    `updated_at` TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

CREATE TABLE IF NOT EXISTS `apex_mdt_warrants` (
    `id` INT UNSIGNED NOT NULL AUTO_INCREMENT,
    `citizen_id` VARCHAR(60) DEFAULT NULL,
    `citizen_name` VARCHAR(80) DEFAULT NULL,
    `type` VARCHAR(20) DEFAULT 'arrest',
    `reason` TEXT DEFAULT NULL,
    `charges` TEXT DEFAULT NULL,
    `status` VARCHAR(20) DEFAULT 'pending',
    `issued_by` VARCHAR(80) DEFAULT NULL,
    `approved_by` VARCHAR(80) DEFAULT NULL,
    `expires_at` BIGINT DEFAULT NULL,
    `created_at` TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

CREATE TABLE IF NOT EXISTS `apex_mdt_bolos` (
    `id` INT UNSIGNED NOT NULL AUTO_INCREMENT,
    `mode` VARCHAR(10) DEFAULT 'police',
    `type` VARCHAR(20) DEFAULT 'person',
    `title` VARCHAR(160) DEFAULT NULL,
    `description` TEXT DEFAULT NULL,
    `priority` VARCHAR(20) DEFAULT 'medium',
    `image` VARCHAR(255) DEFAULT NULL,
    `plate` VARCHAR(12) DEFAULT NULL,
    `last_seen` VARCHAR(160) DEFAULT NULL,
    `coords` VARCHAR(60) DEFAULT NULL,
    `status` VARCHAR(20) DEFAULT 'active',
    `author` VARCHAR(80) DEFAULT NULL,
    `created_at` TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

CREATE TABLE IF NOT EXISTS `apex_mdt_citations` (
    `id` INT UNSIGNED NOT NULL AUTO_INCREMENT,
    `citizen_id` VARCHAR(60) DEFAULT NULL,
    `citizen_name` VARCHAR(80) DEFAULT NULL,
    `plate` VARCHAR(12) DEFAULT NULL,
    `charges` TEXT DEFAULT NULL,
    `amount` INT DEFAULT 0,
    `officer` VARCHAR(80) DEFAULT NULL,
    `paid` TINYINT(1) DEFAULT 0,
    `created_at` TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

CREATE TABLE IF NOT EXISTS `apex_mdt_evidence` (
    `id` INT UNSIGNED NOT NULL AUTO_INCREMENT,
    `case_ref` VARCHAR(40) DEFAULT NULL,
    `type` VARCHAR(20) DEFAULT NULL,
    `label` VARCHAR(160) DEFAULT NULL,
    `description` TEXT DEFAULT NULL,
    `location` VARCHAR(160) DEFAULT NULL,
    `image` VARCHAR(255) DEFAULT NULL,
    `custody` TEXT DEFAULT NULL,
    `added_by` VARCHAR(80) DEFAULT NULL,
    `created_at` TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

CREATE TABLE IF NOT EXISTS `apex_mdt_notes` (
    `id` INT UNSIGNED NOT NULL AUTO_INCREMENT,
    `target_type` VARCHAR(20) DEFAULT 'citizen',
    `target_id` VARCHAR(60) DEFAULT NULL,
    `body` TEXT DEFAULT NULL,
    `author` VARCHAR(80) DEFAULT NULL,
    `created_at` TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

CREATE TABLE IF NOT EXISTS `apex_mdt_flags` (
    `id` INT UNSIGNED NOT NULL AUTO_INCREMENT,
    `citizen_id` VARCHAR(60) DEFAULT NULL,
    `flag` VARCHAR(30) DEFAULT NULL,
    `added_by` VARCHAR(80) DEFAULT NULL,
    `created_at` TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- Citizen / patient face shown on Profiles and Patients.
CREATE TABLE IF NOT EXISTS `apex_mdt_mugshots` (
    `identifier` VARCHAR(60) NOT NULL,
    `photo` LONGTEXT DEFAULT NULL,
    `captured_by` VARCHAR(80) DEFAULT NULL,
    `updated_at` TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    PRIMARY KEY (`identifier`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- ─── Shared (Police + EMS) ─────────────────────────────────

CREATE TABLE IF NOT EXISTS `apex_mdt_bulletins` (
    `id` INT UNSIGNED NOT NULL AUTO_INCREMENT,
    `mode` VARCHAR(10) DEFAULT 'police',
    `title` VARCHAR(160) DEFAULT NULL,
    `body` TEXT DEFAULT NULL,
    `priority` VARCHAR(20) DEFAULT 'medium',
    `author` VARCHAR(80) DEFAULT NULL,
    `created_at` TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

CREATE TABLE IF NOT EXISTS `apex_mdt_messages` (
    `id` INT UNSIGNED NOT NULL AUTO_INCREMENT,
    `channel` VARCHAR(40) DEFAULT 'general',
    `author` VARCHAR(80) DEFAULT NULL,
    `body` TEXT DEFAULT NULL,
    `created_at` TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    `image` LONGTEXT DEFAULT NULL,
    PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

CREATE TABLE IF NOT EXISTS `apex_mdt_audit` (
    `id` INT UNSIGNED NOT NULL AUTO_INCREMENT,
    `actor` VARCHAR(60) DEFAULT NULL,
    `actor_name` VARCHAR(80) DEFAULT NULL,
    `action` VARCHAR(60) DEFAULT NULL,
    `detail` VARCHAR(255) DEFAULT NULL,
    `created_at` TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- ─── EMS / Hospital ────────────────────────────────────────

CREATE TABLE IF NOT EXISTS `apex_mdt_admissions` (
    `id` INT UNSIGNED NOT NULL AUTO_INCREMENT,
    `patient_id` VARCHAR(60) DEFAULT NULL,
    `patient_name` VARCHAR(80) DEFAULT NULL,
    `ward` VARCHAR(30) DEFAULT NULL,
    `bed` INT DEFAULT 0,
    `doctor` VARCHAR(80) DEFAULT NULL,
    `triage` VARCHAR(10) DEFAULT NULL,
    `diagnosis` TEXT DEFAULT NULL,
    `vitals` TEXT DEFAULT NULL,
    `notes` TEXT DEFAULT NULL,
    `status` VARCHAR(20) DEFAULT 'admitted',
    `created_at` TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    `discharged_at` TIMESTAMP NULL DEFAULT NULL,
    PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

CREATE TABLE IF NOT EXISTS `apex_mdt_surgeries` (
    `id` INT UNSIGNED NOT NULL AUTO_INCREMENT,
    `patient_id` VARCHAR(60) DEFAULT NULL,
    `patient_name` VARCHAR(80) DEFAULT NULL,
    `type` VARCHAR(40) DEFAULT NULL,
    `team` TEXT DEFAULT NULL,
    `scheduled_at` BIGINT DEFAULT NULL,
    `status` VARCHAR(20) DEFAULT 'scheduled',
    `outcome` VARCHAR(20) DEFAULT NULL,
    `notes` TEXT DEFAULT NULL,
    `created_at` TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

CREATE TABLE IF NOT EXISTS `apex_mdt_deaths` (
    `id` INT UNSIGNED NOT NULL AUTO_INCREMENT,
    `citizen_id` VARCHAR(60) DEFAULT NULL,
    `citizen_name` VARCHAR(80) DEFAULT NULL,
    `cause` VARCHAR(160) DEFAULT NULL,
    `examiner` VARCHAR(80) DEFAULT NULL,
    `autopsy` TEXT DEFAULT NULL,
    `shared_police` TINYINT(1) DEFAULT 0,
    `time_of_death` TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

CREATE TABLE IF NOT EXISTS `apex_mdt_invoices` (
    `id` INT UNSIGNED NOT NULL AUTO_INCREMENT,
    `citizen_id` VARCHAR(60) DEFAULT NULL,
    `citizen_name` VARCHAR(80) DEFAULT NULL,
    `items` TEXT DEFAULT NULL,
    `total` INT DEFAULT 0,
    `insurance` TINYINT(1) DEFAULT 0,
    `status` VARCHAR(20) DEFAULT 'unpaid',
    `issued_by` VARCHAR(80) DEFAULT NULL,
    `created_at` TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

CREATE TABLE IF NOT EXISTS `apex_mdt_prescriptions` (
    `id` INT UNSIGNED NOT NULL AUTO_INCREMENT,
    `patient_id` VARCHAR(60) DEFAULT NULL,
    `patient_name` VARCHAR(80) DEFAULT NULL,
    `medication` VARCHAR(40) DEFAULT NULL,
    `qty` INT DEFAULT 1,
    `prescriber` VARCHAR(80) DEFAULT NULL,
    `dispensed` TINYINT(1) DEFAULT 0,
    `created_at` TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;
