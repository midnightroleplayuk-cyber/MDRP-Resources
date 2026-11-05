-- 12: contract spots added in game (/gangadmin > Contract spots)
CREATE TABLE IF NOT EXISTS `vg_contract_spots` (
    `id`         INT UNSIGNED NOT NULL AUTO_INCREMENT,
    `pool`       ENUM('general','vehicles','debtors') NOT NULL,
    `label`      VARCHAR(64)  NOT NULL,
    `x`          DECIMAL(9,2) NOT NULL,
    `y`          DECIMAL(9,2) NOT NULL,
    `z`          DECIMAL(9,2) NOT NULL,
    `w`          DECIMAL(6,2) NOT NULL DEFAULT 0,
    `created_by` VARCHAR(64)  NULL DEFAULT NULL,
    `created_at` TIMESTAMP    NOT NULL DEFAULT CURRENT_TIMESTAMP,
    PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
