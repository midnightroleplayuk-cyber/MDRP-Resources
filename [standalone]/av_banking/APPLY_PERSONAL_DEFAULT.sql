-- Execute once against your existing live banking database.
ALTER TABLE `av_banking_accounts` MODIFY COLUMN `label` VARCHAR(60) NOT NULL DEFAULT 'Personal';
DROP TRIGGER IF EXISTS `av_banking_default_personal_label`;
DELIMITER $$
CREATE TRIGGER `av_banking_default_personal_label`
BEFORE INSERT ON `av_banking_accounts`
FOR EACH ROW
BEGIN
  IF LOWER(NEW.`type`) = 'personal'
     AND (NEW.`label` IS NULL OR TRIM(NEW.`label`) = ''
          OR LOWER(TRIM(NEW.`label`)) = 'checking') THEN
    SET NEW.`label` = 'Personal';
  END IF;
END$$
DELIMITER ;
