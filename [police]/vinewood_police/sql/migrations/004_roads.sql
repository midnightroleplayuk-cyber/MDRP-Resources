-- vinewood_police 004_roads: vehicle stops.

CREATE TABLE IF NOT EXISTS `vpo_traffic_stops` (
    `id`                 INT UNSIGNED NOT NULL AUTO_INCREMENT,
    `ref`                VARCHAR(32)  DEFAULT NULL,
    `plate`              VARCHAR(12)  NOT NULL,
    `model`              VARCHAR(64)  DEFAULT NULL,
    `driver_identifier`  VARCHAR(64)  DEFAULT NULL,
    `driver_name`        VARCHAR(100) DEFAULT NULL,
    `npc`                TINYINT(1)   NOT NULL DEFAULT 0,
    `reason`             VARCHAR(64)  DEFAULT NULL,
    `outcome`            VARCHAR(64)  DEFAULT NULL,
    `notes`              TEXT         DEFAULT NULL,
    `checks`             TEXT         DEFAULT NULL,
    `tickets`            TEXT         DEFAULT NULL,
    `location`           VARCHAR(160) DEFAULT NULL,
    `coords`             VARCHAR(100) DEFAULT NULL,
    `officer_identifier` VARCHAR(64)  NOT NULL,
    `officer_name`       VARCHAR(120) DEFAULT NULL,
    `started_at`         INT UNSIGNED NOT NULL,
    `ended_at`           INT UNSIGNED DEFAULT NULL,
    PRIMARY KEY (`id`),
    KEY `idx_vpo_ts_plate` (`plate`, `started_at`),
    KEY `idx_vpo_ts_driver` (`driver_identifier`, `started_at`),
    KEY `idx_vpo_ts_officer` (`officer_identifier`, `started_at`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;
