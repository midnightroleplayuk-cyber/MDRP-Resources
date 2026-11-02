CREATE TABLE IF NOT EXISTS `av_dealerships` (
    `name` VARCHAR(32) NOT NULL,
    `label` VARCHAR(64) DEFAULT NULL,
    `job` VARCHAR(64) DEFAULT NULL,
    `funds` BIGINT DEFAULT 0,
    `monthly_goal` INT DEFAULT 0,
    `stats` LONGTEXT DEFAULT NULL,
    `email` VARCHAR(150) DEFAULT NULL,
    `upgrades` TEXT DEFAULT NULL,
    `is_open` TINYINT(1) DEFAULT 1,
    `offline_sales` TINYINT(1) DEFAULT 0,
    `offline_allowed` TINYINT(1) DEFAULT 0,
    `automatic` TINYINT(1) DEFAULT 0,
    `vip_only` TINYINT(1) DEFAULT 0,
    `last_seen` INT DEFAULT 0,
    `preowned` TINYINT(1) DEFAULT 0,
    `sprite` INT DEFAULT 326,
    `color` INT DEFAULT 3,
    `accounts` TEXT DEFAULT NULL,
    `theme` TEXT DEFAULT NULL,
    `webhooks` TEXT DEFAULT NULL,
    `scene` VARCHAR(32) DEFAULT NULL,
    `zones` LONGTEXT DEFAULT NULL,
    `created_at` TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    PRIMARY KEY (`name`)
);

CREATE TABLE IF NOT EXISTS `av_dealership_employees` (
    `id` INT AUTO_INCREMENT,
    `dealership` VARCHAR(32) NOT NULL,
    `identifier` VARCHAR(64) NOT NULL,
    `name` VARCHAR(64) DEFAULT NULL,
    `photo` VARCHAR(255) DEFAULT NULL,
    `permissions` TEXT DEFAULT NULL,
    `hired_at` VARCHAR(32) DEFAULT NULL,
    `sales` INT DEFAULT 0,
    `earnings` BIGINT DEFAULT 0,
    `points` INT DEFAULT 0,
    `points_month` VARCHAR(7) DEFAULT NULL,
    `grade` INT DEFAULT 0,
    `grade_label` VARCHAR(64) DEFAULT NULL,
    PRIMARY KEY (`id`),
    UNIQUE KEY `dealer_identifier` (`dealership`, `identifier`)
);

CREATE TABLE IF NOT EXISTS `av_dealership_vehicles` (
    `model` VARCHAR(64) NOT NULL,
    `label` VARCHAR(64) DEFAULT NULL,
    `category` VARCHAR(32) DEFAULT NULL,
    `base_price` BIGINT DEFAULT 0,
    `image` VARCHAR(255) DEFAULT NULL,
    `auction` TINYINT(1) DEFAULT 0,
    `warehouse` TINYINT(1) DEFAULT 0,
    `dealerships` TEXT DEFAULT NULL,
    `stats` LONGTEXT DEFAULT NULL,
    PRIMARY KEY (`model`)
);

CREATE TABLE IF NOT EXISTS `av_dealership_stock` (
    `id` INT AUTO_INCREMENT,
    `dealership` VARCHAR(32) NOT NULL,
    `model` VARCHAR(64) NOT NULL,
    `stock` INT DEFAULT 0,
    `price` BIGINT DEFAULT 0,
    PRIMARY KEY (`id`),
    UNIQUE KEY `dealer_model` (`dealership`, `model`)
);

CREATE TABLE IF NOT EXISTS `av_dealership_orders` (
    `id` VARCHAR(8) NOT NULL,
    `dealership` VARCHAR(32) NOT NULL,
    `items` LONGTEXT DEFAULT NULL,
    `units` INT DEFAULT 0,
    `cost` BIGINT DEFAULT 0,
    `status` VARCHAR(16) DEFAULT 'pending',
    `placed_by` VARCHAR(64) DEFAULT NULL,
    `at` VARCHAR(32) DEFAULT NULL,
    `ts` INT DEFAULT 0,
    PRIMARY KEY (`id`)
);

CREATE TABLE IF NOT EXISTS `av_dealership_transactions` (
    `id` INT AUTO_INCREMENT,
    `dealership` VARCHAR(32) NOT NULL,
    `kind` VARCHAR(16) DEFAULT NULL,
    `icon` VARCHAR(16) DEFAULT NULL,
    `title` VARCHAR(128) DEFAULT NULL,
    `by_name` VARCHAR(64) DEFAULT NULL,
    `by_identifier` VARCHAR(64) DEFAULT NULL,
    `amount` BIGINT DEFAULT NULL,
    `badge` VARCHAR(16) DEFAULT NULL,
    `at` VARCHAR(32) DEFAULT NULL,
    `ts` INT DEFAULT 0,
    PRIMARY KEY (`id`)
);

CREATE TABLE IF NOT EXISTS `av_rentals` (
    `id` INT NOT NULL AUTO_INCREMENT,
    `identifier` VARCHAR(100) DEFAULT NULL,
    `dealership` VARCHAR(100) DEFAULT NULL,
    `model` VARCHAR(50) DEFAULT NULL,
    `vehicle` VARCHAR(50) DEFAULT NULL,
    `plates` VARCHAR(50) DEFAULT NULL,
    `customer` VARCHAR(100) DEFAULT NULL,
    `phone` VARCHAR(100) DEFAULT NULL,
    `sellerName` VARCHAR(50) DEFAULT NULL,
    `days` INT DEFAULT NULL,
    `rented` VARCHAR(50) DEFAULT NULL,
    `expires` VARCHAR(50) DEFAULT NULL,
    `paid` VARCHAR(50) DEFAULT '0',
    `preowned` INT DEFAULT 0,
    `email` VARCHAR(150) DEFAULT NULL,
    PRIMARY KEY (`id`)
);

