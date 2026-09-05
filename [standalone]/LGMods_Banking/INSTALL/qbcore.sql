ALTER TABLE `players` ADD COLUMN `sortcode` varchar(255) NULL DEFAULT NULL;
ALTER TABLE `players` ADD COLUMN `accountnumber` varchar(255) NULL DEFAULT NULL;
ALTER TABLE `players` ADD COLUMN `pinnumber` int(50) NULL DEFAULT NULL;
ALTER TABLE `players` ADD COLUMN `debitcardnumber` int(50) NULL DEFAULT NULL;
ALTER TABLE `players` ADD COLUMN IF NOT EXISTS `credit_score` INT DEFAULT 650;
ALTER TABLE players MODIFY COLUMN debitcardnumber VARCHAR(20);

CREATE TABLE IF NOT EXISTS `lgmods_joint_accounts` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `name` varchar(255) NOT NULL,
  `balance` int(11) NOT NULL DEFAULT 0,
  `admin_citizen_id` varchar(50) NOT NULL,
  `created_at` timestamp NOT NULL DEFAULT current_timestamp(),
  PRIMARY KEY (`id`)
);

CREATE TABLE IF NOT EXISTS `lgmods_joint_account_members` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `account_id` int(11) NOT NULL,
  `citizen_id` varchar(50) NOT NULL,
  `is_admin` tinyint(1) NOT NULL DEFAULT 0,
  `added_at` timestamp NOT NULL DEFAULT current_timestamp(),
  PRIMARY KEY (`id`),
  UNIQUE KEY `unique_member` (`account_id`, `citizen_id`),
  FOREIGN KEY (`account_id`) REFERENCES `lgmods_joint_accounts`(`id`) ON DELETE CASCADE
);

CREATE TABLE IF NOT EXISTS `lgmods_joint_account_invites` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `account_id` int(11) NOT NULL,
  `sender_citizen_id` varchar(50) NOT NULL,
  `recipient_citizen_id` varchar(50) NOT NULL,
  `created_at` timestamp NOT NULL DEFAULT current_timestamp(),
  PRIMARY KEY (`id`),
  UNIQUE KEY `unique_invite` (`account_id`, `recipient_citizen_id`),
  FOREIGN KEY (`account_id`) REFERENCES `lgmods_joint_accounts`(`id`) ON DELETE CASCADE
);
