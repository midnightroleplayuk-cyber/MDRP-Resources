-- RUN THIS ON YOUR LIVE DATABASE IN HEIDISQL / PHPMYADMIN.
-- It fixes NEW personal accounts, including when escrowed code explicitly inserts Checking.
ALTER TABLE `av_banking_accounts` MODIFY COLUMN `label` VARCHAR(60) NOT NULL DEFAULT 'PERSONAL';
DROP TRIGGER IF EXISTS `av_banking_default_personal_label`;
DELIMITER $$
CREATE TRIGGER `av_banking_default_personal_label`
BEFORE INSERT ON `av_banking_accounts`
FOR EACH ROW
BEGIN
  IF LOWER(TRIM(COALESCE(NEW.`type`, ''))) = 'personal'
     AND LOWER(TRIM(COALESCE(NEW.`label`, ''))) IN ('', 'checking', 'bank account - personal', 'personal') THEN
    SET NEW.`label` = 'PERSONAL';
  END IF;
END$$
DELIMITER ;
-- OPTIONAL: convert ONLY existing personal accounts still called Checking:
-- UPDATE `av_banking_accounts` SET `label` = 'PERSONAL' WHERE LOWER(TRIM(`type`)) = 'personal' AND LOWER(TRIM(`label`)) = 'checking';
