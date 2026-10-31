-- vinewood_police 013_standards: use of force forms and public complaints.

CREATE TABLE IF NOT EXISTS `vpo_uof` (
    `id`          INT UNSIGNED NOT NULL AUTO_INCREMENT,
    `identifier`  VARCHAR(64)  NOT NULL,
    `officer`     VARCHAR(120) DEFAULT NULL,
    `status`      VARCHAR(16)  NOT NULL DEFAULT 'pending',
    `trigger`     VARCHAR(64)  DEFAULT NULL,
    `subject`     VARCHAR(120) DEFAULT NULL,
    `linked_ref`  VARCHAR(32)  DEFAULT NULL,
    `tactics`     TEXT         DEFAULT NULL,
    `reasons`     TEXT         DEFAULT NULL,
    `subject_injured` TINYINT(1) DEFAULT NULL,
    `officer_injured` TINYINT(1) DEFAULT NULL,
    `narrative`   TEXT         DEFAULT NULL,
    `location`    VARCHAR(160) DEFAULT NULL,
    `created_at`  INT UNSIGNED NOT NULL,
    `submitted_at` INT UNSIGNED DEFAULT NULL,
    `reviewed_by` VARCHAR(120) DEFAULT NULL,
    `review_note` VARCHAR(500) DEFAULT NULL,
    `reviewed_at` INT UNSIGNED DEFAULT NULL,
    PRIMARY KEY (`id`),
    KEY `idx_vpo_uof_officer` (`identifier`, `status`),
    KEY `idx_vpo_uof_review` (`status`, `reviewed_at`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

CREATE TABLE IF NOT EXISTS `vpo_complaints` (
    `id`            INT UNSIGNED NOT NULL AUTO_INCREMENT,
    `ref`           VARCHAR(32)  DEFAULT NULL,
    `complainant`   VARCHAR(100) DEFAULT NULL,
    `complainant_identifier` VARCHAR(64) DEFAULT NULL,
    `officer_text`  VARCHAR(120) DEFAULT NULL,
    `officer_identifier` VARCHAR(64) DEFAULT NULL,
    `officer_name`  VARCHAR(120) DEFAULT NULL,
    `happened`      VARCHAR(120) DEFAULT NULL,
    `category`      VARCHAR(48)  DEFAULT NULL,
    `details`       TEXT         NOT NULL,
    `status`        VARCHAR(24)  NOT NULL DEFAULT 'Received',
    `investigator`  VARCHAR(120) DEFAULT NULL,
    `outcome`       VARCHAR(64)  DEFAULT NULL,
    `notes`         TEXT         DEFAULT NULL,
    `created_at`    INT UNSIGNED NOT NULL,
    `updated_at`    INT UNSIGNED NOT NULL,
    PRIMARY KEY (`id`),
    KEY `idx_vpo_complaints_status` (`status`),
    KEY `idx_vpo_complaints_officer` (`officer_identifier`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;
