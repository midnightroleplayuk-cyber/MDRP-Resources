-- 15: heists built in game, a log of every attempt, and the permission to start one
CREATE TABLE IF NOT EXISTS `vg_heists` (
    `id`         INT UNSIGNED NOT NULL AUTO_INCREMENT,
    `label`      VARCHAR(64)  NOT NULL,
    `kind`       VARCHAR(16)  NOT NULL DEFAULT 'custom',
    `enabled`    TINYINT(1)   NOT NULL DEFAULT 0,
    `data`       LONGTEXT     NOT NULL,
    `next_at`    INT UNSIGNED NOT NULL DEFAULT 0,
    `created_by` VARCHAR(64)  NULL DEFAULT NULL,
    `created_at` TIMESTAMP    NOT NULL DEFAULT CURRENT_TIMESTAMP,
    PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

CREATE TABLE IF NOT EXISTS `vg_heist_runs` (
    `id`         INT UNSIGNED NOT NULL AUTO_INCREMENT,
    `heist_id`   INT UNSIGNED NOT NULL,
    `gang_id`    INT UNSIGNED NOT NULL,
    `status`     ENUM('running','done','failed','cancelled') NOT NULL DEFAULT 'running',
    `loot`       INT UNSIGNED NOT NULL DEFAULT 0,
    `started_by` VARCHAR(64)  NULL DEFAULT NULL,
    `started_at` INT UNSIGNED NOT NULL,
    `ended_at`   INT UNSIGNED NULL DEFAULT NULL,
    PRIMARY KEY (`id`),
    KEY `idx_heist_runs_gang` (`gang_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

UPDATE `vg_ranks`
SET `permissions` = REPLACE(`permissions`, '"diplomacy"', '"diplomacy","heists"')
WHERE `permissions` LIKE '%"diplomacy"%' AND `permissions` NOT LIKE '%"heists"%';
