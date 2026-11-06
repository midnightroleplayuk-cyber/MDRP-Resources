CREATE TABLE IF NOT EXISTS `av_banking_accounts` (
  `id` INT NOT NULL AUTO_INCREMENT,
  `account_number` VARCHAR(24) NOT NULL,
  `label` VARCHAR(60) NOT NULL DEFAULT 'PERSONAL',
  `type` VARCHAR(20) NOT NULL DEFAULT 'personal',
  `owner` VARCHAR(64) NOT NULL,
  `owner_name` VARCHAR(64) DEFAULT '',
  `balance` BIGINT NOT NULL DEFAULT 0,
  `frozen` TINYINT(1) NOT NULL DEFAULT 0,
  `created_at` TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `native` TINYINT DEFAULT 0,
  `offshore` TINYINT DEFAULT 0,
  `last_tax` DATETIME DEFAULT NULL,
  `od_interest_at` DATETIME DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `account_number` (`account_number`),
  KEY `owner` (`owner`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

CREATE TABLE IF NOT EXISTS `av_banking_access` (
  `id` INT NOT NULL AUTO_INCREMENT,
  `account_id` INT NOT NULL,
  `identifier` VARCHAR(64) NOT NULL,
  `name` VARCHAR(64) DEFAULT '',
  `role` VARCHAR(20) NOT NULL DEFAULT 'member',
  `permissions` LONGTEXT DEFAULT '{}',
  `created_at` TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  UNIQUE KEY `account_identifier` (`account_id`, `identifier`),
  KEY `identifier` (`identifier`),
  CONSTRAINT `fk_access_account` FOREIGN KEY (`account_id`) REFERENCES `av_banking_accounts` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

CREATE TABLE IF NOT EXISTS `av_banking_transactions` (
  `id` INT NOT NULL AUTO_INCREMENT,
  `account_id` INT NOT NULL,
  `type` VARCHAR(20) NOT NULL,
  `amount` BIGINT NOT NULL,
  `balance_after` BIGINT NOT NULL DEFAULT 0,
  `description` VARCHAR(120) DEFAULT '',
  `actor` VARCHAR(64) DEFAULT '',
  `actor_name` VARCHAR(64) DEFAULT '',
  `target_account` VARCHAR(24) DEFAULT NULL,
  `reference` VARCHAR(30) NOT NULL,
  `created_at` TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  KEY `account_id` (`account_id`),
  KEY `created_at` (`created_at`),
  CONSTRAINT `fk_tx_account` FOREIGN KEY (`account_id`) REFERENCES `av_banking_accounts` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

CREATE TABLE IF NOT EXISTS `av_banking_cards` (
  `id` INT NOT NULL AUTO_INCREMENT,
  `account_id` INT NOT NULL,
  `holder` VARCHAR(64) NOT NULL,
  `holder_name` VARCHAR(64) DEFAULT '',
  `card_number` VARCHAR(20) NOT NULL,
  `card_type` VARCHAR(30) NOT NULL DEFAULT 'debit_standard',
  `expiry` VARCHAR(5) NOT NULL,
  `frozen` TINYINT(1) NOT NULL DEFAULT 0,
  `daily_limit` INT NOT NULL DEFAULT 5000,
  `spent_today` INT NOT NULL DEFAULT 0,
  `spent_date` DATE DEFAULT NULL,
  `credit_limit` BIGINT NOT NULL DEFAULT 0,
  `credit_used` BIGINT NOT NULL DEFAULT 0,
  `created_at` TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `skin_url` VARCHAR(300) DEFAULT NULL,
  `credit_due_at` DATETIME DEFAULT NULL,
  `credit_missed` INT NOT NULL DEFAULT 0,
  `credit_cash_used` BIGINT NOT NULL DEFAULT 0,
  `stolen_today` BIGINT NOT NULL DEFAULT 0,
  `stolen_date` DATE DEFAULT NULL,
  `atm_pin` VARCHAR(10) DEFAULT NULL,
  `atm_attempts` TINYINT NOT NULL DEFAULT 0,
  `atm_locked_until` DATETIME DEFAULT NULL,
  `uid` VARCHAR(24) DEFAULT NULL,
  `last_used` DATETIME DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `card_number` (`card_number`),
  UNIQUE KEY `uid` (`uid`),
  KEY `account_id` (`account_id`),
  KEY `holder` (`holder`),
  CONSTRAINT `fk_card_account` FOREIGN KEY (`account_id`) REFERENCES `av_banking_accounts` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

CREATE TABLE IF NOT EXISTS `av_banking_loans` (
  `id` INT NOT NULL AUTO_INCREMENT,
  `account_id` INT NOT NULL,
  `identifier` VARCHAR(64) NOT NULL,
  `name` VARCHAR(64) DEFAULT '',
  `label` VARCHAR(60) DEFAULT 'Loan',
  `principal` BIGINT NOT NULL,
  `interest` DECIMAL(5,2) NOT NULL DEFAULT 0,
  `total` BIGINT NOT NULL,
  `paid` BIGINT NOT NULL DEFAULT 0,
  `installment` BIGINT NOT NULL,
  `next_due` DATETIME DEFAULT NULL,
  `missed` INT NOT NULL DEFAULT 0,
  `status` VARCHAR(20) NOT NULL DEFAULT 'active',
  `created_at` TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `reminded_at` DATETIME DEFAULT NULL,
  `loan_type` VARCHAR(20) DEFAULT 'personal',
  PRIMARY KEY (`id`),
  KEY `account_id` (`account_id`),
  KEY `identifier` (`identifier`),
  CONSTRAINT `fk_loan_account` FOREIGN KEY (`account_id`) REFERENCES `av_banking_accounts` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

CREATE TABLE IF NOT EXISTS `av_billing` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `invoiceid` varchar(100) DEFAULT NULL,
  `customerIdentifier` varchar(100) DEFAULT NULL,
  `customerName` varchar(100) DEFAULT NULL,
  `customerPhone` varchar(100) DEFAULT NULL,
  `senderName` varchar(100) DEFAULT NULL,
  `senderIdentifier` varchar(100) DEFAULT NULL,
  `society` varchar(100) DEFAULT NULL,
  `amount` int(11) DEFAULT 0,
  `title` varchar(100) DEFAULT NULL,
  `description` longtext DEFAULT '{}',
  `issued` varchar(50) DEFAULT NULL,
  `paid` tinyint(4) DEFAULT 0,
  `reference` VARCHAR(30) DEFAULT NULL,
  `status` VARCHAR(20) DEFAULT NULL,
  `due_at` DATETIME DEFAULT NULL,
  `paid_at` DATETIME DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `customerIdentifier` (`customerIdentifier`),
  KEY `senderIdentifier` (`senderIdentifier`),
  KEY `society` (`society`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

CREATE TABLE IF NOT EXISTS `av_banking_savings` (
  `id` INT NOT NULL AUTO_INCREMENT,
  `identifier` VARCHAR(64) NOT NULL,
  `label` VARCHAR(40) NOT NULL,
  `icon` VARCHAR(16) DEFAULT '💰',
  `target` BIGINT NOT NULL DEFAULT 0,
  `saved` BIGINT NOT NULL DEFAULT 0,
  `deadline` DATE DEFAULT NULL,
  `created_at` TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `interest_paid` BIGINT DEFAULT 0,
  `last_interest` DATETIME DEFAULT NULL,
  `lock_days` INT DEFAULT 0,
  `locked_until` DATETIME DEFAULT NULL,
  `lock_interest` BIGINT DEFAULT 0,
  PRIMARY KEY (`id`),
  KEY `identifier` (`identifier`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

CREATE TABLE IF NOT EXISTS `av_banking_p2p` (
  `id` INT NOT NULL AUTO_INCREMENT,
  `from_identifier` VARCHAR(64) NOT NULL,
  `from_name` VARCHAR(64) DEFAULT '',
  `to_identifier` VARCHAR(64) NOT NULL,
  `to_name` VARCHAR(64) DEFAULT '',
  `account_id` INT NOT NULL,
  `amount` BIGINT NOT NULL,
  `note` VARCHAR(120) DEFAULT '',
  `status` VARCHAR(20) NOT NULL DEFAULT 'pending',
  `created_at` TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `resolved_at` DATETIME DEFAULT NULL,
  `from_hidden` TINYINT(1) NOT NULL DEFAULT 0,
  `to_hidden` TINYINT(1) NOT NULL DEFAULT 0,
  PRIMARY KEY (`id`),
  KEY `to_identifier` (`to_identifier`),
  KEY `from_identifier` (`from_identifier`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

CREATE TABLE IF NOT EXISTS `av_banking_prefs` (
  `identifier` VARCHAR(64) NOT NULL,
  `theme` VARCHAR(20) DEFAULT NULL,
  `email` VARCHAR(100) DEFAULT NULL,
  `mail_prefs` LONGTEXT DEFAULT NULL,
  `webhook` VARCHAR(200) DEFAULT NULL,
  `favorite_account` INT DEFAULT NULL,
  `last_report` DATETIME DEFAULT NULL,
  `stock_sold_today` BIGINT DEFAULT 0,
  `stock_sold_date` DATE DEFAULT NULL,
  `tier_clearance` TINYINT DEFAULT NULL,
  `transferred_today` BIGINT DEFAULT 0,
  `transferred_date` DATE DEFAULT NULL,
  `show_skins` TINYINT(1) NOT NULL DEFAULT 0,
  PRIMARY KEY (`identifier`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

CREATE TABLE IF NOT EXISTS `av_banking_requests` (
  `id` INT NOT NULL AUTO_INCREMENT,
  `type` VARCHAR(20) NOT NULL,
  `identifier` VARCHAR(64) NOT NULL,
  `name` VARCHAR(64) DEFAULT '',
  `account_id` INT DEFAULT NULL,
  `data` LONGTEXT DEFAULT '{}',
  `status` VARCHAR(20) NOT NULL DEFAULT 'pending',
  `note` VARCHAR(200) DEFAULT '',
  `reviewed_by` VARCHAR(64) DEFAULT '',
  `created_at` TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `reviewed_at` DATETIME DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `status` (`status`),
  KEY `identifier` (`identifier`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

CREATE TABLE IF NOT EXISTS `av_banking_staff` (
  `id` INT NOT NULL AUTO_INCREMENT,
  `identifier` VARCHAR(64) NOT NULL,
  `name` VARCHAR(64) DEFAULT '',
  `permissions` LONGTEXT DEFAULT '{}',
  `created_at` TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  UNIQUE KEY `identifier` (`identifier`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

CREATE TABLE IF NOT EXISTS `av_banking_staff_log` (
  `id` INT NOT NULL AUTO_INCREMENT,
  `identifier` VARCHAR(64) NOT NULL,
  `name` VARCHAR(64) DEFAULT '',
  `action` VARCHAR(40) NOT NULL,
  `target` VARCHAR(64) DEFAULT '',
  `detail` VARCHAR(200) DEFAULT '',
  `created_at` TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  KEY `identifier` (`identifier`),
  KEY `created_at` (`created_at`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

CREATE TABLE IF NOT EXISTS `av_banking_contacts` (
  `id` INT NOT NULL AUTO_INCREMENT,
  `identifier` VARCHAR(64) NOT NULL,
  `label` VARCHAR(40) NOT NULL,
  `account_number` VARCHAR(20) NOT NULL,
  `created_at` TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  KEY `identifier` (`identifier`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

CREATE TABLE IF NOT EXISTS `av_banking_stocks` (
  `symbol` VARCHAR(10) NOT NULL,
  `price` DECIMAL(12,2) NOT NULL DEFAULT 0,
  `open_price` DECIMAL(12,2) NOT NULL DEFAULT 0,
  `open_date` DATE DEFAULT NULL,
  `fair_value` DECIMAL(12,2) NOT NULL DEFAULT 0,
  `trend` DECIMAL(8,5) NOT NULL DEFAULT 0,
  `trend_ticks` INT NOT NULL DEFAULT 0,
  `history` LONGTEXT DEFAULT '[]',
  `updated_at` TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`symbol`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

CREATE TABLE IF NOT EXISTS `av_banking_holdings` (
  `id` INT NOT NULL AUTO_INCREMENT,
  `identifier` VARCHAR(64) NOT NULL,
  `symbol` VARCHAR(10) NOT NULL,
  `shares` INT NOT NULL DEFAULT 0,
  `invested` BIGINT NOT NULL DEFAULT 0,
  PRIMARY KEY (`id`),
  UNIQUE KEY `owner_symbol` (`identifier`, `symbol`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

CREATE TABLE IF NOT EXISTS `av_banking_alerts` (
  `id` INT NOT NULL AUTO_INCREMENT,
  `identifier` VARCHAR(64) NOT NULL,
  `type` VARCHAR(24) NOT NULL,
  `card_id` INT DEFAULT NULL,
  `card_number` VARCHAR(24) DEFAULT NULL,
  `account_number` VARCHAR(24) DEFAULT NULL,
  `amount` BIGINT NOT NULL DEFAULT 0,
  `detail` VARCHAR(200) DEFAULT '',
  `seen` TINYINT(1) NOT NULL DEFAULT 0,
  `created_at` TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  KEY `identifier` (`identifier`),
  KEY `seen` (`seen`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

CREATE TABLE IF NOT EXISTS `av_banking_card_orders` (
  `id` INT NOT NULL AUTO_INCREMENT,
  `identifier` VARCHAR(64) NOT NULL,
  `account_id` INT NOT NULL,
  `account_number` VARCHAR(24) NOT NULL,
  `cost` INT NOT NULL DEFAULT 0,
  `card_id` INT DEFAULT NULL,
  `card_number` VARCHAR(24) DEFAULT NULL,
  `card_type` VARCHAR(32) DEFAULT NULL,
  `created_at` TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `delivered_at` DATETIME DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `identifier` (`identifier`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

CREATE TABLE IF NOT EXISTS `av_banking_standing_orders` (
  `id` INT NOT NULL AUTO_INCREMENT,
  `account_id` INT NOT NULL,
  `to_account_number` VARCHAR(24) NOT NULL,
  `to_label` VARCHAR(60) DEFAULT '',
  `amount` BIGINT NOT NULL,
  `every_days` INT NOT NULL DEFAULT 7,
  `label` VARCHAR(60) DEFAULT '',
  `next_run` DATETIME NOT NULL,
  `runs_left` INT DEFAULT NULL,
  `active` TINYINT(1) NOT NULL DEFAULT 1,
  `fail_count` TINYINT NOT NULL DEFAULT 0,
  `last_run` DATETIME DEFAULT NULL,
  `created_at` TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  KEY `account_id` (`account_id`),
  KEY `next_run` (`next_run`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

CREATE TABLE IF NOT EXISTS `av_banking_branches` (
  `id` INT NOT NULL AUTO_INCREMENT,
  `label` VARCHAR(50) NOT NULL,
  `desks` LONGTEXT DEFAULT NULL,
  `printers` LONGTEXT DEFAULT NULL,
  `blip_x` DOUBLE DEFAULT NULL,
  `blip_y` DOUBLE DEFAULT NULL,
  `blip_z` DOUBLE DEFAULT NULL,
  `blip_sprite` INT DEFAULT 108,
  `blip_color` INT DEFAULT 4,
  `created_at` TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `offshore` TINYINT DEFAULT 0,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

CREATE TABLE IF NOT EXISTS `av_banking_atms` (
  `id` INT NOT NULL AUTO_INCREMENT,
  `x` DOUBLE NOT NULL,
  `y` DOUBLE NOT NULL,
  `z` DOUBLE NOT NULL,
  `radius` DOUBLE NOT NULL DEFAULT 1.5,
  `created_at` TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

CREATE TABLE IF NOT EXISTS `av_banking_holds` (
  `id` INT NOT NULL AUTO_INCREMENT,
  `account_id` INT NOT NULL,
  `source_account_id` INT DEFAULT NULL,
  `source_type` VARCHAR(16) NOT NULL DEFAULT 'cash',
  `identifier` VARCHAR(64) NOT NULL,
  `actor_name` VARCHAR(100) DEFAULT '',
  `amount` INT NOT NULL,
  `fee` INT NOT NULL DEFAULT 0,
  `reason` VARCHAR(30) NOT NULL,
  `detail` VARCHAR(200) DEFAULT '',
  `status` VARCHAR(10) NOT NULL DEFAULT 'held',
  `outcome` VARCHAR(16) DEFAULT NULL,
  `resolved_by` VARCHAR(100) DEFAULT NULL,
  `created_at` TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `expires_at` DATETIME DEFAULT NULL,
  `resolved_at` DATETIME DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `holds_status` (`status`),
  KEY `holds_account` (`account_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

CREATE TABLE IF NOT EXISTS `av_banking_atm_state` (
  `id` INT NOT NULL AUTO_INCREMENT,
  `x` DOUBLE NOT NULL,
  `y` DOUBLE NOT NULL,
  `z` DOUBLE NOT NULL,
  `robbed_until` DATETIME DEFAULT NULL,
  `disabled_until` DATETIME DEFAULT NULL,
  `robbed_count` INT NOT NULL DEFAULT 0,
  `updated_at` TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- Personal accounts: normalize default-style labels on insert.
-- Single-statement trigger: no DELIMITER or BEGIN/END required.
-- The accounts table already declares label DEFAULT 'PERSONAL'.
DROP TRIGGER IF EXISTS `av_banking_default_personal_label`;
CREATE TRIGGER `av_banking_default_personal_label`
BEFORE INSERT ON `av_banking_accounts`
FOR EACH ROW
SET NEW.`label` = IF(
  LOWER(TRIM(COALESCE(NEW.`type`, ''))) = 'personal'
  AND LOWER(TRIM(COALESCE(NEW.`label`, ''))) IN ('', 'checking', 'bank account - personal', 'personal'),
  'PERSONAL',
  NEW.`label`
);
