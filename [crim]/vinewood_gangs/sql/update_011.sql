-- 11: money laundering batches
CREATE TABLE IF NOT EXISTS `vg_laundering` (
    `id`         INT UNSIGNED NOT NULL AUTO_INCREMENT,
    `gang_id`    INT UNSIGNED NOT NULL,
    `method`     VARCHAR(16)  NOT NULL,
    `amount_in`  INT UNSIGNED NOT NULL,
    `amount_out` INT UNSIGNED NOT NULL,
    `ready_at`   INT UNSIGNED NOT NULL,
    `status`     ENUM('washing','done','cancelled') NOT NULL DEFAULT 'washing',
    `citizenid`  VARCHAR(64)  NULL DEFAULT NULL,
    `created_at` INT UNSIGNED NOT NULL,
    PRIMARY KEY (`id`),
    KEY `idx_launder_gang` (`gang_id`, `status`),
    CONSTRAINT `fk_launder_gang` FOREIGN KEY (`gang_id`) REFERENCES `vg_gangs` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
