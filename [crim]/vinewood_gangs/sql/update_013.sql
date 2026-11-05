-- 13: racket shops added in game (/gangadmin > Rackets)
CREATE TABLE IF NOT EXISTS `vg_racket_shops` (
    `shop`       VARCHAR(48)  NOT NULL,
    `label`      VARCHAR(64)  NOT NULL,
    `income`     INT UNSIGNED NOT NULL DEFAULT 300,
    `x`          DECIMAL(9,2) NOT NULL,
    `y`          DECIMAL(9,2) NOT NULL,
    `z`          DECIMAL(9,2) NOT NULL,
    `created_by` VARCHAR(64)  NULL DEFAULT NULL,
    `created_at` TIMESTAMP    NOT NULL DEFAULT CURRENT_TIMESTAMP,
    PRIMARY KEY (`shop`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
