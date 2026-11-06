-- 18: hex territory, which rival hexes each gang has found, and the permission to expand
CREATE TABLE IF NOT EXISTS `vg_hexes` (
    `hex_key`    VARCHAR(24)   NOT NULL,
    `gang_id`    INT UNSIGNED  NOT NULL,
    `control`    DECIMAL(6,2)  NOT NULL DEFAULT 0,
    `is_main`    TINYINT(1)    NOT NULL DEFAULT 0,
    `compound`   TINYINT(1)    NOT NULL DEFAULT 0,
    `claimed_at` INT UNSIGNED  NOT NULL,
    PRIMARY KEY (`hex_key`),
    KEY `idx_hexes_gang` (`gang_id`),
    CONSTRAINT `fk_hexes_gang` FOREIGN KEY (`gang_id`) REFERENCES `vg_gangs` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

CREATE TABLE IF NOT EXISTS `vg_hex_reveals` (
    `gang_id`     INT UNSIGNED NOT NULL,
    `hex_key`     VARCHAR(24)  NOT NULL,
    `revealed_at` INT UNSIGNED NOT NULL,
    PRIMARY KEY (`gang_id`, `hex_key`),
    CONSTRAINT `fk_hex_reveals_gang` FOREIGN KEY (`gang_id`) REFERENCES `vg_gangs` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

UPDATE `vg_ranks`
SET `permissions` = REPLACE(`permissions`, '"diplomacy"', '"diplomacy","expand_turf"')
WHERE `permissions` LIKE '%"diplomacy"%' AND `permissions` NOT LIKE '%"expand_turf"%';
