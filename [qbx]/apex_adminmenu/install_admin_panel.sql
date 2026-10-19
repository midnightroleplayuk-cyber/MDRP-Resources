-- ============================================================
-- Apex Admin Panel — schema
-- Run once. Safe to re-run (uses IF NOT EXISTS everywhere).
-- ============================================================

-- ── Staff members (overrides Config.AdminPerms.UserGroups by license) ─
CREATE TABLE IF NOT EXISTS `apex_staff` (
    `license`      VARCHAR(64)  NOT NULL,
    `nickname`     VARCHAR(64)  NOT NULL DEFAULT '',
    `group_name`   VARCHAR(32)  NOT NULL DEFAULT 'mod',
    `avatar`       VARCHAR(255) NOT NULL DEFAULT '',
    `created_by`   VARCHAR(64)  NOT NULL DEFAULT 'system',
    `created_at`   TIMESTAMP    NOT NULL DEFAULT CURRENT_TIMESTAMP,
    PRIMARY KEY (`license`),
    KEY `idx_group` (`group_name`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- ── Staff groups (hierarchy + custom labels) ─────────────────────────
CREATE TABLE IF NOT EXISTS `apex_staff_groups` (
    `name`         VARCHAR(32)  NOT NULL,
    `label`        VARCHAR(64)  NOT NULL,
    `hierarchy`    INT          NOT NULL DEFAULT 99,
    `permissions`  TEXT         NULL,    -- JSON array of permission keys
    `color`        VARCHAR(16)  NOT NULL DEFAULT '#1F5EFF',
    PRIMARY KEY (`name`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

INSERT IGNORE INTO `apex_staff_groups` (`name`, `label`, `hierarchy`, `permissions`, `color`) VALUES
    ('owner',     'Owner',     0, '["*"]',                                             '#E5564B'),
    -- NOTE: "settings.*" is what lets this group save the server-wide
    -- Settings page, Discord webhook routes included. It is deliberately
    -- separate from "staff.read" (view the staff list) and "staff.*"
    -- (hire/fire staff) — an admin should be able to configure logging
    -- without also being able to promote themselves.
    ('admin',     'Admin',     1, '["players.*","moderation.*","vehicles.*","staff.read","settings.*","console.read","resources.*","utility.*","events.*","blips.*","chat.*","items.*","jobs.*","logs.read"]', '#1F5EFF'),
    -- "jobs.read" is listed here as well as being force-added by the v1.2
    -- migration in server/sqlinstall.lua. Leaving it out of the seed meant a
    -- brand-new install wrote a row that the very same start-up then had to
    -- patch — and the two lists silently disagreeing is how this table drifts
    -- from DEFAULT_GROUPS in server/staff.lua.
    ('moderator', 'Moderator', 2, '["players.read","players.teleport","players.revive","players.heal","moderation.warn","moderation.kick","moderation.ban","jobs.read","reports.*","chat.read","chat.write"]', '#4E9CE5'),
    ('helper',    'Helper',    3, '["players.read","jobs.read","reports.read","reports.assist","chat.read","chat.write"]', '#E5A93C');

-- ── Warnings ─────────────────────────────────────────────────────────
CREATE TABLE IF NOT EXISTS `apex_warnings` (
    `id`         INT AUTO_INCREMENT PRIMARY KEY,
    `target`     VARCHAR(64)  NOT NULL,    -- license of the warned player
    `player`     VARCHAR(80)  NOT NULL,    -- last known name
    `reason`     VARCHAR(255) NOT NULL,
    `admin`      VARCHAR(80)  NOT NULL,
    `admin_lic`  VARCHAR(64)  NOT NULL,
    `created_at` TIMESTAMP    NOT NULL DEFAULT CURRENT_TIMESTAMP,
    `expires_at` TIMESTAMP    NULL,
    KEY `idx_target` (`target`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- ── Jail sentences ───────────────────────────────────────────────────
CREATE TABLE IF NOT EXISTS `apex_jail` (
    `id`         INT AUTO_INCREMENT PRIMARY KEY,
    `target`     VARCHAR(64)  NOT NULL,
    `player`     VARCHAR(80)  NOT NULL,
    `reason`     VARCHAR(255) NOT NULL,
    `admin`      VARCHAR(80)  NOT NULL,
    `admin_lic`  VARCHAR(64)  NOT NULL,
    `minutes`    INT          NOT NULL,
    `created_at` TIMESTAMP    NOT NULL DEFAULT CURRENT_TIMESTAMP,
    `released`   TINYINT(1)   NOT NULL DEFAULT 0,
    KEY `idx_target` (`target`),
    KEY `idx_released` (`released`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- ── Staff action log (everything an admin does) ──────────────────────
CREATE TABLE IF NOT EXISTS `apex_staff_log` (
    `id`         BIGINT AUTO_INCREMENT PRIMARY KEY,
    `admin_lic`  VARCHAR(64)  NOT NULL,
    `admin`      VARCHAR(80)  NOT NULL,
    `category`   VARCHAR(32)  NOT NULL,   -- 'player','vehicle','money','utility','panel','quickmenu','report'
    `action`     VARCHAR(64)  NOT NULL,
    `target`     VARCHAR(80)  NULL,
    `target_lic` VARCHAR(64)  NULL,
    `details`    TEXT         NULL,        -- arbitrary text or JSON
    `created_at` TIMESTAMP    NOT NULL DEFAULT CURRENT_TIMESTAMP,
    KEY `idx_admin`     (`admin_lic`),
    KEY `idx_category`  (`category`),
    KEY `idx_created`   (`created_at`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- ── Custom blips ─────────────────────────────────────────────────────
CREATE TABLE IF NOT EXISTS `apex_blips` (
    `id`         INT AUTO_INCREMENT PRIMARY KEY,
    `label`      VARCHAR(64)  NOT NULL,
    `category`   VARCHAR(32)  NOT NULL DEFAULT 'Staff',
    `x`          FLOAT        NOT NULL,
    `y`          FLOAT        NOT NULL,
    `z`          FLOAT        NOT NULL,
    `sprite`     INT          NOT NULL DEFAULT 1,
    `color`      INT          NOT NULL DEFAULT 1,
    `scale`      FLOAT        NOT NULL DEFAULT 0.8,
    `display`    INT          NOT NULL DEFAULT 4,
    `short_range` TINYINT(1)  NOT NULL DEFAULT 1,
    `created_at` TIMESTAMP    NOT NULL DEFAULT CURRENT_TIMESTAMP
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- ── Events / staff schedule ─────────────────────────────────────────
CREATE TABLE IF NOT EXISTS `apex_events` (
    `id`         INT AUTO_INCREMENT PRIMARY KEY,
    `title`      VARCHAR(120) NOT NULL,
    `description` TEXT        NULL,
    `author`     VARCHAR(80)  NOT NULL,
    `author_lic` VARCHAR(64)  NOT NULL,
    `color`      VARCHAR(16)  NOT NULL DEFAULT '#E5A93C',
    `starts_at`  TIMESTAMP    NOT NULL,
    `created_at` TIMESTAMP    NOT NULL DEFAULT CURRENT_TIMESTAMP,
    KEY `idx_starts` (`starts_at`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- ── Staff chat (Staff + Reports channels) ───────────────────────────
CREATE TABLE IF NOT EXISTS `apex_staff_chat` (
    `id`         BIGINT AUTO_INCREMENT PRIMARY KEY,
    `channel`    VARCHAR(32)  NOT NULL DEFAULT 'staff',  -- 'staff' or arbitrary channel name
    `author`     VARCHAR(80)  NOT NULL,
    `author_lic` VARCHAR(64)  NOT NULL,
    `text`       TEXT         NOT NULL,
    `created_at` TIMESTAMP    NOT NULL DEFAULT CURRENT_TIMESTAMP,
    KEY `idx_channel` (`channel`, `created_at`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- ── Items catalogue (cached from ox_inventory or qb-core/Items) ─────
CREATE TABLE IF NOT EXISTS `apex_items_cache` (
    `name`     VARCHAR(64)  NOT NULL,
    `label`    VARCHAR(120) NOT NULL,
    `weight`   FLOAT        NOT NULL DEFAULT 0,
    `image`    VARCHAR(255) NULL,
    PRIMARY KEY (`name`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- ── Vehicles catalogue ──────────────────────────────────────────────
CREATE TABLE IF NOT EXISTS `apex_vehicles_cache` (
    `model`     VARCHAR(64)  NOT NULL,
    `label`     VARCHAR(120) NOT NULL,
    `class`     VARCHAR(64)  NULL,
    `image`     VARCHAR(255) NULL,
    PRIMARY KEY (`model`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- ── Settings per staff (personal panel prefs) ───────────────────────
CREATE TABLE IF NOT EXISTS `apex_staff_settings` (
    `license`  VARCHAR(64)  NOT NULL PRIMARY KEY,
    `data`     TEXT         NULL  -- arbitrary JSON
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- ── Steam avatars (cached) ──────────────────────────────────────────
-- `avatar`     = remote https URL returned by Steam (fragile — Steam's
--                CDN occasionally rotates / 429s us).
-- `avatar_b64` = the same image, downloaded once and stored locally as
--                a base64 data URI. The panel uses this column when
--                available, so the UI keeps working even if Steam goes
--                offline or the CDN moves the file.
CREATE TABLE IF NOT EXISTS `apex_steam_avatars` (
    `steam`      VARCHAR(64)  NOT NULL PRIMARY KEY,
    `avatar`     VARCHAR(512) NOT NULL,
    `avatar_b64` LONGTEXT     NULL,
    `cached_at`  TIMESTAMP    NOT NULL DEFAULT CURRENT_TIMESTAMP
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- ── Job overrides (for QBCore/QBox where jobs live in shared.lua) ───
-- ESX writes directly to `jobs` + `job_grades`; we don't need this
-- table for ESX. For QB / QBox we mirror every job created or edited
-- through the admin panel here so a restart can replay them back into
-- the framework's in-memory jobs table.
CREATE TABLE IF NOT EXISTS `apex_jobs_overrides` (
    `name`       VARCHAR(64)  NOT NULL PRIMARY KEY,
    `data`       LONGTEXT     NOT NULL,
    `updated_at` TIMESTAMP    NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- ── DM channels (private 1-to-1 chats) ──────────────────────────────
-- The channel name for a DM is "dm:<sorted-licA>:<sorted-licB>".
CREATE TABLE IF NOT EXISTS `apex_chat_channels` (
    `name`       VARCHAR(160) NOT NULL PRIMARY KEY,
    `kind`       VARCHAR(16)  NOT NULL DEFAULT 'channel', -- 'channel' or 'dm'
    `label`      VARCHAR(160) NOT NULL,
    `members`    TEXT         NULL,                       -- JSON array of licenses (DMs only)
    `created_at` TIMESTAMP    NOT NULL DEFAULT CURRENT_TIMESTAMP,
    KEY `idx_kind` (`kind`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

INSERT IGNORE INTO `apex_chat_channels` (`name`, `kind`, `label`) VALUES
    ('staff',   'channel', 'Staff'),
    ('reports', 'channel', 'Reports');

-- ── Playtime / last-seen / sessions ─────────────────────────────────
CREATE TABLE IF NOT EXISTS `apex_player_stats` (
    `license`     VARCHAR(64)  NOT NULL PRIMARY KEY,
    `last_name`   VARCHAR(80)  NOT NULL DEFAULT '',
    `playtime`    BIGINT       NOT NULL DEFAULT 0,
    `first_seen`  TIMESTAMP    NOT NULL DEFAULT CURRENT_TIMESTAMP,
    `last_seen`   TIMESTAMP    NULL,
    `last_login`  TIMESTAMP    NULL,
    `sessions`    INT          NOT NULL DEFAULT 0
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- ── Player flags (visible only to staff) ────────────────────────────
CREATE TABLE IF NOT EXISTS `apex_player_flags` (
    `license`    VARCHAR(64)  NOT NULL PRIMARY KEY,
    `flag`       VARCHAR(32)  NOT NULL,           -- 'suspicious', 'trusted', 'streamer', 'vip', 'custom'
    `note`       VARCHAR(255) NOT NULL DEFAULT '',
    `set_by`     VARCHAR(80)  NOT NULL DEFAULT '',
    `set_by_lic` VARCHAR(64)  NOT NULL DEFAULT '',
    `created_at` TIMESTAMP    NOT NULL DEFAULT CURRENT_TIMESTAMP
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- ── Global panel settings (admin-only) ──────────────────────────────
-- Key/value store for server-wide configuration that's editable
-- through the admin Settings page (Discord webhooks, log behaviour,
-- event rules, etc.). Plain TEXT lets us serialise JSON / scalars
-- equally — server-side code interprets per key.
CREATE TABLE IF NOT EXISTS `apex_panel_settings` (
    `k`          VARCHAR(64)  NOT NULL PRIMARY KEY,
    `v`          LONGTEXT     NULL,
    `updated_by` VARCHAR(80)  NOT NULL DEFAULT '',
    `updated_at` TIMESTAMP    NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- Reasonable defaults — kept as JSON so the panel can read them on
-- first open without a separate seed step. INSERT IGNORE leaves any
-- pre-existing operator value alone.
INSERT IGNORE INTO `apex_panel_settings` (`k`, `v`) VALUES
    ('discord.enabled',          'true'),
    ('discord.username',         '"Apex Admin"'),
    ('discord.avatar',           '""'),
    ('discord.webhooks',         '{}'),
    ('discord.log_events',       '{"moderation":true,"economy":true,"player":true,"vehicle":true,"staff":true,"console":true,"reports":true}'),
    ('events.blocked',           '[]'),
    ('events.hidden',            '[]'),
    ('events.custom_rules',      '[]'),
    ('panel.notify_position',    '"top-right"'),
    ('panel.notify_sound',       'true'),
    ('panel.auto_refresh_secs',  '15');

-- ── Per-staff keybinds (the rebindable shortcuts shown in Settings) ─
-- Stored in JSON so we can grow the list of actions without schema
-- migrations. The client reads this on bootstrap and rebinds via
-- RegisterKeyMapping on the fly.
CREATE TABLE IF NOT EXISTS `apex_staff_keybinds` (
    `license`    VARCHAR(64)  NOT NULL PRIMARY KEY,
    `data`       LONGTEXT     NOT NULL,           -- JSON: { action: { key, modifier? } }
    `updated_at` TIMESTAMP    NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- ── Captured FiveM events (server + client) ─────────────────────────
-- Every named event seen by the server is appended here so admins
-- can audit traffic, build custom dashboards, or set up rules that
-- mute / block specific events. The `payload` is a truncated
-- JSON snapshot of the arguments for forensic context.
CREATE TABLE IF NOT EXISTS `apex_event_logs` (
    `id`         BIGINT       NOT NULL AUTO_INCREMENT PRIMARY KEY,
    `event`      VARCHAR(160) NOT NULL,
    `source`     INT          NULL,
    `src_name`   VARCHAR(120) NULL,
    `src_lic`    VARCHAR(64)  NULL,
    `payload`    TEXT         NULL,
    `created_at` TIMESTAMP    NOT NULL DEFAULT CURRENT_TIMESTAMP,
    KEY `idx_event` (`event`),
    KEY `idx_created` (`created_at`),
    KEY `idx_src_lic` (`src_lic`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- ── Custom event rules (block / hide / log to discord) ──────────────
-- Operators can target an event name (or wildcard) and choose what
-- happens when it fires: drop it before any other handler runs, hide
-- from the Event Logs view, or push it to a specific Discord
-- webhook with a custom embed template.
CREATE TABLE IF NOT EXISTS `apex_event_rules` (
    `id`          INT          NOT NULL AUTO_INCREMENT PRIMARY KEY,
    `event`       VARCHAR(160) NOT NULL,           -- exact name or 'prefix:*' wildcard
    `action`      VARCHAR(16)  NOT NULL DEFAULT 'log', -- 'log' | 'block' | 'hide' | 'webhook'
    `webhook_key` VARCHAR(64)  NULL,               -- key from discord.webhooks when action='webhook'
    `template`    TEXT         NULL,               -- mustache-ish template for the embed body
    `enabled`     TINYINT(1)   NOT NULL DEFAULT 1,
    `created_by`  VARCHAR(80)  NOT NULL DEFAULT '',
    `created_at`  TIMESTAMP    NOT NULL DEFAULT CURRENT_TIMESTAMP,
    KEY `idx_event` (`event`),
    KEY `idx_action` (`action`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;
