-- vinewood_police 001_core: officers, qualifications, persistent player state, audit log.
-- Applied automatically on first start. Safe to run by hand (every statement is IF NOT EXISTS).

CREATE TABLE IF NOT EXISTS `vpo_officers` (
    `identifier`    VARCHAR(64)  NOT NULL,
    `display_name`  VARCHAR(100) DEFAULT NULL,
    `collar_number` VARCHAR(10)  DEFAULT NULL,
    `callsign`      VARCHAR(16)  DEFAULT NULL,
    `created_at`    INT UNSIGNED NOT NULL,
    `updated_at`    INT UNSIGNED NOT NULL,
    PRIMARY KEY (`identifier`),
    UNIQUE KEY `uq_vpo_officers_collar` (`collar_number`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

CREATE TABLE IF NOT EXISTS `vpo_qualifications` (
    `id`              INT UNSIGNED NOT NULL AUTO_INCREMENT,
    `identifier`      VARCHAR(64)  NOT NULL,
    `qualification`   VARCHAR(32)  NOT NULL,
    `granted_by`      VARCHAR(64)  DEFAULT NULL,
    `granted_by_name` VARCHAR(100) DEFAULT NULL,
    `granted_at`      INT UNSIGNED NOT NULL,
    `expires_at`      INT UNSIGNED DEFAULT NULL,
    `notes`           VARCHAR(255) DEFAULT NULL,
    `revoked_at`      INT UNSIGNED DEFAULT NULL,
    `revoked_by`      VARCHAR(100) DEFAULT NULL,
    `revoke_reason`   VARCHAR(255) DEFAULT NULL,
    PRIMARY KEY (`id`),
    KEY `idx_vpo_qual_officer` (`identifier`, `qualification`, `revoked_at`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

CREATE TABLE IF NOT EXISTS `vpo_player_state` (
    `identifier` VARCHAR(64)     NOT NULL,
    `state_key`  VARCHAR(32)     NOT NULL,
    `value`      TEXT            DEFAULT NULL,
    `seq`        BIGINT UNSIGNED NOT NULL DEFAULT 0,
    `updated_at` INT UNSIGNED    NOT NULL,
    PRIMARY KEY (`identifier`, `state_key`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

CREATE TABLE IF NOT EXISTS `vpo_audit` (
    `id`               BIGINT UNSIGNED NOT NULL AUTO_INCREMENT,
    `created_at`       INT UNSIGNED    NOT NULL,
    `action`           VARCHAR(64)     NOT NULL,
    `source`           VARCHAR(64)     NOT NULL,
    `actor_identifier` VARCHAR(64)     DEFAULT NULL,
    `actor_name`       VARCHAR(100)    DEFAULT NULL,
    `target_type`      VARCHAR(32)     DEFAULT NULL,
    `target_id`        VARCHAR(64)     DEFAULT NULL,
    `previous_value`   TEXT            DEFAULT NULL,
    `new_value`        TEXT            DEFAULT NULL,
    `reason`           VARCHAR(500)    DEFAULT NULL,
    `meta`             TEXT            DEFAULT NULL,
    PRIMARY KEY (`id`),
    KEY `idx_vpo_audit_time` (`created_at`),
    KEY `idx_vpo_audit_action` (`action`, `created_at`),
    KEY `idx_vpo_audit_actor` (`actor_identifier`, `created_at`),
    KEY `idx_vpo_audit_target` (`target_type`, `target_id`, `created_at`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;
