-- vinewood_police 003_arrests: arrests and stop and search. When vinewood-mdt is running these
-- hold the MDT's reference too, so the custody suite (phase 3) can find the record either way.

CREATE TABLE IF NOT EXISTS `vpo_arrests` (
    `id`                 INT UNSIGNED NOT NULL AUTO_INCREMENT,
    `ref`                VARCHAR(32)  DEFAULT NULL,
    `identifier`         VARCHAR(64)  NOT NULL,
    `subject_name`       VARCHAR(100) DEFAULT NULL,
    `offences`           TEXT         NOT NULL,
    `grounds`            TEXT         NOT NULL,
    `necessity`          TEXT         DEFAULT NULL,
    `cautioned`          TINYINT(1)   NOT NULL DEFAULT 0,
    `incident_ref`       VARCHAR(32)  DEFAULT NULL,
    `mdt_record_id`      INT UNSIGNED DEFAULT NULL,
    `mdt_incident_id`    INT UNSIGNED DEFAULT NULL,
    `location`           VARCHAR(160) DEFAULT NULL,
    `coords`             VARCHAR(100) DEFAULT NULL,
    `officer_identifier` VARCHAR(64)  NOT NULL,
    `officer_name`       VARCHAR(120) DEFAULT NULL,
    `created_at`         INT UNSIGNED NOT NULL,
    `released_at`        INT UNSIGNED DEFAULT NULL,
    `release_reason`     VARCHAR(255) DEFAULT NULL,
    PRIMARY KEY (`id`),
    KEY `idx_vpo_arrests_person` (`identifier`, `created_at`),
    KEY `idx_vpo_arrests_ref` (`ref`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

CREATE TABLE IF NOT EXISTS `vpo_stop_search` (
    `id`                 INT UNSIGNED NOT NULL AUTO_INCREMENT,
    `ref`                VARCHAR(32)  DEFAULT NULL,
    `identifier`         VARCHAR(64)  DEFAULT NULL,
    `subject_name`       VARCHAR(100) DEFAULT NULL,
    `power`              VARCHAR(32)  NOT NULL,
    `authorisation`      VARCHAR(160) DEFAULT NULL,
    `object`             VARCHAR(64)  NOT NULL,
    `grounds`            TEXT         DEFAULT NULL,
    `found`              TEXT         DEFAULT NULL,
    `outcome`            VARCHAR(64)  NOT NULL,
    `location`           VARCHAR(160) DEFAULT NULL,
    `coords`             VARCHAR(100) DEFAULT NULL,
    `officer_identifier` VARCHAR(64)  NOT NULL,
    `officer_name`       VARCHAR(120) DEFAULT NULL,
    `created_at`         INT UNSIGNED NOT NULL,
    PRIMARY KEY (`id`),
    KEY `idx_vpo_ss_person` (`identifier`, `created_at`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;
