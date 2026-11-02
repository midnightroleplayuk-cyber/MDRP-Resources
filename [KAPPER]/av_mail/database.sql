CREATE TABLE IF NOT EXISTS `av_mail_domains` (
    `id` INT NOT NULL AUTO_INCREMENT,
    `domain` VARCHAR(100) NOT NULL,
    `owner_identifier` VARCHAR(100) DEFAULT NULL,
    `price` INT NOT NULL DEFAULT 0,
    `is_default` TINYINT(1) NOT NULL DEFAULT 0,
    `created_at` TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    PRIMARY KEY (`id`),
    UNIQUE KEY `uq_domain` (`domain`),
    KEY `idx_owner` (`owner_identifier`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

CREATE TABLE IF NOT EXISTS `av_mail_accounts` (
    `id` INT NOT NULL AUTO_INCREMENT,
    `address` VARCHAR(150) NOT NULL,
    `username` VARCHAR(64) NOT NULL,
    `domain` VARCHAR(100) NOT NULL,
    `password_hash` VARCHAR(64) NOT NULL,
    `salt` VARCHAR(32) NOT NULL,
    `owner_identifier` VARCHAR(100) DEFAULT NULL,
    `created_by` VARCHAR(100) DEFAULT NULL,
    `display_name` VARCHAR(64) NOT NULL,
    `avatar` VARCHAR(255) DEFAULT NULL,
    `created_at` TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    `last_login` TIMESTAMP NULL DEFAULT NULL,
    PRIMARY KEY (`id`),
    UNIQUE KEY `uq_address` (`address`),
    KEY `idx_owner` (`owner_identifier`),
    KEY `idx_domain` (`domain`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

CREATE TABLE IF NOT EXISTS `av_mail_messages` (
    `id` INT NOT NULL AUTO_INCREMENT,
    `from_address` VARCHAR(150) NOT NULL,
    `subject` VARCHAR(255) DEFAULT NULL,
    `body` TEXT,
    `created_at` TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    PRIMARY KEY (`id`),
    KEY `idx_from` (`from_address`),
    KEY `idx_created` (`created_at`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

CREATE TABLE IF NOT EXISTS `av_mail_items` (
    `id` INT NOT NULL AUTO_INCREMENT,
    `message_id` INT NOT NULL,
    `account_id` INT NOT NULL,
    `box` ENUM('inbox','sent','trash') NOT NULL DEFAULT 'inbox',
    `is_read` TINYINT(1) NOT NULL DEFAULT 0,
    `is_starred` TINYINT(1) NOT NULL DEFAULT 0,
    `created_at` TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    PRIMARY KEY (`id`),
    KEY `idx_account_box` (`account_id`, `box`),
    KEY `idx_message` (`message_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

CREATE TABLE IF NOT EXISTS `av_mail_attachments` (
    `id` INT NOT NULL AUTO_INCREMENT,
    `message_id` INT NOT NULL,
    `file_id` VARCHAR(50) NOT NULL,
    `device_serial` VARCHAR(50) NOT NULL,
    `name` VARCHAR(100) NOT NULL,
    `type` ENUM('image','video','document') NOT NULL,
    `url` TEXT,
    PRIMARY KEY (`id`),
    KEY `idx_message` (`message_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

CREATE TABLE IF NOT EXISTS `av_mail_contacts` (
    `id` INT NOT NULL AUTO_INCREMENT,
    `account_id` INT NOT NULL,
    `name` VARCHAR(64) NOT NULL,
    `email` VARCHAR(150) NOT NULL,
    `created_at` TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    PRIMARY KEY (`id`),
    KEY `idx_account` (`account_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;
