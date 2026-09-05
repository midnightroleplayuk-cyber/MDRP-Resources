ALTER TABLE `users` ADD COLUMN IF NOT EXISTS `sortcode` varchar(255) NULL DEFAULT NULL;
ALTER TABLE `users` ADD COLUMN IF NOT EXISTS `accountnumber` varchar(255) NULL DEFAULT NULL;
ALTER TABLE `users` ADD COLUMN IF NOT EXISTS `pinnumber` int(50) NULL DEFAULT NULL;
ALTER TABLE `users` ADD COLUMN IF NOT EXISTS `debitcardnumber` VARCHAR(20) NULL DEFAULT NULL;

ALTER TABLE `users` MODIFY COLUMN `debitcardnumber` VARCHAR(20);

CREATE TABLE IF NOT EXISTS `lgmods_joint_accounts` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `name` varchar(255) NOT NULL,
  `balance` int(11) NOT NULL DEFAULT 0,
  `sortcode` varchar(10) DEFAULT NULL,
  `accountnumber` varchar(10) DEFAULT NULL,
  `admin_identifier` varchar(60) NOT NULL,
  `created_at` timestamp NOT NULL DEFAULT current_timestamp(),
  PRIMARY KEY (`id`)
);

CREATE TABLE IF NOT EXISTS `lgmods_joint_account_members` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `account_id` int(11) NOT NULL,
  `identifier` varchar(60) NOT NULL,
  `is_admin` tinyint(1) NOT NULL DEFAULT 0,
  `added_at` timestamp NOT NULL DEFAULT current_timestamp(),
  PRIMARY KEY (`id`),
  UNIQUE KEY `unique_member` (`account_id`, `identifier`)
);

CREATE TABLE IF NOT EXISTS `lgmods_joint_account_invites` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `account_id` int(11) NOT NULL,
  `sender_identifier` varchar(60) NOT NULL,
  `recipient_identifier` varchar(60) NOT NULL,
  `created_at` timestamp NOT NULL DEFAULT current_timestamp(),
  PRIMARY KEY (`id`),
  UNIQUE KEY `unique_invite` (`account_id`, `recipient_identifier`)
);

ALTER TABLE `lgmods_joint_account_members` 
ADD COLUMN IF NOT EXISTS `is_admin` tinyint(1) NOT NULL DEFAULT 0;

ALTER TABLE `lgmods_joint_accounts` 
ADD COLUMN IF NOT EXISTS `sortcode` varchar(10) DEFAULT NULL,
ADD COLUMN IF NOT EXISTS `accountnumber` varchar(10) DEFAULT NULL;

CREATE INDEX IF NOT EXISTS `idx_joint_accounts_admin` ON `lgmods_joint_accounts` (`admin_identifier`);
CREATE INDEX IF NOT EXISTS `idx_joint_members_account` ON `lgmods_joint_account_members` (`account_id`);
CREATE INDEX IF NOT EXISTS `idx_joint_members_identifier` ON `lgmods_joint_account_members` (`identifier`);
CREATE INDEX IF NOT EXISTS `idx_joint_invites_account` ON `lgmods_joint_account_invites` (`account_id`);
CREATE INDEX IF NOT EXISTS `idx_joint_invites_recipient` ON `lgmods_joint_account_invites` (`recipient_identifier`);