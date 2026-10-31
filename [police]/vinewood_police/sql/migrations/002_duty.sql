-- vinewood_police 002_duty: duty sessions, pocket notebook, equipment issue log.

CREATE TABLE IF NOT EXISTS `vpo_duty_sessions` (
    `id`          INT UNSIGNED NOT NULL AUTO_INCREMENT,
    `identifier`  VARCHAR(64)  NOT NULL,
    `officer`     VARCHAR(120) DEFAULT NULL,
    `callsign`    VARCHAR(16)  DEFAULT NULL,
    `collar`      VARCHAR(10)  DEFAULT NULL,
    `unit`        VARCHAR(32)  DEFAULT NULL,
    `vehicle`     VARCHAR(24)  DEFAULT NULL,
    `station`     VARCHAR(32)  DEFAULT NULL,
    `started_at`  INT UNSIGNED NOT NULL,
    `ended_at`    INT UNSIGNED DEFAULT NULL,
    `end_reason`  VARCHAR(32)  DEFAULT NULL,
    `report`      TEXT         DEFAULT NULL,
    `stats`       TEXT         DEFAULT NULL,
    PRIMARY KEY (`id`),
    KEY `idx_vpo_duty_officer` (`identifier`, `started_at`),
    KEY `idx_vpo_duty_open` (`ended_at`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

CREATE TABLE IF NOT EXISTS `vpo_notebook` (
    `id`          INT UNSIGNED NOT NULL AUTO_INCREMENT,
    `identifier`  VARCHAR(64)  NOT NULL,
    `session_id`  INT UNSIGNED DEFAULT NULL,
    `created_at`  INT UNSIGNED NOT NULL,
    `text`        TEXT         NOT NULL,
    `ref`         VARCHAR(32)  DEFAULT NULL,
    `corrects_id` INT UNSIGNED DEFAULT NULL,
    PRIMARY KEY (`id`),
    KEY `idx_vpo_notebook_officer` (`identifier`, `id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

CREATE TABLE IF NOT EXISTS `vpo_equipment_issue` (
    `id`            INT UNSIGNED NOT NULL AUTO_INCREMENT,
    `identifier`    VARCHAR(64)  NOT NULL,
    `session_id`    INT UNSIGNED DEFAULT NULL,
    `item`          VARCHAR(64)  NOT NULL,
    `label`         VARCHAR(64)  DEFAULT NULL,
    `count`         INT UNSIGNED NOT NULL DEFAULT 1,
    `serial`        VARCHAR(32)  DEFAULT NULL,
    `issued_at`     INT UNSIGNED NOT NULL,
    `returned_at`   INT UNSIGNED DEFAULT NULL,
    `return_reason` VARCHAR(32)  DEFAULT NULL,
    PRIMARY KEY (`id`),
    KEY `idx_vpo_equipment_out` (`identifier`, `returned_at`),
    UNIQUE KEY `uq_vpo_equipment_serial` (`serial`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;
