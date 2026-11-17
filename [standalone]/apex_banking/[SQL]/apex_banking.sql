-- ============================================================
-- Apex Banking — SQL schema
-- ────────────────────────────────────────────────────────────
-- These tables are also created automatically by
-- build/server/database.lua on first start, so importing this
-- file by hand is OPTIONAL. Kept here for DBA convenience.
-- ============================================================

CREATE TABLE IF NOT EXISTS `apex_banking_accounts` (
  `identifier`         VARCHAR(60) NOT NULL PRIMARY KEY,
  `iban`               VARCHAR(20) NOT NULL UNIQUE,
  `owner_name`         VARCHAR(80) NOT NULL,
  `pin`                VARCHAR(8)  NOT NULL,
  `pin_tries`          TINYINT     NOT NULL DEFAULT 0,
  `pin_locked_until`   BIGINT      NOT NULL DEFAULT 0,
  `frozen`             TINYINT(1)  NOT NULL DEFAULT 0,
  `savings`            BIGINT      NOT NULL DEFAULT 0,
  `savings_opened_at`  BIGINT      NOT NULL DEFAULT 0,
  `savings_last_tick`  BIGINT      NOT NULL DEFAULT 0,
  `ui_brand`           VARCHAR(10) DEFAULT NULL,
  `created_at`         TIMESTAMP   DEFAULT CURRENT_TIMESTAMP,
  INDEX `idx_iban` (`iban`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

CREATE TABLE IF NOT EXISTS `apex_banking_sub_accounts` (
  `id`         INT AUTO_INCREMENT PRIMARY KEY,
  `iban`       VARCHAR(20) NOT NULL UNIQUE,
  `owner`      VARCHAR(60) NOT NULL,
  `owner_name` VARCHAR(80) NOT NULL,
  `label`      VARCHAR(60) NOT NULL,
  `balance`    BIGINT      NOT NULL DEFAULT 0,
  `created_at` TIMESTAMP   DEFAULT CURRENT_TIMESTAMP,
  INDEX `idx_owner` (`owner`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

CREATE TABLE IF NOT EXISTS `apex_banking_sub_partners` (
  `id`             INT AUTO_INCREMENT PRIMARY KEY,
  `sub_id`         INT         NOT NULL,
  `identifier`     VARCHAR(60) NOT NULL,
  `partner_name`   VARCHAR(80) NOT NULL,
  `perms`          TEXT        NOT NULL,
  `daily_limit`    BIGINT      NOT NULL DEFAULT 0,
  `daily_used`     BIGINT      NOT NULL DEFAULT 0,
  `daily_reset_at` BIGINT      NOT NULL DEFAULT 0,
  `added_at`       TIMESTAMP   DEFAULT CURRENT_TIMESTAMP,
  UNIQUE KEY `uq_sub_partner` (`sub_id`, `identifier`),
  INDEX `idx_partner` (`identifier`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

CREATE TABLE IF NOT EXISTS `apex_banking_cards` (
  `id`           INT AUTO_INCREMENT PRIMARY KEY,
  `serial`       VARCHAR(10) NOT NULL UNIQUE,
  `identifier`   VARCHAR(60) NOT NULL,
  `account_iban` VARCHAR(20) NOT NULL,
  `owner_name`   VARCHAR(80) NOT NULL,
  `frozen`       TINYINT(1)  NOT NULL DEFAULT 0,
  `issued_at`    TIMESTAMP   DEFAULT CURRENT_TIMESTAMP,
  INDEX `idx_owner` (`identifier`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

CREATE TABLE IF NOT EXISTS `apex_banking_transactions` (
  `id`         INT AUTO_INCREMENT PRIMARY KEY,
  `kind`       VARCHAR(24) NOT NULL,
  `from_iban`  VARCHAR(20) DEFAULT NULL,
  `to_iban`    VARCHAR(20) DEFAULT NULL,
  `amount`     BIGINT      NOT NULL,
  `fee`        BIGINT      NOT NULL DEFAULT 0,
  `label`      VARCHAR(80) DEFAULT NULL,
  `actor`      VARCHAR(80) DEFAULT NULL,
  `created_at` TIMESTAMP   DEFAULT CURRENT_TIMESTAMP,
  INDEX `idx_from` (`from_iban`, `created_at`),
  INDEX `idx_to`   (`to_iban`,   `created_at`),
  INDEX `idx_kind` (`kind`,      `created_at`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

CREATE TABLE IF NOT EXISTS `apex_banking_loans` (
  `id`         INT AUTO_INCREMENT PRIMARY KEY,
  `identifier` VARCHAR(60) NOT NULL,
  `amount`     BIGINT      NOT NULL,
  `interest`   BIGINT      NOT NULL,
  `remaining`  BIGINT      NOT NULL,
  `due_at`     BIGINT      NOT NULL,
  `created_at` TIMESTAMP   DEFAULT CURRENT_TIMESTAMP,
  `closed_at`  BIGINT      DEFAULT NULL,
  INDEX `idx_owner` (`identifier`, `closed_at`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- Admin-placed ATM props (/placeatm). Spawned for every player on
-- join and interactable exactly like map ATMs (same prop models).
CREATE TABLE IF NOT EXISTS `apex_banking_atms` (
  `id`         INT AUTO_INCREMENT PRIMARY KEY,
  `model`      VARCHAR(64) NOT NULL,
  `x`          DOUBLE      NOT NULL,
  `y`          DOUBLE      NOT NULL,
  `z`          DOUBLE      NOT NULL,
  `heading`    DOUBLE      NOT NULL DEFAULT 0,
  `created_by` VARCHAR(60) DEFAULT NULL,
  `created_at` TIMESTAMP   DEFAULT CURRENT_TIMESTAMP
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- Job / business treasuries. Auto-discovered from the framework's own
-- job tables on first start; per-grade wages and pay intervals are
-- stored as JSON so a grade can have its own cadence.
CREATE TABLE IF NOT EXISTS `apex_banking_business` (
  `job`          VARCHAR(50) NOT NULL PRIMARY KEY,
  `label`        VARCHAR(80) NOT NULL,
  `iban`         VARCHAR(20) NOT NULL DEFAULT '',
  `balance`      BIGINT      NOT NULL DEFAULT 0,
  `pay_interval` INT         NOT NULL DEFAULT 60,
  `next_pay_at`  BIGINT      NOT NULL DEFAULT 0,
  `wages`        TEXT        NOT NULL,
  `intervals`    TEXT        NOT NULL,
  UNIQUE KEY `uq_biz_iban` (`iban`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- Server-wide key/value settings: the appearance an admin broadcast
-- (theme, layout, colours), the feature switches and the ATM screen
-- calibration all live here as one JSON row each.
CREATE TABLE IF NOT EXISTS `apex_banking_settings` (
  `k`          VARCHAR(40) NOT NULL PRIMARY KEY,
  `v`          LONGTEXT    NOT NULL,
  `updated_at` TIMESTAMP   DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- Audit trail of everything staff did in /bankadmin. An admin money
-- edit that leaves no trace anywhere is how servers lose track of
-- their own economy.
CREATE TABLE IF NOT EXISTS `apex_banking_admin_log` (
  `id`          INT AUTO_INCREMENT PRIMARY KEY,
  `admin_id`    VARCHAR(60)  DEFAULT NULL,
  `admin_name`  VARCHAR(80)  DEFAULT NULL,
  `action`      VARCHAR(40)  NOT NULL,
  `target_id`   VARCHAR(60)  DEFAULT NULL,
  `target_name` VARCHAR(80)  DEFAULT NULL,
  `amount`      BIGINT       NOT NULL DEFAULT 0,
  `detail`      VARCHAR(255) DEFAULT NULL,
  `created_at`  TIMESTAMP    DEFAULT CURRENT_TIMESTAMP,
  INDEX `idx_admin_log_time` (`created_at`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
