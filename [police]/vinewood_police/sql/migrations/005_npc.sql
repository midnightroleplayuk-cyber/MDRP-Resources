-- vinewood_police 005_npc: generated NPC people and vehicles.

CREATE TABLE IF NOT EXISTS `vpo_npc_people` (
    `id`          INT UNSIGNED NOT NULL AUTO_INCREMENT,
    `firstname`   VARCHAR(40)  NOT NULL,
    `lastname`    VARCHAR(40)  NOT NULL,
    `dob`         VARCHAR(10)  NOT NULL,
    `sex`         CHAR(1)      NOT NULL,
    `address`     VARCHAR(160) DEFAULT NULL,
    `licence`     VARCHAR(16)  NOT NULL,
    `points`      TINYINT UNSIGNED NOT NULL DEFAULT 0,
    `wanted`      VARCHAR(160) DEFAULT NULL,
    `prior_record` TINYINT(1)  NOT NULL DEFAULT 0,
    `traits`      TEXT         DEFAULT NULL,
    `keep`        TINYINT(1)   NOT NULL DEFAULT 0,
    `created_at`  INT UNSIGNED NOT NULL,
    `last_seen`   INT UNSIGNED NOT NULL,
    PRIMARY KEY (`id`),
    KEY `idx_vpo_npcp_name` (`lastname`, `firstname`, `dob`),
    KEY `idx_vpo_npcp_seen` (`keep`, `last_seen`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

CREATE TABLE IF NOT EXISTS `vpo_npc_vehicles` (
    `plate`       VARCHAR(12)  NOT NULL,
    `model`       VARCHAR(32)  DEFAULT NULL,
    `keeper_id`   INT UNSIGNED DEFAULT NULL,
    `keeper_type` VARCHAR(16)  NOT NULL,
    `keeper_name` VARCHAR(100) DEFAULT NULL,
    `driver_id`   INT UNSIGNED DEFAULT NULL,
    `insurance`   VARCHAR(16)  NOT NULL,
    `mot`         VARCHAR(16)  NOT NULL,
    `tax`         VARCHAR(16)  NOT NULL,
    `stolen`      TINYINT(1)   NOT NULL DEFAULT 0,
    `defect`      VARCHAR(80)  DEFAULT NULL,
    `keep`        TINYINT(1)   NOT NULL DEFAULT 0,
    `created_at`  INT UNSIGNED NOT NULL,
    `last_seen`   INT UNSIGNED NOT NULL,
    PRIMARY KEY (`plate`),
    KEY `idx_vpo_npcv_seen` (`keep`, `last_seen`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;
