-- vinewood_police 014_management: suspension from duty.
ALTER TABLE `vpo_officers`
    ADD COLUMN `suspended_at` INT UNSIGNED DEFAULT NULL,
    ADD COLUMN `suspended_reason` VARCHAR(255) DEFAULT NULL,
    ADD COLUMN `suspended_by` VARCHAR(120) DEFAULT NULL;
