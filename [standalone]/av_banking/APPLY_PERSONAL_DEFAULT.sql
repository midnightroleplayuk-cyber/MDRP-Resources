-- Run against the database actually used by your FiveM server.
-- Converts only untouched default labels, never custom names.
ALTER TABLE `av_banking_accounts` MODIFY COLUMN `label` VARCHAR(60) NOT NULL DEFAULT 'PERSONAL';
UPDATE `av_banking_accounts` SET `label`='PERSONAL'
WHERE LOWER(TRIM(`label`))='checking' AND LOWER(TRIM(`type`))='personal';
DROP TRIGGER IF EXISTS `av_banking_default_personal_label`;
DROP TRIGGER IF EXISTS `av_banking_personal_label_update`;
DELIMITER $$
CREATE TRIGGER `av_banking_default_personal_label` BEFORE INSERT ON `av_banking_accounts`
FOR EACH ROW BEGIN
 IF LOWER(TRIM(COALESCE(NEW.`type`,'')))='personal'
 AND LOWER(TRIM(COALESCE(NEW.`label`,''))) IN ('','checking','bank account - personal')
 THEN SET NEW.`label`='PERSONAL'; END IF;
END$$
CREATE TRIGGER `av_banking_personal_label_update` BEFORE UPDATE ON `av_banking_accounts`
FOR EACH ROW BEGIN
 IF LOWER(TRIM(COALESCE(NEW.`type`,'')))='personal'
 AND LOWER(TRIM(COALESCE(NEW.`label`,'')))='checking'
 THEN SET NEW.`label`='PERSONAL'; END IF;
END$$
DELIMITER ;
-- Check results:
SELECT `id`,`type`,`label`,`native` FROM `av_banking_accounts` ORDER BY `id` DESC LIMIT 20;
SHOW TRIGGERS LIKE 'av_banking_accounts';
