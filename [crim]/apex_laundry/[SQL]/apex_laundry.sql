-- ============================================================
-- Apex Laundry — database schema
-- ------------------------------------------------------------
-- The resource auto-creates this table on first boot (see
-- build/server/database.lua), so importing this file is optional.
-- It is provided for DBAs who prefer to provision tables manually.
-- ============================================================

CREATE TABLE IF NOT EXISTS `apex_laundry_machines` (
    `id`            VARCHAR(64) NOT NULL PRIMARY KEY,
    `cleaners`      INT         NOT NULL DEFAULT 0,
    `up_efficiency` TINYINT     NOT NULL DEFAULT 0,
    `up_potency`    TINYINT     NOT NULL DEFAULT 0,
    `progress`      TEXT        DEFAULT NULL,
    `updated_at`    TIMESTAMP   DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- Machines created live with /laundrycreator (admin placement tool).
CREATE TABLE IF NOT EXISTS `apex_laundry_placed` (
    `id`         INT AUTO_INCREMENT PRIMARY KEY,
    `label`      VARCHAR(80)  NOT NULL DEFAULT 'Laundromat',
    `model`      VARCHAR(64)  NOT NULL,
    `x`          FLOAT NOT NULL,
    `y`          FLOAT NOT NULL,
    `z`          FLOAT NOT NULL,
    `heading`    FLOAT NOT NULL DEFAULT 0,
    `invisible`  TINYINT(1)   NOT NULL DEFAULT 0,
    `created_at` TIMESTAMP    DEFAULT CURRENT_TIMESTAMP
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
