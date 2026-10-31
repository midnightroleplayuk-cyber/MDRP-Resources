-- vinewood_police 007_custody: custody suite detention and the custody log.

CREATE TABLE IF NOT EXISTS `vpo_custody` (
    `arrest_id`       INT UNSIGNED NOT NULL,
    `identifier`      VARCHAR(64)  NOT NULL,
    `subject_name`    VARCHAR(100) DEFAULT NULL,
    `suite`           VARCHAR(32)  DEFAULT NULL,
    `booked_at`       INT UNSIGNED DEFAULT NULL,
    `booked_by`       VARCHAR(120) DEFAULT NULL,
    `grounds`         VARCHAR(160) DEFAULT NULL,
    `risk`            VARCHAR(16)  DEFAULT NULL,
    `observation`     TINYINT UNSIGNED DEFAULT NULL,
    `property_stash`  VARCHAR(64)  DEFAULT NULL,
    `property_status` VARCHAR(16)  NOT NULL DEFAULT 'none',
    `released_at`     INT UNSIGNED DEFAULT NULL,
    `outcome`         VARCHAR(64)  DEFAULT NULL,
    PRIMARY KEY (`arrest_id`),
    KEY `idx_vpo_custody_person` (`identifier`, `property_status`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

CREATE TABLE IF NOT EXISTS `vpo_custody_log` (
    `id`          INT UNSIGNED NOT NULL AUTO_INCREMENT,
    `arrest_id`   INT UNSIGNED NOT NULL,
    `created_at`  INT UNSIGNED NOT NULL,
    `kind`        VARCHAR(24)  NOT NULL,
    `text`        TEXT         NOT NULL,
    `officer`     VARCHAR(120) DEFAULT NULL,
    PRIMARY KEY (`id`),
    KEY `idx_vpo_clog_arrest` (`arrest_id`, `id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;
