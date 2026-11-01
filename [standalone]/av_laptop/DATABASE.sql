CREATE TABLE IF NOT EXISTS `av_documents` (
  `id` varchar(50) NOT NULL,
  `owner` varchar(100) DEFAULT '0',
  `name` varchar(100) DEFAULT '0',
  `content` longtext DEFAULT NULL,
  `type` varchar(50) DEFAULT 'document',
  `official` tinyint(1) NOT NULL DEFAULT 0,
  `locked` tinyint(1) NOT NULL DEFAULT 0,
  `job` varchar(50) DEFAULT NULL,
  `preview` text DEFAULT NULL,
  `ydoc` longtext DEFAULT NULL,
  `created_at` timestamp NULL DEFAULT current_timestamp(),
  `updated_at` timestamp NULL DEFAULT current_timestamp(),
  `deleted_at` timestamp NULL DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `owner` (`owner`),
  KEY `type` (`type`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

CREATE TABLE IF NOT EXISTS `av_document_shares` (
  `document_id` varchar(50) NOT NULL,
  `identifier` varchar(100) NOT NULL,
  `name` varchar(100) DEFAULT NULL,
  `role` varchar(20) NOT NULL DEFAULT 'viewer',
  `created_at` timestamp NULL DEFAULT current_timestamp(),
  PRIMARY KEY (`document_id`, `identifier`),
  KEY `identifier` (`identifier`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

CREATE TABLE IF NOT EXISTS `av_document_signers` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `document_id` varchar(50) NOT NULL,
  `identifier` varchar(100) DEFAULT NULL,
  `name` varchar(100) DEFAULT NULL,
  `label` varchar(60) DEFAULT NULL,
  `status` varchar(20) NOT NULL DEFAULT 'pending',
  `signed_at` timestamp NULL DEFAULT NULL,
  `created_at` timestamp NULL DEFAULT current_timestamp(),
  PRIMARY KEY (`id`),
  KEY `document_id` (`document_id`),
  KEY `identifier` (`identifier`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

CREATE TABLE IF NOT EXISTS `laptop_files` (
  `id` varchar(50) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NOT NULL,
  `device_serial` varchar(50) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NOT NULL,
  `owner` varchar(100) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
  `parent_id` varchar(50) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT 'root',
  `name` varchar(100) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NOT NULL DEFAULT '"No name"',
  `type` enum('folder','image','video','document','device','notes') CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NOT NULL,
  `content` longtext CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
  `metadata` longtext CHARACTER SET utf8mb4 COLLATE utf8mb4_bin DEFAULT NULL,
  `created_at` timestamp NULL DEFAULT current_timestamp(),
  `deleted_at` timestamp NULL DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `device_serial` (`device_serial`),
  KEY `parent_id` (`parent_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_general_ci;
CREATE TABLE IF NOT EXISTS `laptop_settings` (
  `serial` varchar(50) NOT NULL,
  `owner` varchar(100) DEFAULT NULL,
  `setup_done` tinyint(1) NOT NULL DEFAULT 0,
  `prefs` longtext DEFAULT NULL,
  `widgets` longtext DEFAULT NULL,
  `modules` longtext DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT current_timestamp() ON UPDATE current_timestamp(),
  PRIMARY KEY (`serial`),
  KEY `owner` (`owner`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

CREATE TABLE IF NOT EXISTS `av_laptop_config` (
  `key` varchar(64) NOT NULL,
  `value` longtext DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT current_timestamp() ON UPDATE current_timestamp(),
  PRIMARY KEY (`key`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

CREATE TABLE IF NOT EXISTS `av_laptop_news` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `title` varchar(80) NOT NULL,
  `text` text NOT NULL,
  `source` varchar(60) DEFAULT 'admin',
  `author` varchar(100) DEFAULT NULL,
  `pinned` tinyint(1) NOT NULL DEFAULT 0,
  `active` tinyint(1) NOT NULL DEFAULT 1,
  `expires_at` int(11) DEFAULT NULL,
  `created_at` int(11) NOT NULL,
  `updated_at` int(11) NOT NULL,
  PRIMARY KEY (`id`),
  KEY `feed` (`active`, `pinned`, `created_at`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

CREATE TABLE IF NOT EXISTS `av_laptop_admin_logs` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `admin_name` varchar(100) DEFAULT NULL,
  `admin_identifier` varchar(100) DEFAULT NULL,
  `action` varchar(40) NOT NULL,
  `target` varchar(100) DEFAULT NULL,
  `details` longtext DEFAULT NULL,
  `at` int(11) NOT NULL,
  PRIMARY KEY (`id`),
  KEY `action` (`action`),
  KEY `at` (`at`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

CREATE TABLE IF NOT EXISTS `av_laptop_events` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `title` varchar(80) NOT NULL,
  `description` text DEFAULT NULL,
  `location` varchar(100) DEFAULT NULL,
  `coords` varchar(120) DEFAULT NULL,
  `start_at` int(11) NOT NULL,
  `end_at` int(11) NOT NULL,
  `all_day` tinyint(1) NOT NULL DEFAULT 0,
  `color` varchar(20) NOT NULL DEFAULT 'blue',
  `job` varchar(60) DEFAULT NULL,
  `source` varchar(60) DEFAULT 'admin',
  `author` varchar(100) DEFAULT NULL,
  `created_at` int(11) NOT NULL,
  `updated_at` int(11) NOT NULL,
  PRIMARY KEY (`id`),
  KEY `range` (`start_at`, `end_at`),
  KEY `job` (`job`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

CREATE TABLE IF NOT EXISTS `laptop_agenda` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `serial` varchar(50) NOT NULL,
  `owner` varchar(100) DEFAULT NULL,
  `title` varchar(80) NOT NULL,
  `description` varchar(500) DEFAULT NULL,
  `location` varchar(100) DEFAULT NULL,
  `start_at` int(11) NOT NULL,
  `end_at` int(11) NOT NULL,
  `all_day` tinyint(1) NOT NULL DEFAULT 0,
  `color` varchar(20) NOT NULL DEFAULT 'blue',
  `created_at` int(11) NOT NULL,
  PRIMARY KEY (`id`),
  KEY `serial` (`serial`, `start_at`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

CREATE TABLE IF NOT EXISTS `av_cloud_plans` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `name` varchar(40) NOT NULL,
  `price` int(11) NOT NULL DEFAULT 0,
  `period_days` int(11) NOT NULL DEFAULT 30,
  `capacity` int(11) NOT NULL DEFAULT 20,
  `team_drives` int(11) NOT NULL DEFAULT 0,
  `max_members` int(11) NOT NULL DEFAULT 0,
  `free` tinyint(1) NOT NULL DEFAULT 0,
  `active` tinyint(1) NOT NULL DEFAULT 1,
  `sort` int(11) NOT NULL DEFAULT 0,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

CREATE TABLE IF NOT EXISTS `av_cloud_drives` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `type` varchar(10) NOT NULL DEFAULT 'personal',
  `name` varchar(60) NOT NULL,
  `owner` varchar(100) NOT NULL,
  `owner_name` varchar(100) DEFAULT NULL,
  `plan_id` int(11) NOT NULL,
  `status` varchar(10) NOT NULL DEFAULT 'active',
  `auto_renew` tinyint(1) NOT NULL DEFAULT 1,
  `renew_at` int(11) NOT NULL DEFAULT 0,
  `grace_until` int(11) NOT NULL DEFAULT 0,
  `delete_at` int(11) NOT NULL DEFAULT 0,
  `color` varchar(20) DEFAULT NULL,
  `created_at` int(11) NOT NULL,
  `updated_at` int(11) NOT NULL,
  PRIMARY KEY (`id`),
  KEY `owner` (`owner`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

CREATE TABLE IF NOT EXISTS `av_cloud_members` (
  `drive_id` int(11) NOT NULL,
  `identifier` varchar(100) NOT NULL,
  `name` varchar(100) DEFAULT NULL,
  `role` varchar(10) NOT NULL DEFAULT 'viewer',
  `perms` int(11) NOT NULL DEFAULT 0,
  `added_by` varchar(100) DEFAULT NULL,
  `created_at` int(11) NOT NULL,
  PRIMARY KEY (`drive_id`, `identifier`),
  KEY `identifier` (`identifier`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

CREATE TABLE IF NOT EXISTS `av_cloud_invites` (
  `code` varchar(16) NOT NULL,
  `drive_id` int(11) NOT NULL,
  `role` varchar(10) NOT NULL DEFAULT 'viewer',
  `perms` int(11) NOT NULL DEFAULT 0,
  `expires_at` int(11) NOT NULL,
  `max_uses` int(11) NOT NULL DEFAULT 1,
  `uses` int(11) NOT NULL DEFAULT 0,
  `created_by` varchar(100) DEFAULT NULL,
  PRIMARY KEY (`code`),
  KEY `drive_id` (`drive_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

CREATE TABLE IF NOT EXISTS `av_cloud_billing` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `drive_id` int(11) NOT NULL,
  `amount` int(11) NOT NULL,
  `status` varchar(10) NOT NULL,
  `payer` varchar(100) DEFAULT NULL,
  `note` varchar(60) DEFAULT NULL,
  `at` int(11) NOT NULL,
  PRIMARY KEY (`id`),
  KEY `drive_id` (`drive_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

CREATE TABLE IF NOT EXISTS `av_cloud_activity` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `drive_id` int(11) NOT NULL,
  `actor` varchar(100) DEFAULT NULL,
  `actor_name` varchar(100) DEFAULT NULL,
  `action` varchar(40) NOT NULL,
  `target` varchar(120) DEFAULT NULL,
  `at` int(11) NOT NULL,
  PRIMARY KEY (`id`),
  KEY `drive_id` (`drive_id`, `at`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

CREATE TABLE IF NOT EXISTS `av_license_types` (
  `id` varchar(40) NOT NULL,
  `label` varchar(60) NOT NULL,
  `item` varchar(50) DEFAULT NULL,
  `issuers` text DEFAULT NULL,
  `inspectors` text DEFAULT NULL,
  `validity_days` int(11) NOT NULL DEFAULT 0,
  `fields` text DEFAULT NULL,
  `template` text DEFAULT NULL,
  `active` tinyint(1) NOT NULL DEFAULT 1,
  `sort` int(11) NOT NULL DEFAULT 0,
  `updated_at` int(11) NOT NULL DEFAULT 0,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

CREATE TABLE IF NOT EXISTS `av_licenses` (
  `id` varchar(20) NOT NULL,
  `type_id` varchar(40) NOT NULL,
  `holder` varchar(100) NOT NULL,
  `holder_name` varchar(100) DEFAULT NULL,
  `holder_data` text DEFAULT NULL,
  `fields` text DEFAULT NULL,
  `issuer` varchar(100) DEFAULT NULL,
  `issuer_name` varchar(100) DEFAULT NULL,
  `issuer_job` varchar(50) DEFAULT NULL,
  `issued_at` int(11) NOT NULL DEFAULT 0,
  `expires_at` int(11) NOT NULL DEFAULT 0,
  `status` varchar(16) NOT NULL DEFAULT 'valid',
  `revoked_at` int(11) NOT NULL DEFAULT 0,
  `revoked_by` varchar(100) DEFAULT NULL,
  `revoke_reason` varchar(120) DEFAULT NULL,
  `template` text DEFAULT NULL,
  `verify` varchar(12) DEFAULT NULL,
  `prints` int(11) NOT NULL DEFAULT 0,
  `updated_at` int(11) NOT NULL DEFAULT 0,
  PRIMARY KEY (`id`),
  KEY `holder` (`holder`),
  KEY `type_id` (`type_id`),
  KEY `type_issued` (`type_id`, `issued_at`),
  KEY `issuer_job` (`issuer_job`),
  KEY `verify` (`verify`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

CREATE TABLE IF NOT EXISTS `av_license_logs` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `license_id` varchar(20) NOT NULL,
  `type_id` varchar(40) DEFAULT NULL,
  `action` varchar(20) NOT NULL,
  `actor` varchar(100) DEFAULT NULL,
  `actor_name` varchar(100) DEFAULT NULL,
  `actor_job` varchar(50) DEFAULT NULL,
  `holder` varchar(100) DEFAULT NULL,
  `holder_name` varchar(100) DEFAULT NULL,
  `details` varchar(200) DEFAULT NULL,
  `created_at` int(11) NOT NULL DEFAULT 0,
  PRIMARY KEY (`id`),
  KEY `license_id` (`license_id`),
  KEY `created_at` (`created_at`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
