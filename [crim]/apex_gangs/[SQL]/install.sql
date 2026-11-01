-- ============================================================
-- Apex Gangs — database schema
-- Tables are ALSO auto-created at runtime (server/database.lua); this
-- file is for manual installs / DB review. Safe to run repeatedly.
-- ============================================================

CREATE TABLE IF NOT EXISTS `apex_gangs_gangs` (
    `gang`        VARCHAR(64)  NOT NULL,
    `label`       VARCHAR(120) NULL,
    `color`       VARCHAR(16)  NULL,
    `logo`        VARCHAR(64)  NULL,
    `leader`      VARCHAR(64)  NULL,
    `level`       INT          NOT NULL DEFAULT 1,
    `xp`          BIGINT       NOT NULL DEFAULT 0,
    `max_members` INT          NOT NULL DEFAULT 12,
    `hq`          TEXT         NULL,
    `created_by`  VARCHAR(64)  NULL,
    `created_at`  BIGINT       NOT NULL,
    PRIMARY KEY (`gang`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

CREATE TABLE IF NOT EXISTS `apex_gangs_members` (
    `identifier`  VARCHAR(64)  NOT NULL,
    `gang`        VARCHAR(64)  NOT NULL,
    `grade`       INT          NOT NULL DEFAULT 0,
    `name`        VARCHAR(120) NULL,
    `joined_at`   BIGINT       NOT NULL,
    `invited_by`  VARCHAR(64)  NULL,
    `last_seen`   BIGINT       NOT NULL DEFAULT 0,
    PRIMARY KEY (`identifier`, `gang`),
    KEY `idx_gang` (`gang`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

CREATE TABLE IF NOT EXISTS `apex_gangs_ranks` (
    `gang`        VARCHAR(64) NOT NULL,
    `grade`       INT         NOT NULL,
    `label`       VARCHAR(64) NULL,
    `is_leader`   TINYINT     NOT NULL DEFAULT 0,
    `salary`      INT         NOT NULL DEFAULT 0,
    `permissions` TEXT        NULL,
    PRIMARY KEY (`gang`, `grade`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

CREATE TABLE IF NOT EXISTS `apex_gangs_zones` (
    `id`         VARCHAR(64)  NOT NULL,
    `gang`       VARCHAR(64)  NOT NULL,
    `kind`       VARCHAR(24)  NOT NULL DEFAULT 'hq',
    `label`      VARCHAR(120) NULL,
    `icon`       VARCHAR(32)  NULL,
    `x`          DOUBLE       NOT NULL,
    `y`          DOUBLE       NOT NULL,
    `z`          DOUBLE       NOT NULL,
    `heading`    DOUBLE       NOT NULL DEFAULT 0,
    `radius`     DOUBLE       NOT NULL DEFAULT 2.0,
    `blip`       TINYINT      NOT NULL DEFAULT 1,
    `created_by` VARCHAR(64)  NULL,
    `created_at` BIGINT       NOT NULL,
    PRIMARY KEY (`id`),
    KEY `idx_gang` (`gang`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

CREATE TABLE IF NOT EXISTS `apex_gangs_turf` (
    `id`          VARCHAR(64)  NOT NULL,
    `label`       VARCHAR(120) NULL,
    `owner`       VARCHAR(64)  NULL,
    `shape`       VARCHAR(12)  NOT NULL DEFAULT 'circle',
    `x`           DOUBLE       NOT NULL DEFAULT 0,
    `y`           DOUBLE       NOT NULL DEFAULT 0,
    `z`           DOUBLE       NOT NULL DEFAULT 0,
    `radius`      DOUBLE       NOT NULL DEFAULT 50.0,
    `points`      TEXT         NULL,
    `reward`      TEXT         NULL,
    `blip`        TINYINT      NOT NULL DEFAULT 1,
    `enabled`     TINYINT      NOT NULL DEFAULT 1,
    `captured_at` BIGINT       NOT NULL DEFAULT 0,
    `created_at`  BIGINT       NOT NULL,
    PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

CREATE TABLE IF NOT EXISTS `apex_gangs_graffiti` (
    `id`         INT          NOT NULL AUTO_INCREMENT,
    `gang`       VARCHAR(64)  NOT NULL,
    `x`          DOUBLE       NOT NULL,
    `y`          DOUBLE       NOT NULL,
    `z`          DOUBLE       NOT NULL,
    `rx`         DOUBLE       NOT NULL DEFAULT 0,
    `ry`         DOUBLE       NOT NULL DEFAULT 0,
    `rz`         DOUBLE       NOT NULL DEFAULT 0,
    `scale`      DOUBLE       NOT NULL DEFAULT 1.0,
    `text`       VARCHAR(32)  NULL,
    `font`       VARCHAR(32)  NULL,
    `image`      VARCHAR(48)  NULL,
    `url`        VARCHAR(255) NULL,
    `width`      INT          NULL,
    `height`     INT          NULL,
    `txd`        VARCHAR(48)  NULL,
    `tx`         VARCHAR(48)  NULL,
    `color`      VARCHAR(16)  NULL,
    `interior`   TINYINT      NOT NULL DEFAULT 0,
    `created_by` VARCHAR(64)  NULL,
    `created_at` BIGINT       NOT NULL,
    PRIMARY KEY (`id`),
    KEY `idx_gang` (`gang`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

CREATE TABLE IF NOT EXISTS `apex_gangs_treasury` (
    `gang`    VARCHAR(64) NOT NULL,
    `balance` BIGINT      NOT NULL DEFAULT 0,
    PRIMARY KEY (`gang`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

CREATE TABLE IF NOT EXISTS `apex_gangs_garage` (
    `id`        INT          NOT NULL AUTO_INCREMENT,
    `gang`      VARCHAR(64)  NOT NULL,
    `plate`     VARCHAR(16)  NOT NULL,
    `model`     VARCHAR(64)  NOT NULL,
    `label`     VARCHAR(64)  NULL,
    `props`     LONGTEXT     NULL,
    `stored`    TINYINT      NOT NULL DEFAULT 1,
    `added_by`  VARCHAR(64)  NULL,
    `added_at`  BIGINT       NOT NULL,
    PRIMARY KEY (`id`),
    UNIQUE KEY `uk_plate` (`plate`),
    KEY `idx_gang` (`gang`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

CREATE TABLE IF NOT EXISTS `apex_gangs_upgrades` (
    `gang`  VARCHAR(64) NOT NULL,
    `ukey`  VARCHAR(48) NOT NULL,
    `level` INT         NOT NULL DEFAULT 1,
    PRIMARY KEY (`gang`, `ukey`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

CREATE TABLE IF NOT EXISTS `apex_gangs_tasks` (
    `id`         INT          NOT NULL AUTO_INCREMENT,
    `gang`       VARCHAR(64)  NOT NULL,
    `task_key`   VARCHAR(48)  NOT NULL,
    `type`       VARCHAR(24)  NOT NULL,
    `name`       VARCHAR(120) NULL,
    `progress`   INT          NOT NULL DEFAULT 0,
    `objective`  INT          NOT NULL DEFAULT 1,
    `reward`     TEXT         NULL,
    `status`     VARCHAR(16)  NOT NULL DEFAULT 'active',
    `created_at` BIGINT       NOT NULL,
    `expires_at` BIGINT       NOT NULL DEFAULT 0,
    PRIMARY KEY (`id`),
    KEY `idx_gang_status` (`gang`, `status`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

CREATE TABLE IF NOT EXISTS `apex_gangs_ops` (
    `id`          INT          NOT NULL AUTO_INCREMENT,
    `gang`        VARCHAR(64)  NOT NULL,
    `target_gang` VARCHAR(64)  NULL,
    `type`        VARCHAR(16)  NOT NULL,
    `status`      VARCHAR(16)  NOT NULL DEFAULT 'pending',
    `result`      TEXT         NULL,
    `started_at`  BIGINT       NOT NULL,
    `ends_at`     BIGINT       NOT NULL DEFAULT 0,
    PRIMARY KEY (`id`),
    KEY `idx_gang_type` (`gang`, `type`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

CREATE TABLE IF NOT EXISTS `apex_gangs_invites` (
    `id`         INT          NOT NULL AUTO_INCREMENT,
    `gang`       VARCHAR(64)  NOT NULL,
    `identifier` VARCHAR(64)  NOT NULL,
    `grade`      INT          NOT NULL DEFAULT 0,
    `invited_by` VARCHAR(64)  NULL,
    `created_at` BIGINT       NOT NULL,
    PRIMARY KEY (`id`),
    UNIQUE KEY `uk_invite` (`gang`, `identifier`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

CREATE TABLE IF NOT EXISTS `apex_gangs_logs` (
    `id`         INT          NOT NULL AUTO_INCREMENT,
    `gang`       VARCHAR(64)  NOT NULL,
    `category`   VARCHAR(32)  NOT NULL,
    `action`     VARCHAR(64)  NOT NULL,
    `actor`      VARCHAR(120) NULL,
    `target`     VARCHAR(120) NULL,
    `amount`     BIGINT       NULL,
    `details`    TEXT         NULL,
    `created_at` BIGINT       NOT NULL,
    PRIMARY KEY (`id`),
    KEY `idx_gang_created` (`gang`, `created_at`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

CREATE TABLE IF NOT EXISTS `apex_gangs_theme` (
    `scope`      VARCHAR(64) NOT NULL,
    `brand`      VARCHAR(16) NULL,
    `bg`         VARCHAR(16) NULL,
    `updated_at` BIGINT      NOT NULL,
    PRIMARY KEY (`scope`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;
