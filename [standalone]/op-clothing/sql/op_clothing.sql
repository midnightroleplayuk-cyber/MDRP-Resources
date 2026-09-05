-- ──────────────────────────────────────────────────────────────────────────────
--  OP Clothing — Database schema (oxmysql)
--  The resource creates database automatically on first start.
-- ──────────────────────────────────────────────────────────────────────────────

CREATE TABLE IF NOT EXISTS `op_clothing_outfits` (
    `id` INT NOT NULL AUTO_INCREMENT,
    `identifier` VARCHAR(64) NOT NULL,
    `name` VARCHAR(64) NOT NULL DEFAULT 'Outfit',
    `appearance` LONGTEXT,
    `created_at` TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    PRIMARY KEY (`id`),
    INDEX `idx_identifier` (`identifier`)
);

CREATE TABLE IF NOT EXISTS `op_clothing_custom_ped_permissions` (
    `identifier` VARCHAR(64) NOT NULL,
    `granted_at` TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    PRIMARY KEY (`identifier`)
);

CREATE TABLE IF NOT EXISTS `op_clothing_job_outfits` (
    `id` INT NOT NULL AUTO_INCREMENT,
    `locker_id` VARCHAR(64) NOT NULL,
    `job` VARCHAR(64) NOT NULL,
    `name` VARCHAR(64) NOT NULL DEFAULT 'Uniform',
    `appearance` LONGTEXT,
    `min_grade` INT NOT NULL DEFAULT 0,
    `manage_min_grade` INT NOT NULL DEFAULT 99,
    `sort_order` INT NOT NULL DEFAULT 0,
    `created_at` TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    PRIMARY KEY (`id`),
    INDEX `idx_locker` (`locker_id`),
    INDEX `idx_job` (`job`)
);
