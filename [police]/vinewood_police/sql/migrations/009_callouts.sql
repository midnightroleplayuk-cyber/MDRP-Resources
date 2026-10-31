-- vinewood_police 009_callouts: calls created by the callout engine.

CREATE TABLE IF NOT EXISTS `vpo_callouts` (
    `id`            INT UNSIGNED NOT NULL AUTO_INCREMENT,
    `ref`           VARCHAR(32)  DEFAULT NULL,
    `scenario`      VARCHAR(32)  NOT NULL,
    `title`         VARCHAR(120) NOT NULL,
    `location`      VARCHAR(160) DEFAULT NULL,
    `coords`        VARCHAR(100) DEFAULT NULL,
    `priority`      TINYINT UNSIGNED NOT NULL DEFAULT 3,
    `status`        VARCHAR(16)  NOT NULL DEFAULT 'pending',
    `outcome`       VARCHAR(64)  DEFAULT NULL,
    `notes`         TEXT         DEFAULT NULL,
    `officers`      TEXT         DEFAULT NULL,
    `mdt_incident`  VARCHAR(32)  DEFAULT NULL,
    `created_at`    INT UNSIGNED NOT NULL,
    `attended_at`   INT UNSIGNED DEFAULT NULL,
    `closed_at`     INT UNSIGNED DEFAULT NULL,
    PRIMARY KEY (`id`),
    KEY `idx_vpo_callouts_status` (`status`, `created_at`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;
