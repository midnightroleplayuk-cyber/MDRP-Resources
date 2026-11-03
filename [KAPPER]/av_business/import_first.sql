CREATE TABLE IF NOT EXISTS `av_items` (
  `job` varchar(50) NOT NULL,
  `name` varchar(50) NOT NULL,
  `label` varchar(50) DEFAULT NULL,
  `type` varchar(50) DEFAULT NULL,
  `image` longtext DEFAULT NULL,
  `description` varchar(50) DEFAULT NULL,
  `weight` varchar(50) DEFAULT NULL,
  `ingredients` longtext DEFAULT NULL,
  `prop` varchar(50) DEFAULT NULL,
  `price` int(11) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

CREATE TABLE IF NOT EXISTS `av_business` (
  `name` varchar(50) NOT NULL,
  `job` varchar(50) DEFAULT NULL,
  `type` varchar(50) DEFAULT NULL,
  `data` longtext DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

CREATE TABLE IF NOT EXISTS `av_society` (
  `job` varchar(50) DEFAULT NULL,
  `money` varchar(50) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

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
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

CREATE TABLE IF NOT EXISTS `av_business_discounts` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `code` varchar(50) NOT NULL,
  `job` varchar(50) NOT NULL,
  `discount` int(11) NOT NULL,
  `description` text DEFAULT NULL,
  `type` enum('percentage','amount') NOT NULL,
  `generated` int(11) NOT NULL,
  `employee` varchar(60) NOT NULL,
  `limit` int(11) DEFAULT NULL,
  `expires` int(11) DEFAULT NULL,
  `redeemed` int(11) DEFAULT 0,
  `enabled` tinyint(1) DEFAULT 1,
  PRIMARY KEY (`id`),
  KEY `job` (`job`),
  KEY `code_index` (`code`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

ALTER TABLE av_items 
ADD COLUMN cashier INT DEFAULT 1;

CREATE TABLE IF NOT EXISTS `av_pawnshops` (
    `id` INT NOT NULL AUTO_INCREMENT,
    `pawnshop_name` VARCHAR(50) NOT NULL,
    `item_name` VARCHAR(50) NOT NULL,
    `stock` INT DEFAULT 0,
    PRIMARY KEY (`id`),
    UNIQUE KEY `unique_item_per_shop` (`pawnshop_name`, `item_name`)
);

CREATE TABLE IF NOT EXISTS `av_business_counter` (
    `id` INT NOT NULL AUTO_INCREMENT,
    `business` VARCHAR(50) NOT NULL,
    `item` VARCHAR(50) NOT NULL,
    `stock` INT NOT NULL DEFAULT 0,
    `price` INT NOT NULL DEFAULT 0,
    PRIMARY KEY (`id`),
    UNIQUE KEY `unique_item_per_business` (`business`, `item`)
);
CREATE TABLE IF NOT EXISTS `av_business_bills` (
  `job` VARCHAR(50) NOT NULL,
  `dirt` FLOAT DEFAULT 0,
  `gas_pending` FLOAT DEFAULT 0,
  `electricity_pending` FLOAT DEFAULT 0,
  `water_pending` FLOAT DEFAULT 0,
  `gas_last_paid` BIGINT DEFAULT 0,
  `electricity_last_paid` BIGINT DEFAULT 0,
  `water_last_paid` BIGINT DEFAULT 0,
  `rent_enabled` TINYINT DEFAULT 0,
  `rent_amount` FLOAT DEFAULT 0,
  `rent_interval` INT DEFAULT 7,
  `rent_last_paid` BIGINT DEFAULT 0,
  `tax_rate` FLOAT DEFAULT 0,
  `tax_pending` INT DEFAULT 0,
  `tax_last_paid` BIGINT DEFAULT 0,
  PRIMARY KEY (`job`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

CREATE TABLE IF NOT EXISTS `av_business_promos` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `job` varchar(50) NOT NULL,
  `label` varchar(100) NOT NULL,
  `description` text DEFAULT NULL,
  `type` enum('percentage','amount') NOT NULL,
  `discount` int(11) NOT NULL,
  `starts_at` int(11) NOT NULL,
  `ends_at` int(11) DEFAULT NULL,
  `enabled` tinyint(1) DEFAULT 1,
  PRIMARY KEY (`id`),
  KEY `job` (`job`),
  KEY `active_promo` (`job`, `enabled`, `starts_at`, `ends_at`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

CREATE TABLE IF NOT EXISTS `av_loyalty_promos` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `job` varchar(50) NOT NULL,
  `name` varchar(100) NOT NULL,
  `image` longtext DEFAULT NULL,
  `required_visits` int(11) NOT NULL DEFAULT 10,
  `discount` int(11) NOT NULL,
  `discount_type` enum('percentage','amount') NOT NULL DEFAULT 'percentage',
  `max_prints` int(11) DEFAULT NULL,
  `visit_cooldown` int(11) NOT NULL DEFAULT 3600,
  `active` tinyint(1) DEFAULT 1,
  `created_at` int(11) NOT NULL,
  PRIMARY KEY (`id`),
  KEY `job` (`job`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

CREATE TABLE IF NOT EXISTS `av_loyalty_cards` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `serial` varchar(20) NOT NULL,
  `promo_id` int(11) NOT NULL,
  `job` varchar(50) NOT NULL,
  `visits` int(11) NOT NULL DEFAULT 0,
  `last_visit` int(11) DEFAULT NULL,
  `redeemed` tinyint(1) DEFAULT 0,
  `redeemed_at` int(11) DEFAULT NULL,
  `printed_at` int(11) NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `serial` (`serial`),
  KEY `promo_id` (`promo_id`),
  KEY `job_idx` (`job`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;