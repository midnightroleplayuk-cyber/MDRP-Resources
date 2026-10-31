-- vinewood_police 006_roadside: vehicle seizures.

CREATE TABLE IF NOT EXISTS `vpo_vehicle_seizures` (
    `id`                 INT UNSIGNED NOT NULL AUTO_INCREMENT,
    `ref`                VARCHAR(32)  DEFAULT NULL,
    `stop_id`            INT UNSIGNED DEFAULT NULL,
    `plate`              VARCHAR(12)  NOT NULL,
    `model`              VARCHAR(64)  DEFAULT NULL,
    `npc`                TINYINT(1)   NOT NULL DEFAULT 0,
    `power`              VARCHAR(16)  NOT NULL,
    `reason`             TEXT         NOT NULL,
    `driver_name`        VARCHAR(100) DEFAULT NULL,
    `location`           VARCHAR(160) DEFAULT NULL,
    `officer_identifier` VARCHAR(64)  NOT NULL,
    `officer_name`       VARCHAR(120) DEFAULT NULL,
    `status`             VARCHAR(24)  NOT NULL DEFAULT 'awaiting_recovery',
    `created_at`         INT UNSIGNED NOT NULL,
    `recovered_at`       INT UNSIGNED DEFAULT NULL,
    PRIMARY KEY (`id`),
    KEY `idx_vpo_seiz_plate` (`plate`, `created_at`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;
