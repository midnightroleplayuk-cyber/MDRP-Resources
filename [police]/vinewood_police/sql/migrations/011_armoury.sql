-- vinewood_police 011_armoury: rounds not handed back (discharges) for review.

CREATE TABLE IF NOT EXISTS `vpo_discharges` (
    `id`           INT UNSIGNED NOT NULL AUTO_INCREMENT,
    `identifier`   VARCHAR(64)  NOT NULL,
    `officer_name` VARCHAR(120) DEFAULT NULL,
    `session_id`   INT UNSIGNED DEFAULT NULL,
    `station`      VARCHAR(64)  DEFAULT NULL,
    `ammo`         VARCHAR(64)  NOT NULL,
    `label`        VARCHAR(64)  DEFAULT NULL,
    `rounds`       INT UNSIGNED NOT NULL,
    `account`      TEXT         DEFAULT NULL,
    `unaccounted`  TINYINT(1)   NOT NULL DEFAULT 0,
    `reviewed_by`  VARCHAR(120) DEFAULT NULL,
    `reviewed_at`  INT UNSIGNED DEFAULT NULL,
    `created_at`   INT UNSIGNED NOT NULL,
    PRIMARY KEY (`id`),
    KEY `idx_vpo_discharges_officer` (`identifier`, `created_at`),
    KEY `idx_vpo_discharges_review` (`reviewed_at`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;
