-- vinewood_police 012_incidents_cid: major incidents (cordons, scene log) and CID case files.

CREATE TABLE IF NOT EXISTS `vpo_incidents` (
    `id`          INT UNSIGNED NOT NULL AUTO_INCREMENT,
    `ref`         VARCHAR(32)  DEFAULT NULL,
    `type`        VARCHAR(48)  NOT NULL,
    `label`       VARCHAR(120) NOT NULL,
    `coords`      VARCHAR(100) NOT NULL,
    `inner_r`     SMALLINT UNSIGNED NOT NULL,
    `outer_r`     SMALLINT UNSIGNED NOT NULL,
    `status`      VARCHAR(16)  NOT NULL DEFAULT 'active',
    `linked`      VARCHAR(160) DEFAULT NULL,
    `roles`       TEXT         DEFAULT NULL,
    `declared_by` VARCHAR(120) DEFAULT NULL,
    `summary`     TEXT         DEFAULT NULL,
    `created_at`  INT UNSIGNED NOT NULL,
    `closed_at`   INT UNSIGNED DEFAULT NULL,
    PRIMARY KEY (`id`),
    KEY `idx_vpo_incidents_status` (`status`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

CREATE TABLE IF NOT EXISTS `vpo_incident_log` (
    `id`          INT UNSIGNED NOT NULL AUTO_INCREMENT,
    `incident_id` INT UNSIGNED NOT NULL,
    `created_at`  INT UNSIGNED NOT NULL,
    `kind`        VARCHAR(24)  NOT NULL,
    `text`        TEXT         NOT NULL,
    `officer`     VARCHAR(120) DEFAULT NULL,
    PRIMARY KEY (`id`),
    KEY `idx_vpo_ilog` (`incident_id`, `id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

CREATE TABLE IF NOT EXISTS `vpo_cases` (
    `id`             INT UNSIGNED NOT NULL AUTO_INCREMENT,
    `ref`            VARCHAR(32)  DEFAULT NULL,
    `title`          VARCHAR(160) NOT NULL,
    `type`           VARCHAR(48)  DEFAULT NULL,
    `status`         VARCHAR(32)  NOT NULL DEFAULT 'Open',
    `oic_identifier` VARCHAR(64)  DEFAULT NULL,
    `oic_name`       VARCHAR(120) DEFAULT NULL,
    `summary`        TEXT         DEFAULT NULL,
    `links`          TEXT         DEFAULT NULL,
    `people`         TEXT         DEFAULT NULL,
    `created_by`     VARCHAR(120) DEFAULT NULL,
    `created_at`     INT UNSIGNED NOT NULL,
    `updated_at`     INT UNSIGNED NOT NULL,
    `closed_at`      INT UNSIGNED DEFAULT NULL,
    PRIMARY KEY (`id`),
    KEY `idx_vpo_cases_status` (`status`, `updated_at`),
    KEY `idx_vpo_cases_oic` (`oic_identifier`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

CREATE TABLE IF NOT EXISTS `vpo_case_entries` (
    `id`          INT UNSIGNED NOT NULL AUTO_INCREMENT,
    `case_id`     INT UNSIGNED NOT NULL,
    `kind`        VARCHAR(16)  NOT NULL,
    `text`        TEXT         NOT NULL,
    `officer`     VARCHAR(120) DEFAULT NULL,
    `assigned_identifier` VARCHAR(64) DEFAULT NULL,
    `assigned_name` VARCHAR(120) DEFAULT NULL,
    `done_at`     INT UNSIGNED DEFAULT NULL,
    `done_by`     VARCHAR(120) DEFAULT NULL,
    `created_at`  INT UNSIGNED NOT NULL,
    PRIMARY KEY (`id`),
    KEY `idx_vpo_case_entries` (`case_id`, `kind`, `id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;