CREATE TABLE IF NOT EXISTS `av_financing` (
    `id` INT NOT NULL AUTO_INCREMENT,
    `identifier` VARCHAR(50) DEFAULT NULL,
    `dealership` VARCHAR(50) DEFAULT NULL,
    `plates` VARCHAR(50) DEFAULT NULL,
    `customer` VARCHAR(50) DEFAULT NULL,
    `phone` VARCHAR(50) DEFAULT NULL,
    `vehicle` VARCHAR(50) DEFAULT NULL,
    `model` VARCHAR(50) DEFAULT NULL,
    `paid` VARCHAR(50) DEFAULT NULL,
    `totalPrice` VARCHAR(50) DEFAULT NULL,
    `payments` VARCHAR(50) DEFAULT NULL,
    `lastPayment` VARCHAR(50) DEFAULT NULL,
    `seller` VARCHAR(50) DEFAULT NULL,
    `sellerName` VARCHAR(50) DEFAULT NULL,
    `email` VARCHAR(150) DEFAULT NULL,
    PRIMARY KEY (`id`),
    KEY `fin_identifier` (`identifier`),
    KEY `fin_dealership` (`dealership`)
);

CREATE TABLE IF NOT EXISTS `av_civil_auctions` (
    `id` INT NOT NULL AUTO_INCREMENT,
    `dealership` VARCHAR(32) NOT NULL,
    `model` VARCHAR(64) NOT NULL,
    `min_price` BIGINT DEFAULT 0,
    `bid` BIGINT DEFAULT 0,
    `bidder` VARCHAR(64) DEFAULT NULL,
    `bidder_name` VARCHAR(64) DEFAULT NULL,
    `created_by` VARCHAR(64) DEFAULT NULL,
    `ends_at` INT DEFAULT 0,
    `status` VARCHAR(16) DEFAULT 'active',
    PRIMARY KEY (`id`),
    KEY `civil_dealership` (`dealership`),
    KEY `civil_status` (`status`)
);

CREATE TABLE IF NOT EXISTS `av_civil_auction_log` (
    `id` INT NOT NULL AUTO_INCREMENT,
    `identifier` VARCHAR(64) NOT NULL,
    `kind` VARCHAR(16) NOT NULL,
    `vehicle` VARCHAR(64) DEFAULT NULL,
    `dealership` VARCHAR(64) DEFAULT NULL,
    `amount` BIGINT DEFAULT 0,
    `at` VARCHAR(32) DEFAULT NULL,
    `ts` INT DEFAULT 0,
    PRIMARY KEY (`id`),
    KEY `auction_log_identifier` (`identifier`)
);

CREATE TABLE IF NOT EXISTS `av_dealership_posts` (
    `id` INT NOT NULL AUTO_INCREMENT,
    `dealership` VARCHAR(32) NOT NULL,
    `title` VARCHAR(64) NOT NULL,
    `body` VARCHAR(400) NOT NULL,
    `author` VARCHAR(64) DEFAULT NULL,
    `ends_at` INT DEFAULT 0,
    `ts` INT DEFAULT 0,
    PRIMARY KEY (`id`),
    KEY `posts_dealership` (`dealership`)
);

CREATE TABLE IF NOT EXISTS `av_motors_profiles` (
    `identifier` VARCHAR(64) NOT NULL,
    `alias` VARCHAR(24) DEFAULT NULL,
    `theme` VARCHAR(9) DEFAULT NULL,
    PRIMARY KEY (`identifier`)
);

CREATE TABLE IF NOT EXISTS `av_society` (
  `job` varchar(50) DEFAULT NULL,
  `money` varchar(50) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

CREATE TABLE IF NOT EXISTS `av_vehicle_history` (
    `id` INT NOT NULL AUTO_INCREMENT,
    `plates` VARCHAR(50) NOT NULL,
    `kind` VARCHAR(24) NOT NULL,
    `detail` VARCHAR(128) DEFAULT NULL,
    `dealership` VARCHAR(64) DEFAULT NULL,
    `at` VARCHAR(32) DEFAULT NULL,
    `ts` INT DEFAULT 0,
    PRIMARY KEY (`id`),
    KEY `history_plates` (`plates`)
);

CREATE TABLE IF NOT EXISTS `av_vehicle_policies` (
    `id` INT NOT NULL AUTO_INCREMENT,
    `identifier` VARCHAR(64) NOT NULL,
    `dealership` VARCHAR(32) NOT NULL,
    `plates` VARCHAR(50) NOT NULL,
    `model` VARCHAR(64) DEFAULT NULL,
    `vehicle` VARCHAR(64) DEFAULT NULL,
    `insured_value` BIGINT DEFAULT 0,
    `deductible_pct` INT DEFAULT 20,
    `expires_at` INT DEFAULT 0,
    `status` VARCHAR(12) DEFAULT 'active',
    `ts` INT DEFAULT 0,
    PRIMARY KEY (`id`),
    KEY `policies_identifier` (`identifier`),
    KEY `policies_plates` (`plates`)
);

CREATE TABLE IF NOT EXISTS `av_dealership_ratings` (
    `id` INT NOT NULL AUTO_INCREMENT,
    `dealership` VARCHAR(32) NOT NULL,
    `identifier` VARCHAR(64) NOT NULL,
    `stars` INT NOT NULL,
    `ts` INT DEFAULT 0,
    PRIMARY KEY (`id`),
    KEY `ratings_dealership` (`dealership`)
);

ALTER TABLE `av_dealerships` ADD COLUMN IF NOT EXISTS `instant_delivery` TINYINT(1) DEFAULT 0;
